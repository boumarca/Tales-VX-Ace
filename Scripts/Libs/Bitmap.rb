class Bitmap
  def initialize(filename); end
  def initialize(width, height); end
  def dispose; end
  def disposed?; end
  def width; end
  def height; end
  def rect; end
  def blt(x, y, src_bitmap, src_rect, opacity=255); end
  def stretch_blt(dest_rect, src_bitmap, src_rect, opacity=255); end
  def fill_rect(x, y, width, height, color); end
  def fill_rect(rect, color); end
  def gradient_fill_rect(x, y, width, height, color1, color2, vertical = false); end
  def gradient_fill_rect(rect, color1, color2, vertical = false); end
  def clear; end
  def clear_rect(x, y, width, height); end
  def clear_rect(rect); end
  def get_pixel(x,y); end
  def set_pixel(x, y, color); end
  def hue_change(hue); end
  def blur; end
  def radial_blur(angle, division); end
  def draw_text(x, y, width, height, str, align = 0); end
  def draw_text(rect, str, align = 0); end
  def text_size(str); end
  attr_accessor :font
end

