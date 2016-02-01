#==============================================================================
# ** LMBS_InputPlayer
#------------------------------------------------------------------------------
#  This class handles player input
#==============================================================================

module LMBS
  class LMBS_InputPlayer < LMBS_InputController
    def command
      if Input.repeat?(Input::RIGHT)
        return LMBS_WalkRightCommand.new
      end
     end
  end
end