class LordOfWar::Events::Service::CreateEvent
  include LordOfWar::Shared::Service::Responses
  include LordOfWar::Shared::Utils

  attr_accessor :title, :datetime, :place_name, :place_url, :desc, :user_id

  def initialize(title, datetime, place_name, place_url, desc, user_id)
    @title = title
    @datetime = datetime
    @place_name = place_name
    @place_url = place_url
    @desc = desc
    @user_id = user_id
  end

  def execute!
    evt = LordOfWar::Events::Entity::Event.new(
      title,
      datetime,
      place_name,
      place_url,
      desc,
      user_id
    )

    new_event_id = events_store.create_event evt

    if new_event_id.nil?
      res = error('Ocurrio un error al crear el evento')
      res.value = evt

      res
    else
      success(evt)
    end
  end

  private

  def events_store
    @events_store ||= LordOfWar::Events::Repository::Event.new
  end
end
