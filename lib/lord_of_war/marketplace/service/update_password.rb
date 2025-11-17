class LordOfWar::Profile::Service::UpdatePassword
  include LordOfWar::Shared::Service::Responses
  include LordOfWar::Shared::Utils

  include BCrypt

  attr_accessor :current_password, :verification_password, :new_password, :user_id

  def initialize(current_password, verification_password, new_password, user_id)
    @current_password = current_password
    @verification_password = verification_password
    @new_password = new_password
    @user_id = user_id
  end

  def execute!
    if BCrypt::Password.new(current_password) == verification_password
      if password_complex_enough? new_password
        if profile_store.update_password! user_id, BCrypt::Password.create(new_password)
          success 'Actualizacion exitosa!'
        else
          error 'Sucedio un error al actualizar tu contraseña!'
        end
      else
        error 'Tu nueva contrasena es muy simple. Agrega mayusculas, numeros y simbolos.'
      end
    else
      error 'Tu contraseña actual es incorrecta!'
    end
  end

  private

  def profile_store
    @profile_store ||= LordOfWar::Profile::Repository::Profile.new
  end
end
