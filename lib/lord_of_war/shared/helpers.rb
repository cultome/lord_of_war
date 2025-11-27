module LordOfWar::Shared::Helpers
  VIEWS_FOLDER = File.expand_path '../../../views', __dir__

  NO_AUTH_PATHS = %w[
    /apple-touch-icon.png
    /favicon-32x32.png
    /favicon-16x16.png
    /site.webmanifest
    /css/
    /img/
  ].join('|')

  def authenticate!
    return if request.path.match?(/^(#{NO_AUTH_PATHS})/)

    session[:user_id] = '74604fce-0953-4e87-93e5-e10e2b7389ff'

    if session.key? :user_id
      store = LordOfWar::Shared::Repository::Login.new
      @account = store.find_account_by_user session[:user_id]
      @user = @account.user
    else
      redirect to('/login')
    end
  end

  def partial(template, locals = {})
    erb :"_#{template}", layout: false, locals: locals
  end

  def format_calendar_header(value)
    year, month = value.split('-').map(&:to_i)
    months = %w[Enero Febrero Marzo Abril Mayo Junio Julio Agosto Septiembre Octubre Noviembre Diciembre]

    "#{months[month - 1]} #{year}"
  end

  def format_event_date(time)
    months = %w[Ene Feb Mar Abr May Jun Jul Ago Sep Oct Nov Dic]

    "#{time.day} de #{months[time.month - 1]} - #{time.strftime "%H:%M"} hrs"
  end

  def options_for(catalog)
    catalog.map do |id, name|
      "<option value=\"#{id}\">#{name}</option>"
    end
  end
end
