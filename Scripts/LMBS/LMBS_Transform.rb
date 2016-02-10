#==============================================================================
# ** LMBS_Transform
#------------------------------------------------------------------------------
#  This class handles position, rotation and scaling of the object
#==============================================================================

module LMBS
  class LMBS_Transform
    attr_accessor :position
    attr_accessor :depth
    #--------------------------------------------------------------------------
    # * Object Initialization
    #--------------------------------------------------------------------------
    def initialize(position)
      @position = position
      @depth = 0
    end
  end
end
