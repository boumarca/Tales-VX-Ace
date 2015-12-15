#==============================================================================
# ** New Class
# ** Window_RecipeResults
#------------------------------------------------------------------------------
#  This window displays the results of cooking.
#==============================================================================

class Window_RecipeResults < Window_Modal
  #--------------------------------------------------------------------------
  # * Constants (Positions)
  #--------------------------------------------------------------------------
  WINDOW_WIDTH  = 448
  TITLE_X       = 96
  ROW_X         = 228
  RECT_WIDTH    = 196
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y)
    super(x, y, window_width, window_height) 
    self.y  += (max_height - window_height) / 2
    show
    draw_results
  end
  #--------------------------------------------------------------------------
  # * Get Window Width
  #--------------------------------------------------------------------------
  def window_width
    return WINDOW_WIDTH
  end
  #--------------------------------------------------------------------------
  # * Get Window Height
  #--------------------------------------------------------------------------
  def window_height
    height = 5 + (CookingManager.effects.size + 1) / 2 + (CookingManager.ingredients.size + 1) / 2
    fitting_height(height)
  end  
  #--------------------------------------------------------------------------
  # * Get Max Height
  #--------------------------------------------------------------------------
  def max_height
    fitting_height(11)
  end  
  #--------------------------------------------------------------------------
  # * Override
  # * Create Continue Arrow
  #--------------------------------------------------------------------------
  def create_arrow
    super
    @down_arrow.y += (max_height - window_height) / 2
  end
  #--------------------------------------------------------------------------
  # * Draw Results
  #--------------------------------------------------------------------------
  def draw_results
    draw_recipe_image
    draw_recipe_info
    draw_effects
    draw_ingredients
  end
  #--------------------------------------------------------------------------
  # * Draw Recipe Image
  #--------------------------------------------------------------------------
  def draw_recipe_image
    bitmap = Cache.picture("sandwich")
    rect = Rect.new(0, 0, 32, 32)
    dest_rect = Rect.new(0, 0, 72, 72)
    contents.stretch_blt(dest_rect, bitmap, rect) 
    bitmap.dispose
  end
  #--------------------------------------------------------------------------
  # * Draw Success/Failure message
  #--------------------------------------------------------------------------
  def draw_recipe_info
    str = sprintf(Vocab::COOKING_SUCCESS, $game_cooking.cook.name) if(CookingManager.success?)
    str = sprintf(Vocab::COOKING_FAILURE, $game_cooking.cook.name) if(!CookingManager.success?)
    draw_text(TITLE_X, 0, contents.width, line_height, str)
    draw_text(0, line_height, contents.width, line_height, $game_cooking.recipe.name, Bitmap::ALIGN_CENTER)    
  end
  #--------------------------------------------------------------------------
  # * Draw Effects
  #--------------------------------------------------------------------------
  def draw_effects
    draw_text(0, line_height * 3, contents.width, line_height, Vocab::COOKING_EFFECT, Bitmap::ALIGN_CENTER)
    CookingManager.effects.each_index { |i|
      effect = CookingManager.effects[i]
      str = effect_text(effect)
      x = ROW_X * (i % 2)
      y = line_height * (3 + (CookingManager.effects.size + 1) / 2)
      draw_text(x, y, RECT_WIDTH, line_height, str, Bitmap::ALIGN_CENTER)
    }
  end
  #--------------------------------------------------------------------------
  # * Get Effect Text
  #--------------------------------------------------------------------------
  def effect_text(effect)
    case effect.code
    when Game_Battler::EFFECT_RECOVER_HP
      sprintf(Vocab::COOKING_RECOVERY, Vocab.hp, (effect.value1 * 100).to_i)
    when Game_Battler::EFFECT_RECOVER_MP
      sprintf(Vocab::COOKING_RECOVERY, Vocab.mp, (effect.value1 * 100).to_i)
    when Game_Battler::EFFECT_ADD_STATE
      sprintf(Vocab::COOKING_ADD_STATE, $data_states[effect.data_id].name)
    when Game_Battler::EFFECT_REMOVE_STATE
      sprintf(Vocab::COOKING_REMOVE_STATE, $data_states[effect.data_id].name)
    when Game_Battler::EFFECT_ADD_BUFF
      sprintf(Vocab::COOKING_BUFF, Vocab.param(effect.data_id))
    when Game_Battler::EFFECT_ADD_DEBUFF
      sprintf(Vocab::COOKING_DEBUFF, Vocab.param(effect.data_id))
    end
  end
  #--------------------------------------------------------------------------
  # * Draw Ingredients
  #--------------------------------------------------------------------------
  def draw_ingredients
    y = line_height * (4 + (CookingManager.effects.size + 1) / 2)
    draw_text(0, y, contents.width, line_height, Vocab::COOKING_INGREDIENTS, Bitmap::ALIGN_CENTER)
    ingredients_uniq = CookingManager.ingredients.uniq
    ingredients_uniq.each_index { |i|
      item = ingredients_uniq[i]
      x = ROW_X * (i % 2)
      item_y = y + line_height * (i/2 + 1)
      qty = CookingManager.ingredients.find_all { |other| other.id == item.id }
      draw_item_name(item, x, item_y, true, RECT_WIDTH)
      draw_text(x, item_y, RECT_WIDTH, line_height, sprintf("x%2d", qty.size), Bitmap::ALIGN_RIGHT)
    }    
  end  
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_results
  end
end