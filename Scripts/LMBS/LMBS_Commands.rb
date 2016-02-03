#==============================================================================
# ** LMBS_Command
#------------------------------------------------------------------------------
#  This script contains all of the Command classes
#==============================================================================

module LMBS
  class LMBS_Command
    def execute(battler)
    end
  end
  
  class LMBS_IdleCommand < LMBS_Command
    def execute(battler)
      battler.idle
    end
  end
  
  class LMBS_WalkRightCommand < LMBS_Command
    def execute(battler)
      battler.walk_right
    end
  end
  
  class LMBS_WalkLeftCommand < LMBS_Command
    def execute(battler)
      battler.walk_left
    end
  end
  
  class LMBS_GuardCommand < LMBS_Command
    def execute(battler)
      battler.guard
    end
  end
    end
  end
end