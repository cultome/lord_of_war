class LordOfWar::Profile::Repository::Equipment
  def get_user_equipment_by_kind(user_id, kind)
    DB
      .execute('SELECT * FROM equipment WHERE user_id = $1 AND kind = $2', [user_id, kind])
      .map { |rec| LordOfWar::Profile::Entity::Equipment.parse_json rec }
  end
end
