#==============================================================================
# ** LMBS_InputPlayer
#------------------------------------------------------------------------------
#  This class handles player input
#==============================================================================

module LMBS
  class LMBS_InputPlayer < LMBS_InputController
    #--------------------------------------------------------------------------
    # * Object Initialization
    #--------------------------------------------------------------------------
    def initialize
      create_actions_mapping
    end
    #--------------------------------------------------------------------------
    # * Create Command Mapping
    #--------------------------------------------------------------------------
    def create_actions_mapping
      @actions = {}
      @actions[:Idle]     = method(:idle_action)
      @actions[:Walking]  = method(:walking_action)
      @actions[:Guarding] = method(:guarding_action)
    end
    #--------------------------------------------------------------------------
    # * Handle Player Input
    #--------------------------------------------------------------------------
    def handle_input(actions)
      actions.each { |action|
        next unless @actions.include?(action)
        command = @actions[action].call
        return command if command
      } 
    end
    #--------------------------------------------------------------------------
    # * Idle Action
    #--------------------------------------------------------------------------
    def idle_action
      return idle_command
    end
    #--------------------------------------------------------------------------
    # * Walking Action
    #--------------------------------------------------------------------------
    def walking_action
      return walk_right_command  if Input.press?(Input::Keys::RIGHT)
      return walk_left_command   if Input.press?(Input::Keys::LEFT)
    end
    #--------------------------------------------------------------------------
    # * Guarding Action
    #--------------------------------------------------------------------------
    def guarding_action
      return guard_command if Input.press?(Input::Keys::X)
    end
    #--------------------------------------------------------------------------
    # * Running Action
    #--------------------------------------------------------------------------
    def running_action
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