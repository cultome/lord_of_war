class LordOfWar::Marketplace::Service::DisplayProducts
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

    listings = listing_store.get_listings filters, pagination

    prices = listings.map(&:price_amount).select(&:positive?)
    price_min = prices.min
    price_max = prices.max

    price_range = {
      min: price_min,
      min_placeholder: "$#{to_money_format price_min}",
      max: price_max,
      max_placeholder: "$#{to_money_format price_max}",
    }

    success({
      section_title: 'Bazar de guerra',
      listings: listings,
      categories: catalogs_store.category_labels,
      filters: filters,
      pagination: pagination,
      price_range: price_range,
      listing: LordOfWar::Marketplace::Entity::Listing.parse_json({}),
    })
  end

  private

  def listing_store
    @listing_store ||= LordOfWar::Marketplace::Repository::Listing.new
  end

  def catalogs_store
    @catalogs_store ||= LordOfWar::Shared::Repository::Catalogs.new
  end
end
