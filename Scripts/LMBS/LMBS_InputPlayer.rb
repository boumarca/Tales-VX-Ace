#==============================================================================
# ** LMBS_InputPlayer
#------------------------------------------------------------------------------
#  This class handles player input
#==============================================================================

module LMBS
  class LMBS_InputPlayer < LMBS_InputController
    def command
      if Input.press?(Input::RIGHT)
        return LMBS_WalkRightCommand.new
      end      
      return LMBS_IdleCommand.new
    end
  end
end