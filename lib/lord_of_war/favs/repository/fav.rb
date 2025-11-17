class LordOfWar::Favs::Repository::Fav
  # def toggle_fav(product_id, user_id)
  #   existing_record = @db
  #                     .execute('SELECT product_id FROM favs WHERE product_id = $1 AND user_id = $2', [product_id, user_id])
  #                     .map { |rec| rec['product_id'] }
  #                     .first
  #
  #   if existing_record.nil?
  #     puts "[+] Inserting fav [#{product_id}] for [#{user_id}]..."
  #     @db.execute 'INSERT INTO favs(product_id, user_id) VALUES ($1, $2)', [product_id, user_id]
  #     true
  #   else
  #     remove_fav product_id, user_id
  #     false
  #   end
  # end

  # def remove_fav(product_id, user_id)
  #   puts "[+] Removing fav [#{product_id}] for [#{user_id}]..."
  #   @db.execute 'DELETE FROM favs WHERE product_id = $1 AND user_id = $2', [product_id, user_id]
  # end

  def get_favs(user_id)
    @db
      .execute('SELECT p.* FROM products p JOIN favs f ON f.product_id = p.id AND f.user_id = $1', [user_id])
      .map { |rec| LordOfWar::Product.parse_json rec }
  end

  # def filter_by_favs(products, user_id)
  #   prod_ids = products.map(&:id)
  #   ph = products.map.with_index { |_, idx| "$#{idx + 2}" }.join(',')
  #
  #   @db
  #     .execute("SELECT p.product_id FROM favs p WHERE p.user_id = $1 AND p.product_id IN (#{ph})", [user_id, *prod_ids])
  #     .each_with_object({}) { |rec, acc| acc[rec['product_id']] = true }
  # end
end
