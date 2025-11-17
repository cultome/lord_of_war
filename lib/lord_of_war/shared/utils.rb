module LordOfWar::Shared::Utils
  def to_money_format(value)
    value.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
  end

  def password_complex_enough?(_value)
    # TODO: implement
    true
  end
end
