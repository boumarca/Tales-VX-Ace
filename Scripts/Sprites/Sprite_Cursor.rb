#==============================================================================
# ** New Class
# ** Sprite_Cursor
#------------------------------------------------------------------------------
#  Cursor sprite used for windows
#  Source: Yanfly
#==============================================================================

class Sprite_Cursor < Sprite
  #--------------------------------------------------------------------------
  # * Constants
  #--------------------------------------------------------------------------
  CURSOR_FILE = "Cursor"
  OFFSET_X    = -12
  OFFSET_Y    = 0
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(window)
    super(window.viewport)
    @window = window
    create_bitmap
  end
  #--------------------------------------------------------------------------
  # * Create Cursor Bitmap
  #--------------------------------------------------------------------------
  def create_bitmap
    self.bitmap = Cache.system(CURSOR_FILE)
    self.z = @window.z + 100
    self.hide
  end
  #--------------------------------------------------------------------------
  # * Update the Cursor
  #--------------------------------------------------------------------------
  def update
    super
    update_visibility
    update_position
  end
  #--------------------------------------------------------------------------
  # * Update Cursor Position
  #--------------------------------------------------------------------------
  def update_position
    rect = @window.cursor_rect
    self.x = @window.x + rect.x + OFFSET_X - @window.ox 
    self.y = @window.y + rect.y + rect.height + OFFSET_Y - @window.oy 
  end
  #--------------------------------------------------------------------------
  # * Update Cursor Position
  #--------------------------------------------------------------------------
  def update_visibility
    (@window.open? && @window.active) ? self.show : self.hide
  end
end
