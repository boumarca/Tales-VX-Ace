#==============================================================================
# ** Window_MenuActor
#------------------------------------------------------------------------------
#  This is the super class for actor selection.
#==============================================================================

class Window_MenuActor < Window_Selectable
  #--------------------------------------------------------------------------
  # * Constants (Positions)
  #--------------------------------------------------------------------------
  ACTOR_WINDOW_WIDTH  = 304
  ACTOR_WINDOW_HEIGHT = 328  
  ITEM_HEIGHT         = 120
  #--------------------------------------------------------------------------
  # * Modified
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y)
    super(x, y, window_width, window_height)
    refresh
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Get Digit Count
  #--------------------------------------------------------------------------
  def col_max
    return 3
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Get Number of Items
  #--------------------------------------------------------------------------
  def item_max
    $game_party.members.size
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Get Window Width
  #--------------------------------------------------------------------------
  def window_width
    return ACTOR_WINDOW_WIDTH
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Get Window Height
  #--------------------------------------------------------------------------
  def window_height
    return ACTOR_WINDOW_HEIGHT
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Calculate Height of Window Contents
  #--------------------------------------------------------------------------
  def contents_height
    height - standard_padding * 2
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Get Item Height
  #--------------------------------------------------------------------------
  def item_height
    ITEM_HEIGHT
  end
  #--------------------------------------------------------------------------
  # * Modified
  # * Processing When OK Button Is Pressed
  #--------------------------------------------------------------------------
  def process_ok
    Input.update
    $game_party.target_actor = $game_party.members[index] unless @cursor_all
    call_ok_handler
  end
  #--------------------------------------------------------------------------
  # * Restore Previous Selection Position
  #--------------------------------------------------------------------------
  def select_last
    select($game_party.target_actor.index || 0)
  end
  #--------------------------------------------------------------------------
  # * Set Position of Cursor for Item
  #--------------------------------------------------------------------------
  def select_for_item(item)
    @cursor_fix = item.for_user?
    @cursor_all = item.for_all?
    if @cursor_fix
      select($game_party.menu_actor.index)
    elsif @cursor_all
      select(0)
    else
      select_last
    end
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Update Cursor
  #--------------------------------------------------------------------------
  def update_cursor
    if @cursor_all
      show_cursor_on_all
      cursor_rect.set(0, line_height + standard_padding, contents.width, row_max * (item_height + standard_padding) - standard_padding)
      self.top_row = 0
      @cursor.hide
    elsif @index < 0
      cursor_rect.empty
    else
      ensure_cursor_visible
      cursor_rect.set(item_rect(@index))
    end
    @cursor.update
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Set Window Header
  #--------------------------------------------------------------------------
  def show_cursor_on_all
    @all_cursors = Array.new(item_max)
    (0...@all_cursors.size).each {|i|
      @all_cursors[i] = Sprite_Cursor.new(self)
      cursor_rect.set(item_rect(i))
      @all_cursors[i].show
      @all_cursors[i].update
    }
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Deactivate
  #--------------------------------------------------------------------------
  def deactivate
    @all_cursors.each{|cursor| cursor.dispose} if @cursor_all
    @cursor_all = false if @cursor_all
    super
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Draw Simple Status
  #--------------------------------------------------------------------------
  def draw_actor_simple_status(actor, x, y)
    draw_actor_hp(actor, x, y, item_width)
    draw_actor_mp(actor, x, y + line_height, item_width)
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Draw Current Value
  #     current : Current value
  #     color1  : Color of current value
  #--------------------------------------------------------------------------
  def draw_current_value(x, y, width, current, color1)
    change_color(color1)
    draw_text(x, y, width, line_height, current, Bitmap::ALIGN_RIGHT)
    change_color(normal_color)
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Draw HP
  #--------------------------------------------------------------------------
  def draw_actor_hp(actor, x, y, width = 124)
    draw_gauge(x, y, width, actor.hp_rate, hp_gauge_color1, hp_gauge_color2)
    change_color(system_color)
    draw_text(x, y, 30, line_height, Vocab::hp_a)
    draw_current_value(x, y, width, actor.hp, hp_color(actor))
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Draw MP
  #--------------------------------------------------------------------------
  def draw_actor_mp(actor, x, y, width = 124)
    draw_gauge(x, y, width, actor.mp_rate, mp_gauge_color1, mp_gauge_color2)
    change_color(system_color)
    draw_text(x, y, 30, line_height, Vocab::mp_a)
    draw_current_value(x, y, width, actor.mp, mp_color(actor))
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Update Bottom Padding
  #--------------------------------------------------------------------------
  def update_padding_bottom
    self.padding_bottom = padding
  end
end
