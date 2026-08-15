--- See `https://github.com/Hammerspoon/hammerspoon/blob/master/extensions/alert/alert.lua#L17`
local module = {}

function module.getStyle()
	local style = {
		strokeWidth = 2,
		strokeColor = { white = 0.1, alpha = 0 },
		fillColor = { white = 0.17, alpha = 0.9 },
		textColor = { white = 1, alpha = 1 },
		textFont = ".AppleSystemUIFont",
		textSize = 27,
		radius = 10,
		atScreenEdge = 0,
		fadeInDuration = 0.1,
		fadeOutDuration = 0.3,
		padding = nil,
	}

	return style
end

return module
