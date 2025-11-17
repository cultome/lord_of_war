class LordOfWar::Catalog::Service::DisplayCatalog
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
      max_price: max_price
    )

    pagination = LordOfWar::Shared::Entity::Pagination.new page

    products = product_store.get_products filters, pagination
    favs = favs_store.filter_by_favs products, user_id

    prices = products.map(&:price_amount).select(&:positive?)
    price_min = prices.min
    price_max = prices.max

    price_range = {
      min: price_min,
      min_placeholder: "$#{to_money_format price_min}",
      max: price_max,
      max_placeholder: "$#{to_money_format price_max}",
    }

    success(
        products: products,
        categories: category_labels,
        filters: filters,
        pagination: pagination,
        price_range: price_range,
        favs: favs,
        section_title: 'Catalogo',
    )
  end

  private

  def category_labels
    @@category_labels ||= begin
      catalog = product_store.categories_catalog
      {
        catalog['replica'] => 'Replicas',
        catalog['accessories'] => 'Accesorios',
        catalog['gear'] => 'Equipo Tactico',
        catalog['misc'] => 'Insumos',
        catalog['consumable'] => 'Misc',
      }
    end
  end

  def favs_store
    @favs_store ||= LordOfWar::Catalog::Repository::Favs.new
  end

  def product_store
    @product_store ||= LordOfWar::Catalog::Repository::Product.new
  end
end
