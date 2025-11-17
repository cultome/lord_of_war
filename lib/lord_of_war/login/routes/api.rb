class LordOfWar::Login::Routes::Api < Sinatra::Base
  include LordOfWar::Shared::Helpers

  set :views, VIEWS_FOLDER

  get '/login' do
    if session.key? :user_id
      redirect to('/')
    else
      erb :login, layout: :login_layout
    end
  end

  post '/login' do
    resp = LordOfWar::Login::Service::LoginUser.new(
      params['email'],
      params['password']
    ).execute!

    if resp.success?
      session[:user_id] = resp.value.id
      response.headers['HX-Redirect'] = '/'

      partial :login_form, alert_type: 'seconday', message: 'Validacion exitosa!'
    else
      partial :login_form, alert_type: resp.error_type, message: resp.error
    end
  end

  get '/logout' do
    session[:user_id] = nil

    redirect to('/login')
  end
end
