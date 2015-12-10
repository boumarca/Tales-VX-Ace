#--------------------------------------------------------------------------
# * RPG::Actor Modifications
#--------------------------------------------------------------------------

class RPG::Actor < RPG::BaseItem
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :default_title_id
  attr_accessor :titles
  #--------------------------------------------------------------------------
  # * Modified
  # * Initialize a New Actor
  #--------------------------------------------------------------------------
  alias actor_initialize initialize
  def initialize
    actor_initialize
    init_custom_fields
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Initialize Custom Fields
  #--------------------------------------------------------------------------
  def init_custom_fields
    @default_title_id = 1
    @titles = []
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Load Note Tags
  #--------------------------------------------------------------------------
  def load_notetags
    super
    init_custom_fields
    self.note.split(/[\r\n]+/).each { |line|
      case line
      when /<default title:\s*(\d*)\s*>/i
        @default_title_id = $1.to_i
      when /<titles:[ ](\d+(?:\s*,\s*\d+)*)>/i
        $1.scan(/\d+/).each { |num| 
          @titles.push(num.to_i) if num.to_i > 0 
        }
      when /<icon_index:\s*(\d*)\s*>/i
        @icon_index = $1.to_i
      when /<max_level:\s*(\d*)\s*>/i
        @max_level = $1.to_i
      end
    }
  end
end


