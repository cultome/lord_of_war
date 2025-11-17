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
          current_tab: params.fetch('tab', 'equipment'),
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

  get '/equipment/:kind' do
    res = LordOfWar::Profile::Service::DisplayEquipment.new(
      params['kind'],
      @account.user.id
    ).execute!

    partial(
      :equipment,
      {
        kind: kind_labels.fetch(params[:kind], params[:kind]), 
        kind_id: params[:kind], 
        equipments: res.value, 
        equipment: LordOfWar::Profile::Entity::Equipment.empty
      }
    )
  end

  post '/equipment/:kind' do
    res = LordOfWar::Profile::Service::AddEquipment.new(
      params['kind'],
      params['name'],
      params['url'],
      @account.user.id
    ).execute!

    label = kind_labels.fetch(params[:kind], params[:kind])

    if res.success?
      query_string = request.referer.include?('?') ? request.referer.split('?').last : ''
      response.headers['HX-Redirect'] = "/profile?tab=equipment&#{query_string}"

      partial :equipment_form, kind: label, kind_id: params[:kind], equipment: res.value
    else
      partial :equipment_form, kind: label, kind_id: params[:kind], equipment: res.value, message: res.error
    end
  end

  delete '/equipment/:id' do
    res = LordOfWar::Profile::Service::RemoveEquipment.new(
      params['id'],
      @account.user.id
    ).execute!

    query_string = request.referer.include?('?') ? request.referer.split('?').last : ''
    response.headers['HX-Redirect'] = "/profile?tab=equipment&#{query_string}"

  partial :equipment_form, kind: '', kind_id: params[:kind], equipment: LordOfWar::Profile::Entity::Equipment.empty
  end

  private

  def kind_labels
    @kind_labels ||= {
      'hands' => 'Manos',
      'primary' => 'Replica Primaria',
      'secondary' => 'Replica Secundaria',
      'jacket' => 'Chaleco',
      'shoes' => 'Calzado',
      'pants' => 'Pantalones',
      'belt' => 'Cinturon',
      'chest' => 'Pecho',
      'helmet' => 'Casco',
      'face' => 'Cara',
    }
  end
end
