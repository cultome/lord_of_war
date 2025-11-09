module LordOfWar::Utils
  def audit_props(data_folder, products)
    puts '[*] Generating audit for properties'

    props = Hash.new { |h, k| h[k] = Set.new }
    products.each do |hsh|
      hsh.each do |key, value|
        props[key].add value
      end
    end

    props.each do |key, vals|
      CSV.open "#{data_folder}/audit_key_#{key}.csv", 'w' do |csv|
        csv << ['value']
        vals.map(&:to_json).sort.each { |val| csv << [val] }
      end
    rescue StandardError => e
      puts "[-] Error: #{e}"
      binding.pry
    end
  end

  def detect_category(value)
    vdc = value.downcase
    category = %w[misc consumable gear accessories replica].find do |cat|
      keyword_category[cat].any? { |cw| vdc.include? cw }
    end

    return 'unknown' if category.nil?

    category
  end

  def keyword_category
    @keyword_category ||= {
      'aeg' => 'replica',
      'ametralladora' => 'replica',
      'anilla rifle' => 'accessories',
      'anillas' => 'accessories',
      'audífonos' => 'gear',
      'balaklava' => 'gear',
      'barra de luz' => 'misc',
      'baston' => 'misc',
      'batería' => 'accessories',
      'battery' => 'accessories',
      'binoculares' => 'misc',
      'bipode' => 'misc',
      'bolso' => 'gear',
      'bolígrafo' => 'misc',
      'botas' => 'gear',
      'boxer' => 'misc',
      'brazalete' => 'misc',
      'brújula' => 'misc',
      'bufanda' => 'gear',
      'camisa' => 'gear',
      'cantimplora' => 'gear',
      'carabina' => 'replica',
      'careta' => 'gear',
      'cargador' => 'accessories',
      'casco' => 'gear',
      'chaleco' => 'gear',
      'chamarra' => 'gear',
      'cigarrera' => 'misc',
      'cinto' => 'gear',
      'cinturón' => 'gear',
      'coderas' => 'gear',
      'collar' => 'misc',
      'combat belt' => 'gear',
      'cuchillo' => 'misc',
      'cuerda' => 'gear',
      'detector de metales' => 'misc',
      'empuñadura' => 'accessories',
      'encendedor' => 'misc',
      'esposas' => 'misc',
      'ferrocerio' => 'misc',
      'fornitura' => 'gear',
      'funda' => 'gear',
      'gas pimienta' => 'misc',
      'gasa' => 'misc',
      'google' => 'gear',
      'gorro' => 'gear',
      'grip' => 'accessories',
      'guantes' => 'gear',
      'guardamanos' => 'accessories',
      'hacha' => 'misc',
      'headset' => 'gear',
      'helmet' => 'gear',
      'holster' => 'gear',
      'kit médico' => 'misc',
      'lapicero' => 'misc',
      'llavero' => 'misc',
      'láser' => 'accessories',
      'magazine' => 'accessories',
      'maleta' => 'gear',
      'mira' => 'accessories',
      'mochila' => 'gear',
      'monedero' => 'gear',
      'montura' => 'accessories',
      'montura de carro' => 'accessories',
      'mosquetón' => 'replica',
      'munición' => 'consumable',
      'navaja' => 'misc',
      'pala' => 'misc',
      'palestina' => 'gear',
      'pantalon' => 'gear',
      'parche' => 'misc',
      'parches' => 'misc',
      'pasamontañas' => 'gear',
      'pechera' => 'gear',
      'piernera' => 'gear',
      'pinzas' => 'misc',
      'pistol' => 'replica',
      'pistola' => 'replica',
      'pluma' => 'misc',
      'porta bastón' => 'gear',
      'porta cargador' => 'gear',
      'porta esposas' => 'gear',
      'porta fusil' => 'gear',
      'porta lampara' => 'gear',
      'pouch' => 'gear',
      'pulsera' => 'gear',
      'recuperador' => 'gear',
      'reloj' => 'gear',
      'resortera' => 'misc',
      'revolver' => 'replica',
      'riel carabina' => 'accessories',
      'riel de montura' => 'accessories',
      'riel picatinny' => 'accessories',
      'rieles laterales' => 'accessories',
      'rifle' => 'replica',
      'rodilleras' => 'gear',
      'réplica' => 'replica',
      'shemag' => 'gear',
      'silbato' => 'misc',
      'silla' => 'misc',
      'sobaquera' => 'gear',
      'soporte de linterna' => 'accessories',
      'speed loader' => 'misc',
      'sujetador' => 'gear',
      'taser' => 'misc',
      'termo' => 'misc',
      'tijeras' => 'misc',
      'torniquete' => 'gear',
      'unforme' => 'gear',
      'linterna' => 'accessories',
    }.each_with_object(Hash.new { |h, v| h[v] = [] }) do |(word, category), acc|
      acc[category] << word
    end
  end

  def clean_prop_name(name)
    name
      .downcase
      .gsub(/\s+/, '_')
      .gsub(/\W+/, '')
      .gsub(/[0-9]+/, '')
      .gsub(/_+/, '_')
      .gsub(/^_/, '')
      .gsub(/_$/, '')
      .gsub('_a_', '_')
      .gsub('_con_', '_')
      .gsub('_de_', '_')
      .gsub('_del_', '_')
      .gsub('_el_', '_')
      .gsub('_en_', '_')
      .gsub('_la_', '_')
      .gsub('_las_', '_')
      .gsub('_los_', '_')
      .gsub('_o_', '_')
      .gsub('_por_', '_')
      .gsub('_su_', '_')
      .gsub('_sus_', '_')
      .gsub('_y_', '_')
      .strip
  end

  def extract_title_info(value)
    props = {
      'category' => detect_category(value),
    }

    lx = licenses.select { |license| value =~ /#{license}/ }.uniq
    mx = makers.select { |maker| value =~ /#{maker}/ }.uniq

    return props if lx.empty? && mx.empty?

    props['license'] = lx unless lx.empty?
    props['maker'] = mx unless mx.empty?

    props
  end

  def licenses
    [
      'Barrett',
      'Black Rain Ordnance',
      'Colt',
      'Cybergun',
      'DYTAC',
      'Daniel Defense',
      'F-1',
      'FN Herstal',
      'GLOCK',
      'Genesis Arms',
      'KRISS USA',
      'Kalashnikov',
      'Magnum Research',
      'Noveske',
      'Rifle Dynamics',
      'SP Systems',
      'Salient Arms International',
      'Seekins Precision',
      'Sig Sauer',
      'SilencerCo',
      'Smith & Wesson',
      'Strike Industries',
      'Strike Industries',
      'Swiss Arms',
      'TTI',
      'Tanfoglio',
      'Taran Tactical Innovations',
      'Thompson',
    ]
  end

  def makers
    [
      '6mmProShop',
      'A&K',
      'ASG',
      'AW Custom',
      'Aegis Custom',
      'Arcturus',
      'Army',
      'Auto Ordnance',
      'CAA',
      'CYMA',
      'Classic Army',
      'Command Arms',
      'Cybergun',
      'Double Bell',
      'E&C',
      'EMG',
      'Elite Force',
      'ICS',
      'KWC',
      'OEM',
      'VFC',
      'CYMA',
      'DBoys',
      'DB',
      'Double Eagle',
      'DYTAC',
      'GHK',
      'SRC',
      'APS',
      'AW Custom',
      'G&P',
      'King Arms',
      'SLR',
      'Knights Armament Airsoft',
      'Evike',
      'G&G',
      'HFC',
      'Krytac',
      'KWA',
      'Matrix',
      'Golden Eagle',
      'Big Bang',
      'SOCOM Gear',
      'SoftAir',
      'Specna Arms',
      'Tokyo Marui',
      'Umarex',
      'WE Tech',
      'CQB Master',
      'WE-Tech USA',
    ]
  end
end
