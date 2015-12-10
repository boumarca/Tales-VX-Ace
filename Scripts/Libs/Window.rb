class Window
  def initialize(x = 0, y = 0, width = 0, height = 0); end
  def dispose; end
  def disposed?; end
  def update; end
  def move(x, y, width, height); end
  def open?; end  
  def close?; end
  attr_accessor :windowskin
  attr_accessor :contents
  attr_accessor :cursor_rect
  attr_accessor :viewport
  attr_accessor :active
  attr_accessor :visible
  attr_accessor :arrows_visible
  attr_accessor :pause
  attr_accessor :x
  attr_accessor :y
  attr_accessor :width
  attr_accessor :height
  attr_accessor :z
  attr_accessor :ox
  attr_accessor :oy
  attr_accessor :padding
  attr_accessor :opacity
  attr_accessor :back_opacity
  attr_accessor :contents_opacity
  attr_accessor :openness
  attr_accessor :tone
end