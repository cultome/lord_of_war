class LordOfWar::Profile::Service::UpdateTeams
  include LordOfWar::Shared::Service::Responses
  include LordOfWar::Shared::Utils

  attr_accessor :teams, :user_id

  def initialize(teams, user_id)
    @teams = teams
    @user_id = user_id
  end

  def execute!
    my_teams = teams_store.sync_teams @teams, @user_id
    teams = teams_store.get_teams

    success({ teams: teams, my_teams: my_teams })
  end

  private

  def teams_store
    @teams_store ||= LordOfWar::Profile::Repository::Team.new
  end
end
