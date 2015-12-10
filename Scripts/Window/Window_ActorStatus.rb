#==============================================================================
# ** Window_ActorStatus
#------------------------------------------------------------------------------
#  This window displays the user's status on the skills and equip screen.
#==============================================================================

class Window_ActorStatus < Window_Selectable
  #--------------------------------------------------------------------------
  # * Constants (Positions)
  #--------------------------------------------------------------------------
  STATUS_X            = 96
  STATUS_WIDTH        = 168
  STATUS_WINDOW_WIDTH = 352
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :commands_disabled
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y)
    super(x, y, window_width, fitting_height(3))
    @actor = nil
    @commands_disabled = false
    select(0)
  end
  #--------------------------------------------------------------------------
  # * Modified
  # * Get Window Width
  #--------------------------------------------------------------------------
  def window_width
    return STATUS_WINDOW_WIDTH
  end
  #--------------------------------------------------------------------------
  # * Actor Settings
  #--------------------------------------------------------------------------
  def actor=(actor)
    return if @actor == actor
    @actor = actor
    refresh
  end
  #--------------------------------------------------------------------------
  # * Get Number of Items
  #--------------------------------------------------------------------------
  def item_max
    return 1
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_actor_simple_status if @actor
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Draw Simple Status
  #--------------------------------------------------------------------------
  def draw_actor_simple_status
    draw_actor_face(@actor, 0, 0)
    draw_actor_icons(@actor, 0, 0)
    draw_actor_name(@actor, STATUS_X, 0, STATUS_WIDTH)
    draw_actor_hp(@actor, STATUS_X, line_height, STATUS_WIDTH)
    draw_actor_mp(@actor, STATUS_X, line_height * 2, STATUS_WIDTH)    
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Update Cursor
  #--------------------------------------------------------------------------
  def update_cursor
    if @cursor_all
      cursor_rect.set(0, 0, contents.width, row_max * item_height)
      self.top_row = 0
    elsif @index < 0
      cursor_rect.empty
    else
      ensure_cursor_visible
      cursor_rect.set(STATUS_X - 4, 0, STATUS_WIDTH, line_height)
    end
    @cursor.update
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
  #--------------------------------------------------------------------------
  # * Override
  # * Move Cursor Down
  #--------------------------------------------------------------------------
  def cursor_down(wrap = false)
    return if @commands_disabled
    Sound.play_cursor
    Input.update
    deactivate
    call_ok_handler
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
  # * New Method
  # * Processing When Start Is Pressed
  #--------------------------------------------------------------------------
  def process_select
    return if @commands_disabled
    Sound.play_cursor
    super
  end
end
