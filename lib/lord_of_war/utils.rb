module LordOfWar::Utils
  def audit_props(data_folder, products)
    props = Hash.new { |h, k| h[k] = Set.new }
    products.each do |hsh|
      hsh.each do |key, value|
        [value]
        props[key].add value
        [value]
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
    lx = licenses.select { |license| value =~ /#{license}/ }.uniq
    mx = makers.select { |maker| value =~ /#{maker}/ }.uniq

    props = {}

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
