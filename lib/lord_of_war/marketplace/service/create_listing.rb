class LordOfWar::Marketplace::Service::CreateListing
  include LordOfWar::Shared::Service::Responses
  include LordOfWar::Shared::Utils

  attr_accessor :title, :desc, :price, :category_id, :imgs, :user_id

  def initialize(title, desc, price, category_id, imgs, user_id)
    @title = title
    @desc = desc
    @price = price
    @category_id = category_id
    @imgs = imgs
    @user_id = user_id
  end

  def execute!
    listing = LordOfWar::Marketplace::Entity::Listing.new(
      title,
      desc,
      price,
      category_id,
      imgs,
    )

    new_listing_id = listing_store.create_listing listing, user_id
    category_labels = category_store.category_labels

    if new_listing_id.nil?
      error_with_value('Ocurrio un error al crear el anuncio', { listing: listing, category_labels: category_labels })

    else
      success({ listing: listing, category_labels: category_labels })
    end
  end

  private

  def listing_store
    @listing_store ||= LordOfWar::Marketplace::Repository::Listing.new
  end

  def category_store
    @category_store ||= LordOfWar::Shared::Repository::Catalogs.new
  end
end
