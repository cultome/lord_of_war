class LordOfWar::Api < Sinatra::Base
  get '/product-list' do
    filters = LordOfWar::Filters.new(
      categories: ['Réplicas']
    )

    categories = [
      'Réplicas',
      'Equipo táctico',
    ]

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

    pagination = LordOfWar::Pagination.new

    erb(
      :product_list,
      locals: {
        products: products,
        categories: categories,
        filters: filters,
        pagination: pagination,
      }
    )
  end
end
