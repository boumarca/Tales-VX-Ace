#==============================================================================
# ** LMBS_Battler
#------------------------------------------------------------------------------
#  This class handles battlers as a LMBS game object
#==============================================================================

module LMBS
  class LMBS_Battler
    #--------------------------------------------------------------------------
    # * Constants
    #--------------------------------------------------------------------------
    JUMP_FORCE = -280
    #--------------------------------------------------------------------------
    # * Public Members
    #--------------------------------------------------------------------------
    attr_reader :transform
    #--------------------------------------------------------------------------
    # * Object Initialization
    #--------------------------------------------------------------------------
    def initialize(viewport, game_battler)
      @viewport = viewport
      @game_battler = game_battler
      @facing_left = false
      @walk_speed = @game_battler.walk_speed
      @jumping = false
      @grounded = false
      create_states
      create_transform
      create_rigidbody
      create_battler_sprite
      create_input_controller
      @current_state = @states[:idle]
      @current_state.enter_state(self)
    end
    #--------------------------------------------------------------------------
    # * Create States
    #--------------------------------------------------------------------------
    def create_states
      @states = {}
      @states[:idle] = LMBS_IdleState.new(@game_battler.battle_animations[:idle])
      @states[:walking] = LMBS_WalkingState.new(@game_battler.battle_animations[:walking])
      @states[:guarding] = LMBS_GuardingState.new(@game_battler.battle_animations[:guarding])
      @states[:running] = LMBS_RunningState.new(@game_battler.battle_animations[:running])
      @states[:jump_up] = LMBS_JumpingUpState.new(@game_battler.battle_animations[:jump_up])
      @states[:jump_down] = LMBS_JumpingDownState.new(@game_battler.battle_animations[:jump_down])
    end
    #--------------------------------------------------------------------------
    # * Create Transform Component
    #--------------------------------------------------------------------------
    def create_transform
      @transform = LMBS_Transform.new(Vector2.new(rand(500) + 50, LMBS_SceneBattle::GROUND - @game_battler.aabb.height/2.0))
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
      hit = collision.object_hit
      if hit.is_a?(LMBS_Battler)
        @rigidbody.velocity.x = 0;
      elsif hit.is_a?(LMBS_Background)
        @rigidbody.velocity.y = 0;
        @grounded = true
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
    def update_command
      command = @controller.handle_input(@current_state.actions)
      if command
        command.execute(self)
      end
    end
    #--------------------------------------------------------------------------
    # * Update movement
    #--------------------------------------------------------------------------
    def update_movement
      if @jumping
        if @grounded
          change_state(@states[:idle])
          @jumping = false
        elsif @rigidbody.velocity.y > 0
          change_state(@states[:jump_down]) unless @current_state == @states[:jump_down]
        end
      end
    end
    #--------------------------------------------------------------------------
    # * Update sprite
    #--------------------------------------------------------------------------
    def update_sprite
      @sprite.move(@transform.position.x, @transform.position.y + @game_battler.aabb.height/2.0)
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
      change_state(@states[:idle]) unless @current_state == @states[:idle]
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
      change_state(@states[:walking]) unless @current_state == @states[:walking]
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
      change_state(@states[:running]) unless @current_state == @states[:running]
      modifier = facing_left ? -1 : 1
      @rigidbody.velocity.x = @walk_speed * 2 * modifier
      @rigidbody.layer = Physics_RigidBody::LAYER_RUNNING
      @rigidbody.collision_mask = Physics_RigidBody::COLLISIONS_RUNNING
    end
    #--------------------------------------------------------------------------
    # * Guard
    #--------------------------------------------------------------------------
    def guard
      change_state(@states[:guarding]) unless @current_state == @states[:guarding]
    end
    #--------------------------------------------------------------------------
    # * Jump
    #--------------------------------------------------------------------------
    def jump
      if !@jumping && @grounded
        @jumping = true
        @grounded = false
        @rigidbody.velocity.y += JUMP_FORCE
        change_state(@states[:jump_up])
      end
    end
  end
end
