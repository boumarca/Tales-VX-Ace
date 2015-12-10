#==============================================================================
# ** New Class
# ** Window_MenuHeader
#------------------------------------------------------------------------------
#  This window displays the top menu header text.
#==============================================================================

class Window_MenuHeader < Window_Base
  #--------------------------------------------------------------------------
  # * Constants (Positions)
  #--------------------------------------------------------------------------
  HEADER_X      = 16
  HEADER_Y      = 12
  WINDOW_WIDTH  = 160
  PADDING       = 8
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(header)
    super(HEADER_X, HEADER_Y, WINDOW_WIDTH, fitting_height(1))
    @header = header
    draw_header
  end
  #--------------------------------------------------------------------------
  # * Draw Header
  #--------------------------------------------------------------------------
  def draw_header
    draw_text(0, 0, contents.width, line_height, @header, Bitmap::ALIGN_CENTER)
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Get Standard Padding Size
  #--------------------------------------------------------------------------
  def standard_padding
    return PADDING
  end
end

