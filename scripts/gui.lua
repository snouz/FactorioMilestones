require("gui_display_page")
require("gui_settings_page")

function build_main_frame(player)
    local screen_element = player.gui.screen
    local main_frame = screen_element.add{type="frame", name="milestones_main_frame", direction="vertical", visible=false}

    local titlebar = main_frame.add{type="flow", name="milestones_titlebar", style="flib_titlebar_flow", direction="horizontal"}
    titlebar.add{
        type="label",
        name="milestones_main_label",
        style="frame_title",
        style_mods={left_margin=4},
        caption={"milestones.title"},
        ignored_by_interaction=true
    }
    titlebar.add{type="empty-widget", style="flib_titlebar_drag_handle", ignored_by_interaction=true}
    local settings_button = titlebar.add{
        type="sprite-button",
        name="milestones_settings_button",
        style="frame_action_button",
        sprite="milestones_settings_white", 
        hovered_sprite="milestones_settings_black", 
        clicked_sprite="milestones_settings_black", 
        mouse_button_filter={"left"},
        tooltip = {"milestones.settings_instructions"},
        tags={
            action="milestones_open_settings"
        }
    }
    if player.permission_group == nil or not player.permission_group.allows_action(defines.input_action.mod_settings_changed) then
        settings_button.enabled = false
        settings_button.tooltip = {"milestones.settings_disabled"}
        settings_button.sprite = "milestones_settings_disabled"
        settings_button.hovered_sprite = "milestones_settings_disabled"
        settings_button.clicked_sprite = "milestones_settings_disabled"
    end
    titlebar.add{
        type="sprite-button",
        name="milestones_pin_button",
        style="frame_action_button",
        mouse_button_filter={"left"},
        sprite="milestones_pin_white",
        hovered_sprite="milestones_pin_black",
        clicked_sprite="milestones_pin_black",
        tooltip = {"milestones.pin_instructions"},
        tags={
            action="milestones_pin_gui"
        }
    }
    titlebar.add{
        type="sprite-button",
        name="milestones_close_button",
        style="frame_action_button",
        mouse_button_filter={"left"},
        sprite="utility/close_white",
        hovered_sprite="utility/close_black",
        clicked_sprite="utility/close_black",
        tooltip = {"gui.close-instruction"},
        tags={
            action="milestones_close_gui"
        }
    }
    titlebar.drag_target = main_frame

    local inner_frame = main_frame.add{type="frame", name="milestones_inner_frame", direction="vertical", style="milestones_inner_frame"}

    local dialog_buttons_bar = main_frame.add{type="flow", style="dialog_buttons_horizontal_flow", name="milestones_dialog_buttons", direction="horizontal"}
    dialog_buttons_bar.add{type="button", style="back_button", caption={"milestones.settings_back"}, tags={action="milestones_cancel_settings"}}
    dialog_buttons_bar.add{type="empty-widget", style="flib_dialog_footer_drag_handle", ignored_by_interaction=true}
    dialog_buttons_bar.add{type="button", style="confirm_button", caption={"milestones.settings_confirm"}, tags={action="milestones_confirm_settings"}}
    dialog_buttons_bar.drag_target = main_frame

    return main_frame, inner_frame
end

local function update_settings_button(player) -- In case permissions changed
    local main_frame = global.players[player.index].main_frame
    settings_button = main_frame.milestones_titlebar.milestones_settings_button
    
    if player.permission_group and player.permission_group.allows_action(defines.input_action.mod_settings_changed) then
        settings_button.enabled = true
        settings_button.tooltip = {"milestones.settings_instructions"}
        settings_button.sprite = "milestones_settings_white"
        settings_button.hovered_sprite = "milestones_settings_black"
        settings_button.clicked_sprite = "milestones_settings_black"
    else
        settings_button.enabled = false
        settings_button.tooltip = {"milestones.settings_disabled"}
        settings_button.sprite = "milestones_settings_disabled"
        settings_button.hovered_sprite = "milestones_settings_disabled"
        settings_button.clicked_sprite = "milestones_settings_disabled"
    end
end

local function open_gui(player)
    local global_player = global.players[player.index]
    build_display_page(player)
    update_settings_button(player)
    global_player.main_frame.visible = true
    player.opened = global_player.main_frame
    player.set_shortcut_toggled("milestones_toggle_gui", true)

    if not global_player.opened_once_before then -- Open in the center the first time
        global_player.main_frame.force_auto_center()
        global_player.opened_once_before = true
    end
