class LordOfWar::Store::JsonStore
  def initialize(*files)
    data = files.flat_map do |file|
      File.readlines(file).flat_map { |line| JSON.parse line }
    end

    @products = data.map { |p| LordOfWar::Product.parse_json p }
  end

  def get_products(filters, pagination)
    results = @products.select do |p|
      p.price_amount >= filters.min_price &&
        p.price_amount <= filters.max_price &&
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
end
