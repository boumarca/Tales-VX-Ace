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
end
