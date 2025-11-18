module LordOfWar::Shared::Utils
  def to_money_format(value)
    value.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
  end

  def valid_url?(_url)
    # TODO: implement
    true
  end

  def password_complex_enough?(_value)
    # TODO: implement
    true
  end
end
