module Utils
  def fetch_or_create(table, value, db)
    return nil if value.blank?

    existing = db
               .execute("SELECT id FROM #{table} WHERE name = $1 LIMIT 1", [value])
               .map { |row| row['id'] }
               .first

    return existing unless existing.nil?

    db
      .execute("INSERT INTO #{table}(id, name) VALUES ($1, $2) RETURNING id", [SecureRandom.uuid, value])
      .map { |row| row['id'] }
      .first
  end

  def create_product_relation_if_required(table, column, product_id, other_id, db)
    existing = db
               .execute("SELECT product_id FROM #{table} WHERE product_id = $1 AND #{column} = $2 LIMIT 1", [product_id, other_id])
               .map { |row| row['product_id'] }
               .first

    return unless existing.nil?

    db.execute "INSERT INTO #{table}(product_id, #{column}) VALUES ($1, $2)", [product_id, other_id]
  end

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
    vdc = value.downcase.tr 'áéíóú', 'aeiou'
    category = %w[misc gear accessories consumable replica].find do |cat|
      keyword_category[cat].any? { |cw| vdc.match?(/\b#{cw}\b/) }
    end

    return 'unknown' if category.nil?

    category
  end

  def keyword_category
    @keyword_category ||= {
      # misc
      'adaptador' => 'misc',
      'agarre de goma' => 'misc',
      'barra de luz' => 'misc',
      'baston' => 'misc',
      'binoculares' => 'misc',
      'boligrafo' => 'misc',
      'bolsa' => 'misc',
      'boquilla' => 'misc',
      'boxer' => 'misc',
      'brazalete' => 'misc',
      'brujula' => 'misc',
      'bucking' => 'misc',
      'cabeza de cilindro' => 'misc',
      'cabeza de piston' => 'misc',
      'cabezal de piston' => 'misc',
      'cable' => 'misc',
      'caja de cambios' => 'misc',
      'calcetin' => 'misc',
      'calzas' => 'misc',
      'camara de hop-up' => 'misc',
      'capacidad variable' => 'misc',
      'cartucho' => 'misc',
      'cartuchos' => 'misc',
      'casquillos' => 'misc',
      'cigarrera' => 'misc',
      'cilindro' => 'misc',
      'collar' => 'misc',
      'compensator ' => 'misc',
      'conjunto' => 'misc',
      'corta flamas' => 'misc',
      'cubierta' => 'misc',
      'cuchillo' => 'misc',
      'culata' => 'misc',
      'detector de metales' => 'misc',
      'dispositivo ' => 'misc',
      'encendedor' => 'misc',
      'engranajes' => 'misc',
      'esposas' => 'misc',
      'estuche' => 'misc',
      'ferrocerio' => 'misc',
      'gas pimienta' => 'misc',
      'gasa' => 'misc',
      'gatillo' => 'misc',
      'gearbox' => 'misc',
      'grasa' => 'misc',
      'guia de resorte' => 'misc',
      'hacha' => 'misc',
      'hop-up' => 'misc',
      'juego' => 'misc',
      'kit medico' => 'misc',
      'kit' => 'misc',
      'lanyard' => 'misc',
      'lapicero' => 'misc',
      'lips de alimentacion' => 'misc',
      'llavero' => 'misc',
      'lubricante' => 'misc',
      'mejora' => 'misc',
      'motor' => 'misc',
      'navaja' => 'misc',
      'pala' => 'misc',
      'parche' => 'misc',
      'parches' => 'misc',
      'pasador de retencion' => 'misc',
      'pinzas' => 'misc',
      'piston' => 'misc',
      'piñon de acero' => 'misc',
      'placa' => 'misc',
      'pluma' => 'misc',
      'repuesto' => 'misc',
      'resorte' => 'misc',
      'resortera' => 'misc',
      'selector' => 'misc',
      'silbato' => 'misc',
      'silla' => 'misc',
      'sistema riel' => 'misc',
      'soporte' => 'misc',
      'speed loader' => 'misc',
      'spring' => 'misc',
      'tapa de rosca' => 'misc',
      'taser' => 'misc',
      'termo' => 'misc',
      'tijeras' => 'misc',
      'valvula de liberacion' => 'misc',
      'valvula' => 'misc',

      # replica
      'aeg' => 'replica',
      'ametralladora' => 'replica',
      'carabina' => 'replica',
      'pistol' => 'replica',
      'pistola' => 'replica',
      'revolver' => 'replica',
      'rifle' => 'replica',
      'replica' => 'replica',
      'fusil' => 'replica',

      # accessories
      'anilla rifle' => 'accessories',
      'anillas' => 'accessories',
      'bateria' => 'accessories',
      'battery' => 'accessories',
      'bipode' => 'accessories',
      'cargador' => 'accessories',
      'cañon' => 'accessories',
      'empuñadura' => 'accessories',
      'grip' => 'accessories',
      'guardamanos' => 'accessories',
      'hi-cap' => 'accessories',
      'laser' => 'accessories',
      'linterna' => 'accessories',
      'lampara' => 'accessories',
      'loading nozzle' => 'accessories',
      'mag' => 'accessories',
      'magazine' => 'accessories',
      'magbox' => 'accessories',
      'mira' => 'accessories',
      'montura de carro' => 'accessories',
      'montura' => 'accessories',
      'mosqueton' => 'accessories',
      'nozzle housing' => 'accessories',
      'riel carabina' => 'accessories',
      'riel de montura' => 'accessories',
      'riel picatinny' => 'accessories',
      'riel picatiny' => 'accessories',
      'rieles laterales' => 'accessories',
      'soporte de linterna' => 'accessories',
      'supresor' => 'accessories',
      'tubo amortiguador' => 'accessories',

      # gear
      'portafusibles' => 'gear',
      'sling' => 'gear',
      'audifonos' => 'gear',
      'balaklava' => 'gear',
      'bolso' => 'gear',
      'botas' => 'gear',
      'bufanda' => 'gear',
      'camisa' => 'gear',
      'cantimplora' => 'gear',
      'careta' => 'gear',
      'casco' => 'gear',
      'chaleco' => 'gear',
      'chamarra' => 'gear',
      'cinto' => 'gear',
      'cinturon' => 'gear',
      'coderas' => 'gear',
      'combat belt' => 'gear',
      'cuerda' => 'gear',
      'fornitura' => 'gear',
      'funda' => 'gear',
      'google' => 'gear',
      'gorro' => 'gear',
      'guantes' => 'gear',
      'headset' => 'gear',
      'helmet' => 'gear',
      'holster' => 'gear',
      'maleta' => 'gear',
      'mochila' => 'gear',
      'monedero' => 'gear',
      'palestina' => 'gear',
      'pantalon' => 'gear',
      'pasamontañas' => 'gear',
      'pechera' => 'gear',
      'piernera' => 'gear',
      'porta baston' => 'gear',
      'porta cargador' => 'gear',
      'porta esposas' => 'gear',
      'porta fusil' => 'gear',
      'porta lampara' => 'gear',
      'pouch' => 'gear',
      'pulsera' => 'gear',
      'recuperador' => 'gear',
      'reloj' => 'gear',
      'rodilleras' => 'gear',
      'shemag' => 'gear',
      'sobaquera' => 'gear',
      'sujetador' => 'gear',
      'torniquete' => 'gear',
      'unforme' => 'gear',

      # consumable
      'municion' => 'consumable',
      'bb' => 'consumable',
      'bbs' => 'consumable',
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

  def generate_search_corpus(rec, values)
    search_corpus = rec.slice(*values).reduce('') do |acc, val|
      if val.is_a? String
        acc + " #{val}"
      elsif val.is_a? Array
        acc + " #{val.join " "}"
      elsif val.is_a? Hash
        acc + " #{val.values.join " "}"
      end
    end

    search_corpus.downcase.tr('áéíóú', 'aeiou').strip
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
