﻿#==============================================================================
# ** Physics RigidBody
#------------------------------------------------------------------------------
#  This class handles rigid bodies and contains differents physical properties
#==============================================================================

class Physics_RigidBody
  #--------------------------------------------------------------------------
  # * Collision Layers
  #--------------------------------------------------------------------------
  LAYER_ALLY    = 1
  LAYER_ENEMY   = 2
  LAYER_RUNNING = 4
  LAYER_GROUND  = 8
  LAYER_SIDES   = 16
  #--------------------------------------------------------------------------
  # * Collision Bitmasks
  #--------------------------------------------------------------------------
  COLLISIONS_ALLY    = LAYER_ENEMY + LAYER_GROUND + LAYER_SIDES
  COLLISIONS_ENEMY   = LAYER_ALLY + LAYER_GROUND + LAYER_SIDES
  COLLISIONS_RUNNING = LAYER_GROUND + LAYER_SIDES
  COLLISIONS_GROUND  = LAYER_ENEMY + LAYER_ALLY + LAYER_RUNNING
  COLLISIONS_SIDES   = LAYER_ENEMY + LAYER_ALLY + LAYER_RUNNING
  #--------------------------------------------------------------------------
  # * Public members
  #--------------------------------------------------------------------------
  attr_accessor :velocity
  attr_accessor :use_gravity
  attr_accessor :parent
  attr_accessor :layer
  attr_accessor :collision_mask
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
    @layer = 0
    @collision_mask = 0
    @static_friction = 0.2
    @dynamic_friction = 0.1
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
