class LordOfWar::Filters
  def initialize(categories: {})
    @categories = categories
  end

  def category?(name)
    @categories.include? name
  end
end
