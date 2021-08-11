space_indicators = {}
activate_indicators = {}

hs.ipc.cliInstall()

hs.alert.defaultStyle.fillColor = { white = 0.17, alpha = 0.9 }
hs.alert.defaultStyle.strokeColor = { white = 0.1, alpha = 0 }
hs.alert.defaultStyle.radius = 10
hs.alert.defaultStyle.fadeInDuration = 0.1
hs.alert.defaultStyle.fadeOutDuration = 0.1

hs.keycodes.inputSourceChanged(function()
	if hs.keycodes.currentSourceID() == last_alerted_IM_ID then return end
    hs.alert.closeSpecific(last_IM_alert_uuid)
	last_alerted_IM_ID = hs.keycodes.currentSourceID()
    last_IM_alert_uuid = hs.alert.show(
		(function()
			if last_alerted_IM_ID == "com.apple.keylayout.ABC" then
				return "ABC"
            elseif last_alerted_IM_ID == "com.apple.inputmethod.Korean.2SetKorean" then
				return "두벌식"
            else return last_alerted_IM_ID
			end
		end)(),
		0.2
	)
end)

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

hs.spaces.watcher.new(update_space_indicator):start()

hs.alert.show("Hammer spoon loaded")
init_space_indicator()
init_activate_indicator()
update_space_indicator()
