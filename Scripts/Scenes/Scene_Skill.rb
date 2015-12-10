#==============================================================================
# ** Scene_Skill
#------------------------------------------------------------------------------
#  This class performs skills screen processing. Skills are handled as items for
# the sake of process sharing.
#==============================================================================

class Scene_Skill < Scene_ItemBase
  #--------------------------------------------------------------------------
  # * Constants (Positions)
  #--------------------------------------------------------------------------
  CONTROL_WINDOW_Y  = 12
  HELP_WINDOW_X     = 16
  HELP_WINDOW_Y     = 340
  STATUS_WINDOW_X   = 16
  STATUS_WINDOW_Y   = 52
  MANUAL_WINDOW_X   = 368
  MANUAL_WINDOW_Y   = 52
  AUTO_WINDOW_X     = 16
  AUTO_WINDOW_Y     = 148
  SLOT_WINDOW_X     = 16
  SLOT_WINDOW_Y     = 148
  #--------------------------------------------------------------------------
  # * Modified
  # * Start Processing
  #--------------------------------------------------------------------------
  def start
    super
    create_header_window(Vocab::SKILLS)
    create_help_window
    create_control_window
    create_status_window
    create_auto_skills_list
    create_manual_skills_list
    create_skills_slot_window
    @shortcut_selection = false
    set_controls_help
  end
  #--------------------------------------------------------------------------
  # * Modified
  # * Create Status Window
  #--------------------------------------------------------------------------
  def create_status_window
    @status_window = Window_ActorStatus.new(STATUS_WINDOW_X, STATUS_WINDOW_Y)
    @status_window.actor = @actor
    @status_window.set_handler(:ok,       method(:on_status_ok))
    @status_window.set_handler(:cancel,   method(:on_status_cancel))
    @status_window.set_handler(:select,    method(:on_toggle_control))
    @status_window.set_handler(:pagedown, method(:next_actor))
    @status_window.set_handler(:pageup,   method(:prev_actor))
    @status_window.activate
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Create Control Window
  #--------------------------------------------------------------------------
  def create_control_window
    @control_window = Window_SkillsControl.new(0, CONTROL_WINDOW_Y)
    @control_window.x = Graphics.width - 16 - @control_window.width
    @control_window.select_symbol(@actor.battle_control)
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Create Auto Skills List
  #--------------------------------------------------------------------------
  def create_auto_skills_list
    @auto_list_window = Window_AutoSkillsList.new(AUTO_WINDOW_X, AUTO_WINDOW_Y)
    @auto_list_window.set_handler(:ok,       method(:on_auto_ok))
    @auto_list_window.set_handler(:cancel,   method(:return_scene))
    @auto_list_window.set_handler(:up,       method(:status_return))
    @auto_list_window.set_handler(:x,        method(:on_auto_ok))
    @auto_list_window.set_handler(:y,        method(:on_skills_use))
    @auto_list_window.set_handler(:pagedown, method(:next_actor))
    @auto_list_window.set_handler(:pageup,   method(:prev_actor))
    @auto_list_window.actor = @actor
    @auto_list_window.help_window = @help_window
    @auto_list_window.hide if !@actor.auto?
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Create Manual Skills List
  #--------------------------------------------------------------------------
  def create_manual_skills_list
    @manual_list_window = Window_ManualSkillsList.new(MANUAL_WINDOW_X, MANUAL_WINDOW_Y)
    @manual_list_window.set_handler(:ok,     method(:on_manual_ok))
    @manual_list_window.set_handler(:cancel, method(:on_manual_cancel))
    @manual_list_window.set_handler(:y,      method(:on_skills_use))
    @manual_list_window.actor = @actor
    @manual_list_window.help_window = @help_window
    @manual_list_window.hide if @actor.auto?
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Create Skills Slot Window
  #--------------------------------------------------------------------------
  def create_skills_slot_window
    @slot_window = Window_SkillsSlot.new(SLOT_WINDOW_X, SLOT_WINDOW_Y)
    @slot_window.set_handler(:ok,         method(:on_slot_ok))
    @slot_window.set_handler(:cancel,     method(:return_scene))
    @slot_window.set_handler(:up,         method(:status_return))
    @slot_window.set_handler(:x,          method(:command_clear))
    @slot_window.set_handler(:y,          method(:on_skills_use))
    @slot_window.set_handler(:pagedown,   method(:next_actor))
    @slot_window.set_handler(:pageup,     method(:prev_actor))
    @slot_window.set_handler(:switch_tab, method(:set_controls_help))
    @slot_window.actor = @actor
    @slot_window.help_window = @help_window
    @slot_window.item_window = @manual_list_window
    @slot_window.hide if @actor.auto?
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Create Help Window
  #--------------------------------------------------------------------------
  def create_help_window
    @help_window = Window_SkillHelp.new(HELP_WINDOW_X, HELP_WINDOW_Y)
  end
  #--------------------------------------------------------------------------
  # * Get Skill's User
  #--------------------------------------------------------------------------
  def user
    @actor
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * [Remove] Command
  #--------------------------------------------------------------------------
  def command_clear
    if @slot_window.skill_tab?
      if !@actor.battle_skills[@slot_window.index].nil?
        Sound.play_ok
        @actor.change_skill(@slot_window.index, nil)
        @slot_window.refresh
        @help_window.clear
      else
        Sound.play_buzzer
      end
    elsif @slot_window.shortcut_tab?
      if !@actor.shortcuts[@slot_window.index].empty?
        Sound.play_ok
        @actor.change_shortcut(@slot_window.index, nil, nil)
        @slot_window.refresh
        @help_window.clear
      else
        Sound.play_buzzer
      end
    end
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Status Window [Ok]
  #--------------------------------------------------------------------------
  def on_status_ok
    if @shortcut_selection
      @manual_list_window.activate.select(0)
    else
      if @actor.auto?
        @auto_list_window.activate.select(0)
      else
        @slot_window.activate.select(0)
      end
    end
    set_controls_help
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Status Window [Cancel]
  #--------------------------------------------------------------------------
  def on_status_cancel
    if @shortcut_selection
      @slot_window.activate.select(@slot_window.index)
      reset_actor
      enable_commands
      @shortcut_selection = false
      set_controls_help
    else
      return_scene
    end
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Auto Window [Ok]
  #--------------------------------------------------------------------------
  def on_auto_ok
    toggle_auto_battle_use(@auto_list_window.item)
    @auto_list_window.redraw_current_item
    @auto_list_window.activate
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Toggle Skill Use
  #--------------------------------------------------------------------------
  def toggle_auto_battle_use(skill)
    if @actor.skill_active?(skill)
      @actor.deactivate_skill(skill)
    else
      @actor.activate_skill(skill)
    end
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Return to Status Window
  #--------------------------------------------------------------------------
  def status_return
    @auto_list_window.unselect if @actor.auto?
    @slot_window.unselect if !@actor.auto?
    @status_window.activate
    @help_window.clear
    set_controls_help
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Manual Window [Ok]
  #--------------------------------------------------------------------------
  def on_manual_ok
    Sound.play_ok
    if @shortcut_selection
      @slot_window.actor.change_shortcut(@slot_window.index, @actor, @manual_list_window.item)
      reset_actor
      enable_commands
      @shortcut_selection = false
    else
      @actor.change_skill(@slot_window.index, @manual_list_window.item)
    end
    @slot_window.activate.refresh
    @manual_list_window.unselect
    @manual_list_window.refresh
    set_controls_help
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Manual Window [Cancel]
  #--------------------------------------------------------------------------
  def on_manual_cancel
    @manual_list_window.deactivate.unselect
    if @shortcut_selection
      @status_window.activate
      @help_window.clear
    else
      @slot_window.activate
    end
    set_controls_help
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Slot Window [Ok]
  #--------------------------------------------------------------------------
  def on_slot_ok
    if @slot_window.shortcut_tab?
      @shortcut_selection = true
      disable_commands
      @status_window.activate
      @help_window.clear
    else
      @manual_list_window.activate.select_item(@slot_window.item)
    end
    set_controls_help
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * [Use Skills]
  #--------------------------------------------------------------------------
  def on_skills_use
    @item_window = active_window
    @item_window.used_from_here = false
    @actor.last_skill.object = item
    determine_item
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * [Toggle Control]
  #--------------------------------------------------------------------------
  def on_toggle_control
    @actor.toggle_control
    @control_window.select_symbol(@actor.battle_control)
    switch_windows
    @slot_window.deactivate.unselect if @actor.semi_auto?
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Get Active Window For Item Use
  #--------------------------------------------------------------------------
  def active_window
    return @auto_list_window   if @auto_list_window.used_from_here
    return @manual_list_window if @manual_list_window.used_from_here
    return @slot_window        if @slot_window.used_from_here
  end
  #--------------------------------------------------------------------------
  # * Play SE When Using Item
  #--------------------------------------------------------------------------
  def play_se_for_item
    Sound.play_use_skill
  end
  #--------------------------------------------------------------------------
  # * Modified
  # * Use Item
  #--------------------------------------------------------------------------
  def use_item
    super
    @status_window.refresh
    @slot_list_window.refresh if !@actor.auto?
    @manual_list_window.refresh if !@actor.auto?
    @auto_list_window.refresh if @actor.auto?
  end
  #--------------------------------------------------------------------------
  # * Modified
  # * Change Actors
  #--------------------------------------------------------------------------
  def on_actor_change
    if @shortcut_selection
      @manual_list_window.actor = @actor
      @status_window.actor = @actor
    else
      last_control = @control_window.current_symbol
      @auto_list_window.actor = @actor
      @manual_list_window.actor = @actor
      @slot_window.actor = @actor
      @slot_window.switch_tab if @slot_window.shortcut_tab?
      @status_window.actor = @actor
      @control_window.select_symbol(@actor.battle_control)
      last_control != @actor.battle_control ? switch_windows : reactive_windows
      @help_window.clear
    end
  end
  #--------------------------------------------------------------------------
  # * Modified
  # * Update windows
  #--------------------------------------------------------------------------
  def switch_windows
    if @actor.auto?
      @manual_list_window.hide
      @slot_window.hide.deactivate.unselect
      @auto_list_window.show.refresh
      @status_window.activate.select(0)
    else
      @auto_list_window.hide.deactivate.unselect
      @manual_list_window.show
      @slot_window.show.refresh
      @status_window.activate.select(0)
    end
    set_controls_help
  end
  #--------------------------------------------------------------------------
  # * Activate windows after actor change
  #--------------------------------------------------------------------------
  def reactive_windows
    @auto_list_window.deactivate.unselect if @actor.auto?
    @slot_window.deactivate.unselect if @actor.manual?
    @status_window.activate.select(0)
    set_controls_help
  end
  #--------------------------------------------------------------------------
  # * Activate Item Window
  #--------------------------------------------------------------------------
  def activate_item_window
    super
    @item_window = nil
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Enable Commands After Shortcut
  #--------------------------------------------------------------------------
  def enable_commands
    @status_window.commands_disabled = false
    @manual_list_window.commands_disabled = false
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Disable Commands For Shortcut
  #--------------------------------------------------------------------------
  def disable_commands
    @status_window.commands_disabled = true
    @manual_list_window.commands_disabled = true
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Reset Actor After Shortcut
  #--------------------------------------------------------------------------
  def reset_actor
    @actor = @slot_window.actor
    $game_party.menu_actor = @actor
    @status_window.actor = @actor
    @manual_list_window.actor = @actor
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Set Control Help 
  #--------------------------------------------------------------------------
  def set_controls_help
    @control_help_window.clear
    set_status_controls if @status_window.active
    set_auto_controls   if @auto_list_window.active
    set_manual_controls if @manual_list_window.active
    set_slots_controls  if @slot_window.active
    set_actor_controls  if @actor_window.active
    @control_help_window.refresh
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Set Controls For Command Window 
  #--------------------------------------------------------------------------
  def set_status_controls
    @control_help_window.add_control(Vocab::SKILLS,               :A) 
    @control_help_window.add_control(Vocab::BACK,                 :B)
    @control_help_window.add_control(Vocab::CHANGE_ACTOR,         :L, :R)
    @control_help_window.add_control(Vocab::CHANGE_CONTROL_MODE,  :Z)  unless @status_window.commands_disabled
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Set Controls For Auto Window 
  #--------------------------------------------------------------------------
  def set_auto_controls
    @control_help_window.add_control(Vocab::TOGGLE,       :A, :X)
    @control_help_window.add_control(Vocab::BACK,         :B)
    @control_help_window.add_control(Vocab::USE,          :Y)
    @control_help_window.add_control(Vocab::CHANGE_ACTOR, :L, :R)
    @control_help_window.add_control(Vocab::DESCRIPTION,  :C)
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Set Controls For Manual Window 
  #--------------------------------------------------------------------------
  def set_manual_controls
    @control_help_window.add_control(Vocab::CONFIRM,      :A)
    @control_help_window.add_control(Vocab::BACK,         :B)
    @control_help_window.add_control(Vocab::USE,          :Y) unless @manual_list_window.commands_disabled
    @control_help_window.add_control(Vocab::DESCRIPTION,  :C)
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Set Controls For Slots Window 
  #--------------------------------------------------------------------------
  def set_slots_controls
    @control_help_window.add_control(Vocab::SKILLS,       :A)
    @control_help_window.add_control(Vocab::BACK,         :B)
    @control_help_window.add_control(Vocab::REMOVE,       :X)
    @control_help_window.add_control(Vocab::USE,          :Y) unless @slot_window.shortcut_tab?
    @control_help_window.add_control(Vocab::DESCRIPTION,  :C)
    @control_help_window.add_control(Vocab::CHANGE_ACTOR, :L, :R)
  end
  #--------------------------------------------------------------------------
  # * New Method
  # * Set Controls For Actor Window 
  #--------------------------------------------------------------------------
  def set_actor_controls
    @control_help_window.add_control(Vocab::CONFIRM, :A)
    @control_help_window.add_control(Vocab::BACK,    :B)
  end
end
