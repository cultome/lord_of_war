class LordOfWar::Store::JsonStore
  def initialize(*files)
    data = files.flat_map do |file|
      File.readlines(file).flat_map { |line| JSON.parse line }
    end

    @products = data.map { |p| LordOfWar::Product.parse_json p }
  end

  def get_products(filters)
    @products.select do |p|
      p.price_amount >= filters.min_price &&
        p.price_amount <= filters.max_price &&
        (filters.categories_empty? || filters.category?(p.category)) &&
        (filters.search_empty? || p.search_corpus.include?(filters.search))
    end
  end
end
