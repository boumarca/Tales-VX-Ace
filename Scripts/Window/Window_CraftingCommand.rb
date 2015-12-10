#==============================================================================
# ** New Class
# ** Window_CraftingCommand
#------------------------------------------------------------------------------
#  This window is for selecting Crafting submenu commands.
#==============================================================================

class Window_CraftingCommand < Window_SubMenu
  #--------------------------------------------------------------------------
  # * Create Command List
  #--------------------------------------------------------------------------
  def make_command_list
    add_command(Vocab::SYNTHESIS, :synthesis, main_commands_enabled)
    add_command(Vocab::ENHANCE,   :enhance,   main_commands_enabled)
  end
  #--------------------------------------------------------------------------
  # * Get Activation State of Main Commands
  #--------------------------------------------------------------------------
  def main_commands_enabled
    $game_party.exists
  end
end
