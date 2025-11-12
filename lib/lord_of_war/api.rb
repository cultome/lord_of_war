class LordOfWar::Api < Sinatra::Base
  include BCrypt

  enable :sessions

  set :sessions, domain: 'localhost'
  set :session_secret, ENV.fetch('SESSION_SECRET') { SecureRandom.hex(64) }

  NO_AUTH_PATHS = %w[
    /login
    /logout
    /apple-touch-icon.png
    /favicon-32x32.png
    /favicon-16x16.png
    /site.webmanifest
    /css/
  ].join('|')

  before do
    # return if request.path.match?(/^(#{NO_AUTH_PATHS})/)
    session[:user_id] = '74604fce-0953-4e87-93e5-e10e2b7389ff'

    if session.key? :user_id
      @user = store.find_user session[:user_id]
      @account = LordOfWar::Account.new user: @user
    else
      redirect to('/login')
    end
  end

  get '/login' do
    if session.key? :user_id
      redirect to('/')
    else
      erb :login, layout: :login_layout
    end
  end

  post '/login' do
    user = store.find_user_by_email params['email']

    if user.nil?
      puts "[-] User [#{params["email"]}] doesnt exists!"
      partial :login_form, alert_type: 'danger', message: 'Credenciales invalidas!'
    elsif BCrypt::Password.new(user.password) != params['password']
      puts "[-] Password for [#{params["email"]}] is incorrect!"
      partial :login_form, alert_type: 'danger', message: 'Credenciales invalidas!'
    else
      puts "[-] Login successful for [#{params["email"]}]!"

      session[:user_id] = user.id
      response.headers['HX-Redirect'] = '/'

      partial :login_form, alert_type: 'seconday', message: 'Validacion exitosa!'
    end
  end

  get '/logout' do
    session[:user_id] = nil

    redirect to('/login')
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

  get '/' do
    redirect to('/catalog')
  end

  get '/marketplace' do
    filters = LordOfWar::Filters.new(
      user_id: @user.id,
      search: params['search'],
      categories: params['categories'],
      min_price: params['min-price'],
      max_price: params['max-price'],
      favs_only: true
    )

    pagination = LordOfWar::Pagination.new params['page']

    products = []

    prices = products.map(&:price_amount).select(&:positive?)
    price_min = prices.min
    price_max = prices.max

    price_range = {
      min: price_min,
      min_placeholder: "$#{to_money_format price_min}",
      max: price_max,
      max_placeholder: "$#{to_money_format price_max}",
    }

    erb(
      :marketplace,
      locals: {
        section_title: 'Bazar de guerra',
        account: @account,
        products: products,
        categories: category_labels,
        filters: filters,
        pagination: pagination,
        price_range: price_range,
      }
    )
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
      response.headers['HX-Redirect'] = "/events?#{request.referer.split("?").last}"

      partial :event_form, event: evt, alert_type: 'secondary', message: 'Evento creado!'
    end
  end

  get '/profile' do
    erb(
      :profile,
      locals: {
        section_title: 'Mi perfil',
        account: @account,
      }
    )
  end

  get '/favs' do
    filters = LordOfWar::Filters.new(
      user_id: @user.id,
      search: params['search'],
      categories: params['categories'],
      min_price: params['min-price'],
      max_price: params['max-price'],
      favs_only: true
    )

    pagination = LordOfWar::Pagination.new params['page']

    products = store.get_products filters, pagination

    prices = products.map(&:price_amount).select(&:positive?)
    price_min = prices.min
    price_max = prices.max

    price_range = {
      min: price_min,
      min_placeholder: "$#{to_money_format price_min}",
      max: price_max,
      max_placeholder: "$#{to_money_format price_max}",
    }

    erb(
      :favs,
      locals: {
        products: products,
        categories: category_labels,
        filters: filters,
        pagination: pagination,
        price_range: price_range,
        section_title: 'Mi Favs',
        account: @account,
      }
    )
  end

  get '/catalog' do
    filters = LordOfWar::Filters.new(
      user_id: @user.id,
      search: params['search'],
      categories: params['categories'],
      min_price: params['min-price'],
      max_price: params['max-price']
    )

    pagination = LordOfWar::Pagination.new params['page']

    products = store.get_products filters, pagination
    favs = store.filter_by_favs products, @user.id

    prices = products.map(&:price_amount).select(&:positive?)
    price_min = prices.min
    price_max = prices.max

    price_range = {
      min: price_min,
      min_placeholder: "$#{to_money_format price_min}",
      max: price_max,
      max_placeholder: "$#{to_money_format price_max}",
    }

    erb(
      :catalog,
      locals: {
        products: products,
        categories: category_labels,
        filters: filters,
        pagination: pagination,
        price_range: price_range,
        favs: favs,
        section_title: 'Catalogo',
        account: @account,
      }
    )
  end

  post '/fav-remove/:id' do
    product = store.find_product params[:id]
    store.remove_fav product.id, @user.id
    '' # remove element
  end

  post '/fav-toggle/:id' do
    product = store.find_product params[:id]
    new_state_is_active = store.toggle_fav product.id, @user.id
    partial :fav_button, product: product, was_removed: !new_state_is_active, is_active: new_state_is_active
  end

  def to_money_format(value)
    value.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
  end

  def category_labels
    @@category_labels ||= begin
      catalog = store.categories_catalog
      {
        catalog['replica'] => 'Replicas',
        catalog['accessories'] => 'Accesorios',
        catalog['gear'] => 'Equipo Tactico',
        catalog['misc'] => 'Insumos',
        catalog['consumable'] => 'Misc',
      }
    end
  end

  def password_complex_enough?(_value)
    # TODO: implement
    true
  end

  def store
    @store ||= LordOfWar::Store::SqliteStore.new 'low.db'
  end

  helpers do
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
  end
end
