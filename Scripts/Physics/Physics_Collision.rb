#==============================================================================
# ** Physics_Manifold
#------------------------------------------------------------------------------
#  This class contains collision information
#==============================================================================

class Physics_Collision
  #--------------------------------------------------------------------------
  # * Constants
  #--------------------------------------------------------------------------
  PENETRATION_CORRECTION_PERCENT = 0.2
  PENETRATION_SLOP = 0.01
  #--------------------------------------------------------------------------
  # * Public Members
  #--------------------------------------------------------------------------
  attr_accessor :collider_hit
  attr_accessor :object_hit
  attr_reader :collider_a
  attr_reader :collider_b
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(collider_a, collider_b, penetration, normal)
    @collider_a = collider_a
    @collider_b = collider_b
    @body_a = collider_a.entity
    @body_b = collider_b.entity
    @penetration = penetration
    @normal = normal
  end
  #--------------------------------------------------------------------------
  # * Collision is a trigger ?
  #--------------------------------------------------------------------------
  def is_trigger?
    @body_a.is_trigger || @body_b.is_trigger
  end
  #--------------------------------------------------------------------------
  # * Returns the relative velocity
  #--------------------------------------------------------------------------
  def relative_velocity
    @body_b.velocity - @body_a.velocity
  end
  #--------------------------------------------------------------------------
  # * Returns the relative velocity along the collision normal
  # * If equal or less than zero, objects are moving toward each other
  #--------------------------------------------------------------------------
  def velocity_along_normal
    Vector2.dot_product(relative_velocity, @normal)
  end
  #--------------------------------------------------------------------------
  # * Send Message
  #--------------------------------------------------------------------------
  def send_message(trigger_message, collision_message)
    if is_trigger?
      on_trigger_message(trigger_message)
    else
      on_collision_message(collision_message)
    end
  end
  #--------------------------------------------------------------------------
  # * Send Message to Colliders on collisions
  #--------------------------------------------------------------------------
  def on_collision_message(message)
    collision_a = self.dup
    collision_b = self.dup
    if @body_a.parent.respond_to?(message)
      collision_a.collider_hit = @collider_b
      collision_a.object_hit = @body_b.parent
      @body_a.parent.send(message, collision_a)
    end
    if @body_b.parent.respond_to?(message)
      collision_b.collider_hit = @collider_a
      collision_b.object_hit = @body_a.parent
      @body_b.parent.send(message, collision_b)
    end
  end
  #--------------------------------------------------------------------------
  # * Send Message to Colliders on triggers
  #--------------------------------------------------------------------------
  def on_trigger_message(message)
    if @body_a.parent.respond_to?(message)
      @body_a.parent.send(message, @collider_b)
    end
    if @body_b.parent.respond_to?(message)
      @body_b.parent.send(message, @collider_a)
    end
  end
  #--------------------------------------------------------------------------
  # * Resolves the collision by applying impulses
  #--------------------------------------------------------------------------
  def resolve
    e = [@body_a.restitution, @body_b.restitution].min
    impulse_magnitude = -(1 + e) * velocity_along_normal
    impulse_magnitude /= @body_a.inverse_mass + @body_b.inverse_mass
    impulse = @normal * impulse_magnitude
    apply_impulse(impulse)
    @body_a.apply_friction(@body_b.friction)
    @body_b.apply_friction(@body_a.friction)
  end
  #--------------------------------------------------------------------------
  # * Apply impulse
  #--------------------------------------------------------------------------
  def apply_impulse(impulse)
    mass_sum = @body_a.mass + @body_b.mass
    ratio = @body_a.mass / mass_sum.to_f
    @body_a.velocity -= impulse * ratio
    ratio = @body_b.mass / mass_sum.to_f
    @body_b.velocity += impulse * ratio
  end
  #--------------------------------------------------------------------------
  # * Apply friction
  #--------------------------------------------------------------------------
  def apply_friction_impulse(friction_impulse)
    @body_a.velocity -= friction_impulse * @body_a.inverse_mass
    @body_b.velocity += friction_impulse * @body_b.inverse_mass
  end
  #--------------------------------------------------------------------------
  # * Correct interpenetration between bodies
  #--------------------------------------------------------------------------
  def positional_correction
    slop = [@penetration - PENETRATION_SLOP, 0].max
    linear_proj = slop / (@body_a.inverse_mass + @body_b.inverse_mass).to_f
    correction =  @normal * (linear_proj * PENETRATION_CORRECTION_PERCENT)
    @body_a.position -= correction * @body_a.inverse_mass
    @body_b.position += correction * @body_b.inverse_mass
  end
  #--------------------------------------------------------------------------
  # * Checks if two collisions have the same colliders
  #--------------------------------------------------------------------------
  def same_colliders(other)
    return true if @collider_a == other.collider_a && @collider_b == other.collider_b
    return true if @collider_a == other.collider_b && @collider_b == other.collider_a
    return false
  end
end
