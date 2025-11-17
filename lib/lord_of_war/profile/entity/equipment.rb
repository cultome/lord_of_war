class LordOfWar::Profile::Entity::Equipment
  attr_accessor :user_id, :kind, :name, :url

  def self.parse_json(rec)
    new rec['user_id'], rec['kind'], rec['name'], rec['url']
  end

  def initialize(user_id, kind, name, url)
    @user_id = user_id
    @kind = kind
    @name = name
    @url = url
  end
end
