class LordOfWar::Profile::Service::DisplayEquipment
  include LordOfWar::Shared::Service::Responses
  include LordOfWar::Shared::Utils

  def initialize(kind, user_id)
    @kind = kind
    @user_id = user_id
  end

  def execute!
    equipment = equipment_store.get_user_equipment_by_kind @user_id, @kind

    success equipment
  end

  private

  def equipment_store
    @equipment_store ||= LordOfWar::Profile::Repository::Equipment.new
  end
end
