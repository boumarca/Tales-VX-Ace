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
  LAYER_GROUND  = 8
  #--------------------------------------------------------------------------
  # * Collision Bitmasks
  #--------------------------------------------------------------------------
  COLLISIONS_ALLY   = LAYER_ENEMY + LAYER_GROUND
  COLLISIONS_ENEMY  = LAYER_ALLY + LAYER_GROUND
  COLLISION_RUNNING = LAYER_GROUND
  #--------------------------------------------------------------------------
  # * Public members
  #--------------------------------------------------------------------------
  attr_accessor :velocity
  attr_accessor :restitution
  attr_accessor :force
  attr_accessor :parent
  attr_accessor :layer
  attr_accessor :collision_mask
  attr_accessor :static_friction
  attr_accessor :dynamic_friction
  attr_accessor :use_gravity
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
    @restitution = 0.2
    @position = Vector2.zero
    @force = Vector2.zero
    @layer = 0
    @static_friction = 0.5
    @dynamic_friction = 0.3
    @use_gravity = true
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
    j = collision.impulse_magnitude
    impulse = collision.normal * j
    apply_impulse(collision.body_a, collision.body_b, impulse)

#friction
    tangent = collision.relative_velocity - collision.normal * collision.velocity_along_normal
    tangent.normalize
    jt = -Vector2.dot_product(collision.relative_velocity, tangent)
    jt = jt / (collision.body_a.inverse_mass + collision.body_b.inverse_mass).to_f
    mu = Math.hypot(collision.body_a.static_friction, collision.body_a.static_friction)
    friction_impulse = Vector2.zero
    if jt.abs < j * mu
      friction_impulse = tangent * jt
    else
      dynamic_friction = Math.hypot(collision.body_a.dynamic_friction, collision.body_a.dynamic_friction)
      friction_impulse = tangent * j * dynamic_friction
    end
    collision.body_a.velocity -= friction_impulse * collision.body_a.inverse_mass
    collision.body_b.velocity += friction_impulse * collision.body_b.inverse_mass
  end
  #--------------------------------------------------------------------------
  # * Apply impulse
  #--------------------------------------------------------------------------
  def self.apply_impulse(body_a, body_b, impulse)
    mass_sum = body_a.mass + body_a.mass
    ratio = body_a.mass / mass_sum.to_f
    body_a.velocity -= impulse * ratio
    ratio = body_b.mass / mass_sum.to_f
    body_b.velocity += impulse * ratio
  end
  #--------------------------------------------------------------------------
  # * Correct interpenetration between bodies
  #--------------------------------------------------------------------------
  def self.positional_correction(collision)
    a = collision.body_a
    b = collision.body_b
    slop = [collision.penetration - PENETRATION_SLOP, 0].max
    linear_proj = slop / (a.inverse_mass + b.inverse_mass).to_f
    correction =  collision.normal * (linear_proj * PENETRATION_CORRECTION_PERCENT)
    a.position -= correction * a.inverse_mass
    b.position += correction * b.inverse_mass
  end
end
