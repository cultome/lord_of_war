class LordOfWar::Home::Routes::Api < Sinatra::Base
  helpers LordOfWar::Shared::Helpers

  set :views, VIEWS_FOLDER

  before do
    authenticate!
  end

  get '/' do
    redirect to('/catalog')
  end
end
