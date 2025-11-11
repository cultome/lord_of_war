class LordOfWar::User
  attr_accessor :id, :email, :username, :password

  def self.parse_json(rec)
    user = new rec['id'], rec['username']
    user.password = rec['password']
    user.email = rec['email']

    user
  end

  def initialize(id, username)
    @id = id
    @username = username
  end
end
