class LordOfWar::Profile::Repository::Team
  def get_teams
    DB
      .execute('SELECT * FROM teams')
      .map { |rec| LordOfWar::Profile::Entity::Team.parse_json rec }
  end

  def get_user_teams(user_id)
    DB
      .execute('SELECT team_id FROM users_teams WHERE user_id = $1', [user_id])
      .map { |rec| rec['team_id'] }
  end

  def sync_teams(teams, user_id)
    DB.execute('DELETE FROM users_teams WHERE user_id = $1', [user_id])
      .map { |rec| LordOfWar::Profile::Entity::Team.parse_json rec }

    params = teams.flat_map { |team_id| [user_id, team_id] }
    ph = teams.map.with_index { |_, idx| "($#{(idx * 2) + 1}, $#{(idx * 2) + 2})" }.join(',')

    DB
      .execute(
        "INSERT INTO users_teams(user_id, team_id) VALUES #{ph} RETURNING team_id",
        params
      ).map { |rec| rec['team_id'] }
  end
end
