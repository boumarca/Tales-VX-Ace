#==============================================================================
# ** New Class
# ** Window_SystemMessage
#------------------------------------------------------------------------------
#  This window displays system messages with variable width.
#==============================================================================

class Window_SystemMessage < Window_Modal
  #--------------------------------------------------------------------------
  # * Override
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(message)
    message_rect = message_size(message)
    
    x = Graphics.width / 2 - message_rect.width / 2 - standard_padding
    y = Graphics.height / 2 - message_rect.height / 2 - standard_padding
    @width = message_rect.width + standard_padding * 2 + 2
    super(x, y, window_width, window_height)
    draw_text_ex(0, 0, message)
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
    fitting_height(1)
  end
  #--------------------------------------------------------------------------
  # * Get Alignment
  #--------------------------------------------------------------------------
  def alignment
    return Bitmap::ALIGN_CENTER
  end
end