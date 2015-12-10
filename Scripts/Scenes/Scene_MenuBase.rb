#==============================================================================
# ** Scene_MenuBase
#------------------------------------------------------------------------------
#  This class performs basic processing related to the menu screen.
#==============================================================================

class Scene_MenuBase < Scene_Base
  #--------------------------------------------------------------------------
  # * Constants (Positions)
  #--------------------------------------------------------------------------
  CONTROLS_X          = 16
  CONTROLS_Y          = 460
  #--------------------------------------------------------------------------
  # * Start Processing
  #--------------------------------------------------------------------------
  def start
    super
    create_background
    @actor = $game_party.menu_actor
    create_control_help_window
  end
  #--------------------------------------------------------------------------
  # * Termination Processing
  #--------------------------------------------------------------------------
  def terminate
    super
    dispose_background
  end
  #--------------------------------------------------------------------------
  # * Create Background
  #--------------------------------------------------------------------------
  def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = SceneManager.background_bitmap
    @background_sprite.color.set(16, 16, 16, 128)
  end
  #--------------------------------------------------------------------------
  # * Free Background
  #--------------------------------------------------------------------------
  def dispose_background
    @background_sprite.dispose
  end
  #--------------------------------------------------------------------------
  # * Create Help Window
  #--------------------------------------------------------------------------
  def create_help_window
    @help_window = Window_Help.new
    @help_window.viewport = @viewport
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Create Controls Help
  #--------------------------------------------------------------------------
  def create_control_help_window
    @control_help_window = Window_ControlsHelp.new(CONTROLS_X, CONTROLS_Y)
  end
  #--------------------------------------------------------------------------
  # * Switch to Next Actor
  #--------------------------------------------------------------------------
  def next_actor
    @actor = $game_party.menu_actor_next
    on_actor_change
  end
  #--------------------------------------------------------------------------
  # * Switch to Previous Actor
  #--------------------------------------------------------------------------
  def prev_actor
    @actor = $game_party.menu_actor_prev
    on_actor_change
  end
  #--------------------------------------------------------------------------
  # * Change Actors
  #--------------------------------------------------------------------------
  def on_actor_change
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Create Header Window
  #--------------------------------------------------------------------------
  def create_header_window(text)
    @header_window = Window_MenuHeader.new(text)
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Set Control Help 
  #--------------------------------------------------------------------------
  def set_controls_help
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Call Confirm Window
  #--------------------------------------------------------------------------
  def call_confirm_window(message, on_ok, on_cancel, context = nil)
    @system_window = Window_SystemChoice.new(message)
    @system_window.set_handler(:ok, on_ok)
    @system_window.set_handler(:cancel, on_cancel)
    @system_window.change_context(context)    
  end
end
