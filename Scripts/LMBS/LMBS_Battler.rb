#==============================================================================
# ** LMBS_Battler
#------------------------------------------------------------------------------
#  This class handles battlers as a LMBS game object
#==============================================================================

module LMBS
  class LMBS_Battler
    attr_reader :transform
    #--------------------------------------------------------------------------
    # * Object Initialization
    #--------------------------------------------------------------------------
    def initialize(viewport, game_battler)
      @viewport = viewport
      @game_battler = game_battler
      @facing_left = false
      @walk_speed = @game_battler.walk_speed
      create_states
      create_transform
      create_rigidbody
      create_battler_sprite
      create_input_controller
      @current_state = @states[:Idle]
      @current_state.enter_state(self)
    end
    #--------------------------------------------------------------------------
    # * Create States
    #--------------------------------------------------------------------------
    def create_states
      @states = {}
      p @game_battler.battle_animations
      @states[:Idle] = LMBS_IdleState.new(@game_battler.battle_animations[:Idle])
      @states[:Walking] = LMBS_WalkingState.new(@game_battler.battle_animations[:Walking])
      @states[:Guarding] = LMBS_GuardingState.new(@game_battler.battle_animations[:Guarding])
      @states[:Running] = LMBS_RunningState.new(@game_battler.battle_animations[:Running])
    end
    #--------------------------------------------------------------------------
    # * Create Transform Component
    #--------------------------------------------------------------------------
    def create_transform
      @transform = LMBS_Transform.new(Vector2.new(rand(500) + 50, LMBS_SceneBattle::GROUND))
    end
    #--------------------------------------------------------------------------
    # * Create Battler Sprite
    #--------------------------------------------------------------------------
    def create_battler_sprite
      @sprite = LMBS_SpriteBattler.new(@viewport)
      @sprite.move(@transform.position.x,  @transform.position.y)
      @sprite.z = @transform.depth
    end
    #--------------------------------------------------------------------------
    # * Create Input Controller
    #--------------------------------------------------------------------------
    def create_input_controller
      if @game_battler.is_a?(Game_Actor)
        if @game_battler.battle_control == :manual
          @controller = LMBS_InputPlayer.new
        elsif @game_battler.battle_control == :auto
          @controller = LMBS_InputController.new
        end
      elsif @game_battler.is_a?(Game_Enemy)
        @controller = LMBS_InputController.new
      end
    end
    #--------------------------------------------------------------------------
    # * Create AABB
    #--------------------------------------------------------------------------
    def create_rigidbody
      @rigidbody = Physics_RigidBody.new(self)
      @rigidbody.aabb = Physics_AABB.new(aabb_rect)
      @rigidbody.position = Vector2.new(@transform.position.x, @transform.position.y)
      reset_layer
    end
    #--------------------------------------------------------------------------
    # * Get AABB rect
    #--------------------------------------------------------------------------
    def aabb_rect
      rect = @game_battler.aabb
      rect.x = @transform.position.x - rect.width*0.5
      rect.y = @transform.position.y - rect.height
      rect
    end
    #--------------------------------------------------------------------------
    # * Update AABB
    #--------------------------------------------------------------------------
    def update_aabb
      @rigidbody.move(aabb_rect)
    end
    #--------------------------------------------------------------------------
    # * Called when this object collides
    #--------------------------------------------------------------------------
    def on_collision(collision)
      if collision.object_hit.is_a?(LMBS_Battler)
        @rigidbody.velocity.x = 0;
      end
    end
    #--------------------------------------------------------------------------
    # * Free
    #--------------------------------------------------------------------------
    def dispose
      @rigidbody.dispose
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
    end
    #--------------------------------------------------------------------------
    # * Update sprite
    #--------------------------------------------------------------------------
    def update_sprite
      @sprite.move(@transform.position.x, @transform.position.y)
      @sprite.update
    end
    #--------------------------------------------------------------------------
    # * Change State
    #--------------------------------------------------------------------------
    def change_state(state)
      return if state.nil? || @current_state == state
      @current_state.exit_state(self)
      @current_state = state
      @current_state.enter_state(self)
    end
    #--------------------------------------------------------------------------
    # * Start animation
    #--------------------------------------------------------------------------
    def start_animation(animation)
      @sprite.start_animation(animation, @facing_left, true)
    end
    #--------------------------------------------------------------------------
    # * Reset Collision Layer
    #--------------------------------------------------------------------------
    def reset_layer
      if @game_battler.is_a?(Game_Actor)
        @rigidbody.layer = Physics_RigidBody::LAYER_ALLY
        @rigidbody.collision_mask = Physics_RigidBody::COLLISIONS_ALLY
      elsif @game_battler.is_a?(Game_Enemy)
        @rigidbody.layer = Physics_RigidBody::LAYER_ENEMY
        @rigidbody.collision_mask = Physics_RigidBody::COLLISIONS_ENEMY
      end
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
      @rigidbody.velocity.x = 0
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
      @rigidbody.velocity.x = @walk_speed * modifier
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
      @rigidbody.velocity.x = @walk_speed * 2 * modifier
      @rigidbody.layer = Physics_RigidBody::LAYER_RUNNING
      @rigidbody.collision_mask = Physics_RigidBody::COLLISION_RUNNING
    end
    #--------------------------------------------------------------------------
    # * Guard
    #--------------------------------------------------------------------------
    def guard
      change_state(@states[:Guarding]) unless @current_state == @states[:Guarding]
    end
  end
end
