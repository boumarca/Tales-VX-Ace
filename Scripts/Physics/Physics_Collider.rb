#==============================================================================
# ** Physics Collider
#------------------------------------------------------------------------------
#  This super class handles collider and their collisions
#==============================================================================

class Physics_Collider
  #--------------------------------------------------------------------------
  # * Public Members
  #--------------------------------------------------------------------------
  attr_accessor :entity
  attr_accessor :layer
  attr_accessor :collision_mask
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    @layer = 0
    @collision_mask = 0
    PhysicsManager.add_collider(self)
  end
  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------
  def dispose
    PhysicsManager.remove_collider(self)
  end
  #--------------------------------------------------------------------------
  # * Determines if body collides
  # * Returns a collision definition if hit, nil if not
  #--------------------------------------------------------------------------
  def self.collision_detection(collider_a, collider_b)
    #collision = nil
    #if body_a.is_a?(Physics_BoxCollider)
    #  if body_b.is_a?(Physics_BoxCollider)
        collision = Physics_BoxCollider.collision(collider_a, collider_b)
    #  elsif body_b.is_a?(Physics_CircleCollider)
    #    collision = Physics_BoxCollider.collision_circle(body_a, body_b)
    #  end
    #elsif body_a.is_a(Physics_CircleCollider)
    #  if body_b.is_a?(Physics_BoxCollider)
    #    collision = Physics_BoxCollider.collision_circle(body_b, body_a)
    #  elsif body_b.is_a?(Physics_CircleCollider)
    #    collision = Physics_CircleCollider.collision(body_a, body_b)
    #  end
    #end
    return collision
  end
end
