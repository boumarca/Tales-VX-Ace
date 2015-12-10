#==============================================================================
# ** Window_EquipStatus
#------------------------------------------------------------------------------
#  This window displays actor parameter changes on the equipment screen.
#==============================================================================

class Window_EquipStat < Window_Base
  #--------------------------------------------------------------------------
  # * Constants (Positions)
  #--------------------------------------------------------------------------
  WINDOW_WIDTH = 228
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y)
    super(x, y, window_width, window_height)
    @actor = nil
    @temp_actor = nil
    @item = nil
    @etype_id = -1
    refresh
  end
  #--------------------------------------------------------------------------
  # * Modified
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
  # * New Method
  # * Set Item
  #--------------------------------------------------------------------------
  def set_item(item)
    return if @item == item
    @item = item
    refresh
  end
  #--------------------------------------------------------------------------
  # * Modified
  # * Set Actor
  #--------------------------------------------------------------------------
  def actor=(actor)
    return if @actor == actor
    @actor = actor
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Set Equipment Type Id
  #--------------------------------------------------------------------------
  def set_etype_id(etype_id)
    return if @etype_id == etype_id
    @etype_id = etype_id
  end
  #--------------------------------------------------------------------------
  # * Modified
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_equip
    #draw_item_name(@item, 4, line_height) 
    draw_item_name(@item, 0, line_height)
    8.times {|i| draw_item(0, line_height * (2 + i), i) }
  end
  #--------------------------------------------------------------------------
  # * Set Temporary Actor After Equipment Change
  #--------------------------------------------------------------------------
  def set_temp_actor(temp_actor)
    return if @temp_actor == temp_actor
    @temp_actor = temp_actor
    refresh
  end
  #--------------------------------------------------------------------------
  # * Modified
  # * Draw Item
  #--------------------------------------------------------------------------
  def draw_item(x, y, param_id)
#~     draw_param_name(x + 4, y, param_id)
#~     draw_current_param(x + 94, y, param_id) if @actor
#~     draw_right_arrow(x + 136, y)
#~     draw_new_param(x + 160, y, param_id) if @temp_actor
    draw_param_name(x, y, param_id)
    draw_current_param(x + 90, y, param_id) if @actor
    draw_right_arrow(x + 136, y)
    draw_new_param(x + 160, y, param_id) if @temp_actor
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Draw Equip Type Name
  #--------------------------------------------------------------------------
  def draw_equip
    change_color(system_color)
    draw_text(0, 0, 120, line_height, Vocab::etype(@etype_id))
  end
  #--------------------------------------------------------------------------
  # * Draw Parameter Name
  #--------------------------------------------------------------------------
  def draw_param_name(x, y, param_id)
    change_color(system_color)
    draw_text(x, y, 80, line_height, Vocab::param(param_id))
  end
  #--------------------------------------------------------------------------
  # * Modified
  # * Draw Current Parameter
  #--------------------------------------------------------------------------
  def draw_current_param(x, y, param_id)
    change_color(normal_color)
    draw_text(x, y, 42, line_height, @actor.param(param_id), 2)
  end
  #--------------------------------------------------------------------------
  # * Draw Right Arrow
  #--------------------------------------------------------------------------
  def draw_right_arrow(x, y)
    change_color(system_color)
    draw_text(x, y, 22, line_height, "→", 1)
  end
  #--------------------------------------------------------------------------
  # * Modified
  # * Draw Post-Equipment Change Parameter
  #--------------------------------------------------------------------------
  def draw_new_param(x, y, param_id)
    new_value = @temp_actor.param(param_id)
    change_color(param_change_color(new_value - @actor.param(param_id)))
    draw_text(x, y, 42, line_height, new_value, 2)
  end
end
