class LordOfWar::Shared::Repository::Login
  def find_user(user_id)
    DB
      .execute('SELECT * FROM users where id = $1', [user_id])
      .map { |rec| LordOfWar::Login::Entity::User.parse_json rec }
      .first
  end
end
