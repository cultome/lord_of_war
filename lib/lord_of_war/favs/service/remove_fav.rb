class LordOfWar::Favs::Service::RemoveFav
  include LordOfWar::Shared::Service::Responses
  include LordOfWar::Shared::Utils

  attr_accessor :id, :user_id

  def initialize(id, user_id)
    @id = id
    @user_id = user_id
  end

  def execute!
    product = product_store.find_product id
    favs_store.remove_fav product.id, user_id

    success ''
  end

  private

  def product_store
    @product_store ||= LordOfWar::Catalog::Repository::Product.new
  end

  def favs_store
    @favs_store ||= LordOfWar::Catalog::Repository::Favs.new
  end
end
