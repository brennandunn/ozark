class String
  def to_slug
    self.gsub!(/\W+/, ' ') # all non-word chars to spaces
    self.strip!            # ohh la la
    self.downcase!         #
    self.gsub!(/\ +/, '-') # spaces to dashes, preferred separator char everywhere
    self
  end
end


class Object
  def tap
    yield self; self;
  end
end