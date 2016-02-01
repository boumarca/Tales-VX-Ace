#==============================================================================
# ** LMBS_Animator
#------------------------------------------------------------------------------
#  This class performs animation states processing.
#==============================================================================

module LMBS
  class LMBS_Animation_State
    attr_accessor :animation
  end
  
  class LMBS_Animator
    #--------------------------------------------------------------------------
    # * Object Initialization
    #--------------------------------------------------------------------------
    def initialize
      @states = []
      init_states
      @current_state = @states[0] 
    end
    #--------------------------------------------------------------------------
    # * Initialize State Machine
    #--------------------------------------------------------------------------
    def init_states
      state = LMBS_Animation_State.new
      state.animation = 112
      @states.push(state)
    end
    #--------------------------------------------------------------------------
    # * Set Sprite
    #--------------------------------------------------------------------------
    def sprite=(sprite)
      @sprite = sprite
      @sprite.start_animation($data_animations[@current_state.animation], false, true)
    end  
  end
end