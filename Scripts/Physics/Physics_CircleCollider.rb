#==============================================================================
# ** Physics Circle
#------------------------------------------------------------------------------
#  This class handles Circles and their collisions
#==============================================================================

class Physics_CircleCollider < Physics_Collider
  #--------------------------------------------------------------------------
  # * Public Members
  #--------------------------------------------------------------------------
  attr_accessor :radius
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(radius)
    super()
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
  def self.collision(circle_a, circle_b)
    n = circle_b.rigidbody.position - circle_a.rigidbody.position
    radii = circle_a.radius + circle_b.radius
    radii *= radii
    return nil if normal.squared_length > radii
    distance = normal.length
    if distance != 0
      penetration = radii - distance
      normal = Vector2.new(n.x / distance, n.y / distance)
      return Physics_Collision.new(circle_a.rigidbody, circle_b.rigidbody, penetration, normal)
    else
      return Physics_Collision.new(circle_a.rigidbody, circle_b.rigidbody, circle_a.radius, Vector2.unit_x)
    end
  end
end
