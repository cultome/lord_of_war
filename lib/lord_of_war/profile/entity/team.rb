class LordOfWar::Profile::Entity::Team
  attr_accessor :id, :name, :state, :page_url, :logo_url

  def self.parse_json(rec)
    obj = new rec['name']

    obj.id = rec['id']
    obj.state = rec['state']
    obj.page_url = rec['page_url']
    obj.logo_url = rec['logo_url']

    obj
  end

  def initialize(name)
    @name = name
  end
end
