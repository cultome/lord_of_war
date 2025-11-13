class LordOfWar::Listing
  attr_accessor :id, :search_corpus, :title, :desc, :price, :category, :category_id, :imgs

  def self.parse_json(rec)
    obj = new(
      rec['title'],
      rec['desc'],
      rec['price'],
      rec['category_id']
    )

    obj.id = rec['id']
    obj.category = rec['category']
    obj.imgs = rec['imgs'].present? ? rec['imgs'] : []

    obj
  end

  def initialize(title, description, price, category_id)
    @title = title
    @desc = description
    @price = price
    @category_id = category_id
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
