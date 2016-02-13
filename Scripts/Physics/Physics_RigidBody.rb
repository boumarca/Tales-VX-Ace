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
  #--------------------------------------------------------------------------
  # * Collision Bitmasks
  #--------------------------------------------------------------------------
  COLLISIONS_ALLY   = LAYER_ENEMY + LAYER_GROUND
  COLLISIONS_ENEMY  = LAYER_ALLY + LAYER_GROUND
  COLLISIONS_RUNNING = LAYER_GROUND
  COLLISIONS_GROUND = LAYER_ENEMY + LAYER_ALLY + LAYER_RUNNING
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
    @restitution = 0.0
    @position = Vector2.zero
    @force = Vector2.zero
    @layer = 0
    @collision_mask = 0
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
    if mass == 0.0
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
        collision = Physics_AABB.collision(body_a, body_b)
      elsif body_b.aabb.is_a?(Physics_Circle)
        collision = Physics_AABB.collision_circle(body_a, body_b)
      end
    elsif body_a.aabb.is_a(Physics_Circle)
      if body_b.aabb.is_a?(Physics_AABB)
        collision = Physics_AABB.collision_circle(body_b, body_a)
      elsif body_b.aabb.is_a?(Physics_Circle)
        collision = Physics_Circle.collision(body_a, body_b)
      end
    end
    return collision
  end
end
