#==============================================================================
# ** New Class
# ** Window_SystemChoice
#------------------------------------------------------------------------------
#  This window displays system messages with variable width. Also allows the
# player to choose yes or no.
#==============================================================================

class Window_SystemChoice < Window_Command
  #--------------------------------------------------------------------------
  # * Constants
  #--------------------------------------------------------------------------
  CHOICES = 2
  #--------------------------------------------------------------------------
  # * Object Initialization
  #-------------------------------------------------------------------------
  def initialize(message)
    message_rect = message_size(message)
    
    x = Graphics.width / 2 - message_rect.width / 2 - standard_padding
    y = Graphics.height / 2 - message_rect.height / 2 - standard_padding
    @width = message_rect.width + standard_padding * 2 + 2
    super(x, y)
    self.z = 200
    self.openness = 0
    draw_text_ex(0, 0, message)
    set_handler(:cancel, method(:return_context))
  end
  #--------------------------------------------------------------------------
  # * Get Message Size
  #-------------------------------------------------------------------------
  def message_size(message)
    dummy_window = Window_Base.new(0,0,0,0)
    dummy_window.hide
    message_rect = dummy_window.text_size(message)
    dummy_window.dispose
    return message_rect
  end
  #--------------------------------------------------------------------------
  # * Get Window Width
  #--------------------------------------------------------------------------
  def window_width
    @width
  end
  #--------------------------------------------------------------------------
  # * Get Window Height
  #--------------------------------------------------------------------------
  def window_height
    fitting_height(3)
  end
  #--------------------------------------------------------------------------
  # * Create Command List
  #--------------------------------------------------------------------------
  def make_command_list
    add_command(Vocab::YES, :ok)
    add_command(Vocab::NO,  :cancel)
  end
  #--------------------------------------------------------------------------
  # * Get Rectangle for Drawing Items
  #--------------------------------------------------------------------------
  def item_rect(index)
    rect = Rect.new
    rect.width = item_width
    rect.height = item_height
    rect.x = index % col_max * (item_width + spacing)
    rect.y = index / col_max * item_height + line_height
    rect
  end
  #--------------------------------------------------------------------------
  # * Get Alignment
  #--------------------------------------------------------------------------
  def alignment
    return Bitmap::ALIGN_CENTER
  end
  #--------------------------------------------------------------------------
  # * Get control of window
  #-------------------------------------------------------------------------
  def change_context(window)
    if window
      @window = window
      @window.deactivate 
    end
    open
    activate
  end
  #--------------------------------------------------------------------------
  # * Give control back to other window
  #-------------------------------------------------------------------------
  def return_context
    @window.activate if @window
    close
    deactivate
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Processing When OK Button Is Pressed
  #--------------------------------------------------------------------------
  def process_ok
    if current_item_enabled?
      Sound.play_ok
      Input.update
      return_context
      call_ok_handler
    else
      Sound.play_buzzer
    end
  end
end