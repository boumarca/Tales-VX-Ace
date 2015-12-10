#==============================================================================
# ** New Class
# ** RPG::Material
#------------------------------------------------------------------------------
#  The data class for Material used in crafting. Material uses the ID of a 
# RPG::BaseItem for reference.
#==============================================================================
class RPG::Material
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :type_id
  attr_accessor :item_id
  attr_accessor :quantity
  #--------------------------------------------------------------------------
  # * Initialize New Material
  #--------------------------------------------------------------------------
  def initialize(type_id = 0, item_id = 0, quantity = 0)
    @type_id = type_id
    @item_id = item_id
    @quantity = quantity
  end
  #--------------------------------------------------------------------------
  # * Determines whether the material is an item. 
  # * Returns true if the value of type_id is 0.
  #--------------------------------------------------------------------------
  def item?
    @type_id == 0
  end
  #--------------------------------------------------------------------------
  # * Determines whether the material is a weapon. 
  # * Returns true if the value of type_id is 1.
  #--------------------------------------------------------------------------
  def weapon?
    @type_id == 1
  end
  #--------------------------------------------------------------------------
  # * Determines whether the material is an armor. 
  # * Returns true if the value of type_id is 2.
  #--------------------------------------------------------------------------
  def armor?
    @type_id == 2
  end
end