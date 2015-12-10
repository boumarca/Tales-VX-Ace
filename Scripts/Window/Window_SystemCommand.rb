#==============================================================================
# ** New Class
# ** Window_SystemCommand
#------------------------------------------------------------------------------
#  This windows is for selecting System submenu commands.
#==============================================================================

class Window_SystemCommand < Window_SubMenu
  #--------------------------------------------------------------------------
  # * Create Command List
  #--------------------------------------------------------------------------
  def make_command_list
    add_command(Vocab::SAVE,          :save,          save_enabled)
    add_command(Vocab::LOAD,          :load,          load_enabled)
    add_command(Vocab::OPTIONS,       :options)
    add_command(Vocab::TITLE_SCREEN,  :title_screen)
  end
  #--------------------------------------------------------------------------
  # * Get Activation State of Save
  #--------------------------------------------------------------------------
  def save_enabled
    !$game_system.save_disabled
  end
  #--------------------------------------------------------------------------
  # * Get Activation State of Continue
  #--------------------------------------------------------------------------
  def load_enabled
    DataManager.save_file_exists?
  end
end
