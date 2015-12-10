#==============================================================================
# ** New Class
# ** Window_LibrairiesCommand
#------------------------------------------------------------------------------
#  This window is for selecting Librairies submenu commands.
#==============================================================================

class Window_LibrairiesCommand < Window_SubMenu
  #--------------------------------------------------------------------------
  # * Create Command List
  #--------------------------------------------------------------------------
  def make_command_list
    add_command(Vocab::SYNOPSIS,        :synopsis,        main_commands_enabled)
    add_command(Vocab::WORLD_MAP,       :world_map,       main_commands_enabled)
    add_command(Vocab::MONSTER_LIST,    :monster_list,    main_commands_enabled)
    add_command(Vocab::COLLECTOR_BOOK,  :collector_book,  main_commands_enabled)
  end
  #--------------------------------------------------------------------------
  # * Get Activation State of Main Commands
  #--------------------------------------------------------------------------
  def main_commands_enabled
    $game_party.exists
  end
end
