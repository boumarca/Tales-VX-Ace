#==============================================================================
# ** SynthesisManager
#------------------------------------------------------------------------------
#  This module manages item synthesis.
#==============================================================================

module SynthesisManager
  #--------------------------------------------------------------------------
  # * Constants
  #--------------------------------------------------------------------------
  BASE_EXP = 25
  #--------------------------------------------------------------------------
  # * Reset Information
  #--------------------------------------------------------------------------
  def self.reset
    @item = nil
  end
  #--------------------------------------------------------------------------
  # * Set Item
  #--------------------------------------------------------------------------
  def self.item=(item)
    return if @item == item
    @item = item
  end
  #--------------------------------------------------------------------------
  # * Get Item
  #--------------------------------------------------------------------------
  def self.item
    @item
  end
  #-------------------------------------------------------------------------
  # * Make Item
  #--------------------------------------------------------------------------
  def self.make_item
    $game_crafting.gain_synthesis_exp(get_exp)
    $game_party.gain_item(@item, 1)
    use_material
  end
  #--------------------------------------------------------------------------
  # * Use Materials
  #--------------------------------------------------------------------------
  def self.use_material
    @item.synthesis_materials.each { |material| 
      item = get_item_from_material(material)
      puts item.name.to_s
      $game_party.lose_item(item, 1) 
    }
  end
  #--------------------------------------------------------------------------
  # * Test if item is synthesizable
  #--------------------------------------------------------------------------
  def self.synthesizable?(item)
    item.synthesis_materials.each { |material| 
      return false if !owns_enough?(material) 
    }
    return true
  end
  #--------------------------------------------------------------------------
  # * Get number of materials possessed.
  #--------------------------------------------------------------------------
  def self.quantity(material)
    $game_party.item_number(get_item_from_material(material))
  end
  #--------------------------------------------------------------------------
  # * Get Item From Material information
  #--------------------------------------------------------------------------
  def self.get_item_from_material(material)
    if material.item?
      $data_items[material.item_id]
    elsif material.weapon?
      $data_weapons[material.item_id]
    elsif material.armor?
      $data_armors[material.item_id]
    end
  end
  #--------------------------------------------------------------------------
  # * Tests if the party owns enough of this material
  #--------------------------------------------------------------------------
  def self.owns_enough?(material)
    quantity(material) >= material.quantity
  end
  #--------------------------------------------------------------------------
  # * Get Exp For Synthesizing
  #--------------------------------------------------------------------------
  def self.get_exp
    return BASE_EXP * @item.synthesis_level / $game_crafting.synthesis_level
  end
end