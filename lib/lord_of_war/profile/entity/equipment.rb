class LordOfWar::Profile::Entity::Equipment
  attr_accessor :id, :user_id, :kind, :name, :url

  def self.empty
    new '', '', ''
  end

  def self.parse_json(rec)
    equipment = new rec['kind'], rec['name'], rec['url']
    equipment.user_id = rec['user_id']
    equipment.id = rec['id']

    equipment
  end

  def initialize(kind, name, url)
    @user_id = user_id
    @kind = kind
    @name = name
    @url = url
  end
end
