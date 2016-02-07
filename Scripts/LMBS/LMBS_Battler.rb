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
    def initialize(viewport, game_battler)
      @viewport = viewport
      @game_battler = game_battler
      @current_state = nil
      @facing_left = false
      @walk_speed = @game_battler.walk_speed
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
      @states[:Idle] = LMBS_IdleState.new(@game_battler.battle_animations[:Idle])
      @states[:Walking] = LMBS_WalkingState.new(@game_battler.battle_animations[:Walking])
      @states[:Guarding] = LMBS_GuardingState.new(@game_battler.battle_animations[:Guarding])
      @states[:Running] = LMBS_RunningState.new(@game_battler.battle_animations[:Running])
    end
    #--------------------------------------------------------------------------
    # * Create Transform Component
    #--------------------------------------------------------------------------
    def create_transform
      @transform = LMBS_Transform.new
      @transform.x = rand(500) + 50
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
      if @game_battler.is_a?(Game_Actor)
        @controller = LMBS_InputPlayer.new 
      elsif @game_battler.is_a?(Game_Enemy)
        @controller = LMBS_InputController.new
      end
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
      walk(false)
    end
    #--------------------------------------------------------------------------
    # * Walk Left
    #--------------------------------------------------------------------------
    def walk_left
      walk(true)
    end
    #--------------------------------------------------------------------------
    # * Walk
    #--------------------------------------------------------------------------
    def walk(facing_left)
      update_facing(facing_left)
      change_state(@states[:Walking]) unless @current_state == @states[:Walking]
      modifier = facing_left ? -1 : 1
      @transform.x += @walk_speed * modifier
    end
    #--------------------------------------------------------------------------
    # * Run Right
    #--------------------------------------------------------------------------
    def run_right
      run(false)
    end
    #--------------------------------------------------------------------------
    # * Run Left
    #--------------------------------------------------------------------------
    def run_left
      run(true)
    end
    #--------------------------------------------------------------------------
    # * Run
    #--------------------------------------------------------------------------
    def run(facing_left)
      update_facing(facing_left)
      change_state(@states[:Running]) unless @current_state == @states[:Running]
      modifier = facing_left ? -1 : 1
      @transform.x += @walk_speed * 2 * modifier
    end
    #--------------------------------------------------------------------------
    # * Guard
    #--------------------------------------------------------------------------
    def guard
      change_state(@states[:Guarding]) unless @current_state == @states[:Guarding]
    end
  end
end