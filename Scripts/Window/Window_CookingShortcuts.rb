#==============================================================================
# ** New Class
# ** Window_CookingShortcuts
#------------------------------------------------------------------------------
#  This window is for setting the cooking shortcuts
#==============================================================================

class Window_CookingShortcuts < Window_Selectable
  #--------------------------------------------------------------------------
  # * Constants (Icons)
  #--------------------------------------------------------------------------
  RECIPE_ICON   = 230
  #--------------------------------------------------------------------------
  # * Constants (Positions)
  #--------------------------------------------------------------------------
  RECIPE_X      = 48
  WINDOW_WIDTH  = 304
  ICON_WIDTH    = 24
  #--------------------------------------------------------------------------
  # * Override
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y)
    super(x, y, window_width, window_height)
    refresh
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Get Window Width
  #--------------------------------------------------------------------------
  def window_width
    return WINDOW_WIDTH
  end
  #--------------------------------------------------------------------------
  # * Modified
  # * Get Window Height
  #--------------------------------------------------------------------------
  def window_height
    fitting_height(8)
  end
  #--------------------------------------------------------------------------
  # * Get Recipe
  #--------------------------------------------------------------------------
  def recipe
    index >= 0 ? $game_cooking.cooking_shortcuts[index].recipe : nil
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Update Help Text
  #--------------------------------------------------------------------------
  def update_help
    @help_window.set_item(recipe)
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Get Number of Items
  #--------------------------------------------------------------------------
  def item_max
    Game_Cooking::SHORTCUT_SLOTS
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Get Rectangle for Drawing Items
  #--------------------------------------------------------------------------
  def item_rect(index)
    rect = super(index)
    rect.y += line_height
    rect
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Draw Header
  #--------------------------------------------------------------------------
  def draw_header
    draw_text(4, 0, contents.width, line_height, Vocab::SHORTCUTS)
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Draw Item
  #--------------------------------------------------------------------------
  def draw_item(index)
    rect = item_rect(index)
    shortcut = $game_cooking.cooking_shortcuts[index]
    draw_icon(RECIPE_ICON, rect.x, rect.y)
    return if shortcut.recipe.nil? || shortcut.actor.nil?
    draw_text(RECIPE_X, rect.y, contents.width - RECIPE_X, line_height, shortcut.recipe.name)
    draw_icon(shortcut.actor.icon_index, rect.width - ICON_WIDTH, rect.y)
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    super
    draw_header
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Move Cursor Down
  #--------------------------------------------------------------------------
  def cursor_up(wrap = false)
    if row == 0
      process_up
    else
      super
    end
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Process Down
  #--------------------------------------------------------------------------
  def process_up(wrap = false)
    Sound.play_cursor
    Input.update
    deactivate
    hide
    call_handler(:up)
  end
end