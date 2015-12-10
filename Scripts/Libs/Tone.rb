class Tone
  def initialize(red, green, blue, gray = 0); end
  def set(red, green, blue, gray = 0); end
  def set(tone); end
  attr_accessor :red
  attr_accessor :green
  attr_accessor :blue
  attr_accessor :gray
end