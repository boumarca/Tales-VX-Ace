#==============================================================================
# ** Game_BattlerLMBS
#------------------------------------------------------------------------------
#  This class handles battlers as a LMBS game object
#==============================================================================

module LMBS
  class LMBS_Battler
    #--------------------------------------------------------------------------
    # * Object Initialization
    #--------------------------------------------------------------------------
    def initialize(viewport)
      @viewport = viewport
      create_battler
      create_animator
    end
    #--------------------------------------------------------------------------
    # * Create Battle Background Sprite
    #--------------------------------------------------------------------------
    def create_battler
      @sprite = LMBS_SpriteBattler.new(@viewport)
      @sprite.ground
      @sprite.z = 0
    end
    #--------------------------------------------------------------------------
    # * Create Sprite Animator
    #--------------------------------------------------------------------------
    def create_animator
      @animator = LMBS_Animator.new
      @animator.sprite = @sprite
    end
    #--------------------------------------------------------------------------
    # * Get Battle Background Bitmap
    #--------------------------------------------------------------------------
    def battler_bitmap
      Cache.battler(battleback_name) if battleback_name
    end
    #--------------------------------------------------------------------------
    # * Get Filename of Battle Background
    #--------------------------------------------------------------------------
    def battleback_name
      return "Idle"
    end
    #--------------------------------------------------------------------------
    # * Free
    #--------------------------------------------------------------------------
    def dispose
      @sprite.bitmap.dispose
      @sprite.dispose
    end
    #--------------------------------------------------------------------------
    # * Update
    #--------------------------------------------------------------------------
    def update
      @sprite.update
    end
  end
end