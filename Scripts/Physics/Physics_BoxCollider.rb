#==============================================================================
# ** Physics_BoxCollider
#------------------------------------------------------------------------------
#  This class handles Box containers and their collisions
#==============================================================================

class Physics_BoxCollider < Physics_Collider
  #--------------------------------------------------------------------------
  # * Public Members
  #--------------------------------------------------------------------------
  attr_reader :min
  attr_reader :max
  attr_reader :half_width
  attr_reader :half_height
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(rect)
    super()
    @min = Vector2.new(0, 0)
    @max = Vector2.new(rect.width, rect.height)
    compute_box
  end
  #--------------------------------------------------------------------------
  # * Compute Collider for optizimation
  #--------------------------------------------------------------------------
  def compute_box
    @half_width = (@max.x - @min.x) / 2.0
    @half_height = (@max.y - @min.y) / 2.0
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
  def self.collision(box_a, box_b)
    n = box_b.entity.position - box_a.entity.position
    x_overlap = box_a.half_width + box_b.half_width - (n.x).abs
    if(x_overlap > 0)
      y_overlap = box_a.half_height + box_b.half_height - (n.y).abs
      if(y_overlap > 0)
        if(x_overlap < y_overlap)
          normal = n.x < 0 ? Vector2.unit_x * -1 : Vector2.unit_x
          return Physics_Collision.new(box_a, box_b, x_overlap, normal)
        else
          normal = n.y < 0 ? Vector2.unit_y * -1 : Vector2.unit_y
          return Physics_Collision.new(box_a, box_b, y_overlap, normal)
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
  def self.collision_circle(box, circle)
    n = circle.position - box.position
    closest = n
    x_extent = (box.max.x - box.min.x) / 2.0
    y_extent = (box.max.y - box.min.y) / 2.0
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
    return new Physics_Collision.new(box.rigidbody, circle.rigidbody, penetration, -n) if inside
    return new Physics_Collision.new(box.rigidbody, circle.rigidbody, penetration, n)
  end
end
