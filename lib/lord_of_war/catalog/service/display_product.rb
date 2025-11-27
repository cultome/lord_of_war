class LordOfWar::Catalog::Service::DisplayProduct
  include LordOfWar::Shared::Service::Responses
  include LordOfWar::Shared::Utils

  attr_accessor :id

  def initialize(id)
    @id = id
  end

  def execute!
    product = product_store.find_product id
    success({
      product: product,
      capacity_catalog: product_store.get_capacity_catalog,
      thread_direction_catalog: product_store.get_thread_direction_catalog,
      system_catalog: product_store.get_system_catalog,
      speed_catalog: product_store.get_speed_catalog,
      motor_catalog: product_store.get_motor_catalog,
      magazine_catalog: product_store.get_magazine_catalog,
      outer_barrel_catalog: product_store.get_outer_barrel_catalog,
      inner_barrel_catalog: product_store.get_inner_barrel_catalog,
      hop_up_catalog: product_store.get_hop_up_catalog,
      gearbox_catalog: product_store.get_gearbox_catalog,
      fps_range_catalog: product_store.get_fps_range_catalog,
      category_catalog: product_store.get_category_catalog,
    })
  end

  private

  def product_store
    @product_store ||= LordOfWar::Catalog::Repository::Product.new
  end
end
