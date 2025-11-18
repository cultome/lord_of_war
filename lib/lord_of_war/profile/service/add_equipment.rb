class LordOfWar::Profile::Service::AddEquipment
  include LordOfWar::Shared::Service::Responses
  include LordOfWar::Shared::Utils

  attr_accessor :kind, :name, :url, :user_id

  def initialize(kind, name, url, user_id)
    @kind = kind
    @name = name
    @url = url
    @user_id = user_id
  end

  def execute!
    preview_img_url = valid_url?(url) ? extract_preview_image(url) : nil

    equipment = equipment_store.add_equipment kind, name, url, user_id, preview_img_url
    success equipment
  end

  private

  def equipment_store
    @equipment_store ||= LordOfWar::Profile::Repository::Equipment.new
  end

  def extract_preview_image(url)
    res = HTTParty.get(
      url,
      headers: {
        'User-Agent' => 'Mozilla/5.0 (X11; Linux x86_64; rv:142.0) Gecko/20100101 Firefox/142.0',
        'Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
        'Accept-Language' => 'en-US,en;q=0.5',
        'Accept-Encoding' => 'gzip, deflate, br, zstd',
        'Upgrade-Insecure-Requests' => '1',
        'Sec-Fetch-Dest' => 'document',
        'Sec-Fetch-Mode' => 'navigate',
        'Sec-Fetch-Site' => 'same-site',
        'Connection' => 'keep-alive',
        'Priority' => 'u=0, i',
        'TE' => 'trailers',
      }
    )

    doc = Nokogiri::HTML res.body
    doc.at('meta[property="og:image"]')&.[]('content')
  end
end
