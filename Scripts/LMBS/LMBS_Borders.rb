#==============================================================================
# ** LMBS_Borders
#------------------------------------------------------------------------------
#  This class handles the battle borders
#==============================================================================

module LMBS
  class LMBS_Borders
    #--------------------------------------------------------------------------
    # * Public Members
    #--------------------------------------------------------------------------
    attr_accessor :transform
    attr_reader   :rigidbody
    #--------------------------------------------------------------------------
    # * Object Initialization
    #--------------------------------------------------------------------------
    def initialize(x, y, width, height)
      @transform = LMBS_Transform.new(Vector2.new(x, y))
      @rigidbody = Physics_RigidBody.new(self)
      @rigidbody.aabb = Physics_AABB.new(Rect.new(0 ,0 , width, height))
      @rigidbody.mass = 0
      @rigidbody.use_gravity = false
      @rigidbody.position = Vector2.new(@transform.position.x, @transform.position.y)
    end
    #--------------------------------------------------------------------------
    # * Set Layers
    #--------------------------------------------------------------------------
    def layers(layer, collision_mask)
      @rigidbody.layer = layer
      @rigidbody.collision_mask = collision_mask
    end
    #--------------------------------------------------------------------------
    # * Set Friction
    #--------------------------------------------------------------------------
    def friction(static)
      @rigidbody.static_friction = static
    end
  end
end
