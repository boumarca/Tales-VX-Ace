#==============================================================================
# ** Window_UseItem
#------------------------------------------------------------------------------
#  This window is for selecting actors that will be the target of item or
#  skill use.
#==============================================================================

class Window_UseItem < Window_MenuActor
  #--------------------------------------------------------------------------
  # * Constants (Positions)
  #--------------------------------------------------------------------------
  ITEM_HEIGHT         = 120
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
    draw_text(0,0, contents.width, line_height, Vocab::ITEM_USE, Bitmap::ALIGN_CENTER)
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
    draw_actor_simple_status(current_actor, rect.x, rect.y + line_height * 3)
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
