class LordOfWar::Catalog::Routes::Api < Sinatra::Base
  helpers LordOfWar::Shared::Helpers

  set :views, VIEWS_FOLDER

  before do
    authenticate!
  end

  get '/edit/:id' do
    res = LordOfWar::Catalog::Service::DisplayProduct.new(params[:id]).execute!
    partial :edit_product, **res.value
  end

  get '/catalog' do
    res = LordOfWar::Catalog::Service::DisplayCatalog.new(
      @user.id,
      params['search'],
      params['categories'],
      params['min_price'],
      params['max_price'],
      params['page']
    ).execute!

    erb :catalog, locals: { account: @account }.merge(res.value) if res.success?
  end

  post '/fav-toggle/:id' do
    res = LordOfWar::Catalog::Service::ToggleFav.new(
      params['id'],
      @user.id
    ).execute!

    partial :fav_button, res.value if res.success?
  end
end
