#==============================================================================
# ** Scene_LMBS
#------------------------------------------------------------------------------
#  This class performs battle screen processing.
#==============================================================================

class Scene_LMBS < Scene_Base
  #--------------------------------------------------------------------------
  # * Start Processing
  #--------------------------------------------------------------------------
  def start
    super
    create_spriteset
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
    dispose_spriteset
    RPG::ME.stop
  end
  #--------------------------------------------------------------------------
  # * Create Sprite Set
  #--------------------------------------------------------------------------
  def create_spriteset
    @spriteset = Spriteset_LMBS.new
  end
  #--------------------------------------------------------------------------
  # * Free Sprite Set
  #--------------------------------------------------------------------------
  def dispose_spriteset
    @spriteset.dispose
  end
end
