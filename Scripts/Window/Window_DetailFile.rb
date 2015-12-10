#==============================================================================
# ** New Class
# ** Window_DetailFile
#------------------------------------------------------------------------------
#  This window displays a character information on the save and load screens. 
#  These windows are separate for each character.
#==============================================================================

class Window_DetailFile < Window_Base
  #--------------------------------------------------------------------------
  # * Constants (Positions)
  #--------------------------------------------------------------------------
  WINDOW_WIDTH  = 256  
  TEXT_X        = 96
  HP_X          = 166
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader   :index
  #--------------------------------------------------------------------------
  # * Modified
  # * Object Initialization
  #     index : index of window for positionning
  #--------------------------------------------------------------------------
  def initialize(index)
    @index = index
    x = index >= 3 ? WINDOW_WIDTH : 0
    super(x, (index % 3) * fitting_height(3), WINDOW_WIDTH, fitting_height(3))
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Set Actor
  #     item : Actor to show in window
  #--------------------------------------------------------------------------
  def set_actor(actor)
    @actor_data = actor
    refresh
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Refresh Window, Hide If No Actor
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    if(@actor_data.nil?)
      self.hide
    else
      self.show
      draw_character_info
    end
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Draw Actor Info
  #--------------------------------------------------------------------------
  def draw_character_info
    return unless @actor_data
    draw_character_index
    draw_character_face
    draw_character_name
    draw_character_level
    draw_character_hp
    draw_character_mp
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Draw Actor Index
  #--------------------------------------------------------------------------
  def draw_character_index
    draw_text(0, line_height, standard_padding, line_height, @index + 1, Bitmap::ALIGN_CENTER)
  end 
  #--------------------------------------------------------------------------
  # * New Method
  # * Draw Face
  #--------------------------------------------------------------------------
  def draw_character_face
    draw_face(@actor_data[0], @actor_data[1], standard_padding, 0)
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Draw Name
  #--------------------------------------------------------------------------
  def draw_character_name
    draw_text(TEXT_X, 0, 140, line_height, @actor_data[2])
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Draw Level
  #--------------------------------------------------------------------------
  def draw_character_level
    change_color(system_color)
    draw_text(TEXT_X, line_height, 62, line_height, Vocab::level_a)
    change_color(normal_color)
    draw_text(TEXT_X, line_height, 62, line_height, @actor_data[3], Bitmap::ALIGN_RIGHT)
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Draw HP
  #--------------------------------------------------------------------------
  def draw_character_hp
    draw_gauge(HP_X, line_height, 62, hp_rate, hp_gauge_color1, hp_gauge_color2)
    change_color(system_color)
    draw_text(HP_X, line_height, 62, line_height, Vocab::hp_a)
    change_color(hp_color)
    draw_text(HP_X, line_height, 62, line_height, @actor_data[4], Bitmap::ALIGN_RIGHT)
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Draw MP
  #--------------------------------------------------------------------------
  def draw_character_mp
    draw_gauge(HP_X, line_height * 2, 62, mp_rate, mp_gauge_color1, mp_gauge_color2)
    change_color(system_color)
    draw_text(HP_X, line_height * 2, 62, line_height, Vocab::mp_a)
    change_color(mp_color)
    draw_text(HP_X, line_height * 2, 62, line_height, @actor_data[6], Bitmap::ALIGN_RIGHT)
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * HP Rate
  #--------------------------------------------------------------------------
  def hp_rate
    @actor_data[4].to_f / @actor_data[5]
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * MP Rate
  #--------------------------------------------------------------------------
  def mp_rate
    @actor_data[6].to_f / @actor_data[7]
  end  
  #--------------------------------------------------------------------------
  # * Override
  # * Get HP Text Color
  #--------------------------------------------------------------------------
  def hp_color
    return knockout_color if @actor_data[4] == 0
    return crisis_color if @actor_data[4] < @actor_data[5] / 4
    return normal_color
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Get MP Text Color
  #--------------------------------------------------------------------------
  def mp_color
    return crisis_color if @actor_data[6] < @actor_data[7] / 4
    return normal_color
  end
end