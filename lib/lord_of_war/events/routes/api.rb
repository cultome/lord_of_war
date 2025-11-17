class LordOfWar::Events::Routes::Api < Sinatra::Base
  helpers LordOfWar::Shared::Helpers

  set :views, VIEWS_FOLDER

  before do
    authenticate!
  end

  get '/events' do
    res = LordOfWar::Events::Service::DisplayEvents.new(
      @user.id,
      params.fetch('month', Time.now.strftime('%Y-%m'))
    ).execute!

    erb :events, locals: { account: @account }.merge(res.value) if res.success?
  end

  post '/event-add' do
    res = LordOfWar::Events::Service::CreateEvent.new(
      params['title'],
      "#{params["date"]}T#{params["time"]}:00-06:00", # "2025-11-11T21:43:40-06:00"
      params['place_name'],
      params['place_url'],
      params['desc'],
      @account.user.id
    ).execute!

    if res.success?
      query_string = request.referer.include?('?') ? request.referer.split('?').last : ''
      response.headers['HX-Redirect'] = "/events?#{query_string}"

      partial :event_form, event: res.value, alert_type: res.alert_type, message: 'Evento creado!'
    else
      partial :event_form, event: res.value, alert_type: res.alert_type, message: res.error
    end
  end

  delete '/events/:id' do
    res = LordOfWar::Events::Service::DeleteEvent.new(
      params[:id],
      @account.user.id
    ).execute!

    if res.success?
      query_string = request.referer.include?('?') ? request.referer.split('?').last : ''
      response.headers['HX-Redirect'] = "/events?#{query_string}"

      partial :empty
    else
      res2 = LordOfWar::Events::Service::DisplayEvents.new(
        @user.id,
        params.fetch('month', Time.now.strftime('%Y-%m'))
      ).execute!

      partial :event_list, { account: @account, alert_type: res.alert_type, message: res.error }.merge(res2.value)
    end
  end
end
