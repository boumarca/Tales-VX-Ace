#==============================================================================
# ** Physics_LayerMask
#------------------------------------------------------------------------------
#  This modules contains constants for Layer Mask
#==============================================================================

module Physics_LayerMask
  #--------------------------------------------------------------------------
  # * Collision Layers
  #--------------------------------------------------------------------------
  LAYER_ALLY    = 1
  LAYER_ENEMY   = 2
  LAYER_RUNNING = 4
  LAYER_GROUND  = 8
  LAYER_SIDES   = 16
  #--------------------------------------------------------------------------
  # * Collision Bitmasks
  #--------------------------------------------------------------------------
  COLLISIONS_ALLY    = LAYER_ENEMY + LAYER_GROUND + LAYER_SIDES
  COLLISIONS_ENEMY   = LAYER_ALLY + LAYER_GROUND + LAYER_SIDES
  COLLISIONS_RUNNING = LAYER_GROUND + LAYER_SIDES
  COLLISIONS_GROUND  = LAYER_ENEMY + LAYER_ALLY + LAYER_RUNNING
  COLLISIONS_SIDES   = LAYER_ENEMY + LAYER_ALLY + LAYER_RUNNING
end
