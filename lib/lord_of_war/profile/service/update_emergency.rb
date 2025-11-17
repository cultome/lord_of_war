class LordOfWar::Profile::Service::UpdateEmergency
  include LordOfWar::Shared::Service::Responses
  include LordOfWar::Shared::Utils

  attr_accessor :name, :blood_type, :contact_name, :contact_phone, :user_id

  def initialize(name, blood_type, contact_name, contact_phone, user_id)
    @name = name
    @blood_type = blood_type
    @name = name
    @contact_name = contact_name
    @contact_phone = contact_phone
    @user_id = user_id
  end

  def execute!
    if profile_store.update_emergency!(name, blood_type, contact_name, contact_phone, user_id)
      success 'Datos de emergencia actualizado'
    else
      error 'Ocurrio un error al actualizar tu contacto'
    end
  end

  private

  def profile_store
    @profile_store ||= LordOfWar::Profile::Repository::Profile.new
  end
end
