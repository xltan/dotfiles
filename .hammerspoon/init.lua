-- Define the window filter
-- Define a variable to store the previous application
local KITTY = "kitty"

local appKeyMappings = {
	["^Code"] = { -- Another example app
		{ { "cmd", "ctrl" }, "r", { "cmd", "ctrl", "shift" }, "r" },
	},
	["^Cursor"] = { -- Another example app
		{ { "cmd", "ctrl" }, "r", { "cmd", "ctrl", "shift" }, "r" },
	},
	["^OpenVPN Connect"] = { -- Another example app
		{
			{ "cmd" },
			"w",
			nil,
			function()
				local current_win = hs.window.frontmostWindow()
				current_win:close()
			end,
		},
	},
}

-- Table to store dynamic hotkeys
local dynamicHotkeys = {}

-- Function to find key mappings for an app based on regex
local function getKeyMappingsForApp(appName)
	for pattern, keyMappings in pairs(appKeyMappings) do
		if string.match(appName, pattern) then
			return keyMappings
		end
	end
	return nil
end

-- Function to enable keybindings for a specific app
local function enableKeyBindingsForApp(appName)
	local keyMappings = getKeyMappingsForApp(appName)
	if not keyMappings then
		return
	end

	for _, shortcut in ipairs(keyMappings) do
		local macMods, macKey, winMods, winKeyOrFunc = table.unpack(shortcut)
		if type(winKeyOrFunc) == "string" then
			-- Standard keystroke remapping
			dynamicHotkeys[#dynamicHotkeys + 1] = hs.hotkey.bind(macMods, macKey, nil, function()
				print(111, winMods[1], winMods[2], winKeyOrFunc)
				hs.eventtap.keyStroke(winMods, winKeyOrFunc, 1)
			end)
		elseif type(winKeyOrFunc) == "function" then
			-- Custom function mapping
			dynamicHotkeys[#dynamicHotkeys + 1] = hs.hotkey.bind(macMods, macKey, nil, winKeyOrFunc)
		end
	end
end

-- Function to disable all active keybindings
local function disableAllKeyBindings()
	for _, hotkey in ipairs(dynamicHotkeys) do
		hotkey:delete()
	end
	dynamicHotkeys = {}
end

-- App watcher to monitor active app
local appWatcher = hs.application.watcher.new(function(appName, eventType, app)
	if eventType == hs.application.watcher.activated then
		disableAllKeyBindings()
		enableKeyBindingsForApp(appName)
	elseif eventType == hs.application.watcher.launched and appName == "kitty" then
		app:mainWindow():centerOnScreen(nil, false, 0)
	end
end)

-- Start the app watcher
appWatcher:start()

-- Expose a cleanup function for reloading
local function stop()
	disableAllKeyBindings()
	appWatcher:stop()
end

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

hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "R", function()
	stop() -- Clean up the watcher and hotkeys
	hs.reload()
end)
