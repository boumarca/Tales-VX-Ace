#==============================================================================
# ** Physics Circle
#------------------------------------------------------------------------------
#  This class handles Circles and their collisions
#==============================================================================

class Physics_Circle
  attr_accessor :radius
  attr_accessor :position
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(position, radius)
    @position = position
    @radius = radius
  end
  #--------------------------------------------------------------------------
  # * Determines if two circles collides. 
  #--------------------------------------------------------------------------
  def self.simple_collision(a, b)
    x = a.x + b.x
    y = a.y + b.y
    r = a.radius + b.radius
    r*r < x*x + y*y
  end
  #--------------------------------------------------------------------------
  # * Determines if two circles collides. 
  # * Return a collision object including the collision details 
  # * Returns nil if no collision.
  #--------------------------------------------------------------------------
  def self.collision(a, b)
    n = b.position - a.position
    radii = a.radius + b.radius
    radii *= radii
    return nil if normal.squared_length > radii
    distance = normal.length
    if distance != 0
      penetration = radii - distance
      normal = Vector2.new(n.x / distance, n.y / distance)
      return Physics_Collision.new(a, b , penetration, normal)
    else
      return Physics_Collision.new(a, b , a.radius, Vector2::UNIT_X)
    end
  end
end