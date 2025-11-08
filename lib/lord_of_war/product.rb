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

  def method_missing(name)
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
      license: license,
      maker: maker,
      fps_range: fps_range,
    }.compact
  end

  def tags?
    !tags.empty?
  end

  def tags
    []
  end

  def list_img
    return img if img.is_a? String

    return img.first if img.first.is_a? String

    img.first.first
  end

  def license
    val = @props.fetch('license', []).join ', '

    val.empty? ? nil : val
  end

  def maker
    val = @props.fetch('maker', []).join ', '

    val.empty? ? nil : val
  end

  def fps_range
    val = (@props.fetch('fps_range', []).first || {}).values_at('low', 'high').compact.join ' - '

    val.empty? ? nil : val
  end
end
