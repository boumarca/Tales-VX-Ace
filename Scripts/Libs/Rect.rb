class Rect
  def initialize(x, y, width, height); end
  def initialize(x = 0, y = 0, width = 0 , height = 0); end
  def set(x, y, width, height); end
  def set(rect); end
  def empty; end
  attr_accessor :x
  attr_accessor :y
  attr_accessor :width
  attr_accessor :height
end