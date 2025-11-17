class LordOfWar::Profile::Service::AddEquipment
  include LordOfWar::Shared::Service::Responses
  include LordOfWar::Shared::Utils

  attr_accessor :kind, :name, :url, :user_id

  def initialize(kind, name, url, user_id)
    @kind = kind
    @name = name
    @url = url
    @user_id = user_id
  end

  def execute!
    equipment = equipment_store.add_equipment kind, name, url, user_id
    success equipment
  end

  private

  def equipment_store
    @equipment_store ||= LordOfWar::Profile::Repository::Equipment.new
  end
end
