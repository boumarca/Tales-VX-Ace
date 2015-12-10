#==============================================================================
# ** New Class
# ** Scene_Synthesis**
#------------------------------------------------------------------------------
#  This class performs the item synthesis screen processing.
#==============================================================================

class Scene_Synthesis < Scene_ItemBase
  #--------------------------------------------------------------------------
  # * Constants (Positions)
  #--------------------------------------------------------------------------
  ITEM_WINDOW_X     = 16
  ITEM_WINDOW_Y     = 52
  CATEGORY_WINDOW_X = 420
  CATEGORY_WINDOW_Y = 16
  LEVEL_WINDOW_X    = 320
  LEVEL_WINDOW_Y    = 52
  MATERIAL_WINDOW_X = 320
  MATERIAL_WINDOW_Y = 100
  HELP_WINDOW_X     = 16
  HELP_WINDOW_Y     = 340
  RESULT_WINDOW_X   = 96
  RESULT_WINDOW_Y   = 52
  #--------------------------------------------------------------------------
  # * Start Processing
  #--------------------------------------------------------------------------
  def start
    super
    create_header_window(Vocab::SYNTHESIS)
    create_help_window
    create_category_window
    create_material_window
    create_item_window    
    create_level_window    
    set_controls_help
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Create Help Window
  #--------------------------------------------------------------------------
  def create_help_window
    @help_window = Window_ItemHelp.new(HELP_WINDOW_X, HELP_WINDOW_Y)
  end
  #--------------------------------------------------------------------------
  # * Create Item Window
  #--------------------------------------------------------------------------
  def create_item_window
    @item_window = Window_SynthesisItemList.new(ITEM_WINDOW_X, ITEM_WINDOW_Y)
    @item_window.help_window = @help_window
    @item_window.set_handler(:ok,       method(:on_item_ok))
    @item_window.set_handler(:cancel,   method(:return_scene))
    @item_window.set_handler(:up,       method(:category_return))
    @item_window.set_handler(:start,    method(:on_toggle_help))
    @item_window.set_handler(:pagedown, method(:next_category))
    @item_window.set_handler(:pageup,   method(:prev_category))
    @category_window.item_window = @item_window
    @item_window.materials_window = @material_window
    @item_window.activate
    @item_window.select(0)
  end
  #--------------------------------------------------------------------------
  # * Create Category Window
  #--------------------------------------------------------------------------
  def create_category_window
    @category_window = Window_SynthesisCategory.new(CATEGORY_WINDOW_X, CATEGORY_WINDOW_Y)
    @category_window.set_handler(:ok,       method(:on_category_ok))
    @category_window.set_handler(:cancel,   method(:return_scene))
    @category_window.set_handler(:down,     method(:on_category_ok))
    @category_window.set_handler(:pagedown, method(:next_category))
    @category_window.set_handler(:pageup,   method(:prev_category))
    @category_window.help_window = @help_window
  end
  #--------------------------------------------------------------------------
  # * Create Level Window
  #--------------------------------------------------------------------------
  def create_level_window
    @level_window = Window_SynthesisLevel.new(LEVEL_WINDOW_X, LEVEL_WINDOW_Y)
  end
  #--------------------------------------------------------------------------
  # * Create Material Window
  #--------------------------------------------------------------------------
  def create_material_window
    @material_window = Window_SynthesisMaterial.new(MATERIAL_WINDOW_X, MATERIAL_WINDOW_Y)    
  end
  #--------------------------------------------------------------------------
  # * Item [OK]
  #--------------------------------------------------------------------------
  def on_item_ok
    synthesize_item(@item_window.item)
  end
  #--------------------------------------------------------------------------
  # * Item [Up]
  #--------------------------------------------------------------------------
  def category_return
    @item_window.unselect
    @category_window.activate
    set_controls_help
  end
  #--------------------------------------------------------------------------
  # * Item [Start] : Toggle Description
  #--------------------------------------------------------------------------
  def on_toggle_help
    @help_window.toggle_text
  end
  #--------------------------------------------------------------------------
  # * Category [OK]
  #--------------------------------------------------------------------------
  def on_category_ok
    @item_window.activate.select(0)
    set_controls_help
  end
  #--------------------------------------------------------------------------
  # * Change to next category
  #--------------------------------------------------------------------------
  def next_category
    @category_window.cursor_right
    @item_window.select(0) if @item_window.active
  end
  #--------------------------------------------------------------------------
  # * Change to previous category
  #--------------------------------------------------------------------------
  def prev_category
    @category_window.cursor_left
    @item_window.select(0) if @item_window.active
  end
  #--------------------------------------------------------------------------
  # * Synthesize Process
  #--------------------------------------------------------------------------
  def synthesize_item(item)
    if item.nil?
      Sound.play_buzzer
      return
    else
      @item_window.deactivate
      if !$game_party.item_max?(item)
        SynthesisManager.reset      
        SynthesisManager.item = item
        if SynthesisManager.synthesizable?(item)
          Sound.play_use_item
          SynthesisManager.make_item
          #display_results
          @item_window.refresh
          @material_window.refresh
          @level_window.refresh
          @item_window.activate
        else
          Sound.play_buzzer
          @system_window = Window_SystemMessage.new(Vocab::MATERIAL_ERROR)
          @system_window.change_context(@item_window)
        end 
      else
        Sound.play_buzzer
        @system_window = Window_SystemMessage.new(sprintf(Vocab::INVENTORY_FULL, item.name))
        @system_window.change_context(@item_window)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Display Results
  #--------------------------------------------------------------------------
  def display_results
    @results_window = Window_SynthesisResults.new(RESULT_WINDOW_X, RESULT_WINDOW_Y)
    @results_window.change_context(@item_window)  
  end
  #--------------------------------------------------------------------------
  # * Set Control Help 
  #--------------------------------------------------------------------------
  def set_controls_help
    @control_help_window.clear
    set_category_controls if @category_window.active
    set_item_controls     if @item_window.active
    @control_help_window.refresh
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Set Controls For Category Window 
  #--------------------------------------------------------------------------
  def set_category_controls
    @control_help_window.add_control(Vocab::ITEM,             :A) 
    @control_help_window.add_control(Vocab::BACK,             :B)
    @control_help_window.add_control(Vocab::CHANGE_CATEGORY,  :L, :R)
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Set Controls For Item Window 
  #--------------------------------------------------------------------------
  def set_item_controls
    @control_help_window.add_control(Vocab::CONFIRM,          :A) 
    @control_help_window.add_control(Vocab::BACK,             :B)
    @control_help_window.add_control(Vocab::CHANGE_CATEGORY,  :L, :R)
    @control_help_window.add_control(Vocab::DESCRIPTION,      :C)
  end
end