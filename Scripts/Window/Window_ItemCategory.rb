#==============================================================================
# ** Window_ItemCategory
#------------------------------------------------------------------------------
#  This window is for selecting a category of normal items and equipment
# on the item screen or shop screen.
#==============================================================================

class Window_ItemCategory < Window_HorzCommand
  #--------------------------------------------------------------------------
  # * Constants (Positions)
  #--------------------------------------------------------------------------
  WINDOW_WIDTH    = 252
  PADDING         = 6
  MAX_CATEGORY    = 10
  SPACING         = 0
  #--------------------------------------------------------------------------
  # * Constants (Icons)
  #--------------------------------------------------------------------------
  NEW_ICON        = 261
  ITEM_ICON       = 192
  WEAPON_ICON     = 389
  ARMOR_ICON      = 436
  HEAD_ICON       = 458
  ARM_ICON        = 493
  ACCESSORY_ICON  = 179
  FOOD_ICON       = 297
  MATERIAL_ICON   = 342
  KEY_ITEM_ICON   = 270
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
    super
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
  # * Modified
  # * Create Command List
  #--------------------------------------------------------------------------
  def make_command_list
    add_command(NEW_ICON,       :new)
    add_command(ITEM_ICON,      :item)
    add_command(WEAPON_ICON,    :weapon)
    add_command(ARMOR_ICON,     :armor)
    add_command(HEAD_ICON,      :head)
    add_command(ARM_ICON,       :arm)
    add_command(ACCESSORY_ICON, :accessory)
    add_command(FOOD_ICON,      :food)
    add_command(MATERIAL_ICON,  :material)
    add_command(KEY_ITEM_ICON,  :key_item)
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
  # * Move Cursor Down
  #--------------------------------------------------------------------------
  def cursor_down(wrap = false)
    Sound.play_cursor
    Input.update
    deactivate
    call_handler(:down)
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Processing When L Button (Page Up) Is Pressed
  #--------------------------------------------------------------------------
  def process_pageup
    Sound.play_cursor
    Input.update
    call_handler(:pageup)
  end
  #--------------------------------------------------------------------------
  # * Override 
  # * Processing When R Button (Page Down) Is Pressed
  #--------------------------------------------------------------------------
  def process_pagedown
    Sound.play_cursor
    Input.update
    call_handler(:pagedown)
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
