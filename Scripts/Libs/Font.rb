class Font
  def initialize(name = "MS PGothic", size = 22); end
  def self.exist?(name) end
  def self.default_name; end
  def self.default_name=(name); end
  def self.default_size; end
  def self.default_size=(size); end
  def self.default_bold; end
  def self.default_bold=(bool); end
  def self.default_italic; end
  def self.default_italic=(bool); end
  def self.default_shadow; end
  def self.default_shadow=(shadow); end
  def self.default_outline; end
  def self.default_outline=(outline); end
  def self.default_color; end
  def self.default_color=(color); end
  def self.default_out_color; end
  def self.default_out_color=(out_color); end
  attr_accessor :name
  attr_accessor :size
  attr_accessor :bold
  attr_accessor :italic
  attr_accessor :outline
  attr_accessor :shadow
  attr_accessor :color
end