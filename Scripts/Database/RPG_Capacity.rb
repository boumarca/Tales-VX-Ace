#==============================================================================
# ** New Class
# ** RPG::Capacity
#------------------------------------------------------------------------------
#  The data class for Capacities (Skills). Capacities are handled as items for
# convenience.
#==============================================================================

class RPG::Capacity < RPG::BaseItem
  #--------------------------------------------------------------------------
  # * Constants 
  #--------------------------------------------------------------------------
  PARAMETER_ICON  = 11
  ACTION_ICON     = 12
  SUPPORT_ICON    = 13
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :sp_cost    
  attr_accessor :ctype_id   
  #--------------------------------------------------------------------------
  # * Initialize New Capacity
  #--------------------------------------------------------------------------
  def initialize
    super
    @sp_cost = 0
    @ctype_id = 1
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Determines whether the capacity type is [Parameter]. 
  # * Returns true if the value of ctype_id is 1.
  #--------------------------------------------------------------------------
  def parameter_capacity?
    @ctype_id == 1
  end
    #--------------------------------------------------------------------------
  # * New Method
  # * Determines whether the capacity type is [Action]. 
  # * Returns true if the value of ctype_id is 1.
  #--------------------------------------------------------------------------
  def action_capacity?
    @ctype_id == 2
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Determines whether the capacity type is [Support]. 
  # * Returns true if the value of ctype_id is 1.
  #--------------------------------------------------------------------------
  def support_capacity?
    @ctype_id == 3
  end
end