#==============================================================================
# ** Physics Entity
#------------------------------------------------------------------------------
#  This is the super class for all physics bodies
#==============================================================================

class Physics_Entity
  attr_accessor :position
  attr_reader   :parent
  attr_accessor :is_trigger
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(parent)
    @parent = parent
    @position = Vector2.zero
    @is_trigger = false
  end
  #--------------------------------------------------------------------------
  # * Update entity velocity
  #--------------------------------------------------------------------------
  def update_velocity
  end
  #--------------------------------------------------------------------------
  # * Update entity position
  #--------------------------------------------------------------------------
  def update_position
  end
  #--------------------------------------------------------------------------
  # * Interpolate entity position
  #--------------------------------------------------------------------------
  def interpolate_position(ratio)
  end
  #--------------------------------------------------------------------------
  # * Update parent
  #--------------------------------------------------------------------------
  def update_parent
  end
end
