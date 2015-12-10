#==============================================================================
# ** New Class
# ** Window_Side
#------------------------------------------------------------------------------
#  This window display various informations at the right of the main menu.
#==============================================================================

class Window_Side < Window_Base
  #--------------------------------------------------------------------------
  # * Constants (Positions)
  #--------------------------------------------------------------------------
  SIDE_WINDOW_WIDTH   = 148
  SIDE_WINDOW_HEIGHT  = 384
  MARGIN_X            = 0
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y)
    super(x, y, window_width, window_height)
    refresh
  end
  #--------------------------------------------------------------------------
  # * Get Window Width
  #--------------------------------------------------------------------------
  def window_width
    return SIDE_WINDOW_WIDTH
  end
  #--------------------------------------------------------------------------
  # * Get Window Height
  #--------------------------------------------------------------------------
  def window_height
    return SIDE_WINDOW_HEIGHT
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    @playtime_old = $game_system.playtime
    draw_element_with_title(money.group, currency_title, MARGIN_X, line_height * 0, contents.width)
    draw_element_with_title(grade.group, grade_title, MARGIN_X, line_height * 3, contents.width)
    draw_element_with_title(playtime, playtime_title, MARGIN_X, line_height * 6, contents.width)
    draw_element_with_title(encounter, encounter_title, MARGIN_X, line_height * 9, contents.width)
    draw_element_with_title(combo, combo_title, MARGIN_X, line_height * 12, contents.width)
  end
  #--------------------------------------------------------------------------
  # * Draw Element with Amount
  #--------------------------------------------------------------------------
  def draw_element_with_title(element, title, x, y, width)
    change_color(system_color)
    draw_text(x, y, width, line_height, title, Bitmap::ALIGN_LEFT)
    change_color(normal_color)
    draw_text(x, y + line_height, width, line_height, element, Bitmap::ALIGN_RIGHT)
  end
  #--------------------------------------------------------------------------
  # * Update
  #--------------------------------------------------------------------------
  def update
    super
    if Graphics.frame_count / Graphics.frame_rate != @playtime_old
      refresh
    end
  end
  #--------------------------------------------------------------------------
  # * Get Party Money
  #--------------------------------------------------------------------------
  def money
    $game_party.gold
  end
  #--------------------------------------------------------------------------
  # * Get Currency Title
  #--------------------------------------------------------------------------
  def currency_title
    Vocab::currency_unit
  end
  #--------------------------------------------------------------------------
  # * Get Party Grade
  #--------------------------------------------------------------------------
  def grade
    $game_party.grade
  end
  #--------------------------------------------------------------------------
  # * Get Grade Title
  #--------------------------------------------------------------------------
  def grade_title
    Vocab::GRADE
  end
  #--------------------------------------------------------------------------
  # * Get Playtime
  #--------------------------------------------------------------------------
  def playtime
    $game_system.playtime_s
  end
  #--------------------------------------------------------------------------
  # * Get Playtime Title
  #--------------------------------------------------------------------------
  def playtime_title
    Vocab::PLAYTIME
  end
  #--------------------------------------------------------------------------
  # * Get Encounter Number
  #--------------------------------------------------------------------------
  def encounter
    $game_system.battle_count
  end
  #--------------------------------------------------------------------------
  # * Get Encounter Title
  #--------------------------------------------------------------------------
  def encounter_title
    Vocab::ENCOUNTER
  end
  #--------------------------------------------------------------------------
  # * Get Combo Number
  #--------------------------------------------------------------------------
  def combo
    $game_party.max_combo
  end
  #--------------------------------------------------------------------------
  # * Get Combo Title
  #--------------------------------------------------------------------------
  def combo_title
    Vocab::COMBO
  end
end
