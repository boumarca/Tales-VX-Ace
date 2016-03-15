#==============================================================================
# ** Sprite_Battler
#------------------------------------------------------------------------------
#  This sprite is used to display battlers.
#==============================================================================

module LMBS
  class LMBS_SpriteBattler < Sprite_Base
    #--------------------------------------------------------------------------
    # * Object Initialization
    #--------------------------------------------------------------------------
    def initialize(viewport)
      super(viewport)
    end
    #--------------------------------------------------------------------------
    # * Override
    # * Start Animation
    #--------------------------------------------------------------------------
    def start_animation(animation, mirror = false, loop = false, stretch_last_frame = false, anim_end = nil)
      @anim_end = anim_end
      @stretch_last_frame = stretch_last_frame
      super(animation, mirror, loop)
    end
    #--------------------------------------------------------------------------
    # * Move sprite
    #--------------------------------------------------------------------------
    def move(x, y)
      self.x = x
      self.y = y
    end
    #--------------------------------------------------------------------------
    # * Override
    # * End Animation
    #--------------------------------------------------------------------------
    def end_animation
      @anim_end.call unless @anim_end.nil?
      dispose_animation unless @stretch_last_frame
    end
  end
end
