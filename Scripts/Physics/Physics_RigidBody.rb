#==============================================================================
# ** Physics RigidBody
#------------------------------------------------------------------------------
#  This class handles rigid bodies and contains differents physical properties
#==============================================================================

class Physics_RigidBody < Physics_Entity
  #--------------------------------------------------------------------------
  # * Public members
  #--------------------------------------------------------------------------
  attr_accessor :velocity
  attr_accessor :use_gravity
  attr_accessor :friction
  attr_reader   :restitution
  attr_reader   :forces
  attr_reader   :mass
  attr_reader   :inverse_mass
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(parent)
    super(parent)
    self.mass = 1
    @velocity = Vector2.zero
    @restitution = 0.0
    @forces = Vector2.zero
    @friction = 0.2
    @use_gravity = true
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
  # * Apply friction
  #--------------------------------------------------------------------------
  def apply_friction(coef_friction)
    speed = @velocity.length
    friction = Vector2.zero
    if coef_friction < speed
      friction = -(@velocity / speed) * coef_friction
    else
      friction = -@velocity
    end
    @velocity += friction
  end
  #--------------------------------------------------------------------------
  # * Update Forces
  #--------------------------------------------------------------------------
  def update_velocity
    gravity = @use_gravity ? PhysicsManager.gravity : Vector2.zero
    @velocity += (@forces * @inverse_mass + gravity) * (PhysicsManager::DELTA_TIME/2.0)
  end
  #--------------------------------------------------------------------------
  # * Update Rigidbody positions
  #--------------------------------------------------------------------------
  def update_position
    @position += @velocity * PhysicsManager::DELTA_TIME
    update_velocity
    reset_forces
  end
  #--------------------------------------------------------------------------
  # * Update Parent
  #--------------------------------------------------------------------------
  def update_parent
    @parent.transform.position = @position
  end
end
