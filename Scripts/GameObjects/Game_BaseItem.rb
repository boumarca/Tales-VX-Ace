#==============================================================================
# ** Game_BaseItem
#------------------------------------------------------------------------------
#  This class uniformly handles skills, items, titles, weapons, and armor. 
# References to the database object itself are not retained to enable 
# inclusion in save data.
#==============================================================================

class Game_BaseItem
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    @class = nil
    @item_id = 0
  end
  #--------------------------------------------------------------------------
  # * Modified
  # * Determine Class
  #--------------------------------------------------------------------------
  def is_skill?;    @class == RPG::Skill;     end
  def is_item?;     @class == RPG::Item;      end
  def is_weapon?;   @class == RPG::Weapon;    end
  def is_armor?;    @class == RPG::Armor;     end
  def is_title?;    @class == RPG::Title;     end
  def is_capacity?; @class == RPG::Capacity;  end
  def is_recipe?;   @class == RPG::Recipe;    end
  def is_nil?;      @class == nil;            end
  #--------------------------------------------------------------------------
  # * Modified
  # * Get Item Object
  #--------------------------------------------------------------------------
  def object
    return $data_skills[@item_id]     if is_skill?
    return $data_items[@item_id]      if is_item?
    return $data_weapons[@item_id]    if is_weapon?
    return $data_armors[@item_id]     if is_armor?
    return $data_titles[@item_id]     if is_title?
    return $data_capacities[@item_id] if is_capacity?
    return $data_recipe[@item_id]     if is_recipe?
    return nil
  end
  #--------------------------------------------------------------------------
  # * Set Item Object
  #--------------------------------------------------------------------------
  def object=(item)
    @class = item ? item.class : nil
    @item_id = item ? item.id : 0
  end
  #--------------------------------------------------------------------------
  # * Set Equipment with ID
  #     is_weapon:  Whether it is a weapon
  #     item_id: Weapon/armor ID
  #--------------------------------------------------------------------------
  def set_equip(is_weapon, item_id)
    @class = is_weapon ? RPG::Weapon : RPG::Armor
    @item_id = item_id
  end
  #--------------------------------------------------------------------------
  # * Redefinition of ==
  #--------------------------------------------------------------------------
  def ==(other)
    return false if other.nil?
    @class == other.object.class && @item_id == other.object.id
  end
end
