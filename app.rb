class App < Sinatra::Base
  set :public_folder, './public'
  enable :sessions

  set :sessions, domain: 'localhost'
  set :session_secret, ENV.fetch('SESSION_SECRET') { SecureRandom.hex(64) }

  use LordOfWar::Login::Routes::Api
  use LordOfWar::Home::Routes::Api
  use LordOfWar::Catalog::Routes::Api
  use LordOfWar::Events::Routes::Api
  use LordOfWar::Favs::Routes::Api
  use LordOfWar::Marketplace::Routes::Api
  use LordOfWar::Profile::Routes::Api
end
