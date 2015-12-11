#==============================================================================
# ** New Class
# ** Game_Crafting
#------------------------------------------------------------------------------
#  This class handles parties. Information such as synthesis level is included.
#  Instances of this class are referenced by $game_crafting.
#==============================================================================

class Game_Crafting
  #--------------------------------------------------------------------------
  # * Constants
  #--------------------------------------------------------------------------
  SYNTHESIS_MAX_LEVEL       = 99          # Maximum level for item synthesis
  #--------------------------------------------------------------------------
  # * Public Instance Variables temp public!
  #--------------------------------------------------------------------------
  attr_accessor   :synthesis_exp          # synthesis_level
  attr_accessor   :synthesis_level          # synthesis_level
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    @synthesis_level = 1
    @synthesis_exp = 0
  end
  #--------------------------------------------------------------------------
  # * Get Total EXP Required for Rising to Specified Synthesis Level
  #--------------------------------------------------------------------------
  def synthesis_exp_for_level(level)
    100 * level
  end
  #--------------------------------------------------------------------------
  # * Get EXP for Next Synthesis Level
  #--------------------------------------------------------------------------
  def next_synthesis_level_exp
    synthesis_exp_for_level(@synthesis_level)
  end
  #--------------------------------------------------------------------------
  # * Determine Maximum Synthesis Level
  #--------------------------------------------------------------------------
  def max_synthesis_level?
    @synthesis_level >= SYNTHESIS_MAX_LEVEL
  end
  #--------------------------------------------------------------------------
  # * Level Up Synthesis
  #--------------------------------------------------------------------------
  def level_up_synthesis
    @synthesis_exp %= synthesis_exp_for_level(@synthesis_level)
    @synthesis_level += 1    
  end
  #--------------------------------------------------------------------------
  # * Change Synthesis Experience
  #--------------------------------------------------------------------------
  def change_synthesis_exp(exp)
    @synthesis_exp = exp
    puts sprintf("%s / %s Next: %s", @synthesis_exp, next_synthesis_level_exp, next_synthesis_level_exp - @synthesis_exp)
    last_level = $game_crafting.synthesis_level
    level_up_synthesis while !max_synthesis_level? && @synthesis_exp >= next_synthesis_level_exp
  end
  #--------------------------------------------------------------------------
  # * Get Synthesis EXP (Account for Experience Rate)
  #--------------------------------------------------------------------------
  def gain_synthesis_exp(exp)
    change_synthesis_exp(@synthesis_exp + exp)
  end
end