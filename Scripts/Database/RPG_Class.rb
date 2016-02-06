#--------------------------------------------------------------------------
# * RPG::Class Modifications
#--------------------------------------------------------------------------

class RPG::Class < RPG::BaseItem
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :growth_rate
  attr_accessor :msp
  attr_accessor :capacities
  attr_accessor :walk_speed
  #--------------------------------------------------------------------------
  # * Modified
  # * Initialize a New Base Item
  #--------------------------------------------------------------------------
  alias class_initialize initialize
  def initialize
    class_initialize
    init_custom_fields
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Initialize Custom Fields
  #--------------------------------------------------------------------------
  def init_custom_fields
    @growth_rate = [0.0] * 8
    @msp = 0
    @capacities = []
    @walk_speed = 0
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Load Note Tags
  # * Source: Yanfly
  #--------------------------------------------------------------------------
  def load_notetags
    super
    init_custom_fields
    self.note.split(/[\r\n]+/).each { |line|
      case line
      when /<(.*) growth:\s*(\d+\.?\d*)>/i
        case $1.upcase
        when "HP"
          @growth_rate[0] = $2.to_f
        when "MP", "TP"
          @growth_rate[1] = $2.to_f
        when "P.ATK"
          @growth_rate[2] = $2.to_f
        when "P.DEF"
          @growth_rate[3] = $2.to_f
        when "M.ATK"
          @growth_rate[4] = $2.to_f
        when "M.DEF"
          @growth_rate[5] = $2.to_f
        when "AGI"
          @growth_rate[6] = $2.to_f
        when "LCK", "LUCK"
          @growth_rate[7] = $2.to_f
        end
      when /<max sp:\s*(\d+\.?\d*)>/i
          @msp = $1.to_i
      when /<capacities:[ ](\d+(?:\s*,\s*\d+)*)>/i
        $1.scan(/\d+/).each { |num| 
          @capacities.push(num.to_i) if num.to_i > 0 
        }
      when /<walk_speed:\s*(\d+\.?\d*)\s*>/i
        @walk_speed = $1.to_f
      end
    }
  end
end