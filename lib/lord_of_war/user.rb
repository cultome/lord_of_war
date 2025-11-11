class LordOfWar::User
  attr_accessor :id, :username, :password

  def self.parse_json(rec)
    user = new rec['id'], rec['username']
    user.password = rec['password']

    user
  end

  def initialize(id, username)
    @id = id
    @username = username
  end
end
