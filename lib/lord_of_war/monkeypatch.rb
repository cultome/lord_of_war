class Time
  def present?
    !blank?
  end

  def blank?
    false
  end
end

class Numeric
  def present?
    !blank?
  end

  def blank?
    false
  end
end

class String
  def present?
    !blank?
  end

  def blank?
    empty?
  end
end

class Hash
  def present?
    !blank?
  end

  def blank?
    empty?
  end
end

class Array
  def present?
    !blank?
  end

  def blank?
    empty?
  end
end

class NilClass
  def present?
    !blank?
  end

  def blank?
    true
  end
end
