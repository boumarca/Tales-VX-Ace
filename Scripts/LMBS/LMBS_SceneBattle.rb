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
      @battlers.push(LMBS_Battler.new(@viewport, $game_actors[1])) 
    end
    #--------------------------------------------------------------------------
    # * Create Enemies
    #--------------------------------------------------------------------------
    def create_enemies 
      @battlers.push(LMBS_Battler.new(@viewport, Game_Enemy.new(0, 31)))
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
      update_battlers
      update_physics
      update_sprites
    end
    #--------------------------------------------------------------------------
    # * Update Battlers
    #--------------------------------------------------------------------------
    def update_battlers
      @battlers.each { |battler| 
        battler.update        
      }
    end
    #--------------------------------------------------------------------------
    # * Update Physics
    #--------------------------------------------------------------------------
    def update_physics 
      @battlers.each { |battler| 
        @battlers.each { |other| 
          next if battler == other
          collision = Physics_RigidBody.collision_detection(battler.rigidbody, other.rigidbody)
          if collision
            Physics_RigidBody.resolve_collision(collision)
            Physics_RigidBody.positional_correction(collision)
          end
        }
      }
      @battlers.each { |battler|
        position = battler.rigidbody.position
        battler.rigidbody.position = Vector2.new(position.x + battler.rigidbody.velocity.x, position.y + battler.rigidbody.velocity.y)
        battler.transform.x = battler.rigidbody.position.x
        battler.transform.y = battler.rigidbody.position.y
      }      
    end
    #--------------------------------------------------------------------------
    # * Update Sprites
    #--------------------------------------------------------------------------
    def update_sprites
      @battlers.each { |battler| 
        battler.update_sprite        
      }
    end
  end
end
