#--------------------------------------------------------------------------
# * RPG::BaseItem Modifications
#--------------------------------------------------------------------------

class RPG::BaseItem
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :image
  attr_accessor :subtype_id  
  #--------------------------------------------------------------------------
  # * Modified
  # * Initialize a New Base Item
  #--------------------------------------------------------------------------
  alias base_item_initialize initialize
  def initialize
    base_item_initialize
    init_custom_fields
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Initialize Custom Fields
  #--------------------------------------------------------------------------
  def init_custom_fields
    @image = ''
    @subtype_id = 1
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Load Note Tags
  #--------------------------------------------------------------------------
  def load_notetags
    init_custom_fields
    self.note.split(/[\r\n]+/).each { |line|
      case line
      when /<image:\s*"(.*)"\s*>/i
        @image = $1
      when /<subtype_id:\s*(\d*)\s*>/i
        @subtype_id = $1.to_i
      end
    }
  end  
end