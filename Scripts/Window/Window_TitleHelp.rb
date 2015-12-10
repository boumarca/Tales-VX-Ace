#==============================================================================
# ** Window_TitleHelp
#------------------------------------------------------------------------------
#  This window shows title information and adds a toggleable second description.
#==============================================================================

class Window_TitleHelp < Window_ToggleHelp
  #--------------------------------------------------------------------------
  # * Override
  # * Set Item
  #     item : Skills and items etc.
  #--------------------------------------------------------------------------
  def set_item(item)
    text = ""
    item.params.each_with_index { |param, i|
      text.concat(sprintf("%s + %#.01g   \n",Vocab::param(i), param)) if param != 0.0
    }
    set_alt_text(text)
    super
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
    draw_alt_description
  end
end
