class LordOfWar::Events::Entity::Event
  attr_accessor :title, :datetime, :place_name, :place_url, :desc, :created_by, :id, :created_at

  def self.parse_json(rec)
    obj = new(
      rec['title'],
      rec['datetime'].present? ? Time.parse(rec['datetime']) : nil,
      rec['place_name'],
      rec['place_url'],
      rec['desc'],
      rec['created_by']
    )

    obj.id = rec['id']
    obj.created_at = rec['created_at ']

    obj
  end

  def initialize(title, datetime, place_name, place_url, desc, created_by)
    @title = title

    if datetime.present?
      @datetime = if datetime.is_a? Time
                    datetime
                  else
                    Time.parse datetime
                  end
    end

    @place_name = place_name
    @place_url = place_url
    @desc = desc
    @created_by = created_by
  end
end
