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
    attr_reader   :transform
    attr_reader   :facing_left
    attr_reader   :grounded
    attr_reader   :walk_speed
    #--------------------------------------------------------------------------
    # * Object Initialization
    #--------------------------------------------------------------------------
    def initialize(viewport, game_battler)
      @viewport = viewport
      @game_battler = game_battler
      @facing_left = false
      @walk_speed = @game_battler.walk_speed
      @grounded = false
      @loop_animation = true
      @stretch_last_frame = false
      @anim_end = nil
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
      @states[:jumping] = LMBS_JumpingState.new(@game_battler.battle_animations[:jumping])
      @states[:falling] = LMBS_FallingState.new(@game_battler.battle_animations[:falling])
      @states[:stopping] = LMBS_StoppingState.new(@game_battler.battle_animations[:stopping])
      @states[:landing] = LMBS_LandingState.new(@game_battler.battle_animations[:landing])
      @states[:attacking] = LMBS_AttackingState.new(@game_battler.battle_animations[:attack1])
      @states[:attack_cooldown] = LMBS_AttackCooldownState.new(@game_battler.battle_animations[:attack1])
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
      @sprite.move(@transform.position.x, @transform.position.y)
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
      @rigidbody.position = Vector2.new(@transform.position.x, @transform.position.y)
      @collider = Physics_BoxCollider.new(aabb_rect)
      @collider.rigidbody = @rigidbody
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
    # * Called when this object collides
    #--------------------------------------------------------------------------
    def on_collision(collision)
      if collision.object_hit.is_a?(LMBS_Battler)
        @rigidbody.velocity.x = 0;
      elsif collision.collider_hit.layer == Physics_LayerMask::LAYER_GROUND
        @rigidbody.velocity.y = 0;
        @grounded = true
      end
      @current_state.update_collision(self, collision)
    end
    #--------------------------------------------------------------------------
    # * Free
    #--------------------------------------------------------------------------
    def dispose
      @collider.dispose
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
      @current_state.update_command(self)
    end
    #--------------------------------------------------------------------------
    # * Update movement
    # * Refactor in update state
    #--------------------------------------------------------------------------
    def update_movement
      @current_state.update_movement(self)
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
      @sprite.start_animation(animation, @facing_left, @loop_animation, @stretch_last_frame, @anim_end)
    end
    #--------------------------------------------------------------------------
    # * Reset Collision Layer
    #--------------------------------------------------------------------------
    def reset_layer
      if @game_battler.is_a?(Game_Actor)
        @collider.layer = Physics_LayerMask::LAYER_ALLY
        @collider.collision_mask = Physics_LayerMask::COLLISIONS_ALLY
      elsif @game_battler.is_a?(Game_Enemy)
        @collider.layer = Physics_LayerMask::LAYER_ENEMY
        @collider.collision_mask = Physics_LayerMask::COLLISIONS_ENEMY
      end
    end
    #--------------------------------------------------------------------------
    # * Set Facing
    #--------------------------------------------------------------------------
    def facing_left=(facing_left)
      return if @facing_left == facing_left
      @facing_left = !@facing_left
      start_animation(@current_state.animation)
    end
    #--------------------------------------------------------------------------
    # * Set Horizontal Velocity
    #--------------------------------------------------------------------------
    def horizontal_velocity=(value)
      @rigidbody.velocity.x = value
    end
    #--------------------------------------------------------------------------
    # * Set Vertical Velocity
    #--------------------------------------------------------------------------
    def vertical_velocity=(value)
      @rigidbody.velocity.y = value
    end
    #--------------------------------------------------------------------------
    # * Is Moving Horizontal
    #--------------------------------------------------------------------------
    def moving_horizontal?
      @rigidbody.velocity.x != 0
    end
    #--------------------------------------------------------------------------
    # * Is Falling
    #--------------------------------------------------------------------------
    def falling?
      @rigidbody.velocity.y > 0
    end
    #--------------------------------------------------------------------------
    # * Set the battler on the runnig collision layers
    #--------------------------------------------------------------------------
    def running_layer
      @collider.layer = Physics_LayerMask::LAYER_RUNNING
      @collider.collision_mask = Physics_LayerMask::COLLISIONS_RUNNING
    end
    #--------------------------------------------------------------------------
    # * Idle
    #--------------------------------------------------------------------------
    def idle
      change_state(@states[:idle]) unless @current_state == @states[:idle]
    end
    #--------------------------------------------------------------------------
    # * Walk
    #--------------------------------------------------------------------------
    def walk(left)
      self.facing_left = left
      change_state(@states[:walking]) unless @current_state == @states[:walking]
    end
    #--------------------------------------------------------------------------
    # * Run
    #--------------------------------------------------------------------------
    def run(left)
      self.facing_left = left
      change_state(@states[:running]) unless @current_state == @states[:running]
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
      @grounded = false
      change_state(@states[:jumping])
    end
    #--------------------------------------------------------------------------
    # * Fall
    #--------------------------------------------------------------------------
    def fall
      change_state(@states[:falling])
    end
    #--------------------------------------------------------------------------
    # * Fall
    #--------------------------------------------------------------------------
    def land
      change_state(@states[:landing])
    end
    #--------------------------------------------------------------------------
    # * Stop Running
    #--------------------------------------------------------------------------
    def stop
      change_state(@states[:stopping]) unless @current_state == @states[:stopping]
    end
    #--------------------------------------------------------------------------
    # * Attack
    #--------------------------------------------------------------------------
    def attack
      @loop_animation = false
      @anim_end = method(:attack_cooldown)
      @stretch_last_frame = true
      change_state(@states[:attacking]) unless @current_state == @states[:attacking]
      @loop_animation = true
      @stretch_last_frame = false
      @anim_end = nil
    end
    #--------------------------------------------------------------------------
    # * Attack Cool down
    #--------------------------------------------------------------------------
    def attack_cooldown
      change_state(@states[:attack_cooldown])
    end
  end
end
