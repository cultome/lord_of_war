class LordOfWar::Pagination
  attr_reader :page_size, :page
  attr_accessor :page, :total_records

  def initialize(page)
    @page = page.blank? ? 1 : page.to_i
    @page_size = 48
    @total_records = 0
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

  def pages
    ((@total_records / @page_size) + 1).times.map do |idx|
      [idx + 1, idx + 1 == @page]
    end
  end
end
