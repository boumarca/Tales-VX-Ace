#==============================================================================
# ** New Class
# ** Window_SynthesisCategory**
#------------------------------------------------------------------------------
#  This window displays the categories of craftable items on the item screen.
#==============================================================================

class Window_SynthesisCategory < Window_ItemCategory
  #--------------------------------------------------------------------------
  # * Constants (Positions)
  #--------------------------------------------------------------------------
  WINDOW_WIDTH    = 204
  MAX_CATEGORY    = 8
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y)
    super
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
    return MAX_CATEGORY
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Create Command List
  #--------------------------------------------------------------------------
  def make_command_list
    add_command(ITEM_ICON,      :item)
    add_command(WEAPON_ICON,    :weapon)
    add_command(ARMOR_ICON,     :armor)
    add_command(HEAD_ICON,      :head)
    add_command(ARM_ICON,       :arm)
    add_command(ACCESSORY_ICON, :accessory)
    add_command(MATERIAL_ICON,  :material)
    add_command(KEY_ITEM_ICON,  :key_item)
  end
end