class Viewport
  def initialize(x, y, width, height); end
  def initialize(rect); end
  def initialize; end
  def dispose; end
  def disposed?; end
  def flash(color, duration); end
  def update; end
  attr_accessor :rect
  attr_accessor :visible
  attr_accessor :z
  attr_accessor :ox
  attr_accessor :oy
  attr_accessor :color
  attr_accessor :tone
end