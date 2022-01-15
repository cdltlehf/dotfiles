-- global leader
leader = { "ctrl", "cmd" }

-- Alert style {{{1
-- TODO: set it as a local configuration?
hs.alert.defaultStyle.fillColor = { white = 0.17, alpha = 0.9 }
hs.alert.defaultStyle.strokeColor = { white = 0.1, alpha = 0 }
hs.alert.defaultStyle.radius = 10
hs.alert.defaultStyle.fadeInDuration = 0.1
hs.alert.defaultStyle.fadeOutDuration = 0.3
-- }}}

do -- Input source changer {{{1
    local inputSource = {
        english = "com.apple.keylayout.ABC",
        korean = "com.apple.inputmethod.Korean.2SetKorean",
    }
    local sourceNameTable = {
        [inputSource.english] = "ABC",
        [inputSource.korean] = "두벌식",
    }
    local getName = function(source)
        if sourceNameTable[source] == nil then 
            return source
        end
        return sourceNameTable[source]
    end
    local escape_bind
    local escape_callback = function()
        hs.keycodes.currentSourceID(inputSource.english)

        escape_bind:disable()
        hs.eventtap.keyStroke({}, 'escape', 0)
        escape_bind:enable()
    end
    escape_bind = hs.hotkey.new({}, 'escape', escape_callback)
    escape_bind:enable()

    hs.keycodes.inputSourceChanged(function()
        if hs.keycodes.currentSourceID() == last_alerted_IM_ID then 
            return end

        hs.alert.closeSpecific(last_IM_alert_uuid)
        last_alerted_IM_ID = hs.keycodes.currentSourceID()
        last_IM_alert_uuid = hs.alert.show(getName(last_alerted_IM_ID), 0.2)
    end)
end -- }}}

-- Space/Activate indicators {{{
-- TODO: make it as a module?
hs.ipc.cliInstall()
space_indicators = {}
activate_indicators = {}
function skhd_activate() 
    hs.task.new(
        '/usr/local/bin/yabai', 
        function(s,o,e) 
            hs.task.new(
                '/usr/local/bin/jq',
                function(s,o,e)
                    hs.fnutils.each(activate_indicators, function(indicator)
                        if o == "1\n" then indicator:show() end
                    end)
                end,
                {'.windows | length'}
            ):setInput(o):start()
        end, 
        { '-m', 'query', '--spaces', '--space' }
    ):start()
    show_space_indicator() 
end

function skhd_deactivate() 
    hs.fnutils.each(activate_indicators, function(indicator)
       indicator:hide()
    end)
    hide_space_indicator() 
end

function init_activate_indicator()
    hs.fnutils.each(hs.screen.allScreens(), function(scr)
        local indicator = hs.canvas.new(scr:fullFrame())
        indicator:insertElement({
            type = 'rectangle',
            frame = { 
                x = 6, y = 6 + 24, 
                w = indicator:size().w - 12, h = indicator:size().h - 12 - 24
            },
            strokeColor = { hex = "0xf1fa8c" },
            strokeWidth = 1,
            action = 'stroke'
        })
        table.insert(activate_indicators, indicator)
    end)
end

function init_space_indicator()
    hs.fnutils.each(hs.screen.allScreens(), function(scr)
        local indicator = hs.canvas.new(scr:fullFrame())
        indicator:behavior(1)
        table.insert(space_indicators, indicator)
    end)
end

function update_space_indicator()
    local container_height = 30
    local container_offset_bottom = 15
    local circle_radius = 5
    local circle_padding = 10

    hs.task.new(
        '/usr/local/bin/yabai', 
        function(s,o,e) 
            hs.task.new(
                '/usr/local/bin/jq',
                function(s,o,e)
                    hs.fnutils.each(space_indicators, function(indicator)
                        local num_spaces = string.len(string.gsub(o, '%s', ''))
                        local container_width = 
                            circle_padding * ( num_spaces - 1 ) +
                            circle_radius * 2 * ( num_spaces - 1 ) +
                            container_height

                        indicator:replaceElements()

                        indicator:insertElement({ 
                            type = "rectangle", 
                            id = "background",
                            fillColor = { white = 0.4, alpha = 0.9 },
                            roundedRectRadii = { 
                                xRadius = container_height / 2, 
                                yRadius = container_height / 2
                            },
                            frame = {
                                x = indicator:size().w / 2 - container_width / 2,
                                y = indicator:size().h - container_height - container_offset_bottom,
                                w = container_width,
                                h = container_height
                            },
                            action = 'fill'
                        })

                        local n = 0
                        for i in string.gsub(o, '%s', ''):gmatch('.') do
                            indicator:insertElement({
                                type = "ellipticalArc",
                                id = n,
                                fillColor = { white = 1.0, alpha = 1.0 and i == '1' or 0.5 },
                                radius = 10,
                                absolutePosition = false,
                                action = "fill",
                                frame = { 
                                    x = indicator:size().w / 2 - container_width / 2 +
                                        n * (circle_radius * 2 + circle_padding) +
                                        container_height / 2 - circle_radius,
                                    y = indicator:size().h - container_height 
                                        - container_offset_bottom +
                                        container_height / 2 - circle_radius,
                                    w = circle_radius * 2,
                                    h = circle_radius * 2
                                }
                            })
                            n = n + 1
                        end
                    end)
                end,
                {'-r', '.[].focused'}
            ):setInput(o):start()
        end, 
        { '-m', 'query', '--spaces' }
    ):start()
end

function show_space_indicator()
    hs.fnutils.each(space_indicators, function(indicator)
        indicator:show(0.1)
    end)
end

function hide_space_indicator()
    hs.fnutils.each(space_indicators, function(indicator)
        indicator:hide(0.2)
    end)
end
-- }}}

do -- Window manager {{{1
    local function setFocusedWindowRatio(x, y, w, h, padding, duration)
        if padding == nil then padding = 0 end
        if duration == nil then duration = 0 end

        local window = hs.window.focusedWindow()
        local frame = window:frame()
        local screen_frame = window:screen():frame()

        screen_frame.x = screen_frame.x + padding / 2
        screen_frame.y = screen_frame.y + padding / 2
        screen_frame.w = screen_frame.w - padding
        screen_frame.h = screen_frame.h - padding

        frame.x = screen_frame.x + screen_frame.w * x + padding / 2
        frame.y = screen_frame.y + screen_frame.h * y + padding / 2

        frame.w = screen_frame.w * w - padding
        frame.h = screen_frame.h * h - padding

        window:setFrame(frame, duration)
    end

    local padding = 5
    local duration = 0

    hs.hotkey.bind(leader, "h", function()
        setFocusedWindowRatio(0, 0, 0.5, 1, padding, duration)
    end)
    hs.hotkey.bind(leader, "l", function()
        setFocusedWindowRatio(0.5, 0, 0.5, 1, padding, duration)
    end)
    hs.hotkey.bind(leader, "k", function()
        setFocusedWindowRatio(0, 0, 1, 1, padding, duration)
    end)
    hs.hotkey.bind(leader, "j", function()
        setFocusedWindowRatio(0.25, 0.25, 0.5, 0.5, padding, duration)
    end)

end -- }}}

-- hammer spoon reload {{{1
hs.hotkey.bind(leader, "r", function()
    hs.reload()
end)
hs.alert.show("Hammer spoon loaded")
-- }}}

-- hs.spaces.watcher.new(update_space_indicator):start()
-- init_space_indicator()
-- init_activate_indicator()
-- update_space_indicator()

-- vim:ts=2:sts=2:sw=2:et:sta:fdm=marker:fdl=0
