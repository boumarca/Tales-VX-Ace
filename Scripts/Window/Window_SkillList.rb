#==============================================================================
# ** New Class
# ** Window_SkillsList
#------------------------------------------------------------------------------
#  This is the super class for any window displaying skill lists.
#==============================================================================

class Window_SkillList < Window_Selectable
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :used_from_here   #if skill is used from this window
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y)
    super(x, y, window_width, window_height)
    @actor = nil
    @data = []
  end
  #--------------------------------------------------------------------------
  # * Get Window Width
  #--------------------------------------------------------------------------
  def window_width
  end
  #--------------------------------------------------------------------------
  # * Get Window Height
  #--------------------------------------------------------------------------
  def window_height
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Select Skill From Slot
  #--------------------------------------------------------------------------
  def select_item(item)
    index = @data.index(item)
    select(index ? index : 0)
  end
  #--------------------------------------------------------------------------
  # * Set Actor
  #--------------------------------------------------------------------------
  def actor=(actor)
    return if @actor == actor
    @actor = actor
    self.oy = 0
    refresh
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Get Number of Items
  #--------------------------------------------------------------------------
  def item_max
    @data ? @data.size : 1
  end
  #--------------------------------------------------------------------------
  # * Get Skill
  #--------------------------------------------------------------------------
  def item
    @data && index >= 0 ? @data[index] : nil
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Processing When Y Is Pressed
  #--------------------------------------------------------------------------
  def process_y
    if usable?(item)
      @used_from_here = true
      Sound.play_ok
      Input.update
      deactivate
      call_y_handler
    else
      Sound.play_buzzer
    end
  end
  #--------------------------------------------------------------------------
  # * Return if Skill is Usable?
  #--------------------------------------------------------------------------
  def usable?(item)
    enable?(item) && @actor.usable?(item)
  end
  #--------------------------------------------------------------------------
  # * Display Skill in Enable State?
  #--------------------------------------------------------------------------
  def enable?(item)
    @actor && @actor.skill_cost_payable?(item)
  end
  #--------------------------------------------------------------------------
  # * Create Skill List
  #--------------------------------------------------------------------------
  def make_item_list
    @data = @actor ? @actor.skills : []
  end
  #--------------------------------------------------------------------------
  # * Restore Previous Selection Position
  #--------------------------------------------------------------------------
  def select_last
    select(@data.index(@actor.last_skill.object) || 0)
  end
  #--------------------------------------------------------------------------
  # * Update Help Text
  #--------------------------------------------------------------------------
  def update_help
    @help_window.set_item(item)
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    make_item_list
    create_contents
    draw_all_items
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Determine if list is empty
  #--------------------------------------------------------------------------
  def empty?
    @data.empty?
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Determine if Cursor is Moveable
  #--------------------------------------------------------------------------
  def cursor_movable?
    active && open? && !@cursor_fix && !@cursor_all
  end
end
