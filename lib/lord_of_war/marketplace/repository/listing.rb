class LordOfWar::Marketplace::Repository::Listing
  def create_listing(listing, user_id)
    query = <<~SQL
      INSERT INTO listings(id, title, desc, price, search_corpus, category_id, created_by, created_at)
      VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
      RETURNING id
    SQL

    params = [
      SecureRandom.uuid,
      listing.title,
      listing.desc,
      listing.price_amount,
      listing.search_corpus,
      listing.category_id,
      user_id,
      Time.now.iso8601,
    ]

    new_listing_id = DB.execute(query, params).map { |rec| rec['id'] }.first

    return new_listing_id if listing.imgs.blank?

    listing.imgs.each do |img|
      query = 'INSERT INTO imgs(id, name) VALUES ($1, $2) RETURNING id'
      new_img_id = DB.execute(query, [SecureRandom.uuid, img]).map { |rec| rec['id'] }.first

      query = 'INSERT INTO listings_imgs(listing_id, img_id) VALUES ($1, $2)'
      DB.execute query, [new_listing_id, new_img_id]
    end
  end

  def delete_listing!(id, user_id)
    DB.execute(
      'DELETE FROM listings WHERE id = $1 AND created_by = $2 RETURNING id',
      [id, user_id]
    ).map { |rec| rec['id'] }.first.present?
  end

  def find_listing(id)
    query = <<~SQL
      SELECT
        l.*,
        c.label_es AS category
      FROM listings l
      JOIN categories c ON c.id = l.category_id
      WHERE l.id = $1
    SQL

    listings = DB
               .execute(query, [id])
               .map { |rec| LordOfWar::Marketplace::Entity::Listing.parse_json rec }

    load_listing_relations listings

    listings.first
  end

  def get_listings(filters, pagination)
    clauses = ['l.price >= $1', 'l.price <= $2']
    params = [filters.min_price, filters.max_price]
    ph_idx = 3

    unless filters.search_empty?
      clauses << "l.search_corpus LIKE $#{ph_idx}"
      params << "%#{filters.search}%"
      ph_idx += 1
    end

    unless filters.categories_empty?
      ph = filters.categories.map.with_index { |_, idx| "$#{idx + ph_idx}" }.join(',')
      clauses << "l.category_id IN (#{ph})"
      filters.categories.each { |cat| params << cat }
      ph_idx += filters.categories.size
    end

    first_idx, = pagination.results_range

    query = <<~SQL
      SELECT
        l.*,
        c.name AS category
      FROM listings l
      JOIN categories c ON c.id = l.category_id
      WHERE
      #{clauses.join " AND "}
      LIMIT $#{ph_idx}
      OFFSET $#{ph_idx + 1}
    SQL

    listings = DB
               .execute(query, params + [pagination.page_size, first_idx])
               .map { |rec| LordOfWar::Marketplace::Entity::Listing.parse_json rec }

    if listings.empty?
      pagination.page = 0
    else
      load_listing_relations listings

      # calculate pagination
      query = <<~SQL
        SELECT count(*) AS total
        FROM listings l
        WHERE
        #{clauses.join " AND "}
      SQL
      total_results = DB.execute(query, params).map { |rec| rec['total'] }.first

      pagination.total_records = total_results
    end

    listings
  end

  private

  def load_listing_relations(listings)
    listing_ids = listings.map(&:id)
    imgs = listings_imgs listing_ids
    listings.each do |l|
      l.imgs = imgs[l.id]
    end
  end

  def listings_relation(listings_ids, plural, singular)
    phs = listings_ids.map.with_index { |_, idx| "$#{idx + 1}" }.join(',')
    DB
      .execute("SELECT a.listing_id, b.name FROM listings_#{plural} a JOIN #{plural} b ON b.id == a.#{singular}_id WHERE a.listing_id IN (#{phs})", listings_ids)
      .each_with_object(Hash.new { |h, k| h[k] = [] }) { |rec, acc| acc[rec['listing_id']] << rec['name'] }
  end

  def listings_imgs(listings_ids)
    listings_relation listings_ids, 'imgs', 'img'
  end
end
