#==============================================================================
# ** Window_MenuCommand
#------------------------------------------------------------------------------
#  This command window appears on the menu screen.
#==============================================================================

class Window_MenuCommand < Window_Command
  #--------------------------------------------------------------------------
  # * Constants (Positions)
  #--------------------------------------------------------------------------
  COMMAND_WINDOW_WIDTH  = 608
  COMMAND_WINDOW_HEIGHT = 64
  ROWS_MAX              = 2
  COLUMNS_MAX           = 5
  SPACING               = 0
  PADDING               = 8
  #--------------------------------------------------------------------------
  # * Initialize Command Selection Position (Class Method)
  #--------------------------------------------------------------------------
  def self.init_command_position
    @@last_command_symbol = nil
  end
  #--------------------------------------------------------------------------
  # * Modified
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y)
    super(x, y)
    select_last
  end
  #--------------------------------------------------------------------------
  # * Modified
  # * Get Window Width
  #--------------------------------------------------------------------------
  def window_width
    return COMMAND_WINDOW_WIDTH
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Get Number of Lines to Show
  #--------------------------------------------------------------------------
  def visible_line_number
    return ROWS_MAX
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Get Digit Count
  #--------------------------------------------------------------------------
  def col_max
    return COLUMNS_MAX
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Get Alignment
  #--------------------------------------------------------------------------
  def alignment
    return Bitmap::ALIGN_CENTER
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Get Spacing for Items Arranged Side by Side
  #--------------------------------------------------------------------------
  def spacing
    return SPACING
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Get Standard Padding Size
  #--------------------------------------------------------------------------
  def standard_padding
    return PADDING
  end
  #--------------------------------------------------------------------------
  # * Modified
  # * Create Command List
  #--------------------------------------------------------------------------
  def make_command_list
    add_command(Vocab::SKILLS,      :skills,      main_commands_enabled)
    add_command(Vocab::CAPACITIES,  :capacities,  main_commands_enabled)
    add_command(Vocab::EQUIP,       :equip,       main_commands_enabled)
    add_command(Vocab::LEARNING,    :learning,    main_commands_enabled)
    add_command(Vocab::LIBRAIRIES,  :librairies,  main_commands_enabled)
    add_command(Vocab::ITEM,        :item,        main_commands_enabled)
    add_command(Vocab::CRAFTING,    :crafting,    main_commands_enabled)
    add_command(Vocab::STRATEGY,    :strategy,    main_commands_enabled)
    add_command(Vocab::COOKING,     :cooking,     main_commands_enabled)
    add_command(Vocab::SYSTEM,      :system,      main_commands_enabled)
  end
  #--------------------------------------------------------------------------
  # * Get Activation State of Main Commands
  #--------------------------------------------------------------------------
  def main_commands_enabled
    $game_party.exists
  end
  #--------------------------------------------------------------------------
  # * Processing When OK Button Is Pressed
  #--------------------------------------------------------------------------
  def process_ok
    @@last_command_symbol = current_symbol
    super
  end
  #--------------------------------------------------------------------------
  # * Restore Previous Selection Position
  #--------------------------------------------------------------------------
  def select_last
    select_symbol(@@last_command_symbol)
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Move Cursor Down. Call Formation at Border
  #--------------------------------------------------------------------------
  def cursor_down(wrap = false)
    if row == row_max - 1
      deactivate
      @@last_command_symbol = current_symbol
      call_handler(:formation)
    else
      super
    end
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Move Cursor Right. Loops at Border.
  #--------------------------------------------------------------------------
  def cursor_right(wrap = false)
    if col_max >= 2 && (index % col_max == col_max - 1)
      select(index + 1 - col_max)
    elsif col_max >= 2 && (index < item_max - 1 || (wrap && horizontal?))
      select((index + 1) % item_max)
    end
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Move Cursor Left. Loops at Border.
  #--------------------------------------------------------------------------
  def cursor_left(wrap = false)
    if col_max >= 2 && (index % col_max == 0)
      select(index - 1 + col_max)
    elsif col_max >= 2 && (index > 0 || (wrap && horizontal?))
      select((index - 1 + item_max) % item_max)
    end
  end
end
