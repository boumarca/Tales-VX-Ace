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
  WINDOW_WIDTH    = 304 
  ITEM_LIST_SIZE  = 12 
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y, level)
    super(x, y, window_width, window_height) 
    @level = level
    @page = 0
    setup_new_items
    draw_header
    draw_page_number
    draw_items
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
    fitting_height(ITEM_LIST_SIZE + 2)
  end
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def setup_new_items
    @new_items = []
    @new_items += $data_items.select {|item| newly_craftable?(item) }
    @new_items += $data_weapons.select {|item| newly_craftable?(item) }
    @new_items += $data_armors.select {|item| newly_craftable?(item) }
  end
  #--------------------------------------------------------------------------
  # * Is Item Newly Craftable
  #--------------------------------------------------------------------------
  def newly_craftable?(item)
    !item.nil? && item.synthesis_level == @level
  end
  #--------------------------------------------------------------------------
  # * Draw Header
  #--------------------------------------------------------------------------
  def draw_header
    draw_text(0,0, contents.width, line_height, Vocab::NEW_ITEMS, Bitmap::ALIGN_CENTER)
  end
  #--------------------------------------------------------------------------
  # * Draw Page Number
  #-------------------------------------------------------------------------- 
  def draw_page_number
    draw_text(0, line_height * (ITEM_LIST_SIZE + 1), contents.width, line_height, sprintf("%d/%d", @page + 1, @new_items.size / ITEM_LIST_SIZE + 1), Bitmap::ALIGN_RIGHT)
  end 
  #--------------------------------------------------------------------------
  # * Draw Items
  #-------------------------------------------------------------------------- 
  def draw_items
    start_index = @page * ITEM_LIST_SIZE
    end_index = [(@page + 1) * (ITEM_LIST_SIZE - 1), @new_items.size].min
      line = 1
    for i in start_index ... end_index
      draw_item_name(@new_items[i], 0, line_height * line)
      line += 1
    end
  end
end
