class LordOfWar::Shared::Entity::Pagination
  attr_reader :page_size, :page, :pages_in_pagination
  attr_accessor :page, :total_records

  def initialize(page)
    @page = page.blank? ? 1 : page.to_i
    @page_size = 48
    @pages_in_pagination = 4
    @total_records = 0
  end

  def display?
    @total_records > @page_size
  end

  def results_range
    os = (@page - 1) * @page_size

    [os, os + @page_size]
  end

  def prev?
    @total_records > 0 && @page > 1
  end

  def next?
    @total_records > 0 && @page <= @total_records / @page_size
  end

  def last_page
    (@total_records / @page_size) + 1
  end

  def pages
    max = [page + (pages_in_pagination / 2), last_page].min
    min = [page - (pages_in_pagination / 2), 1].max

    middle_pages = (min..max)
    res = middle_pages.map do |idx|
      [idx, idx == @page, false]
    end

    unless middle_pages.include? 1
      res.unshift [1, false, true]
      res.unshift [1, false, false]
    end

    unless middle_pages.include? last_page
      res.push [last_page, false, true]
      res.push [last_page, false, false]
    end

    res
  end
end
