class LordOfWar::Events::Repository::Event
  def create_event(event)
    query = <<~SQL
      INSERT INTO events(id, title, datetime, place_name, place_url, desc, created_by, created_at)
      VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
      RETURNING id
    SQL

    params = [
      SecureRandom.uuid,
      event.title,
      event.datetime.iso8601,
      event.place_name,
      event.place_url,
      event.desc,
      event.created_by,
      Time.now.iso8601,
    ]

    DB.execute(query, params).map { |rec| rec['id'] }.first
  end

  def get_events(_user_id, month)
    query = <<~SQL
      SELECT e.*
      FROM events e
      WHERE e.datetime >= $1 AND e.datetime <= $2
    SQL

    dt_start = "#{month.strftime "%Y-%m-%d"}T00:00:00-06:00"
    dt_end = "#{month.next_month.strftime "%Y-%m-%d"}T00:00:00-06:00"

    DB.execute(query, [dt_start, dt_end]).map { |rec| LordOfWar::Events::Entity::Event.parse_json rec }
  end

  def delete_event!(id, user_id)
    query = 'DELETE FROM events WHERE id = $1 AND created_by = $2 RETURNING id'

    DB.execute(query, [id, user_id]).map { |rec| rec['id'] }.first.present?
  end
end
