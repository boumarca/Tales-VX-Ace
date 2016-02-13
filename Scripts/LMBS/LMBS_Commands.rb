#==============================================================================
# ** LMBS_Command
#------------------------------------------------------------------------------
#  This script contains all of the Command classes
#==============================================================================

module LMBS
  #==============================================================================
  # * Command Superclass
  #==============================================================================
  class LMBS_Command
    def execute(battler)
    end
  end
  #==============================================================================
  # * Idle Command
  #==============================================================================
  class LMBS_IdleCommand < LMBS_Command
    def execute(battler)
      battler.idle
    end
  end
  #==============================================================================
  # * Walk Right Command
  #==============================================================================
  class LMBS_WalkRightCommand < LMBS_Command
    def execute(battler)
      battler.walk_right
    end
  end
  #==============================================================================
  # * Walk Left Command
  #==============================================================================
  class LMBS_WalkLeftCommand < LMBS_Command
    def execute(battler)
      battler.walk_left
    end
  end
  #==============================================================================
  # * Guard Command
  #==============================================================================
  class LMBS_GuardCommand < LMBS_Command
    def execute(battler)
      battler.guard
    end
  end
  #==============================================================================
  # * Run Right Command
  #==============================================================================
  class LMBS_RunRightCommand < LMBS_Command
    def execute(battler)
      battler.run_right
    end
  end
  #==============================================================================
  # * Run Left Command
  #==============================================================================
  class LMBS_RunLeftCommand < LMBS_Command
    def execute(battler)
      battler.run_left
    end
  end
  #==============================================================================
  # * Jump Command
  #==============================================================================
  class LMBS_JumpCommand < LMBS_Command
    def execute(battler)
      battler.jump
    end
  end
end
