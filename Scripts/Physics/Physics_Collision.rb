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
  # * Returns the relative velocity along the collision normal
  # * If equal or less than zero, objects are moving toward each other
  #--------------------------------------------------------------------------
  def velocity_along_normal
    relative_velocity = @body_b.velocity - @body_a.velocity
    Vector2.dot_product(relative_velocity, @normal)
  end
end
