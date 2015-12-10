#==============================================================================
# ** New Class
# ** Window_CapacityHelp
#------------------------------------------------------------------------------
#  This window shows capacity explanations.
#==============================================================================

class Window_CapacityHelp < Window_SimpleHelp
  #--------------------------------------------------------------------------
  # * Constants (Positions)
  #--------------------------------------------------------------------------
  SP_X        = 470
  SP_WIDTH    = 114
  TYPE_X      = 328
  TYPE_WIDTH  = 100
  #--------------------------------------------------------------------------
  # * Override
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    super
    draw_capacity_sp
    draw_capacity_type
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Clear
  #--------------------------------------------------------------------------
  def clear
    set_sp_cost(nil)
    set_capacity_type(0)
    super
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Set Item
  #     item : Skills and items etc.
  #--------------------------------------------------------------------------
  def set_item(item)
    set_capacity_type(item ? item.ctype_id : 0)
    set_sp_cost(item ? item.sp_cost : nil)
    super
  end
  #--------------------------------------------------------------------------
  # * Set Capacity Type
  #--------------------------------------------------------------------------
  def set_capacity_type(ctype_id)
    @capacity_type = $data_system.capacities_types[ctype_id]
  end
  #--------------------------------------------------------------------------
  # * Set SP Cost
  #--------------------------------------------------------------------------
  def set_sp_cost(sp_cost)
    if sp_cost != @sp_cost
      @sp_cost = sp_cost
    end
  end
  #--------------------------------------------------------------------------
  # * Draw Capacity SP Cost
  #--------------------------------------------------------------------------
  def draw_capacity_sp
    return unless @sp_cost
    change_color(system_color)
    draw_text(SP_X, 0, SP_WIDTH, line_height, Vocab::SP_COST)
    change_color(normal_color)
    draw_text(SP_X, 0, SP_WIDTH, line_height, @sp_cost, Bitmap::ALIGN_RIGHT)
  end
  #--------------------------------------------------------------------------
  # * Draw Capacity Usage
  #--------------------------------------------------------------------------
  def draw_capacity_type
    return unless @capacity_type
    draw_text(TYPE_X, 0, TYPE_WIDTH, line_height, @capacity_type)
  end
end