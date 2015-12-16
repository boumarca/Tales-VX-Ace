#==============================================================================
# ** Spriteset_LMBS
#------------------------------------------------------------------------------
#  This class brings together battle screen sprites. It's used within the
# Scene_LMBS class.
#==============================================================================

module LMBS
  class LMBS_Spriteset
    #--------------------------------------------------------------------------
    # * Object Initialization
    #--------------------------------------------------------------------------
    def initialize
      create_viewports
      create_battleback
      update
    end
    #--------------------------------------------------------------------------
    # * Create Viewport
    #--------------------------------------------------------------------------
    def create_viewports
      @viewport = Viewport.new
    end
    #--------------------------------------------------------------------------
    # * Create Battle Background Sprite
    #--------------------------------------------------------------------------
    def create_battleback
      @background = Sprite.new(@viewport)
      @background.bitmap = battleback_bitmap
      @background.z = 0
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
      dispose_battleback
      dispose_viewports
    end
    #--------------------------------------------------------------------------
    # * Free Battle Background (Floor) Sprite
    #--------------------------------------------------------------------------
    def dispose_battleback
      @background.bitmap.dispose
      @background.dispose
    end
    #--------------------------------------------------------------------------
    # * Free Viewport
    #--------------------------------------------------------------------------
    def dispose_viewports
      @viewport.dispose
    end
    #--------------------------------------------------------------------------
    # * Frame Update
    #--------------------------------------------------------------------------
    def update
      update_battleback
      update_viewports
    end
    #--------------------------------------------------------------------------
    # * Update Battle Background Sprite
    #--------------------------------------------------------------------------
    def update_battleback
      @background.update
    end
    #--------------------------------------------------------------------------
    # * Update Viewport
    #--------------------------------------------------------------------------
    def update_viewports
      @viewport.update
    end
  end
end
