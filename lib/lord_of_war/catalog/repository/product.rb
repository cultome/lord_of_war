class LordOfWar::Catalog::Repository::Product
  def get_products(filters, pagination)
    clauses = ['p.price >= $1', 'p.price <= $2']
    params = [filters.min_price, filters.max_price]
    ph_idx = 3

    unless filters.search_empty?
      clauses << "p.search_corpus LIKE $#{ph_idx}"
      params << "%#{filters.search}%"
      ph_idx += 1
    end

    unless filters.categories_empty?
      ph = filters.categories.map.with_index { |_, idx| "$#{idx + ph_idx}" }.join(',')
      clauses << "p.category_id IN (#{ph})"
      filters.categories.each { |cat| params << cat }
      ph_idx += filters.categories.size
    end

    first_idx, = pagination.results_range

    favs_join = "JOIN favs f ON f.product_id = p.id AND f.user_id = '#{filters.user_id}'"

    query = <<~SQL
      SELECT p.*
      FROM products p
      #{favs_join if filters.favs_only?}
      WHERE
      #{clauses.join " AND "}
      LIMIT $#{ph_idx}
      OFFSET $#{ph_idx + 1}
    SQL

    prods = DB
            .execute(query, params + [pagination.page_size, first_idx])
            .map { |rec| LordOfWar::Catalog::Entity::Product.parse_json rec }

    if prods.empty?
      pagination.page = 0
    else
      load_product_relations prods

      # calculate pagination
      query = <<~SQL
        SELECT count(*) AS total
        FROM products p
        #{favs_join if filters.favs_only?}
        WHERE
        #{clauses.join " AND "}
      SQL
      total_results = DB.execute(query, params).map { |rec| rec['total'] }.first

      pagination.total_records = total_results
    end

    prods
  end

  def find_product(id)
    DB
      .execute('SELECT * FROM products WHERE id = $1', [id])
      .map { |rec| LordOfWar::Catalog::Entity::Product.parse_json rec }
      .first
  end

  def categories_catalog
    DB.execute('SELECT id, name FROM categories').each_with_object({}) { |rec, acc| acc[rec['name']] = rec['id'] }
  end

  private

  def load_product_relations(products)
    product_ids = products.map(&:id)

    batteries = products_batteries product_ids
    firing_modes = products_firing_modes product_ids
    imgs = products_imgs product_ids
    licenses = products_licenses product_ids
    makers = products_makers product_ids
    types = products_types product_ids

    products.each do |p|
      p.batteries = batteries[p.id]
      p.firing_modes = firing_modes[p.id]
      p.imgs = imgs[p.id]
      p.licenses = licenses[p.id]
      p.makers = makers[p.id]
      p.types = types[p.id]
    end
  end

  private

  def products_relation(product_ids, plural, singular)
    phs = product_ids.map.with_index { |_, idx| "$#{idx + 1}" }.join(',')
    DB
      .execute("SELECT a.product_id, b.name FROM products_#{plural} a JOIN #{plural} b ON b.id == a.#{singular}_id WHERE a.product_id IN (#{phs})", product_ids)
      .each_with_object(Hash.new { |h, k| h[k] = [] }) { |rec, acc| acc[rec['product_id']] << rec['name'] }
  end

  def products_batteries(product_ids)
    products_relation product_ids, 'batteries', 'battery'
  end

  def products_firing_modes(product_ids)
    products_relation product_ids, 'firing_modes', 'firing_mode'
  end

  def products_imgs(product_ids)
    products_relation product_ids, 'imgs', 'img'
  end

  def products_licenses(product_ids)
    products_relation product_ids, 'licenses', 'license'
  end

  def products_makers(product_ids)
    products_relation product_ids, 'makers', 'maker'
  end

  def products_types(product_ids)
    products_relation product_ids, 'types', 'type'
  end
end
