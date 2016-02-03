#==============================================================================
# ** LMBS_InputPlayer
#------------------------------------------------------------------------------
#  This class handles player input
#==============================================================================

module LMBS
  class LMBS_InputPlayer < LMBS_InputController
    def command
      return LMBS_GuardCommand.new      if Input.press?(Input::Keys::X)
      return LMBS_WalkRightCommand.new  if Input.press?(Input::Keys::RIGHT)
      return LMBS_WalkLeftCommand.new   if Input.press?(Input::Keys::LEFT)
      return LMBS_IdleCommand.new
    end
  end
end