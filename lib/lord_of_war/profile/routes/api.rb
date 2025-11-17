class LordOfWar::Profile::Routes::Api < Sinatra::Base
  helpers LordOfWar::Shared::Helpers

  include BCrypt

  before do
    authenticate!
  end

  get '/profile' do
    teams = store.get_teams

    erb(
      :profile,
      locals: {
        section_title: 'Mi perfil',
        account: @account,
        teams: teams,
      }
    )
  end

  post '/update-account' do
    if @account.user.username == params['username']
      partial :account_form, { account: @account, alert_type: 'warning', message: 'Ya tienes este nombre de usuario!' }
    elsif store.username_exists? params['username']
      partial :account_form,
              { account: @account, alert_type: 'danger', message: "El nombre de usuario [#{params["username"]}] no esta disponible" }
    elsif store.update_username! @account.user.id, params['username']
      @account.user.username = params['username']

      partial :account_form, { account: @account, alert_type: 'secondary', message: 'Actualizacion exitosa!' }
    else
      partial :account_form, { account: @account, alert_type: 'danger', message: 'Sucedio un error al actualizar tu nombre de usuario!' }
    end
  end

  post '/update-password' do
    locals = { account: @account }

    if BCrypt::Password.new(@account.user.password) == params['cpasswd']
      if password_complex_enough? params['npasswd']
        if store.update_password! @account.user.id, BCrypt::Password.create(params['npasswd'])
          locals.merge! alert_type: 'secondary', message: 'Actualizacion exitosa!'
        else
          locals.merge! alert_type: 'danger', message: 'Sucedio un error al actualizar tu contraseña!'
        end
      else
        locals.merge! alert_type: 'danger', message: 'Tu nueva contrasena es muy simple. Agrega mayusculas, numeros y simbolos.'
      end
    else
      locals.merge! alert_type: 'danger', message: 'Tu contraseña actual es incorrecta!'
    end

    partial :password_form, locals
  end

  post '/update-emergency' do
  end

  post '/update-teams' do
  end
end
