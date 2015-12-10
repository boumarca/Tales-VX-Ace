class Tilemap
  def initialize(viewport=nil); end
  def dispose; end
  def disposed?; end
  def update; end
  attr_accessor :bitmaps
  attr_accessor :map_data
  attr_accessor :flash_data
  attr_accessor :flags
  attr_accessor :viewport
  attr_accessor :visible
  attr_accessor :ox
  attr_accessor :oy
end