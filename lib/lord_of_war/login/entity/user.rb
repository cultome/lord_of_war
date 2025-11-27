class LordOfWar::Login::Entity::User
  attr_accessor :id, :email, :username, :password, :role

  def self.parse_json(rec)
    user = new rec['id'], rec['username'], rec['role']
    user.password = rec['password']
    user.email = rec['email']

    user
  end

  def initialize(id, username, role = 'regular')
    @id = id
    @username = username
    @role = role
  end
end
