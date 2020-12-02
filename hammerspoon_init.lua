hs.hotkey.bind({"option"}, "`", function()
    alacritty = hs.application.find('alacritty')
    if alacritty then
      awin = alacritty:mainWindow()
    end
    if awin and alacritty and alacritty:isFrontmost() then
      hs.eventtap.keyStroke({"command"}, "tab", 0)
      hs.eventtap.keyStroke({}, "return", 0)
      alacritty:hide()
    else
      hs.application.launchOrFocus("/Applications/Alacritty.app")
      local alacritty = hs.application.find('alacritty')
      alacritty.setFrontmost(alacritty)
      alacritty.activate(alacritty)
    end
  end
)
