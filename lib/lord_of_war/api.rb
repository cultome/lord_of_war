class LordOfWar::Api < Sinatra::Base
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
      username: 'username',
      search: params['search'],
      categories: params['categories'],
      min_price: params['min-price'],
      max_price: params['max-price'],
      favs_only: true
    )

    pagination = LordOfWar::Pagination.new params['page']

    products = products_store.get_products filters, pagination

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
      username: 'username',
      search: params['search'],
      categories: params['categories'],
      min_price: params['min-price'],
      max_price: params['max-price']
    )

    pagination = LordOfWar::Pagination.new params['page']

    products = products_store.get_products filters, pagination
    favs = products_store.filter_by_favs products, 'username'

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
    product = products_store.find_product params[:id]
    products_store.remove_fav product.id, 'username'
    '' # remove element
  end

  post '/fav-toggle/:id' do
    product = products_store.find_product params[:id]
    new_state_is_active = products_store.toggle_fav product.id, 'username'
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

  def products_store
    @products_store ||= LordOfWar::Store::JsonStore.new(
      'data/vetaairsoft/products_clean.json'
      # 'data/aire_suave_data/aire_suave_accesorios.json',
      # 'data/aire_suave_data/aire_suave_baterias_y_cargadores.json',
      # 'data/aire_suave_data/aire_suave_bbs_y_gas.json',
      # 'data/aire_suave_data/aire_suave_clean.json',
      # 'data/aire_suave_data/aire_suave_equipo_tactico.json',
      # 'data/aire_suave_data/aire_suave_ofertas.json',
      # 'data/aire_suave_data/aire_suave_replicas.json',
      # 'data/aire_suave_data/aire_suave_sin_categorizar.json'
    )
  end

  helpers do
    def partial(template, locals = {})
      erb :"_#{template}", layout: false, locals: locals
    end
  end
end
