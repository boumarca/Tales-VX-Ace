#==============================================================================
# ** Window_ControlsHelp
#------------------------------------------------------------------------------
#  This is a window displaying control help.
#==============================================================================

class Window_ControlsHelp < Window_Base
  #--------------------------------------------------------------------------
  # * Constants (Positions)
  #--------------------------------------------------------------------------
  WINDOW_WIDTH  = 608
  WINDOW_HEIGHT = 20
  LINE_HEIGHT   = 20
  PADDING       = 0
  LINES         = 1
  SPACING       = 8
  COLS          = 6
  ITEM_WIDTH    = 94
  ICON_SIZE     = 16
  ICON_Y        = 2
  #--------------------------------------------------------------------------
  # * Constants (Icons)
  #--------------------------------------------------------------------------
  ICON_LIST = { Input::Keys::A  => 538,
                Input::Keys::B  => 539,
                Input::Keys::X  => 540,
                Input::Keys::Y  => 541,
                Input::Keys::L  => 542,
                Input::Keys::R  => 543,
                Input::Keys::SELECT  => 544,
                Input::Keys::START  => 545}
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y)
    @controls = []
    @text_x = 0
    super(x, y, WINDOW_WIDTH, WINDOW_HEIGHT)
    self.opacity = 0    
    self.arrows_visible = false
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
  # * Calculate Width of Window Contents
  #--------------------------------------------------------------------------
  def standard_padding
    return PADDING
  end
  #--------------------------------------------------------------------------
  # * Get Number of Items
  #--------------------------------------------------------------------------
  def item_max
    @controls.size
  end
  #--------------------------------------------------------------------------
  # * Get Command Name
  #--------------------------------------------------------------------------
  def command_name(index)
    @controls[index][:name]
  end
  #--------------------------------------------------------------------------
  # * Get Command Symbol
  #--------------------------------------------------------------------------
  def command_symbol(index)
    @controls[index][:symbol]
  end
  #--------------------------------------------------------------------------
  # * Get Command Symbol
  #--------------------------------------------------------------------------
  def command_ext(index)
    @controls[index][:ext]
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_all_items
  end
  #--------------------------------------------------------------------------
  # * Draw All Items
  #--------------------------------------------------------------------------
  def draw_all_items
    item_max.times {|i| draw_item(i) }
  end
  #--------------------------------------------------------------------------
  # * Draw Item
  #--------------------------------------------------------------------------
  def draw_item(index)
    draw_icon(ICON_LIST[command_symbol(index)], @text_x, ICON_Y)
    @text_x += ICON_SIZE
    if !command_ext(index).nil?
      draw_icon(ICON_LIST[command_ext(index)], @text_x, ICON_Y) 
      @text_x += ICON_SIZE
    end
    @text_x += SPACING / 2
    contents.font.size = 20
    rect = contents.text_size(command_name(index))
    draw_text(@text_x, -1, rect.width, rect.height, command_name(index), Bitmap::ALIGN_LEFT)
    @text_x += rect.width + SPACING
  end
  #--------------------------------------------------------------------------
  # * Add Control
  #--------------------------------------------------------------------------
  def add_control(name, symbol, ext = nil)
    @controls.push({:name=>name, :symbol=>symbol, :ext=>ext})
  end
  #--------------------------------------------------------------------------
  # * Clear
  #--------------------------------------------------------------------------
  def clear
    @controls = []
    @text_x = 0
    contents.clear
  end
end