#==============================================================================
# ■ Window_DebugActor
#==============================================================================

class Window_DebugActor < Window_Debug
  
  attr_reader :actor
  
  #--------------------------------------------------------------------------
  # initialize
  #-------------------------------------------------------------------------
  def initialize
    @actor = $game_actors[1]
    super
  end

  #--------------------------------------------------------------------------
  # actor
  #--------------------------------------------------------------------------
  def actor=(actor)
    @actor = actor
    refresh
  end
 
  #--------------------------------------------------------------------------
  # * Override
  # * Processing When L Button (Page Up) Is Pressed
  #--------------------------------------------------------------------------
  def process_pageup
    Sound.play_cursor
    Input.update
    call_handler(:pageup)
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Processing When R Button (Page Down) Is Pressed
  #--------------------------------------------------------------------------
  def process_pagedown
    Sound.play_cursor
    Input.update
    call_handler(:pagedown)
  end
   
end # Window_DebugActor


#==============================================================================
# ■ Window_DebugSkills
#==============================================================================

class Window_DebugSkills < Window_DebugActor
   
  #--------------------------------------------------------------------------
  # make_command_list
  #--------------------------------------------------------------------------
  def make_command_list
    $data_classes[@actor.class_id].learnings.each { |skill|
      name = $data_skills[skill.skill_id].name
      text = sprintf("%s:", name)
      add_command(text, :skills, true, skill.skill_id)
    }
  end
  
  #--------------------------------------------------------------------------
  # draw_item
  #--------------------------------------------------------------------------
  def draw_item(index)
    rect = item_rect_for_text(index)
    skill = $data_skills[@list[index][:ext]]
    contents.clear_rect(rect)
    name = command_name(index)
    draw_item_name(skill, rect.x, rect.y)
    text = @actor.skill_learn?(skill) ? "[LEARNED]" : "[NOT LEARNED]"
    draw_text(rect, text, 2)
  end
   
end # Window_DebugSkills

#==============================================================================
# ■ Window_DebugCapacities
#==============================================================================

class Window_DebugCapacities < Window_DebugActor
    
  #--------------------------------------------------------------------------
  # make_command_list
  #--------------------------------------------------------------------------
  def make_command_list
    $data_classes[@actor.class_id].capacities.each { |capacity_id|
      name = $data_capacities[capacity_id].name
      text = sprintf("%s:", name)
      add_command(text, :capacities, true, capacity_id)
    }
  end
  
  #--------------------------------------------------------------------------
  # draw_item
  #--------------------------------------------------------------------------
  def draw_item(index)
    rect = item_rect_for_text(index)
    capacity = $data_capacities[@list[index][:ext]]
    contents.clear_rect(rect)
    name = command_name(index)
    draw_item_name(capacity, rect.x, rect.y)
    text = @actor.capacity_learn?(capacity) ? "[LEARNED]" : "[NOT LEARNED]"
    draw_text(rect, text, 2)
  end
     
end # Window_DebugCapacities

#==============================================================================
# ■ Window_DebugTitles
#==============================================================================

class Window_DebugTitles < Window_DebugActor
 
  #--------------------------------------------------------------------------
  # make_command_list
  #--------------------------------------------------------------------------
  def make_command_list
    $data_actors[@actor.id].titles.each { |title_id|
      name = $data_titles[title_id].name
      text = sprintf("%s:", name)
      add_command(text, :titles, true, title_id)
    }
  end
  
  #--------------------------------------------------------------------------
  # draw_item
  #--------------------------------------------------------------------------
  def draw_item(index)
    rect = item_rect_for_text(index)
    title = $data_titles[@list[index][:ext]]
    contents.clear_rect(rect)
    name = command_name(index)
    draw_text(rect, name, 0)
    text = @actor.title_unlocked?(title) ? "[EARNED]" : "[NOT EARNED]"
    draw_text(rect, text, 2)
  end
  
end # Window_DebugTitles

#==============================================================================
# ■ Window_DebugRecipes
#==============================================================================

class Window_DebugRecipe < Window_Debug
 
  #--------------------------------------------------------------------------
  # make_command_list
  #--------------------------------------------------------------------------
  def make_command_list
    $data_recipes.each { |recipe|
      next if recipe.nil?
      name = recipe.name
      text = sprintf("%s:", name)
      add_command(text, :recipes, true, recipe.id)
    }
  end
  
  #--------------------------------------------------------------------------
  # draw_item
  #--------------------------------------------------------------------------
  def draw_item(index)
    rect = item_rect_for_text(index)
    recipe = $data_recipes[@list[index][:ext]]
    contents.clear_rect(rect)
    name = command_name(index)
    draw_text(rect, name, 0)
    text = $game_party.recipe_learn?(recipe) ? "[LEARNED]" : "[NOT LEARNED]"
    draw_text(rect, text, 2)
  end
  
