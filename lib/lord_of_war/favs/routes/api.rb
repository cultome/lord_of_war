class LordOfWar::Favs::Routes::Api < Sinatra::Base
  helpers LordOfWar::Shared::Helpers

  set :views, VIEWS_FOLDER

  before do
    authenticate!
  end

  get '/favs' do
    res = LordOfWar::Favs::Service::DisplayFavs.new(
      @user.id,
      params['search'],
      params['categories'],
      params['min_price'],
      params['max_price'],
      params['page']
    ).execute!

    erb :favs, locals: { account: @account }.merge(res.value) if res.success?
  end

  delete '/favs/:id' do
    res = LordOfWar::Favs::Service::RemoveFav.new(
      params['id'],
      @user.id
    ).execute!

    res.value if res.success?
  end
end
