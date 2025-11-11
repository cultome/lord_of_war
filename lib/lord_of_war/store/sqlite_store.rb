class LordOfWar::Store::SqliteStore
  def initialize(db_file)
    @db = SQLite3::Database.new db_file
    @db.results_as_hash = true
  end

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

    prods = @db
            .execute(query, params + [pagination.page_size, first_idx])
            .map { |rec| LordOfWar::Product.parse_json rec }

    if prods.empty?
      pagination.page = 0
    else
      load_relations prods

      # calculate pagination
      query = "SELECT count(*) as total FROM products p WHERE #{clauses.join " AND "}"
      total_results = @db.execute(query, params).map { |rec| rec['total'] }.first

      pagination.total_records = total_results
    end

    prods
  end

  def find_product(id)
    @db
      .execute('SELECT * FROM products WHERE id = $1', [id])
      .map { |rec| LordOfWar::Product.parse_json rec }
      .first
  end

  def toggle_fav(product_id, user_id)
    existing_record = @db
                      .execute('SELECT product_id FROM favs WHERE product_id = $1 AND user_id = $2', [product_id, user_id])
                      .map { |rec| rec['product_id'] }
                      .first

    if existing_record.nil?
      @db.execute 'INSERT INTO favs(product_id, user_id) VALUES ($1, $2)', [product_id, user_id]
    else
      remove_fav product_id, user_id
    end
  end

  def remove_fav(product_id, user_id)
    @db.execute 'DELETE FROM favs WHERE product_id = $1 AND user_id = $2)', [product_id, user_id]
  end

  def get_favs(user_id)
    @db
      .execute('SELECT p.* FROM products p JOIN favs f ON f.product_id = p.id AND f.user_id = $1', [user_id])
      .map { |rec| LordOfWar::Product.parse_json rec }
  end

  def filter_by_favs(products, user_id)
    prod_ids = products.map(&:id)
    ph = products.map.with_index { |_, idx| "$#{idx + 2}" }.join(',')

    @db
      .execute("SELECT p.product_id FROM favs p WHERE p.user_id = $1 AND p.product_id IN (#{ph})", [user_id, *prod_ids])
      .each_with_object({}) { |rec, acc| acc[rec['product_id']] = true }
  end

  def categories_catalog
    @db.execute('SELECT id, name FROM categories').each_with_object({}) { |rec, acc| acc[rec['name']] = rec['id'] }
  end

  def find_user(user_id)
    @db
      .execute('SELECT * FROM users where id = $1', [user_id])
      .map { |rec| LordOfWar::User.parse_json rec }
      .first
  end

  def find_user_by_email(email)
    @db
      .execute('SELECT * FROM users where email = $1', [email])
      .map { |rec| LordOfWar::User.parse_json rec }
      .first
  end

  def username_exists?(username)
    @db
      .execute('SELECT id FROM users where username like $1', [username])
      .map { |rec| rec['id'] }
      .first
      .present?
  end

  def update_password!(user_id, password)
    @db
      .execute('UPDATE users SET password = $1 WHERE id = $2 RETURNING id', [password, user_id])
      .map { |rec| rec['id'] }
      .first
      .present?
  end

  def update_username!(user_id, username)
    @db
      .execute('UPDATE users SET username = $1 WHERE id = $2 RETURNING id', [username, user_id])
      .map { |rec| rec['id'] }
      .first
      .present?
  end

  private

  def load_relations(products)
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

  def products_relation(product_ids, plural, singular)
    phs = product_ids.map.with_index { |_, idx| "$#{idx + 1}" }.join(',')
    @db
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
