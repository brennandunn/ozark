class String
  def to_slug
    self.gsub(/\W+/, ' ').strip.downcase.gsub(/\ +/, '-')
  end
  
end


class Object
  def tap
    yield self; self;
  end
end