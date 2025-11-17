class LordOfWar::Profile::Service::DisplayProfile
  include LordOfWar::Shared::Service::Responses
  include LordOfWar::Shared::Utils

  def execute!
    teams = teams_store.get_teams

    success teams
  end

  private

  def teams_store
    @teams_store ||= LordOfWar::Profile::Repository::Team.new
  end
end
