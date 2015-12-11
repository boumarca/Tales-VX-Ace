#==============================================================================
# ** Vocab
#------------------------------------------------------------------------------
#  This module defines terms and messages. It defines some data as constant
# variables. Terms in the database are obtained from $data_system.
#==============================================================================

module Vocab

  # Shop Screen
  ShopBuy         = "Buy"
  ShopSell        = "Sell"
  ShopCancel      = "Cancel"
  Possession      = "Possession"

  # Status Screen
  ExpTotal        = "EXP:"
  ExpNext         = "Next:"

  # Save/Load Screen
  SaveMessage     = "Save to which file?"
  LoadMessage     = "Load which file?"
  File            = "File"
  CONFIRM_SAVE    = "Do you want to overwrite the current savefile?"
  CONFIRM_LOAD    = "Do you want to load the current savefile?"
  CONFIRM_NEW_FILE= "Do you want to create a new savefile?"

  # Display when there are multiple members
  PartyName       = "%s's Party"

  # Basic Battle Messages
  Emerge          = "%s emerged!"
  Preemptive      = "%s got the upper hand!"
  Surprise        = "%s was surprised!"
  EscapeStart     = "%s has started to escape!"
  EscapeFailure   = "However, it was unable to escape!"

  # Battle Ending Messages
  Victory         = "%s was victorious!"
  Defeat          = "%s was defeated."
  ObtainExp       = "%s EXP received!"
  ObtainGold      = "%s\\G found!"
  ObtainItem      = "%s found!"
  LevelUp         = "%s is now %s %s!"
  ObtainSkill     = "%s learned!"

  # Use Item
  UseItem         = "%s uses %s!"
  
  #Drop Item
  DropItem        = "Drop %s?"

  # Critical Hit
  CriticalToEnemy = "An excellent hit!!"
  CriticalToActor = "A painful blow!!"

  # Results for Actions on Actors
  ActorDamage     = "%s took %s damage!"
  ActorRecovery   = "%s recovered %s %s!"
  ActorGain       = "%s gained %s %s!"
  ActorLoss       = "%s lost %s %s!"
  ActorDrain      = "%s was drained of %s %s!"
  ActorNoDamage   = "%s took no damage!"
  ActorNoHit      = "Miss! %s took no damage!"

  # Results for Actions on Enemies
  EnemyDamage     = "%s took %s damage!"
  EnemyRecovery   = "%s recovered %s %s!"
  EnemyGain       = "%s gained %s %s!"
  EnemyLoss       = "%s lost %s %s!"
  EnemyDrain      = "Drained %s %s from %s!"
  EnemyNoDamage   = "%s took no damage!"
  EnemyNoHit      = "Missed! %s took no damage!"

  # Evasion/Reflection
  Evasion         = "%s evaded the attack!"
  MagicEvasion    = "%s nullified the magic!"
  MagicReflection = "%s reflected the magic!"
  CounterAttack   = "%s counterattacked!"
  Substitute      = "%s protected %s!"

  # Buff/Debuff
  BuffAdd         = "%s's %s went up!"
  DebuffAdd       = "%s's %s went down!"
  BuffRemove      = "%s's %s returned to normal."

  # Skill or Item Had No Effect
  ActionFailure   = "There was no effect on %s!"

  # Error Message
  PlayerPosError  = "Player's starting position is not set."
  EventOverflow   = "Common event calls exceeded the limit."

  # Basic Status
  def self.basic(basic_id)
    $data_system.terms.basic[basic_id]
  end

  # Parameters
  def self.param(param_id)
    $data_system.terms.params[param_id]
  end

  # Equip Type
  def self.etype(etype_id)
    $data_system.terms.etypes[etype_id]
  end

  # Commands
  def self.command(command_id)
    $data_system.terms.commands[command_id]
  end

  # Currency Unit
  def self.currency_unit
    $data_system.currency_unit
  end
  
  #Item Use
  ITEM_USE    = "Utiliser sur qui?"
  ITEM_EQUIP  = "Équiper sur qui?"
  ITEM_DROP   = "Voulez-vous jeter \\C[1]%s\\C[0]?"
  
  #ATTRIBUTES PARAMS
  AATR = "A.Atr"
  DATR = "D.Atr"

  #Menu Commands
  SKILLS                = "Artes"
  CAPACITIES            = "Skills"
  EQUIP                 = "Equipment"
  LEARNING              = "Growth"
  LIBRAIRIES            = "Librairies"
  SYNOPSIS              = "Synopsis"
  WORLD_MAP             = "World Map"
  MONSTER_LIST          = "Monster List"
  COLLECTOR_BOOK        = "Collector Book"
  ITEM                  = "Items"
  CRAFTING              = "Crafting"
  SYNTHESIS             = "Synthesis"
  ENHANCE               = "Enhance"
  STRATEGY              = "Strategies"
  COOKING               = "Cooking"
  SYSTEM                = "System"
  SAVE                  = "Save"
  LOAD                  = "Load"
  OPTIONS               = "Options"
  TITLE_SCREEN          = "Title Screen"
  STATUS                = "Status"
  
  #Main Menu
  PLAYTIME              = "Playtime"
  ENCOUNTER             = "Encounters"
  GRADE                 = "Grade"
  COMBO                 = "Combo"
  LOCATION              = "Location"
  SAVE_TIME             = "Last Save" 
  
  #Controls
  MANUAL                = "Manual"
  SEMI_AUTO             = "Semi-Auto"
  AUTO                  = "Auto"
  
  #Skills
  SKILL_ON              = "[ON]"
  SKILL_OFF             = "[OFF]"
  SKILL_USAGE           = "Usage"
  MP_COST               = "TP Cost"
  SP_COST               = "SP Cost"
  SP                    = "SP"
  SHORTCUTS             = "Shortcuts"
  
  #Cooking
  ACTOR_COOK            = "Cook"
  RECIPE                = "Recipe"
  REQUIRED_INGREDIENTS  = "Required Ingredients"
  EXTRA_INGREDIENTS     = "Extra Ingredients"
  PARTY_FULL            = "The party is full!"
  INGREDIENTS_ERROR     = "You don't have all the ingredients!"
  COOKING_SUCCESS       = "%s successfully cooked :"
  COOKING_FAILURE       = "%s has failed in cooking:" 
  COOKING_EFFECT        = "Effects"
  COOKING_INGREDIENTS   = "Ingredients"
  COOKING_RECOVERY      = "%s +%s%%"
  COOKING_BUFF          = "%s increased"
  COOKING_DEBUFF        = "%s decreased"
  COOKING_ADD_STATE     = "%s inflicted"
  COOKING_REMOVE_STATE  = "%s recovered"
  
  #Synthesis
  MATERIALS             = "Required Materials"
  MATERIAL_ERROR        = "You don't have all the materials!"
  INVENTORY_FULL        = "You can't carry anymore %s"
  CONFIRM_CRAFT         = "Craft %s?"
  
  #Yes/No
  YES                   = "Yes"
  NO                    = "No"
  
  #Controls Help
  CONFIRM               = "Confirm"
  BACK                  = "Back"
  LEADER                = "Set leader"
  SWAP                  = "Swap"
  CHANGE_ACTOR          = "Change member"
  CHANGE_CONTROL_MODE   = "Mode"
  CHANGE_CATEGORY       = "Category"
  TOGGLE                = "On/Off"
  USE                   = "Use"
  DESCRIPTION           = "Description"
  REMOVE                = "Remove"
  REMOVE_ALL            = "Remove all"  
  DROP                  = "Drop"
  OPTIMIZE              = "Optimize"
  MODIFY                = "Modify" 
  DONE                  = "Done"
  ERASE                 = "Erase"
  COOK                  = "Cook"
  
  #--------------------------------------------------------------------------
  def self.level;       basic(0);     end   # Level
  def self.level_a;     basic(1);     end   # Level (short)
  def self.hp;          basic(2);     end   # HP
  def self.hp_a;        basic(3);     end   # HP (short)
  def self.mp;          basic(4);     end   # MP
  def self.mp_a;        basic(5);     end   # MP (short)
  def self.tp;          basic(6);     end   # TP
  def self.tp_a;        basic(7);     end   # TP (short)
  def self.fight;       command(0);   end   # Fight
  def self.escape;      command(1);   end   # Escape
  def self.attack;      command(2);   end   # Attack
  def self.guard;       command(3);   end   # Guard
  def self.item;        command(4);   end   # Items
  def self.skill;       command(5);   end   # Skills
  def self.equip;       command(6);   end   # Equip
  def self.status;      command(7);   end   # Status
  def self.formation;   command(8);   end   # Change Formation
  def self.save;        command(9);   end   # Save
  def self.game_end;    command(10);  end   # Exit Game
  def self.weapon;      command(12);  end   # Weapons
  def self.armor;       command(13);  end   # Armor
  def self.key_item;    command(14);  end   # Key Items
  def self.equip2;      command(15);  end   # Change Equipment
  def self.optimize;    command(16);  end   # Ultimate Equipment
  def self.clear;       command(17);  end   # Remove All
  def self.new_game;    command(18);  end   # New Game
  def self.continue;    command(19);  end   # Continue
  def self.shutdown;    command(20);  end   # Shut Down
  def self.to_title;    command(21);  end   # Go to Title
  def self.cancel;      command(22);  end   # Cancel
  #--------------------------------------------------------------------------
end
