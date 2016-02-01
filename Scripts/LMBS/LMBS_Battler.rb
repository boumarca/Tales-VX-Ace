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
      create_transform
      create_battler
      create_animator
      create_input_controller
    end
    #--------------------------------------------------------------------------
    # * Create Transform Component
    #--------------------------------------------------------------------------
    def create_transform
      @transform = LMBS_Transform.new
      @transform.x = 100
      @transform.y = LMBS_SceneBattle::GROUND
      @transform.z = 0
    end
    #--------------------------------------------------------------------------
    # * Create Battle Background Sprite
    #--------------------------------------------------------------------------
    def create_battler
      @sprite = LMBS_SpriteBattler.new(@viewport)
      @sprite.move_sprite(@transform.x,  @transform.y)
      @sprite.z = @transform.z
    end
    #--------------------------------------------------------------------------
    # * Create Sprite Animator
    #--------------------------------------------------------------------------
    def create_animator
      @animator = LMBS_Animator.new
      @animator.sprite = @sprite
    end
    #--------------------------------------------------------------------------
    # * Create Input Controller
    #--------------------------------------------------------------------------
    def create_input_controller
      @controller = LMBS_InputPlayer.new
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
      command = @controller.command
      if command
        command.execute(self)
      end
      @sprite.update
    end
    #--------------------------------------------------------------------------
    # * Idle
    #--------------------------------------------------------------------------
    def idle
      @animator.change_state(@animator.states[:Idle])
    end
    #--------------------------------------------------------------------------
    # * Walk Right
    #--------------------------------------------------------------------------
    def walk_right
      @animator.change_state(@animator.states[:Walking])
    end
  end
end