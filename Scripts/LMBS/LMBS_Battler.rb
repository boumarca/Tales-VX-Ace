#==============================================================================
# ** LMBS_Battler
#------------------------------------------------------------------------------
#  This class handles battlers as a LMBS game object
#==============================================================================

module LMBS
  class LMBS_Battler
    #--------------------------------------------------------------------------
    # * Object Initialization
    #--------------------------------------------------------------------------
    def initialize(viewport, actor)
      @viewport = viewport
      @actor = actor
      @current_state = nil
      @facing_left = false
      @walk_speed = @actor.class.walk_speed
      create_states
      create_transform
      create_battler_sprite
      create_input_controller
      idle
    end
    #--------------------------------------------------------------------------
    # * Create States
    #--------------------------------------------------------------------------
    def create_states
      @states = {}
      @states[:Idle] = LMBS_IdleState.new(@actor.class.battle_animations[:Idle])
      @states[:Walking] = LMBS_WalkingState.new(@actor.class.battle_animations[:Walking])
      @states[:Guarding] = LMBS_GuardingState.new(@actor.class.battle_animations[:Guarding])
      @states[:Running] = LMBS_RunningState.new(@actor.class.battle_animations[:Running])
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
    # * Create Battler Sprite
    #--------------------------------------------------------------------------
    def create_battler_sprite
      @sprite = LMBS_SpriteBattler.new(@viewport)
      @sprite.move(@transform.x,  @transform.y)
      @sprite.z = @transform.z
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
      command = @controller.handle_input(@current_state.actions)
      if command
        command.execute(self)
      end
      update_sprite
    end
    #--------------------------------------------------------------------------
    # * Update sprite
    #-------------------------------------------------------------------------- 
    def update_sprite
      @sprite.move(@transform.x, @transform.y)
      @sprite.update
    end
    #--------------------------------------------------------------------------
    # * Change State
    #--------------------------------------------------------------------------
    def change_state(state)
      @current_state = state
      @current_state.enter_state(self)
    end
    #--------------------------------------------------------------------------
    # * Change State
    #--------------------------------------------------------------------------
    def start_animation(animation)
      @sprite.start_animation(animation, @facing_left, true)
    end
    #--------------------------------------------------------------------------
    # * Update Facing
    #--------------------------------------------------------------------------
    def update_facing(facing_left)
      return if @facing_left == facing_left
      @facing_left = !@facing_left
      start_animation(@current_state.animation)
    end
    #--------------------------------------------------------------------------
    # * Idle
    #--------------------------------------------------------------------------
    def idle
      change_state(@states[:Idle]) unless @current_state == @states[:Idle]
    end
    #--------------------------------------------------------------------------
    # * Walk Right
    #--------------------------------------------------------------------------
    def walk_right
      update_facing(false)
      change_state(@states[:Walking]) unless @current_state == @states[:Walking]
      @transform.x += @walk_speed
    end
    #--------------------------------------------------------------------------
    # * Walk Left
    #--------------------------------------------------------------------------
    def walk_left
      update_facing(true)
      change_state(@states[:Walking]) unless @current_state == @states[:Walking]
      @transform.x -= @walk_speed
    end
    #--------------------------------------------------------------------------
    # * Run Right
    #--------------------------------------------------------------------------
    def run_right
      update_facing(false)
      change_state(@states[:Running]) unless @current_state == @states[:Running]
      @transform.x += @walk_speed * 2
    end
    #--------------------------------------------------------------------------
    # * Run Left
    #--------------------------------------------------------------------------
    def run_left
      update_facing(true)
      change_state(@states[:Running]) unless @current_state == @states[:Running]
      @transform.x -= @walk_speed * 2
    end
    #--------------------------------------------------------------------------
    # * Guard
    #--------------------------------------------------------------------------
    def guard
      change_state(@states[:Guarding]) unless @current_state == @states[:Guarding]
    end
  end
end