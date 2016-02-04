#==============================================================================
# ** LMBS_InputPlayer
#------------------------------------------------------------------------------
#  This class handles player input
#==============================================================================

module LMBS
  class LMBS_InputPlayer < LMBS_InputController
    BUTTON_COOLTIME = 0.5
    #--------------------------------------------------------------------------
    # * Object Initialization
    #--------------------------------------------------------------------------
    def initialize
      @button_cooler = 0
      @button_count = 0
      create_actions_mapping
    end
    #--------------------------------------------------------------------------
    # * Create Command Mapping
    #--------------------------------------------------------------------------
    def create_actions_mapping
      @actions = {}
      @actions[:Idle]     = method(:idle_action)
      @actions[:Walking]  = method(:movement_action)
      @actions[:Guarding] = method(:guarding_action)
     # @actions[:Running]  = method(:running_action)
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
    end
    #--------------------------------------------------------------------------
    # * Update button tap cooldown
    #--------------------------------------------------------------------------
    def update_tap_cooldown
      if @button_cooler > 0
        @button_cooler -= Time.now - @last_time
        @last_time = Time.now
        #puts "Cooler = " + @button_cooler.to_s
      else
        @button_count = 0
        #puts "Button count = 0"
      end
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
    def movement_action
      if Input.repeat?(Input::Keys::RIGHT) || Input.repeat?(Input::Keys::LEFT)
        if @button_cooler > 0 && @button_count == 1
          puts "Double Tap " + @button_cooler.to_s + " " + @button_count.to_s
        else
          @button_cooler = BUTTON_COOLTIME
          @button_count += 1
          @last_time = Time.now
        end        
      end      
      return walk_right_command  if Input.press?(Input::Keys::RIGHT)
      return walk_left_command   if Input.press?(Input::Keys::LEFT)
    end

#  var ButtonCooler : float = 0.5 ; // Half a second before reset
#   var ButtonCount : int = 0;
#   function Update ( )
#   {
#      if ( Input.anyKeyDown ( ) ){
#   
#         if ( ButtonCooler > 0 && ButtonCount == 1/*Number of Taps you want Minus One*/){
#            //Has double tapped
#         }else{
#           ButtonCooler = 0.5 ; 
#           ButtonCount += 1 ;
#         }
#      }
#   
#      if ( ButtonCooler > 0 )
#      {
#   
#         ButtonCooler -= 1 * Time.deltaTime ;
#   
#      }else{
#         ButtonCount = 0 ;
#      }
#   }
#        
    #--------------------------------------------------------------------------
    # * Guarding Action
    #--------------------------------------------------------------------------
    def guarding_action
      return guard_command if Input.press?(Input::Keys::X)
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
  end
end