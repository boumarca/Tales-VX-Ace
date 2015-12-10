#==============================================================================
# ** New Class
# ** Window_RecipeHelp
#------------------------------------------------------------------------------
#  This window shows recipe explanations.
#==============================================================================

class Window_RecipeHelp < Window_SimpleHelp
  #--------------------------------------------------------------------------
  # * Constants (Positions)
  #--------------------------------------------------------------------------
  NAME_X        = 108
  DESCRIPTION_X = 118
  #--------------------------------------------------------------------------
  # * Constants (Icons)
  #--------------------------------------------------------------------------
  IMAGE_SIZE    = 32
  #--------------------------------------------------------------------------
  # * Override
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    super
    draw_item_image
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Clear
  #--------------------------------------------------------------------------
  def clear
    set_picture(nil)
    super
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Set Item
  #     item : Skills and items etc.
  #--------------------------------------------------------------------------
  def set_item(item)
    set_picture(item ? item.image : nil)
    super
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
    bitmap = Cache.picture("sandwich")
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
  # * Override
  # * Draw Item Description
  #--------------------------------------------------------------------------
  def draw_item_description
    draw_text_ex(DESCRIPTION_X, line_height, @text)
  end
end