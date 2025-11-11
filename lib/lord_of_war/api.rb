class LordOfWar::Api < Sinatra::Base
  before do
    @user = LordOfWar::User.new '74604fce-0953-4e87-93e5-e10e2b7389ff', 'cultome'
  end

  post '/update-account' do
  end

  post '/update-password' do
  end

  post '/update-emergency' do
  end

  post '/update-teams' do
  end

  get '/' do
    redirect to('/catalog')
  end

  get '/marketplace' do
    erb(
      :marketplace,
      locals: {
        section_title: 'Mercado de armas',
      }
    )
  end

  get '/events' do
    erb(
      :events,
      locals: {
        section_title: 'Eventos de la comunidad',
      }
    )
  end

  get '/profile' do
    erb(
      :profile,
      locals: {
        section_title: 'Mi perfil',
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
        section_title: 'Mi Warlist',
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
    partial :fav_button, product: product, is_active: new_state_is_active
  end

  def to_money_format(value)
    value.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
  end

  def category_labels
    @category_labels = {
      'replica' => 'Replicas',
      'accessories' => 'Accesorios',
      'gear' => 'Equipo Tactico',
      'consumable' => 'Insumos',
      'misc' => 'Misc',
    }
  end

  def users_store; end

  def store
    @store ||= LordOfWar::Store::SqliteStore.new 'low.db'
  end

  helpers do
    def partial(template, locals = {})
      erb :"_#{template}", layout: false, locals: locals
    end
  end
end