end # Window_DebugTitles

#==============================================================================
# ■ Window_DebugCooking
#==============================================================================

class Window_DebugCooking < Window_DebugActor
 
  #--------------------------------------------------------------------------
  # make_command_list
  #--------------------------------------------------------------------------
  def make_command_list
    $data_recipes.each { |recipe|
      next if !$game_party.recipe_learn?(recipe)
      name = recipe.name
      text = sprintf("%s:", name)
      add_command(text, :recipes, true, recipe.id)
    }
  end
  
  #--------------------------------------------------------------------------
  # draw_item
  #--------------------------------------------------------------------------
  def draw_item(index)
    rect = item_rect_for_text(index)
    recipe = $data_recipes[@list[index][:ext]]
    contents.clear_rect(rect)
    name = command_name(index)
    draw_text(rect, name, 0)
    text = @actor.debug_recipe_usage(recipe)
    draw_text(rect, text, 2)
  end
  
  #--------------------------------------------------------------------------
  # cursor_right
  #--------------------------------------------------------------------------
  def cursor_right(wrap = false)
    Sound.play_cursor
    delta = Input.press?(:SHIFT) ? 10 : 1
    delta = Input.press?(:CTRL) ? 100 : delta
    delta.times { @actor.use_recipe($data_recipes[@list[index][:ext]], true) }
    refresh
  end  
  
end # Window_DebugCooking

#==============================================================================
# ■ Window_DebugParty
#==============================================================================

