#==============================================================================
# ** Window_ItemCategory
#------------------------------------------------------------------------------
#  This window is for selecting a category of capacities on the Capacities 
# menu screen.
#==============================================================================

class Window_CapacitiesCategory < Window_HorzCommand
  #--------------------------------------------------------------------------
  # * Constants (Positions)
  #--------------------------------------------------------------------------
  WINDOW_WIDTH  = 256
  PADDING       = 6
  MAX_CATEGORY  = 5
  SPACING       = 31
  #--------------------------------------------------------------------------
  # * Constants (Positions)
  #--------------------------------------------------------------------------
  ALL_ICON      = 5
  SET_ICON      = 6
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader   :item_window
  #--------------------------------------------------------------------------
  # * Class Variable
  #--------------------------------------------------------------------------
  @@last_category = 0
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y)
    super(x, y)
    select(@@last_category)
    deactivate
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Get Standard Padding Size
  #--------------------------------------------------------------------------
  def standard_padding
    return PADDING
  end
  #--------------------------------------------------------------------------
  # * Modified
  # * Get Window Width
  #--------------------------------------------------------------------------
  def window_width
    return WINDOW_WIDTH
  end
  #--------------------------------------------------------------------------
  # * Modified
  # * Get Digit Count
  #--------------------------------------------------------------------------
  def col_max
    return MAX_CATEGORY
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Get Spacing for Items Arranged Side by Side
  #--------------------------------------------------------------------------
  def spacing
    return SPACING
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    @item_window.category = current_symbol if @item_window
    @@last_category = index
  end
  #--------------------------------------------------------------------------
  # * Create Command List
  #--------------------------------------------------------------------------
  def make_command_list
    add_command(ALL_ICON,                      :all)
    add_command(RPG::Capacity::PARAMETER_ICON, :parameter)
    add_command(RPG::Capacity::ACTION_ICON,    :action)
    add_command(RPG::Capacity::SUPPORT_ICON,   :support)
    add_command(SET_ICON,                      :set)
  end
  #--------------------------------------------------------------------------
  # * Set Item Window
  #--------------------------------------------------------------------------
  def item_window=(item_window)
    @item_window = item_window
    update
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Draw Item
  #--------------------------------------------------------------------------
  def draw_item(index)
    change_color(normal_color, command_enabled?(index))
    rect = item_rect(index)
    draw_icon(command_name(index), rect.x, rect.y)
  end
    #--------------------------------------------------------------------------
  # * Override
  # * Move Cursor Right
  #--------------------------------------------------------------------------
  def cursor_right(wrap = true)
    if col_max >= 2 && (index < item_max - 1 || (wrap && horizontal?))
      select((index + 1) % item_max)
      @item_window.category = current_symbol if @item_window
    end
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Move Cursor Left
  #--------------------------------------------------------------------------
  def cursor_left(wrap = true)
    if col_max >= 2 && (index > 0 || (wrap && horizontal?))
      select((index - 1 + item_max) % item_max)
      @item_window.category = current_symbol if @item_window
    end
  end
end
