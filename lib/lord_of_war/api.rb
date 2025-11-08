class LordOfWar::Api < Sinatra::Base
  set :public_folder, '/static'

  get '/product-list' do
    filters = LordOfWar::Filters.new(
      categories: ['Réplicas']
    )

    categories = [
      'Réplicas',
      'Equipo táctico',
    ]

    products = [
      LordOfWar::Replica.new,
    ]

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
