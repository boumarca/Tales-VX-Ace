#==============================================================================
# ** New Class
# ** Window_SkillHelp
#------------------------------------------------------------------------------
#  This window shows skills explanations.
#==============================================================================

class Window_SkillHelp < Window_SimpleHelp
  #--------------------------------------------------------------------------
  # * Constants (Positions)
  #--------------------------------------------------------------------------
  MP_X        = 460
  MP_WIDTH    = 124
  USAGE_X     = 328
  USAGE_WIDTH = 100
  ATTR_X      = 272
  ICON_OFFSET = 93
  #--------------------------------------------------------------------------
  # * Override
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    super
    draw_skill_mp
    draw_skill_usage
    draw_skill_element
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Clear
  #--------------------------------------------------------------------------
  def clear
    set_mp_cost(nil)
    set_usage(nil)
    set_attribute(nil)
    set_skill_type(0)
    super
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Set Item
  #     item : Skills and items etc.
  #--------------------------------------------------------------------------
  def set_item(item)
    set_skill_type(item ? item.stype_id : 0)
    set_mp_cost(item ? item.mp_cost : nil)
    set_usage(item ? item.usage_count : nil)
    set_attribute(item ? item.damage.element_id : nil)
    super
  end
  #--------------------------------------------------------------------------
  # * Set Skill Type
  #--------------------------------------------------------------------------
  def set_skill_type(stype_id)
    @skill_type = stype_id > 0 ? $data_system.skill_types[stype_id] : ""
  end
  #--------------------------------------------------------------------------
  # * Set MP Cost
  #--------------------------------------------------------------------------
  def set_mp_cost(mp_cost)
    if mp_cost != @mp_cost
      @mp_cost = mp_cost
    end
  end
  #--------------------------------------------------------------------------
  # * Set Usage 
  #--------------------------------------------------------------------------
  def set_usage(usage)
    if usage != @usage
      @usage = usage
    end
  end
  #--------------------------------------------------------------------------
  # * Set Attack Attributes
  #--------------------------------------------------------------------------
  def set_attribute(attr)
    if attr != @atk_attr
      @atk_attr = attr
    end
  end
  #--------------------------------------------------------------------------
  # * Override
  # * Draw Skill Description
  #--------------------------------------------------------------------------
  def draw_item_description
    return if @skill_type == ""
    draw_text_ex(10, line_height, sprintf("%s: %s", @skill_type, @text))
  end
  #--------------------------------------------------------------------------
  # * Draw Skill MP Cost
  #--------------------------------------------------------------------------
  def draw_skill_mp
    return unless @mp_cost
    change_color(system_color)
    draw_text(MP_X, 0, MP_WIDTH, line_height, Vocab::MP_COST)
    change_color(normal_color)
    draw_text(MP_X, 0, MP_WIDTH, line_height, @mp_cost, Bitmap::ALIGN_RIGHT)
  end
  #--------------------------------------------------------------------------
  # * Draw Skill Usage
  #--------------------------------------------------------------------------
  def draw_skill_usage
    return unless @usage
    change_color(system_color)
    draw_text(USAGE_X, 0, USAGE_WIDTH, line_height, Vocab::SKILL_USAGE)
    change_color(normal_color)
    draw_text(USAGE_X, 0, USAGE_WIDTH, line_height, @usage, Bitmap::ALIGN_RIGHT)
  end
  #--------------------------------------------------------------------------
  # * Draw Skill Attack Attribute
  #--------------------------------------------------------------------------
  def draw_skill_element
    return unless @atk_attr
    draw_icon(@atk_attr + ICON_OFFSET, ATTR_X, 0)
  end
end