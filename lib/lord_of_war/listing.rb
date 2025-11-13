class LordOfWar::Listing
  attr_accessor :id, :search_corpus, :title, :description, :price, :category, :imgs

  def self.parse_json(rec)
    obj = new(
      rec['title'],
      rec['description'],
      rec['price'],
      rec['category']
    )

    obj.id = rec['id']
    obj.imgs = rec['imgs'].present? ? rec['imgs'] : []

    obj
  end

  def initialize(title, description, price, category)
    @title = title
    @description = description
    @price = price
    @category = category
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
end
