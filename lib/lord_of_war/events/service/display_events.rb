class LordOfWar::Events::Service::DisplayEvents
  include LordOfWar::Shared::Service::Responses
  include LordOfWar::Shared::Utils

  attr_accessor :user_id, :month

  # @param month [String] In format yyyy-mm
  def initialize(user_id, month)
    @user_id = user_id
    @month = month
  end

  def execute!
    year, mnth = month.split('-').map(&:to_i)

    current_month = Date.new year, mnth, 1
    prev_month = current_month.prev_month
    next_month = current_month.next_month

    events = events_store.get_events user_id, current_month

    events_by_date = events
                     .map { |e| e.datetime.strftime('%Y-%m-%d') }
                     .group_by(&:itself)
                     .transform_values(&:size)

    success({
      section_title: 'Eventos de la comunidad',
      events: events,
      event: LordOfWar::Events::Entity::Event.parse_json({}),
      events_by_date: events_by_date,
      today: Time.now.strftime('%Y-%m-%d'),
      current_month_skips: current_month.wday,
      current_month_days: (next_month - current_month).to_i,
      current_month: current_month.strftime('%Y-%m'),
      prev_month: prev_month.strftime('%Y-%m'),
      next_month: next_month.strftime('%Y-%m'),
    })
  end

  private

  def events_store
    @events_store ||= LordOfWar::Events::Repository::Event.new
  end
end

