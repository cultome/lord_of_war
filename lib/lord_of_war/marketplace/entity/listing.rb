class LordOfWar::Marketplace::Entity::Listing
  attr_accessor :id, :title, :desc, :price, :category, :category_id, :imgs, :created_at, :created_by

  def self.parse_json(rec)
    obj = new(
      rec['title'],
      rec['desc'],
      rec['price'],
      rec['category_id']
    )

    obj.id = rec['id']
    obj.category = rec['category']
    obj.created_at = rec['created_at']
    obj.created_by = rec['created_by']
    obj.imgs = rec['imgs'].present? ? rec['imgs'] : []

    obj
  end

  def initialize(title, description, price, category_id, imgs = [])
    @title = title
    @desc = description
    @price = price
    @category_id = category_id
    @imgs = imgs
  end

  def list_img
    imgs.first
  end

  def price_amount
    @price
  end

  def price
    "$#{@price} MXN"
  end

  def search_corpus
    "#{title} #{desc} #{category}".downcase.tr 'áéíóú', 'aeiou'
  end
end
