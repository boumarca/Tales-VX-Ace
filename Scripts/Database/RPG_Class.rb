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
    return unless @data
    @growth_rate = @data["growth_rate"] if @data.include?("growth_rate")
    @msp = @data["max_sp"] if @data.include?("max_sp")
    @capacities = @data["capacities"] if @data.include?("capacities")
    @walk_speed = @data["walk_speed"] if @data.include?("walk_speed")
  end
end