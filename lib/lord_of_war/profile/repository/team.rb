class LordOfWar::Profile::Repository::Team
  def get_teams
    query = 'SELECT e.* FROM teams e'

    @db.execute(query).map { |rec| LordOfWar::Team.parse_json rec }
  end
end
