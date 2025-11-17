class LordOfWar::Profile::Repository::Team
  def get_teams
    query = 'SELECT e.* FROM teams e'

    DB.execute(query).map { |rec| LordOfWar::Profile::Entity::Team.parse_json rec }
  end
end
