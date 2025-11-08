class LordOfWar::Store::JsonStore
  def initialize(*files)
    data = files.flat_map do |file|
      File.readlines(file).flat_map { |line| JSON.parse line }
    end

    @products = data.map { |p| LordOfWar::Product.parse_json p }
  end

  def get_products(_filters)
    @products
  end
end
