class LordOfWar::Login::Repository::User
  def find_user_by_email(email)
    DB
      .execute('SELECT * FROM users where email = $1', [email])
      .map { |rec| LordOfWar::Login::Entity::User.parse_json rec }
      .first
  end
end
