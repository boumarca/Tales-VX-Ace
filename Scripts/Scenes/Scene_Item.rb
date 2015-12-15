#==============================================================================
# ** Scene_Item
#------------------------------------------------------------------------------
#  This class performs the item screen processing.
#==============================================================================

class Scene_Item < Scene_ItemBase
  #--------------------------------------------------------------------------
  # * Constants (Positions)
  #--------------------------------------------------------------------------
  HELP_WINDOW_X     = 16
  HELP_WINDOW_Y     = 340
  ITEM_WINDOW_X     = 16
  ITEM_WINDOW_Y     = 52
  CATEGORY_WINDOW_X = 372
  CATEGORY_WINDOW_Y = 16
  #--------------------------------------------------------------------------
  # * Modified
  # * Start Processing
  #--------------------------------------------------------------------------
  def start
    super
    create_header_window(Vocab::ITEM)
    create_help_window
    create_category_window
    create_item_window
    create_quick_equip_window
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
  # * Modified
  # * Create Category Window
  #--------------------------------------------------------------------------
  def create_category_window
    @category_window = Window_ItemCategory.new(CATEGORY_WINDOW_X, CATEGORY_WINDOW_Y)
    @category_window.help_window = @help_window
    @category_window.set_handler(:ok,       method(:on_category_ok))
    @category_window.set_handler(:cancel,   method(:return_scene))
    @category_window.set_handler(:down,     method(:on_category_ok))
    @category_window.set_handler(:pagedown, method(:next_category))
    @category_window.set_handler(:pageup,   method(:prev_category))
  end
  #--------------------------------------------------------------------------
  # * Modified
  # * Create Item Window
  #--------------------------------------------------------------------------
  def create_item_window
    @item_window = Window_MenuItemList.new(ITEM_WINDOW_X, ITEM_WINDOW_Y)
    @item_window.help_window = @help_window
    @item_window.set_handler(:ok,       method(:on_item_ok))
    @item_window.set_handler(:cancel,   method(:return_scene))
    @item_window.set_handler(:up,       method(:category_return))
    @item_window.set_handler(:start,    method(:on_toggle_help))
    @item_window.set_handler(:x,        method(:on_item_drop))
    @item_window.set_handler(:pagedown, method(:next_category))
    @item_window.set_handler(:pageup,   method(:prev_category))
    @category_window.item_window = @item_window
    @item_window.activate
    @item_window.select(0)
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Create Quick Equip Window
  #--------------------------------------------------------------------------
  def create_quick_equip_window
    @equip_window = Window_QuickEquip.new(0, ACTOR_WINDOW_Y)
    @equip_window.x = Graphics.width / 2 - @equip_window.window_width / 2
    @equip_window.set_handler(:ok,     method(:on_equip_ok))
    @equip_window.set_handler(:cancel, method(:on_equip_cancel))
    @equip_window.z = 200
    @equip_window.visible = false
  end
  #--------------------------------------------------------------------------
  # * Category [OK]
  #--------------------------------------------------------------------------
  def on_category_ok
    @item_window.activate.select(0)
    set_controls_help
  end
  #--------------------------------------------------------------------------
  # * Modified
  # * Item [OK]
  #--------------------------------------------------------------------------
  def on_item_ok
    $game_party.last_item.object = item
    determine_item if item.is_a?(RPG::UsableItem)
    determine_equip if item.is_a?(RPG::EquipItem)
  end
  #--------------------------------------------------------------------------
  # * Item [Up]
  #--------------------------------------------------------------------------
  def category_return
    @item_window.unselect
    @category_window.activate
    set_controls_help
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Item [Start] : Toggle Description
  #--------------------------------------------------------------------------
  def on_toggle_help
    @help_window.toggle_text
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Item [Drop]
  #--------------------------------------------------------------------------
  def on_item_drop
    @system_window = Window_SystemChoice.new(sprintf(Vocab::ITEM_DROP, item.name))
    @system_window.set_handler(:ok, method(:drop_item))
    @system_window.change_context(@item_window)
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Equip [OK]
  #--------------------------------------------------------------------------
  def on_equip_ok
    if $game_party.target_actor.equippable?(item)
      equip_item
    else
      Sound.play_buzzer
    end
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Equip [Cancel]
  #--------------------------------------------------------------------------
  def on_equip_cancel
    hide_sub_window(@equip_window)
  end
  #--------------------------------------------------------------------------
  # * Play SE When Using Item
  #--------------------------------------------------------------------------
  def play_se_for_item
    Sound.play_use_item
  end
  #--------------------------------------------------------------------------
  # * Modified
  # * Use Item
  #--------------------------------------------------------------------------
  def use_item
    hide_sub_window(@actor_window) if last_item?
    super
    update_item_window
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Drop Item
  #--------------------------------------------------------------------------
  def drop_item
    $game_party.lose_item(item, 1)
    update_item_window
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Determine Equip
  #--------------------------------------------------------------------------
  def determine_equip
    @equip_window.item = item
    show_sub_window(@equip_window)
    @equip_window.select_last
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Equip Item
  #--------------------------------------------------------------------------
  def equip_item
    hide_sub_window(@equip_window) if last_item?
    Sound.play_ok
    $game_party.target_actor.change_equip(item.etype_id, item)
    @equip_window.refresh
    update_item_window
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Check if last item
  #--------------------------------------------------------------------------
  def last_item?
    $game_party.item_container(item.class)[item.id] == 1
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Update item window
  #--------------------------------------------------------------------------
  def update_item_window
    @item_window.refresh
    @item_window.adjust_cursor if @item_window.item.nil?
    @item_window.update_help
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Change to next category
  #--------------------------------------------------------------------------
  def next_category
    @category_window.cursor_right
    @item_window.select(0) if @item_window.active
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Change to previous category
  #--------------------------------------------------------------------------
  def prev_category
    @category_window.cursor_left
    @item_window.select(0) if @item_window.active
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Set Control Help 
  #--------------------------------------------------------------------------
  def set_controls_help
    @control_help_window.clear
    set_category_controls if @category_window.active
    set_item_controls     if @item_window.active
    set_actor_controls    if @actor_window.active || @equip_window.active
    @control_help_window.refresh
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Set Controls For Category Window 
  #--------------------------------------------------------------------------
  def set_category_controls
    @control_help_window.add_control(Vocab::ITEM,             Input::Keys::A) 
    @control_help_window.add_control(Vocab::BACK,             Input::Keys::B)
    @control_help_window.add_control(Vocab::CHANGE_CATEGORY,  Input::Keys::L, Input::Keys::R)
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Set Controls For Item Window 
  #--------------------------------------------------------------------------
  def set_item_controls
    @control_help_window.add_control(Vocab::USE,              Input::Keys::A) 
    @control_help_window.add_control(Vocab::BACK,             Input::Keys::B)
    @control_help_window.add_control(Vocab::DROP,             Input::Keys::X)
    @control_help_window.add_control(Vocab::CHANGE_CATEGORY,  Input::Keys::L, Input::Keys::R)
    @control_help_window.add_control(Vocab::DESCRIPTION,      Input::Keys::START)
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Set Controls For Actor Window 
  #--------------------------------------------------------------------------
  def set_actor_controls
    @control_help_window.add_control(Vocab::CONFIRM, Input::Keys::A)
    @control_help_window.add_control(Vocab::BACK,    Input::Keys::B)
  end
end
