class LordOfWar::Product
  SINGLE_VALUE_PROP = %w[
    title
  ]

  def self.parse_json(rec)
    new rec
  end

  def initialize(rec)
    @props = rec
  end

  def single_value_prop?(name)
    SINGLE_VALUE_PROP.include? name
  end

  def method_missing(name, *args)
    prop = name.to_s

    return nil unless @props.key? prop

    if single_value_prop? prop
      return @props[prop] if @props[prop].is_a? String

      return @props[prop].first
    end

    @props[prop]
  rescue StandardError => e
    binding.pry
  end

  def specs?
    !specs.empty?
  end

  def specs
    {
      'License' => license,
      'Maker' => maker,
      'FPS range' => fps_range,
    }.compact
  end

  def price_amount
    return nil if @props['price'].blank?

    @props.dig 'price', 'amount'
  end

  def price
    return nil if @props['price'].blank?

    "$#{@props.dig "price", "amount"} #{@props.dig "price", "currency"}"
  end

  def fps_range
    return nil if @props['fps_range'].blank?

    "#{@props["fps_range"]} FPS"
  end

  def tags?
    !tags.empty?
  end

  def tags
    []
  end

  def list_img
    img.first || '/img/noproduct.png'
  end

  def license
    val = @props.fetch('license', []).join ', '

    val.empty? ? nil : val
  end

  def maker
    val = @props.fetch('maker', []).join ', '

    val.empty? ? nil : val
  end
end
