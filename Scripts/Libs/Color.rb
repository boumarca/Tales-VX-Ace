class Color
  def initialize(red, green, blue, alpha = 255); end
  def set(red, green, blue, alpha = nil) ; end
  def set(color); end
  attr_accessor :red
  attr_accessor :green
  attr_accessor :blue
  attr_accessor :alpha
end