class LordOfWar::Profile::Service::UpdateAccount
  include LordOfWar::Shared::Service::Responses
  include LordOfWar::Shared::Utils

  attr_accessor :new_username, :current_username, :user_id

  def initialize(new_username, current_username, user_id)
    @new_username = new_username
    @current_username = current_username
    @user_id = user_id
  end

  def execute!
    if current_username == new_username
      error 'Ya tienes este nombre de usuario!'
    elsif profile_store.username_exists? new_username
      error "El nombre de usuario [#{new_username}] no esta disponible"
    elsif profile_store.update_username! user_id, new_username
      success 'Actualizacion exitosa!'
    else
      error 'Sucedio un error al actualizar tu nombre de usuario!'
    end
  end

  private

  def profile_store
    @profile_store ||= LordOfWar::Profile::Repository::Profile.new
  end
end
