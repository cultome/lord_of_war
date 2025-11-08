class LordOfWar::Pagination
  def prev?
    false
  end

  def next?
    true
  end

  def pages
    [
      [1, false],
      [2, false],
      [3, true],
      [4, false],
    ]
  end
end
