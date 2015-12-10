#==============================================================================
# ** Window_MenuStatus
#------------------------------------------------------------------------------
#  This window displays party member status on the menu screen.
#  To display the cursor properly, reduce padding and offset window elements.
#==============================================================================

class Window_MenuStatus < Window_Base
  #--------------------------------------------------------------------------
  # * Constants (Positions)
  #--------------------------------------------------------------------------
  PADDING               = 6
  STATUS_WINDOW_WIDTH   = 460
  STATUS_WINDOW_HEIGHT  = 96
  MARGIN                = 4
  STATUS_OFFSET_X       = 96
  NAME_COLUMN_WIDTH     = 148
  HP_COLUMN_WIDTH       = 176
  HP_OFFSET_X           = 256
  #--------------------------------------------------------------------------
  # * Constants (Icons)
  #--------------------------------------------------------------------------
  FLAG_ICON             = 125
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader   :selected                 # selected
  attr_reader   :pending                  # pending
  #--------------------------------------------------------------------------
  # * Modified
  # * Object Initialization
  #     index : index of party member
  #--------------------------------------------------------------------------
  def initialize(index)
    super(0, index * STATUS_WINDOW_HEIGHT, STATUS_WINDOW_WIDTH, STATUS_WINDOW_HEIGHT)
    @index = index
    @selected = false
    @pending = false
    @cursor = Sprite_Cursor.new(self)
    refresh
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
    return STATUS_WINDOW_WIDTH
  end
  #--------------------------------------------------------------------------
  # * Get Item Height
  #--------------------------------------------------------------------------
  def item_height
    height - 24
  end
  #--------------------------------------------------------------------------
  # * Modified
  # * Draw Item
  #--------------------------------------------------------------------------
  def draw_item
    current_actor = $game_party.members[@index]
    contents.fill_rect(contents.rect, pending_color) if @pending
    draw_text(standard_padding, line_height + standard_padding, standard_padding * 2, line_height, @index + 1, Bitmap::ALIGN_CENTER) 
    draw_actor_face(current_actor, 3 * standard_padding, standard_padding)
    draw_icon(FLAG_ICON, 3 * standard_padding, contents.height - standard_padding - 24) if current_actor == $game_party.map_leader
    draw_actor_icons(current_actor, 3 * standard_padding, standard_padding)
    draw_actor_simple_status(current_actor, STATUS_OFFSET_X + standard_padding, standard_padding)
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Draw Simple Status
  #--------------------------------------------------------------------------
  def draw_actor_simple_status(actor, x, y)
    draw_actor_name(actor, x, y, NAME_COLUMN_WIDTH)
    draw_actor_level(actor, x, y + line_height * 1, NAME_COLUMN_WIDTH)
    draw_actor_hp(actor, HP_OFFSET_X + standard_padding, y, HP_COLUMN_WIDTH)
    draw_actor_mp(actor, HP_OFFSET_X + standard_padding, y + line_height * 1, HP_COLUMN_WIDTH)
    draw_actor_next_exp(actor, HP_OFFSET_X + standard_padding, y + line_height * 2, HP_COLUMN_WIDTH)
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Draw Next Experience
  #--------------------------------------------------------------------------
  def draw_actor_next_exp(actor, x, y, width)
    next_level_exp = actor.max_level? ? "-------" : actor.next_level_exp - actor.exp
    change_color(system_color)
    draw_text(x, y, width, line_height, Vocab::ExpNext, Bitmap::ALIGN_LEFT)
    change_color(normal_color)
    draw_text(x, y, width, line_height, next_level_exp, Bitmap::ALIGN_RIGHT)
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_item
  end
  #--------------------------------------------------------------------------
  # * Set Selected
  #--------------------------------------------------------------------------
  def selected=(selected)
    @selected = selected
    update_cursor
  end
  #--------------------------------------------------------------------------
  # * Set Pending
  #--------------------------------------------------------------------------
  def pending=(pending)
    @pending = pending
    update_cursor
  end
  #--------------------------------------------------------------------------
  # * Update Cursor
  #--------------------------------------------------------------------------
  def update_cursor
    if @selected
      cursor_rect.set(contents.rect.x + 1, contents.rect.y + 1, contents.rect.width - 2, contents.rect.height - 2)
      @cursor.show
      @cursor.x = viewport.rect.x + Sprite_Cursor::OFFSET_X
      @cursor.y = viewport.rect.y + self.y + cursor_rect.height - viewport.oy + Sprite_Cursor::OFFSET_Y
    else
      cursor_rect.empty
      @cursor.hide
    end
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Free
  #--------------------------------------------------------------------------
  def dispose
    @cursor.dispose
    super
  end
end
