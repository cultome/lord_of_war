class LordOfWar::Shared::Repository::Catalogs
  def category_labels
    @category_labels ||= DB
                         .execute('SELECT id, label_es FROM categories ORDER BY menu_order')
                         .each_with_object({}) { |rec, acc| acc[rec['id']] = rec['label_es'] }
  end
end
