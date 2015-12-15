#==============================================================================
# ** Scene_File
#------------------------------------------------------------------------------
#  This class performs common processing for the save screen and load screen.
#==============================================================================

class Scene_File < Scene_MenuBase
  #--------------------------------------------------------------------------
  # * Constants (Positions)
  #--------------------------------------------------------------------------
  SAVE_VIEWPORT_X         = 16
  SAVE_VIEWPORT_Y         = 52
  SAVE_VIEWPORT_WIDTH     = 96  
  SAVE_VIEWPORT_HEIGHT    = 406
  DETAIL_VIEWPORT_X       = 112 
  DETAIL_VIEWPORT_Y       = 52
  DETAIL_VIEWPORT_WIDTH   = 512  
  DETAIL_VIEWPORT_HEIGHT  = 288
  ARROW_X                 = 56
  UP_ARROW_Y              = 56
  DOWN_ARROW_Y            = 446
  BOTTOM_WINDOW_X         = 112
  BOTTOM_WINDOW_Y         = 340
  #--------------------------------------------------------------------------
  # * Constants (Images)
  #--------------------------------------------------------------------------
  UP_ARROW                = "Scroll_arrow_up"
  DOWN_ARROW              = "Scroll_arrow_down"
  #--------------------------------------------------------------------------
  # * Modified
  # * Start Processing
  #--------------------------------------------------------------------------
  def start
    super
    create_header_window
    create_savefile_viewport
    create_savefile_windows
    init_selection
    create_detail_viewport
    create_detail_window
    create_bottom_window
    create_scroll_arrows
    set_controls_help
  end
  #--------------------------------------------------------------------------
  # * Modified
  # * Termination Processing
  #--------------------------------------------------------------------------
  def terminate
    super
    @savefile_viewport.dispose
    @savefile_windows.each {|window| window.dispose }
    @detail_viewport.dispose
    @detail_windows.each {|window| window.dispose }
    @up_arrow.dispose
    @down_arrow.dispose
  end
  #--------------------------------------------------------------------------
  # * Modified
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    @savefile_windows.each {|window| window.update }
    update_savefile_selection
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Create Header Window
  #--------------------------------------------------------------------------
  def create_header_window
  end
  #--------------------------------------------------------------------------
  # * Modified
  # * Create Save File Viewport
  #--------------------------------------------------------------------------
  def create_savefile_viewport
    @savefile_viewport = Viewport.new(SAVE_VIEWPORT_X, SAVE_VIEWPORT_Y, SAVE_VIEWPORT_WIDTH, SAVE_VIEWPORT_HEIGHT)
  end
  #--------------------------------------------------------------------------
  # * Modified
  # * Create Save File Window
  #--------------------------------------------------------------------------
  def create_savefile_windows
    @savefile_windows = Array.new(item_max) do |i|
      Window_SaveFile.new(i)
    end
    @savefile_windows.each {|window| window.viewport = @savefile_viewport }
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Create Detail Windows Viewport
  #--------------------------------------------------------------------------
  def create_detail_viewport
    @detail_viewport = Viewport.new(DETAIL_VIEWPORT_X, DETAIL_VIEWPORT_Y, DETAIL_VIEWPORT_WIDTH, DETAIL_VIEWPORT_HEIGHT)
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Create Detail Window
  #--------------------------------------------------------------------------
  def create_detail_window
    @detail_windows = Array.new($game_party.max_party_members) do |i|
      Window_DetailFile.new(i)
    end
    @detail_windows.each {|window| 
      window.viewport = @detail_viewport
      window.load_header(@index)
    }
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Create Bottom Window
  #--------------------------------------------------------------------------
  def create_bottom_window
    @bottom_window = Window_BottomFile.new(BOTTOM_WINDOW_X, BOTTOM_WINDOW_Y)
    @bottom_window.load_header(@index)
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Create Scroll Arrows
  #--------------------------------------------------------------------------
  def create_scroll_arrows
    @up_arrow = Sprite.new
    @up_arrow.bitmap = Cache.system(UP_ARROW)
    @up_arrow.x = ARROW_X
    @up_arrow.y = UP_ARROW_Y
    @down_arrow = Sprite.new
    @down_arrow.bitmap = Cache.system(DOWN_ARROW)
    @down_arrow.x = ARROW_X
    @down_arrow.y = DOWN_ARROW_Y
    update_scroll_arrows
  end
  #--------------------------------------------------------------------------
  # * Initialize Selection State
  #--------------------------------------------------------------------------
  def init_selection
    @index = first_savefile_index
    self.top_index = @index - visible_max / 2
    @savefile_windows[@index].selected = true
    ensure_cursor_visible
  end
  #--------------------------------------------------------------------------
  # * Get Number of Items
  #--------------------------------------------------------------------------
  def item_max
    DataManager.savefile_max
  end
  #--------------------------------------------------------------------------
  # * Modified
  # * Get Number of Save Files to Show on Screen
  #--------------------------------------------------------------------------
  def visible_max
    return 7
  end
  #--------------------------------------------------------------------------
  # * Get Height of Save File Window
  #--------------------------------------------------------------------------
  def savefile_height
    @savefile_viewport.rect.height / visible_max
  end
  #--------------------------------------------------------------------------
  # * Get File Index to Select First
  #--------------------------------------------------------------------------
  def first_savefile_index
    return 0
  end
  #--------------------------------------------------------------------------
  # * Get Current Index
  #--------------------------------------------------------------------------
  def index
    @index
  end
  #--------------------------------------------------------------------------
  # * Get Top Index
  #--------------------------------------------------------------------------
  def top_index
    @savefile_viewport.oy / savefile_height
  end
  #--------------------------------------------------------------------------
  # * Set Top Index
  #--------------------------------------------------------------------------
  def top_index=(index)
    index = 0 if index < 0
    index = item_max - visible_max if index > item_max - visible_max
    @savefile_viewport.oy = index * savefile_height
  end
  #--------------------------------------------------------------------------
  # * Get Bottom Index
  #--------------------------------------------------------------------------
  def bottom_index
    top_index + visible_max - 1
  end
  #--------------------------------------------------------------------------
  # * Set Bottom Index
  #--------------------------------------------------------------------------
  def bottom_index=(index)
    self.top_index = index - (visible_max - 1)
  end
  #--------------------------------------------------------------------------
  # * Modified
  # * Update Save File Selection
  #--------------------------------------------------------------------------
  def update_savefile_selection
    return on_savefile_ok     if Input.trigger?(Input::Keys::A)
    return on_savefile_cancel if Input.trigger?(Input::Keys::B)
    update_cursor if @savefile_windows[@index].selected == true
  end
  #--------------------------------------------------------------------------
  # * Save File [OK]
  #--------------------------------------------------------------------------
  def on_savefile_ok
  end
  #--------------------------------------------------------------------------
  # * Save File [Cancel]
  #--------------------------------------------------------------------------
  def on_savefile_cancel
    Sound.play_cancel
    return_scene
  end
  #--------------------------------------------------------------------------
  # * Processing When Cancelling Save Confirmation
  #--------------------------------------------------------------------------
  def on_confirm_cancel
    @system_window.return_context
    @savefile_windows[@index].selected = true
  end
  #--------------------------------------------------------------------------
  # * Update Cursor
  #--------------------------------------------------------------------------
  def update_cursor
    last_index = @index
    cursor_down (Input.trigger?(Input::Keys::DOWN))  if Input.repeat?(Input::Keys::DOWN)
    cursor_up   (Input.trigger?(Input::Keys::UP))    if Input.repeat?(Input::Keys::UP)
    cursor_pagedown   if Input.trigger?(Input::Keys::R)
    cursor_pageup     if Input.trigger?(Input::Keys::L)
    change_window(last_index) if @index != last_index
    update_scroll_arrows if @index != last_index
  end
  #--------------------------------------------------------------------------
  # * Change File Window
  #--------------------------------------------------------------------------
  def change_window(last_index)
    Sound.play_cursor
    @savefile_windows[last_index].selected = false
    reload_windows
  end
  #--------------------------------------------------------------------------
  # * Reload Windows
  #--------------------------------------------------------------------------
  def reload_windows
    @savefile_windows[@index].selected = true
    @bottom_window.load_header(@index)
    @detail_windows.each {|window| window.load_header(@index) }
  end
  #--------------------------------------------------------------------------
  # * Move Cursor Down
  #--------------------------------------------------------------------------
  def cursor_down(wrap)
    @index = (@index + 1) % item_max if @index < item_max - 1 || wrap
    ensure_cursor_visible
  end
  #--------------------------------------------------------------------------
  # * Move Cursor Up
  #--------------------------------------------------------------------------
  def cursor_up(wrap)
    @index = (@index - 1 + item_max) % item_max if @index > 0 || wrap
    ensure_cursor_visible
  end
  #--------------------------------------------------------------------------
  # * Move Cursor One Page Down
  #--------------------------------------------------------------------------
  def cursor_pagedown
    if top_index + visible_max < item_max
      self.top_index += visible_max
      @index = [@index + visible_max, item_max - 1].min
    end
  end
  #--------------------------------------------------------------------------
  # * Move Cursor One Page Up
  #--------------------------------------------------------------------------
  def cursor_pageup
    if top_index > 0
      self.top_index -= visible_max
      @index = [@index - visible_max, 0].max
    end
  end
  #--------------------------------------------------------------------------
  # * Scroll Cursor to Position Within Screen
  #--------------------------------------------------------------------------
  def ensure_cursor_visible
    self.top_index = index if index < top_index
    self.bottom_index = index if index > bottom_index
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Update Scroll Arrows
  #--------------------------------------------------------------------------
  def update_scroll_arrows
    if top_index > 0
      @up_arrow.show
    else
      @up_arrow.hide
    end 
    if bottom_index < (item_max - 1)
      @down_arrow.show
    else
      @down_arrow.hide
    end 
  end
end
