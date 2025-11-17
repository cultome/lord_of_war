module LordOfWar::Shared::Service::Responses
  class ServiceResponse
    attr_accessor :error, :alert_type, :value

    def initialize(value, error, alert_type)
      @value = value
      @error = error
      @alert_type = alert_type
    end

    def success?
      !@value.nil?
    end
  end

  def error_with_value(error, value, alert_type: 'danger')
    ServiceResponse.new value, error, alert_type
  end

  def error(error, alert_type: 'danger')
    ServiceResponse.new nil, error, alert_type
  end

  def success(value, alert_type: 'secondary')
    ServiceResponse.new value, nil, alert_type
  end

  def success_empty
    ServiceResponse.new '', nil, 'secondary'
  end
end
