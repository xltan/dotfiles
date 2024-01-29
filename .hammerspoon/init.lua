-- Define the window filter
-- Define a variable to store the previous application
local KITTY = "kitty"

local function activateHotkey(eventType, modifier, key, fn)
	if eventType == hs.application.watcher.activated then
		hs.hotkey.bind(modifier, key, nil, fn)
		-- If the application is no longer Edge, remove the mapping
	elseif eventType == hs.application.watcher.deactivated then
		hs.hotkey.deleteAll(modifier, key)
	end
end

-- Define a function to handle application events
local function handleApplicationEvent(appName, eventType, app)
	if appName == nil then
		return
	end
	if string.find(appName, "^Code") then
		activateHotkey(eventType, { "cmd", "ctrl" }, "r", function()
			hs.eventtap.keyStroke({ "cmd", "ctrl", "shift" }, "r")
		end)
	elseif string.find(appName, "^OpenVPN Connect") then
		activateHotkey(eventType, { "cmd" }, "w", function()
			app:mainWindow():close()
		end)
	elseif eventType == hs.application.watcher.launched and appName == "kitty" then
		app:mainWindow():centerOnScreen(nil, false, 0)
	end
end

-- Create an application watcher and start it
appWatcher = hs.application.watcher.new(handleApplicationEvent)
appWatcher:start()

-- Switch kitty
hs.hotkey.bind(
	{ "option" },
	"space",
	function() -- change your own hotkey combo here, available keys could be found here:https://www.hammerspoon.org/docs/hs.hotkey.html#bind
		local app = hs.window.frontmostWindow():application()
		if app and app:name() == KITTY then
			app:hide()
		else
			hs.application.open(KITTY)
		end
	end
)

-- Kill all other windows
hs.hotkey.bind(
	{ "shift", "cmd" },
	"q",
	function() -- change your own hotkey combo here, available keys could be found here:https://www.hammerspoon.org/docs/hs.hotkey.html#bind
		local current_win = hs.window.frontmostWindow()
		local app = current_win:application()
    -- closes all other windows
    for _, win in ipairs(app:allWindows()) do
      if win ~= current_win then
        win:close()
      end
    end
	end
)
