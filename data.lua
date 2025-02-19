local data_util = require("__flib__.data-util")
local styles = data.raw["gui-style"].default

styles.milestones_inner_frame = {
    type = "frame_style",
    parent = "inside_shallow_frame_with_padding",
    vertically_stretchable = "on",
    vertical_flow_style = {
      type = "vertical_flow_style",
      horizontal_align = "center",
      vertical_spacing = 8,
    }
}

styles.milestones_deep_frame_in_shallow_frame = {
  type = "frame_style",
  parent = "deep_frame_in_shallow_frame",
  left_padding = 8,
  right_padding = 8,
  top_padding = 4,
  bottom_padding = 4,
  minimal_width = 400
}

styles.milestones_horizontal_flow = {
  type = "horizontal_flow_style",
  parent = "horizontal_flow",
  vertical_align = "center",
  minimal_width = 150,
  horizontal_spacing = 8
}

styles.milestones_table_style = {
  type = "table_style",
  horizontal_spacing = 32
}

styles.milestones_small_button = {
  type = "button_style",
  parent = "frame_button",
  width = 16,
  height = 16
}

styles.milestones_trash_button = {
  type = "button_style",
  parent = "tool_button_red",
  width = 24,
  height = 24,
  padding = 0
}

styles.milestones_confirm_button = {
  type = "button_style",
  parent = "tool_button_green",
  width = 24,
  height = 24,
  padding = 0
}

styles.milestones_empty_button = {
  type = "empty_widget_style",
  width = 16,
  height = 16
}

styles.milestones_small_dropdown = {
  type = "dropdown_style",
  minimal_width = 75
}

styles.milestones_small_textfield = {
  type = "textbox_style",
  width = 50,
  natural_width = 50
}

data:extend{
    {
        type = "custom-input",
        name = "milestones_toggle_gui",
        key_sequence = "CONTROL + ALT + M",
        order = "a"
    },
    {
      type = "custom-input",
      name = "milestones_confirm_settings",
      key_sequence = "",
      linked_game_control = "confirm-gui"
    },
    {
      type = "custom-input",
      name = "milestones_cancel_settings",
      key_sequence = "",
      linked_game_control = "toggle-menu"
    }
}

local shortcut_icon = "__Milestones__/graphics/shortcut-icon.png"
data:extend{
  {
    type = "shortcut",
    name = "milestones_toggle_gui",
    icon = data_util.build_sprite(nil, {0,0}, shortcut_icon, 32, 2),
    disabled_icon = data_util.build_sprite(nil, {48,0}, shortcut_icon, 32, 2),
    small_icon = data_util.build_sprite(nil, {0,32}, shortcut_icon, 24, 2),
    disabled_small_icon = data_util.build_sprite(nil, {36,32}, shortcut_icon, 24, 2),
    associated_control_input = "milestones_toggle_gui",
    toggleable = true,
    action = "lua"
  }
}

-- Sprites
local toolbar_icons = "__Milestones__/graphics/toolbar-icons.png"
local arrows = "__Milestones__/graphics/arrows.png"
local item_icons = "__Milestones__/graphics/item-icons.png"
data:extend{
  data_util.build_sprite("milestones_main_icon_white", {48,0}, shortcut_icon, 32, 2),

  data_util.build_sprite("milestones_settings_black", {0, 0}, toolbar_icons, 32),
  data_util.build_sprite("milestones_settings_white", {32, 0}, toolbar_icons, 32),
  data_util.build_sprite("milestones_settings_disabled", {64, 0}, toolbar_icons, 32),
  data_util.build_sprite("milestones_pin_black", {0, 32}, toolbar_icons, 32),
  data_util.build_sprite("milestones_pin_white", {32, 32}, toolbar_icons, 32),
  data_util.build_sprite("milestones_pin_disabled", {64, 32}, toolbar_icons, 32),

  data_util.build_sprite("milestones_arrow_up", {0, 0}, arrows, 16),
  data_util.build_sprite("milestones_arrow_down", {16, 0}, arrows, 16),

  data_util.build_sprite("milestones_icon_item", {0, 0}, item_icons, 16),
  data_util.build_sprite("milestones_icon_item_black", {0, 16}, item_icons, 16),
  data_util.build_sprite("milestones_icon_fluid", {16, 0}, item_icons, 16),
  data_util.build_sprite("milestones_icon_fluid_black", {16, 16}, item_icons, 16),
  data_util.build_sprite("milestones_icon_technology", {32, 0}, item_icons, 16),
  data_util.build_sprite("milestones_icon_technology_black", {32, 16}, item_icons, 16),
}
