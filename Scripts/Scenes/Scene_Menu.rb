#==============================================================================
# ** Scene_Menu
#------------------------------------------------------------------------------
#  This class performs the menu screen processing.
#==============================================================================

class Scene_Menu < Scene_MenuBase
  #--------------------------------------------------------------------------
  # * Constants (Positions)
  #--------------------------------------------------------------------------
  COMMAND_WINDOW_X    = 16
  COMMAND_WINDOW_Y    = 12
  SIDE_WINDOW_X       = 476
  SIDE_WINDOW_Y       = 76
  SUBWINDOW_X         = 496
  LIBRAIRIES_WINDOW_Y = 44
  SYSTEM_WINDOW_Y     = 68
  VIEWPORT_X          = 16
  VIEWPORT_Y          = 76
  VIEWPORT_WIDTH      = 460  
  VIEWPORT_HEIGHT     = 384
  ARROW_X             = 238
  UP_ARROW_Y          = 80
  DOWN_ARROW_Y        = 448
  CRAFTING_WINDOW_X   = 142
  #--------------------------------------------------------------------------
  # * Constants (Images)
  #--------------------------------------------------------------------------
  UP_ARROW            = "Scroll_arrow_up"
  DOWN_ARROW          = "Scroll_arrow_down"
  #--------------------------------------------------------------------------
  # * Class Variable
  #--------------------------------------------------------------------------
  @@editing_formation = false
  #--------------------------------------------------------------------------
  # * Modified
  # * Start Processing
  #--------------------------------------------------------------------------
  def start
    super
    create_command_window
    create_side_window
    create_crafting_window
    create_librairies_window
    create_system_window
    create_actor_viewport
    create_actor_windows
    create_scroll_arrows
    @index = 0
    @pending_index = -1 
    init_selection(select_last) if @@editing_formation
    set_controls_help
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Termination Processing
  #--------------------------------------------------------------------------
  def terminate
    super
    @actor_viewport.dispose
    @actor_windows.each {|window| window.dispose }
    @up_arrow.dispose
    @down_arrow.dispose
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    @actor_windows.each {|window| window.update }
    update_actor_selection
  end
  #--------------------------------------------------------------------------
  # * Modified
  # * Create Command Window
  #--------------------------------------------------------------------------
  def create_command_window
    @command_window = Window_MenuCommand.new(COMMAND_WINDOW_X, COMMAND_WINDOW_Y)
    @command_window.set_handler(:skills,     method(:command_personal))
    @command_window.set_handler(:capacities, method(:command_personal))
    @command_window.set_handler(:equip,      method(:command_personal))
    @command_window.set_handler(:learning,   method(:command_personal))
    @command_window.set_handler(:librairies, method(:command_librairies))
    @command_window.set_handler(:item,       method(:command_item))
    @command_window.set_handler(:crafting,   method(:command_crafting))
    #@command_window.set_handler(:strategy,   method(:command_strategy))
    @command_window.set_handler(:cooking,    method(:command_cooking))
    @command_window.set_handler(:system,     method(:command_system))
    @command_window.set_handler(:formation,  method(:command_formation))
    @command_window.set_handler(:cancel,     method(:return_scene))
    @command_window.deactivate.unselect if @@editing_formation
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Create Side Window
  #--------------------------------------------------------------------------
  def create_side_window
    @side_window = Window_Side.new(SIDE_WINDOW_X, SIDE_WINDOW_Y)
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Create Crafting Window
  #--------------------------------------------------------------------------
  def create_crafting_window
    @crafting_window = Window_CraftingCommand.new(CRAFTING_WINDOW_X, SYSTEM_WINDOW_Y)
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Create Librairies Window
  #--------------------------------------------------------------------------
  def create_librairies_window
    @librairies_window = Window_LibrairiesCommand.new(SUBWINDOW_X, LIBRAIRIES_WINDOW_Y)
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Create System Window
  #--------------------------------------------------------------------------
  def create_system_window
    @system_menu = Window_SystemCommand.new(SUBWINDOW_X, SYSTEM_WINDOW_Y)
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Create Actor Viewport
  #--------------------------------------------------------------------------
  def create_actor_viewport
    @actor_viewport = Viewport.new(VIEWPORT_X, VIEWPORT_Y, VIEWPORT_WIDTH, VIEWPORT_HEIGHT)
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Create Actor Windows
  #--------------------------------------------------------------------------
  def create_actor_windows
    @actor_windows = Array.new(item_max) do |i|
      Window_MenuStatus.new(i)
    end
    @actor_windows.each {|window| window.viewport = @actor_viewport }
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
  # * [Skills], [Capacities], [Equipment] and [Status] Commands
  #--------------------------------------------------------------------------
  def command_personal
    init_selection(select_last)
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * [Librairies] Command
  #--------------------------------------------------------------------------
  def command_librairies
    @librairies_window.select_last
    @librairies_window.activate
    #@librairies_window.set_handler(:ok,     method(:on_sub_librairies_ok))
    @librairies_window.set_handler(:cancel, method(:on_sub_librairies_cancel))
  end
  #--------------------------------------------------------------------------
  # * [Item] Command
  #--------------------------------------------------------------------------
  def command_item
    SceneManager.call(Scene_Item)
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * [Crafting] Command
  #--------------------------------------------------------------------------
  def command_crafting
    @crafting_window.select_last
    @crafting_window.activate
    @crafting_window.set_handler(:ok,     method(:on_sub_crafting_ok))
    @crafting_window.set_handler(:cancel, method(:on_sub_crafting_cancel))
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * [Strategy] Command
  #--------------------------------------------------------------------------
  def command_strategy
    #SceneManager.call(Scene_Item)
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * [Cooking] Command
  #--------------------------------------------------------------------------
  def command_cooking
    SceneManager.call(Scene_Cooking)
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * [System] Command
  #--------------------------------------------------------------------------
  def command_system
    @system_menu.activate.select_last
    @system_menu.set_handler(:ok,     method(:on_sub_system_ok))
    @system_menu.set_handler(:cancel, method(:on_sub_system_cancel))
  end
  #--------------------------------------------------------------------------
  # * Modified
  # * [OK] Personal Command
  #--------------------------------------------------------------------------
  def on_personal_ok
    Sound.play_ok
    $game_party.menu_actor = $game_party.members[@index]
    case @command_window.current_symbol
    when :skills
      SceneManager.call(Scene_Skill)
    when :capacities
      SceneManager.call(Scene_Capacity)
    when :equip
      SceneManager.call(Scene_Equip)
    when :learning
      #SceneManager.call(Scene_Status)
    end
  end
  #--------------------------------------------------------------------------
  # * [Cancel] Personal Command
  #--------------------------------------------------------------------------
  def on_personal_cancel
    Sound.play_cancel
    exit_selection
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * [OK] Sub Crafting Command
  #--------------------------------------------------------------------------
  def on_sub_crafting_ok
    case @crafting_window.current_symbol
    when :synthesis
      SceneManager.call(Scene_Synthesis)
    when :enhance
      #SceneManager.call(Scene_Status)
    end
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * [Cancel] Sub Crafting Command
  #--------------------------------------------------------------------------
  def on_sub_crafting_cancel
    @crafting_window.deactivate
    @command_window.activate
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * [OK] Sub Librairies Command
  #--------------------------------------------------------------------------
  def on_sub_librairies_ok
    case @librairies_window.current_symbol
    when :synopsis
      #SceneManager.call(Scene_Skill)
    when :world_map
      #SceneManager.call(Scene_Skill)
    when :monster_list
      #SceneManager.call(Scene_Equip)
    when :collector_book
      #SceneManager.call(Scene_Status)
    end
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * [Cancel] Sub Librairies Command
  #--------------------------------------------------------------------------
  def on_sub_librairies_cancel
    @librairies_window.deactivate
    @command_window.activate
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * [OK] Sub System Command
  #--------------------------------------------------------------------------
  def on_sub_system_ok
    case @system_menu.current_symbol
    when :save
      SceneManager.call(Scene_Save)
    when :load
      SceneManager.call(Scene_Load)
    when :options
      #SceneManager.call(Scene_Equip)
    when :title_screen
      SceneManager.call(Scene_End)
    end
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * [Cancel] Sub System Command
  #--------------------------------------------------------------------------
  def on_sub_system_cancel
    @system_menu.deactivate
    @command_window.activate
  end
  #--------------------------------------------------------------------------
  # * Modified
  # * [Formation] Command
  #--------------------------------------------------------------------------
  def command_formation
    @command_window.unselect
    @@editing_formation = true
    init_selection(0)
  end
  #--------------------------------------------------------------------------
  # * Modified
  # * Formation [Ok]
  #--------------------------------------------------------------------------
  def on_formation_ok
    Sound.play_ok
    $game_party.menu_actor = $game_party.members[@index]
    SceneManager.call(Scene_Status)
  end
  #--------------------------------------------------------------------------
  # * Modified
  # * Formation [Cancel]
  #--------------------------------------------------------------------------
  def on_formation_cancel
    Sound.play_cancel
    if @pending_index >= 0
      @actor_windows[@pending_index].pending = false
      @actor_windows[@pending_index].refresh
      @pending_index = -1
    else
      @@editing_formation = false
      exit_selection
    end
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Formation [Y] : Set Leader
  #--------------------------------------------------------------------------
  def on_formation_leader
    Sound.play_ok
    last_index = $game_party.map_leader.index
    $game_party.map_leader = $game_party.members[@index].id
    @actor_windows[last_index].refresh
    @actor_windows[@index].refresh
  end
  #--------------------------------------------------------------------------
  # * Formation [X] : Switch Formation
  #--------------------------------------------------------------------------
  def on_formation_switch
    Sound.play_ok
    if @pending_index >= 0
      $game_party.swap_order(@index, @pending_index)
      @actor_windows[@pending_index].pending = false
      @actor_windows[@index].refresh
      @actor_windows[@pending_index].refresh
      @pending_index = -1
      set_controls_help
    else
      @pending_index = @index
      @actor_windows[@pending_index].pending = true
      @actor_windows[@pending_index].refresh
      set_controls_help
    end
  end
  #--------------------------------------------------------------------------
  # * Initialize Selection State
  #--------------------------------------------------------------------------
  def init_selection(index)
    @index = index
    self.top_index = @index - visible_max / 2
    ensure_cursor_visible
    @actor_windows[@index].selected = true
    Input.update
    set_controls_help
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Exit Selection State
  #--------------------------------------------------------------------------
  def exit_selection
    @actor_windows[@index].selected = false
    @command_window.activate.select_last
    set_controls_help
  end
  #--------------------------------------------------------------------------
  # * Modified
  # * Get Number of Party Members
  #--------------------------------------------------------------------------
  def item_max
    $game_party.all_members.size
  end
  #--------------------------------------------------------------------------
  # * Modified
  # * Get Number of Actors to Show on Screen
  #--------------------------------------------------------------------------
  def visible_max
    return [4, item_max].min
  end
  #--------------------------------------------------------------------------
  # * Get Height of Actor Window
  #--------------------------------------------------------------------------
  def actor_height
    return 96
  end
  #--------------------------------------------------------------------------
  # * Get Top Index
  #--------------------------------------------------------------------------
  def top_index
    @actor_viewport.oy / actor_height
  end
  #--------------------------------------------------------------------------
  # * Modified
  # * Set Top Index
  #--------------------------------------------------------------------------
  def top_index=(index)
    index = 0 if index < 0
    index = item_max - visible_max if index > item_max - visible_max
    @actor_viewport.oy = index * actor_height
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
  # * Update Actor Selection
  #--------------------------------------------------------------------------
  def update_actor_selection
    return on_formation_ok     if Input.trigger?(:A) && @@editing_formation && @pending_index == -1
    return on_formation_cancel if Input.trigger?(:B) && @@editing_formation
    return on_formation_switch if Input.trigger?(:X) && @@editing_formation
    return on_formation_leader if Input.trigger?(:Y) && @@editing_formation && @pending_index == -1
    return on_personal_ok      if Input.trigger?(:A)
    return on_personal_cancel  if Input.trigger?(:B)
    update_cursor if @actor_windows[@index].selected == true
  end
  #--------------------------------------------------------------------------
  # * Update Cursor
  #--------------------------------------------------------------------------
  def update_cursor
    last_index = @index
    cursor_down (Input.trigger?(:DOWN))  if Input.repeat?(:DOWN)
    cursor_up   (Input.trigger?(:UP))    if Input.repeat?(:UP)
    change_window(last_index) if @index != last_index
    update_scroll_arrows if @index != last_index
  end
  #--------------------------------------------------------------------------
  # * Change File Window
  #--------------------------------------------------------------------------
  def change_window(last_index)
    Sound.play_cursor
    @actor_windows[last_index].selected = false
    @actor_windows[@index].selected = true
  end
  #--------------------------------------------------------------------------
  # * Move Cursor Down
  #--------------------------------------------------------------------------
  def cursor_down(wrap = false)
    @index = (@index + 1) % item_max if @index < item_max - 1
    ensure_cursor_visible
  end
  #--------------------------------------------------------------------------
  # * Move Cursor Up
  #--------------------------------------------------------------------------
  def cursor_up(wrap = false)
    if @@editing_formation && @index == 0
      Sound.play_cursor
      @actor_windows[@pending_index].pending = false
      @actor_windows[@pending_index].refresh
      @pending_index = -1      
      @@editing_formation = false 
      exit_selection
    else
      @index = (@index - 1 + item_max) % item_max if @index > 0
      ensure_cursor_visible
    end
  end
  #--------------------------------------------------------------------------
  # * Scroll Cursor to Position Within Screen
  #--------------------------------------------------------------------------
  def ensure_cursor_visible
    self.top_index = @index if @index < top_index
    self.bottom_index = @index if @index > bottom_index
  end
  #--------------------------------------------------------------------------
  # * Restore Previous Selection Position
  #--------------------------------------------------------------------------
  def select_last
    return $game_party.menu_actor.index || 0
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
    if bottom_index < ($game_party.members.size - 1)
      @down_arrow.show
    else
      @down_arrow.hide
    end 
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Set Control Help 
  #--------------------------------------------------------------------------
  def set_controls_help
    @control_help_window.clear
    set_formation_controls if @@editing_formation
    set_command_controls if @command_window.active || !@@editing_formation
    @control_help_window.refresh
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Set Controls For Command Window 
  #--------------------------------------------------------------------------
  def set_command_controls
    @control_help_window.add_control(Vocab::CONFIRM,  :A)
    @control_help_window.add_control(Vocab::BACK,     :B)
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Set Formation Controls Help
  #--------------------------------------------------------------------------
  def set_formation_controls
    @control_help_window.add_control(Vocab::STATUS,   :A) if @pending_index == -1
    @control_help_window.add_control(Vocab::BACK,     :B)  
    @control_help_window.add_control(Vocab::SWAP,     :X)
    @control_help_window.add_control(Vocab::LEADER,   :Y) if @pending_index == -1
  end
end
