#==============================================================================
# ** New Class
# ** Window_AutoSkillsList
#------------------------------------------------------------------------------
#  This window is for displaying a list of available skills when 
#  the setting is set to auto mode. 
#==============================================================================

class Window_AutoSkillsList < Window_SkillList
  #--------------------------------------------------------------------------
  # * Constants (Positions)
  #--------------------------------------------------------------------------
  STATUS_X      = 112
  STATUS_WIDTH  = 168
  COLUMNS       = 2
  ROWS          = 7
  WINDOW_WIDTH  = 608
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
    fitting_height(7)
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Get Digit Count
  #--------------------------------------------------------------------------
  def col_max
    return COLUMNS
  end
  #--------------------------------------------------------------------------
  # * Display Skill in Active State?
  #--------------------------------------------------------------------------
  def active?(item)
    @actor && @actor.skill_active?(item)
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Draw Item
  #--------------------------------------------------------------------------
  def draw_item(index)
    skill = @data[index]
    if skill
      rect = item_rect(index)
      rect.width -= 4
      draw_item_name(skill, rect.x, rect.y, enable?(skill))
      draw_auto_use(skill, rect.x, rect.y, rect.width)
    end
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Draw Use In Battle On or Off
  #--------------------------------------------------------------------------
  def draw_auto_use(skill, x, y, width)
    return unless skill
    str = @actor.skill_active?(skill) ? Vocab::SKILL_ON : Vocab::SKILL_OFF
    draw_text(x, y, width, line_height, str, Bitmap::ALIGN_RIGHT)
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
  # * Process X
  #--------------------------------------------------------------------------
  def process_x
    Sound.play_ok
    super
  end
end