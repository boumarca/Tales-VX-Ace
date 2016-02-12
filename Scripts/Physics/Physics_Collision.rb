#==============================================================================
# ** Physics_Manifold
#------------------------------------------------------------------------------
#  This class contains collision information
#==============================================================================

class Physics_Collision
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
  # * Returns the impulse magnitude
  #--------------------------------------------------------------------------
  def impulse_magnitude
    e = [@body_a.restitution, @body_b.restitution].min
    j = -(1 + e) * velocity_along_normal
    j /= @body_a.inverse_mass + @body_b.inverse_mass
  end
end
