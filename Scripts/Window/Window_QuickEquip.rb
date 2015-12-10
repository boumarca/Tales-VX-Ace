#==============================================================================
# ** Window_QuickEquip
#------------------------------------------------------------------------------
#  This window is for selecting actors that will be the target of quick equip.
#==============================================================================

class Window_QuickEquip < Window_MenuActor
  #--------------------------------------------------------------------------
  # * Constants (Icons)
  #--------------------------------------------------------------------------
  STAT_INCREASE_ICON_INDEX  = 34
  STAT_DECREASE_ICON_INDEX  = 50
  STAT_UNCHANGED_ICON_INDEX = 16
  EQUIPPED_ICON_INDEX       = 139
  UNEQUIPPABLE_ICON_INDEX   = 17
  #--------------------------------------------------------------------------
  # * Constants (Positions)
  #--------------------------------------------------------------------------
  STAT_TEXT_SIZE            = 48
  #--------------------------------------------------------------------------
  # * Override
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y)
    @item = nil
    super(x, y)
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Get Rectangle for Drawing Items
  #--------------------------------------------------------------------------
  def item_rect(index)
    rect = super
    rect.y = index / col_max * (item_height + standard_padding) + line_height + standard_padding
    rect
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Draw Window Header
  #--------------------------------------------------------------------------
  def draw_header
    draw_text(0,0, contents.width, line_height, Vocab::ITEM_EQUIP, Bitmap::ALIGN_CENTER)
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Set Item
  #--------------------------------------------------------------------------
  def item=(item)
    @item = item
    refresh
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Draw Item
  #--------------------------------------------------------------------------
  def draw_item(index)
    current_actor = $game_party.members[index]
    rect = item_rect(index)
    draw_actor_face(current_actor, rect.x, rect.y)
    draw_actor_icons(current_actor, rect.x, rect.y)
    draw_actor_equip_info(rect.x, rect.y + line_height * 2, current_actor)
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Draw Actor Equipment Information
  #--------------------------------------------------------------------------
  def draw_actor_equip_info(x, y, actor)
    if !actor.equippable?(@item)
      draw_icon(UNEQUIPPABLE_ICON_INDEX, x, y)
    elsif actor.equipped?(@item)
      draw_icon(EQUIPPED_ICON_INDEX, x, y)
    else
      old_stat = actor.param(param_id)
      new_stat = get_new_stat(actor)
      if old_stat < new_stat
        draw_icon(STAT_INCREASE_ICON_INDEX, x, y)
      elsif old_stat > new_stat
        draw_icon(STAT_DECREASE_ICON_INDEX, x, y) 
      else
        draw_icon(STAT_UNCHANGED_ICON_INDEX, x, y) 
      end
      draw_text(x + 4, y + line_height, STAT_TEXT_SIZE, line_height, old_stat, Bitmap::ALIGN_CENTER)
      draw_text(x, y + line_height, item_width - 4, line_height, "→", Bitmap::ALIGN_RIGHT)
      change_color(param_change_color(new_stat - old_stat))
      draw_text(x + 4, y + line_height * 2, STAT_TEXT_SIZE, line_height, new_stat, Bitmap::ALIGN_CENTER)
      change_color(normal_color)
    end
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Gets the predicted value of the stat
  #--------------------------------------------------------------------------
  def get_new_stat(actor)
    equipment_bonus = actor.equips[@item.etype_id].nil? ? 0 : actor.equips[@item.etype_id].params[param_id]
    item_bonus = @item.nil? ? 0 : @item.params[param_id]
    actor.param(param_id) - equipment_bonus + item_bonus
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Get Parameter ID Corresponding to Selected Item
  #    By default, ATK if weapon and DEF if armor.
  #--------------------------------------------------------------------------
  def param_id
    @item.is_a?(RPG::Weapon) ? 2 : 3
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    super
    draw_header
  end
end
