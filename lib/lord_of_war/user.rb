class LordOfWar::User
  attr_reader :id, :username

  def self.parse_json(rec)
    new rec['id'], rec['username']
  end

  def initialize(id, username)
    @id = id
    @username = username
  end
end
