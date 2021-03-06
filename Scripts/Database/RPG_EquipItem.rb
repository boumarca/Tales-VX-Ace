#--------------------------------------------------------------------------
# * RPG::EquipItem Modifications
#--------------------------------------------------------------------------

class RPG::EquipItem < RPG::BaseItem
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
      when /<synthesis_level:\s*(\d*)\s*>/i
        @synthesis_level = $1.to_i
      when /<synthesis_material:\s*(\d*)\s*,\s*(\d*)\s*,\s*(\d*)\s*>/i
        @synthesis_materials.push(RPG::Material.new($1.to_i, $2.to_i, $3.to_i))
      end
    }
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Determines whether the item type is [Weapon Item]. 
  # * Returns true if the value of etype_id is 0.
  #--------------------------------------------------------------------------
  def weapon_item?
    @etype_id == 0
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Determines whether the item type is [Armor(Shield) Item]. 
  # * Returns true if the value of etype_id is 1.
  #--------------------------------------------------------------------------
  def arm_item?
    @etype_id == 1
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Determines whether the item type is [Armor(Head) Item]. 
  # * Returns true if the value of etype_id is 2.
  #--------------------------------------------------------------------------
  def head_item?
    @etype_id == 2
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Determines whether the item type is [Armor(Body) Item]. 
  # * Returns true if the value of etype_id is 3.
  #--------------------------------------------------------------------------
  def body_item?
    @etype_id == 3
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Determines whether the item type is [Armor(Accessory) Item]. 
  # * Returns true if the value of etype_id is 4.
  #--------------------------------------------------------------------------
  def accessory_item?
    @etype_id == 4
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Returns an array of attack attributes for this item.
  #--------------------------------------------------------------------------
  def atk_attributes
    atk_attr = []
    @features.each {|feat|
      atk_attr.push(feat.data_id) if feat.code == Game_BattlerBase::FEATURE_ATK_ELEMENT
    }
    return atk_attr
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Returns an array of defense attributes for this item.
  #--------------------------------------------------------------------------
  def def_attributes
    def_attr = []
    @features.each {|feat|
      def_attr.push(feat.data_id) if feat.code == Game_BattlerBase::FEATURE_ELEMENT_RATE
    }
    return def_attr
  end
end