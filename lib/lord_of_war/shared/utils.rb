module LordOfWar::Shared::Utils
  def to_money_format(value)
    value.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
  end

  # Validates is value is a valid HTTP URL
  def valid_url?(value)
    uri = URI.parse value
    uri.is_a?(URI::HTTP) && !uri.host.nil?
  rescue URI::InvalidURIError
    false
  end

  # Verify if password is:
  # - longer or equal to 8 characters
  # - contains at least a uppercase letter
  # - contains at least a lowercase letter
  # - contains at least a number
  # - contains at least an special character
  #
  # Returns false otherwise
  def password_complex_enough?(value)
    return false if value.length < 8
    return false unless value =~ /[a-z]/        # lowercase
    return false unless value =~ /[A-Z]/        # uppercase
    return false unless value =~ /\d/           # numbers
    return false unless value =~ /[^A-Za-z0-9]/ # specials

    true
  end
end
