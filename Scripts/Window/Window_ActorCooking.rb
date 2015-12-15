#==============================================================================
# ** New Class
# ** Window_ActorCook
#------------------------------------------------------------------------------
#  This window is for selecting actor that will be the cook of the recipe.
#==============================================================================

class Window_ActorCooking < Window_MenuActor
  #--------------------------------------------------------------------------
  # * Constants
  #--------------------------------------------------------------------------
  MASTERY_ICON  = 125
  ICON_SIZE     = 24
  BEST_ACTOR_INDEX = 1
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y)
    super(x, y)
    @recipe = nil
  end
  #--------------------------------------------------------------------------
  # * Set Ingredients Window
  #--------------------------------------------------------------------------
  def ingredient_window=(window)
    @ingredient_window = window
  end
  #--------------------------------------------------------------------------
  # * Override
  #--------------------------------------------------------------------------
  def index=(index)
    super(index)
    @ingredient_window.mastery_level = $game_party.members[index].mastery_level(@recipe)
    @ingredient_window.refresh
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Get Window Height
  #--------------------------------------------------------------------------
  def window_height
    fitting_height(11)
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Processing When OK Button Is Pressed
  #--------------------------------------------------------------------------
  def process_ok
    Sound.play_ok
    super
  end
   #--------------------------------------------------------------------------
  # * Override
  # * Restore Previous Selection Position
  #--------------------------------------------------------------------------
  def select_last
    select($game_party.members.index($game_cooking.cook) || 0)
  end
  #--------------------------------------------------------------------------
  # * Set Recipe
  #--------------------------------------------------------------------------
  def recipe=(recipe)
    return if @recipe == recipe
    @recipe = recipe
    refresh
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_all_items
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Get Rectangle for Drawing Items
  #--------------------------------------------------------------------------
  def item_rect(index)
    rect = super
    rect.y = index / col_max * (item_height + standard_padding)
    rect
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Draw Item
  #--------------------------------------------------------------------------
  def draw_item(index)
    current_actor = $game_party.members[index]
    rect = item_rect(index)
    if(!@recipe.nil? && current_actor.id == @recipe.actor_id)
      draw_best_actor_face(current_actor, rect.x, rect.y)
    else
      draw_actor_face(current_actor, rect.x, rect.y)
    end
    draw_actor_icons(current_actor, rect.x, rect.y)
    draw_actor_simple_status(current_actor, rect.x, rect.y + line_height * 3)
    draw_mastery_level(current_actor, rect.x, rect.y + line_height * 2)
  end
  #--------------------------------------------------------------------------
  # * Draw Mastery Level
  #--------------------------------------------------------------------------
  def draw_mastery_level(actor, x, y)
    return unless @recipe
    level = actor.mastery_level(@recipe)
    return if level == 0 
    for i in 1..level
      draw_icon(MASTERY_ICON, x + ICON_SIZE * (i - 1), y)
    end
  end
  #--------------------------------------------------------------------------
  # * Draw Actor Face Graphic
  #--------------------------------------------------------------------------
  def draw_best_actor_face(actor, x, y, enabled = true)
    draw_face(actor.face_name, BEST_ACTOR_INDEX, x, y, enabled)
  end
end