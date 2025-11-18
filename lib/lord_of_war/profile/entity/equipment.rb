class LordOfWar::Profile::Entity::Equipment
  attr_accessor :id, :user_id, :kind, :name, :url, :preview_img_url

  def self.empty
    new '', '', ''
  end

  def self.parse_json(rec)
    equipment = new rec['kind'], rec['name'], rec['url']
    equipment.user_id = rec['user_id']
    equipment.id = rec['id']
    equipment.preview_img_url = rec['preview_img_url']

    equipment
  end

  def initialize(kind, name, url)
    @user_id = user_id
    @kind = kind
    @name = name
    @url = url
  end
end