class Window_DebugParty < Window_Debug
 
  #--------------------------------------------------------------------------
  # make_command_list
  #--------------------------------------------------------------------------
  def make_command_list
    add_command("Party Member 1", :member, true, 0)
    add_command("Party Member 2", :member, true, 1)
    add_command("Party Member 3", :member, true, 2)
    add_command("Party Member 4", :member, true, 3)
    add_command("Party Member 5", :member, true, 4)
    add_command("Party Member 6", :member, true, 5)
    add_command("Hunger",         :hunger)
    add_command("Gald",           :gald)
    add_command("Grade",          :grade)
    add_command("Encounters",     :encounters)
    add_command("Combos",         :combos)
  end
  
  #--------------------------------------------------------------------------
  # draw_item
  #--------------------------------------------------------------------------
  def draw_item(index)
    contents.clear_rect(item_rect_for_text(index))
    name = command_name(index)
    draw_text(item_rect_for_text(index), name, 0)
    text = get_parameter(index)
    draw_text(item_rect_for_text(index), text, 2)
  end
  
  #--------------------------------------------------------------------------
  # get_parameter
  #--------------------------------------------------------------------------
  def get_parameter(index)
    case command_symbol(index)
    when :member
      actor = $game_party.all_members[@list[index][:ext]]
      actor.nil? ? "None" : actor.name
    when :hunger
      $game_party.hungry ? "[HUNGRY]" : "[NOT HUNGRY]" 
    when :gald
      $game_party.gold
    when :grade
      $game_party.grade.to_f
    when :encounters
      $game_system.battle_count
    when :combos
      $game_party.max_combo
    else
      return 0
    end
  end
  
  #--------------------------------------------------------------------------
  # set_parameter
  #--------------------------------------------------------------------------
  def set_parameter(value)
    case current_symbol
    when :member
      old_actor_id = $game_party.debug_actors[current_ext]
      $game_party.debug_actors[current_ext] = value if value != 0
      $game_party.debug_actors.pop if value == 0 && current_ext == $game_party.all_members.size - 1
      $game_party.map_leader = $game_party.all_members[0].id if $game_party.map_leader.id == old_actor_id
    when :hunger
      $game_party.hungry = value
    when :gald
      $game_party.gain_gold(value)
    when :grade
      $game_party.gain_grade(value)
    when :encounters
      $game_system.battle_count += value
      $game_system.battle_count = 0 if $game_system.battle_count < 0
    when :combos
      $game_party.new_max_combo($game_party.max_combo + value)
    end
  end
  
  #--------------------------------------------------------------------------
  # cursor_right
  #--------------------------------------------------------------------------
  def cursor_right(wrap = false)
    Sound.play_cursor
    delta = Input.press?(:SHIFT) ? 10 : 1
    delta = Input.press?(:CTRL) ? 100 : delta
    delta = Input.press?(:ALT) ? 1000 : delta
    set_parameter(delta) unless current_symbol == :hunger || current_symbol == :member
    set_parameter(next_actor) if current_symbol == :member
    set_parameter(!$game_party.hungry) if current_symbol == :hunger
    draw_item(index)
    refresh
  end  
  
  #--------------------------------------------------------------------------
  # cursor_left
  #--------------------------------------------------------------------------
  def cursor_left(wrap = false)
    Sound.play_cursor
    delta = Input.press?(:SHIFT) ? -10 : -1
    delta = Input.press?(:CTRL) ? -100 : delta
    delta = Input.press?(:ALT) ? -1000 : delta
    set_parameter(delta) unless current_symbol == :hunger || current_symbol == :member
    set_parameter(prev_actor) if current_symbol == :member
    set_parameter(!$game_party.hungry) if current_symbol == :hunger
    draw_item(index)
    refresh
  end  
  
  #--------------------------------------------------------------------------
  # * Switch to Next Actor
  #--------------------------------------------------------------------------
  def next_actor
    actor = $game_party.all_members[current_ext]
    actor_id = actor ? actor.id : 0
    return actor_id if actor_id == 0 && current_ext > $game_party.all_members.size
    loop do
      actor_id += 1
      if actor_id > ($data_actors.size - 1)
        actor_id = 0 if current_ext == $game_party.all_members.size - 1 && current_ext != 0
        actor_id = 1 if current_ext < $game_party.all_members.size - 1 || current_ext == 0
      end
      break unless $game_party.all_members.include?($game_actors[actor_id])
    end
    return actor_id
  end
  
  #--------------------------------------------------------------------------
  # * Switch to Previous Actor
  #--------------------------------------------------------------------------
  def prev_actor
    actor = $game_party.all_members[current_ext]
    actor_id = actor ? actor.id : 0
    return actor_id if actor_id == 0 && current_ext > $game_party.all_members.size
    loop do
      actor_id -= 1
      if actor_id < 1
        actor_id = 0 if current_ext == $game_party.all_members.size - 1 && current_ext != 0
        actor_id = ($data_actors.size - 1) if current_ext < $game_party.all_members.size - 1 || current_ext == 0
      end
      break unless $game_party.all_members.include?($game_actors[actor_id])
    end
    return actor_id
  end
  
end # Window_DebugParty

#==============================================================================
# ■ Window_DebugActorParams
#==============================================================================

class Window_DebugActorParams < Window_DebugActor
  
  #--------------------------------------------------------------------------
  # make_command_list
  #--------------------------------------------------------------------------
  def make_command_list
    add_command("Level",            :level)
    add_command("Current HP",       :hp)
    add_command("Max HP",           :mhp)
    add_command("Current MP",       :mp)
    add_command("Max MP",           :mmp)
    add_command("Physical Attack",  :patk)
    add_command("Physical Defense", :pdef)
    add_command("Magical Attack",   :matk)
    add_command("Magical Defense",  :mdef)
    add_command("Agility",          :agi)
    add_command("Luck",             :lck)
    add_command("Current SP",       :sp)
    add_command("Max SP",           :msp)
  end
  
  #--------------------------------------------------------------------------
  # draw_item
  #--------------------------------------------------------------------------
  def draw_item(index)
    contents.clear_rect(item_rect_for_text(index))
    name = command_name(index)
    draw_text(item_rect_for_text(index), name, 0)
    text = get_parameter(index)
    draw_text(item_rect_for_text(index), text, 2)
  end
  
  #--------------------------------------------------------------------------
  # get_parameter
  #--------------------------------------------------------------------------
  def get_parameter(index)
    case command_symbol(index)
    when :level
      @actor.level
    when :hp
      @actor.hp
    when :mhp
      @actor.mhp
    when :mp
      @actor.mp
    when :mmp
      @actor.mmp
    when :patk
      @actor.param(2)
    when :pdef
      @actor.param(3)
    when :matk
      @actor.param(4)
    when :mdef
      @actor.param(5)
    when :agi
      @actor.param(6)
    when :lck
      @actor.param(7)
    when :sp
      @actor.sp
    when :msp
      @actor.msp
    else
      return 0
    end
  end
  
  #--------------------------------------------------------------------------
  # set_parameter
  #--------------------------------------------------------------------------
  def set_parameter(value)
    case current_symbol
    when :level
      @actor.change_level(@actor.level + value, false)
    when :hp
      @actor.hp += value
    when :mhp
      @actor.add_param(0, value)
    when :mp
      @actor.mp += value
    when :mmp
      @actor.add_param(1, value)
    when :patk
      @actor.add_param(2, value)
    when :pdef
      @actor.add_param(3, value)
    when :matk
      @actor.add_param(4, value)
    when :mdef
      @actor.add_param(5, value)
    when :agi
      @actor.add_param(6, value)
    when :lck
      @actor.add_param(7, value)
    when :sp
      @actor.sp += value
    when :msp
      @actor.add_max_sp(value)
    end
  end
   
  #--------------------------------------------------------------------------
  # cursor_right
  #--------------------------------------------------------------------------
  def cursor_right(wrap = false)
    Sound.play_cursor
    delta = Input.press?(:SHIFT) ? 10 : 1
    delta = Input.press?(:CTRL) ? 100 : delta
    set_parameter(delta)
    refresh
  end
  
  #--------------------------------------------------------------------------
  # cursor_left
  #--------------------------------------------------------------------------
  def cursor_left(wrap = false)
    Sound.play_cursor
    delta = Input.press?(:SHIFT) ? -10 : -1
    delta = Input.press?(:CTRL) ? -100 : delta
    set_parameter(delta)
    refresh
  end
 
