class LordOfWar::Profile::Service::RemoveEquipment
  include LordOfWar::Shared::Service::Responses
  include LordOfWar::Shared::Utils

  attr_accessor :id, :user_id

  def initialize(id, user_id)
    @id = id
    @user_id = user_id
  end

  def execute!
    equipment_store.remove_equipment id, user_id
    success 'Equipamiento eliminado'
  end

  private

  def equipment_store
    @equipment_store ||= LordOfWar::Profile::Repository::Equipment.new
  end
end
