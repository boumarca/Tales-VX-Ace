#==============================================================================
# ** New Class
# ** Window_SynthesisLevelup
#------------------------------------------------------------------------------
#  This window is a modal window displaying name of newly craftable items.
#==============================================================================

class Window_SynthesisLevelup < Window_Modal
  #--------------------------------------------------------------------------
  # * Constants
  #--------------------------------------------------------------------------
  WINDOW_WIDTH = 304  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y, level)
    super(x, y, window_width, window_height) 
    @level = level
    setup_new_items
  end
  #--------------------------------------------------------------------------
  # * Get Window Height
  #--------------------------------------------------------------------------
  def window_width
    return WINDOW_WIDTH
  end
  #--------------------------------------------------------------------------
  # * Get Window Height
  #--------------------------------------------------------------------------
  def window_height
    fitting_height(14)
  end
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def setup_new_items
    @new_items = []
    @new_items += $data_items.select {|item| newly_craftable?(item) }
    @new_items += $data_weapons.select {|item| newly_craftable?(item) }
    @new_items += $data_armors.select {|item| newly_craftable?(item) }
    puts @new_items.to_s 
  end
  #--------------------------------------------------------------------------
  # * Is Item Newly Craftable
  #--------------------------------------------------------------------------
  def newly_craftable?(item)
    !item.nil? && item.synthesis_level == @level
  end
end
