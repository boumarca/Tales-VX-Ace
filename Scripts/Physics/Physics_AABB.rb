#==============================================================================
# ** Physics AABB
#------------------------------------------------------------------------------
#  This class handles Axis-Aligned Bounding Box (AABB) and their collisions
#==============================================================================

class Physics_AABB
  attr_accessor :min
  attr_accessor :max
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(rect)
    @min = Vector2.new(rect.x, rect.y)
    @max = Vector2.new(rect.x + rect.width, rect.y + rect.height)
  end
  #--------------------------------------------------------------------------
  # * Determines if two AABB collides with each other using SAT
  #--------------------------------------------------------------------------
  def self.aabb_vs_aabb(a, b)
    return false if a.max.x < b.min.x || a.min.x > b.max.x
    return false if a.max.y < b.min.y || a.min.y > b.max.y
    return true
  end
end