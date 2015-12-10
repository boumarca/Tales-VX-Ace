#==============================================================================
# ** Scene_Equip
#------------------------------------------------------------------------------
#  This class performs the equipment screen processing.
#==============================================================================

class Scene_Equip < Scene_MenuBase
  #--------------------------------------------------------------------------
  # * Constants (Positions)
  #--------------------------------------------------------------------------
  HELP_WINDOW_X   = 16
  HELP_WINDOW_Y   = 340
  STATUS_WINDOW_X = 16
  STATUS_WINDOW_Y = 52
  SLOT_WINDOW_X   = 16
  SLOT_WINDOW_Y   = 148
  ITEM_WINDOW_X   = 368
  ITEM_WINDOW_Y   = 52
  STAT_WINDOW_X   = 140
  STAT_WINDOW_Y   = 52
  #--------------------------------------------------------------------------
  # * Modified
  # * Start Processing
  #--------------------------------------------------------------------------
  def start
    super
    create_header_window(Vocab::EQUIP)
    create_help_window
    create_status_window
    create_slot_window
    create_stat_window
    create_item_window
    set_controls_help
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Create Help Window
  #--------------------------------------------------------------------------
  def create_help_window
    @help_window = Window_ItemHelp.new(HELP_WINDOW_X, HELP_WINDOW_Y)
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Create Status Window
  #--------------------------------------------------------------------------
  def create_status_window
    @status_window = Window_ActorStatus.new(STATUS_WINDOW_X, STATUS_WINDOW_Y)
    @status_window.actor = @actor
    @status_window.set_handler(:ok,       method(:on_status_ok))
    @status_window.set_handler(:cancel,   method(:return_scene))
    @status_window.set_handler(:y,        method(:command_optimize))
    @status_window.set_handler(:pagedown, method(:next_actor))
    @status_window.set_handler(:pageup,   method(:prev_actor))
  end
  #--------------------------------------------------------------------------
  # * Modified
  # * Create Slot Window
  #--------------------------------------------------------------------------
  def create_slot_window
    @slot_window = Window_EquipSlot.new(SLOT_WINDOW_X, SLOT_WINDOW_Y)
    @slot_window.help_window = @help_window
    @slot_window.actor = @actor
    @slot_window.set_handler(:ok,       method(:on_slot_ok))
    @slot_window.set_handler(:cancel,   method(:return_scene))
    @slot_window.set_handler(:up,       method(:status_return))
    @slot_window.set_handler(:x,        method(:command_clear))
    @slot_window.set_handler(:start,    method(:on_toggle_help))
    @slot_window.set_handler(:pagedown, method(:next_actor))
    @slot_window.set_handler(:pageup,   method(:prev_actor))
  end
  #--------------------------------------------------------------------------
  # * Modified
  # * Create Stat Window
  #--------------------------------------------------------------------------
  def create_stat_window
    @stat_window = Window_EquipStat.new(STAT_WINDOW_X, STAT_WINDOW_Y)
    @stat_window.actor = @actor
    @stat_window.hide
  end
  #--------------------------------------------------------------------------
  # * Modified
  # * Create Item Window
  #--------------------------------------------------------------------------
  def create_item_window
    @item_window = Window_EquipItem.new(ITEM_WINDOW_X, ITEM_WINDOW_Y)
    @item_window.help_window = @help_window
    @item_window.stat_window = @stat_window
    @item_window.actor = @actor
    @item_window.set_handler(:ok,     method(:on_item_ok))
    @item_window.set_handler(:cancel, method(:on_item_cancel))
    @item_window.set_handler(:start,  method(:on_toggle_help))
    @slot_window.item_window = @item_window
  end
  #--------------------------------------------------------------------------
  # * [Ultimate Equipment] Command
  #--------------------------------------------------------------------------
  def command_optimize
    Sound.play_ok
    @actor.optimize_equipments
    @slot_window.refresh
    @item_window.refresh
  end
  #--------------------------------------------------------------------------
  # * Modified
  # * [Remove] Command
  #--------------------------------------------------------------------------
  def command_clear
    if !@actor.equips[@slot_window.index].nil? && @slot_window.index != 0
      Sound.play_ok
      @actor.change_equip(@slot_window.index, nil)
      @slot_window.refresh
      @item_window.refresh
      @help_window.clear
    else
      Sound.play_buzzer
    end
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Return to Status Window
  #--------------------------------------------------------------------------
  def status_return
    @slot_window.unselect
    @status_window.activate
    @help_window.clear
    set_controls_help
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Status [OK]
  #--------------------------------------------------------------------------
  def on_status_ok
    @slot_window.activate.select(0)
    set_controls_help
  end
  #--------------------------------------------------------------------------
  # * Modified
  # * Slot [OK]
  #--------------------------------------------------------------------------
  def on_slot_ok
    @item_window.activate.select(0)
    @stat_window.show
    set_controls_help
  end
  #--------------------------------------------------------------------------
  # * Modified
  # * Item [OK]
  #--------------------------------------------------------------------------
  def on_item_ok
    Sound.play_ok
    @actor.change_equip(@slot_window.index, @item_window.item)
    @slot_window.activate.refresh
    @item_window.unselect
    @item_window.refresh
    @stat_window.hide
    set_controls_help
  end
  #--------------------------------------------------------------------------
  # * Modified
  # * Item [Cancel]
  #--------------------------------------------------------------------------
  def on_item_cancel
    @slot_window.activate
    @item_window.unselect
    @stat_window.hide
    set_controls_help
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Item [Start]
  #--------------------------------------------------------------------------
  def on_toggle_help
    @help_window.toggle_text
  end
  #--------------------------------------------------------------------------
  # * Change Actors
  #--------------------------------------------------------------------------
  def on_actor_change
    @stat_window.actor = @actor
    @slot_window.actor = @actor
    @item_window.actor = @actor
    @status_window.actor = @actor
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Set Control Help 
  #--------------------------------------------------------------------------
  def set_controls_help
    @control_help_window.clear
    set_status_controls   if @status_window.active
    set_slots_controls    if @slot_window.active 
    set_item_controls     if @item_window.active
    @control_help_window.refresh
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Set Controls For Status Window 
  #--------------------------------------------------------------------------
  def set_status_controls
    @control_help_window.add_control(Vocab::EQUIP,        :A) 
    @control_help_window.add_control(Vocab::BACK,         :B)
    @control_help_window.add_control(Vocab::OPTIMIZE,     :X)
    @control_help_window.add_control(Vocab::CHANGE_ACTOR, :L, :R)
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Set Controls For Slots Window 
  #--------------------------------------------------------------------------
  def set_slots_controls
    @control_help_window.add_control(Vocab::CONFIRM,      :A) 
    @control_help_window.add_control(Vocab::BACK,         :B)
    @control_help_window.add_control(Vocab::REMOVE,       :X)
    @control_help_window.add_control(Vocab::CHANGE_ACTOR, :L, :R)
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Set Controls For Item Window 
  #--------------------------------------------------------------------------
  def set_item_controls
    @control_help_window.add_control(Vocab::CONFIRM, :A) 
    @control_help_window.add_control(Vocab::BACK,    :B)
  end
end
