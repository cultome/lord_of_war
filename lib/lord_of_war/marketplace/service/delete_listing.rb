class LordOfWar::Marketplace::Service::DeleteListing
  include LordOfWar::Shared::Service::Responses
  include LordOfWar::Shared::Utils

  attr_accessor :id, :user_id

  def initialize(id, user_id)
    @id = id
    @user_id = user_id
  end

  def execute!
    if listing_store.delete_listing! id, user_id
      success_empty
    else
      error 'No pudes borrar este anuncio!'
    end
  end

  private

  def listing_store
    @listing_store ||= LordOfWar::Marketplace::Repository::Listing.new
  end
end
