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
  attr_accessor :body_a
  attr_accessor :body_b
  attr_accessor :penetration
  attr_accessor :normal
  attr_accessor :object_hit
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
  # * On Collision Triggers
  #--------------------------------------------------------------------------
  def on_collision_trigger
    @object_hit = @body_b.parent
    @body_a.parent.on_collision(self)
    @object_hit = @body_a.parent
    @body_b.parent.on_collision(self)
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

#friction
    tangent = relative_velocity - @normal * velocity_along_normal
    tangent.normalize
    tangent_magnitude = -Vector2.dot_product(relative_velocity, tangent)
    tangent_magnitude = tangent_magnitude / (@body_a.inverse_mass + @body_b.inverse_mass).to_f
    mu = Math.hypot(@body_a.static_friction, @body_a.static_friction)
    friction_impulse = Vector2.zero
    if tangent_magnitude.abs < impulse_magnitude * mu
      friction_impulse = tangent * tangent_magnitude
    else
      dynamic_friction = Math.hypot(@body_a.dynamic_friction, @body_a.dynamic_friction)
      friction_impulse = tangent * (impulse_magnitude * mu) * dynamic_friction
    end
    apply_friction_impulse(friction_impulse)
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
