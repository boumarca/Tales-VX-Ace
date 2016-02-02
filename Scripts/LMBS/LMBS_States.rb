#==============================================================================
# ** LMBS_States
#------------------------------------------------------------------------------
#  This script contains the states of a battler
#==============================================================================

module LMBS
  class LMBS_AnimationState
    attr_accessor :animation
    #--------------------------------------------------------------------------
    # * Enter State
    #--------------------------------------------------------------------------
    def enter_state(battler)
      battler.start_animation($data_animations[@animation])
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
end