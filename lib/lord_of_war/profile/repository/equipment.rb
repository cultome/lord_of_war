class LordOfWar::Profile::Repository::Equipment
  def get_user_equipment_by_kind(user_id, kind)
    DB
      .execute('SELECT * FROM equipment WHERE user_id = $1 AND kind = $2', [user_id, kind])
      .map { |rec| LordOfWar::Profile::Entity::Equipment.parse_json rec }
  end

  def add_equipment(kind, name, url, user_id)
    DB
      .execute(
        'INSERT INTO equipment(id, user_id, kind, name, url) VALUES ($1, $2, $3, $4, $5) RETURNING *', 
        [SecureRandom.uuid, user_id, kind, name, url]
      )
      .map { |rec| LordOfWar::Profile::Entity::Equipment.parse_json rec }
      .first
  end

  def remove_equipment(id, user_id)
    DB.execute 'DELETE FROM equipment WHERE id = $1 AND user_id = $2', [id, user_id]
  end
end
