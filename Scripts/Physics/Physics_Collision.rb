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
  attr_reader :collider_hit
  attr_reader :object_hit
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(body_a, body_b, penetration, normal)
    @body_a = body_a
    @body_b = body_b
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
  # * Send Message to Colliders on collisions
  #--------------------------------------------------------------------------
  def on_collision_message(collider_a, collider_b)
    if @body_a.parent.respond_to?(:on_collision)
      @collider_hit = collider_b
      @object_hit = @body_b.parent
      @body_a.parent.on_collision(self)
    end
    if @body_b.parent.respond_to?(:on_collision)
      @collider_hit = collider_a
      @object_hit = @body_a.parent
      @body_b.parent.on_collision(self)
    end
  end
  #--------------------------------------------------------------------------
  # * Send Message to Colliders on triggers
  #--------------------------------------------------------------------------
  def on_trigger_message(collider_a, collider_b)
    if @body_a.parent.respond_to?(:on_trigger)
      @body_a.parent.on_trigger(collider_b)
    end
    if @body_b.parent.respond_to?(:on_trigger)
      @body_b.parent.on_trigger(collider_a)
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
end