end # Window_DebugActorParams

#==============================================================================
# ■ Window_DebugCrafting
#==============================================================================

class Window_DebugCrafting < Window_Debug
 
  #--------------------------------------------------------------------------
  # make_command_list
  #--------------------------------------------------------------------------
  def make_command_list
   add_command("Synthesis Level", :exp)
  end
  
  #--------------------------------------------------------------------------
  # draw_item
  #--------------------------------------------------------------------------
  def draw_item(index)
    contents.clear_rect(item_rect_for_text(index))
    name = command_name(index)
    draw_text(item_rect_for_text(index), name, 0)
    text = get_parameter(index)
    draw_text(item_rect_for_text(index), text, 2)
  end
  
  #--------------------------------------------------------------------------
  # get_parameter
  #--------------------------------------------------------------------------
  def get_parameter(index)
    case command_symbol(index)
    when :exp
      $game_crafting.synthesis_level
    else
      return 0
    end
  end
  
  #--------------------------------------------------------------------------
  # set_parameter
  #--------------------------------------------------------------------------
  def set_parameter(value)
    case current_symbol
    when :exp
      value.times { $game_crafting.gain_synthesis_exp($game_crafting.next_synthesis_level_exp)}
    end
  end
  
  #--------------------------------------------------------------------------
  # cursor_right
  #--------------------------------------------------------------------------
  def cursor_right(wrap = false)
    Sound.play_cursor
    delta = Input.press?(:SHIFT) ? 10 : 1
    delta = Input.press?(:CTRL) ? 100 : delta
    delta = Input.press?(:ALT) ? 1000 : delta
    set_parameter(delta) 
    draw_item(index)
    refresh
  end  
end #Window_DebugCrafting

#==============================================================================
# ■ Scene_Debug
#==============================================================================

