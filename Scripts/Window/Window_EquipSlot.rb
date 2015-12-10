#==============================================================================
# ** Window_EquipSlot
#------------------------------------------------------------------------------
#  This window displays items the actor is currently equipped with on the
# equipment screen.
#==============================================================================

class Window_EquipSlot < Window_Selectable
  #--------------------------------------------------------------------------
  # * Constants (Positions)
  #--------------------------------------------------------------------------
  STATUS_X      = 112
  STATUS_WIDTH  = 168
  WINDOW_WIDTH  = 352
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader   :stat_window            # Stat window
  attr_reader   :item_window            # Item window
  #--------------------------------------------------------------------------
  # * Modified
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y)
    super(x, y, window_width, window_height)
    @actor = nil
    activate
    select(0)
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
    fitting_height(7)
  end
  #--------------------------------------------------------------------------
  # * Set Actor
  #--------------------------------------------------------------------------
  def actor=(actor)
    return if @actor == actor
    @actor = actor
    call_update_help
    refresh
  end
  #--------------------------------------------------------------------------
  # * Get Number of Items
  #--------------------------------------------------------------------------
  def item_max
    @actor ? @actor.equip_slots.size : 0
  end
  #--------------------------------------------------------------------------
  # * Get Item
  #--------------------------------------------------------------------------
  def item
    @actor ? @actor.equips[index] : nil
  end
  #--------------------------------------------------------------------------
  # * Draw Item
  #--------------------------------------------------------------------------
  def draw_item(index)
    return unless @actor
    rect = item_rect_for_text(index)
    change_color(system_color, enable?(index))
    draw_text(rect.x, rect.y, 92, line_height, slot_name(index))
    draw_item_name(@actor.equips[index], rect.x + 92, rect.y, enable?(index))
  end
  #--------------------------------------------------------------------------
  # * Get Equipment Slot Name
  #--------------------------------------------------------------------------
  def slot_name(index)
    @actor ? Vocab::etype(@actor.equip_slots[index]) : ""
  end
  #--------------------------------------------------------------------------
  # * Modified
  # * Display Equipment Slot in Enabled State?
  #--------------------------------------------------------------------------
  def enable?(index)
    @actor ? @actor.equip_change_ok?(index) : false
  end
  #--------------------------------------------------------------------------
  # * Modified
  # * Get Activation State of Selection Item
  #--------------------------------------------------------------------------
  def current_item_enabled?
    (enable?(index) && !@item_window.empty?)
  end
  #--------------------------------------------------------------------------
  # * Set Stat Window
  #--------------------------------------------------------------------------
  def stat_window=(stat_window)
    @stat_window = stat_window
    call_update_help
  end
  #--------------------------------------------------------------------------
  # * Set Item Window
  #--------------------------------------------------------------------------
  def item_window=(item_window)
    @item_window = item_window
  end
  #--------------------------------------------------------------------------
  # * Update Help Text
  #--------------------------------------------------------------------------
  def update_help
    super
    @help_window.set_item(item) if @help_window
    @stat_window.set_temp_actor(nil) if @stat_window
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Move Cursor Up
  #--------------------------------------------------------------------------
  def cursor_up(wrap = false)
    if row == 0
      process_up
    else
      super
    end
  end
  #--------------------------------------------------------------------------
  # * Modified
  # * Cursor Movement Processing
  #--------------------------------------------------------------------------
  def process_cursor_move
    super 
    @item_window.slot_id = index if @item_window
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Process Cursor Up
  #--------------------------------------------------------------------------
  def process_up
    Sound.play_cursor
    Input.update
    deactivate
    call_handler(:up)
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
  def cursor_right(wrap = false)
    process_cursor_ok unless @item_window.empty?
  end
end
