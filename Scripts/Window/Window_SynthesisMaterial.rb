#==============================================================================
# ** New Class
# ** Window_SynthesisMaterial
#------------------------------------------------------------------------------
#  This window displays the required materials for synthesis.
#==============================================================================

class Window_SynthesisMaterial < Window_Base
  #--------------------------------------------------------------------------
  # * Constants (Positions)
  #--------------------------------------------------------------------------
  WINDOW_WIDTH  = 304  
  MARGIN_X      = 12
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y)
    super(x, y, window_width, fitting_height(9))   
    @materials = []
  end
  #--------------------------------------------------------------------------
  # * Get Window Width
  #--------------------------------------------------------------------------
  def window_width
    return WINDOW_WIDTH
  end
  #--------------------------------------------------------------------------
  # * Set Materials
  #--------------------------------------------------------------------------
  def materials=(materials)
    return if @materials == materials
    @materials = materials
    refresh
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_materials
  end
  #--------------------------------------------------------------------------
  # * Get Number of Items
  #--------------------------------------------------------------------------
  def item_max
    @materials ? @materials.size : 0
  end
  #--------------------------------------------------------------------------
  # * Draw Materials
  #--------------------------------------------------------------------------
  def draw_materials
    change_color(system_color)
    draw_text(0, 0, contents.width, line_height, Vocab::MATERIALS)
    change_color(normal_color)
    item_max.times { |i| draw_item(i) }  
  end
  #--------------------------------------------------------------------------
  # * Draw Item
  #--------------------------------------------------------------------------
  def draw_item(index)
    material = @materials[index]
    if material
      rect = Rect.new(0, line_height * (index + 1), contents.width - MARGIN_X, line_height)
      rect.width -= 4
      draw_item_name(SynthesisManager.get_item_from_material(material), rect.x, rect.y, enable?(material))
      draw_item_number(rect, material.quantity, SynthesisManager.quantity(material))
    end
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Draw Number of Items
  #--------------------------------------------------------------------------
  def draw_item_number(rect, needed, owned)
    draw_text(rect, sprintf("%2d/%2d", needed, owned), Bitmap::ALIGN_RIGHT)
  end
  #--------------------------------------------------------------------------
  # * Display in Enabled State?
  #--------------------------------------------------------------------------
  def enable?(material)
    SynthesisManager.owns_enough?(material) 
  end
end