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
    def update_collision(battler)
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
  # * Jump Up State
  #==============================================================================
  class LMBS_JumpingUpState < LMBS_AnimationState
    def initialize(animation_id)
      super(animation_id)
      @actions = []
    end
    def enter_state(battler)
      super
      battler.vertical_velocity = LMBS_Battler::JUMP_FORCE   
    end
  end
  #==============================================================================
  # * Jump Down State
  #==============================================================================
  class LMBS_JumpingDownState < LMBS_AnimationState
    def initialize(animation_id)
      super(animation_id)
      @actions = []
    end
  end
  #==============================================================================
  # * Stop Run State
  #==============================================================================
  class LMBS_StopRunState < LMBS_AnimationState
    def initialize(animation_id)
      super(animation_id)
      @actions = []
    end
  end
end
