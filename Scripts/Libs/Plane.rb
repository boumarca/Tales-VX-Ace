class Plane
  def initialize(viewport=nil);end
  def dispose; end
  def disposed?; end
  attr_accessor :bitmap
  attr_reader   :viewport
  attr_accessor :visible
  attr_accessor :z
  attr_accessor :ox
  attr_accessor :oy
  attr_accessor :zoom_x
  attr_accessor :zoom_y
  attr_accessor :opacity
  attr_accessor :blend_type
  attr_accessor :color
  attr_accessor :tone
end