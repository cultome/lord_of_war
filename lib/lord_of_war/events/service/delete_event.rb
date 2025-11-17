class LordOfWar::Events::Service::DeleteEvent
  include LordOfWar::Shared::Service::Responses
  include LordOfWar::Shared::Utils

  attr_accessor :id, :user_id

  def initialize(id, user_id)
    @id = id
    @user_id = user_id
  end

  def execute!
    if events_store.delete_event! id, user_id
      success 'Evento eliminado con exito'
    else
      error 'No puedes eliminar este evento!'
    end
  end

  private

  def events_store
    @events_store ||= LordOfWar::Events::Repository::Event.new
  end
end
