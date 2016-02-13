#==============================================================================
# ** LMBS_Background
#------------------------------------------------------------------------------
#  This class handles the battle background
#==============================================================================

module LMBS
  class LMBS_Background
    #--------------------------------------------------------------------------
    # * Constants
    #--------------------------------------------------------------------------
    GROUND_X      = 320
    GROUND_Y      = 490
    GROUND_WIDTH  = 1280
    GROUND_HEIGHT = 300
    #--------------------------------------------------------------------------
    # * Public Members
    #--------------------------------------------------------------------------
    attr_accessor :transform
    #--------------------------------------------------------------------------
    # * Object Initialization
    #--------------------------------------------------------------------------
    def initialize(viewport)
      @viewport = viewport
      create_battleback
      create_transform

    end
    #--------------------------------------------------------------------------
    # * Create Transform
    #--------------------------------------------------------------------------
    def create_transform
      @transform = LMBS_Transform.new(Vector2.new(GROUND_X, GROUND_Y))
    end
    #--------------------------------------------------------------------------
    # * Create Rigidbody
    #--------------------------------------------------------------------------
    def create_rigidbody
      @groundbody = Physics_RigidBody.new(self)
      @groundbody.aabb = Physics_AABB.new(aabb)
      @groundbody.mass = 0
      @groundbody.use_gravity = false
      @groundbody.position = Vector2.new(@transform.position.x, @transform.position.y)
      @groundbody.layer = Physics_RigidBody::LAYER_GROUND
      @groundbody.collision_mask = Physics_RigidBody::COLLISIONS_GROUND
    end
    #--------------------------------------------------------------------------
    # * AABB Rect
    #--------------------------------------------------------------------------
    def aabb_rect
      Rect.new(0 ,0 , GROUND_WIDTH, GROUND_HEIGHT)
    end
    #--------------------------------------------------------------------------
    # * Create Battle Background Sprite
    #--------------------------------------------------------------------------
    def create_battleback
      @background = Sprite.new(@viewport)
      @background.bitmap = battleback_bitmap
      @background.z = -10
      center_sprite(@background)
    end
    #--------------------------------------------------------------------------
    # * Move Sprite to Screen Center
    #--------------------------------------------------------------------------
    def center_sprite(sprite)
      sprite.ox = sprite.bitmap.width / 2
      sprite.oy = sprite.bitmap.height / 2
      sprite.x = Graphics.width / 2
      sprite.y = Graphics.height / 2
    end
    #--------------------------------------------------------------------------
    # * Get Battle Background Bitmap
    #--------------------------------------------------------------------------
    def battleback_bitmap
      Cache.battleback1(battleback_name) if battleback_name
    end
    #--------------------------------------------------------------------------
    # * Get Filename of Battle Background
    #--------------------------------------------------------------------------
    def battleback_name
      return "BG1"
    end
    #--------------------------------------------------------------------------
    # * On Collsion
    #--------------------------------------------------------------------------
    def on_collision(collision)
    end
    #--------------------------------------------------------------------------
    # * Free
    #--------------------------------------------------------------------------
    def dispose
      @background.bitmap.dispose
      @background.dispose
    end
  end
end
