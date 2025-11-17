class LordOfWar::Catalog::Service::ToggleFav
  include LordOfWar::Shared::Service::Responses
  include LordOfWar::Shared::Utils

  attr_accessor :id, :user_id

  def initialize(id, user_id)
    @id = id
    @user_id = user_id
  end

  def execute!
    product = product_store.find_product id
    new_state_is_active = favs_store.toggle_fav product.id, user_id

    success({ product: product, was_removed: !new_state_is_active, is_active: new_state_is_active })
  end

  private

  def product_store
    @product_store ||= LordOfWar::Catalog::Repository::Product.new
  end

  def favs_store
    @favs_store ||= LordOfWar::Catalog::Repository::Favs.new
  end
end
