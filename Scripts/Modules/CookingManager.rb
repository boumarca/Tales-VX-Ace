#==============================================================================
# ** CookingManager
#------------------------------------------------------------------------------
#  This module manages cooking.
#==============================================================================

module CookingManager
  #--------------------------------------------------------------------------
  # * Constants
  #--------------------------------------------------------------------------
  MASTERY_BONUS   = [0.0, 0.02, 0.05, 0.09]   # mastery bonus
  ACTOR_BONUS     = 0.03                      # good actor bonus  
  KNIFE_BONUS     = 0.05                      # owning the kitchen knife bonus
  KNIFE_ID        = 27                        # database id of the kitchen knife
  #--------------------------------------------------------------------------
  # * Reset Information
  #--------------------------------------------------------------------------
  def self.reset
    @cook = nil
	  @recipe = nil
    @mastery_level = nil 
    @success = false
    @used_ingredients = []
    @effects = []
    @extra_ingredients = 0
  end
  #--------------------------------------------------------------------------
  # * Set Cook
  #--------------------------------------------------------------------------
  def self.cook=(cook)
    return if @cook == cook
    @cook = cook 
    update_mastery_level
  end
  #--------------------------------------------------------------------------
  # * Set Recipe
  #--------------------------------------------------------------------------
  def self.recipe=(recipe)
    return if @recipe == recipe
    @recipe = recipe
    update_mastery_level
  end
  #--------------------------------------------------------------------------
  # * Set Mastery Level
  #--------------------------------------------------------------------------
  def self.update_mastery_level
     @mastery_level = @cook.mastery_level(@recipe) unless @recipe.nil? || @cook.nil?
  end
  #--------------------------------------------------------------------------
  # * Get Success
  #--------------------------------------------------------------------------
  def self.success?
    @success
  end
  #--------------------------------------------------------------------------
  # * Get Used Ingredients
  #--------------------------------------------------------------------------
  def self.ingredients
    @used_ingredients.collect { |id| $data_items[id]}
  end
  #--------------------------------------------------------------------------
  # * Get Effects
  #--------------------------------------------------------------------------
  def self.effects
    @effects
  end
  #--------------------------------------------------------------------------
  # * Cook Recipe
  #--------------------------------------------------------------------------
  def self.cook_recipe
    use_required
    use_extra
    @success = recipe_successful?
    if @success
      success_effects
    else
      failure_effect
    end 
    apply_effects
    $game_party.hungry = false
    @cook.use_recipe(@recipe, @success)
  end
  #--------------------------------------------------------------------------
  # * Apply effects of recipe on party members
  #--------------------------------------------------------------------------
  def self.apply_effects
    item = @recipe.dup
    item.effects = @effects
    item.effects.each {|effect| 
      $game_party.members.each { |actor|
        next if actor.dead?
        actor.item_effect_apply(@cook, item, effect)
      }
    }
  end
  #--------------------------------------------------------------------------
  # * Use Required Ingredients
  #--------------------------------------------------------------------------
  def self.use_required
    @recipe.required.each {|ingredient| 
      item = get_item_from(ingredient)
      @used_ingredients.push(item.id)
      $game_party.consume_item(item) 
    }
  end
  #--------------------------------------------------------------------------
  # * Use Extra Ingredients If Owned
  #--------------------------------------------------------------------------
  def self.use_extra
    @recipe.extra.each {|ingredient| 
      next if ingredient.level > @mastery_level
      item = get_item_from(ingredient)
      if $game_party.has_item?(item)
        @used_ingredients.push(item.id)
        $game_party.consume_item(item)
        @extra_ingredients += 1
      end
    }
  end
  #--------------------------------------------------------------------------
  # * Test if Recipe is Successful
  #--------------------------------------------------------------------------
  def self.recipe_successful?
    base_rate = @recipe.success_rate
    mastery_bonus = MASTERY_BONUS[@mastery_level]
    actor_bonus = @cook.id == @recipe.actor_id ? ACTOR_BONUS : 0
    knife_bonus = $game_party.has_item?($data_items[KNIFE_ID]) ? KNIFE_BONUS : 0
    success_rate = base_rate + mastery_bonus + actor_bonus + knife_bonus
    rand <= success_rate
  end
  #--------------------------------------------------------------------------
  # * Test if Recipe is Cookable
  #--------------------------------------------------------------------------
  def self.recipe_cookable?
    @recipe.required.each { |ingredient| 
      return false if quantity(ingredient) == 0 
    }
    return true
  end
  #--------------------------------------------------------------------------
  # * Get Item To Use
  #--------------------------------------------------------------------------
  def self.get_item_from(ingredient)
    return $data_items[ingredient.item_id] if ingredient.item?
    list = $game_party.items.select {|obj| obj.belongs?(ingredient.category_id)}
    return list[rand(list.size)]
  end
  #--------------------------------------------------------------------------
  # * Get number of items posessed. Used for cooking
  #--------------------------------------------------------------------------
  def self.quantity(item)
    return 0 unless item
    quantity = 0
    if item.item?
      quantity = $game_party.item_number($data_items[item.item_id])
    else
      list = $game_party.items.select {|obj| obj.belongs?(item.category_id)}
      list.each { |i| quantity += $game_party.item_number(i) }
    end
    return quantity
  end
  #--------------------------------------------------------------------------
  # * Get Effect of Successful Recipe
  #--------------------------------------------------------------------------
  def self.success_effects
    @recipe.base_effects.each { |item| merge_or_add_effect(item) }
    @extra_ingredients.times { 
      @recipe.ingredient_effects.each { |item| merge_or_add_effect(item) }
    }
    @cook.mastery_level(@recipe).times { 
     @recipe.mastery_effects.each { |item| merge_or_add_effect(item) }
    }
    if @cook.id == @recipe.actor_id && @cook.master_recipe?(@recipe)
      @recipe.actor_effects.each { |item| merge_or_add_effect(item) }
    end    
  end
  #--------------------------------------------------------------------------
  # * Merge Or Add Effect To Array
  #--------------------------------------------------------------------------
  def self.merge_or_add_effect(other)
    obj = @effects.find { |effect| effect.code == other.code && effect.data_id == other.data_id}
    if obj.nil?
      @effects.push(other.dup)
    else
      obj.value1 += other.value1
      obj.value2 += other.value2
    end
  end
  #--------------------------------------------------------------------------
  # * Get Effect of Failed Recipe
  #--------------------------------------------------------------------------
  def self.failure_effect
    fail = rand(7)
    case fail
    when 0
      @effects = [RPG::UsableItem::Effect.new(11, 0, rand, 0)] # Random HP Regen
    when 1
      @effects = [RPG::UsableItem::Effect.new(12, 0, rand, 0)] # Random MP Regen
    when 2
      @effects = [RPG::UsableItem::Effect.new(11, 0, rand, 0),
                  RPG::UsableItem::Effect.new(12, 0, rand, 0)] # Random HP & MP Regen
    when 3
      @effects = [RPG::UsableItem::Effect.new(21, rand(1) + 2, 1, 0)] # Inflict Random Status Effect
    when 4
      @effects = [RPG::UsableItem::Effect.new(22, rand(1) + 2, 1, 0)] # Remove Random Status Effect 
    when 5
      @effects = [RPG::UsableItem::Effect.new(31, rand(4) + 2, 1, 0)] # Give Random Buff
    when 6
      @effects = [RPG::UsableItem::Effect.new(32, rand(4) + 2, 1, 0)] # Give Random Debuff
    else
      @effects = []
    end
  end
end