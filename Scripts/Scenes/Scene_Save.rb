#==============================================================================
# ** Scene_Save
#------------------------------------------------------------------------------
#  This class performs save screen processing. 
#==============================================================================

class Scene_Save < Scene_File
  #--------------------------------------------------------------------------
  # * Get File Index to Select First
  #--------------------------------------------------------------------------
  def first_savefile_index
    DataManager.last_savefile_index
  end
  #--------------------------------------------------------------------------
  # * Confirm Save File
  #--------------------------------------------------------------------------
  def on_savefile_ok
    super
    Sound.play_ok
    text = DataManager.exists?(@index) ? Vocab::CONFIRM_SAVE : Vocab::CONFIRM_NEW_FILE
    call_confirm_window(text, method(:save_file), method(:on_confirm_cancel))
    @savefile_windows[@index].selected = false
  end
  #--------------------------------------------------------------------------
  # * Save File
  #--------------------------------------------------------------------------
  def save_file
    if DataManager.save_game(@index)
      on_save_success
    else
      Sound.play_buzzer
    end
  end
  #--------------------------------------------------------------------------
  # * Processing When Save Is Successful
  #--------------------------------------------------------------------------
  def on_save_success
    return_scene
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Create Header Window
  #--------------------------------------------------------------------------
  def create_header_window
    @header_window = Window_MenuHeader.new(Vocab::SAVE)
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Set Control Help 
  #--------------------------------------------------------------------------
  def set_controls_help
    @control_help_window.clear
    set_save_controls  
    @control_help_window.refresh
  end
  #--------------------------------------------------------------------------
  # * Set Controls For Actor Window 
  #--------------------------------------------------------------------------
  def set_save_controls
    @control_help_window.add_control(Vocab::CONFIRM,    :A) 
    @control_help_window.add_control(Vocab::BACK,       :B)
  end
end
