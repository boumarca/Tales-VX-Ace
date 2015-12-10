#==============================================================================
# ** New Class
# ** Window_ManualSkillsList
#------------------------------------------------------------------------------
#  This window is for displaying a list of available skills when the setting is
#  set to manual or semi-auto mode.
#==============================================================================

class Window_ManualSkillsList < Window_SkillList
  #--------------------------------------------------------------------------
  # * Constants (Positions)
  #--------------------------------------------------------------------------
  WINDOW_WIDTH = 256
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :commands_disabled
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y)
    super(x, y)
    @slot_id = -1
    @commands_disabled = false
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
    fitting_height(11)
  end
  #--------------------------------------------------------------------------
  # * Set Skills Slot ID
  #--------------------------------------------------------------------------
  def slot_id=(slot_id)
    return if @slot_id == slot_id
    @slot_id = slot_id
    self.oy = 0
    refresh
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Processing When Y Is Pressed
  #--------------------------------------------------------------------------
  def process_y
    return if @commands_disabled
    super
  end
  #--------------------------------------------------------------------------
  # * Restore Previous Selection Position
  #--------------------------------------------------------------------------
  def select_last
    select(@data.index(@actor.last_skill.object) || 0)
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
    end
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Move Cursor Left
  #--------------------------------------------------------------------------
  def cursor_left(wrap = false)
    return if @commands_disabled
    process_cursor_cancel
  end
end