end

local function close_gui(player)
    local global_player = global.players[player.index]
    global_player.main_frame.visible = false
    global_player.inner_frame.clear()
    player.set_shortcut_toggled("milestones_toggle_gui", false)
    if player.opened == global_player.main_frame then
        player.opened = nil
    end
end

local function toggle_gui(player)
    local visible = global.players[player.index].main_frame.visible
    if visible == false then
        open_gui(player)
    else
        close_gui(player)
    end
end

local function refresh_gui(player)
    if is_display_page_visible(player.index) then
        global.players[player.index].inner_frame.clear()
        build_display_page(player)
    end
end

function refresh_gui_for_force(force)
    for _, player in pairs(force.players) do
        refresh_gui(player)
    end
end

local function toggle_pinned(player, element)
    local global_player = global.players[player.index]
    global_player.pinned = not global_player.pinned
    if global_player.pinned then
        element.style = "flib_selected_frame_action_button"
        element.sprite = "milestones_pin_black"
        player.opened = nil
    else
        element.style = "frame_action_button"
        element.sprite = "milestones_pin_white"
        if player.opened == nil then
            player.opened = global_player.main_frame
        elseif player.opened ~= global_player.main_frame then
            close_gui(player)
        end
    end
end

script.on_event(defines.events.on_gui_closed, function(event)
    local player = game.get_player(event.player_index)
    if event.element and event.element.name == "milestones_main_frame" then

        local player = game.get_player(event.player_index)
        local global_player = global.players[event.player_index]
        if global_player.one_time_prevent_close then
            global_player.one_time_prevent_close = false
            player.opened = global_player.main_frame
        elseif not global_player.pinned then
            close_gui(player)
        end
    end
end)

-- Quickbar shortcut
script.on_event(defines.events.on_lua_shortcut, function(event)
    if event.prototype_name == "milestones_toggle_gui" then
        local player = game.get_player(event.player_index)
        toggle_gui(player)
    end
end)

-- Keyboard shortcuts
script.on_event("milestones_toggle_gui", function(event)
    local player = game.get_player(event.player_index)
    toggle_gui(player)
end)

-- Override `E` on the settings page
script.on_event("milestones_confirm_settings", function(event)
    if is_settings_page_visible(event.player_index) then
        confirm_settings_page(event.player_index)
        global.players[event.player_index].one_time_prevent_close = true
    end
end)

-- Override `Escape` on the settings page
script.on_event("milestones_cancel_settings", function(event)
    if is_settings_page_visible(event.player_index) then
        cancel_settings_page(event.player_index)
        global.players[event.player_index].one_time_prevent_close = true
    end
end)

script.on_event(defines.events.on_gui_click, function(event)
    if not event.element then return end
    if not event.element.tags then return end
    if event.element.tags.action == "milestones_close_gui" then
        local player = game.get_player(event.player_index)
        close_gui(player)
    elseif event.element.tags.action == "milestones_pin_gui" then
        local player = game.get_player(event.player_index)
        toggle_pinned(player, event.element)
    elseif event.element.tags.action == "milestones_open_settings" then
        local player = game.get_player(event.player_index)
        global.players[player.index].inner_frame.clear()
        build_settings_page(player)
    elseif event.element.tags.action == "milestones_cancel_settings" then
        cancel_settings_page(event.player_index)
    elseif event.element.tags.action == "milestones_confirm_settings" then
        confirm_settings_page(event.player_index)
    elseif event.element.tags.action == "milestones_swap_setting" then
        swap_settings(event.player_index, event.element)
    elseif event.element.tags.action == "milestones_delete_setting" then
        delete_setting(event.player_index, event.element)
    elseif event.element.tags.action == "milestones_add_setting" then
        add_setting(event.player_index, event.element)
    elseif event.element.tags.action == "milestones_edit_time" then
        enable_edit_time(event.player_index, event.element)
    elseif event.element.tags.action == "milestones_confirm_edit_time" then
        confirm_edit_time(event.player_index, event.element)
    end
end)

script.on_event(defines.events.on_gui_confirmed, function(event)
    if not event.element then return end
    if not event.element.tags then return end
    if event.element.tags.action == "milestones_confirm_edit_time_textfield" then
        confirm_edit_time(event.player_index, event.element)
    end
end)

