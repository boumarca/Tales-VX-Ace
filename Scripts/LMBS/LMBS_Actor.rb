#==============================================================================
# ** LMBS_Actor
#------------------------------------------------------------------------------
#  This class handles actors as a LMBS game object
#==============================================================================

module LMBS
  class LMBS_Actor < LMBS_Battler
    #--------------------------------------------------------------------------
    # * Override
    # * Create Input Controller
    #--------------------------------------------------------------------------
    def create_input_controller
      if @game_battler.battle_control == :manual
        @controller = LMBS_InputPlayer.new
      elsif @game_battler.battle_control == :auto
        @controller = LMBS_InputController.new
      end
    end
    #--------------------------------------------------------------------------
    # * Override
    # * Reset Collision Layer
    #--------------------------------------------------------------------------
    def reset_layer
      @collider.layer = Physics_LayerMask::LAYER_ALLY
      @collider.collision_mask = Physics_LayerMask::COLLISIONS_ALLY
    end
  end
end
