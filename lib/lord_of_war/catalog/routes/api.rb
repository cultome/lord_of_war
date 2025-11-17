class LordOfWar::Catalog::Routes::Api < Sinatra::Base
  helpers LordOfWar::Shared::Helpers

  set :views, VIEWS_FOLDER

  before do
    authenticate!
  end

  get '/catalog' do
    res = LordOfWar::Catalog::Service::DisplayCatalog.new(
      @user.id,
      params['search'],
      params['categories'],
      params['min_price'],
      params['max_price'],
      params['page'],
    ).execute!

    if res.success?
      erb(:catalog, locals: { account: @account }.merge(res.value))
    else
    end
  end

  post '/fav-toggle/:id' do
    res = LordOfWar::Catalog::Service::ToggleFav.new(
      params['id'],
      @user.id,
    ).execute!

    if res.success?
      partial :fav_button, res.value
    else
    end
  end

  private

  def product_store
    @product_store ||= LordOfWar::Catalog::Repository::Product.new
  end
end
