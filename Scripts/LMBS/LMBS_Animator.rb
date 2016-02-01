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
    attr_accessor :states
    #--------------------------------------------------------------------------
    # * Object Initialization
    #--------------------------------------------------------------------------
    def initialize
      @states = {}
      init_states
      @current_state = @states[:Idle] 
    end
    #--------------------------------------------------------------------------
    # * Initialize State Machine
    #--------------------------------------------------------------------------
    def init_states
      state = LMBS_Animation_State.new
      state.animation = 112
      @states[:Idle] = state
      state = LMBS_Animation_State.new
      state.animation = 113
      @states[:Walking] = state
    end
    #--------------------------------------------------------------------------
    # * Set Sprite
    #--------------------------------------------------------------------------
    def sprite=(sprite)
      @sprite = sprite
      @sprite.start_animation($data_animations[@current_state.animation], false, true)
    end  
    #--------------------------------------------------------------------------
    # * Change State
    #--------------------------------------------------------------------------
    def change_state(state)
      return if @current_state == state
      @current_state = state
      @sprite.start_animation($data_animations[@current_state.animation], false, true)
    end
  end
end