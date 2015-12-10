#==============================================================================
# ** Window_ShopSell
#------------------------------------------------------------------------------
#  This window displays a list of items in possession for selling on the shop
# screen.
#==============================================================================

class Window_ShopSell < Window_ItemList
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super(x, y, width, height)
  end
  #--------------------------------------------------------------------------
  # * Get Activation State of Selection Item
  #--------------------------------------------------------------------------
  def current_item_enabled?
    enable?(@data[index])
  end
  #--------------------------------------------------------------------------
  # * Display in Enabled State?
  #--------------------------------------------------------------------------
  def enable?(item)
    item && item.price > 0
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Draw Item Name
  #     enabled : Enabled flag. When false, draw semi-transparently.
  #--------------------------------------------------------------------------
  def draw_item_name(item, x, y, enabled = true, width = 172)
    return unless item
    draw_icon(item.icon_index, x, y)
    change_color(normal_color, enabled)
    draw_text(x + 24, y, width, line_height, item.name)
  end
end
