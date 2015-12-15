#==============================================================================
# ** New Class
# ** Scene_Capacity
#------------------------------------------------------------------------------
#  This class performs capacities screen processing. Capacities are handled as 
# items for the sake of process sharing.
#==============================================================================

class Scene_Capacity < Scene_MenuBase
  #--------------------------------------------------------------------------
  # * Constants (Positions)
  #--------------------------------------------------------------------------
  HELP_WINDOW_X             = 16
  HELP_WINDOW_Y             = 340
  STATUS_WINDOW_X           = 16
  STATUS_WINDOW_Y           = 52
  CATEGORY_WINDOW_X         = 368
  CATEGORY_WINDOW_Y         = 112
  CAPACITIES_WINDOW_X       = 16
  CAPACITIES_WINDOW_Y       = 148
  CAPACITIES_WINDOW_HEIGHT  = 192
  SP_WINDOW_X               = 368
  SP_WINDOW_Y               = 52
  #--------------------------------------------------------------------------
  # * Override
  # * Start Processing
  #--------------------------------------------------------------------------
  def start
    super
    create_header_window(Vocab::CAPACITIES)
    create_help_window
    create_status_window
    create_category_window
    create_capacities_list
    create_sp_window
    set_controls_help
  end
  #--------------------------------------------------------------------------
  # * Create Status Window
  #--------------------------------------------------------------------------
  def create_status_window
    @status_window = Window_ActorStatus.new(STATUS_WINDOW_X, STATUS_WINDOW_Y)
    @status_window.actor = @actor
    @status_window.set_handler(:ok,       method(:on_status_ok))
    @status_window.set_handler(:cancel,   method(:return_scene))
    @status_window.set_handler(:x,        method(:on_deactivate_all))
    @status_window.set_handler(:pagedown, method(:next_actor))
    @status_window.set_handler(:pageup,   method(:prev_actor))
  end
  #--------------------------------------------------------------------------
  # * Create Capacities List
  #--------------------------------------------------------------------------
  def create_capacities_list
    @capacities_list_window = Window_CapacitiesList.new(CAPACITIES_WINDOW_X, CAPACITIES_WINDOW_Y)
    @capacities_list_window.set_handler(:ok,       method(:on_capacity_ok))
    @capacities_list_window.set_handler(:cancel,   method(:return_scene))
    @capacities_list_window.set_handler(:up,       method(:status_return))
    @capacities_list_window.set_handler(:pagedown, method(:next_category))
    @capacities_list_window.set_handler(:pageup,   method(:prev_category))
    @capacities_list_window.actor = @actor
    @capacities_list_window.help_window = @help_window
    @category_window.item_window = @capacities_list_window
    @capacities_list_window.activate.select(0)
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Create Help Window
  #--------------------------------------------------------------------------
  def create_help_window
    @help_window = Window_CapacityHelp.new(HELP_WINDOW_X, HELP_WINDOW_Y)
  end
  #--------------------------------------------------------------------------
  # * Create Category Window
  #--------------------------------------------------------------------------
  def create_category_window
    @category_window = Window_CapacitiesCategory.new(CATEGORY_WINDOW_X, CATEGORY_WINDOW_Y)
  end
  #--------------------------------------------------------------------------
  # * Create SP Window
  #--------------------------------------------------------------------------
  def create_sp_window
    @sp_window = Window_SP.new(SP_WINDOW_X, SP_WINDOW_Y)
    @sp_window.actor = @actor
  end
  #--------------------------------------------------------------------------
  # * Get Currently Selected Item
  #--------------------------------------------------------------------------
  def item
    @capacities_list_window.item
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Change Actors
  #--------------------------------------------------------------------------
  def on_actor_change
    @capacities_list_window.actor = @actor
    @status_window.actor = @actor
    @sp_window.actor = @actor
    @help_window.clear
  end
  #--------------------------------------------------------------------------
  # * Status Window [Ok]
  #--------------------------------------------------------------------------
  def on_status_ok
    @capacities_list_window.activate.select(0)
    set_controls_help
  end
  #--------------------------------------------------------------------------
  # * Status Window [X] : Deactivate All Capacities
  #--------------------------------------------------------------------------
  def on_deactivate_all
    Sound.play_ok
    @actor.active_capacities.each{ |capacity| @actor.deactivate_capacity(capacity) }
    @status_window.refresh
    @sp_window.refresh
    @capacities_list_window.refresh
  end
  #--------------------------------------------------------------------------
  # * Capacity Window [Ok]
  #--------------------------------------------------------------------------
  def on_capacity_ok
    if @actor.capacity_active?(item)
      @actor.deactivate_capacity(item)
    else
      @actor.activate_capacity(item) if @actor.capacity_cost_payable?(item)
    end
    @status_window.refresh
    @sp_window.refresh
    update_capacities_window
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Update capacities window
  #--------------------------------------------------------------------------
  def update_capacities_window
    @capacities_list_window.activate.refresh
    @capacities_list_window.adjust_cursor if @capacities_list_window.item.nil?
    @capacities_list_window.update_help
  end
  #--------------------------------------------------------------------------
  # * Change to next category
  #--------------------------------------------------------------------------
  def next_category
     @category_window.cursor_right
     @capacities_list_window.activate.select(0)
  end
  #--------------------------------------------------------------------------
  # * Change to previous category
  #--------------------------------------------------------------------------
  def prev_category
     @category_window.cursor_left
     @capacities_list_window.activate.select(0)
end
  #--------------------------------------------------------------------------
  # * Return to Status Window
  #--------------------------------------------------------------------------
  def status_return
    @capacities_list_window.unselect
    @status_window.activate
    @help_window.clear
    set_controls_help
  end
  #--------------------------------------------------------------------------
  # * Set Control Help 
  #--------------------------------------------------------------------------
  def set_controls_help
    @control_help_window.clear
    set_status_controls     if @status_window.active
    set_capacities_controls if @capacities_list_window.active
    @control_help_window.refresh
  end
  #--------------------------------------------------------------------------
  # * Set Controls For Status Window 
  #--------------------------------------------------------------------------
  def set_status_controls
    @control_help_window.add_control(Vocab::CAPACITIES,   Input::Keys::A) 
    @control_help_window.add_control(Vocab::BACK,         Input::Keys::B)
    @control_help_window.add_control(Vocab::REMOVE_ALL,   Input::Keys::X)
    @control_help_window.add_control(Vocab::CHANGE_ACTOR, Input::Keys::L, Input::Keys::R)
  end
  #--------------------------------------------------------------------------
  # * Set Controls For Capacities Window 
  #--------------------------------------------------------------------------
  def set_capacities_controls
    @control_help_window.add_control(Vocab::TOGGLE,           Input::Keys::A) 
    @control_help_window.add_control(Vocab::BACK,             Input::Keys::B)
    @control_help_window.add_control(Vocab::CHANGE_CATEGORY,  Input::Keys::L, Input::Keys::R)
  end
end
