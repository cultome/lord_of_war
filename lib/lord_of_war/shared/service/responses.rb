module LordOfWar::Shared::Service::Responses
  class ServiceResponse
    attr_accessor :error, :error_type, :value

    def initialize(value, error, error_type)
      @value = value
      @error = error
      @error_type = error_type
    end

    def success?
      !@value.nil?
    end
  end

  def error(error, error_type: 'danger')
    ServiceResponse.new nil, error, error_type
  end

  def success(value)
    ServiceResponse.new value, nil, nil
  end
end
