class LordOfWar::Marketplace::Service::ListingDetails
  include LordOfWar::Shared::Service::Responses
  include LordOfWar::Shared::Utils

  attr_accessor :id

  def initialize(id)
    @id = id
  end

  def execute!
    listing = listing_store.find_listing id

    success({ listing: listing })
  end

  private

  def listing_store
    @listing_store ||= LordOfWar::Marketplace::Repository::Listing.new
  end
end
