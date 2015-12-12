#==============================================================================
# ** New Class
# ** RPG::Title
#------------------------------------------------------------------------------
#  The data class for titles. Titles are handled as items for convenience.
#==============================================================================

class RPG::Title < RPG::BaseItem
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :params       #[HP, MP, P.Atk, P.Def, M.Atk, M.Def, Agi, Lck] Lck is not used
  #--------------------------------------------------------------------------
  # * Title Initialization
  #--------------------------------------------------------------------------
  def initialize
    super
    @params = [0.0] * 8
  end
end