#==============================================================================
# ** Physics RigidBody
#------------------------------------------------------------------------------
#  This class handles rigid bodies and contains differents physical properties
#==============================================================================

class Physics_RigidBody
  #--------------------------------------------------------------------------
  # * Public members
  #--------------------------------------------------------------------------
  attr_accessor :velocity
  attr_accessor :use_gravity
  attr_accessor :parent
  attr_accessor :static_friction
  attr_accessor :dynamic_friction
  attr_reader   :restitution
  attr_reader   :forces
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
    @restitution = 0.0
    @position = Vector2.zero
    @forces = Vector2.zero
    @static_friction = 0.2
    @use_gravity = true
    PhysicsManager.add_rigidbody(self)
  end
  #--------------------------------------------------------------------------
  # * Set Position
  #--------------------------------------------------------------------------
  def position=(value)
    return if @position == value
    @position = value
  end
  #--------------------------------------------------------------------------
  # * Set Mass
  #--------------------------------------------------------------------------
  def mass=(mass)
    @mass = mass
    if mass == 0.0
      @inverse_mass = 0
    else
      @inverse_mass = 1.0 / mass
    end
  end
  #--------------------------------------------------------------------------
  # * Add Force
  #--------------------------------------------------------------------------
  def add_force(force)
    @forces += force
  end
  #--------------------------------------------------------------------------
  # * Reset Forces
  #--------------------------------------------------------------------------
  def reset_forces
    @forces = Vector2.zero
  end
  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------
  def dispose
    PhysicsManager.remove_rigidbody(self)
  end
  #--------------------------------------------------------------------------
  # * Apply friction
  #--------------------------------------------------------------------------
  def apply_friction(coef_friction)
    #puts "---"
    #p coef_friction
    speed = @velocity.length
  #  p speed
    friction = Vector2.zero
    if coef_friction < speed
      friction = -(@velocity / speed) * coef_friction
    else
      friction = -@velocity
    end
  #  p friction
    @velocity += friction
  end
end
