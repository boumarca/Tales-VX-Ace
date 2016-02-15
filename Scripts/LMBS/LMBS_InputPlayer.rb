#==============================================================================
# ** LMBS_InputPlayer
#------------------------------------------------------------------------------
#  This class handles player input
#==============================================================================

module LMBS
  class LMBS_InputPlayer < LMBS_InputController
    TAP_COOLTIME = 0.5
    #--------------------------------------------------------------------------
    # * Object Initialization
    #--------------------------------------------------------------------------
    def initialize
      reset_double_tap
      create_actions_mapping
    end
    #--------------------------------------------------------------------------
    # * Create Command Mapping
    #--------------------------------------------------------------------------
    def create_actions_mapping
      @actions = {}
      @actions[:idle]     = method(:idle_action)
      @actions[:move]  	  = method(:move_action)
      @actions[:guarding] = method(:guarding_action)
      @actions[:jump]     = method(:jump_action)
      @actions[:stop]     = method(:stop_action)
      @actions[:attack]   = method(:attack_action)
    end
    #--------------------------------------------------------------------------
    # * Update Tap cooldown every frame
    #--------------------------------------------------------------------------
    def update_tap_cooldown
      if @cooldown > 0
        @cooldown -= Time.now - @last_time
        @last_time = Time.now
      else
        reset_double_tap
      end
    end
    #--------------------------------------------------------------------------
    # * Update Double Tap Status
    #--------------------------------------------------------------------------
    def update_double_tap(input)
      if @last_input != input
        if @first_input == input
          if @cooldown > 0
            @double_tap = true
            @first_input = nil
          else
            reset_double_tap
          end
        else
          @double_tap = false
          @first_input = input
        end
      end
      @last_input = input
      @cooldown = TAP_COOLTIME
      @last_time = Time.now
    end
    #--------------------------------------------------------------------------
    # * Reset Double Tap Status
    #--------------------------------------------------------------------------
    def reset_double_tap
      @double_tap = false
      @first_input = nil
      @last_time = Time.now
      @cooldown = 0
    end
    #--------------------------------------------------------------------------
    # * Handle Player Input
    #--------------------------------------------------------------------------
    def handle_input(actions)
      update_tap_cooldown
      actions.each { |action|
        next unless @actions.include?(action)
        command = @actions[action].call
        return command if command
      }
      return nil
    end
    #--------------------------------------------------------------------------
    # * Idle Action
    #--------------------------------------------------------------------------
    def idle_action
      return idle_command
    end
    #--------------------------------------------------------------------------
    # * Move Action
    #--------------------------------------------------------------------------
    def move_action
      if Input.press?(Input::Keys::RIGHT)
        update_double_tap(Input::Keys::RIGHT)
        return run_right_command if @double_tap
        return walk_right_command
      elsif Input.press?(Input::Keys::LEFT)
        update_double_tap(Input::Keys::LEFT)
        return run_left_command if @double_tap
        return walk_left_command
      end
      @last_input = nil
      reset_double_tap if @double_tap
      return nil
    end
    #--------------------------------------------------------------------------
    # * Guarding Action
    #--------------------------------------------------------------------------
    def guarding_action
      return guard_command if Input.press?(Input::Keys::X)
    end
    #--------------------------------------------------------------------------
    # * Jump Action
    #--------------------------------------------------------------------------
    def jump_action
      return jump_command if Input.press?(Input::Keys::UP)
    end
    #--------------------------------------------------------------------------
    # * Stop Run Action
    #--------------------------------------------------------------------------
    def stop_action
      if (@last_input == Input::Keys::RIGHT && Input.press?(Input::Keys::LEFT)) || (@last_input == Input::Keys::LEFT && Input.press?(Input::Keys::RIGHT))
        return stop_command
      end
    end
    #--------------------------------------------------------------------------
    # * Attack Action
    #--------------------------------------------------------------------------
    def attack_action
      return attack_command if Input.trigger?(Input::Keys::A)
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
    #--------------------------------------------------------------------------
    # * Run Right Command Instance
    #--------------------------------------------------------------------------
    def run_right_command
      return @run_right_command if @run_right_command
      @run_right_command = LMBS_RunRightCommand.new
    end
    #--------------------------------------------------------------------------
    # * Run Left Command Instance
    #--------------------------------------------------------------------------
    def run_left_command
      return @run_left_command if @run_left_command
      @run_left_command = LMBS_RunLeftCommand.new
    end
    #--------------------------------------------------------------------------
    # * Run Left Command Instance
    #--------------------------------------------------------------------------
    def jump_command
      return @jump_command if @jump_command
      @jump_command = LMBS_JumpCommand.new
    end
    #--------------------------------------------------------------------------
    # * Stop Run Command Instance
    #--------------------------------------------------------------------------
    def stop_command
      return @stop_command if @stop_command
      @stop_command = LMBS_StopCommand.new
    end
    #--------------------------------------------------------------------------
    # * Stop Run Command Instance
    #--------------------------------------------------------------------------
    def attack_command
      return @attack_command if @attack_command
      @attack_command = LMBS_AttackCommand.new
    end
  end
end
