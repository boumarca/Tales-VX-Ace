#==============================================================================
# ** LMBS_States
#------------------------------------------------------------------------------
#  This script contains the states of a battler
#==============================================================================

module LMBS
  #==============================================================================
  # ** State Superclass
  #==============================================================================
  class LMBS_AnimationState
    #--------------------------------------------------------------------------
    # * Object Initialization
    #--------------------------------------------------------------------------
    def initialize(animation_id)
      @animation = animation_id
    end
    #--------------------------------------------------------------------------
    # * Animation
    #--------------------------------------------------------------------------
    def animation
      $data_animations[@animation]
    end
    #--------------------------------------------------------------------------
    # * Actions possible in state
    #--------------------------------------------------------------------------
    def actions
      @actions
    end
    #--------------------------------------------------------------------------
    # * Enter State
    #--------------------------------------------------------------------------
    def enter_state(battler)
      battler.start_animation(animation)
    end
    #--------------------------------------------------------------------------
    # * Exit State
    #--------------------------------------------------------------------------
    def exit_state(battler)
      battler.reset_layer
    end
    #--------------------------------------------------------------------------
    # * Update On Command
    #--------------------------------------------------------------------------
    def update_command(battler)
    end
    #--------------------------------------------------------------------------
    # * Update On Collision
    #--------------------------------------------------------------------------
    def update_collision(battler, hit)
    end
    #--------------------------------------------------------------------------
    # * Update On Movement
    #--------------------------------------------------------------------------
    def update_movement(battler)
    end
  end

  #==============================================================================
  # * Idle State
  #==============================================================================
  class LMBS_IdleState < LMBS_AnimationState
    def initialize(animation_id)
      super(animation_id)
      @actions = [:jump, :guarding, :move, :idle]
    end
    def enter_state(battler)
      super
      battler.horizontal_velocity = 0
    end
  end
  #==============================================================================
  # * Walking State
  #==============================================================================
  class LMBS_WalkingState < LMBS_AnimationState
    def initialize(animation_id)
      super(animation_id)
      @actions = [:jump, :guarding, :move, :idle]
    end
    def update_command(battler)
      modifier = battler.facing_left ? -1 : 1
      battler.horizontal_velocity = battler.walk_speed * modifier
    end
  end
  #==============================================================================
  # * Running State
  #==============================================================================
  class LMBS_RunningState < LMBS_AnimationState
    def initialize(animation_id)
      super(animation_id)
      @actions = [:jump, :stop]
    end
    def enter_state(battler)
      super
      battler.running_layer
    end
    def update_collision(battler, hit)
      if hit.rigidbody.layer == Physics_RigidBody::LAYER_SIDES
        battler.stop_run
      end
    end
    def update_command(battler)
      modifier = battler.facing_left ? -1 : 1
      battler.horizontal_velocity = battler.walk_speed * modifier * 2
    end
  end
  #==============================================================================
  # * Guarding State
  #==============================================================================
  class LMBS_GuardingState < LMBS_AnimationState
    def initialize(animation_id)
      super(animation_id)
      @actions = [:jump, :guarding, :idle]
    end
  end
  #==============================================================================
  # * Jump State
  #==============================================================================
  class LMBS_JumpingState < LMBS_AnimationState
    def initialize(animation_id)
      super(animation_id)
      @actions = []
    end
    def enter_state(battler)
      super
      battler.vertical_velocity = LMBS_Battler::JUMP_FORCE
    end
    def update_movement(battler)
      battler.fall if battler.falling?
    end
  end
  #==============================================================================
  # * Falling State
  #==============================================================================
  class LMBS_FallingState < LMBS_AnimationState
    def initialize(animation_id)
      super(animation_id)
      @actions = []
    end
    def update_movement(battler)
      battler.idle if battler.grounded
    end
  end
  #==============================================================================
  # * Stop Run State
  #==============================================================================
  class LMBS_StopRunState < LMBS_AnimationState
    STOP_TIME = 0.3
    def initialize(animation_id)
      super(animation_id)
      @actions = []
    end
    def enter_state(battler)
      super
      @start_time = Time.now
    end
    def update_movement(battler)
      if !battler.moving_horizontal? && Time.now - @start_time >= STOP_TIME
        battler.idle
      end
    end
  end
end
