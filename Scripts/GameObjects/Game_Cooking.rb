#==============================================================================
# ** New Class
# ** Game_Cooking
#------------------------------------------------------------------------------
#  This class handles cooking. Information such as the recipes learned is included.
#  Instances of this class are referenced by $game_cooking.
#==============================================================================

class Game_Cooking
  #--------------------------------------------------------------------------
  # * Constants
  #--------------------------------------------------------------------------
  SHORTCUT_SLOTS            = 4           # Number of Cooking Shortcuts
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :hungry                   # party's hunger status
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    @cook_id = 0
    @recipe_id = 0
    @hungry = true
    @recipes = []
    @cooking_shortcuts = []
    init_cooking_shortcuts
  end
  #--------------------------------------------------------------------------
  # * Init Cooking Shortcuts
  #--------------------------------------------------------------------------
  def init_cooking_shortcuts
    @cooking_shortcuts = Array.new(SHORTCUT_SLOTS) { Game_CookingShortcut.new }
  end
  #--------------------------------------------------------------------------
  # * Get Cook
  #--------------------------------------------------------------------------
  def cook
    $game_actors[@cook_id] || $game_party.members[0]
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
  # * Shortcuts
  #--------------------------------------------------------------------------
  def cooking_shortcuts
    @cooking_shortcuts
  end 
  #--------------------------------------------------------------------------
  # * Remove Cooking References To This Actor
  #--------------------------------------------------------------------------
  def remove_cooking_references(actor_id)
    @cook_id = all_members[0].id if @cook_id == actor_id
    @cooking_shortcuts.each { |shortcut|
      next if shortcut.empty?
      shortcut.clear if shortcut.actor.id == actor_id
    }
  end
end