#==============================================================================
# ** LMBS_Battle
#------------------------------------------------------------------------------
#  This class performs battle screen processing.
#==============================================================================

module LMBS
  class LMBS_SceneBattle < Scene_Base
    #--------------------------------------------------------------------------
    # * Constant
    #--------------------------------------------------------------------------
    GROUND = 340
    #--------------------------------------------------------------------------
    # * Start Processing
    #--------------------------------------------------------------------------
    def start
      super
      PhysicsManager.setup
      create_viewport
      create_background
      create_battlers
    end
    #--------------------------------------------------------------------------
    # * Post-Start Processing
    #--------------------------------------------------------------------------
    def post_start
      super
    end
    #--------------------------------------------------------------------------
    # * Pre-Termination Processing
    #--------------------------------------------------------------------------
    def pre_terminate
      super
      Graphics.fadeout(30) if SceneManager.scene_is?(Scene_Map)
      Graphics.fadeout(60) if SceneManager.scene_is?(Scene_Title)
    end
    #--------------------------------------------------------------------------
    # * Termination Processing
    #--------------------------------------------------------------------------
    def terminate
      super
      dispose_sprites
      PhysicsManager.stop
      RPG::ME.stop
    end
    #--------------------------------------------------------------------------
    # * Create Viewport
    #--------------------------------------------------------------------------
    def create_viewport
      @viewport = Viewport.new
    end
    #--------------------------------------------------------------------------
    # * Create Background Sprite
    #--------------------------------------------------------------------------
    def create_background
      @background = LMBS_Background.new(@viewport)
    end
    #--------------------------------------------------------------------------
    # * Create Battlers
    #--------------------------------------------------------------------------
    def create_battlers
      @battlers = []
      create_actors
      create_enemies
    end
    #--------------------------------------------------------------------------
    # * Create Actors
    #--------------------------------------------------------------------------
    def create_actors
      @battlers.push(LMBS_Actor.new(@viewport, $game_party.members[0]))
      @battlers.push(LMBS_Actor.new(@viewport, $game_party.members[1]))
    end
    #--------------------------------------------------------------------------
    # * Create Enemies
    #--------------------------------------------------------------------------
    def create_enemies
      @battlers.push(LMBS_Enemy.new(@viewport, Game_Enemy.new(0, 31)))
    end
    #--------------------------------------------------------------------------
    # * Free Sprites
    #--------------------------------------------------------------------------
    def dispose_sprites
      @background.dispose
      @battlers.each { |battler| battler.dispose }
    end
    #--------------------------------------------------------------------------
    # * Update
    #--------------------------------------------------------------------------
    def update
      super
      pre_physics_update
      PhysicsManager.run_physics
      post_physics_update
    end
    #--------------------------------------------------------------------------
    # * Update Battlers
    #--------------------------------------------------------------------------
    def pre_physics_update
      @battlers.each { |battler|
        battler.update_command
        battler.reset_ground
      }
    end
    #--------------------------------------------------------------------------
    # * Update Sprites
    #--------------------------------------------------------------------------
    def post_physics_update
      @battlers.each { |battler|
        battler.update_movement
        battler.update_sprite
      }
    end
  end
end
