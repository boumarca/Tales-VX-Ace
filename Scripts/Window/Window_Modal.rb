#==============================================================================
# ** New Class
# ** Window_Modal
#------------------------------------------------------------------------------
#  This window is a modal window displaying informations with no controls
#==============================================================================

class Window_Modal < Window_Base
  #--------------------------------------------------------------------------
  # * Constants (Arrows)
  #--------------------------------------------------------------------------
  ARROW_WIDTH         = 16
  ARROW_HEIGHT        = 8
  ARROW               = "Scroll_arrow_down"
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super(x, y, width, height) 
    self.z = 200
    self.openness = 0    
    create_arrow
    self.arrows_visible = true
  end
  #--------------------------------------------------------------------------
  # * Create Continue Arrow
  #--------------------------------------------------------------------------
  def create_arrow
    @down_arrow = Sprite.new
    @down_arrow.bitmap = Cache.system(ARROW)
    @down_arrow.x = self.x + window_width / 2 - ARROW_WIDTH / 2
    @down_arrow.y = self.y + window_height - standard_padding + ARROW_HEIGHT / 2
    @down_arrow.z = 300
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
  def process_close
    Sound.play_cancel
    Input.update
    return_context
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    process_handling
  end
  #--------------------------------------------------------------------------
  # * Modified
  # * Handling Processing for OK and Cancel Etc.
  #--------------------------------------------------------------------------
  def process_handling
    return unless open? && active
    return process_close    if Input.trigger?(:A) || Input.trigger?(:B)
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Activate Window
  #--------------------------------------------------------------------------
  def activate
    @down_arrow.opacity = 255
    super
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Deactivate Window
  #--------------------------------------------------------------------------
  def deactivate
    @down_arrow.opacity = 0
    super
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Free
  #--------------------------------------------------------------------------
  def dispose
    @down_arrow.dispose
    super
  end
end