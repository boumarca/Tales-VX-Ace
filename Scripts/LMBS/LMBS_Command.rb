#==============================================================================
# ** LMBS_Command
#------------------------------------------------------------------------------
#  This script contains all of the input classes
#==============================================================================

module LMBS
  class LMBS_Command
    def execute(actor)
    end
  end
  
  class LMBS_IdleCommand < LMBS_Command
      def execute(actor)
        actor.idle
      end
    end
  
  class LMBS_WalkRightCommand < LMBS_Command
    def execute(actor)
      actor.walk_right
    end
  end
end