#==============================================================================
# ** New Class
# ** RPG::Recipe
#------------------------------------------------------------------------------
#  The data class for Recipes. Recipes are handled as items for convenience.
#==============================================================================

class RPG::Recipe < RPG::UsableItem
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :ingredients
  attr_accessor :actor_id
  #--------------------------------------------------------------------------
  # * Initialize New Recipe
  #--------------------------------------------------------------------------
  def initialize
    super
    @scope = 8
    @ingredients = []
    @actor_id = 0
  end
  #--------------------------------------------------------------------------
  # * Returns an array containing all required ingredients
  #--------------------------------------------------------------------------
  def required
    @ingredients.select {|item| item.required?}
  end
  #--------------------------------------------------------------------------
  # * Returns an array containing all extra ingredients
  #--------------------------------------------------------------------------
  def extra
    @ingredients.select {|item| item.extra?}
  end
  #--------------------------------------------------------------------------
  # * Returns an array containing all base effects
  #--------------------------------------------------------------------------
  def base_effects
    @effects.select { |effect| effect.base?}
  end
  #--------------------------------------------------------------------------
  # * Returns an array containing all mastery effects
  #--------------------------------------------------------------------------
  def mastery_effects
    @effects.select { |effect| effect.mastery?}
  end
  #--------------------------------------------------------------------------
  # * Returns an array containing all ingredients effects
  #--------------------------------------------------------------------------
  def ingredient_effects
    @effects.select { |effect| effect.ingredient?}
  end
  #--------------------------------------------------------------------------
  # * Returns an array containing all actor effects
  #--------------------------------------------------------------------------
  def actor_effects
    @effects.select { |effect| effect.actor?}
  end
  #==============================================================================
  # ** New Class
  # ** RPG::Recipe::Ingredient
  #------------------------------------------------------------------------------
  #  The data class for Ingredients used in recipe. Ingredients uses the ID of a 
  # RPG::Item for reference.
  #==============================================================================
  class Ingredient
    #--------------------------------------------------------------------------
    # * Public Instance Variables
    #--------------------------------------------------------------------------
    attr_accessor :item_id
    attr_accessor :category_id
    attr_accessor :type
    attr_accessor :level
    attr_accessor :quantity
    #--------------------------------------------------------------------------
    # * Initialize New Recipe
    #--------------------------------------------------------------------------
    def initialize
      @item_id = 0
      @category_id = 0
      @type = 0
      @level = 0
      @quantity = 1
    end
    #--------------------------------------------------------------------------
    # * Determines whether the ingredient is an item. 
    # * Returns true if the value of item_id is not 0.
    #--------------------------------------------------------------------------
    def item?
      @item_id != 0
    end
    #--------------------------------------------------------------------------
    # * Determines whether the ingredient is a category.
    # * Returns true if the value of category_id is not 0.
    #--------------------------------------------------------------------------
    def category?
      @category_id != 0
    end
    #--------------------------------------------------------------------------
    # * Determines whether the ingredient type is [Required]. 
    # * Returns true if the value of type is 0.
    #--------------------------------------------------------------------------
    def required?
      @type == 0
    end
    #--------------------------------------------------------------------------
    # * Determines whether the ingredient type is [Extra]. 
    # * Returns true if the value of type is 1.
    #--------------------------------------------------------------------------
    def extra?
      @type == 1
    end
  end
  
  #==============================================================================
  # ** New Class
  # ** RPG::Recipe::Effect
  #------------------------------------------------------------------------------
  #  The data class for Effects of the recipe. 
  #==============================================================================
  class Effect < RPG::UsableItem::Effect
    #--------------------------------------------------------------------------
    # * Public Instance Variables
    #--------------------------------------------------------------------------
    attr_accessor :type
    #--------------------------------------------------------------------------
    # * Initialize Effect
    #--------------------------------------------------------------------------
    def initialize
      super
      @type = 0
    end
    #--------------------------------------------------------------------------
    # * Determines whether the effectr type is [Base Effect]. 
    # * Returns true if the value of type is 0.
    #--------------------------------------------------------------------------
    def base?
      @type == 0
    end
    #--------------------------------------------------------------------------
    # * Determines whether the effectr type is [Mastery Effect]. 
    # * Returns true if the value of type is 0.
    #--------------------------------------------------------------------------
    def mastery?
      @type == 1
    end
    #--------------------------------------------------------------------------
    # * Determines whether the effectr type is [Ingredient Effect]. 
    # * Returns true if the value of type is 0.
    #--------------------------------------------------------------------------
    def ingredient?
      @type == 2
    end
    #--------------------------------------------------------------------------
    # * Determines whether the effectr type is [Actor Effect]. 
    # * Returns true if the value of type is 0.
    #--------------------------------------------------------------------------
    def actor?
      @type == 3
    end
  end
end

