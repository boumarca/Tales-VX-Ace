#==============================================================================
# ** New Class
# ** Game_Crafting
#------------------------------------------------------------------------------
#  This class handles parties. Information such as synthesis level is included.
#  Instances of this class are referenced by $game_crafting.
#==============================================================================

class Game_Crafting
  #--------------------------------------------------------------------------
  # * Constants
  #--------------------------------------------------------------------------
  SYNTHESIS_MAX_LEVEL       = 99          # Maximum level for item synthesis
  BASE_EXP                  = 25          # Base Exp crafting gives
  #--------------------------------------------------------------------------
  # * Public Instance Variables temp public!
  #--------------------------------------------------------------------------
  attr_accessor   :synthesis_exp          # synthesis_level
  attr_accessor   :synthesis_level        # synthesis_level
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    @synthesis_level = 1
    @synthesis_exp = 0
  end
  #--------------------------------------------------------------------------
  # * Get Exp For Synthesizing
  #--------------------------------------------------------------------------
  def get_exp(item)
    return BASE_EXP * item.synthesis_level / synthesis_level
  end
  #--------------------------------------------------------------------------
  # * Get Total EXP Required for Rising to Specified Synthesis Level
  #--------------------------------------------------------------------------
  def synthesis_exp_for_level(level)
    100 * level
  end
  #--------------------------------------------------------------------------
  # * Get EXP for Next Synthesis Level
  #--------------------------------------------------------------------------
  def next_synthesis_level_exp
    synthesis_exp_for_level(@synthesis_level)
  end
  #--------------------------------------------------------------------------
  # * Determine Maximum Synthesis Level
  #--------------------------------------------------------------------------
  def max_synthesis_level?
    @synthesis_level >= SYNTHESIS_MAX_LEVEL
  end
  #--------------------------------------------------------------------------
  # * Level Up Synthesis
  #--------------------------------------------------------------------------
  def level_up_synthesis
    @synthesis_exp %= synthesis_exp_for_level(@synthesis_level)
    @synthesis_level += 1    
  end
  #--------------------------------------------------------------------------
  # * Change Synthesis Experience
  #--------------------------------------------------------------------------
  def change_synthesis_exp(exp)
    @synthesis_exp = exp
    puts sprintf("%s / %s Next: %s", @synthesis_exp, next_synthesis_level_exp, next_synthesis_level_exp - @synthesis_exp)
    last_level = $game_crafting.synthesis_level
    level_up_synthesis while !max_synthesis_level? && @synthesis_exp >= next_synthesis_level_exp
  end
  #--------------------------------------------------------------------------
  # * Get Synthesis EXP (Account for Experience Rate)
  #--------------------------------------------------------------------------
  def gain_synthesis_exp(exp)
    change_synthesis_exp(@synthesis_exp + exp)
  end
  #--------------------------------------------------------------------------
  # * Get Item From Material information
  #--------------------------------------------------------------------------
  def get_item_from_material(material)
    if material.item?
      $data_items[material.item_id]
    elsif material.weapon?
      $data_weapons[material.item_id]
    elsif material.armor?
      $data_armors[material.item_id]
    end
  end
  #--------------------------------------------------------------------------
  # * Get number of materials possessed.
  #--------------------------------------------------------------------------
  def quantity(material)
    $game_party.item_number(get_item_from_material(material))
  end
  #--------------------------------------------------------------------------
  # * Tests if the party owns enough of this material
  #--------------------------------------------------------------------------
  def owns_enough?(material)
    quantity(material) >= material.quantity
  end
  #--------------------------------------------------------------------------
  # * Test if item is synthesizable
  #--------------------------------------------------------------------------
  def synthesizable?(item)
    item.synthesis_materials.each { |material| 
      return false if !owns_enough?(material) 
    }
    return true
  end
  #-------------------------------------------------------------------------
  # * Make Item
  #--------------------------------------------------------------------------
  def make_item(item)
    gain_synthesis_exp(get_exp(item))
    $game_party.gain_item(item, 1)
    use_materials(item)
  end
  #--------------------------------------------------------------------------
  # * Use Materials
  #--------------------------------------------------------------------------
  def use_materials(item)
    item.synthesis_materials.each { |material| 
      it = get_item_from_material(material)
      puts it.name.to_s
      $game_party.lose_item(it, 1) 
    }
  end
end