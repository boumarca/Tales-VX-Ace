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
  end
  
  #==============================================================================
  # * Idle State
  #============================================================================== 
  class LMBS_IdleState < LMBS_AnimationState
    def initialize(animation_id)
      super(animation_id)
      @actions = [:Guarding, :Move, :Idle]
    end
  end
  #==============================================================================
  # * Walking State
  #============================================================================== 
  class LMBS_WalkingState < LMBS_AnimationState
    def initialize(animation_id)
      super(animation_id)
      @actions = [:Guarding, :Move, :Idle]
    end
  end
  #==============================================================================
  # * Guarding State
  #==============================================================================  
  class LMBS_GuardingState < LMBS_AnimationState
    def initialize(animation_id)
      super(animation_id)
      @actions = [:Guarding, :Idle]
    end
  end
  #==============================================================================
  # * Running State
  #============================================================================== 
  class LMBS_RunningState < LMBS_AnimationState
    def initialize(animation_id)
      super(animation_id)
      @actions = [:Guarding, :Move, :Idle]
    end
  end
end