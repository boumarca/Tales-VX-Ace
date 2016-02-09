#==============================================================================
# ** Physics RigidBody
#------------------------------------------------------------------------------
#  This class handles rigid bodies and contains differents physical properties
#==============================================================================

class Physics_RigidBody
  PENETRATION_CORRECTION_PERCERT = 0.2
  PENETRATION_SLOP = 0.01
  attr_accessor :velocity
  attr_reader :aabb
  attr_accessor :restitution
  attr_reader :position
  attr_reader   :mass
  attr_reader   :inverse_mass
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize 
    mass = 1
    @velocity = Vector2.new(0, 0)
    @restitution = 0.1
    @position = Vector2.new(0, 0)  
  end
  
  def move(rect)
    @aabb.move(rect)
  end
  
  def aabb=(value)
    return if @aabb == value
    @aabb = value
    @aabb.position = @position
  end
  
  def position=(value)    
    return if @position == value
    @position = value
    @aabb.position = @position
    
  end
    
  def mass=(mass)
    if mass == 0
      @inverse_mass = 0
    else
      @inverse_mass = 1 / mass
    end
  end
  
  def self.resolve_collision(collision)
    a = collision.body_a
    b = collision.body_b
    relative_velocity = b.velocity - a.velocity
    velocity_along_normal = Vector2.dot_product(relative_velocity, collision.normal)
    return if velocity_along_normal > 0
    
    e = [a.restitution, b.restitution].min
    j = -(1 + e) * velocity_along_normal
    j /= a.inverse_mass + b.inverse_mass 
    impulse = collision.normal * j  
    mass_sum = a.mass + b.mass
    
    ratio = a.mass / mass_sum
    a.velocity -= ratio * impulse
    ratio = b.mass / mass_sum
    b.velocity += ratio * impulse
  end
  
  def self.positional_correction(collision) 
    a = collision.body_a
    b = colllision.body_b 
    slop = [collision.penetration - PENETRATION_SLOP, 0].max
    linear_proj = slop / (a.inverse_mass + b.inverse_mass)
    correction =  linear_proj * PENETRATION_CORRECTION_PERSENT * normal
    a.position -= a.inverse_mass * correction
    b.position += b.inverse_mass * correction
  end
end