#==============================================================================
# ** Window_SaveFile
#------------------------------------------------------------------------------
#  This window displays save files on the save and load screens.
#==============================================================================

class Window_SaveFile < Window_Base
  #--------------------------------------------------------------------------
  # * Constants (Positions)
  #--------------------------------------------------------------------------
  PADDING             = 5
  WINDOW_WIDTH        = 96
  #--------------------------------------------------------------------------
  # * Constants (Icons)
  #--------------------------------------------------------------------------
  NEW_GAME_PLUS_ICON  = 125
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader   :selected                 # selected
  #--------------------------------------------------------------------------
  # * Modified
  # * Object Initialization
  #     index : index of save files
  #--------------------------------------------------------------------------
  def initialize(index)
    super(0, index * fitting_height(2), WINDOW_WIDTH, fitting_height(2))
    @file_index = index
    @header = DataManager.load_header(@file_index)
    @selected = false
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
  # * Reload Window
  #--------------------------------------------------------------------------  
  def reload
    @header = DataManager.load_header(@file_index)
    refresh
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_file_number
    draw_playtime
    draw_new_game_plus
  end
  #--------------------------------------------------------------------------
  # * Draw File Number
  #--------------------------------------------------------------------------
  def draw_file_number
    change_color(normal_color)
    draw_text(4, 0, WINDOW_WIDTH, line_height, "#{@file_index + 1}")
  end
  #--------------------------------------------------------------------------
  # * Draw Play Time
  #--------------------------------------------------------------------------
  def draw_playtime
    return unless @header
    draw_text(4, line_height, contents.width, line_height, @header[:playtime_s], Bitmap::ALIGN_CENTER)
  end
  #--------------------------------------------------------------------------
  # * Draw New Game Plus Icon
  #--------------------------------------------------------------------------
  def draw_new_game_plus
    return unless @header
    draw_icon(NEW_GAME_PLUS_ICON, contents.rect.width - 26, 2) if @header[:new_game_plus]
  end
  #--------------------------------------------------------------------------
  # * Set Selected
  #--------------------------------------------------------------------------
  def selected=(selected)
    @selected = selected
    update_cursor
  end
  #--------------------------------------------------------------------------
  # * Update Cursor
  #--------------------------------------------------------------------------
  def update_cursor
    if @selected
      cursor_rect.set(contents.rect.x + 2, contents.rect.y + 2, contents.rect.width - 4, contents.rect.height - 4)
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
