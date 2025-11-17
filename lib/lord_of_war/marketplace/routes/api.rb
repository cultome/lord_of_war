class LordOfWar::Marketplace::Routes::Api < Sinatra::Base
  helpers LordOfWar::Shared::Helpers

  before do
    authenticate!
  end

  get '/marketplace' do
    filters = LordOfWar::Shared::Entity::Filters.new(
      user_id: @user.id,
      search: params['search'],
      categories: params['categories'],
      min_price: params['min-price'],
      max_price: params['max-price']
    )

    pagination = LordOfWar::Shared::Entity::Pagination.new params['page']

    listings = store.get_listings filters, pagination

    prices = listings.map(&:price_amount).select(&:positive?)
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
        listings: listings,
        categories: category_labels,
        filters: filters,
        pagination: pagination,
        price_range: price_range,
        listing: LordOfWar::Listing.parse_json({}),
      }
    )
  end

  post '/marketplace/upload-image' do
    file = params[:file]
    halt 400, 'No se recibió archivo' unless file && file[:tempfile]

    filename = "#{SecureRandom.uuid}.#{file[:filename].split(".").last}"
    filepath = File.join './public/uploads', filename

    FileUtils.mkdir_p './public/uploads'
    File.binwrite filepath, file[:tempfile].read

    partial :listing_upload_img, filename: filename
  end

  get '/marketplace/:id' do
    listing = store.find_listing params[:id]

    erb(
      :listing,
      layout: false,
      locals: {
        listing: listing,
      }
    )
  end

  post '/listing-add' do
    listing = LordOfWar::Listing.new(
      params['title'],
      params['desc'],
      params['price'],
      params['category_id'],
      params['imgs']
    )

    new_listing_id = store.create_listing listing, @account.user.id

    if new_listing_id.nil?
      partial :listing_form, listing: listing, alert_type: 'danger', message: 'Ocurrio un error al crear el anuncio',
                             categories: category_labels

    else
      query_string = request.referer.include?('?') ? request.referer.split('?').last : ''
      response.headers['HX-Redirect'] = "/marketplace?#{query_string}"

      partial :listing_form, listing: listing, alert_type: 'secondary', message: 'Anuncio creado!', categories: category_labels
    end
  end
end
