#==============================================================================
# ** Vector2
#------------------------------------------------------------------------------
#  This struct handles Vectors in two dimensions
#==============================================================================

class Vector2
  #--------------------------------------------------------------------------
  # * Singleton Vectors
  #--------------------------------------------------------------------------
  def self.one;    Vector2.new(1, 1); end
  def self.unit_x; Vector2.new(1, 0); end
  def self.unit_y; Vector2.new(0, 1); end
  def self.zero;   Vector2.new(0, 0); end
  #--------------------------------------------------------------------------
  # * Public Members
  #--------------------------------------------------------------------------
  attr_accessor :x
  attr_accessor :y
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y)
    @x = x
    @y = y
  end
  #--------------------------------------------------------------------------
  # * Vector Addition
  #--------------------------------------------------------------------------
  def +(vector)
    Vector2.new(@x + vector.x, @y + vector.y)
  end
  #--------------------------------------------------------------------------
  # * Vector Subtraction
  #--------------------------------------------------------------------------
  def -(vector)
    Vector2.new(@x - vector.x, @y - vector.y)
  end
  #--------------------------------------------------------------------------
  # * Vector Subtraction
  #--------------------------------------------------------------------------
  def -@
    Vector2.new(-@x, -@y)
  end
  #--------------------------------------------------------------------------
  # * Scalar Multiplication
  #--------------------------------------------------------------------------
  def *(number)
    Vector2.new(@x * number, @y * number)
  end
  #--------------------------------------------------------------------------
  # * Scalar Division
  #--------------------------------------------------------------------------
  def /(number)
    Vector2.new(@x / number.to_f, @y / number.to_f)
  end
  #--------------------------------------------------------------------------
  # * Vector Equality
  #--------------------------------------------------------------------------
  def ==(vector)
    @x == vector.x && @y == vector.y
  end
  #--------------------------------------------------------------------------
  # * Returns the length of the vector
  #--------------------------------------------------------------------------
  def length
    return 0 if @x == 0 && @y == 0
    Math.hypot(@x, @y)
  end
  #--------------------------------------------------------------------------
  # * Returns the magnitude of the vector. Same as length
  #--------------------------------------------------------------------------
  def magintude
    length
  end
  #--------------------------------------------------------------------------
  # * Returns the squared length of the vector.
  #--------------------------------------------------------------------------
  def squared_length
    @x*@x + @y*@y
  end
  #--------------------------------------------------------------------------
  # * Returns the squared magnitude of the vector. Same as squared_length
  #--------------------------------------------------------------------------
  def squared_magnitude
    squared_length
  end
  #--------------------------------------------------------------------------
  # * Normalizes the vector
  #--------------------------------------------------------------------------
  def normalize
    len = length.to_f
    if len ==0
      @x = 0
      @y = 0
    else
      @x = @x / len
      @y = @y / len
    end
  end
  #--------------------------------------------------------------------------
  # * Returns the dot product between the two vectors
  #--------------------------------------------------------------------------
  def self.dot_product(a, b)
    a.x*b.x + a.y*b.y
  end
  #--------------------------------------------------------------------------
  # * Unit Tests
  #--------------------------------------------------------------------------
  def self.unit_tests
    p Math::DEGREES_TO_RADIANS
    p Math::RADIANS_TO_DEGREES
    a = Vector2.new(2, 4)
    b = Vector2.new(3, 2)
    sum = a + b
    puts sum == Vector2.new(5, 6)
    dif = a - b
    puts dif == Vector2.new(-1, 2)
    c = Vector2.new(3, 4)
    len = c.length
    puts len == 5
    sqlen = c.squared_length
    puts sqlen == 25
    d = Vector2.new(2, 0)
    puts d.normalize == Vector2.unit_x
    i = Vector2.unit_x
    j = Vector2.unit_y
    angle = Math.acos(Vector2.dot_product(i,j))
    puts angle * Math::RADIANS_TO_DEGREES == 90.0
    mul = a * 2
    puts mul == Vector2.new(4, 8)
    puts Vector2.zero
    puts Vector2.one
  end
end
