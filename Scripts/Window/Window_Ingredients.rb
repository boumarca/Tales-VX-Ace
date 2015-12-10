#==============================================================================
# ** New Class
# ** Window_Ingredients
#------------------------------------------------------------------------------
#  This window displays the required and extra ingredients for cooking.
#==============================================================================

class Window_Ingredients < Window_Base
  #--------------------------------------------------------------------------
  # * Constants (Positions)
  #--------------------------------------------------------------------------
  WINDOW_WIDTH  = 304
  MARGIN_X      = 12
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y)
    super(x, y, window_width, fitting_height(8)) 
    @mastery_level = nil
    @recipe = nil
  end
  #--------------------------------------------------------------------------
  # * Get Window Width
  #--------------------------------------------------------------------------
  def window_width
    return WINDOW_WIDTH
  end
  #--------------------------------------------------------------------------
  # * Set Recipe
  #--------------------------------------------------------------------------
  def recipe=(recipe)
    return if @recipe == recipe
    @recipe = recipe
    refresh
  end
  #--------------------------------------------------------------------------
  # * Set Mastery Level
  #--------------------------------------------------------------------------
  def mastery_level=(mastery_level)
    return if @mastery_level == mastery_level
    @mastery_level = mastery_level
    refresh
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_ingredients
  end
  #--------------------------------------------------------------------------
  # * Draw Ingredients
  #--------------------------------------------------------------------------
  def draw_ingredients
    return unless @recipe && @mastery_level
    draw_required_ingredients
    draw_extra_ingredients
  end
  #--------------------------------------------------------------------------
  # * Draw Required Ingredients
  #--------------------------------------------------------------------------
  def draw_required_ingredients
    change_color(system_color)
    draw_text(0, 0, contents.width, line_height, Vocab::REQUIRED_INGREDIENTS)
    change_color(normal_color)
    @line = 1
    @recipe.required.each { |item| draw_item(item) }
  end
  #--------------------------------------------------------------------------
  # * Draw Extra Ingredients
  #--------------------------------------------------------------------------
  def draw_extra_ingredients
    change_color(system_color)
    draw_text(0, line_height * @line, contents.width, line_height, Vocab::EXTRA_INGREDIENTS)
    change_color(normal_color)
    @line += 1
    @recipe.extra.each { |item|
      next if item.level > @mastery_level 
      draw_item(item) 
    } 
  end
  #--------------------------------------------------------------------------
  # * Draw Item
  #--------------------------------------------------------------------------
  def draw_item(item)
    return unless item
    if item
      rect = Rect.new(0, line_height * @line, contents.width - MARGIN_X, line_height)
      rect.width -= 4
      draw_item_name(item, rect.x, rect.y, enable?(item))
      draw_item_number(rect, item)
      @line += 1
    end
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Draw Item Name
  #     enabled : Enabled flag. When false, draw semi-transparently.
  #--------------------------------------------------------------------------
  def draw_item_name(item, x, y, enabled = true, width = 172)
    return unless item
    draw_icon(icon_index(item), x, y)
    change_color(normal_color, enabled)
    draw_text(x + 24, y, width, line_height, name(item))
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Enable Item if have enough item
  #--------------------------------------------------------------------------
  def enable?(item)
    CookingManager.quantity(item) > 0
  end
  #--------------------------------------------------------------------------
  # * Get the icon index of item or category
  #--------------------------------------------------------------------------
  def icon_index(item)
    return $data_items[item.item_id].icon_index if item.item?
    return ($data_items.find { |i| !i.nil? && i.subtype_id == item.category_id}).icon_index if item.category?
  end
  #--------------------------------------------------------------------------
  # * Get the name of item or category
  #--------------------------------------------------------------------------
  def name(item)
    return $data_items[item.item_id].name  if item.item?
    return $data_system.item_types[item.category_id] if item.category?
  end
  #--------------------------------------------------------------------------
  # * Draw Number of Items
  #--------------------------------------------------------------------------
  def draw_item_number(rect, item)
    draw_text(rect, sprintf("%2d/%2d", item.quantity, CookingManager.quantity(item)), Bitmap::ALIGN_RIGHT)
  end
end