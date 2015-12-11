#==============================================================================
# ** New Class
# ** Window_ItemHelp
#------------------------------------------------------------------------------
#  This window shows item explanations.
#==============================================================================

class Window_ItemHelp < Window_ToggleHelp
  #--------------------------------------------------------------------------
  # * Constants (Positions)
  #--------------------------------------------------------------------------
  NAME_X        = 108
  DESCRIPTION_X = 118
  #--------------------------------------------------------------------------
  # * Constants (Icons)
  #--------------------------------------------------------------------------
  IMAGE_SIZE    = 32
  ICON_SIZE     = 24
  ICON_OFFSET   = 93
  #--------------------------------------------------------------------------
  # * Override
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    super
    draw_item_image
    draw_item_subtype
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Draw Main Help
  #--------------------------------------------------------------------------
  def draw_main
    draw_item_description
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Draw Toggle Help
  #--------------------------------------------------------------------------
  def draw_toggle
    if @params
      draw_item_params 
    else
      draw_item_description 
    end
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Clear
  #--------------------------------------------------------------------------
  def clear
    set_picture(nil)
    set_params(nil)
    set_subtype("")
    super
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Set Item
  #     item : Skills and items etc.
  #--------------------------------------------------------------------------
  def set_item(item)
    clear
    set_picture(item ? item.image : nil)
    set_subtype(item ? parse_subtype(item) : "")
    set_params(item ? item.params : nil) if item.is_a?(RPG::EquipItem)
    set_attributes(item) if item.is_a?(RPG::EquipItem)
    super
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Set Attack and Defense Attributes
  #--------------------------------------------------------------------------
  def set_attributes(item)
    @atk_attr = item.atk_attributes ? item.atk_attributes : []
    @def_attr = item.def_attributes ? item.def_attributes : []
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Set Params
  #--------------------------------------------------------------------------
  def set_params(params)
    if params != @params
      @params = params
    end
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Set Picture
  #--------------------------------------------------------------------------
  def set_picture(picture)
    if picture != @picture
      @picture = picture
    end
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Set Subtype
  #--------------------------------------------------------------------------
  def set_subtype(subtype)
    if subtype != @subtype
      @subtype = subtype
    end
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Draw Item Image
  #--------------------------------------------------------------------------
#~   def draw_item_image
#~     return unless @picture
#~     bitmap = Cache.picture(@picture)
#~     rect = Rect.new(0, 0, IMAGE_SIZE, IMAGE_SIZE)
#~     contents.blt(IMAGE_SIZE / 3, IMAGE_SIZE / 3, bitmap, rect)
#~     bitmap.dispose
#~   end
  
  def draw_item_image
    return unless @picture
    bitmap = Cache.picture("itemtex018")
    rect = Rect.new(0, 0, 32, 32)
    dest_rect = Rect.new(12, 12, 64, 72)
    contents.stretch_blt(dest_rect, bitmap, rect) 
    bitmap.dispose
  end
  
