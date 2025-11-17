class LordOfWar::Profile::Repository::Profile
  def username_exists?(username)
    DB
      .execute('SELECT id FROM users where username like $1', [username])
      .map { |rec| rec['id'] }
      .first
      .present?
  end

  def update_password!(user_id, password)
    DB
      .execute('UPDATE users SET password = $1 WHERE id = $2 RETURNING id', [password, user_id])
      .map { |rec| rec['id'] }
      .first
      .present?
  end

  def update_username!(user_id, username)
    DB
      .execute('UPDATE users SET username = $1 WHERE id = $2 RETURNING id', [username, user_id])
      .map { |rec| rec['id'] }
      .first
      .present?
  end

  def update_emergency!(name, blood_type, contact_name, contact_phone, user_id)
    DB
      .execute(
        'UPDATE users SET real_name = $1, blood_type = $2, emergency_contact_name = $3, emergency_contact_phone = $4 WHERE id = $5 RETURNING id', 
        [name, blood_type, contact_name, contact_phone, user_id]
      ).map { |rec| rec['id'] }.first.present?
  end
end
