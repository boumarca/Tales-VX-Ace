#==============================================================================
# ** New Class
# ** Window_Face
#------------------------------------------------------------------------------
#  This window display a faceset of the actor in the status screen.
# The window is set to be invisible so that only the faceset is shown.
#==============================================================================

class Window_Face < Window_Base
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y, actor)
    super(x, y, 72, 72)
    self.opacity = 0
    @actor = actor
    refresh
  end
  #--------------------------------------------------------------------------
  # * Get Standard Padding Size
  #--------------------------------------------------------------------------
  def standard_padding
    return 0
  end
  #--------------------------------------------------------------------------
  # * Set Actor
  #--------------------------------------------------------------------------
  def actor=(actor)
    return if @actor == actor
    @actor = actor
    refresh
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_actor_face(@actor, 0, 0)
    draw_actor_icons(@actor, 0, 0)
  end
end