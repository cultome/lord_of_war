class LordOfWar::Events::Routes::Api < Sinatra::Base
  helpers LordOfWar::Shared::Helpers

  before do
    authenticate!
  end

  get '/events' do
    year, month = params.fetch('month', Time.now.strftime('%Y-%m')).split('-').map(&:to_i)

    current_month = Date.new year, month, 1
    prev_month = current_month.prev_month
    next_month = current_month.next_month

    events = store.get_events @account.user.id, current_month

    events_by_date = events
                     .map { |e| e.datetime.strftime('%Y-%m-%d') }
                     .group_by(&:itself)
                     .transform_values(&:size)

    erb(
      :events,
      locals: {
        section_title: 'Eventos de la comunidad',
        account: @account,
        events: events,
        event: LordOfWar::Event.parse_json({}),
        events_by_date: events_by_date,
        today: Time.now.strftime('%Y-%m-%d'),
        current_month_skips: current_month.wday,
        current_month_days: (next_month - current_month).to_i,
        current_month: current_month.strftime('%Y-%m'),
        prev_month: prev_month.strftime('%Y-%m'),
        next_month: next_month.strftime('%Y-%m'),
      }
    )
  end

  post '/event-add' do
    evt = LordOfWar::Event.new(
      params['title'],
      "#{params["date"]}T#{params["time"]}:00-06:00", # "2025-11-11T21:43:40-06:00"
      params['place_name'],
      params['place_url'],
      params['desc'],
      @account.user.id
    )

    new_event_id = store.create_event evt

    if new_event_id.nil?
      partial :event_form, event: evt, alert_type: 'danger', message: 'Ocurrio un error al crear el evento'
    else
      query_string = request.referer.include?('?') ? request.referer.split('?').last : ''
      response.headers['HX-Redirect'] = "/events?#{query_string}"

      partial :event_form, event: evt, alert_type: 'secondary', message: 'Evento creado!'
    end
  end
end
