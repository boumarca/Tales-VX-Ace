#==============================================================================
# ** New Class
# ** Window_CapacitiesList
#------------------------------------------------------------------------------
#  This window is for displaying a list of available capacities.
#==============================================================================

class Window_CapacitiesList < Window_Selectable
  #--------------------------------------------------------------------------
  # * Constants (Positions)
  #--------------------------------------------------------------------------
  WINDOW_WIDTH = 608
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y)
    super(x, y, window_width, window_height)
    @category = :none
    @actor = nil
    @data = []
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
  # * Set Category
  #--------------------------------------------------------------------------
  def category=(category)
    return if @category == category
    @category = category
    refresh
    self.oy = 0
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Get Digit Count
  #--------------------------------------------------------------------------
  def col_max
    return 2
  end
  #--------------------------------------------------------------------------
  # * Select Capacity
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
  # * Get Capacity
  #--------------------------------------------------------------------------
  def item
    @data && index >= 0 ? @data[index] : nil
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Get Activation State of Selection Item
  #--------------------------------------------------------------------------
  def current_item_enabled?
    return false if item.nil?
    @actor && @actor.capacity_cost_payable?(item) || @actor.capacity_active?(item)
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Display Capacity in Enable State?
  #--------------------------------------------------------------------------
  def enable?(item)
    #@actor && @actor.capacity_cost_payable?(item) || @actor.capacity_active?(item)
    @actor && @actor.capacity_active?(item)
  end
  #--------------------------------------------------------------------------
  # * Create Capacity List
  #--------------------------------------------------------------------------
  def make_item_list
    @data = @actor.capacities.select {|item| include?(item)}
    @data.push(nil) if include?(nil)
  end
  #--------------------------------------------------------------------------
  # * Include in Capacity List?
  #--------------------------------------------------------------------------
  def include?(item)
    case @category
    when :all
      item.is_a?(RPG::Capacity)
    when :parameter
      item.is_a?(RPG::Capacity) && item.parameter_capacity?
    when :action
      item.is_a?(RPG::Capacity) && item.action_capacity?
    when :support
      item.is_a?(RPG::Capacity) && item.support_capacity?
    when :set
      item.is_a?(RPG::Capacity) && @actor.capacity_active?(item)
    else
      false
    end
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Draw Item
  #--------------------------------------------------------------------------
  def draw_item(index)
    capacity = @data[index]
    if capacity
      rect = item_rect(index)
      rect.width -= 4
      draw_item_name(capacity, rect.x, rect.y, enable?(capacity))
      draw_item_number(rect, capacity, enable?(capacity))
    end
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Draw Number of Items
  #--------------------------------------------------------------------------
  def draw_item_number(rect, item, enabled = true)
    change_color(normal_color, enabled)
    draw_text(rect, item.sp_cost, Bitmap::ALIGN_RIGHT)
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
end