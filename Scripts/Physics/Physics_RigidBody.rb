#==============================================================================
# ** Physics RigidBody
#------------------------------------------------------------------------------
#  This class handles rigid bodies and contains differents physical properties
#==============================================================================

class Physics_RigidBody
  #--------------------------------------------------------------------------
  # * Constants
  #--------------------------------------------------------------------------
  PENETRATION_CORRECTION_PERCENT = 0.2
  PENETRATION_SLOP = 0.01
  #--------------------------------------------------------------------------
  # * Collision Layers
  #--------------------------------------------------------------------------
  LAYER_ALLY    = 1
  LAYER_ENEMY   = 2
  LAYER_RUNNING = 4
  #--------------------------------------------------------------------------
  # * Collision Bitmasks
  #--------------------------------------------------------------------------
  COLLISIONS_ALLY   = LAYER_ENEMY
  COLLISIONS_ENEMY  = LAYER_ALLY
  COLLISION_RUNNING = 0
  #--------------------------------------------------------------------------
  # * Public members
  #--------------------------------------------------------------------------
  attr_accessor :velocity
  attr_accessor :restitution
  attr_accessor :force
  attr_accessor :parent
  attr_accessor :layer
  attr_accessor :collision_mask
  attr_reader   :aabb
  attr_reader   :position
  attr_reader   :mass
  attr_reader   :inverse_mass
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(parent)
    @parent = parent
    self.mass = 1
    @velocity = Vector2.zero
    @restitution = 0.1
    @position = Vector2.zero
    @force = Vector2.zero
    @layer = 0
    PhysicsManager.add_rigidbody(self)
  end
  #--------------------------------------------------------------------------
  # * Set Bounding box
  #--------------------------------------------------------------------------
  def aabb=(value)
    return if @aabb == value
    @aabb = value
    @aabb.position = @position
  end
  #--------------------------------------------------------------------------
  # * Set Position
  #--------------------------------------------------------------------------
  def position=(value)
    return if @position == value
    @position = value
    @aabb.position = @position
  end
  #--------------------------------------------------------------------------
  # * Set Mass
  #--------------------------------------------------------------------------
  def mass=(mass)
    @mass = mass
    if mass == 0
      @inverse_mass = 0
    else
      @inverse_mass = 1.0 / mass
    end
  end
  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------
  def dispose
    PhysicsManager.remove_rigidbody(self)
  end
  #--------------------------------------------------------------------------
  # * Determines if body collides
  # * Returns a collision definition if hit, nil if not
  #--------------------------------------------------------------------------
  def self.collision_detection(body_a, body_b)
    collision = nil
    if body_a.aabb.is_a?(Physics_AABB)
      if body_b.aabb.is_a?(Physics_AABB)
        collision = Physics_AABB.collision(body_a.aabb, body_b.aabb)
      elsif body_b.aabb.is_a?(Physics_Circle)
        collision = Physics_AABB.collision_circle(body_a.aabb, body_b.aabb)
      end
    elsif body_a.aabb.is_a(Physics_Circle)
      if body_b.aabb.is_a?(Physics_AABB)
        collision = Physics_AABB.collision_circle(body_b.aabb, body_a.aabb)
      elsif body_b.aabb.is_a?(Physics_Circle)
        collision = Physics_Circle.collision(body_a.aabb, body_b.aabb)
      end
    end
    if !collision.nil?
      collision.body_a = body_a
      collision.body_b = body_b
    end
    return collision
  end
  #--------------------------------------------------------------------------
  # * Resolves the collision by applying impulses
  #--------------------------------------------------------------------------
  def self.resolve_collision(collision)
    a = collision.body_a
    b = collision.body_b
    velocity_along_normal = collision.velocity_along_normal
    e = [a.restitution, b.restitution].min
    j = -(1 + e) * velocity_along_normal
    j /= a.inverse_mass + b.inverse_mass
    impulse = collision.normal * j
    mass_sum = a.mass + b.mass

    ratio = a.mass / mass_sum
    a.velocity -= impulse * ratio
    ratio = b.mass / mass_sum
    b.velocity += impulse * ratio
  end
  #--------------------------------------------------------------------------
  # * Correct interpenetration between bodies
  #--------------------------------------------------------------------------
  def self.positional_correction(collision)
    a = collision.body_a
    b = collision.body_b
    slop = [collision.penetration - PENETRATION_SLOP, 0].max
    linear_proj = slop / (a.inverse_mass + b.inverse_mass)
    correction =  collision.normal * (linear_proj * PENETRATION_CORRECTION_PERCENT)
    a.position -= correction * a.inverse_mass
    b.position += correction * b.inverse_mass
  end
end
