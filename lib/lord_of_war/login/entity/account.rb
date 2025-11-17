class LordOfWar::Login::Entity::Account
  attr_reader :user, :emergency_information

  def self.parse_json(rec)
    user = LordOfWar::Login::Entity::User.parse_json rec
    emergency_info = LordOfWar::Login::Entity::EmergencyInformation.parse_json rec

    new user: user, emergency_information: emergency_info
  end

  def initialize(user:, emergency_information:)
    @user = user
    @emergency_information = emergency_information
  end
end
