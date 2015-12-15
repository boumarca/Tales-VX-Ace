#==============================================================================
# ** Scene_Status
#------------------------------------------------------------------------------
#  This class performs the status screen processing.
#==============================================================================

class Scene_Status < Scene_MenuBase
  #--------------------------------------------------------------------------
  # * Constants (Positions)
  #--------------------------------------------------------------------------
  STATUS_WINDOW_X = 16
  STATUS_WINDOW_Y = 52
  FACE_X          = 256
  FACE_Y          = 12
  PORTRAIT_X      = 368
  PORTRAIT_Y      = 52
  HELP_WINDOW_X   = 16
  HELP_WINDOW_Y   = 340
  TITLE_WINDOW_X  = 368
  TITLE_WINDOW_Y  = 52
  #--------------------------------------------------------------------------
  # * Modified
  # * Start Processing
  #--------------------------------------------------------------------------
  def start
    super
    create_header_window(Vocab::STATUS)
    create_status_window
    create_face_window
    create_help_window
    create_title_window
    create_name_window
    set_controls_help
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Create Status Window
  #--------------------------------------------------------------------------
  def create_status_window
    @status_window = Window_Status.new(STATUS_WINDOW_X, STATUS_WINDOW_Y, @actor)
    @status_window.set_handler(:name,     method(:input_name))
    @status_window.set_handler(:title,    method(:change_title))
    @status_window.set_handler(:cancel,   method(:return_scene))
    @status_window.set_handler(:pagedown, method(:next_actor))
    @status_window.set_handler(:pageup,   method(:prev_actor))
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Create Face Window
  #--------------------------------------------------------------------------
  def create_face_window
    @face_window = Window_Face.new(FACE_X, FACE_Y, @actor)
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Create Name Input Windows
  #--------------------------------------------------------------------------
  def create_name_window
    @edit_window = Window_NameEdit.new(@actor, 10)
    @input_window = Window_NameInput.new(@edit_window)
    @input_window.set_handler(:ok, method(:on_input_ok))
    @edit_window.hide
    @input_window.hide
    @input_window.deactivate
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Create Title Windows
  #--------------------------------------------------------------------------
  def create_title_window
    @title_window = Window_TitleList.new(TITLE_WINDOW_X, TITLE_WINDOW_Y)
    @title_window.actor = @actor
    @title_window.set_handler(:ok,      method(:on_title_ok))
    @title_window.set_handler(:cancel,  method(:on_title_cancel))
    @title_window.set_handler(:start,   method(:toggle_help))
    @title_window.help_window = @help_window
    @title_window.hide
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Create Help Window When Choosing Titles
  #--------------------------------------------------------------------------
  def create_help_window
    @help_window = Window_TitleHelp.new(HELP_WINDOW_X, HELP_WINDOW_Y)
    @help_window.hide
  end
  #--------------------------------------------------------------------------
  # * Modified
  # * Change Actors
  #--------------------------------------------------------------------------
  def on_actor_change
    @status_window.actor = @actor
    @face_window.actor = @actor
    @edit_window.actor = @actor
    @title_window.actor = @actor
    @status_window.activate
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Change Actor Name
  #--------------------------------------------------------------------------
  def input_name
    @status_window.deactivate
    @edit_window.show.refresh
    @input_window.show.activate.select(0)
    set_controls_help
  end
  #--------------------------------------------------------------------------
  # * Input [OK]
  #--------------------------------------------------------------------------
  def on_input_ok
    @actor.name = @edit_window.name
    @edit_window.hide
    @input_window.hide.deactivate.unselect
    @status_window.activate.refresh
    set_controls_help
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Change Actor Title
  #--------------------------------------------------------------------------
  def change_title
    @status_window.deactivate
    @title_window.select_last
    @title_window.show.activate
    @title_window.refresh
    @help_window.show
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Title [OK]
  #--------------------------------------------------------------------------
  def on_title_ok
    @actor.equip_title(@title_window.title)
    @status_window.refresh
    title_to_status
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Title [Cancel]
  #--------------------------------------------------------------------------
  def on_title_cancel
    title_to_status
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Title Window To Status
  #--------------------------------------------------------------------------
  def title_to_status
    @title_window.hide.deactivate.unselect
    @help_window.hide
    @status_window.activate
    set_controls_help
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Toggle Help Window
  #--------------------------------------------------------------------------
  def toggle_help
    @help_window.toggle_text
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Set Control Help 
  #--------------------------------------------------------------------------
  def set_controls_help
    @control_help_window.clear
    set_status_controls   if @status_window.active
    set_titles_controls   if @title_window.active
    set_input_controls    if @input_window.active
    @control_help_window.refresh
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Set Controls For Status Window 
  #--------------------------------------------------------------------------
  def set_status_controls
    @control_help_window.add_control(Vocab::MODIFY,       Input::Keys::A) 
    @control_help_window.add_control(Vocab::BACK,         Input::Keys::B)
    @control_help_window.add_control(Vocab::CHANGE_ACTOR, Input::Keys::L, Input::Keys::R)
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Set Controls For Titles Window 
  #--------------------------------------------------------------------------
  def set_titles_controls
    @control_help_window.add_control(Vocab::CONFIRM,      Input::Keys::A) 
    @control_help_window.add_control(Vocab::BACK,         Input::Keys::B)
    @control_help_window.add_control(Vocab::DESCRIPTION,  Input::Keys::START)
  end
    #--------------------------------------------------------------------------
  # * New Method
  # * Set Controls For Name Input Window 
  #--------------------------------------------------------------------------
  def set_input_controls
    @control_help_window.add_control(Vocab::CONFIRM,  Input::Keys::A) 
    @control_help_window.add_control(Vocab::ERASE,    Input::Keys::B)
    @control_help_window.add_control(Vocab::DONE,     Input::Keys::START)
  end
end