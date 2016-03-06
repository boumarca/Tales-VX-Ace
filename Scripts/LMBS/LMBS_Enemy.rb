#==============================================================================
# ** LMBS_Enemy
#------------------------------------------------------------------------------
#  This class handles enemies as a LMBS game object
#==============================================================================

module LMBS
  class LMBS_Enemy < LMBS_Battler
    #--------------------------------------------------------------------------
    # * Override
    # * Create Input Controller
    #--------------------------------------------------------------------------
    def create_input_controller
      @controller = LMBS_InputController.new
    end
    #--------------------------------------------------------------------------
    # * Reset Collision Layer
    #--------------------------------------------------------------------------
    def reset_layer
      @collider.layer = Physics_LayerMask::LAYER_ENEMY
      @collider.collision_mask = Physics_LayerMask::COLLISIONS_ENEMY
    end
  end
end
