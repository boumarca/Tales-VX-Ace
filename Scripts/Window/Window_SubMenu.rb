#==============================================================================
# ** New Class
# ** Window_SubMenu
#------------------------------------------------------------------------------
#  Super class of submenu windows.
#==============================================================================

class Window_SubMenu < Window_Command
  #--------------------------------------------------------------------------
  # * Constants (Positions)
  #--------------------------------------------------------------------------
  WINDOW_WIDTH = 128
  #--------------------------------------------------------------------------
  # * Initialize Command Selection Position (Class Method)
  #--------------------------------------------------------------------------
  def self.init_command_position
    @@last_command_symbol = nil
  end
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y)
    super(x, y)
    self.openness = 0
    deactivate
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Activate Window
  #--------------------------------------------------------------------------
  def activate
    open
    super
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Deactivate Window
  #--------------------------------------------------------------------------
  def deactivate
    close
    super
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Get Window Width
  #--------------------------------------------------------------------------
  def window_width
    return WINDOW_WIDTH
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Get Number of Lines to Show
  #--------------------------------------------------------------------------
  def visible_line_number
    item_max
  end
  #--------------------------------------------------------------------------
  # * Override
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
  # * Move Cursor Up
  #--------------------------------------------------------------------------
  def cursor_up(wrap = false)
    if row == 0
      process_up
    else
      super
    end
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Process Cursor Up
  #--------------------------------------------------------------------------
  def process_up
    Sound.play_cursor
    Input.update
    deactivate
    call_cancel_handler
  end
end
