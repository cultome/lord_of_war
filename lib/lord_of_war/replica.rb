class LordOfWar::Replica < LordOfWar::Product
  def specs
    {
      'Maker' => maker,
      'Speed' => speed,
      'FPS Range' => fps_range,
    }
  end

  def tags
    [maker, license]
  end

  def list_alt
    title
  end

  def list_img
    'https://dcdn-us.mitiendanube.com/stores/001/981/503/products/sa-18811-2-3b2ef090b367bf0f4117224767122462-480-0.webp'
  end

  def license
    'Daniel Defense'
  end

  def maker
    'Tokio Marui'
  end

  def fps_range
    '230-250'
  end

  def inner_barrel; end

  def speed; end

  def thread_direction; end

  def gearbox; end

  def motor; end

  def battery; end

  def hop_up; end
end
