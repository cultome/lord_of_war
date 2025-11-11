class Numeric
  def blank?
    false
  end
end

class String
  def blank?
    empty?
  end
end

class Hash
  def blank?
    empty?
  end
end

class Array
  def blank?
    empty?
  end
end

class NilClass
  def blank?
    true
  end
end
