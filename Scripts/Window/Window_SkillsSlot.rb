#==============================================================================
# ** New Class
# ** Window_SkillsSlot
#------------------------------------------------------------------------------
#  This window is for setting the skills for battle usage and character status
#==============================================================================

class Window_SkillsSlot < Window_Selectable
  #--------------------------------------------------------------------------
  # * Constants (Icons)
  #--------------------------------------------------------------------------
  NEUTRAL       = 368
  UP            = 369
  DOWN          = 370
  SIDE          = 371
  S_UP          = 372
  S_DOWN        = 373
  S_LEFT        = 374
  S_RIGHT       = 375
  #--------------------------------------------------------------------------
  # * Constants (Positions)
  #--------------------------------------------------------------------------
  SKILLS_X      = 48
  WINDOW_WIDTH  = 352
  ARROW_X       = 186
  UP_ARROW_Y    = 156
  DOWN_ARROW_Y  = 332
  ICON_WIDTH    = 24
  #--------------------------------------------------------------------------
  # * Constants (Images)
  #--------------------------------------------------------------------------
  UP_ARROW      = "Scroll_arrow_up"
  DOWN_ARROW    = "Scroll_arrow_down"
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :used_from_here   #if skill is used from this window
  attr_reader   :actor
  #--------------------------------------------------------------------------
  # * Override
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y)
    super(x, y, window_width, window_height)
    @actor = nil
    @used_from_here = false
    @shortcut_tab = false
    create_scroll_arrows
    refresh
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
    @up_arrow.z = 200
    @down_arrow = Sprite.new
    @down_arrow.bitmap = Cache.system(DOWN_ARROW)
    @down_arrow.x = ARROW_X
    @down_arrow.y = DOWN_ARROW_Y
    @down_arrow.z = 200
    update_scroll_arrows
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Update Scroll Arrows
  #--------------------------------------------------------------------------
  def update_scroll_arrows
    if skill_tab?
      @up_arrow.opacity = 0
      @down_arrow.opacity = 255
    elsif shortcut_tab?
      @up_arrow.opacity = 255
      @down_arrow.opacity = 0
    end 
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Get Window Width
  #--------------------------------------------------------------------------
  def window_width
    return WINDOW_WIDTH
  end
  #--------------------------------------------------------------------------
  # * Modified
  # * Get Window Height
  #--------------------------------------------------------------------------
  def window_height
    fitting_height(7)
  end
  #--------------------------------------------------------------------------
  # * Set Actor
  #--------------------------------------------------------------------------
  def actor=(actor)
    return if @actor == actor
    @actor = actor
    refresh
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Get Number of Items
  #--------------------------------------------------------------------------
  def item_max
    @actor ? @actor.battle_skills.size : 0
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Get Item
  #--------------------------------------------------------------------------
  def item
    @actor ? @actor.battle_skills[index] : nil
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Get Activation State of Selection Item
  #--------------------------------------------------------------------------
  def current_item_enabled?
    !@item_window.empty?
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Processing When Y Is Pressed
  #--------------------------------------------------------------------------
  def process_y
    if usable?(item)
      @used_from_here = true
      Sound.play_ok
      Input.update
      deactivate
      call_y_handler
    else
      Sound.play_buzzer
    end
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Get Rectangle for Drawing Items
  #--------------------------------------------------------------------------
  def item_rect(index)
    rect = super(index)
    rect.y += line_height
    rect
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Draw Header
  #--------------------------------------------------------------------------
  def draw_header
    header = @shortcut_tab ? Vocab::SHORTCUTS : Vocab::SKILLS
    draw_text(4, 0, contents.width, line_height, header)
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Draw Item
  #--------------------------------------------------------------------------
  def draw_item(index)
    return unless @actor
    rect = item_rect(index)
    draw_skill(rect, index) if skill_tab?
    draw_shortcut(rect, index) if shortcut_tab?
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Draw Skill
  #--------------------------------------------------------------------------
  def draw_skill(rect, index)
    draw_icon(slot_icon(index), rect.x, rect.y)
    draw_item_name(@actor.battle_skills[index], rect.x + SKILLS_X, rect.y, enable?(@actor.battle_skills[index]))
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Draw Shortcut
  #--------------------------------------------------------------------------
  def draw_shortcut(rect, index)
    draw_icon(slot_icon(index), rect.x, rect.y)
    draw_item_name(@actor.shortcuts[index].skill, rect.x + SKILLS_X, rect.y)
    draw_icon(@actor.shortcuts[index].actor.icon_index, rect.width - ICON_WIDTH, rect.y) if !@actor.shortcuts[index].actor.nil?
  end
  #--------------------------------------------------------------------------
  # * Get Skills Slot Name
  #--------------------------------------------------------------------------
  def slot_icon(index)
    icons = [NEUTRAL, UP, DOWN, SIDE] if skill_tab?
    icons = [S_UP, S_DOWN, S_LEFT, S_RIGHT] if shortcut_tab?
    return icons[index]
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Return if Skill is Usable?
  #--------------------------------------------------------------------------
  def usable?(item)
    enable?(item) && @actor.usable?(item)
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Display Skills Slot in Enabled State?
  #--------------------------------------------------------------------------
  def enable?(item)
    return false if item.nil?
    @actor && @actor.skill_cost_payable?(item)
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Move Cursor Right
  #--------------------------------------------------------------------------
  def cursor_right(wrap = false)
    process_cursor_ok unless @item_window.empty? || shortcut_tab?
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Move Cursor Up
  #--------------------------------------------------------------------------
  def cursor_up(wrap = false)
    if row == 0
      process_up
    else
      super
    end
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Move Cursor Down
  #--------------------------------------------------------------------------
  def cursor_down(wrap = false)
    if row == 3 && skill_tab?
      process_down
    else
      super
    end
  end
  #--------------------------------------------------------------------------
  # * Set Item Window
  #--------------------------------------------------------------------------
  def item_window=(item_window)
    @item_window = item_window
    update
  end
  #--------------------------------------------------------------------------
  # * Update Help Text
  #--------------------------------------------------------------------------
  def update_help
    @help_window.set_item(item) if @help_window
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Process Cursor Up
  #--------------------------------------------------------------------------
  def process_up
    Sound.play_cursor
    Input.update
    if skill_tab?
      deactivate
      call_handler(:up)
    elsif shortcut_tab?
      switch_tab
      select(3)
    end
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Process Cursor Down
  #--------------------------------------------------------------------------
  def process_down
    Sound.play_cursor
    Input.update
    switch_tab
    select(0)
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Processing When Start Is Pressed
  #--------------------------------------------------------------------------
  def process_start
    Sound.play_cursor
    super
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Is In Skill Tab
  #--------------------------------------------------------------------------
  def skill_tab?
    !@shortcut_tab
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Is In Shortcut Tab
  #--------------------------------------------------------------------------
  def shortcut_tab?
    @shortcut_tab
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Switch tab
  #--------------------------------------------------------------------------
  def switch_tab
    @shortcut_tab = !@shortcut_tab
    update_scroll_arrows
    call_handler(:switch_tab)
    refresh
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    super
    draw_header
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Show Window
  #--------------------------------------------------------------------------
  def show
    @up_arrow.show if shortcut_tab?
    @down_arrow.show if skill_tab?
    super
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Hide Window
  #--------------------------------------------------------------------------
  def hide
    @up_arrow.hide
    @down_arrow.hide
    super
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Free
  #--------------------------------------------------------------------------
  def dispose
    @up_arrow.dispose
    @down_arrow.dispose
    super
  end
end