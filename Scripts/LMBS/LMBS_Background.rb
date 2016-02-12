#==============================================================================
# ** LMBS_Background
#------------------------------------------------------------------------------
#  This class handles the battle background
#==============================================================================

module LMBS
  class LMBS_Background
    attr_accessor :transform
    #--------------------------------------------------------------------------
    # * Object Initialization
    #--------------------------------------------------------------------------
    def initialize(viewport)
      @viewport = viewport
      create_battleback
      @groundbody = Physics_RigidBody.new(self)
      @groundbody.aabb = Physics_AABB.new(Rect.new(0, 340, 640, 100))
      @groundbody.mass = 0
      @groundbody.use_gravity = false
      @transform = LMBS_Transform.new(Vector2.new(320, 390))
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
    # * Free
    #--------------------------------------------------------------------------
    def dispose
      @background.bitmap.dispose
      @background.dispose
    end
  end
end
