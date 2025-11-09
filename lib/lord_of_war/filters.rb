class LordOfWar::Filters
  attr_reader :search, :categories, :min_price, :max_price

  def initialize(search:, categories:, min_price:, max_price:)
    @search = search
    @categories = categories.blank? ? [] : categories
    @min_price = min_price.blank? ? 0 : min_price.to_i
    @max_price = max_price.blank? ? 1_000_000 : max_price.to_i
  end

  def search_empty?
    @search.blank?
  end

  def categories_empty?
    @categories.blank?
  end

  def category?(name)
    @categories.include? name
  end

  def max_price_input
    @max_price == 1_000_000 ? nil : @max_price
  end

  def min_price_input
    @min_price.zero? ? nil : @min_price
  end

  def search_input
    @search.blank? ? nil : @search
  end
end