#~   def draw_item_image
#~     return unless @picture
#~     bitmap = Cache.picture("itemtex019")
#~     rect = Rect.new(0, 0, 64, 72)
#~     contents.blt(12, 12, bitmap, rect)
#~     bitmap.dispose
#~   end
  #--------------------------------------------------------------------------
  # * Override
  # * Draw Item Name
  #--------------------------------------------------------------------------
  def draw_item_name
    draw_text(NAME_X, 0, contents.width - NAME_X, line_height, @name)
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Draw Item Subtype
  #--------------------------------------------------------------------------
  def draw_item_subtype
    change_color(system_color)
    draw_text(NAME_X, 0, contents.width - NAME_X, line_height, @subtype, Bitmap::ALIGN_RIGHT)
    change_color(normal_color)
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Draw Item Description
  #--------------------------------------------------------------------------
  def draw_item_description
    draw_text_ex(DESCRIPTION_X, line_height, @text)
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Draw Item Parameters
  #--------------------------------------------------------------------------
  def draw_item_params
    return unless @params
    draw_params_name
    draw_params_value
    draw_attributes
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Draw Parameters Names
  #--------------------------------------------------------------------------
  def draw_params_name
    change_color(system_color)
    draw_text(DESCRIPTION_X, line_height, (contents.width - DESCRIPTION_X) / 3, line_height, Vocab.param(2))
    draw_text(DESCRIPTION_X, line_height * 2, (contents.width - DESCRIPTION_X) / 3, line_height, Vocab.param(3))
    draw_text(DESCRIPTION_X + (contents.width - DESCRIPTION_X) / 3, line_height, (contents.width - DESCRIPTION_X) / 3, line_height, Vocab.param(4))
    draw_text(DESCRIPTION_X + (contents.width - DESCRIPTION_X) / 3, line_height * 2, (contents.width - DESCRIPTION_X) / 3, line_height, Vocab.param(5))
    draw_text(DESCRIPTION_X + 2 * (contents.width - DESCRIPTION_X) / 3, line_height, (contents.width - DESCRIPTION_X) / 3, line_height, Vocab.param(6))
    draw_text(DESCRIPTION_X + 2 * (contents.width - DESCRIPTION_X) / 3, line_height * 2, (contents.width - DESCRIPTION_X) / 3, line_height, Vocab.param(7))
    draw_text(DESCRIPTION_X, line_height * 3, (contents.width - DESCRIPTION_X) / 2, line_height, Vocab::AATR)
    draw_text(DESCRIPTION_X + (contents.width - DESCRIPTION_X) / 2, line_height * 3, (contents.width - DESCRIPTION_X) / 2, line_height, Vocab::DATR)
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Draw Parameters Values
  #--------------------------------------------------------------------------
  def draw_params_value
    change_color(normal_color)
    draw_text(DESCRIPTION_X, line_height, (contents.width - DESCRIPTION_X) / 3 - standard_padding, line_height, @params[2], Bitmap::ALIGN_RIGHT)
    draw_text(DESCRIPTION_X, line_height * 2, (contents.width - DESCRIPTION_X) / 3 - standard_padding, line_height, @params[3], Bitmap::ALIGN_RIGHT)
    draw_text(DESCRIPTION_X + (contents.width - DESCRIPTION_X) / 3, line_height, (contents.width - DESCRIPTION_X) / 3 - standard_padding, line_height, @params[4], Bitmap::ALIGN_RIGHT)
    draw_text(DESCRIPTION_X + (contents.width - DESCRIPTION_X) / 3, line_height * 2, (contents.width - DESCRIPTION_X) / 3 - standard_padding, line_height, @params[5], Bitmap::ALIGN_RIGHT)
    draw_text(DESCRIPTION_X + 2 * (contents.width - DESCRIPTION_X) / 3, line_height, (contents.width - DESCRIPTION_X) / 3 - standard_padding, line_height, @params[6], Bitmap::ALIGN_RIGHT)
    draw_text(DESCRIPTION_X + 2 * (contents.width - DESCRIPTION_X) / 3, line_height * 2, (contents.width - DESCRIPTION_X) / 3 - standard_padding, line_height, @params[7], Bitmap::ALIGN_RIGHT)
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Draw Attack and Defense Attributes
  #--------------------------------------------------------------------------
  def draw_attributes
    @atk_attr.each_with_index{|id, i| 
      draw_icon(id + ICON_OFFSET, DESCRIPTION_X + ((contents.width - DESCRIPTION_X) / 2) - standard_padding - ((@atk_attr.size - i) * ICON_SIZE), line_height * 3)
    }
    @def_attr.each_with_index{|id, i| 
      draw_icon(id + ICON_OFFSET, contents.width - standard_padding - ((@def_attr.size - i) * ICON_SIZE), line_height * 3)
    }
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Return Item Subtype String
  #--------------------------------------------------------------------------
  def parse_subtype(item)
    return $data_system.weapon_types[item.wtype_id] if item.is_a?(RPG::Weapon)
    return $data_system.armor_types[item.atype_id] if item.is_a?(RPG::Armor)
    return $data_system.item_types[item.subtype_id] if item.is_a?(RPG::Item)
  end
end