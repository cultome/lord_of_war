class LordOfWar::Login::Entity::EmergencyInformation
  attr_accessor :name, :blood_type, :contact_name, :contact_phone

  def self.parse_json(rec)
    new rec['real_name'], rec['blood_type'], rec['emergency_contact_name'], rec['emergency_contact_phone']
  end

  def initialize(name, blood_type, contact_name, contact_phone)
    @name = name
    @blood_type = blood_type
    @contact_name = contact_name
    @contact_phone = contact_phone
  end
end
