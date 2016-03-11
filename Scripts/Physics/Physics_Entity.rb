#==============================================================================
# ** Physics Entity
#------------------------------------------------------------------------------
#  This is the super class for all physics bodies
#==============================================================================

class Physics_Entity
  attr_reader   :parent
  attr_accessor :position
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(parent)
    @parent = parent
    @position = Vector2.zero
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
  # * Update parent
  #--------------------------------------------------------------------------
  def update_parent
  end
end
