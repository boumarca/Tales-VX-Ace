#==============================================================================
# ** LMBS_Transform
#------------------------------------------------------------------------------
#  This class handles position, rotation and scaling of the object
#==============================================================================

module LMBS
  class LMBS_Transform
    attr_accessor :x
    attr_accessor :y
    attr_accessor :z
    #--------------------------------------------------------------------------
    # * Object Initialization
    #--------------------------------------------------------------------------    
    def initialize
      @x = 0
      @y = 0
      @z = 0
    end        
  end
end