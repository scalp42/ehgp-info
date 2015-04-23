class String
  # returns +self+ surounded with +with+
  def surround(with)
    self.gsub /^|$/, with
  end

  # surrounds +self+ with +with+
  def surround!(with)
    self.gsub! /^|$/, with
  end
end
