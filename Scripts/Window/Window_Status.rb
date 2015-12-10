#==============================================================================
# ** Window_Status
#------------------------------------------------------------------------------
#  This window displays full status specs on the status screen.
#==============================================================================

class Window_Status < Window_Command
  #--------------------------------------------------------------------------
  # * Constants (Positions)
  #--------------------------------------------------------------------------
  WINDOW_WIDTH      = 352
  WINDOW_HEIGHT     = 408
  TEXT_X            = 4
  TITLE_X           = 20
  COLUMN_WIDTH      = 152
  EQUIP_TEXT_WIDTH  = 96
  PORTRAIT_X        = 368
  PORTRAIT_Y        = 56
  #--------------------------------------------------------------------------
  # * Modified
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y, actor)
    @actor = actor
    @portrait = Sprite.new
    super(x, y)
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
    return WINDOW_HEIGHT
  end
  #--------------------------------------------------------------------------
  # * Get Number of Items
  #--------------------------------------------------------------------------
  def item_max
    return 2
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
  # * Override
  # * Get Item Width
  #--------------------------------------------------------------------------
  def item_width
    return COLUMN_WIDTH
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Create Command List
  #--------------------------------------------------------------------------
  def make_command_list
    add_command(nil, :name)
    add_command(nil, :title)
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Draw Item
  #--------------------------------------------------------------------------
  def draw_item(index)
    draw_actor_name(@actor, TEXT_X, line_height * 0) if index == 0
    draw_actor_title(TITLE_X, line_height * 1)       if index == 1
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Get Rectangle for Drawing Items
  #--------------------------------------------------------------------------
  def item_rect(index)
    rect = Rect.new
    rect.width = 112 if index == 0
    rect.width = contents.width - TITLE_X if index == 1
    rect.height = item_height
    rect.x = TEXT_X - 4   if index == 0
    rect.x = TITLE_X - 4  if index == 1
    rect.y = index * item_height
    rect
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    super
    draw_actor_portrait
    draw_basic_info(TEXT_X, line_height * 2)
    draw_exp_info(WINDOW_WIDTH / 2 - TEXT_X, line_height * 3)
    draw_parameters(TEXT_X, line_height * 5)
    draw_equipments(TEXT_X, line_height * 11)
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Draw Title
  #--------------------------------------------------------------------------
  def draw_actor_title(x, y)
    change_color(normal_color)
    draw_text(x, y, contents.width - TITLE_X, line_height, @actor.current_title.name)
  end
  #--------------------------------------------------------------------------
  # * Modified
  # * Draw Basic Information
  #--------------------------------------------------------------------------
  def draw_basic_info(x, y)
    draw_actor_level(@actor, x, y + line_height * 0, COLUMN_WIDTH)
    draw_actor_hp(@actor, x, y + line_height * 1, COLUMN_WIDTH)
    draw_actor_mp(@actor, x, y + line_height * 2, COLUMN_WIDTH)
  end
  #--------------------------------------------------------------------------
  # * Modified
  # * Draw Experience Information
  #--------------------------------------------------------------------------
  def draw_exp_info(x, y)
    total = @actor.exp
    to_next = @actor.max_level? ? "-------" : @actor.next_level_exp - @actor.exp
    change_color(system_color)
    draw_text(x, y + line_height * 0, COLUMN_WIDTH, line_height, Vocab::ExpTotal, Bitmap::ALIGN_LEFT)
    draw_text(x, y + line_height * 1, COLUMN_WIDTH, line_height, Vocab::ExpNext, Bitmap::ALIGN_LEFT)
    change_color(normal_color)
    draw_text(x, y + line_height * 0, COLUMN_WIDTH, line_height, total, Bitmap::ALIGN_RIGHT)
    draw_text(x, y + line_height * 1, COLUMN_WIDTH, line_height, to_next, Bitmap::ALIGN_RIGHT)
  end
  #--------------------------------------------------------------------------
  # * Modified
  # * Draw Parameters
  #--------------------------------------------------------------------------
  def draw_parameters(x, y)
    6.times {|i| draw_actor_param(@actor, x, y + line_height * i, i + 2) }
  end
  #--------------------------------------------------------------------------
  # * Modified
  # * Draw Equipment
  #--------------------------------------------------------------------------
  def draw_equipments(x, y)
    @actor.equips.each_with_index do |item, i|
      change_color(system_color)
      draw_text(x, y + line_height * i, EQUIP_TEXT_WIDTH, line_height, Vocab::etype(@actor.equip_slots[i]), Bitmap::ALIGN_LEFT)
      change_color(normal_color)
      draw_item_name(item, x + EQUIP_TEXT_WIDTH, y + line_height * i)
    end
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Draw Actor Portrait Graphic
  #--------------------------------------------------------------------------
  def draw_actor_portrait
    @portrait.bitmap = Cache.picture(@actor.portrait_name)
    @portrait.x = PORTRAIT_X
    @portrait.y = PORTRAIT_Y
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Free
  #--------------------------------------------------------------------------
  def dispose
    @portrait.dispose
    super
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Move Cursor Right
  #--------------------------------------------------------------------------
  def cursor_right(wrap = false)
    process_pagedown
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Move Cursor Left
  #--------------------------------------------------------------------------
  def cursor_left(wrap = false)
    process_pageup
  end
end
