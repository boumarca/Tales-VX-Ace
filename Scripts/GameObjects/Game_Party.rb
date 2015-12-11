#==============================================================================
# ** Game_Party
#------------------------------------------------------------------------------
#  This class handles parties. Information such as gold and items is included.
# Instances of this class are referenced by $game_party.
#==============================================================================

class Game_Party < Game_Unit
  #--------------------------------------------------------------------------
  # * Constants
  #--------------------------------------------------------------------------
  ABILITY_ENCOUNTER_HALF    = 0           # halve encounters
  ABILITY_ENCOUNTER_NONE    = 1           # disable encounters
  ABILITY_CANCEL_SURPRISE   = 2           # disable surprise
  ABILITY_RAISE_PREEMPTIVE  = 3           # increase preemptive strike rate
  ABILITY_GOLD_DOUBLE       = 4           # double money earned
  ABILITY_DROP_ITEM_DOUBLE  = 5           # double item acquisition rate
  MAX_GOLD                  = 99999999    # maximum gald
  GRADE_MAX                 = 9999.99     # maximum grade
  MAX_NEW_ITEMS             = 20          # maximum of new items category
  MAX_ITEMS                 = 15          # maximum items hold
  MAX_MATERIAL              = 99          # maximum materials hold
  SHORTCUT_SLOTS            = 4           # Number of Cooking Shortcuts
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader   :gold                     # party's gold
  attr_reader   :steps                    # number of steps
  attr_reader   :last_item                # for cursor memorization:  item
  attr_reader   :grade                    # party's grade
  attr_reader   :max_combo                # max combo
  attr_accessor :hungry                   # party's hunger status
  #--------------------------------------------------------------------------
  # * Modified
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    super
    @gold = 0
    @grade = 0.0
    @max_combo = 0
    @steps = 0
    @last_item = Game_BaseItem.new
    @menu_actor_id = 0
    @target_actor_id = 0
    @actors = []
    @cook_id = 0
    @recipe_id = 0
	  @hungry = true
	  @recipes = []
    @cooking_shortcuts = []
    init_all_items
    init_cooking_shortcuts
  end
  #--------------------------------------------------------------------------
  # * Initialize All Item Lists
  #--------------------------------------------------------------------------
  def init_all_items
    @new_items = Array.new(MAX_NEW_ITEMS) { Game_BaseItem.new }
    @items = {}
    @weapons = {}
    @armors = {}
  end
  #--------------------------------------------------------------------------
  # * Init Cooking Shortcuts
  #--------------------------------------------------------------------------
  def init_cooking_shortcuts
    @cooking_shortcuts = Array.new(SHORTCUT_SLOTS) { Game_CookingShortcut.new }
  end
  #--------------------------------------------------------------------------
  # * Determine Existence
  #--------------------------------------------------------------------------
  def exists
    !@actors.empty?
  end
  #--------------------------------------------------------------------------
  # * Get Members
  #--------------------------------------------------------------------------
  def members
    in_battle ? battle_members : all_members
  end
  #--------------------------------------------------------------------------
  # * Get All Members
  #--------------------------------------------------------------------------
  def all_members
    @actors.collect {|id| $game_actors[id] }
  end
  #--------------------------------------------------------------------------
  # * Get All Members for debug purposes
  #--------------------------------------------------------------------------
  def debug_actors
    @actors
  end
  #--------------------------------------------------------------------------
  # * Get Battle Members
  #--------------------------------------------------------------------------
  def battle_members
    all_members[0, max_battle_members].select {|actor| actor.exist? }
  end
  #--------------------------------------------------------------------------
  # * Get Maximum Number of Battle Members
  #--------------------------------------------------------------------------
  def max_battle_members
    return 4
  end
  #--------------------------------------------------------------------------
  # * Get Maximum Number of Members In Party
  #--------------------------------------------------------------------------
  def max_party_members
    return 6
  end
  #--------------------------------------------------------------------------
  # * Get Leader
  #--------------------------------------------------------------------------
  def leader
    battle_members[0]
  end
  #--------------------------------------------------------------------------
  # * Get New Item Object Array 
  #--------------------------------------------------------------------------
  def new_items
    ary = @new_items.collect {|item| item.object } 
    ary.compact!
    ary
  end
  #--------------------------------------------------------------------------
  # * Get Item Object Array 
  #--------------------------------------------------------------------------
  def items
    @items.keys.sort.collect {|id| $data_items[id] }
  end
  #--------------------------------------------------------------------------
  # * Get Weapon Object Array 
  #--------------------------------------------------------------------------
  def weapons
    @weapons.keys.sort.collect {|id| $data_weapons[id] }
  end
  #--------------------------------------------------------------------------
  # * Get Armor Object Array 
  #--------------------------------------------------------------------------
  def armors
    @armors.keys.sort.collect {|id| $data_armors[id] }
  end
  #--------------------------------------------------------------------------
  # * Get Array of All Equipment Objects
  #--------------------------------------------------------------------------
  def equip_items
    weapons + armors
  end
  #--------------------------------------------------------------------------
  # * Get Array of All Item Objects
  #--------------------------------------------------------------------------
  def all_items
    items + equip_items
  end
  #--------------------------------------------------------------------------
  # * Get Container Object Corresponding to Item Class
  #--------------------------------------------------------------------------
  def item_container(item_class)
    return @items   if item_class == RPG::Item
    return @weapons if item_class == RPG::Weapon
    return @armors  if item_class == RPG::Armor
    return nil
  end
  #--------------------------------------------------------------------------
  # * Get Database Container Object Corresponding to Item Class
  #--------------------------------------------------------------------------
  def item_database_container(item_class)
    return $data_items   if item_class == RPG::Item
    return $data_weapons if item_class == RPG::Weapon
    return $data_armors  if item_class == RPG::Armor
    return nil
  end
  #--------------------------------------------------------------------------
  # * Modified
  # * Initial Party Setup
  #--------------------------------------------------------------------------
  def setup_starting_members
    @actors = $data_system.party_members.clone
    @map_leader_id = @actors[0]
    leader.set_to_manual
  end
  #--------------------------------------------------------------------------
  # * Get Party Name
  #    If there is only one, returns the actor's name.
  #    If there are more, returns "XX's Party".
  #--------------------------------------------------------------------------
  def name
    return ""           if battle_members.size == 0
    return leader.name  if battle_members.size == 1
    return sprintf(Vocab::PartyName, leader.name)
  end
  #--------------------------------------------------------------------------
  # * Set Up Battle Test
  #--------------------------------------------------------------------------
  def setup_battle_test
    setup_battle_test_members
    setup_battle_test_items
  end
  #--------------------------------------------------------------------------
  # * Battle Test Party Setup
  #--------------------------------------------------------------------------
  def setup_battle_test_members
    $data_system.test_battlers.each do |battler|
      actor = $game_actors[battler.actor_id]
      actor.change_level(battler.level, false)
      actor.init_equips(battler.equips)
      actor.recover_all
      add_actor(actor.id)
    end
  end
  #--------------------------------------------------------------------------
  # * Set Up Items for Battle Test
  #--------------------------------------------------------------------------
  def setup_battle_test_items
    $data_items.each do |item|
      gain_item(item, max_item_number(item)) if item && !item.name.empty?
    end
  end
  #--------------------------------------------------------------------------
  # * Get Highest Level of Party Members
  #--------------------------------------------------------------------------
  def highest_level
    lv = members.collect {|actor| actor.level }.max
  end
  #--------------------------------------------------------------------------
  # * Add an Actor
  #--------------------------------------------------------------------------
  def add_actor(actor_id)
    @actors.push(actor_id) unless @actors.include?(actor_id)
    $game_player.refresh
    $game_map.need_refresh = true
  end
  #--------------------------------------------------------------------------
  # * Modified
  # * Remove Actor
  #--------------------------------------------------------------------------
  def remove_actor(actor_id)
    @actors.delete(actor_id)
    map_leader = 0 if @map_leader_id == actor_id
    $game_player.refresh
    $game_map.need_refresh = true    
    remove_shortcuts_references(actor_id)
    remove_cooking_references(actor_id)
  end
  #--------------------------------------------------------------------------
  # * Modified
  # * Remove Shortcut References To This Actor
  #--------------------------------------------------------------------------
  def remove_shortcuts_references(actor_id)
    members.each {|actor| 
      actor.shortcuts.each { |shortcut|
        next if shortcut.empty?
        shortcut.clear if shortcut.actor.id == actor_id
      }
    }
  end
  #--------------------------------------------------------------------------
  # * Modified
  # * Remove Cooking References To This Actor
  #--------------------------------------------------------------------------
  def remove_cooking_references(actor_id)
    @cook_id = all_members[0].id if @cook_id == actor_id
    @cooking_shortcuts.each { |shortcut|
      next if shortcut.empty?
      shortcut.clear if shortcut.actor.id == actor_id
    }
  end
  #--------------------------------------------------------------------------
  # * Increase Gold
  #--------------------------------------------------------------------------
  def gain_gold(amount)
    @gold = [[@gold + amount, 0].max, max_gold].min
  end
  #--------------------------------------------------------------------------
  # * Decrease Gold
  #--------------------------------------------------------------------------
  def lose_gold(amount)
    gain_gold(-amount)
  end
  #--------------------------------------------------------------------------
  # * Get Maximum Value of Gold
  #--------------------------------------------------------------------------
  def max_gold
    return MAX_GOLD
  end
  #--------------------------------------------------------------------------
  # * Increase Steps
  #--------------------------------------------------------------------------
  def increase_steps
    @steps += 1
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Set New Max Combo If Higher
  #--------------------------------------------------------------------------
  def new_max_combo(combo)
    @max_combo = [combo, @max_combo].max
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Determine If Item Is New 
  #--------------------------------------------------------------------------
  def new_item?(item)
    wrapped_obj = Game_BaseItem.new
    wrapped_obj.object = item
    @new_items.include?(wrapped_obj)
  end
  #--------------------------------------------------------------------------
  # * Get Number of Items Possessed
  #--------------------------------------------------------------------------
  def item_number(item)
    container = item_container(item.class)
    container ? container[item.id] || 0 : 0
  end
  #--------------------------------------------------------------------------
  # * Modified
  # * Get Maximum Number of Items Possessed
  #--------------------------------------------------------------------------
  def max_item_number(item)
    return MAX_MATERIAL if (item.class == RPG::Item) && (item.food_item? || item.material_item?)
    return MAX_ITEMS
  end
  #--------------------------------------------------------------------------
  # * Determine if Maximum Number of Items Are Possessed
  #--------------------------------------------------------------------------
  def item_max?(item)
    item_number(item) >= max_item_number(item)
  end
  #--------------------------------------------------------------------------
  # * Determine Item Possession Status
  #     include_equip : Include equipped items
  #--------------------------------------------------------------------------
  def has_item?(item, include_equip = false)
    return true if item_number(item) > 0
    return include_equip ? members_equip_include?(item) : false
  end
  #--------------------------------------------------------------------------
  # * Determine if Specified Item Is Included in Members' Equipment
  #--------------------------------------------------------------------------
  def members_equip_include?(item)
    members.any? {|actor| actor.equips.include?(item) }
  end
  #--------------------------------------------------------------------------
  # * Modified
  # * Increase/Decrease Items
  #     include_equip : Include equipped items
  #--------------------------------------------------------------------------
  def gain_item(item, amount, include_equip = false, from_party = false)
    container = item_container(item.class)
    return unless container
    last_number = item_number(item)
    new_number = last_number + amount
    update_new_items(item, amount, from_party)
    container[item.id] = [[new_number, 0].max, max_item_number(item)].min
    container.delete(item.id) if container[item.id] == 0
    if include_equip && new_number < 0
      discard_members_equip(item, -new_number)
    end
    $game_map.need_refresh = true
  end
  #--------------------------------------------------------------------------
  # * Lose Items
  #     include_equip : Include equipped items
  #--------------------------------------------------------------------------
  def lose_item(item, amount, include_equip = false, from_party = false)
    gain_item(item, -amount, include_equip, from_party)
  end
  #--------------------------------------------------------------------------
  # * Consume Items
  #    If the specified object is a consumable item, the number in investory
  #    will be reduced by 1.
  #--------------------------------------------------------------------------
  def consume_item(item)
    lose_item(item, 1) if item.is_a?(RPG::Item) && item.consumable
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Update New Item Array
  #--------------------------------------------------------------------------
  def update_new_items(item, amount, from_party)
    return if item.nil?
    if amount <= 0
      remove_from_new_items(item, amount) if new_item?(item)
    else
      add_to_new_items(item) unless from_party
    end
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Remove Item From New Item Array
  #--------------------------------------------------------------------------
  def remove_from_new_items(item, amount)
    return if item_number(item) + amount > 0
    obj = new_items_wrapped_delete(item)
    obj.object = nil
    @new_items.push(obj)
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Add Item To New Item Array
  #--------------------------------------------------------------------------
  def add_to_new_items(item)
    obj = nil
    if new_item?(item)    
      obj = new_items_wrapped_delete(item)
    else
      obj = @new_items.pop
    end
    obj.object = item
    @new_items.unshift(obj)
  end  
  #--------------------------------------------------------------------------
  # * New Method
  # * Wrapper For Deleting Objects In New Objects List
  #--------------------------------------------------------------------------
  def new_items_wrapped_delete(item)
    wrapped_obj = Game_BaseItem.new
    wrapped_obj.object = item
    @new_items.delete(wrapped_obj)
  end
  #--------------------------------------------------------------------------
  # * Discard Members' Equipment
  #--------------------------------------------------------------------------
  def discard_members_equip(item, amount)
    n = amount
    members.each do |actor|
      while n > 0 && actor.equips.include?(item)
        actor.discard_equip(item)
        n -= 1
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Determine Skill/Item Usability
  #--------------------------------------------------------------------------
  def usable?(item)
    members.any? {|actor| actor.usable?(item) }
  end
  #--------------------------------------------------------------------------
  # * Determine Command Inputability During Battle
  #--------------------------------------------------------------------------
  def inputable?
    members.any? {|actor| actor.inputable? }
  end
  #--------------------------------------------------------------------------
  # * Determine if Everyone is Dead
  #--------------------------------------------------------------------------
  def all_dead?
    super && ($game_party.in_battle || members.size > 0)
  end
  #--------------------------------------------------------------------------
  # * Processing Performed When Player Takes 1 Step
  #--------------------------------------------------------------------------
  def on_player_walk
    members.each {|actor| actor.on_player_walk }
  end
  #--------------------------------------------------------------------------
  # * Get Actor Selected on Menu Screen
  #--------------------------------------------------------------------------
  def menu_actor
    $game_actors[@menu_actor_id] || members[0]
  end
  #--------------------------------------------------------------------------
  # * Set Actor Selected on Menu Screen
  #--------------------------------------------------------------------------
  def menu_actor=(actor)
    @menu_actor_id = actor.id
  end
  #--------------------------------------------------------------------------
  # * Select Next Actor on Menu Screen
  #--------------------------------------------------------------------------
  def menu_actor_next
    index = members.index(menu_actor) || -1
    index = (index + 1) % members.size
    self.menu_actor = members[index]
  end
  #--------------------------------------------------------------------------
  # * Select Previous Actor on Menu Screen
  #--------------------------------------------------------------------------
  def menu_actor_prev
    index = members.index(menu_actor) || 1
    index = (index + members.size - 1) % members.size
    self.menu_actor = members[index]
  end
  #--------------------------------------------------------------------------
  # * Get Actor Targeted by Skill/Item Use
  #--------------------------------------------------------------------------
  def target_actor
    $game_actors[@target_actor_id] || members[0]
  end
  #--------------------------------------------------------------------------
  # * Set Actor Targeted by Skill/Item Use
  #--------------------------------------------------------------------------
  def target_actor=(actor)
    @target_actor_id = actor.id
  end
  #--------------------------------------------------------------------------
  # * Change Order
  #--------------------------------------------------------------------------
  def swap_order(index1, index2)
    @actors[index1], @actors[index2] = @actors[index2], @actors[index1]
    $game_player.refresh
  end
  #--------------------------------------------------------------------------
  # * Character Image Information for Save File Display
  #--------------------------------------------------------------------------
  def characters_for_savefile
    all_members.collect do |actor|
      [actor.face_name, actor.face_index, actor.name, actor.level, actor.hp, actor.mhp, actor.mp, actor.mmp]
    end
  end
  #--------------------------------------------------------------------------
  # * Determine Party Ability
  #--------------------------------------------------------------------------
  def party_ability(ability_id)
    battle_members.any? {|actor| actor.party_ability(ability_id) }
  end
  #--------------------------------------------------------------------------
  # * Halve Encounters?
  #--------------------------------------------------------------------------
  def encounter_half?
    party_ability(ABILITY_ENCOUNTER_HALF)
  end
  #--------------------------------------------------------------------------
  # * Disable Encounters?
  #--------------------------------------------------------------------------
  def encounter_none?
    party_ability(ABILITY_ENCOUNTER_NONE)
  end
  #--------------------------------------------------------------------------
  # * Disable Surprise?
  #--------------------------------------------------------------------------
  def cancel_surprise?
    party_ability(ABILITY_CANCEL_SURPRISE)
  end
  #--------------------------------------------------------------------------
  # * Increase Preemptive Strike Rate?
  #--------------------------------------------------------------------------
  def raise_preemptive?
    party_ability(ABILITY_RAISE_PREEMPTIVE)
  end
  #--------------------------------------------------------------------------
  # * Double Money Earned?
  #--------------------------------------------------------------------------
  def gold_double?
    party_ability(ABILITY_GOLD_DOUBLE)
  end
  #--------------------------------------------------------------------------
  # * Double Item Acquisition Rate?
  #--------------------------------------------------------------------------
  def drop_item_double?
    party_ability(ABILITY_DROP_ITEM_DOUBLE)
  end
  #--------------------------------------------------------------------------
  # * Calculate Probability of Preemptive Attack
  #--------------------------------------------------------------------------
  def rate_preemptive(troop_agi)
    (agi >= troop_agi ? 0.05 : 0.03) * (raise_preemptive? ? 4 : 1)
  end
  #--------------------------------------------------------------------------
  # * Calculate Probability of Surprise
  #--------------------------------------------------------------------------
  def rate_surprise(troop_agi)
    cancel_surprise? ? 0 : (agi >= troop_agi ? 0.03 : 0.05)
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Increase Grade
  #--------------------------------------------------------------------------
  def gain_grade(amount)
    @grade = [[@grade + amount, 0].max, max_grade].min
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Decrease Grade
  #--------------------------------------------------------------------------
  def lose_grade(amount)
    gain_grade(-amount)
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Get Maximum Value of Grade
  #--------------------------------------------------------------------------
  def max_grade
    return GRADE_MAX
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Get Map Leader
  #--------------------------------------------------------------------------
  def map_leader
    $game_actors[@map_leader_id]
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Set Map Leader
  #--------------------------------------------------------------------------
  def map_leader=(id)
    @map_leader_id = id
    $game_player.refresh
  end  
  #--------------------------------------------------------------------------
  # * Get Cook
  #--------------------------------------------------------------------------
  def cook
    $game_actors[@cook_id] || members[0]
  end
  #--------------------------------------------------------------------------
  # * Set Cook
  #--------------------------------------------------------------------------
  def cook=(actor)
    @cook_id = actor.id
  end
  #--------------------------------------------------------------------------
  # * Get Recipe
  #--------------------------------------------------------------------------
  def recipe
    $data_recipes[@recipe_id] || recipes[0]
  end
  #--------------------------------------------------------------------------
  # * Set Recipe
  #--------------------------------------------------------------------------
  def recipe=(recipe)
    return unless recipe
    @recipe_id = recipe.id
  end
  #--------------------------------------------------------------------------
  # * Get Recipe Object Array
  #--------------------------------------------------------------------------
  def recipes
    @recipes.sort.collect {|id| $data_recipes[id] }
  end
  #--------------------------------------------------------------------------
  # * Learn Recipe
  #--------------------------------------------------------------------------
  def learn_recipe(recipe_id)
    return if recipe_learn?($data_recipes[recipe_id])
    @recipes.push(recipe_id)
    @recipes.sort!
    $game_actors.all_actors.each { |actor| actor.learn_recipe(recipe_id) } 
  end
  #--------------------------------------------------------------------------
  # * Determine if Recipe Is Already Learned
  #--------------------------------------------------------------------------
  def recipe_learn?(recipe)
    recipe.is_a?(RPG::Recipe) && @recipes.include?(recipe.id)
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Change Shortcuts
  #     slot_id:  Shortcut slot ID
  #     actor: Actor cooking the recipe (remove actor if nil)
  #     recipe: shortcut recipe (remove recipe if nil)
  #--------------------------------------------------------------------------
  def change_shortcut(slot_id, actor, recipe)
    if actor.nil? || recipe.nil?
      @cooking_shortcuts[slot_id].clear 
    else
      @cooking_shortcuts[slot_id].shortcut(actor, recipe)
    end
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Shortcuts
  #--------------------------------------------------------------------------
  def cooking_shortcuts
    @cooking_shortcuts
  end 
end
