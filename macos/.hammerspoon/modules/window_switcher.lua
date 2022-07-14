switcher = hs.window.switcher.new()

hs.hotkey.bind('alt', 'tab', nil,
switcher.nextWindow, nil, switcher.nextWindow)

hs.hotkey.bind('alt-shift', 'tab', nil,
switcher.previousWindow, nil, switcher.previousWindow)
