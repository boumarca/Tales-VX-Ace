#==============================================================================
# ** LMBS_States
#------------------------------------------------------------------------------
#  This script contains the states of a battler
#==============================================================================

module LMBS
  class LMBS_AnimationState
    #--------------------------------------------------------------------------
    # * Animation
    #--------------------------------------------------------------------------
    def animation
      $data_animations[@animation]
    end
    #--------------------------------------------------------------------------
    # * Enter State
    #--------------------------------------------------------------------------
    def enter_state(battler)
      battler.start_animation(animation)
    end
  end
  
  class LMBS_IdleState < LMBS_AnimationState
    #--------------------------------------------------------------------------
    # * Object Initialization
    #--------------------------------------------------------------------------
    def initialize
      @animation = 112
    end
  end
  
  class LMBS_WalkingState < LMBS_AnimationState
    #--------------------------------------------------------------------------
    # * Object Initialization
    #--------------------------------------------------------------------------
    def initialize
      @animation = 113
    end
  end
  
  class LMBS_GuardingState < LMBS_AnimationState
    #--------------------------------------------------------------------------
    # * Object Initialization
    #--------------------------------------------------------------------------
    def initialize
      @animation = 114
    end
  end

  class LMBS_RunningState < LMBS_AnimationState
    #--------------------------------------------------------------------------
    # * Object Initialization
    #--------------------------------------------------------------------------
    def initialize
      @animation = 115
    end
  end
end