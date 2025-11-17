class LordOfWar::Favs::Service::DisplayFavs
  include LordOfWar::Shared::Service::Responses
  include LordOfWar::Shared::Utils

  attr_accessor :user_id, :search, :categories, :min_price, :max_price, :page

  def initialize(user_id, search, categories, min_price, max_price, page)
    @user_id = user_id
    @search = search
    @categories = categories
    @min_price = min_price
    @max_price = max_price
    @page = page
  end

  def execute!
    filters = LordOfWar::Shared::Entity::Filters.new(
      user_id: user_id,
      search: search,
      categories: categories,
      min_price: min_price,
      max_price: max_price,
      favs_only: true
    )

    pagination = LordOfWar::Shared::Entity::Pagination.new page

    products = product_store.get_products filters, pagination

    prices = products.map(&:price_amount).select(&:positive?)
    price_min = prices.min
    price_max = prices.max

    price_range = {
      min: price_min,
      min_placeholder: "$#{to_money_format price_min}",
      max: price_max,
      max_placeholder: "$#{to_money_format price_max}",
    }

    success({
      products: products,
      categories: catalogs_store.category_labels,
      filters: filters,
      pagination: pagination,
      price_range: price_range,
      section_title: 'Mi Favs',
    })
  end

  private

  def product_store
    @product_store ||= LordOfWar::Catalog::Repository::Product.new
  end

  def catalogs_store
    @catalogs_store ||= LordOfWar::Shared::Repository::Catalogs.new
  end
end
