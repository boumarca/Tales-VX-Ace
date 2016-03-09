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
    end
    #--------------------------------------------------------------------------
    # * Update On Command
    #--------------------------------------------------------------------------
    def update_command(battler)
    end
    #--------------------------------------------------------------------------
    # * Update On Collision
    #--------------------------------------------------------------------------
    def update_collision(battler, collision)
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
      @actions = [:attack, :jump, :guarding, :move, :idle]
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
      @actions = [:attack, :jump, :guarding, :move, :idle]
    end
    def update_command(battler)
      side = battler.facing_left ? -1 : 1
      battler.horizontal_velocity = battler.walk_speed * side
    end
  end
  #==============================================================================
  # * Running State
  #==============================================================================
  class LMBS_RunningState < LMBS_AnimationState
    def initialize(animation_id)
      super(animation_id)
      @actions = [:attack, :jump, :stop]
    end
    def enter_state(battler)
      super
      battler.running_layer
    end
    def exit_state(battler)
      battler.reset_layer
    end
    def update_collision(battler, collision)
      if collision.collider_hit.layer == Physics_LayerMask::LAYER_SIDES
        battler.stop
      end
    end
    def update_command(battler)
      side = battler.facing_left ? -1 : 1
      battler.horizontal_velocity = battler.walk_speed * side * 2
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
      battler.land if battler.grounded
    end
  end
  #==============================================================================
  # * Stop Run State
  #==============================================================================
  class LMBS_StoppingState < LMBS_AnimationState
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
  #==============================================================================
  # * Landing State
  #==============================================================================
  class LMBS_LandingState < LMBS_AnimationState
    LAND_TIME = 0.3
    def initialize(animation_id)
      super(animation_id)
      @actions = []
    end
    def enter_state(battler)
      super
      @start_time = Time.now
    end
    def update_movement(battler)
      if Time.now - @start_time >= LAND_TIME
        battler.idle
      end
    end
  end
  #==============================================================================
  # * Attacking State
  #==============================================================================
  class LMBS_AttackingState < LMBS_AnimationState
    def initialize(animation_id)
      super(animation_id)
      @actions = []
    end
  end
  #==============================================================================
  # * Attacking State
  #==============================================================================
  class LMBS_AttackCooldownState < LMBS_AnimationState
    COOLDOWN_TIME = 0.2
    def initialize(animation_id)
      @actions = []
    end
    def enter_state(battler)
      @start_time = Time.now
    end
    def exit_state(battler)
    end
    def update_movement(battler)
      if Time.now - @start_time >= COOLDOWN_TIME
        battler.idle
      end
    end
  end
end
