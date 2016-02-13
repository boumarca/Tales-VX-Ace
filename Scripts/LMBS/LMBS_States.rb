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
  end

  #==============================================================================
  # * Idle State
  #==============================================================================
  class LMBS_IdleState < LMBS_AnimationState
    def initialize(animation_id)
      super(animation_id)
      @actions = [:jump, :guarding, :move, :idle]
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
  # * Running State
  #==============================================================================
  class LMBS_RunningState < LMBS_AnimationState
    def initialize(animation_id)
      super(animation_id)
      @actions = [:jump, :guarding, :move, :idle]
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
end
