#==============================================================================
# ** New Class
# ** Window_Cooking
#------------------------------------------------------------------------------
#  This window is used to choose the cook and the recipe.
#==============================================================================

class Window_Cooking < Window_Command
  #--------------------------------------------------------------------------
  # * Constants (Positions)
  #--------------------------------------------------------------------------
  WINDOW_WIDTH  = 304
  TAG_WIDTH     = 88
  TEXT_WIDTH    = 180
  #--------------------------------------------------------------------------
  # * Constants (Arrows)
  #--------------------------------------------------------------------------
  ARROW_WIDTH         = 16
  ARROW_HEIGHT        = 8
  ARROW               = "Scroll_arrow_down"
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y)
    super(x, y)
    @actor = nil
    @recipe = nil 
    create_arrow
  end
  #--------------------------------------------------------------------------
  # * Create Continue Arrow
  #--------------------------------------------------------------------------
  def create_arrow
    @down_arrow = Sprite.new
    @down_arrow.bitmap = Cache.system(ARROW)
    @down_arrow.x = self.x + window_width / 2 - ARROW_WIDTH / 2
    @down_arrow.y = self.y + window_height - standard_padding
    @down_arrow.z = 100
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Get Window Width
  #--------------------------------------------------------------------------
  def window_width
    return WINDOW_WIDTH
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Get Window Height
  #--------------------------------------------------------------------------
  def window_height
    fitting_height(2)
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Get Number of Items
  #--------------------------------------------------------------------------
  def item_max
    return 2
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Create Command List
  #--------------------------------------------------------------------------
  def make_command_list
    add_command(nil, :actor)
    add_command(nil, :recipe)
  end
  #--------------------------------------------------------------------------
  # * Get Item Width
  #--------------------------------------------------------------------------
  def item_width
    return TEXT_WIDTH
  end
  #--------------------------------------------------------------------------
  # * Set Actor
  #--------------------------------------------------------------------------
  def actor=(actor)
    return if @actor == actor
    @actor = actor
    refresh
  end
  #--------------------------------------------------------------------------
  # * Set Recipe
  #--------------------------------------------------------------------------
  def recipe=(recipe)
    return if @recipe == recipe
    @recipe = recipe
    call_update_help
    refresh
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Update Help Text
  #--------------------------------------------------------------------------
  def update_help
    @help_window.set_item(@recipe)
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    super
    draw_headers
  end
  #--------------------------------------------------------------------------
  # * Draw Headers
  #--------------------------------------------------------------------------
  def draw_headers
    change_color(system_color)
    draw_text(0, 0, TAG_WIDTH, line_height, Vocab::ACTOR_COOK)
    draw_text(0, line_height, TAG_WIDTH, line_height, Vocab::RECIPE)
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Get Rectangle for Drawing Items
  #--------------------------------------------------------------------------
  def item_rect(index)
    rect = super
    rect.x += TAG_WIDTH + standard_padding
    rect
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Draw Item
  #--------------------------------------------------------------------------
  def draw_item(index)
    item = @actor  if index == 0
    item = @recipe if index == 1
    if item
      rect = item_rect_for_text(index)
      rect.width -= 4
      draw_text(rect, item.name)
    end
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Free
  #--------------------------------------------------------------------------
  def dispose
    @down_arrow.dispose
    super
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Move Cursor Down
  #--------------------------------------------------------------------------
  def cursor_down(wrap = false)
    if row == 1
      process_down
    else
      super
    end
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Process Down
  #--------------------------------------------------------------------------
  def process_down(wrap = false)
    Sound.play_cursor
    Input.update
    deactivate
    call_handler(:down)
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Processing When Select-Button Is Pressed
  #--------------------------------------------------------------------------
  def process_select
    Sound.play_cursor
    super
  end
end