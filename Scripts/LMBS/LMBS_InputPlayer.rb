#==============================================================================
# ** LMBS_InputPlayer
#------------------------------------------------------------------------------
#  This class handles player input
#==============================================================================

module LMBS
  class LMBS_InputPlayer < LMBS_InputController
    def command
      return LMBS_WalkRightCommand.new if Input.press?(Input::RIGHT)
      return LMBS_WalkLeftCommand.new if Input.press?(Input::LEFT)
      return LMBS_IdleCommand.new
    end
  end
end