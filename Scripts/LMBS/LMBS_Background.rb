#==============================================================================
# ** LMBS_Background
#------------------------------------------------------------------------------
#  This class handles the battle background
#==============================================================================

module LMBS
  class LMBS_Background
    #--------------------------------------------------------------------------
    # * Constants
    #--------------------------------------------------------------------------
    GROUND_X      = 320
    GROUND_Y      = 490
    GROUND_WIDTH  = 1280
    GROUND_HEIGHT = 300
    LEFT_SIDE_X   = -160
    RIGHT_SIDE_X  = 800
    SIDE_Y        = 240
    SIDE_WIDTH    = 320
    SIDE_HEIGHT   = 960
    #--------------------------------------------------------------------------
    # * Public Members
    #--------------------------------------------------------------------------
    attr_accessor :transform
    #--------------------------------------------------------------------------
    # * Object Initialization
    #--------------------------------------------------------------------------
    def initialize(viewport)
      @viewport = viewport
      create_battleback
      create_ground
      create_sides
    end
    #--------------------------------------------------------------------------
    # * Create Ground
    #--------------------------------------------------------------------------
    def create_ground
      @ground = LMBS_Borders.new(GROUND_X, GROUND_Y, GROUND_WIDTH, GROUND_HEIGHT)
      @ground.layers(Physics_RigidBody::LAYER_GROUND, Physics_RigidBody::COLLISIONS_GROUND)
    end
    #--------------------------------------------------------------------------
    # * Create Sides
    #--------------------------------------------------------------------------
    def create_sides
      @left_side = LMBS_Borders.new(LEFT_SIDE_X, SIDE_Y, SIDE_WIDTH, SIDE_HEIGHT)
      @left_side.layers(Physics_RigidBody::LAYER_SIDES, Physics_RigidBody::COLLISIONS_SIDES)
      @right_side = LMBS_Borders.new(RIGHT_SIDE_X, SIDE_Y, SIDE_WIDTH, SIDE_HEIGHT)
      @right_side.layers(Physics_RigidBody::LAYER_SIDES, Physics_RigidBody::COLLISIONS_SIDES)
    end
    #--------------------------------------------------------------------------
    # * Create Battle Background Sprite
    #--------------------------------------------------------------------------
    def create_battleback
      @background = Sprite.new(@viewport)
      @background.bitmap = battleback_bitmap
      @background.z = -10
      center_sprite(@background)
    end
    #--------------------------------------------------------------------------
    # * Move Sprite to Screen Center
    #--------------------------------------------------------------------------
    def center_sprite(sprite)
      sprite.ox = sprite.bitmap.width / 2
      sprite.oy = sprite.bitmap.height / 2
      sprite.x = Graphics.width / 2
      sprite.y = Graphics.height / 2
    end
    #--------------------------------------------------------------------------
    # * Get Battle Background Bitmap
    #--------------------------------------------------------------------------
    def battleback_bitmap
      Cache.battleback1(battleback_name) if battleback_name
    end
    #--------------------------------------------------------------------------
    # * Get Filename of Battle Background
    #--------------------------------------------------------------------------
    def battleback_name
      return "BG1"
    end
    #--------------------------------------------------------------------------
    # * Free
    #--------------------------------------------------------------------------
    def dispose
      @background.bitmap.dispose
      @background.dispose
    end
  end
end
