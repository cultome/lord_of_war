class LordOfWar::Profile::Repository::Profile
  def username_exists?(username)
    @db
      .execute('SELECT id FROM users where username like $1', [username])
      .map { |rec| rec['id'] }
      .first
      .present?
  end

  def update_password!(user_id, password)
    @db
      .execute('UPDATE users SET password = $1 WHERE id = $2 RETURNING id', [password, user_id])
      .map { |rec| rec['id'] }
      .first
      .present?
  end

  def update_username!(user_id, username)
    @db
      .execute('UPDATE users SET username = $1 WHERE id = $2 RETURNING id', [username, user_id])
      .map { |rec| rec['id'] }
      .first
      .present?
  end
end
