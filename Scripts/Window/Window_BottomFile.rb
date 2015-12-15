#==============================================================================
# ** New Class
# ** Window_BottomFile
#------------------------------------------------------------------------------
#  This window displays save files bottom window on the save and load screens.
#==============================================================================

class Window_BottomFile < Window_Base
  #--------------------------------------------------------------------------
  # * Constants (Positions)
  #--------------------------------------------------------------------------
  WINDOW_WIDTH = 512
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     index : index of save files
  #--------------------------------------------------------------------------
  def initialize(x, y)
    super(x, y, window_width, fitting_height(4))
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Get Window Width
  #--------------------------------------------------------------------------
  def window_width
    return WINDOW_WIDTH
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_save_time
    draw_location
    draw_money
    draw_grade
    draw_encounter
    draw_combo
  end
  #--------------------------------------------------------------------------
  # * Draw Save Time
  #--------------------------------------------------------------------------
  def draw_save_time
    change_color(system_color)
    draw_text(0, 0, contents.rect.width, line_height, Vocab::SAVE_TIME, Bitmap::ALIGN_LEFT)
    return unless @header
    change_color(normal_color)
    draw_text(0, 0, contents.rect.width, line_height, @header[:save_time].strftime("%d/%m/%Y, %H:%M:%S"), Bitmap::ALIGN_RIGHT)
  end
  #--------------------------------------------------------------------------
  # * Draw Location
  #--------------------------------------------------------------------------
  def draw_location
    change_color(system_color)
    draw_text(0, line_height, contents.rect.width, line_height, Vocab::LOCATION, Bitmap::ALIGN_LEFT)
    return unless @header
    change_color(normal_color)
    draw_text(0, line_height, contents.rect.width, line_height, @header[:location], Bitmap::ALIGN_RIGHT)
  end
  #--------------------------------------------------------------------------
  # * Draw Money
  #--------------------------------------------------------------------------
  def draw_money
    change_color(system_color)
    draw_text(0, line_height * 2, contents.rect.width / 2 - standard_padding, line_height, Vocab.currency_unit, Bitmap::ALIGN_LEFT)
    return unless @header
    #money = @header[:money].group unless @header[:money].nil?
    change_color(normal_color)
    draw_text(0, line_height * 2, contents.rect.width / 2 - standard_padding, line_height, @header[:money].group, Bitmap::ALIGN_RIGHT)
  end
  #--------------------------------------------------------------------------
  # * Draw Grade
  #--------------------------------------------------------------------------
  def draw_grade
    change_color(system_color)
    draw_text(0, line_height * 3, contents.rect.width / 2 - standard_padding, line_height, Vocab::GRADE, Bitmap::ALIGN_LEFT)
    return unless @header
    change_color(normal_color)
    draw_text(0, line_height * 3, contents.rect.width / 2 - standard_padding, line_height, @header[:grade], Bitmap::ALIGN_RIGHT)
  end
  #--------------------------------------------------------------------------
  # * Draw Encounter
  #--------------------------------------------------------------------------
  def draw_encounter
    change_color(system_color)
    draw_text(contents.rect.width / 2, line_height * 2, contents.rect.width / 2, line_height, Vocab::ENCOUNTER, Bitmap::ALIGN_LEFT)
    return unless @header
    change_color(normal_color)
    draw_text(contents.rect.width / 2, line_height * 2, contents.rect.width / 2, line_height, @header[:encounter], Bitmap::ALIGN_RIGHT)
  end
  #--------------------------------------------------------------------------
  # * Draw Combo
  #--------------------------------------------------------------------------
  def draw_combo
    change_color(system_color)
    draw_text(contents.rect.width / 2, line_height * 3, contents.rect.width / 2, line_height, Vocab::COMBO, Bitmap::ALIGN_LEFT)
    return unless @header
    change_color(normal_color)
    draw_text(contents.rect.width / 2, line_height * 3, contents.rect.width / 2, line_height, @header[:combo], Bitmap::ALIGN_RIGHT)
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Load File Header
  #--------------------------------------------------------------------------
  def load_header(index)
    @header = DataManager.load_header(index)
    refresh
  end
end