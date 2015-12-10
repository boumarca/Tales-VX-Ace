#--------------------------------------------------------------------------
# * RPG::Item Modifications
#--------------------------------------------------------------------------

class RPG::Item < RPG::UsableItem
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :synthesis_level
  attr_accessor :synthesis_materials
  #--------------------------------------------------------------------------
  # * Override
  # * Initialize Custom Fields
  #--------------------------------------------------------------------------
  def init_custom_fields
    super
    @synthesis_level = 0
    @synthesis_materials = []
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Load Note Tags
  #--------------------------------------------------------------------------
  def load_notetags
    super
    self.note.split(/[\r\n]+/).each { |line|
      case line
      when /<itype_id:\s*(\d+)\s*>/i
        @itype_id = $1.to_i
      when /<synthesis_level:\s*(\d*)\s*>/i
        @synthesis_level = $1.to_i
      when /<synthesis_material:\s*(\d*)\s*,\s*(\d*)\s*,\s*(\d*)\s*>/i
        @synthesis_materials.push(RPG::Material.new($1.to_i, $2.to_i, $3.to_i))
      end
    }
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Determines whether the item type is [Normal Item]. 
  # * Returns true if the value of itype_id is 1.
  #--------------------------------------------------------------------------
  def normal_item?
    @itype_id == 1
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Determines whether the item type is [Food Item]. 
  # * Returns true if the value of itype_id is 3.
  #--------------------------------------------------------------------------
  def food_item?
    @itype_id == 3
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Determines whether the item type is [Material Item]. 
  # * Returns true if the value of itype_id is 4.
  #--------------------------------------------------------------------------
  def material_item?
    @itype_id == 4
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Determines whether the item belongs to the given food category. 
  #--------------------------------------------------------------------------
  def belongs?(category)
    @itype_id == 3 && @subtype_id == category
  end
end

