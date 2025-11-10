class LordOfWar::Store::JsonStore
  def initialize(*files)
    data = files.flat_map do |file|
      File.readlines(file).flat_map { |line| JSON.parse line }
    end

    @products = data.map { |p| LordOfWar::Product.parse_json p }
    @favs = JSON.parse File.read('./data/favs.json')
  end

  def get_products(filters, pagination)
    results = @products.select do |p|
      p.price_amount.between?(filters.min_price, filters.max_price) &&
        (filters.categories_empty? || filters.category?(p.category)) &&
        (filters.search_empty? || p.search_corpus.include?(filters.search))
    end

    first_idx, last_idx = pagination.results_range
    paginated_results = results[first_idx...last_idx] || []

    if paginated_results.empty?
      pagination.page = 0
    else
      pagination.total_records = results.size
    end

    paginated_results
  end

  def find_product(id)
    @products.find { |p| p.id == id }
  end

  def toggle_fav(product_id, username)
    new_status_is_active = if favs_by_username(username).key? product_id
                             @favs[username].delete product_id
                             false
                           else
                             @favs[username].push product_id
                             true
                           end

    File.write './data/favs.json', @favs.to_json

    new_status_is_active
  end

  def get_favs_for(products, username)
    favs_by_user = favs_by_username username
    products.select { |p| favs_by_user.key? p.id }.each_with_object({}) { |p, acc| acc[p.id] = true }
  end

  private

  def favs_by_username(username)
    @favs.fetch(username, []).each_with_object({}) { |pid, acc| acc[pid] = true }
  end
end
