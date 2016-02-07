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
    return unless @data
    @default_title_id = @data["default_title_id"] if @data.include?("default_title_id")
    @titles = @data["titles"] if @data.include?("titles")
    @icon_index = @data["icon_index"] if @data.include?("icon_index")
    @max_level = @data["max_level"] if @data.include?("max_level")  
  end
end

