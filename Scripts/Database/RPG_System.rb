#--------------------------------------------------------------------------
# * RPG::System Modifications
#--------------------------------------------------------------------------

class RPG::System
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :item_types
  attr_accessor :capacities_types
  #--------------------------------------------------------------------------
  # * Modified
  # * Initialize a New System
  #--------------------------------------------------------------------------
  alias system_initialize initialize
  def initialize
    system_initialize
    init_custom_fields
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Initialize Custom Fields
  #--------------------------------------------------------------------------
  def init_custom_fields
    @item_types = [nil, '']
    @capacities_types = [nil, '']
  end
end