class LordOfWar::Marketplace::Routes::Api < Sinatra::Base
  helpers LordOfWar::Shared::Helpers

  set :views, VIEWS_FOLDER

  before do
    authenticate!
  end

  get '/marketplace' do
    res = LordOfWar::Marketplace::Service::DisplayProducts.new(
      @user.id,
      params['search'],
      params['categories'],
      params['min-price'],
      params['max-price'],
      params['page']
    ).execute!

    erb :marketplace, locals: { account: @account }.merge(res.value) if res.success?
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
    res = LordOfWar::Marketplace::Service::ListingDetails.new(params[:id]).execute!

    erb :listing, layout: false, locals: res.value if res.success?
  end

  post '/listing-add' do
    res = LordOfWar::Marketplace::Service::CreateListing.new(
      params['title'],
      params['desc'],
      params['price'],
      params['category_id'],
      params['imgs'],
      @account.user.id
    ).execute!

    if res.success?
      query_string = request.referer.include?('?') ? request.referer.split('?').last : ''
      response.headers['HX-Redirect'] = "/marketplace?#{query_string}"

      partial :listing_form, listing: res.value[:listing], alert_type: res.alert_type, message: 'Anuncio creado!',
                             categories: res.value[:category_labels]
    else
      partial :listing_form, listing: res.value[:listing], alert_type: res.alert_type, message: res.error,
                             categories: res.value[:category_labels]
    end
  end

  delete '/listings/:id' do
  end
end