class Scene_Debug < Scene_MenuBase
  
  #--------------------------------------------------------------------------
  # * Switch to Next Actor
  #--------------------------------------------------------------------------
  def next_actor
    index = @actor.id + 1
    index = 1 if index > ($data_actors.size - 1)
    @actor = $game_actors[index]
    on_actor_change
  end
  
  #--------------------------------------------------------------------------
  # * Switch to Previous Actor
  #--------------------------------------------------------------------------
  def prev_actor
    index = @actor.id - 1
    index = ($data_actors.size - 1) if index < 1
    @actor = $game_actors[index]
    on_actor_change
  end
  
  #--------------------------------------------------------------------------
  # overwrite change actors
  #--------------------------------------------------------------------------
  def on_actor_change
    window = @skill_window    if @command_window.current_symbol == :skills 
    window = @capacity_window if @command_window.current_symbol == :capacities 
    window = @title_window    if @command_window.current_symbol == :titles 
    window = @cooking_window  if @command_window.current_symbol == :cooking 
    window = @actor_window    if @command_window.current_symbol == :actors
    @skill_window.actor = @actor
    @capacity_window.actor = @actor
    @title_window.actor = @actor
    @cooking_window.actor = @actor
    @actor_window.actor = @actor
    window.activate
    window.select(0)
    window.refresh
    refresh_help_window
  end
  
  #--------------------------------------------------------------------------
  # new method: create_skill_window
  #--------------------------------------------------------------------------
  def create_skill_windows
    @skill_window = Window_DebugSkills.new
    @skill_window.set_handler(:ok, method(:on_skill_ok))
    @skill_window.set_handler(:cancel, method(:on_skill_cancel))
    @skill_window.set_handler(:pagedown, method(:next_actor))
    @skill_window.set_handler(:pageup,   method(:prev_actor))
  end
  
  #--------------------------------------------------------------------------
  # new method: command_skill
  #--------------------------------------------------------------------------
  def command_skills    
    @dummy_window.hide
    @skill_window.refresh
    @skill_window.show
    @skill_window.activate
    refresh_help_window
  end
  
  #--------------------------------------------------------------------------
  # new method: on_skill_ok
  #--------------------------------------------------------------------------
  def on_skill_ok
    @skill_window.activate
    skill_id = @skill_window.current_ext
    @skill_window.actor.learn_skill(skill_id)
    @skill_window.draw_item(@skill_window.index)
  end
  
  #--------------------------------------------------------------------------
  # * new method: on_skill_cancel
  #--------------------------------------------------------------------------
  def on_skill_cancel
    @dummy_window.show
    @skill_window.hide
    @command_window.activate
    refresh_help_window
  end

  #--------------------------------------------------------------------------
  # new method: create_capacity_window
  #--------------------------------------------------------------------------
  def create_capacity_windows
    @capacity_window = Window_DebugCapacities.new
    @capacity_window.set_handler(:ok, method(:on_capacity_ok))
    @capacity_window.set_handler(:cancel, method(:on_capacity_cancel))
    @capacity_window.set_handler(:pagedown, method(:next_actor))
    @capacity_window.set_handler(:pageup,   method(:prev_actor))
  end
  
  #--------------------------------------------------------------------------
  # new method: command_capacity
  #--------------------------------------------------------------------------
  def command_capacities
    @dummy_window.hide
    @capacity_window.refresh
    @capacity_window.show
    @capacity_window.activate
    refresh_help_window
  end
  
  #--------------------------------------------------------------------------
  # new method: on_capacity_ok
  #--------------------------------------------------------------------------
  def on_capacity_ok
    @capacity_window.activate
    capacity_id = @capacity_window.current_ext
    @capacity_window.actor.learn_capacity(capacity_id)
    @capacity_window.draw_item(@capacity_window.index)
  end
  
  #--------------------------------------------------------------------------
  # * new method: on_capacity_cancel
  #--------------------------------------------------------------------------
  def on_capacity_cancel
    @dummy_window.show
    @capacity_window.hide
    @command_window.activate
    refresh_help_window
  end

  #--------------------------------------------------------------------------
  # new method: create_title_window
  #--------------------------------------------------------------------------
  def create_title_windows
    @title_window = Window_DebugTitles.new
    @title_window.set_handler(:ok, method(:on_title_ok))
    @title_window.set_handler(:cancel, method(:on_title_cancel))
    @title_window.set_handler(:pagedown, method(:next_actor))
    @title_window.set_handler(:pageup,   method(:prev_actor))
  end
  
  #--------------------------------------------------------------------------
  # new method: command_title
  #--------------------------------------------------------------------------
  def command_titles
    @dummy_window.hide
    @title_window.refresh
    @title_window.show
    @title_window.activate
    refresh_help_window
  end
  
  #--------------------------------------------------------------------------
  # new method: on_title_ok
  #--------------------------------------------------------------------------
  def on_title_ok
    @title_window.activate
    title_id = @title_window.current_ext
    @title_window.actor.obtain_title(title_id)
    @title_window.draw_item(@title_window.index)
  end
  
  #--------------------------------------------------------------------------
  # * new method: on_title_cancel
  #--------------------------------------------------------------------------
  def on_title_cancel
    @dummy_window.show
    @title_window.hide
    @command_window.activate
    refresh_help_window
  end
  
  #--------------------------------------------------------------------------
  # new method: create_cooking_window
  #--------------------------------------------------------------------------
  def create_cooking_windows
    @cooking_window = Window_DebugCooking.new
    @cooking_window.set_handler(:cancel, method(:on_cooking_cancel))
    @cooking_window.set_handler(:pagedown, method(:next_actor))
    @cooking_window.set_handler(:pageup,   method(:prev_actor))
  end
  
  #--------------------------------------------------------------------------
  # new method: command_cooking
  #--------------------------------------------------------------------------
  def command_cooking
    @dummy_window.hide
    @cooking_window.refresh
    @cooking_window.show
    @cooking_window.activate
    refresh_help_window
  end
  
  #--------------------------------------------------------------------------
  # * new method: on_cooking_cancel
  #--------------------------------------------------------------------------
  def on_cooking_cancel
    @dummy_window.show
    @cooking_window.hide
    @command_window.activate
    refresh_help_window
  end
  
  #--------------------------------------------------------------------------
  # new method: create_recipe_window
  #--------------------------------------------------------------------------
  def create_recipe_windows
    @recipe_window = Window_DebugRecipe.new
    @recipe_window.set_handler(:ok, method(:on_recipe_ok))
    @recipe_window.set_handler(:cancel, method(:on_recipe_cancel))
  end
  
  #--------------------------------------------------------------------------
  # new method: command_recipe
  #--------------------------------------------------------------------------
  def command_recipes
    @dummy_window.hide
    @recipe_window.show
    @recipe_window.activate
    refresh_help_window
  end
  
  #--------------------------------------------------------------------------
  # new method: on_recipe_ok
  #--------------------------------------------------------------------------
  def on_recipe_ok
    @recipe_window.activate
    recipe_id = @recipe_window.current_ext
    $game_party.learn_recipe(recipe_id)
    @recipe_window.draw_item(@recipe_window.index)
  end
  
  #--------------------------------------------------------------------------
  # * new method: on_recipe_cancel
  #--------------------------------------------------------------------------
  def on_recipe_cancel
    @dummy_window.show
    @recipe_window.hide
    @command_window.activate
    refresh_help_window
  end

  #--------------------------------------------------------------------------
  # new method: create_party_window
  #--------------------------------------------------------------------------
  def create_party_windows
    @party_window = Window_DebugParty.new
    @party_window.set_handler(:cancel, method(:on_party_cancel))
  end
  
  #--------------------------------------------------------------------------
  # new method: command_party
  #--------------------------------------------------------------------------
  def command_party
    @dummy_window.hide
    @party_window.show
    @party_window.activate
    refresh_help_window
  end
  
  #--------------------------------------------------------------------------
  # * new method: on_party_cancel
  #--------------------------------------------------------------------------
  def on_party_cancel
    @dummy_window.show
    @party_window.hide
    @command_window.activate
    refresh_help_window
  end
  
  #--------------------------------------------------------------------------
  # new method: create_actor_window
  #--------------------------------------------------------------------------
  def create_actor_windows
    @actor_window = Window_DebugActorParams.new
    @actor_window.set_handler(:cancel, method(:on_actor_cancel))
    @actor_window.set_handler(:pagedown, method(:next_actor))
    @actor_window.set_handler(:pageup,   method(:prev_actor))
  end
  
  #--------------------------------------------------------------------------
  # new method: command_actors
  #--------------------------------------------------------------------------
  def command_actors
    @dummy_window.hide
    @actor_window.refresh
    @actor_window.show
    @actor_window.activate
    refresh_help_window
  end 
  
  #--------------------------------------------------------------------------
  # * new method: on_actor_cancel
  #--------------------------------------------------------------------------
  def on_actor_cancel
    @dummy_window.show
    @actor_window.hide
    @command_window.activate
    refresh_help_window
  end
  
#--------------------------------------------------------------------------
  # new method: create_crafting_window
  #--------------------------------------------------------------------------
  def create_crafting_windows
    @crafting_window = Window_DebugCrafting.new
    @crafting_window.set_handler(:cancel, method(:on_crafting_cancel))
  end
  
  #--------------------------------------------------------------------------
  # new method: command_recipe
  #--------------------------------------------------------------------------
  def command_crafting
    @dummy_window.hide
    @crafting_window.show
    @crafting_window.activate
    refresh_help_window
  end

  #--------------------------------------------------------------------------
  # * new method: on_crafting_cancel
  #--------------------------------------------------------------------------
  def on_crafting_cancel
    @dummy_window.show
    @crafting_window.hide
    @command_window.activate
    refresh_help_window
  end
end  
