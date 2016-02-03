#==============================================================================
# ** LMBS_InputPlayer
#------------------------------------------------------------------------------
#  This class handles player input
#==============================================================================

module LMBS
  class LMBS_InputPlayer < LMBS_InputController
    def command
      return guard_command       if Input.press?(Input::Keys::X)
      return walk_right_command  if Input.press?(Input::Keys::RIGHT)
      return walk_left_command   if Input.press?(Input::Keys::LEFT)
      return idle_command
    end
    #--------------------------------------------------------------------------
    # * Idle Command Instance
    #--------------------------------------------------------------------------
    def idle_command
      return @idle_command if @idle_command
      @idle_command = LMBS_IdleCommand.new
    end
    #--------------------------------------------------------------------------
    # * Walk Right Command Instance
    #--------------------------------------------------------------------------
    def walk_right_command
      return @walk_right_command if @walk_right_command
      @walk_right_command = LMBS_WalkRightCommand.new
    end
    #--------------------------------------------------------------------------
    # * Walk Left Command Instance
    #--------------------------------------------------------------------------
    def walk_left_command
      return @walk_left_command if @walk_left_command
      @walk_left_command = LMBS_WalkLeftCommand.new
    end
    #--------------------------------------------------------------------------
    # * Guard Command Instance
    #--------------------------------------------------------------------------
    def guard_command
      return @guard_command if @guard_command
      @guard_command = LMBS_GuardCommand.new
    end
  end
end