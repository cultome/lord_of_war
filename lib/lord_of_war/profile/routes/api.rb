class LordOfWar::Profile::Routes::Api < Sinatra::Base
  helpers LordOfWar::Shared::Helpers

  set :views, VIEWS_FOLDER

  before do
    authenticate!
  end

  get '/profile' do
    res = LordOfWar::Profile::Service::DisplayProfile.new.execute!

    if res.success?
      erb(
        :profile,
        locals: {
          section_title: 'Mi perfil',
          account: @account,
          teams: res.value,
        }
      )
    end
  end

  post '/update-account' do
    res = LordOfWar::Profile::Service::UpdateAccount.new(
      params['username'],
      @account.user.username,
      @account.user.id
    ).execute!

    if res.success?
      partial :account_form, { account: @account, alert_type: res.alert_type, message: 'Actualizacion exitosa!' }
    else
      partial :account_form, { account: @account, alert_type: res.alert_type, message: res.error }
    end
  end

  post '/update-password' do
    res = LordOfWar::Profile::Service::UpdatePassword.new(
      @account.user.password,
      params['cpasswd'],
      params['npasswd'],
      @account.user.id,
    ).execute!

    partial :password_form, account: @account, alert_type: res.alert_type, message: res.success? ? res.value : res.error
  end

  post '/update-emergency' do
  end

  post '/update-teams' do
  end
end
