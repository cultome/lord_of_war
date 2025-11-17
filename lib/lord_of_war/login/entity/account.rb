class LordOfWar::Login::Entity::Account
  attr_reader :user

  def initialize(user:)
    @user = user
  end
end
