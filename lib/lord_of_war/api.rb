class LordOfWar::Api < Sinatra::Base
  get '/product-list' do
    filters = LordOfWar::Filters.new(
      search: params['search'],
      categories: params['categories'],
      min_price: params['min-price'],
      max_price: params['max-price']
    )

    store = LordOfWar::Store::JsonStore.new(
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

    products = store.get_products filters

    prices = products.map(&:price_amount).reject { |amount| amount <= 0 }
    price_min = prices.min
    price_max = prices.max

    price_range = {
      min: price_min,
      min_placeholder: "$#{to_money_format price_min}",
      max: price_max,
      max_placeholder: "$#{to_money_format price_max}",
    }

    pagination = LordOfWar::Pagination.new

    erb(
      :product_list,
      locals: {
        products: products,
        categories: category_labels,
        filters: filters,
        pagination: pagination,
        price_range: price_range,
      }
    )
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
end
