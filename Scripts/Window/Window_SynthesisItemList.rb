#==============================================================================
# ** New Class
# ** Window_SynthesisItemList**
#------------------------------------------------------------------------------
#  This window displays a list of craftable items on the item screen.
#==============================================================================

class Window_SynthesisItemList < Window_ItemList
  #--------------------------------------------------------------------------
  # * Constants(Positions)
  #--------------------------------------------------------------------------
  WINDOW_WIDTH = 304
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y)
    super(x, y)
    @category = :none
  end
  #--------------------------------------------------------------------------
  # * Set Materials Window
  #--------------------------------------------------------------------------
  def materials_window=(window)
    @materials_window = window
    call_update_help
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Get Window Width
  #--------------------------------------------------------------------------
  def window_width
    return WINDOW_WIDTH
  end
  #--------------------------------------------------------------------------
  # * Include in Item List?
  #--------------------------------------------------------------------------
  def include_item?(item)
    return unless item.is_a?(RPG::Item) && learned?(item)
    case @category
    when :item
      item.normal_item?
    when :material
      item.material_item?
    when :key_item
      item.key_item?
    else
      false
    end
  end
  #--------------------------------------------------------------------------
  # * Include in Weapon List?
  #--------------------------------------------------------------------------
  def include_weapon?(item)
    return unless item.is_a?(RPG::Weapon) && learned?(item)
    item.weapon_item?
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Include in Armor List?
  #--------------------------------------------------------------------------
  def include_armor?(item)
    return unless item.is_a?(RPG::Armor) && learned?(item)
    case @category
    when :armor
      item.body_item?
    when :head
      item.head_item?
    when :arm
      item.arm_item?
    when :accessory
      item.accessory_item?
    else
      false
    end
  end
  #--------------------------------------------------------------------------
  # * Check if the item has been learned
  #--------------------------------------------------------------------------
  def learned?(item)
    item.synthesis_level > 0 && item.synthesis_level <= $game_crafting.synthesis_level
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Create Item List
  #--------------------------------------------------------------------------
  def make_item_list
    if item?
      @data = $data_items.select {|item| include_item?(item)}
    elsif weapon?
      @data = $data_weapons.select {|item| include_weapon?(item)}
    elsif armor?
      @data = $data_armors.select {|item| include_armor?(item)}
    end
  end
  #--------------------------------------------------------------------------
  # * Checks if category is a data item
  #--------------------------------------------------------------------------
  def item?
    @category == :item || @category == :material || @category == :key_item
  end
  #--------------------------------------------------------------------------
  # * Checks if category is a data weapon
  #--------------------------------------------------------------------------
  def weapon?
    @category == :weapon
  end
  #--------------------------------------------------------------------------
  # * Checks if category is a data armor
  #--------------------------------------------------------------------------
  def armor?
    @category == :armor || @category == :head || @category == :arm || @category == :accessory
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
  # * Move Cursor Right
  #--------------------------------------------------------------------------
  def cursor_right(wrap = false)
    process_pagedown
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Move Cursor Left
  #--------------------------------------------------------------------------
  def cursor_left(wrap = false)
    process_pageup
  end
  #--------------------------------------------------------------------------
  # * Process Cursor Up
  #--------------------------------------------------------------------------
  def process_up
    Input.update
    deactivate
    call_handler(:up)
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
  # * Override
  # * Update Help Text
  #--------------------------------------------------------------------------
  def update_help
    @help_window.set_item(item)
    @materials_window.materials = item ? item.synthesis_materials : nil
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Display in Enabled State?
  #--------------------------------------------------------------------------
  def enable?(item)
    SynthesisManager.synthesizable?(item)
  end
end
