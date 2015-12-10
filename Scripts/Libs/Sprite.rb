class Sprite
  def initialize(viewport=nil); end
  def dispose; end
  def disposed?; end
  def flash(color, duration); end
  def update; end
  def width; end
  def height; end
  attr_accessor :bitmap
  attr_accessor :src_rect
  attr_accessor :viewport
  attr_accessor :visible
  attr_accessor :x
  attr_accessor :y
  attr_accessor :z
  attr_accessor :ox
  attr_accessor :oy
  attr_accessor :zoom_x
  attr_accessor :zoom_y
  attr_accessor :angle
  attr_accessor :wave_amp
  attr_accessor :wave_length
  attr_accessor :wave_speed
  attr_accessor :wave_phase
  attr_accessor :mirror
  attr_accessor :bush_depth
  attr_accessor :bush_opacity
  attr_accessor :opacity
  attr_accessor :blend_type
  attr_accessor :color
  attr_accessor :tone
end