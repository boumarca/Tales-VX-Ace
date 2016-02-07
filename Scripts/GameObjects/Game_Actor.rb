#==============================================================================
# ** Game_Actor
#------------------------------------------------------------------------------
#  This class handles actors. It is used within the Game_Actors class
# ($game_actors) and is also referenced from the Game_Party class ($game_party).
#==============================================================================

class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # * Constants
  #--------------------------------------------------------------------------
  SKILLS_SLOTS          = 4
  SHORTCUT_SLOTS        = 4
  COOKING_LEVEL_0       =  0...5
  COOKING_LEVEL_1       =  5...15
  COOKING_LEVEL_2       = 15...30
  GOOD_COOK_MULTIPLIER  = 1.5
  RECIPE_FAILURE        = 0.5
  MAX_COOKING_LEVEL     = 3
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :name                     # Name
  attr_accessor :nickname                 # Nickname
  attr_reader   :battle_control           # Battle Control Scheme
  attr_reader   :character_name           # character graphic filename
  attr_reader   :character_index          # character graphic index
  attr_reader   :face_name                # face graphic filename
  attr_reader   :face_index               # face graphic index
  attr_reader   :class_id                 # class ID
  attr_reader   :level                    # level
  attr_reader   :action_input_index       # action number being input
  attr_reader   :last_skill               # For cursor memorization:  Skill
  attr_reader   :portrait_name            # Portrait filename for status menu
  attr_reader   :sp                       # Current SP
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(actor_id)
    super()
    setup(actor_id)
    @last_skill = Game_BaseItem.new
  end
  #--------------------------------------------------------------------------
  # * Modified
  # * Setup
  #--------------------------------------------------------------------------
  def setup(actor_id)
    @battle_control = :auto
    @actor_id = actor_id
    @name = actor.name
    @nickname = actor.nickname
    init_graphics
    @class_id = actor.class_id
    @level = actor.initial_level
    @exp = {}
    @equips = []
    @battle_skills = []
    @shortcuts = []
    @recipe_usage = {}
    init_capacities
    init_stats
    init_titles
    init_exp
    init_skills
    init_battle_skills
    init_equips(actor.equips)
    clear_param_plus
    recover_all
  end
  #--------------------------------------------------------------------------
  # * Get Actor Object
  #--------------------------------------------------------------------------
  def actor
    $data_actors[@actor_id]
  end
  #--------------------------------------------------------------------------
  # * Modified
  # * Initialize Graphics
  #--------------------------------------------------------------------------
  def init_graphics
    @character_name = actor.character_name
    @character_index = actor.character_index
    @face_name = actor.face_name
    @face_index = actor.face_index
    @portrait_name = actor.image
  end
  #--------------------------------------------------------------------------
  # * Get Total EXP Required for Rising to Specified Level
  #--------------------------------------------------------------------------
  def exp_for_level(level)
    self.class.exp_for_level(level)
  end
  #--------------------------------------------------------------------------
  # * Initialize EXP
  #--------------------------------------------------------------------------
  def init_exp
    @exp[@class_id] = current_level_exp
  end
  #--------------------------------------------------------------------------
  # * Get Experience
  #--------------------------------------------------------------------------
  def exp
    @exp[@class_id]
  end
  #--------------------------------------------------------------------------
  # * Get Minimum EXP for Current Level
  #--------------------------------------------------------------------------
  def current_level_exp
    exp_for_level(@level)
  end
  #--------------------------------------------------------------------------
  # * Get EXP for Next Level
  #--------------------------------------------------------------------------
  def next_level_exp
    exp_for_level(@level + 1)
  end
  #--------------------------------------------------------------------------
  # * Maximum Level
  #--------------------------------------------------------------------------
  def max_level
    actor.max_level
  end
  #--------------------------------------------------------------------------
  # * Determine Maximum Level
  #--------------------------------------------------------------------------
  def max_level?
    @level >= max_level
  end
  #--------------------------------------------------------------------------
  # * Initialize Skills
  #--------------------------------------------------------------------------
  def init_skills
    @skills = []
    @active_skills = []
    self.class.learnings.each do |learning|
      learn_skill(learning.skill_id) if learning.level <= @level
    end
  end
  #--------------------------------------------------------------------------
  # * Initialize Equipment
  #     equips:  An array of initial equipment
  #--------------------------------------------------------------------------
  def init_equips(equips)
    @equips = Array.new(equip_slots.size) { Game_BaseItem.new }
    equips.each_with_index do |item_id, i|
      etype_id = index_to_etype_id(i)
      slot_id = empty_slot(etype_id)
      @equips[slot_id].set_equip(etype_id == 0, item_id) if slot_id
    end
    refresh   
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Initialize Battle Skills
  #--------------------------------------------------------------------------
  def init_battle_skills
    @battle_skills = Array.new(SKILLS_SLOTS) { Game_BaseItem.new }
    @shortcuts = Array.new(SHORTCUT_SLOTS) { Game_SkillShortcut.new }
  end
  #--------------------------------------------------------------------------
  # * Modified
  # * Change Skills in Manual mode
  #     slot_id:  Skills slot ID
  #     item:    Skills (remove skill if nil)
  #--------------------------------------------------------------------------
  def change_skill(slot_id, skill)
    @battle_skills[slot_id].object = skill
    refresh
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Change Shortcut in Manual mode
  #     slot_id:  Shortcut slot ID
  #     actor: Actor using the skill (remove actor if nil)
  #     skill: shortcut skill (remove skill if nil)
  #--------------------------------------------------------------------------
  def change_shortcut(slot_id, actor, skill)
    if actor.nil? || skill.nil?
      @shortcuts[slot_id].clear 
    else
      @shortcuts[slot_id].shortcut(actor, skill)
    end
    refresh
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Activate Skill In Auto Mode
  #--------------------------------------------------------------------------
  def activate_skill(skill)
    @active_skills.push(skill.id)
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Deactivate Skill In Auto Mode
  #--------------------------------------------------------------------------
  def deactivate_skill(skill)
    @active_skills.delete(skill.id)
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Determine if skill is already active
  #--------------------------------------------------------------------------
  def skill_active?(skill)
    skill.is_a?(RPG::Skill) && @active_skills.include?(skill.id)
  end
  #--------------------------------------------------------------------------
  # * Convert Index Set by Editor to Equipment Type ID
  #--------------------------------------------------------------------------
  def index_to_etype_id(index)
    index == 1 && dual_wield? ? 0 : index
  end
  #--------------------------------------------------------------------------
  # * Convert from Equipment Type to List of Slot IDs
  #--------------------------------------------------------------------------
  def slot_list(etype_id)
    result = []
    equip_slots.each_with_index {|e, i| result.push(i) if e == etype_id }
    result
  end
  #--------------------------------------------------------------------------
  # * Convert from Equipment Type to Slot ID (Empty Take Precedence)
  #--------------------------------------------------------------------------
  def empty_slot(etype_id)
    list = slot_list(etype_id)
    list.find {|i| @equips[i].is_nil? } || list[0]
  end
  #--------------------------------------------------------------------------
  # * Get Equipment Slot Array
  #--------------------------------------------------------------------------
  def equip_slots
    return [0,0,2,3,4] if dual_wield?       # Dual wield
    return [0,1,2,3,4]                      # Normal
  end
  #--------------------------------------------------------------------------
  # * Get Weapon Object Array
  #--------------------------------------------------------------------------
  def weapons
    @equips.select {|item| item.is_weapon? }.collect {|item| item.object }
  end
  #--------------------------------------------------------------------------
  # * Get Armor Object Array
  #--------------------------------------------------------------------------
  def armors
    @equips.select {|item| item.is_armor? }.collect {|item| item.object }
  end
  #--------------------------------------------------------------------------
  # * Get Equipped Item Object Array
  #--------------------------------------------------------------------------
  def equips
    @equips.collect {|item| item.object }
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Check if Actor has Item Equipped
  #--------------------------------------------------------------------------
  def equipped?(item)
    return false if equips[item.etype_id].nil?
    equips[item.etype_id].id == item.id
  end
  #--------------------------------------------------------------------------
  # * Determine if Equipment Change Possible
  #     slot_id:  Equipment slot ID
  #--------------------------------------------------------------------------
  def equip_change_ok?(slot_id)
    return false if equip_type_fixed?(equip_slots[slot_id])
    return false if equip_type_sealed?(equip_slots[slot_id])
    return true
  end
  #--------------------------------------------------------------------------
  # * Change Equipment
  #     slot_id:  Equipment slot ID
  #     item:    Weapon/armor (remove equipment if nil)
  #--------------------------------------------------------------------------
  def change_equip(slot_id, item)
    return unless trade_item_with_party(item, equips[slot_id])
    return if item && equip_slots[slot_id] != item.etype_id
    @equips[slot_id].object = item
    refresh
  end
  #--------------------------------------------------------------------------
  # * Forcibly Change Equipment
  #     slot_id:  Equipment slot ID
  #     item:     Weapon/armor (remove equipment if nil)
  #--------------------------------------------------------------------------
  def force_change_equip(slot_id, item)
    @equips[slot_id].object = item
    release_unequippable_items(false)
    refresh
  end
  #--------------------------------------------------------------------------
  # * Trade Item with Party
  #     new_item:  Item to get from party
  #     old_item:  Item to give to party
  #--------------------------------------------------------------------------
  def trade_item_with_party(new_item, old_item)
    return false if new_item && !$game_party.has_item?(new_item)
    $game_party.gain_item(old_item, 1, false, true)
    $game_party.lose_item(new_item, 1, false, true)
    return true
  end
  #--------------------------------------------------------------------------
  # * Change Equipment (Specify with ID)
  #     slot_id:  Equipment slot ID
  #     item_id:  Weapons/armor ID
  #--------------------------------------------------------------------------
  def change_equip_by_id(slot_id, item_id)
    if equip_slots[slot_id] == 0
      change_equip(slot_id, $data_weapons[item_id])
    else
      change_equip(slot_id, $data_armors[item_id])
    end
  end
  #--------------------------------------------------------------------------
  # * Discard Equipment
  #     item:  Weapon/armor to discard
  #--------------------------------------------------------------------------
  def discard_equip(item)
    slot_id = equips.index(item)
    @equips[slot_id].object = nil if slot_id
  end
  #--------------------------------------------------------------------------
  # * Remove Equipment that Cannot Be Equipped 
  #     item_gain:  Return removed equipment to party.
  #--------------------------------------------------------------------------
  def release_unequippable_items(item_gain = true)
    loop do
      last_equips = equips.dup
      @equips.each_with_index do |item, i|
        if !equippable?(item.object) || item.object.etype_id != equip_slots[i]
          trade_item_with_party(nil, item.object) if item_gain
          item.object = nil
        end
      end
      return if equips == last_equips
    end
  end
  #--------------------------------------------------------------------------
  # * Remove All Equipment
  #--------------------------------------------------------------------------
  def clear_equipments
    equip_slots.size.times do |i|
      change_equip(i, nil) if equip_change_ok?(i)
    end
  end
  #--------------------------------------------------------------------------
  # * Ultimate Equipment
  #--------------------------------------------------------------------------
  def optimize_equipments
    clear_equipments
    equip_slots.size.times do |i|
      next if !equip_change_ok?(i)
      items = $game_party.equip_items.select do |item|
        item.etype_id == equip_slots[i] &&
        equippable?(item) && item.performance >= 0
      end
      change_equip(i, items.max_by {|item| item.performance })
    end
  end
  #--------------------------------------------------------------------------
  # * Determine if Skill-Required Weapon Is Equipped
  #--------------------------------------------------------------------------
  def skill_wtype_ok?(skill)
    wtype_id1 = skill.required_wtype_id1
    wtype_id2 = skill.required_wtype_id2
    return true if wtype_id1 == 0 && wtype_id2 == 0
    return true if wtype_id1 > 0 && wtype_equipped?(wtype_id1)
    return true if wtype_id2 > 0 && wtype_equipped?(wtype_id2)
    return false
  end
  #--------------------------------------------------------------------------
  # * Determine if Specific Type of Weapon Is Equipped
  #--------------------------------------------------------------------------
  def wtype_equipped?(wtype_id)
    weapons.any? {|weapon| weapon.wtype_id == wtype_id }
  end
  #--------------------------------------------------------------------------
  # * Modified
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    @sp = [[@sp, msp].min, 0].max
    release_unequippable_items
    super
  end
  #--------------------------------------------------------------------------
  # * Determine if Actor or Not
  #--------------------------------------------------------------------------
  def actor?
    return true
  end
  #--------------------------------------------------------------------------
  # * Get Allied Units
  #--------------------------------------------------------------------------
  def friends_unit
    $game_party
  end
  #--------------------------------------------------------------------------
  # * Get Enemy Units
  #--------------------------------------------------------------------------
  def opponents_unit
    $game_troop
  end
  #--------------------------------------------------------------------------
  # * Get Actor ID
  #--------------------------------------------------------------------------
  def id
    @actor_id
  end
  #--------------------------------------------------------------------------
  # * Get Index
  #--------------------------------------------------------------------------
  def index
    $game_party.members.index(self)
  end
  #--------------------------------------------------------------------------
  # * Determine Battle Members
  #--------------------------------------------------------------------------
  def battle_member?
    $game_party.battle_members.include?(self)
  end
  #--------------------------------------------------------------------------
  # * Get Class Object
  #--------------------------------------------------------------------------
  def class
    $data_classes[@class_id]
  end
  #--------------------------------------------------------------------------
  # * Get Skill Object Array
  #--------------------------------------------------------------------------
  def skills
    (@skills | added_skills).sort.collect {|id| $data_skills[id] }
  end
  #--------------------------------------------------------------------------
  # * Get Array of Currently Usable Skills
  #--------------------------------------------------------------------------
  def usable_skills
    skills.select {|skill| usable?(skill) }
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Battle Skills
  #--------------------------------------------------------------------------
  def battle_skills
    @battle_skills.collect {|item| item.object }
  end 
  #--------------------------------------------------------------------------
  # * New Method
  # * Shortcuts
  #--------------------------------------------------------------------------
  def shortcuts
    @shortcuts
  end 
  #--------------------------------------------------------------------------
  # * New Method
  # * Get Active Skill Object Array
  #--------------------------------------------------------------------------
  def active_skills
    @active_skills.sort.collect {|id| $data_skills[id] }
  end
  #--------------------------------------------------------------------------
  # * Modified
  # * Get Array of All Objects Retaining Features
  #--------------------------------------------------------------------------
  def feature_objects
    super + [actor] + [self.class] + equips.compact + active_capacities
  end
  #--------------------------------------------------------------------------
  # * Get Attack Element
  #--------------------------------------------------------------------------
  def atk_elements
    set = super
    set |= [1] if weapons.compact.empty?  # Unarmed: Physical element
    return set
  end
  #--------------------------------------------------------------------------
  # * Modified
  # * Get Maximum Value of Parameter
  #--------------------------------------------------------------------------
  def param_max(param_id)
    return 999 if param_id == 1  # MMP
    return 9999
  end
  #--------------------------------------------------------------------------
  # * Modified
  # * Get Base Value of Parameter
  #--------------------------------------------------------------------------
  def param_base(param_id)
    self.class.params[param_id, 1] + @growth_rate[param_id] * @level
  end
  #--------------------------------------------------------------------------
  # * Modified
  # * Get Added Value of Parameter
  #--------------------------------------------------------------------------
  def param_plus(param_id)
    equips.compact.inject(super) {|r, item| r += item.params[param_id] } + param_title(param_id)
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Get Added Title Value of Parameter
  #--------------------------------------------------------------------------
  def param_title(param_id)
    @title_growth[param_id]
  end
  #--------------------------------------------------------------------------
  # * Get Normal Attack Animation ID
  #--------------------------------------------------------------------------
  def atk_animation_id1
    if dual_wield?
      return weapons[0].animation_id if weapons[0]
      return weapons[1] ? 0 : 1
    else
      return weapons[0] ? weapons[0].animation_id : 1
    end
  end
  #--------------------------------------------------------------------------
  # * Get Animation ID of Normal Attack (Dual Wield: Weapon 2)
  #--------------------------------------------------------------------------
  def atk_animation_id2
    if dual_wield?
      return weapons[1] ? weapons[1].animation_id : 0
    else
      return 0
    end
  end
  #--------------------------------------------------------------------------
  # * Change Experience
  #     show : Level up display flag
  #--------------------------------------------------------------------------
  def change_exp(exp, show)
    @exp[@class_id] = [exp, 0].max
    last_level = @level
    last_skills = skills
    level_up while !max_level? && self.exp >= next_level_exp
    level_down while self.exp < current_level_exp
    display_level_up(skills - last_skills) if show && @level > last_level
    refresh
  end
  #--------------------------------------------------------------------------
  # * Get Experience
  #--------------------------------------------------------------------------
  def exp
    @exp[@class_id]
  end
  #--------------------------------------------------------------------------
  # * Modified
  # * Level Up
  #--------------------------------------------------------------------------
  def level_up
    old_mhp = mhp
    old_mmp = mmp
    @level += 1
    self.class.learnings.each do |learning|
      learn_skill(learning.skill_id) if learning.level == @level
    end
    (0..7).each { |i| @title_growth[i] += current_title.params[i] }
    @hp += mhp - old_mhp
    @mp += mmp - old_mmp
    @sp += self.class.msp / max_level
  end
  #--------------------------------------------------------------------------
  # * Level Down
  #--------------------------------------------------------------------------
  def level_down
    @level -= 1
  end
  #--------------------------------------------------------------------------
  # * Show Level Up Message
  #     new_skills : Array of newly learned skills
  #--------------------------------------------------------------------------
  def display_level_up(new_skills)
    $game_message.new_page
    $game_message.add(sprintf(Vocab::LevelUp, @name, Vocab::level, @level))
    new_skills.each do |skill|
      $game_message.add(sprintf(Vocab::ObtainSkill, skill.name))
    end
  end
  #--------------------------------------------------------------------------
  # * Get EXP (Account for Experience Rate)
  #--------------------------------------------------------------------------
  def gain_exp(exp)
    change_exp(self.exp + (exp * final_exp_rate).to_i, true)
  end
  #--------------------------------------------------------------------------
  # * Calculate Final EXP Rate
  #--------------------------------------------------------------------------
  def final_exp_rate
    exr * (battle_member? ? 1 : reserve_members_exp_rate)
  end
  #--------------------------------------------------------------------------
  # * Get EXP Rate for Reserve Members
  #--------------------------------------------------------------------------
  def reserve_members_exp_rate
    $data_system.opt_extra_exp ? 1 : 0
  end
  #--------------------------------------------------------------------------
  # * Change Level
  #     show : Level up display flag
  #--------------------------------------------------------------------------
  def change_level(level, show)
    level = [[level, max_level].min, 1].max
    change_exp(exp_for_level(level), show)
  end
  #--------------------------------------------------------------------------
  # * Learn Skill
  #--------------------------------------------------------------------------
  def learn_skill(skill_id)
    unless skill_learn?($data_skills[skill_id])
      @skills.push(skill_id)
      @active_skills.push(skill_id)
      @skills.sort!
      @active_skills.sort!
    end
  end
  #--------------------------------------------------------------------------
  # * Forget Skill
  #--------------------------------------------------------------------------
  def forget_skill(skill_id)
    @skills.delete(skill_id)
  end
  #--------------------------------------------------------------------------
  # * Determine if Skill Is Already Learned
  #--------------------------------------------------------------------------
  def skill_learn?(skill)
    skill.is_a?(RPG::Skill) && @skills.include?(skill.id)
  end
  #--------------------------------------------------------------------------
  # * Get Description
  #--------------------------------------------------------------------------
  def description
    actor.description
  end
  #--------------------------------------------------------------------------
  # * Change Class
  #     keep_exp:  Keep EXP
  #--------------------------------------------------------------------------
  def change_class(class_id, keep_exp = false)
    @exp[class_id] = exp if keep_exp
    @class_id = class_id
    change_exp(@exp[@class_id] || 0, false)
    refresh
  end
  #--------------------------------------------------------------------------
  # * Change Graphics
  #--------------------------------------------------------------------------
  def set_graphic(character_name, character_index, face_name, face_index)
    @character_name = character_name
    @character_index = character_index
    @face_name = face_name
    @face_index = face_index
  end
  #--------------------------------------------------------------------------
  # * Use Sprites?
  #--------------------------------------------------------------------------
  def use_sprite?
    return false
  end
  #--------------------------------------------------------------------------
  # * Execute Damage Effect
  #--------------------------------------------------------------------------
  def perform_damage_effect
    $game_troop.screen.start_shake(5, 5, 10)
    @sprite_effect_type = :blink
    Sound.play_actor_damage
  end
  #--------------------------------------------------------------------------
  # * Execute Collapse Effect
  #--------------------------------------------------------------------------
  def perform_collapse_effect
    if $game_party.in_battle
      @sprite_effect_type = :collapse
      Sound.play_actor_collapse
    end
  end
  #--------------------------------------------------------------------------
  # * Create Action Candidate List for Auto Battle
  #--------------------------------------------------------------------------
  def make_action_list
    list = []
    list.push(Game_Action.new(self).set_attack.evaluate)
    usable_skills.each do |skill|
      list.push(Game_Action.new(self).set_skill(skill.id).evaluate)
    end
    list
  end
  #--------------------------------------------------------------------------
  # * Create Action During Auto Battle
  #--------------------------------------------------------------------------
  def make_auto_battle_actions
    @actions.size.times do |i|
      @actions[i] = make_action_list.max_by {|action| action.value }
    end
  end
  #--------------------------------------------------------------------------
  # * Create Action During Confusion
  #--------------------------------------------------------------------------
  def make_confusion_actions
    @actions.size.times do |i|
      @actions[i].set_confusion
    end
  end
  #--------------------------------------------------------------------------
  # * Create Battle Action
  #--------------------------------------------------------------------------
  def make_actions
    super
    if auto_battle?
      make_auto_battle_actions
    elsif confusion?
      make_confusion_actions
    end
  end
  #--------------------------------------------------------------------------
  # * Processing Performed When Player Takes 1 Step
  #--------------------------------------------------------------------------
  def on_player_walk
    @result.clear
    check_floor_effect
    if $game_player.normal_walk?
      turn_end_on_map
      states.each {|state| update_state_steps(state) }
      show_added_states
      show_removed_states
    end
  end
  #--------------------------------------------------------------------------
  # * Update Step Count for State
  #--------------------------------------------------------------------------
  def update_state_steps(state)
    if state.remove_by_walking
      @state_steps[state.id] -= 1 if @state_steps[state.id] > 0
      remove_state(state.id) if @state_steps[state.id] == 0
    end
  end
  #--------------------------------------------------------------------------
  # * Show Added State
  #--------------------------------------------------------------------------
  def show_added_states
    @result.added_state_objects.each do |state|
      $game_message.add(name + state.message1) unless state.message1.empty?
    end
  end
  #--------------------------------------------------------------------------
  # * Show Removed State
  #--------------------------------------------------------------------------
  def show_removed_states
    @result.removed_state_objects.each do |state|
      $game_message.add(name + state.message4) unless state.message4.empty?
    end
  end
  #--------------------------------------------------------------------------
  # * Number of Steps Regarded as One Turn in Battle
  #--------------------------------------------------------------------------
  def steps_for_turn
    return 20
  end
  #--------------------------------------------------------------------------
  # * End of Turn Processing on Map Screen
  #--------------------------------------------------------------------------
  def turn_end_on_map
    if $game_party.steps % steps_for_turn == 0
      on_turn_end
      perform_map_damage_effect if @result.hp_damage > 0
    end
  end
  #--------------------------------------------------------------------------
  # * Determine Floor Effect
  #--------------------------------------------------------------------------
  def check_floor_effect
    execute_floor_damage if $game_player.on_damage_floor?
  end
  #--------------------------------------------------------------------------
  # * Floor Damage Processing
  #--------------------------------------------------------------------------
  def execute_floor_damage
    damage = (basic_floor_damage * fdr).to_i
    self.hp -= [damage, max_floor_damage].min
    perform_map_damage_effect if damage > 0
  end
  #--------------------------------------------------------------------------
  # * Get Base Value for Floor Damage
  #--------------------------------------------------------------------------
  def basic_floor_damage
    return 10
  end
  #--------------------------------------------------------------------------
  # * Get Maximum Value for Floor Damage
  #--------------------------------------------------------------------------
  def max_floor_damage
    $data_system.opt_floor_death ? hp : [hp - 1, 0].max
  end
  #--------------------------------------------------------------------------
  # * Execute Damage Effect on Map
  #--------------------------------------------------------------------------
  def perform_map_damage_effect
    $game_map.screen.start_flash_for_damage
  end
  #--------------------------------------------------------------------------
  # * Clear Actions
  #--------------------------------------------------------------------------
  def clear_actions
    super
    @action_input_index = 0
  end
  #--------------------------------------------------------------------------
  # * Get Action Being Input
  #--------------------------------------------------------------------------
  def input
    @actions[@action_input_index]
  end
  #--------------------------------------------------------------------------
  # * To Next Command Input
  #--------------------------------------------------------------------------
  def next_command
    return false if @action_input_index >= @actions.size - 1
    @action_input_index += 1
    return true
  end
  #--------------------------------------------------------------------------
  # * To Previous Command Input
  #--------------------------------------------------------------------------
  def prior_command
    return false if @action_input_index <= 0
    @action_input_index -= 1
    return true
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Initialize titles
  #--------------------------------------------------------------------------
  def init_titles
    @titles = []
    @current_title = Game_BaseItem.new
    obtain_title(actor.default_title_id)
    equip_title($data_titles[actor.default_title_id])
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Obtain Title
  #--------------------------------------------------------------------------
  def obtain_title(title_id)
    unless title_unlocked?($data_titles[title_id])
      @titles.push(title_id)
      @titles.sort!
    end
  end
  #--------------------------------------------------------------------------
  # * Determine if Skill Is Already Learned
  #--------------------------------------------------------------------------
  def title_unlocked?(title)
    title.is_a?(RPG::Title) && @titles.include?(title.id)
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Equip Title
  #--------------------------------------------------------------------------
  def equip_title(title)
    return unless title_unlocked?(title)
    return if @current_title.object == title
    @current_title.object = title if !title.nil?
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Get Title Object Array
  #--------------------------------------------------------------------------
  def titles
    @titles.sort.collect {|id| $data_titles[id] }
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Get Current Title
  #--------------------------------------------------------------------------
  def current_title
    @current_title.object
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Initialize Stats Arrays
  #--------------------------------------------------------------------------
  def init_stats
    @growth_rate = self.class.growth_rate
    @title_growth = [0.0] * 8
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Check if actor is controlled auto
  #--------------------------------------------------------------------------
  def auto?
    @battle_control == :auto
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Check if actor is controlled manual
  #--------------------------------------------------------------------------
  def manual?
    @battle_control == :manual
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Check if actor is controlled manual
  #--------------------------------------------------------------------------
  def semi_auto?
    @battle_control == :semi_auto
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Toggle Control Mode
  #--------------------------------------------------------------------------
  def toggle_control
    if @battle_control == :auto
      @battle_control = :manual
    elsif @battle_control == :manual
      @battle_control = :semi_auto
    else
      @battle_control = :auto
    end
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Set control to Manual
  #--------------------------------------------------------------------------
  def set_to_manual
    @battle_control = :manual
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Initialize capacities
  #--------------------------------------------------------------------------
  def init_capacities
    @msp_plus = 0
    @sp = msp
    @capacities = []
    @active_capacities = []
    self.class.capacities.each do |capacity|
      learn_capacity(capacity)
    end
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Learn Capacity
  #--------------------------------------------------------------------------
  def learn_capacity(capacity_id)
    unless capacity_learn?($data_capacities[capacity_id])
      @capacities.push(capacity_id)
      @capacities.sort!
    end
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Determine if Capacity Is Already Learned
  #--------------------------------------------------------------------------
  def capacity_learn?(capacity)
    capacity.is_a?(RPG::Capacity) && @capacities.include?(capacity.id)
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Get Capacity Object Array
  #--------------------------------------------------------------------------
  def capacities
    @capacities.sort.collect {|id| $data_capacities[id] }
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Get Active Capacity Object Array
  #--------------------------------------------------------------------------
  def active_capacities
    @active_capacities.sort.collect { |id| $data_capacities[id] }
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Determine if capacity is already active
  #--------------------------------------------------------------------------
  def capacity_active?(capacity)
    capacity.is_a?(RPG::Capacity) && @active_capacities.include?(capacity.id)
  end
  #--------------------------------------------------------------------------
  # * Change SP
  #--------------------------------------------------------------------------
  def sp=(sp)
    @sp = sp
    refresh
  end
  #--------------------------------------------------------------------------
  # * Get Max SP
  #--------------------------------------------------------------------------
  def msp
    [self.class.msp / max_level * @level + @msp_plus, 0].max
  end
  #--------------------------------------------------------------------------
  # * Increase Max SP
  #--------------------------------------------------------------------------
  def add_max_sp(value)
    @msp_plus += value
    @sp += value
    refresh
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Get Percentage of SP
  #--------------------------------------------------------------------------
  def sp_rate
    msp > 0 ? @sp.to_f / msp : 0
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Calculate Capacity's SP Cost
  #--------------------------------------------------------------------------
  def capacity_sp_cost(capacity)
    capacity.sp_cost
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Determine if Cost of Using Capacity Can Be Paid
  #--------------------------------------------------------------------------
  def capacity_cost_payable?(capacity)
    sp >= capacity_sp_cost(capacity)
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Pay Cost of Using Capacity
  #--------------------------------------------------------------------------
  def pay_capacity_cost(capacity)
    self.sp -= capacity_sp_cost(capacity)
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Recover Cost of Inactivating Capacity
  #--------------------------------------------------------------------------
  def recover_capacity_cost(capacity)
    self.sp += capacity_sp_cost(capacity)
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Activate capacity
  #--------------------------------------------------------------------------
  def activate_capacity(capacity)
    pay_capacity_cost(capacity)
    @active_capacities.push(capacity.id)
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Deactivate capacity
  #--------------------------------------------------------------------------
  def deactivate_capacity(capacity)
    recover_capacity_cost(capacity)
    @active_capacities.delete(capacity.id)
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Learn Recipe
  #--------------------------------------------------------------------------
  def learn_recipe(recipe_id)
    @recipe_usage[recipe_id] = 0
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Use Recipe
  #--------------------------------------------------------------------------
  def use_recipe(recipe, success)
    multiplier = recipe.actor_id == actor.id ? GOOD_COOK_MULTIPLIER : 1
    rate = success ? 1 : RECIPE_FAILURE
    @recipe_usage[recipe.id] += multiplier * rate
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Get Recipe Level
  #--------------------------------------------------------------------------
  def mastery_level(recipe)
    return 0 unless recipe 
    use = @recipe_usage[recipe.id]
    return 0 if COOKING_LEVEL_0 === use
    return 1 if COOKING_LEVEL_1 === use
    return 2 if COOKING_LEVEL_2 === use
    return 3 
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Get Max Cooking Level
  #--------------------------------------------------------------------------
  def master_recipe?(recipe)
    mastery_level(recipe) == MAX_COOKING_LEVEL
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Get Number of times recipe has been used for debug purposes
  #--------------------------------------------------------------------------
  def debug_recipe_usage(recipe)
    @recipe_usage[recipe.id]
  end
  #--------------------------------------------------------------------------
  # * Returns battle animation 
  #--------------------------------------------------------------------------
  def battle_animations
    self.class.battle_animations
  end
  #--------------------------------------------------------------------------
  # * Returns the battler's walking speed
  #--------------------------------------------------------------------------
  def walk_speed
    self.class.walk_speed
  end
end
