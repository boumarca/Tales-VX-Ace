#==============================================================================
# ** RPG::Enemy
#------------------------------------------------------------------------------
#  RPG::Enemy Modifications
#==============================================================================

class RPG::Enemy < RPG::BaseItem
#--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :walk_speed
  attr_accessor :battle_animations
  #--------------------------------------------------------------------------
  # * Modified
  # * Initialize a New Base Item
  #--------------------------------------------------------------------------
  alias enemy_initialize initialize
  def initialize
    enemy_initialize
    init_custom_fields
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Initialize Custom Fields
  #--------------------------------------------------------------------------
  def init_custom_fields
    @walk_speed = 0
    @battle_animations = {}
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Load Note Tags
  #--------------------------------------------------------------------------
  def load_notetags
    super
    init_custom_fields
    return unless @data
    @walk_speed = @data["walk_speed"] if @data.include?("walk_speed")
    if @data.include?("battle_animations")
      @data["battle_animations"].each { |key, value| @battle_animations[key.to_sym] = value }
    end
  end
end