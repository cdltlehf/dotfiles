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
				return "가나다"
			end
		end)(),
		0.2
	)
end)
