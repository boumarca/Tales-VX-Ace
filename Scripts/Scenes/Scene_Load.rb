#==============================================================================
# ** Scene_Load
#------------------------------------------------------------------------------
#  This class performs load screen processing. 
#==============================================================================

class Scene_Load < Scene_File
  #--------------------------------------------------------------------------
  # * Get File Index to Select First
  #--------------------------------------------------------------------------
  def first_savefile_index
    DataManager.latest_savefile_index
  end
  #--------------------------------------------------------------------------
  # * Confirm Save File
  #--------------------------------------------------------------------------
  def on_savefile_ok
    super
    if DataManager.exists?(@index)
      Sound.play_ok
      call_confirm_window(Vocab::CONFIRM_LOAD, method(:load_file), method(:on_confirm_cancel))
    else
      Sound.play_buzzer
    end
    @savefile_windows[@index].selected = false
  end
  #--------------------------------------------------------------------------
  # * Load File
  #--------------------------------------------------------------------------
  def load_file
    if DataManager.load_game(@index)
      on_load_success
    else
      Sound.play_buzzer
    end
  end
  #--------------------------------------------------------------------------
  # * Processing When Load Is Successful
  #--------------------------------------------------------------------------
  def on_load_success
    fadeout_all
    $game_system.on_after_load
    SceneManager.goto(Scene_Map)
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Create Header Window
  #--------------------------------------------------------------------------
  def create_header_window
    @header_window = Window_MenuHeader.new(Vocab::LOAD)
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Set Control Help 
  #--------------------------------------------------------------------------
  def set_controls_help
    @control_help_window.clear
    set_load_controls  
    @control_help_window.refresh
  end
  #--------------------------------------------------------------------------
  # * Set Controls For Actor Window 
  #--------------------------------------------------------------------------
  def set_load_controls
    @control_help_window.add_control(Vocab::CONFIRM,    :A) 
    @control_help_window.add_control(Vocab::BACK,       :B)
  end
end
