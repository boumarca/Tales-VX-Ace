#==============================================================================
# ** Physics AABB
#------------------------------------------------------------------------------
#  This class handles Axis-Aligned Bounding Box (AABB) and their collisions
#==============================================================================

class Physics_AABB
  #--------------------------------------------------------------------------
  # * Public Members
  #--------------------------------------------------------------------------
  attr_accessor :min
  attr_accessor :max
  attr_accessor :position
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(rect)
    @min = Vector2.new(0, 0)
    @max = Vector2.new(rect.width, rect.height)
  end
  #--------------------------------------------------------------------------
  # * Determines if two AABB collides with each other using SAT
  #--------------------------------------------------------------------------
  def self.simple_collision(a, b)
    return false if a.max.x < b.min.x || a.min.x > b.max.x
    return false if a.max.y < b.min.y || a.min.y > b.max.y
    return true
  end
  #--------------------------------------------------------------------------
  # * Determines if two AABB collides.
  # * Return a collision object including the collision details
  # * Returns nil if no collision.
  #--------------------------------------------------------------------------
  def self.collision(body_a, body_b)
    a = body_a.aabb
    b = body_b.aabb
    n = b.position - a.position
    a_extent_x = (a.max.x - a.min.x) / 2.0
    b_extent_x = (b.max.x - b.min.x) / 2.0
    x_overlap = a_extent_x + b_extent_x - (n.x).abs
    if(x_overlap > 0)
      a_extent_y = (a.max.y - a.min.y) / 2.0
      b_extent_y = (b.max.y - b.min.y) / 2.0
      y_overlap = a_extent_y + b_extent_y - (n.y).abs
      if(y_overlap > 0)
        if(x_overlap < y_overlap)
          normal = n.x < 0 ? Vector2.unit_x * -1 : Vector2.unit_x
          return Physics_Collision.new(body_a, body_b, x_overlap, normal)
        else
          normal = n.y < 0 ? Vector2.unit_y * -1 : Vector2.unit_y * 1
          return Physics_Collision.new(body_a, body_b, y_overlap, normal)
        end
      end
      return nil
    end
    return nil
  end
  #--------------------------------------------------------------------------
  # * Determines if an AABB collides with a circle.
  # * Return a collision object including the collision details
  # * Returns nil if no collision.
  #--------------------------------------------------------------------------
  def self.collision_circle(body_a, body_b)
    box = body_a.aabb
    circle = body_b.aabb
    n = circle.position - box.position
    closest = n
    x_extent = (box.aabb.max.x - box.aabb.min.x) / 2.0
    y_extent = (box.aabb.max.y - box.aabb.min.y) / 2.0
    closest.x = closest.x.clamp(-x_extent, x_extent)
    closest.y = closest.y.clamp(-y_extent, y_extent)
    inside = false

    if n == closest
      inside = true
       if n.x.abs > n.y.abs
         closest.x = closest.x > 0 ? x_extent : -x_extent
       else
         closest.y = closest.y > 0 ? y_extent : -y_extent
       end
    end

    normal = n - closest
    distance = normal.squared_length
    radius = circle.radius
    return nil if distance > radius*radius && !inside
    distance = Math.sqrt(distance)
    penetration = radius - distance
    return new Physics_Collision.new(body_a, body_b, penetration, -n) if inside
    return new Physics_Collision.new(body_a, body_b, penetration, n)
  end
end
