#==============================================================================
# ** New Class
# ** Scene_Cooking
#------------------------------------------------------------------------------
#  This class performs cookng screen processing. Recipes are handled as 
# items for the sake of process sharing.
#==============================================================================

class Scene_Cooking < Scene_ItemBase
  #--------------------------------------------------------------------------
  # * Constants (Positions)
  #--------------------------------------------------------------------------
  HELP_WINDOW_X         = 16
  HELP_WINDOW_Y         = 340
  COOKING_WINDOW_X      = 16
  COOKING_WINDOW_Y      = 52
  ACTOR_WINDOW_X        = 320
  ACTOR_WINDOW_Y        = 52
  RECIPE_WINDOW_X       = 320
  RECIPE_WINDOW_Y       = 52
  RESULT_WINDOW_X       = 96
  RESULT_WINDOW_Y       = 52
  INGREDIENTS_WINDOW_X  = 16
  INGREDIENTS_WINDOW_Y  = 124
  SHORTCUT_WINDOW_X     = 16
  SHORTCUT_WINDOW_Y     = 124
  #--------------------------------------------------------------------------
  # * Modified
  # * Start Processing
  #--------------------------------------------------------------------------
  def start
    super
    create_header_window(Vocab::COOKING)
    create_help_window
    create_cooking_window
    create_ingredients_window
    create_recipe_window
    create_shortcut_window
    set_controls_help
  end
  #--------------------------------------------------------------------------
  # * Create Cooking Window
  #--------------------------------------------------------------------------
  def create_cooking_window
    @cooking_window = Window_Cooking.new(COOKING_WINDOW_X, COOKING_WINDOW_Y)
    @cooking_window.set_handler(:actor,  method(:select_actor))
    @cooking_window.set_handler(:recipe, method(:select_recipe))
    @cooking_window.set_handler(:cancel, method(:return_scene))
    @cooking_window.set_handler(:y,      method(:cook_recipe))
    @cooking_window.set_handler(:down,   method(:select_shortcuts))
    @cooking_window.set_handler(:select, method(:select_shortcuts))
    @cooking_window.help_window = @help_window
    @cooking_window.actor = $game_cooking.cook
    @cooking_window.recipe = $game_cooking.recipe
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Create Help Window
  #--------------------------------------------------------------------------
  def create_help_window
    @help_window = Window_RecipeHelp.new(HELP_WINDOW_X, HELP_WINDOW_Y)
  end
  #--------------------------------------------------------------------------
  # * Create Actor Window
  #--------------------------------------------------------------------------
  def create_actor_window
    @actor_window = Window_ActorCooking.new(ACTOR_WINDOW_X, ACTOR_WINDOW_Y)
    @actor_window.set_handler(:ok,      method(:on_cook_ok))
    @actor_window.set_handler(:cancel,  method(:on_cook_cancel))
    @actor_window.recipe = $game_cooking.recipe
  end
  #--------------------------------------------------------------------------
  # * Create Ingredients Window
  #--------------------------------------------------------------------------
  def create_ingredients_window
    @ingredients_window = Window_Ingredients.new(INGREDIENTS_WINDOW_X, INGREDIENTS_WINDOW_Y)
    @ingredients_window.recipe = $game_cooking.recipe
    @ingredients_window.mastery_level = $game_cooking.cook.mastery_level($game_cooking.recipe)
    @actor_window.ingredient_window = @ingredients_window
  end
  #--------------------------------------------------------------------------
  # * Create Recipe Windows
  #--------------------------------------------------------------------------
  def create_recipe_window
    @recipe_window = Window_RecipeList.new(RECIPE_WINDOW_X, RECIPE_WINDOW_Y)
    @recipe_window.set_handler(:ok,     method(:on_recipe_ok))
    @recipe_window.set_handler(:cancel, method(:on_recipe_cancel))
    @recipe_window.help_window = @help_window
    @recipe_window.ingredient_window = @ingredients_window
    @recipe_window.hide
  end
  #--------------------------------------------------------------------------
  # * Create Shortcut Windows
  #--------------------------------------------------------------------------
  def create_shortcut_window
    @shortcut_window = Window_CookingShortcuts.new(SHORTCUT_WINDOW_X, SHORTCUT_WINDOW_Y)
    @shortcut_window.set_handler(:ok,     method(:on_shortcut_ok))
    @shortcut_window.set_handler(:cancel, method(:on_shortcut_cancel))
    @shortcut_window.set_handler(:up, method(:on_shortcut_cancel))
    @shortcut_window.help_window = @help_window
    @shortcut_window.hide
  end
  #--------------------------------------------------------------------------
  # * Change Cooking Actor 
  #--------------------------------------------------------------------------
  def select_actor
    @cooking_window.deactivate
    @actor_window.activate.select_last
    set_controls_help
  end
  #--------------------------------------------------------------------------
  # * Change Current Recipe
  #--------------------------------------------------------------------------
  def select_recipe
    @cooking_window.deactivate
    @recipe_window.show.activate.select_last
    set_controls_help
  end
  #--------------------------------------------------------------------------
  # * Change Recipe Shortcuts
  #--------------------------------------------------------------------------
  def select_shortcuts
    @cooking_window.deactivate.unselect
    @shortcut_window.show.activate.select(0)
    set_controls_help
  end
  #--------------------------------------------------------------------------
  # * Actor Cook [OK]
  #--------------------------------------------------------------------------
  def on_cook_ok
    if @shortcut_selection
      @actor_window.deactivate
      @recipe_window.show.activate.select(0)
    else
      $game_cooking.cook = $game_party.members[@actor_window.index]
      @cooking_window.actor = $game_cooking.cook
      @cooking_window.activate
      @actor_window.deactivate.unselect      
    end
    @ingredients_window.mastery_level = $game_cooking.cook.mastery_level($game_cooking.recipe)
    set_controls_help
  end
  #--------------------------------------------------------------------------
  # * Actor Cook [Cancel]
  #--------------------------------------------------------------------------
  def on_cook_cancel
    if @shortcut_selection
      @shortcut_window.activate
      @shortcut_selection = false
    else
      @cooking_window.activate      
    end
    @actor_window.deactivate.unselect
    @ingredients_window.mastery_level = $game_cooking.cook.mastery_level($game_cooking.recipe)
    set_controls_help
  end
  #--------------------------------------------------------------------------
  # * Recipe List [OK]
  #--------------------------------------------------------------------------
  def on_recipe_ok
    if @shortcut_selection
      @shortcut_window.activate
      @shortcut_selection = false
      $game_cooking.change_shortcut(@shortcut_window.index, $game_party.members[@actor_window.index], $game_cooking.recipes[@recipe_window.index])
      @actor_window.unselect
      @shortcut_window.activate
      @shortcut_window.refresh
    else
      $game_cooking.recipe = $game_cooking.recipes[@recipe_window.index]
      @cooking_window.recipe = $game_cooking.recipe
      @ingredients_window.recipe = $game_cooking.recipe
      @actor_window.recipe = $game_cooking.recipe
      @cooking_window.activate
    end
    @recipe_window.hide.deactivate.unselect
    set_controls_help
  end
  #--------------------------------------------------------------------------
  # * Recipe List [Cancel]
  #--------------------------------------------------------------------------
  def on_recipe_cancel
    if @shortcut_selection
      @actor_window.activate
      @help_window.clear    
    else      
      @cooking_window.activate
    end
    @recipe_window.hide.deactivate.unselect
    set_controls_help
  end
  #--------------------------------------------------------------------------
  # * Shortcut Window [Ok]
  #--------------------------------------------------------------------------
  def on_shortcut_ok
    @shortcut_selection = true
    @actor_window.activate.select_last
    @help_window.clear  
    set_controls_help
  end
  #--------------------------------------------------------------------------
  # * Shortcut List [Cancel]
  #--------------------------------------------------------------------------
  def on_shortcut_cancel
    @shortcut_window.hide.deactivate.unselect
    @cooking_window.activate.select(1)
    @ingredients_window.mastery_level = $game_cooking.cook.mastery_level($game_cooking.recipe)
    set_controls_help
  end
  #--------------------------------------------------------------------------
  # * Cooking Process
  #--------------------------------------------------------------------------
  def cook_recipe
    if $game_cooking.recipe.nil?
      Sound.play_buzzer
      return
    else
      @cooking_window.deactivate
      CookingManager.reset
      if $game_cooking.hungry
        CookingManager.recipe = $game_cooking.recipe
        CookingManager.cook = $game_cooking.cook
        if CookingManager.recipe_cookable?
          Sound.play_recovery
          CookingManager.cook_recipe
          display_results
          @ingredients_window.mastery_level = $game_cooking.cook.mastery_level($game_cooking.recipe)
          @ingredients_window.refresh
          @actor_window.refresh
        else
          Sound.play_buzzer
          @system_window = Window_SystemMessage.new(Vocab::INGREDIENTS_ERROR)
          @system_window.change_context(@cooking_window)
        end
      else
        Sound.play_buzzer
        @system_window = Window_SystemMessage.new(Vocab::PARTY_FULL)
        @system_window.change_context(@cooking_window)
      end     
    end
  end
  #--------------------------------------------------------------------------
  # * Display Results
  #--------------------------------------------------------------------------
  def display_results
    @results_window = Window_RecipeResults.new(RESULT_WINDOW_X, RESULT_WINDOW_Y)
    @results_window.change_context(@cooking_window)  
  end
  #--------------------------------------------------------------------------
  # * Set Control Help 
  #--------------------------------------------------------------------------
  def set_controls_help
    @control_help_window.clear
    set_cooking_controls   if @cooking_window.active
    set_actor_controls     if @actor_window.active
    set_recipe_controls    if @recipe_window.active
    set_shortcut_controls  if @shortcut_window.active
    @control_help_window.refresh
  end
  #--------------------------------------------------------------------------
  # * Set Controls For Cooking Window 
  #--------------------------------------------------------------------------
  def set_cooking_controls
    @control_help_window.add_control(Vocab::CONFIRM,    Input::Keys::A) 
    @control_help_window.add_control(Vocab::BACK,       Input::Keys::B)
    @control_help_window.add_control(Vocab::COOK,       Input::Keys::Y)
    @control_help_window.add_control(Vocab::SHORTCUTS,  Input::Keys::SELECT)
  end
  #--------------------------------------------------------------------------
  # * Set Controls For Actor Window 
  #--------------------------------------------------------------------------
  def set_actor_controls
    @control_help_window.add_control(Vocab::CONFIRM,    Input::Keys::A) 
    @control_help_window.add_control(Vocab::BACK,       Input::Keys::B)
  end
  #--------------------------------------------------------------------------
  # * Set Controls For Recipe Window 
  #--------------------------------------------------------------------------
  def set_recipe_controls
    @control_help_window.add_control(Vocab::CONFIRM,    Input::Keys::A) 
    @control_help_window.add_control(Vocab::BACK,       Input::Keys::B)
  end
  #--------------------------------------------------------------------------
  # * Set Controls For Recipe Window 
  #--------------------------------------------------------------------------
  def set_shortcut_controls
    @control_help_window.add_control(Vocab::CONFIRM,    Input::Keys::A) 
    @control_help_window.add_control(Vocab::BACK,       Input::Keys::B)
  end
end