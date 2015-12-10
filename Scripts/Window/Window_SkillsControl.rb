#==============================================================================
# ** New Class
# ** Window_SkillsControl
#------------------------------------------------------------------------------
#  This window displays which kind of control scheme is used by this actor.
#==============================================================================

class Window_SkillsControl < Window_HorzCommand
  #--------------------------------------------------------------------------
  # * Constants (Positions)
  #--------------------------------------------------------------------------
  CONTROL_WINDOW_WIDTH  = 230
  PADDING               = 8
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y)
    super(x, y)
    unselect
    deactivate
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Create Command List
  #--------------------------------------------------------------------------
  def make_command_list
    add_command(Vocab::MANUAL,    :manual,    manual_enabled?)
    add_command(Vocab::SEMI_AUTO, :semi_auto)
    add_command(Vocab::AUTO,      :auto)
  end
  #--------------------------------------------------------------------------
  # * Get Activation State of Manual Command
  #--------------------------------------------------------------------------
  def manual_enabled?
    return true
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Get Digit Count
  #--------------------------------------------------------------------------
  def col_max
    return 3
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Get Window Width
  #--------------------------------------------------------------------------
  def window_width
    return CONTROL_WINDOW_WIDTH 
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Get Standard Padding Size
  #--------------------------------------------------------------------------
  def standard_padding
    return PADDING
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Get Activation State of Command
  #--------------------------------------------------------------------------
  def command_enabled?(index)
    @list[index] == @list[@index]
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Move Cursor to Command with Specified Symbol
  #--------------------------------------------------------------------------
  def select_symbol(symbol)
    super
    refresh
  end
end