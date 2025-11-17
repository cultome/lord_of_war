class LordOfWar::Profile::Routes::Api < Sinatra::Base
  helpers LordOfWar::Shared::Helpers

  set :views, VIEWS_FOLDER

  before do
    authenticate!
  end

  get '/profile' do
    res = LordOfWar::Profile::Service::DisplayProfile.new(@account.user.id).execute!

    if res.success?
      erb(
        :profile,
        locals: {
          section_title: 'Mi perfil',
          account: @account,
          teams: res.value[:teams],
          my_teams: res.value[:my_teams],
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
      @account.user.username = params['username']
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
      @account.user.id
    ).execute!

    partial :password_form, account: @account, alert_type: res.alert_type, message: res.success? ? res.value : res.error
  end

  post '/update-emergency' do
    res = LordOfWar::Profile::Service::UpdateEmergency.new(
      params['name'],
      params['blood_type'],
      params['contact_name'],
      params['contact_phone'],
      @account.user.id
    ).execute!

    if res.success?
      @account.emergency_information.name = params['name']
      @account.emergency_information.blood_type = params['blood_type']
      @account.emergency_information.contact_name = params['contact_name']
      @account.emergency_information.contact_phone = params['contact_phone']

      partial :emergency_form, { account: @account, alert_type: res.alert_type, message: 'Actualizacion exitosa!' }
    else
      partial :emergency_form, { account: @account, alert_type: res.alert_type, message: res.error }
    end
  end

  post '/update-teams' do
    res = LordOfWar::Profile::Service::UpdateTeams.new(
      params['teams'],
      @account.user.id
    ).execute!

    if res.success?
      partial :teams_form,
              { teams: res.value[:teams], my_teams: res.value[:my_teams], alert_type: res.alert_type, message: 'Actualizacion exitosa!' }
    else
      partial :teams_form,
              { teams: res.value[:teams], my_teams: res.value[:my_teams], account: @account, alert_type: res.alert_type,
                message: res.error, }
    end
  end
end
