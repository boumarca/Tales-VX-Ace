#==============================================================================
# ** Window_ItemList
#------------------------------------------------------------------------------
#  This window displays a list of party items on the item screen.
#==============================================================================

class Window_MenuItemList < Window_ItemList
  #--------------------------------------------------------------------------
  # * Constants(Positions)
  #--------------------------------------------------------------------------
  WINDOW_WIDTH = 608
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y)
    super(x, y)
    @category = :none
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
  # * Get Window Width
  #--------------------------------------------------------------------------
  def window_width
    return WINDOW_WIDTH
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Get Digit Count
  #--------------------------------------------------------------------------
  def col_max
    return 2
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Get Activation State of Selection Item
  #--------------------------------------------------------------------------
  def current_item_enabled?
    enable?(@data[index])
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Modified
  # * Include in Item List?
  #--------------------------------------------------------------------------
  def include?(item)
    case @category
    when :item
      item.is_a?(RPG::Item) && item.normal_item?
    when :weapon
      item.is_a?(RPG::Weapon) && item.weapon_item?
    when :armor
      item.is_a?(RPG::Armor) && item.body_item?
    when :head
      item.is_a?(RPG::Armor) && item.head_item?
    when :arm
      item.is_a?(RPG::Armor) && item.arm_item?
    when :accessory
      item.is_a?(RPG::Armor) && item.accessory_item?
    when :food
      item.is_a?(RPG::Item) && item.food_item?
    when :material
      item.is_a?(RPG::Item) && item.material_item?
    when :key_item
      item.is_a?(RPG::Item) && item.key_item?
    else
      false
    end
  end
  #--------------------------------------------------------------------------
  # * Modified
  # * Display in Enabled State?
  #--------------------------------------------------------------------------
  def enable?(item)
    return true if item.is_a?(RPG::EquipItem)
    $game_party.usable?(item)
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Create Item List
  #--------------------------------------------------------------------------
  def make_item_list
    if @category == :new
      @data = $game_party.new_items
    else
      super
    end
  end
  #--------------------------------------------------------------------------
  # * Restore Previous Selection Position
  #--------------------------------------------------------------------------
  def select_last
    select(@data.index($game_party.last_item.object) || 0)
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
  # * Modified
  # * Draw Item Name
  #     enabled : Enabled flag. When false, draw semi-transparently.
  #--------------------------------------------------------------------------
  def draw_item_name(item, x, y, enabled = true, width = 172)
    return unless item
    draw_icon(item.icon_index, x, y)
    color = $game_party.new_item?(item) ? new_item_color : normal_color
    change_color(color, enabled)
    draw_text(x + 24, y, width, line_height, item.name)
  end
end
