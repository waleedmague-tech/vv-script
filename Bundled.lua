-- Bundled by luabundle {"luaVersion":"5.1","version":"1.7.0"}
local __bundle_require, __bundle_loaded, __bundle_register, __bundle_modules = (function(superRequire)
	local loadingPlaceholder = {[{}] = true}

	local register
	local modules = {}

	local require
	local loaded = {}

	register = function(name, body)
		if not modules[name] then
			modules[name] = body
		end
	end

	require = function(name)
		local loadedModule = loaded[name]

		if loadedModule then
			if loadedModule == loadingPlaceholder then
				return nil
			end
		else
			if not modules[name] then
				if not superRequire then
					local identifier = type(name) == 'string' and '\"' .. name .. '\"' or tostring(name)
					error('Tried to require ' .. identifier .. ', but no such module has been registered')
				else
					return superRequire(name)
				end
			end

			loaded[name] = loadingPlaceholder
			loadedModule = modules[name](require, loaded, register, modules)
			loaded[name] = loadedModule
		end

		return loadedModule
	end

	return require, loaded, register, modules
end)(require)
__bundle_register("__root", function(require, _LOADED, __bundle_register, __bundle_modules)
-- Entry point — minimal bootstrap for the VV Ultimatum build.
-- Module cache: each module loads ONCE per script run, so shared utilities
-- (Settings, Humanoids, Conns, ParryTimings…) are true singletons. A Restart
-- re-runs Main.lua with a fresh cache, so edits still hot-reload.
local _cache = {}
local function customRequire(path)
    local hit = _cache[path]
    if hit ~= nil then return hit end
    local ok, content = pcall(readfile, path .. ".lua")
    if not ok or not content then error("require failed: " .. path) end
    local fn, err = loadstring(content, "=" .. path)
    if not fn then error("loadstring failed for " .. path .. ": " .. tostring(err)) end
    local env = setmetatable({ require = customRequire }, { __index = getfenv() })
    setfenv(fn, env)
    local result = fn()
    _cache[path] = result
    return result
end
getfenv().require = customRequire

-- Tear down previous run.
local prevConns = require("Utility/Conns")
prevConns.teardown()
do
    local pg = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
    for _, p in ipairs({ pg, gethui and gethui() or nil }) do
        if p then
            for _, n in ipairs({ "MyMenu", "Notifications", "AnimationVisualizer" }) do
                local o = p:FindFirstChild(n); if o then o:Destroy() end
            end
        end
    end
end

local State  = require("Utility/State")
local Logger = require("Utility/Logger")

local features = {
    AutoParryData       = require("Features/AutoParryData"),
    ParryTimings        = require("Features/ParryTimings"),
    Notification        = require("Features/Notification"),
    Movement            = require("Features/Movement"),
    Visuals             = require("Features/Visuals"),
    Combat              = require("Features/Combat"),
    Debug               = require("Features/Debug"),
    ModeratorChecker    = require("Features/ModeratorChecker"),
    AnimationVisualizer = require("Features/AnimationVisualizer"),
    KeybindHud          = require("Features/KeybindHud"),
}
_G.__AutoParryData = features.AutoParryData
_G.__ParryTimings  = features.ParryTimings
_G.__Notify        = features.Notification.send
-- NOTE: we intentionally do NOT auto-generate timings from learned data here.
-- AutoParry only ever uses timings you explicitly saved (parrytimings.json),
-- which are loaded at require-time. "Regenerate" stays available as a button.

for name, mod in pairs(features) do
    if mod.init then mod.init(State) end
    Logger.info("[Init] " .. name)
end

local Menu = require("Menu/Main")
Menu.build(State, features)

features.Notification.send("Loaded", "Script ready", 2,
    Color3.fromRGB(96, 175, 255))
Logger.info("Script loaded.")

end)
__bundle_register("Menu/Main", function(require, _LOADED, __bundle_register, __bundle_modules)
-- Main menu wiring: tabs, tooltips, keybinds, persistence.
local Players  = game:GetService("Players")
local LP       = Players.LocalPlayer
local Library         = require("GUI/Library")
local TimingsManager  = require("GUI/TimingsManager")
local Uninject        = require("Utility/Uninject")
local Settings        = require("Utility/Settings")
local Keybinds        = require("Utility/Keybinds")

local Menu = {}

function Menu.build(State, F)
    local parent = LP:WaitForChild("PlayerGui")
    pcall(function() if gethui then parent = gethui() end end)

    F.Notification.setParent(parent)
    F.AnimationVisualizer.setParent(parent)
    F.Debug.setParent(parent)
    F.Visuals.setAnimParent(parent)
    F.KeybindHud.setParent(parent)
    F.KeybindHud.setEnabled(State.KeybindHud ~= false)

    -- Restore persisted toggles into State before building UI so initial states reflect last session.
    for k, _ in pairs(State) do
        local saved = Settings.get("state__" .. k, nil)
        if saved ~= nil then State[k] = saved end
    end
    local function persistent(setter, key)
        return function(v) setter(v); Settings.set("state__" .. key, v) end
    end

    local W = Library.new(parent, "VV Ultimatum")

    -- Keybinds. Each feature toggle can be bound to a key.
    local function flip(key, setter)
        return function()
            local v = not State[key]
            setter(v); Settings.set("state__" .. key, v)
            F.Notification.send("Keybind", key .. ": " .. (v and "ON" or "OFF"), 1,
                v and Color3.fromRGB(120,220,150) or Color3.fromRGB(160,160,160))
        end
    end
    Keybinds.register("toggle_menu",     Enum.KeyCode.PageUp, function() W:ToggleVisible() end)
    Keybinds.register("toggle_autoparry",Enum.KeyCode.F,      flip("AutoParry",   F.Combat.setAutoParry))
    Keybinds.register("toggle_fly",      Enum.KeyCode.G,      flip("Fly",         F.Movement.setFly))
    Keybinds.register("toggle_noclip",   Enum.KeyCode.H,      flip("Noclip",      F.Movement.setNoclip))
    Keybinds.register("toggle_esp",      Enum.KeyCode.J,      flip("ESP",         F.Visuals.setESP))
    Keybinds.register("toggle_sprint",   Enum.KeyCode.K,      flip("ToggleSprint",F.Movement.setSprint))
    Keybinds.register("toggle_visualizer",Enum.KeyCode.V,     function()
        State.AnimViz = not State.AnimViz; F.AnimationVisualizer.toggle(State.AnimViz) end)

    --========================================
    -- COMBAT
    --========================================
    local cmb = W:Tab("Combat", "⚔️")
    cmb:Section("AutoParry")
    cmb:Toggle("AutoParry", function() return State.AutoParry end,
        persistent(F.Combat.setAutoParry, "AutoParry"),
        "Auto-press M2 when an enemy attack reaches its known impact frame.")
    cmb:Slider("Range",         5, 80,    function() return State.AutoParryRange end,
        persistent(function(v) State.AutoParryRange = v end, "AutoParryRange"), " studs",
        "How close an enemy must be for AutoParry to consider their attack.")
    cmb:Slider("Press Offset", -200, 500, function() return State.AutoParryOffset end,
        persistent(function(v) State.AutoParryOffset = v end, "AutoParryOffset"), " ms",
        "Shifts every parry's timing globally. Negative = earlier, positive = later.", 0)
    cmb:Dropdown("Timing Preset", { "Early", "Balanced", "Late" },
        function()
            local o = State.AutoParryOffset or 0
            if o <= -25 then return "Early" elseif o >= 25 then return "Late" else return "Balanced" end
        end,
        function(p)
            -- Early  = parry 50ms BEFORE your saved timing
            -- Balanced = AI assumes the best timing from your saved values
            --            (ping-compensated, exact frame). DEFAULT.
            -- Late   = parry 50ms AFTER your saved timing
            local map = { Early = -50, Balanced = 0, Late = 50 }
            local v = map[p] or 0
            State.AutoParryOffset = v
            Settings.set("state__AutoParryOffset", v)
            -- Balanced enables the smart ping-compensated mode.
            State.PingComp = (p == "Balanced") and true or State.PingComp
            Settings.set("state__PingComp", State.PingComp)
            F.Notification.send("Timing Preset", p .. "  (" .. v .. "ms)", 1.5)
        end,
        "Early = 50ms before your timing · Balanced = AI best timing from your saved values (default) · Late = 50ms after.")
    cmb:Toggle("Ping Compensation", function() return State.PingComp end,
        persistent(function(v) State.PingComp = v end, "PingComp"),
        "Used by Balanced: fires your round-trip ping earlier so the parry lands on the exact saved frame server-side.")

    cmb:Section("Tools")
    cmb:Toggle("Animation Visualizer", function() return State.AnimViz end,
        F.AnimationVisualizer.toggle,
        "Open the visualizer/scrubber window. Use the Save button there to capture parry timing.")
    cmb:Button("Open Timings Tab", function() W:JumpToTab("Timings") end,
        "Manage every parry timing (search / edit / categorise).")

    --========================================
    -- TIMINGS — full manager
    --========================================
    local tim = W:Tab("Timings", "⏱️")
    tim:Custom(function(holder)
        TimingsManager.build(holder, {
            timings = F.ParryTimings,
            notify  = F.Notification.send,
            resolveName = F.AnimationVisualizer.resolveName,
            openVisualizer = function(id)
                State.AnimViz = true
                F.AnimationVisualizer.openWithId(id)
            end,
        })
    end, 360)

    --========================================
    -- MOVEMENT
    --========================================
    local mov = W:Tab("Movement", "🏃")
    mov:Toggle("Toggle Sprint", function() return State.ToggleSprint end,
        persistent(F.Movement.setSprint, "ToggleSprint"),
        "Holds LeftShift via VirtualInputManager (no WalkSpeed change).")
    mov:Toggle("Fly", function() return State.Fly end,
        persistent(F.Movement.setFly, "Fly"),
        "WASD = move, Space = up, Ctrl = down.")
    mov:Slider("Fly Speed", 10, 300, function() return State.FlySpeed end,
        persistent(function(v) State.FlySpeed = v end, "FlySpeed"), nil,
        "Higher = faster fly.")
    mov:Toggle("Noclip", function() return State.Noclip end,
        persistent(F.Movement.setNoclip, "Noclip"),
        "Disables collision on your character. Original collisions restored on toggle off.")

    --========================================
    -- VISUALS
    --========================================
    local vis = W:Tab("Visuals", "👁️")
    vis:Section("ESP")
    vis:Toggle("ESP", function() return State.ESP end,
        persistent(F.Visuals.setESP, "ESP"),
        "Through-wall tags. Red = player, Green = NPC, Orange = mob.")
    vis:Slider("Range", 100, 3000, function() return State.ESPRange end,
        persistent(function(v) State.ESPRange = v end, "ESPRange"), " studs")
    vis:Toggle("Outline",       function() return State.ESPOutline  end,
        persistent(F.Visuals.setESPOutline, "ESPOutline"),
        "Glowing character outline, colored by type.")
    vis:Toggle("Show Name",     function() return State.ESPName     end, persistent(function(v) State.ESPName     = v end, "ESPName"))
    vis:Toggle("Show Health",   function() return State.ESPHealth   end, persistent(function(v) State.ESPHealth   = v end, "ESPHealth"))
    vis:Toggle("Show Distance", function() return State.ESPDistance end, persistent(function(v) State.ESPDistance = v end, "ESPDistance"))
    vis:Toggle("Show Weapon",   function() return State.ESPWeapon   end, persistent(function(v) State.ESPWeapon   = v end, "ESPWeapon"),
        "Shows the held weapon for players and mobs (not NPCs).")
    vis:Section("World")
    vis:Toggle("Fullbright", function() return State.Fullbright end,
        persistent(F.Visuals.setFullbright, "Fullbright"),
        "Pumps Lighting brightness + ambient and disables shadows.")
    vis:Toggle("Low GFX", function() return State.LowGfx end,
        persistent(F.Visuals.setLowGfx, "LowGfx"),
        "Quality 1, no shadows/particles/lights/post-FX, smooth plastic materials. Big FPS boost.")

    --========================================
    -- SAFETY
    --========================================
    local saf = W:Tab("Safety", "🛡️")
    saf:Toggle("Moderator Checker", function() return State.ModeratorChecker end,
        persistent(F.ModeratorChecker.setEnabled, "ModeratorChecker"),
        "Toast when a known moderator/admin joins the server.")
    saf:Toggle("Notifications", function() return State.NotificationsEnabled end,
        persistent(function(v) State.NotificationsEnabled = v end, "NotificationsEnabled"),
        "Master switch for corner toast notifications.")
    saf:Toggle("Debug Panel", function() return State.Debug end,
        persistent(F.Debug.setDebug, "Debug"),
        "Floating HUD with FPS / ping / state / last parry.")
    saf:Button("Scan players now", function() F.ModeratorChecker.scanAll() end,
        "Re-check every current player against the mod list.")

    --========================================
    -- SETTINGS / KEYBINDS
    --========================================
    local set = W:Tab("Settings", "⚙️")

    set:Section("Appearance")
    set:Dropdown("Theme", { "Purple", "Midnight", "Abyss", "Light" },
        function() return Settings.get("theme", "Purple") end,
        function(t) Library.setTheme(t); F.Notification.send("Theme", t, 1.5) end,
        "Recolor the whole UI instantly.")
    set:Dropdown("Accent Color",
        { "Purple", "Blue", "Teal", "Green", "Pink", "Red", "Orange", "Gold" },
        function() return Settings.get("accent_name", "Purple") end,
        function(a) Library.setAccent(a); F.Notification.send("Accent", a, 1.5) end,
        "Pick the highlight color used across the whole UI.")
    set:Slider("UI Scale", 60, 160, function() return math.floor(W:GetScale() * 100) end,
        function(v) W:SetScale(v / 100) end, "%",
        "Resize the entire menu for your screen.", 100)
    set:Toggle("Keybind HUD", function() return State.KeybindHud end,
        persistent(F.KeybindHud.setEnabled, "KeybindHud"),
        "Show the keybind list panel on the left. Enabled features glow green.")

    set:Section("Keybinds")
    local function kb(label, name, tip)
        set:Keybind(label, name,
            function() return Keybinds.get(name) end,
            function(k) Keybinds.set(name, k) end, tip)
    end
    kb("Toggle Menu",        "toggle_menu",       "Show/hide the menu.")
    kb("Toggle AutoParry",   "toggle_autoparry",  "Turn AutoParry on/off.")
    kb("Toggle Fly",         "toggle_fly",        "Turn Fly on/off.")
    kb("Toggle Noclip",      "toggle_noclip",     "Turn Noclip on/off.")
    kb("Toggle ESP",         "toggle_esp",        "Turn ESP on/off.")
    kb("Toggle Sprint",      "toggle_sprint",     "Toggle held-sprint.")
    kb("Toggle Visualizer",  "toggle_visualizer", "Open/close the Animation Visualizer.")

    set:Section("Quick Actions")
    set:Button("Performance Mode", function()
        F.Visuals.setLowGfx(true);  State.LowGfx = true
        Settings.set("state__LowGfx", true)
        if State.ESP then F.Visuals.setESP(false); State.ESP = false; Settings.set("state__ESP", false) end
        F.Notification.send("Performance Mode", "Low GFX on, ESP off", 2,
            Color3.fromRGB(80, 200, 130))
    end, "One click: max FPS (Low GFX on, heavy visuals off).")

    set:Section("Profiles")
    local profileName = "default"
    set:TextInput("Profile name", "default", function(v) profileName = v end,
        "Name to save/load a full config snapshot under.")
    set:Button("Save Profile", function()
        if Settings.saveProfile(profileName) then
            F.Notification.send("Profiles", "Saved '" .. profileName .. "'", 2,
                Color3.fromRGB(80, 200, 130))
        end
    end, "Snapshot every toggle/value into a named profile.")
    set:Button("Load Profile", function()
        if Settings.loadProfile(profileName) then
            F.Notification.send("Profiles", "Loaded '" .. profileName .. "' — Restart to apply", 3)
        else
            F.Notification.send("Profiles", "No profile '" .. profileName .. "'", 2,
                Color3.fromRGB(240, 96, 96))
        end
    end, "Apply a saved profile (Restart to fully apply).")

    set:Section("Maintenance")
    set:Button("Reset Menu Position", function()
        Settings.set("menu_pos", { x = 80, y = 80 })
        Settings.set("menu_size", { w = 580, h = 440 })
        F.Notification.send("Menu", "Position reset — Restart to apply", 2)
    end, "Move the window back to default spot/size.")
    set:Button("Reset All Settings", function()
        Settings.reset()
        F.Notification.send("Settings", "Cleared — Restart to apply", 3,
            Color3.fromRGB(240, 96, 96))
    end, "Wipe every saved preference and profile.", true)

    set:Section("Script")
    set:Button("Restart Script", function() Uninject.restart(State) end,
        "Reload the script with your latest edits.")
    set:Button("Uninject (close)", function() Uninject.run(State) end,
        "Disable every feature and remove the menu.", true)
end

return Menu

end)
__bundle_register("Utility/Keybinds", function(require, _LOADED, __bundle_register, __bundle_modules)
-- Keybinds: named global hotkeys. Persisted via Settings.
-- API:
--   Keybinds.register("toggle_menu", Enum.KeyCode.RightShift, callback)
--   Keybinds.set("toggle_menu", Enum.KeyCode.F1)
--   Keybinds.get("toggle_menu") -> Enum.KeyCode
local UIS = game:GetService("UserInputService")
local Settings = require("Utility/Settings")
local Conns    = require("Utility/Conns")

local Keybinds = {}
local registry = {}   -- name -> { keycode, fn }
local saved    = Settings.get("keybinds", {})

local function asKey(name)
    local k = saved[name]
    if type(k) == "string" then return Enum.KeyCode[k] end
    return nil
end

function Keybinds.register(name, defaultKey, fn)
    local key = asKey(name) or defaultKey
    registry[name] = { key = key, fn = fn, default = defaultKey }
end
function Keybinds.set(name, key)
    if not registry[name] then return end
    registry[name].key = key
    saved[name] = key and key.Name or nil
    Settings.set("keybinds", saved)
end
function Keybinds.get(name) return registry[name] and registry[name].key end
function Keybinds.all() return registry end

Conns.add(UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
    for _, b in pairs(registry) do
        if b.key and input.KeyCode == b.key and type(b.fn) == "function" then
            pcall(b.fn)
        end
    end
end))

return Keybinds

end)
__bundle_register("Utility/Conns", function(require, _LOADED, __bundle_register, __bundle_modules)
-- Global connection tracker. Lets Uninject disconnect everything.
-- Persists across reloads via _G so a re-injection can wipe the old run.
_G.__MyMenuConns = _G.__MyMenuConns or {}
_G.__MyMenuTeardowns = _G.__MyMenuTeardowns or {}

local Conns = {}

function Conns.add(c)
    table.insert(_G.__MyMenuConns, c)
    return c
end

-- Register a cleanup callback (e.g. destroy GUI / restore Lighting)
function Conns.onTeardown(fn)
    table.insert(_G.__MyMenuTeardowns, fn)
end

function Conns.teardown()
    for _, c in ipairs(_G.__MyMenuConns) do
        pcall(function() c:Disconnect() end)
    end
    _G.__MyMenuConns = {}
    for _, fn in ipairs(_G.__MyMenuTeardowns) do
        pcall(fn)
    end
    _G.__MyMenuTeardowns = {}
end

return Conns

end)
__bundle_register("Utility/Settings", function(require, _LOADED, __bundle_register, __bundle_modules)
-- Settings: persisted preferences. Saves on change to settings.json.
-- Designed so any feature can `Settings.get(key)` / `Settings.set(key, v)`
-- without caring how persistence works.
local Http = game:GetService("HttpService")
local Settings = {}
local FILE = "settings.json"
local data = {}

local function load()
    if isfile and isfile(FILE) then
        local ok, t = pcall(function() return Http:JSONDecode(readfile(FILE)) end)
        if ok and type(t) == "table" then data = t end
    end
end
local function save()
    pcall(function() writefile(FILE, Http:JSONEncode(data)) end)
end

function Settings.get(key, default) return data[key] == nil and default or data[key] end
function Settings.set(key, v) data[key] = v; save() end
function Settings.all() return data end
function Settings.reset() data = {}; save() end

-- ===== Profiles =====
-- A profile is a snapshot of every "state__*" key. Saved under data.profiles.
function Settings.saveProfile(name)
    if not name or name == "" then return false end
    data.profiles = data.profiles or {}
    local snap = {}
    for k, v in pairs(data) do
        if type(k) == "string" and k:sub(1, 7) == "state__" then snap[k] = v end
    end
    data.profiles[name] = snap
    save()
    return true
end
function Settings.loadProfile(name)
    local p = data.profiles and data.profiles[name]
    if not p then return false end
    for k, v in pairs(p) do data[k] = v end
    save()
    return true
end
function Settings.deleteProfile(name)
    if data.profiles then data.profiles[name] = nil; save() end
end
function Settings.listProfiles()
    local out = {}
    if data.profiles then for k in pairs(data.profiles) do table.insert(out, k) end end
    table.sort(out)
    return out
end

load()
return Settings

end)
__bundle_register("Utility/Uninject", function(require, _LOADED, __bundle_register, __bundle_modules)
-- Uninject + Restart helpers.
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local Conns = require("Utility/Conns")

local Uninject = {}

local function clearAllFlags(State)
    -- Flip every boolean-looking field off so live loops short-circuit.
    for k, v in pairs(State) do
        if type(v) == "boolean" then State[k] = false end
    end
end

function Uninject.run(State)
    clearAllFlags(State)
    Conns.teardown()
    local guis = { LP:FindFirstChild("PlayerGui") }
    pcall(function() if gethui then table.insert(guis, gethui()) end end)
    for _, p in ipairs(guis) do
        if p then
            local o = p:FindFirstChild("MyMenu")
            if o then o:Destroy() end
        end
    end
end

function Uninject.restart(State)
    Uninject.run(State)
    task.defer(function() loadstring(readfile("Main.lua"))() end)
end

return Uninject

end)
__bundle_register("GUI/TimingsManager", function(require, _LOADED, __bundle_register, __bundle_modules)
-- TimingsManager: drop-in widget for the menu's Timings tab.
-- Renders a full management UI: list of all timings with name, id, ms,
-- category; search; per-row edit/delete/preview; quick-add; bulk ops.
local UIS = game:GetService("UserInputService")

local TimingsManager = {}

-- Theme to match Library
local C = {
    bg     = Color3.fromRGB(24, 24, 30),
    row    = Color3.fromRGB(40, 40, 50),
    rowAlt = Color3.fromRGB(46, 46, 58),
    accent = Color3.fromRGB(96, 175, 255),
    green  = Color3.fromRGB(60, 200, 120),
    red    = Color3.fromRGB(220, 90, 90),
    text   = Color3.fromRGB(220, 220, 230),
    dim    = Color3.fromRGB(150, 160, 180),
    border = Color3.fromRGB(50, 50, 65),
}
local function corner(i, r) local c = Instance.new("UICorner", i); c.CornerRadius = UDim.new(0, r or 4); return c end

local search = ""
local catFilter = "All"

function TimingsManager.build(parent, deps)
    -- deps.timings (ParryTimings module), deps.notify, deps.openVisualizer(id)
    local PT     = deps.timings
    local notify = deps.notify or function() end
    local openV  = deps.openVisualizer or function() end
    local resolveName = deps.resolveName or function() return nil end

    local root = Instance.new("Frame")
    root.Size = UDim2.new(1, 0, 1, 0)
    root.BackgroundTransparency = 1
    root.Parent = parent

    -- ============ TOP: search + category dropdown + add bar ============
    local topRow = Instance.new("Frame", root)
    topRow.Size = UDim2.new(1, 0, 0, 28)
    topRow.BackgroundTransparency = 1

    local searchBox = Instance.new("TextBox", topRow)
    searchBox.Size = UDim2.new(0.45, -4, 1, 0)
    searchBox.BackgroundColor3 = C.bg; searchBox.BorderSizePixel = 0
    searchBox.PlaceholderText = "Search name / id / category…"
    searchBox.Text = ""; searchBox.TextColor3 = C.text
    searchBox.TextSize = 12; searchBox.Font = Enum.Font.Gotham
    searchBox.ClearTextOnFocus = false
    searchBox.TextXAlignment = Enum.TextXAlignment.Left
    local sPad = Instance.new("UIPadding", searchBox); sPad.PaddingLeft = UDim.new(0, 8)
    corner(searchBox)

    local catBtn = Instance.new("TextButton", topRow)
    catBtn.Size = UDim2.new(0.25, -4, 1, 0); catBtn.Position = UDim2.new(0.45, 4, 0, 0)
    catBtn.BackgroundColor3 = C.row; catBtn.BorderSizePixel = 0
    catBtn.Text = "All categories  v"
    catBtn.TextColor3 = C.text; catBtn.TextSize = 12; catBtn.Font = Enum.Font.GothamBold
    corner(catBtn)

    local statsLbl = Instance.new("TextLabel", topRow)
    statsLbl.Size = UDim2.new(0.30, -4, 1, 0); statsLbl.Position = UDim2.new(0.70, 4, 0, 0)
    statsLbl.BackgroundColor3 = C.row; statsLbl.BorderSizePixel = 0
    statsLbl.Text = "0 / 0"
    statsLbl.TextColor3 = C.dim; statsLbl.TextSize = 12; statsLbl.Font = Enum.Font.Code
    statsLbl.TextXAlignment = Enum.TextXAlignment.Center
    corner(statsLbl)

    -- Quick add bar
    local addRow = Instance.new("Frame", root)
    addRow.Size = UDim2.new(1, 0, 0, 28); addRow.Position = UDim2.new(0, 0, 0, 32)
    addRow.BackgroundTransparency = 1

    local idIn = Instance.new("TextBox", addRow)
    idIn.Size = UDim2.new(0.45, -4, 1, 0)
    idIn.BackgroundColor3 = C.bg; idIn.BorderSizePixel = 0
    idIn.PlaceholderText = "Animation id"; idIn.Text = ""
    idIn.TextColor3 = C.text; idIn.TextSize = 12; idIn.Font = Enum.Font.Code
    idIn.ClearTextOnFocus = false; idIn.TextXAlignment = Enum.TextXAlignment.Left
    local idPad = Instance.new("UIPadding", idIn); idPad.PaddingLeft = UDim.new(0, 8)
    corner(idIn)

    local msIn = Instance.new("TextBox", addRow)
    msIn.Size = UDim2.new(0.20, -4, 1, 0); msIn.Position = UDim2.new(0.45, 4, 0, 0)
    msIn.BackgroundColor3 = C.bg; msIn.BorderSizePixel = 0
    msIn.PlaceholderText = "ms"; msIn.Text = ""
    msIn.TextColor3 = C.text; msIn.TextSize = 12; msIn.Font = Enum.Font.Code
    msIn.ClearTextOnFocus = false; msIn.TextXAlignment = Enum.TextXAlignment.Left
    local msPad = Instance.new("UIPadding", msIn); msPad.PaddingLeft = UDim.new(0, 8)
    corner(msIn)

    local catIn = Instance.new("TextBox", addRow)
    catIn.Size = UDim2.new(0.20, -4, 1, 0); catIn.Position = UDim2.new(0.65, 4, 0, 0)
    catIn.BackgroundColor3 = C.bg; catIn.BorderSizePixel = 0
    catIn.PlaceholderText = "Category"; catIn.Text = ""
    catIn.TextColor3 = C.text; catIn.TextSize = 12; catIn.Font = Enum.Font.Gotham
    catIn.ClearTextOnFocus = false; catIn.TextXAlignment = Enum.TextXAlignment.Left
    local cPad = Instance.new("UIPadding", catIn); cPad.PaddingLeft = UDim.new(0, 8)
    corner(catIn)

    local addBtn = Instance.new("TextButton", addRow)
    addBtn.Size = UDim2.new(0.15, -4, 1, 0); addBtn.Position = UDim2.new(0.85, 4, 0, 0)
    addBtn.BackgroundColor3 = C.green; addBtn.BorderSizePixel = 0
    addBtn.Text = "Save"; addBtn.TextColor3 = Color3.fromRGB(255,255,255)
    addBtn.TextSize = 12; addBtn.Font = Enum.Font.GothamBold
    corner(addBtn)

    -- ============ LIST ============
    local list = Instance.new("ScrollingFrame", root)
    list.Size = UDim2.new(1, 0, 1, -100); list.Position = UDim2.new(0, 0, 0, 64)
    list.BackgroundColor3 = C.bg; list.BorderSizePixel = 0
    list.CanvasSize = UDim2.new(0, 0, 0, 0); list.ScrollBarThickness = 4
    corner(list)
    local listLayout = Instance.new("UIListLayout", list)
    listLayout.Padding = UDim.new(0, 2); listLayout.SortOrder = Enum.SortOrder.LayoutOrder

    -- ============ BOTTOM: bulk actions ============
    local botRow = Instance.new("Frame", root)
    botRow.Size = UDim2.new(1, 0, 0, 28); botRow.Position = UDim2.new(0, 0, 1, -28)
    botRow.BackgroundTransparency = 1
    local botLayout = Instance.new("UIListLayout", botRow)
    botLayout.FillDirection = Enum.FillDirection.Horizontal
    botLayout.Padding = UDim.new(0, 4)
    local function bb(label, color, fn, w)
        local b = Instance.new("TextButton", botRow)
        b.Size = UDim2.new(0, w or 100, 1, 0); b.BackgroundColor3 = color
        b.BorderSizePixel = 0; b.Text = label; b.TextColor3 = Color3.fromRGB(255,255,255)
        b.TextSize = 12; b.Font = Enum.Font.GothamBold
        corner(b)
        b.MouseButton1Click:Connect(fn)
        return b
    end

    -- Forward declare so we can refer in handlers
    local refresh

    -- Helpers
    local function asMs(v) return type(v) == "table" and (v.sec * 1000) or (v * 1000) end
    local function asCat(v) return type(v) == "table" and (v.cat or "Uncategorized") or "Uncategorized" end
    local function asSrc(v) return type(v) == "table" and (v.src or "—") or "—" end

    -- Build category dropdown
    local catList = Instance.new("Frame", topRow)
    catList.Visible = false; catList.BackgroundColor3 = C.row; catList.BorderSizePixel = 0
    catList.Position = UDim2.new(0.45, 4, 1, 4); catList.Size = UDim2.new(0.25, -4, 0, 0)
    catList.ZIndex = 10
    corner(catList)
    local catLayout = Instance.new("UIListLayout", catList)
    catLayout.Padding = UDim.new(0, 2)
    local function rebuildCatDropdown()
        for _, c in ipairs(catList:GetChildren()) do
            if c:IsA("TextButton") then c:Destroy() end
        end
        local cats = { "All" }
        for _, c in ipairs(PT.categories()) do table.insert(cats, c) end
        for _, c in ipairs(cats) do
            local b = Instance.new("TextButton", catList)
            b.Size = UDim2.new(1, 0, 0, 22); b.BackgroundColor3 = C.row
            b.BorderSizePixel = 0; b.Text = c; b.TextColor3 = C.text
            b.TextSize = 12; b.Font = Enum.Font.Gotham
            b.ZIndex = 11
            b.MouseButton1Click:Connect(function()
                catFilter = c
                catBtn.Text = c .. "  v"
                catList.Visible = false
                refresh()
            end)
        end
        catList.Size = UDim2.new(0.25, -4, 0, #cats * 24)
    end
    catBtn.MouseButton1Click:Connect(function()
        rebuildCatDropdown()
        catList.Visible = not catList.Visible
    end)

    -- Build / refresh list rows
    local function buildRow(id, v, i)
        local row = Instance.new("Frame", list)
        row.Size = UDim2.new(1, -4, 0, 44)
        row.BackgroundColor3 = (i % 2 == 0) and C.rowAlt or C.row
        row.BorderSizePixel = 0
        row.LayoutOrder = i
        corner(row)

        local name = resolveName(id) or "—"
        local title = Instance.new("TextLabel", row)
        title.Size = UDim2.new(1, -200, 0, 18); title.Position = UDim2.new(0, 8, 0, 4)
        title.BackgroundTransparency = 1
        title.Text = name
        title.TextColor3 = C.text; title.TextSize = 13; title.Font = Enum.Font.GothamBold
        title.TextXAlignment = Enum.TextXAlignment.Left; title.TextTruncate = Enum.TextTruncate.AtEnd

        local sub = Instance.new("TextLabel", row)
        sub.Size = UDim2.new(1, -200, 0, 14); sub.Position = UDim2.new(0, 8, 0, 22)
        sub.BackgroundTransparency = 1
        sub.Text = string.format("id=%s  ·  cat=%s  ·  src=%s", id, asCat(v), asSrc(v))
        sub.TextColor3 = C.dim; sub.TextSize = 11; sub.Font = Enum.Font.Code
        sub.TextXAlignment = Enum.TextXAlignment.Left; sub.TextTruncate = Enum.TextTruncate.AtEnd

        -- Editable ms box
        local msBox = Instance.new("TextBox", row)
        msBox.Size = UDim2.new(0, 70, 0, 26); msBox.Position = UDim2.new(1, -188, 0, 9)
        msBox.BackgroundColor3 = C.bg; msBox.BorderSizePixel = 0
        msBox.Text = tostring(math.floor(asMs(v) + 0.5))
        msBox.TextColor3 = C.accent; msBox.TextSize = 13; msBox.Font = Enum.Font.Code
        msBox.ClearTextOnFocus = false
        corner(msBox)
        msBox.FocusLost:Connect(function(enter)
            if not enter then return end
            local n = tonumber(msBox.Text)
            if not n then return end
            PT.set(id, n / 1000, asCat(v))
            notify("Timings", id .. " = " .. n .. " ms", 1.5, C.green)
        end)

        local previewBtn = Instance.new("TextButton", row)
        previewBtn.Size = UDim2.new(0, 56, 0, 26); previewBtn.Position = UDim2.new(1, -114, 0, 9)
        previewBtn.BackgroundColor3 = C.accent; previewBtn.BorderSizePixel = 0
        previewBtn.Text = "View"; previewBtn.TextColor3 = Color3.fromRGB(255,255,255)
        previewBtn.TextSize = 12; previewBtn.Font = Enum.Font.GothamBold
        corner(previewBtn)
        previewBtn.MouseButton1Click:Connect(function() openV(id) end)

        local delBtn = Instance.new("TextButton", row)
        delBtn.Size = UDim2.new(0, 52, 0, 26); delBtn.Position = UDim2.new(1, -56, 0, 9)
        delBtn.BackgroundColor3 = C.red; delBtn.BorderSizePixel = 0
        delBtn.Text = "Delete"; delBtn.TextColor3 = Color3.fromRGB(255,255,255)
        delBtn.TextSize = 12; delBtn.Font = Enum.Font.GothamBold
        corner(delBtn)
        delBtn.MouseButton1Click:Connect(function()
            PT.remove(id)
            notify("Timings", "removed " .. id, 1.5, C.red)
            refresh()
        end)
    end

    local grouped = true          -- group by category by default
    local collapsed = {}          -- cat -> true when collapsed

    local function buildCatHeader(cat, count, order)
        local h = Instance.new("Frame", list)
        h.Size = UDim2.new(1, -4, 0, 26); h.BackgroundColor3 = C.accent
        h.BorderSizePixel = 0; h.LayoutOrder = order
        corner(h)
        local btn = Instance.new("TextButton", h)
        btn.Size = UDim2.new(1, -58, 1, 0); btn.BackgroundTransparency = 1
        btn.Text = string.format("  %s  %s   (%d)",
            collapsed[cat] and ">" or "v", cat:upper(), count)
        btn.TextColor3 = Color3.fromRGB(255,255,255); btn.TextSize = 12
        btn.Font = Enum.Font.GothamBold; btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.MouseButton1Click:Connect(function()
            collapsed[cat] = (not collapsed[cat]) or nil; refresh()
        end)
        -- per-category clear button
        local clr = Instance.new("TextButton", h)
        clr.Size = UDim2.new(0, 52, 0, 20); clr.Position = UDim2.new(1, -54, 0, 3)
        clr.BackgroundColor3 = C.red; clr.BorderSizePixel = 0
        clr.Text = "Clear"; clr.TextColor3 = Color3.fromRGB(255,255,255)
        clr.TextSize = 11; clr.Font = Enum.Font.GothamBold
        corner(clr)
        clr.MouseButton1Click:Connect(function()
            local n = PT.clearCategory(cat)
            notify("Timings", "cleared " .. n .. " in " .. cat, 2, C.red)
            refresh()
        end)
    end

    refresh = function()
        for _, c in ipairs(list:GetChildren()) do
            if c:IsA("Frame") then c:Destroy() end
        end
        local q = search:lower()
        local visible, total = 0, 0
        local rows = {}
        for id, v in pairs(PT.all()) do
            total = total + 1
            local name = (resolveName(id) or ""):lower()
            local cat = asCat(v):lower()
            local pass = true
            if q ~= "" then
                pass = string.find(id:lower(), q, 1, true)
                    or string.find(name, q, 1, true)
                    or string.find(cat, q, 1, true)
            end
            if pass and catFilter ~= "All" and asCat(v) ~= catFilter then pass = false end
            if pass then table.insert(rows, { id = id, v = v, ms = asMs(v), cat = asCat(v) }) end
        end

        local order, canvas = 0, 0
        if grouped then
            -- bucket by category
            local buckets, catNames = {}, {}
            for _, r in ipairs(rows) do
                if not buckets[r.cat] then buckets[r.cat] = {}; table.insert(catNames, r.cat) end
                table.insert(buckets[r.cat], r)
            end
            table.sort(catNames)
            for _, cat in ipairs(catNames) do
                local grp = buckets[cat]
                table.sort(grp, function(a, b) return a.ms < b.ms end)
                order = order + 1; buildCatHeader(cat, #grp, order); canvas = canvas + 28
                if not collapsed[cat] then
                    for _, r in ipairs(grp) do
                        order = order + 1; buildRow(r.id, r.v, order); canvas = canvas + 46
                        visible = visible + 1
                    end
                else
                    visible = visible + #grp
                end
            end
        else
            table.sort(rows, function(a, b) return a.ms < b.ms end)
            for _, r in ipairs(rows) do
                order = order + 1; buildRow(r.id, r.v, order); canvas = canvas + 46
                visible = visible + 1
            end
        end
        statsLbl.Text = string.format("%d / %d", visible, total)
        list.CanvasSize = UDim2.new(0, 0, 0, canvas + 8)
    end

    -- expose grouped toggle for the bottom bar
    local function toggleGrouped() grouped = not grouped; refresh(); return grouped end
    TimingsManager._toggleGrouped = toggleGrouped

    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        search = searchBox.Text; refresh()
    end)

    addBtn.MouseButton1Click:Connect(function()
        local id = (idIn.Text or ""):gsub("rbxassetid://", ""):gsub("%s+", "")
        local n  = tonumber(msIn.Text)
        if id == "" or not n then
            notify("Timings", "need id + ms", 2, C.red); return
        end
        PT.set(id, n / 1000, (catIn.Text ~= "" and catIn.Text) or "Uncategorized")
        notify("Timings", "saved " .. id .. " = " .. n .. "ms", 2, C.green)
        idIn.Text = ""; msIn.Text = ""; catIn.Text = ""
        refresh()
    end)

    local grpBtn
    grpBtn = bb("Group: On", C.accent, function()
        local on = TimingsManager._toggleGrouped()
        grpBtn.Text = "Group: " .. (on and "On" or "Off")
    end, 90)
    bb("Regenerate",    C.accent, function()
        local n = PT.generate()
        notify("Timings", n .. " refreshed", 2)
        refresh()
    end)
    bb("Export → clipboard", C.row, function()
        PT.export(); notify("Timings", "JSON copied", 2)
    end, 140)
    bb("Import paste",  C.row, function()
        local cb = getclipboard or get_clipboard
        local json = cb and cb() or nil
        if not json or json == "" then
            notify("Timings", "clipboard empty", 2, C.red); return
        end
        local ok, msg = PT.import(json)
        notify("Timings", msg or "?", 2, ok and C.green or C.red)
        refresh()
    end, 120)
    bb("Clear Category", C.red, function()
        if catFilter == "All" then
            notify("Timings", "pick a category first (top filter)", 2.5, C.red); return
        end
        local n = PT.clearCategory(catFilter)
        notify("Timings", "cleared " .. n .. " in " .. catFilter, 2, C.red)
        refresh()
    end, 120)
    bb("Clear ALL",     C.red,   function()
        PT.clear(); notify("Timings", "all cleared", 2, C.red); refresh()
    end)

    refresh()
    return { refresh = refresh }
end

return TimingsManager

end)
__bundle_register("GUI/Library", function(require, _LOADED, __bundle_register, __bundle_modules)
-- Premium window library — top tab-bar layout, fully themeable.
-- Public API (unchanged so Menu/Main.lua keeps working):
--   W = Library.new(parent, title)
--   tab = W:Tab(name, icon)
--   tab:Section(text) / Toggle / Button(label,fn,tip,danger) / Slider(...,default)
--       / TextInput / Keybind / Dropdown / Custom(builder,height)
--   W:JumpToTab(name)  W:SetVisible(b)  W:ToggleVisible()
--   W:GetScale() W:SetScale(s)  W:Confirm(msg,onYes)  W:Notify(...)
--   Library.setTheme(name)  Library.setAccent(color)  Library.themes
local UIS      = game:GetService("UserInputService")
local Tween    = game:GetService("TweenService")
local RunSvc   = game:GetService("RunService")
local Settings = require("Utility/Settings")
local MouseUnlock = require("Utility/MouseUnlock")

local Library = {}

--==================== THEMES ====================
local THEMES = {
    Purple = { bg=Color3.fromRGB(8,7,12), bgAlt=Color3.fromRGB(15,12,22),
        bgRow=Color3.fromRGB(24,20,34), bgHover=Color3.fromRGB(46,34,72),
        border=Color3.fromRGB(54,38,86), accent=Color3.fromRGB(180,130,255),
        accent2=Color3.fromRGB(140,86,235), good=Color3.fromRGB(120,220,150),
        warn=Color3.fromRGB(250,185,85), bad=Color3.fromRGB(250,100,125),
        text=Color3.fromRGB(245,242,252), textDim=Color3.fromRGB(168,160,192) },
    Midnight = { bg=Color3.fromRGB(10,12,18), bgAlt=Color3.fromRGB(18,21,30),
        bgRow=Color3.fromRGB(28,32,44), bgHover=Color3.fromRGB(44,52,72),
        border=Color3.fromRGB(46,54,74), accent=Color3.fromRGB(96,170,255),
        accent2=Color3.fromRGB(56,130,225), good=Color3.fromRGB(90,205,140),
        warn=Color3.fromRGB(245,170,70), bad=Color3.fromRGB(240,100,100),
        text=Color3.fromRGB(236,240,250), textDim=Color3.fromRGB(150,160,182) },
    Abyss = { bg=Color3.fromRGB(6,8,10), bgAlt=Color3.fromRGB(12,16,18),
        bgRow=Color3.fromRGB(20,26,30), bgHover=Color3.fromRGB(28,48,52),
        border=Color3.fromRGB(34,52,56), accent=Color3.fromRGB(70,230,200),
        accent2=Color3.fromRGB(40,180,160), good=Color3.fromRGB(110,225,160),
        warn=Color3.fromRGB(245,190,90), bad=Color3.fromRGB(245,110,120),
        text=Color3.fromRGB(235,248,246), textDim=Color3.fromRGB(150,178,178) },
    Light = { bg=Color3.fromRGB(238,240,246), bgAlt=Color3.fromRGB(228,231,240),
        bgRow=Color3.fromRGB(214,218,230), bgHover=Color3.fromRGB(198,204,222),
        border=Color3.fromRGB(186,192,210), accent=Color3.fromRGB(120,90,235),
        accent2=Color3.fromRGB(90,60,205), good=Color3.fromRGB(60,170,110),
        warn=Color3.fromRGB(210,140,40), bad=Color3.fromRGB(215,75,90),
        text=Color3.fromRGB(28,30,40), textDim=Color3.fromRGB(105,112,132) },
}
local ACCENTS = {
    Purple=Color3.fromRGB(180,130,255), Blue=Color3.fromRGB(96,170,255),
    Teal=Color3.fromRGB(70,230,200),    Green=Color3.fromRGB(110,220,140),
    Pink=Color3.fromRGB(245,120,200),   Red=Color3.fromRGB(245,100,110),
    Orange=Color3.fromRGB(250,165,80),  Gold=Color3.fromRGB(245,205,90),
}
Library.themes  = THEMES
Library.accents = ACCENTS

local T = THEMES[Settings.get("theme","Purple")] or THEMES.Purple
do  -- apply saved accent override at load
    local a = Settings.get("accent_name", nil)
    if a and ACCENTS[a] then T.accent = ACCENTS[a] end
end
local registry = {}   -- { inst, map }

local function reapply()
    for _, r in ipairs(registry) do
        for prop, key in pairs(r.map) do pcall(function() r.inst[prop] = T[key] end) end
    end
end
function Library.setTheme(name)
    local nt = THEMES[name]; if not nt then return end
    -- preserve current accent override
    local accentName = Settings.get("accent_name", nil)
    T = setmetatable({}, { __index = nt })
    for k,v in pairs(nt) do T[k]=v end
    if accentName and ACCENTS[accentName] then T.accent = ACCENTS[accentName] end
    Settings.set("theme", name)
    reapply()
end
function Library.setAccent(name)
    local c = ACCENTS[name]; if not c then return end
    T.accent = c
    Settings.set("accent_name", name)
    reapply()
end

--==================== HELPERS ====================
local function ui(cls, props, parent)
    local i = Instance.new(cls)
    if props then for k,v in pairs(props) do i[k]=v end end
    if parent then i.Parent=parent end
    return i
end
local function corner(i,r) ui("UICorner",{CornerRadius=UDim.new(0,r or 8)},i) end
local function pad(i,l,t,rr,b) ui("UIPadding",{PaddingLeft=UDim.new(0,l or 0),
    PaddingTop=UDim.new(0,t or 0),PaddingRight=UDim.new(0,rr or 0),
    PaddingBottom=UDim.new(0,b or 0)},i) end
local function stroke(i,key) local s=ui("UIStroke",{Color=T[key or "border"],Thickness=1},i)
    table.insert(registry,{inst=s,map={Color=key or "border"}}); return s end
local function tw(i,t,p) Tween:Create(i,TweenInfo.new(t or 0.14,Enum.EasingStyle.Quad),p):Play() end
-- theme-bind: registers an instance so reapply() recolors it live
local function bind(i, map) table.insert(registry,{inst=i,map=map}); return i end

--==================== TOOLTIP ====================
local tip, tipLbl, tipTask
local function tipSetup(p)
    if tip then return end
    tip = ui("Frame",{Size=UDim2.fromOffset(0,22),AutomaticSize=Enum.AutomaticSize.X,
        BackgroundColor3=T.bgRow,BorderSizePixel=0,Visible=false,ZIndex=300},p)
    bind(tip,{BackgroundColor3="bgRow"}); corner(tip,5); stroke(tip)
    tipLbl=ui("TextLabel",{AutomaticSize=Enum.AutomaticSize.X,Size=UDim2.fromOffset(0,22),
        BackgroundTransparency=1,TextColor3=T.text,TextSize=12,Font=Enum.Font.Gotham,ZIndex=301},tip)
    bind(tipLbl,{TextColor3="text"}); pad(tipLbl,8,0,8,0)
end
local function tipFor(target,text)
    if not text or text=="" then return end
    target.MouseEnter:Connect(function()
        if tipTask then task.cancel(tipTask) end
        tipTask=task.delay(0.35,function() if tip then tipLbl.Text=text; tip.Visible=true end end)
    end)
    target.MouseLeave:Connect(function()
        if tipTask then task.cancel(tipTask); tipTask=nil end
        if tip then tip.Visible=false end
    end)
end
UIS.InputChanged:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseMovement and tip and tip.Visible then
        tip.Position=UDim2.fromOffset(i.Position.X+14,i.Position.Y+18)
    end
end)

--==================== WINDOW ====================
function Library.new(parent, title)
    local self = { _tabs={}, _byName={}, _active=nil, _vis={}, _getters={} }
    local window = self

    local sg = ui("ScreenGui",{Name="MyMenu",ResetOnSpawn=false,DisplayOrder=1000,
        IgnoreGuiInset=true,Parent=parent})
    self.gui = sg
    tipSetup(sg)

    local pos  = Settings.get("menu_pos",{x=120,y=90})
    local size = Settings.get("menu_size",{w=620,h=420})

    local W = ui("Frame",{Size=UDim2.fromOffset(size.w,size.h),
        Position=UDim2.fromOffset(pos.x,pos.y),BackgroundColor3=T.bg,
        BorderSizePixel=0,ClipsDescendants=true,Parent=sg})
    bind(W,{BackgroundColor3="bg"}); corner(W,12); stroke(W)
    self.window = W

    -- soft drop shadow
    ui("ImageLabel",{Size=UDim2.new(1,40,1,40),Position=UDim2.fromOffset(-20,-16),
        BackgroundTransparency=1,Image="rbxassetid://6014261993",
        ImageColor3=Color3.new(0,0,0),ImageTransparency=0.45,ZIndex=0,
        ScaleType=Enum.ScaleType.Slice,SliceCenter=Rect.new(49,49,450,450),Parent=W})

    local uiScale = ui("UIScale",{Scale=Settings.get("ui_scale",1.0)},W)
    function self:SetScale(s) s=math.clamp(s,0.6,1.6); uiScale.Scale=s; Settings.set("ui_scale",s) end
    function self:GetScale() return uiScale.Scale end

    --======== HEADER ========
    local header = ui("Frame",{Size=UDim2.new(1,0,0,44),BackgroundColor3=T.bgAlt,
        BorderSizePixel=0,ZIndex=2,Parent=W})
    bind(header,{BackgroundColor3="bgAlt"})
    -- accent gradient strip under header
    local strip = ui("Frame",{Size=UDim2.new(1,0,0,2),Position=UDim2.new(0,0,1,-2),
        BackgroundColor3=T.accent,BorderSizePixel=0,ZIndex=3,Parent=header})
    bind(strip,{BackgroundColor3="accent"})

    local logo = ui("TextLabel",{Size=UDim2.fromOffset(150,44),Position=UDim2.fromOffset(16,0),
        BackgroundTransparency=1,Text=title or "Menu",TextColor3=T.text,TextSize=17,
        Font=Enum.Font.GothamBlack,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=3,Parent=header})
    bind(logo,{TextColor3="text"})

    -- search
    local searchBox
    local searchHolder = ui("Frame",{Size=UDim2.fromOffset(230,26),Position=UDim2.new(0.5,-115,0,9),
        BackgroundColor3=T.bg,BorderSizePixel=0,ZIndex=3,Parent=header})
    bind(searchHolder,{BackgroundColor3="bg"}); corner(searchHolder,6); stroke(searchHolder)
    ui("TextLabel",{Size=UDim2.fromOffset(24,26),BackgroundTransparency=1,Text="🔍",
        TextSize=12,ZIndex=4,Parent=searchHolder})
    searchBox = ui("TextBox",{Size=UDim2.new(1,-30,1,0),Position=UDim2.fromOffset(28,0),
        BackgroundTransparency=1,Text="",PlaceholderText="Search…",TextColor3=T.text,
        PlaceholderColor3=T.textDim,TextSize=12,Font=Enum.Font.Gotham,ClearTextOnFocus=false,
        TextXAlignment=Enum.TextXAlignment.Left,ZIndex=4,Parent=searchHolder})
    bind(searchBox,{TextColor3="text",PlaceholderColor3="textDim"})

    local function winBtn(txt,xoff,col,fn,tip2)
        local b=ui("TextButton",{Size=UDim2.fromOffset(28,24),Position=UDim2.new(1,xoff,0,10),
            BackgroundColor3=T.bgRow,BorderSizePixel=0,AutoButtonColor=false,Text=txt,
            TextColor3=col or T.text,TextSize=14,Font=Enum.Font.GothamBold,ZIndex=4,Parent=header})
        bind(b,{BackgroundColor3="bgRow"}); corner(b,6)
        b.MouseEnter:Connect(function() tw(b,0.1,{BackgroundColor3=T.bgHover}) end)
        b.MouseLeave:Connect(function() tw(b,0.1,{BackgroundColor3=T.bgRow}) end)
        b.MouseButton1Click:Connect(fn); tipFor(b,tip2); return b
    end
    winBtn("_",-72,nil,function() self:ToggleMinimize() end,"Minimize")
    winBtn("X",-38,T.bad,function() self:SetVisible(false) end,"Close (PageUp reopens)")

    --======== TAB BAR (horizontal pills) ========
    local tabBar = ui("ScrollingFrame",{Size=UDim2.new(1,-12,0,34),Position=UDim2.fromOffset(6,50),
        BackgroundTransparency=1,BorderSizePixel=0,ScrollingDirection=Enum.ScrollingDirection.X,
        ScrollBarThickness=0,CanvasSize=UDim2.new(0,0,0,0),ZIndex=2,Parent=W})
    local tabLayout = ui("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,
        Padding=UDim.new(0,6),VerticalAlignment=Enum.VerticalAlignment.Center,
        SortOrder=Enum.SortOrder.LayoutOrder},tabBar)

    --======== CONTENT ========
    local content = ui("Frame",{Size=UDim2.new(1,-12,1,-122),Position=UDim2.fromOffset(6,88),
        BackgroundColor3=T.bgAlt,BorderSizePixel=0,Parent=W})
    bind(content,{BackgroundColor3="bgAlt"}); corner(content,10)

    --======== FOOTER ========
    local footer = ui("Frame",{Size=UDim2.new(1,-12,0,22),Position=UDim2.new(0,6,1,-28),
        BackgroundColor3=T.bgAlt,BorderSizePixel=0,Parent=W})
    bind(footer,{BackgroundColor3="bgAlt"}); corner(footer,6)
    local fL=ui("TextLabel",{Size=UDim2.new(0.6,-8,1,0),Position=UDim2.fromOffset(10,0),
        BackgroundTransparency=1,Text="",TextColor3=T.textDim,TextSize=11,Font=Enum.Font.Code,
        TextXAlignment=Enum.TextXAlignment.Left,Parent=footer})
    bind(fL,{TextColor3="textDim"})
    local fR=ui("TextLabel",{Size=UDim2.new(0.4,-8,1,0),Position=UDim2.new(0.6,0,0,0),
        BackgroundTransparency=1,Text="",TextColor3=T.textDim,TextSize=11,Font=Enum.Font.Code,
        TextXAlignment=Enum.TextXAlignment.Right,Parent=footer})
    bind(fR,{TextColor3="textDim"})

    --======== RESIZE ========
    local grip=ui("TextButton",{Size=UDim2.fromOffset(18,18),Position=UDim2.new(1,-20,1,-20),
        BackgroundTransparency=1,Text="//",TextColor3=T.textDim,TextSize=12,
        Font=Enum.Font.GothamBold,AutoButtonColor=false,ZIndex=5,Parent=W})
    bind(grip,{TextColor3="textDim"})
    do local rz
        grip.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then
            rz={x=i.Position.X,y=i.Position.Y,w=W.AbsoluteSize.X,h=W.AbsoluteSize.Y} end end)
        UIS.InputChanged:Connect(function(i) if rz and i.UserInputType==Enum.UserInputType.MouseMovement then
            W.Size=UDim2.fromOffset(math.clamp(rz.w+i.Position.X-rz.x,460,960),
                                    math.clamp(rz.h+i.Position.Y-rz.y,300,720)) end end)
        UIS.InputEnded:Connect(function(i) if rz and i.UserInputType==Enum.UserInputType.MouseButton1 then
            Settings.set("menu_size",{w=W.AbsoluteSize.X,h=W.AbsoluteSize.Y}); rz=nil end end)
    end

    --======== DRAG ========
    do local d,ds,sp
        header.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then
            d=true; ds=i.Position; sp=W.Position end end)
        UIS.InputChanged:Connect(function(i) if d and i.UserInputType==Enum.UserInputType.MouseMovement then
            local dl=i.Position-ds; W.Position=UDim2.fromOffset(sp.X.Offset+dl.X,sp.Y.Offset+dl.Y) end end)
        UIS.InputEnded:Connect(function(i) if d and i.UserInputType==Enum.UserInputType.MouseButton1 then
            d=false; Settings.set("menu_pos",{x=W.Position.X.Offset,y=W.Position.Y.Offset}) end end)
    end

    --======== VISIBILITY ========
    self._visible=Settings.get("menu_visible",true); W.Visible=self._visible
    self._min=false
    MouseUnlock.setSource("menu", self._visible)
    function self:SetVisible(v) self._visible=v; W.Visible=v; Settings.set("menu_visible",v)
        MouseUnlock.setSource("menu", v)
        for _,fn in ipairs(self._vis) do pcall(fn,v) end end
    function self:ToggleVisible() self:SetVisible(not self._visible) end
    function self:OnVisibleChanged(fn) table.insert(self._vis,fn) end
    function self:ToggleMinimize()
        self._min=not self._min
        content.Visible=not self._min; footer.Visible=not self._min
        tabBar.Visible=not self._min; grip.Visible=not self._min
        W.Size=self._min and UDim2.fromOffset(W.AbsoluteSize.X,44)
            or UDim2.fromOffset(Settings.get("menu_size",{w=620}).w,Settings.get("menu_size",{h=420}).h)
    end

    --======== FOOTER STATUS ========
    local fps,fr,ft=60,0,tick()
    RunSvc.RenderStepped:Connect(function() fr=fr+1
        if tick()-ft>=0.5 then fps=fr/(tick()-ft); fr,ft=0,tick() end end)
    task.spawn(function() while sg.Parent do
        local n=0; for _,g in ipairs(self._getters) do if g() then n=n+1 end end
        fL.Text=("%d active"):format(n)
        fR.Text=("FPS %d   %s"):format(math.floor(fps), self._active and self._active.name or "")
        task.wait(0.5)
    end end)

    --======== SEARCH ========
    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local q=searchBox.Text:lower()
        for _,t in ipairs(self._tabs) do
            for _,r in ipairs(t._rows) do
                if r.frame then r.frame.Visible=(q=="" or r.label:lower():find(q,1,true)~=nil) end
            end
            if t._sections then for _,f in ipairs(t._sections) do f.Visible=(q=="") end end
            t:_resize()
        end
    end)

    --======== CONFIRM ========
    function self:Confirm(message,onYes)
        local mask=ui("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundColor3=Color3.new(0,0,0),
            BackgroundTransparency=0.55,BorderSizePixel=0,Text="",AutoButtonColor=false,
            ZIndex=600,Parent=sg})
        local dlg=ui("Frame",{Size=UDim2.fromOffset(330,140),Position=UDim2.new(0.5,-165,0.5,-70),
            BackgroundColor3=T.bgAlt,BorderSizePixel=0,ZIndex=601,Parent=mask})
        corner(dlg,10); stroke(dlg)
        ui("TextLabel",{Size=UDim2.new(1,-20,0,28),Position=UDim2.fromOffset(12,10),
            BackgroundTransparency=1,Text="Confirm",TextColor3=T.accent,TextSize=16,
            Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=602,Parent=dlg})
        ui("TextLabel",{Size=UDim2.new(1,-24,0,52),Position=UDim2.fromOffset(12,40),
            BackgroundTransparency=1,Text=message,TextColor3=T.text,TextSize=13,Font=Enum.Font.Gotham,
            TextWrapped=true,ZIndex=602,Parent=dlg})
        local yes=ui("TextButton",{Size=UDim2.fromOffset(90,30),Position=UDim2.new(1,-194,1,-42),
            BackgroundColor3=T.bad,BorderSizePixel=0,Text="Confirm",TextColor3=Color3.new(1,1,1),
            TextSize=13,Font=Enum.Font.GothamBold,ZIndex=602,Parent=dlg}); corner(yes,6)
        local no=ui("TextButton",{Size=UDim2.fromOffset(90,30),Position=UDim2.new(1,-98,1,-42),
            BackgroundColor3=T.bgRow,BorderSizePixel=0,Text="Cancel",TextColor3=T.text,
            TextSize=13,Font=Enum.Font.GothamBold,ZIndex=602,Parent=dlg}); corner(no,6)
        no.MouseButton1Click:Connect(function() mask:Destroy() end)
        mask.MouseButton1Click:Connect(function() mask:Destroy() end)
        yes.MouseButton1Click:Connect(function() mask:Destroy(); pcall(onYes) end)
    end

    --======== TAB ========
    function self:Tab(name, icon)
        local tab={name=name,_rows={},_sections={}}
        self._byName[name]=tab

        local pill=ui("TextButton",{Size=UDim2.fromOffset(0,28),AutomaticSize=Enum.AutomaticSize.X,
            BackgroundColor3=T.bgRow,BorderSizePixel=0,AutoButtonColor=false,Text="",
            LayoutOrder=#self._tabs+1,Parent=tabBar})
        bind(pill,{BackgroundColor3="bgRow"}); corner(pill,8)
        local plbl=ui("TextLabel",{AutomaticSize=Enum.AutomaticSize.X,Size=UDim2.fromOffset(0,28),
            BackgroundTransparency=1,Text=(icon and (icon.."  ") or "")..name,TextColor3=T.textDim,
            TextSize=13,Font=Enum.Font.GothamBold,Parent=pill})
        bind(plbl,{TextColor3="textDim"}); pad(plbl,12,0,12,0)

        local page=ui("ScrollingFrame",{Size=UDim2.new(1,-16,1,-16),Position=UDim2.fromOffset(8,8),
            BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=5,
            ScrollBarImageColor3=T.accent,CanvasSize=UDim2.new(0,0,0,0),Visible=false,Parent=content})
        bind(page,{ScrollBarImageColor3="accent"})
        local pl=ui("UIListLayout",{Padding=UDim.new(0,6),SortOrder=Enum.SortOrder.LayoutOrder},page)
        tab.page=page
        function tab:_resize()
            local h=0; for _,r in ipairs(self._rows) do
                if r.frame and r.frame.Visible then h=h+r.frame.AbsoluteSize.Y+6 end end
            page.CanvasSize=UDim2.new(0,0,0,h+12)
        end

        local function row(h) return ui("Frame",{Size=UDim2.new(1,0,0,h),BackgroundTransparency=1,Parent=page}) end

        function tab:Section(text)
            local f=row(24)
            local l=ui("TextLabel",{Size=UDim2.new(1,-8,1,0),Position=UDim2.fromOffset(4,4),
                BackgroundTransparency=1,Text=text:upper(),TextColor3=T.accent,TextSize=11,
                Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left,Parent=f})
            bind(l,{TextColor3="accent"})
            table.insert(self._rows,{frame=f,label=text}); table.insert(self._sections,f)
        end

        function tab:Toggle(label,getter,setter,tooltip)
            local f=row(36); f.BackgroundColor3=T.bgRow; corner(f,8); bind(f,{BackgroundColor3="bgRow"})
            local l=ui("TextLabel",{Size=UDim2.new(1,-62,1,0),Position=UDim2.fromOffset(14,0),
                BackgroundTransparency=1,Text=label,TextColor3=T.text,TextSize=13,Font=Enum.Font.Gotham,
                TextXAlignment=Enum.TextXAlignment.Left,Parent=f}); bind(l,{TextColor3="text"})
            local sw=ui("TextButton",{Size=UDim2.fromOffset(40,22),Position=UDim2.new(1,-50,0,7),
                BackgroundColor3=getter() and T.accent or T.bg,BorderSizePixel=0,Text="",
                AutoButtonColor=false,Parent=f}); corner(sw,11)
            local kn=ui("Frame",{Size=UDim2.fromOffset(16,16),
                Position=getter() and UDim2.fromOffset(22,3) or UDim2.fromOffset(3,3),
                BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,Parent=sw}); corner(kn,8)
            sw.MouseButton1Click:Connect(function()
                local v=not getter(); setter(v)
                tw(sw,0.13,{BackgroundColor3=v and T.accent or T.bg})
                tw(kn,0.13,{Position=v and UDim2.fromOffset(22,3) or UDim2.fromOffset(3,3)})
            end)
            tipFor(f,tooltip); table.insert(self._rows,{frame=f,label=label})
            if getter then table.insert(window._getters,getter) end
            self:_resize()
        end

        function tab:Button(label,fn,tooltip,danger)
            local f=row(34)
            local b=ui("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundColor3=danger and T.bad or T.bgRow,
                BorderSizePixel=0,AutoButtonColor=false,Text=label,TextColor3=T.text,TextSize=13,
                Font=Enum.Font.GothamBold,Parent=f}); corner(b,8)
            if not danger then bind(b,{BackgroundColor3="bgRow"}) end
            local base=danger and T.bad or T.bgRow
            b.MouseEnter:Connect(function() tw(b,0.1,{BackgroundColor3=danger and Color3.fromRGB(255,125,140) or T.accent2}) end)
            b.MouseLeave:Connect(function() tw(b,0.1,{BackgroundColor3=base}) end)
            b.MouseButton1Click:Connect(function()
                if danger then window:Confirm("Are you sure: "..label.."?",fn) else fn() end end)
            tipFor(f,tooltip); table.insert(self._rows,{frame=f,label=label}); self:_resize()
        end

        function tab:Slider(label,min,max,getter,setter,suffix,tooltip,default)
            local f=row(48); f.BackgroundColor3=T.bgRow; corner(f,8); bind(f,{BackgroundColor3="bgRow"})
            local l=ui("TextLabel",{Size=UDim2.new(1,-110,0,18),Position=UDim2.fromOffset(14,5),
                BackgroundTransparency=1,Text=label,TextColor3=T.text,TextSize=12,Font=Enum.Font.Gotham,
                TextXAlignment=Enum.TextXAlignment.Left,Parent=f}); bind(l,{TextColor3="text"})
            local box=ui("TextBox",{Size=UDim2.fromOffset(58,20),Position=UDim2.new(1,-(default~=nil and 90 or 64),0,5),
                BackgroundColor3=T.bg,BorderSizePixel=0,Text=tostring(getter()),TextColor3=T.accent,
                TextSize=12,Font=Enum.Font.Code,ClearTextOnFocus=false,Parent=f}); corner(box,4)
            bind(box,{BackgroundColor3="bg"})
            local bar=ui("Frame",{Size=UDim2.new(1,-28,0,6),Position=UDim2.fromOffset(14,34),
                BackgroundColor3=T.bg,BorderSizePixel=0,Parent=f}); corner(bar,3); bind(bar,{BackgroundColor3="bg"})
            local fill=ui("Frame",{Size=UDim2.new((getter()-min)/(max-min),0,1,0),
                BackgroundColor3=T.accent,BorderSizePixel=0,Parent=bar}); corner(fill,3); bind(fill,{BackgroundColor3="accent"})
            if default~=nil then
                local rb=ui("TextButton",{Size=UDim2.fromOffset(22,20),Position=UDim2.new(1,-26,0,5),
                    BackgroundColor3=T.bgHover,BorderSizePixel=0,Text="R",TextColor3=T.textDim,
                    TextSize=12,Font=Enum.Font.GothamBold,Parent=f}); corner(rb,4)
                rb.MouseButton1Click:Connect(function() setter(default); box.Text=tostring(default)
                    fill.Size=UDim2.new((default-min)/(max-min),0,1,0) end)
                tipFor(rb,"Reset to default")
            end
            local function setv(v,fromBar)
                v=math.clamp(v,min,max); setter(v); box.Text=tostring(v)
                if fromBar then fill.Size=UDim2.new((v-min)/(max-min),0,1,0)
                else tw(fill,0.05,{Size=UDim2.new((v-min)/(max-min),0,1,0)}) end
            end
            local drag
            bar.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=true
                setv(math.floor(min+(max-min)*math.clamp((i.Position.X-bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1)+0.5),true) end end)
            UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=false end end)
            UIS.InputChanged:Connect(function(i) if drag and i.UserInputType==Enum.UserInputType.MouseMovement then
                setv(math.floor(min+(max-min)*math.clamp((i.Position.X-bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1)+0.5),true) end end)
            box.FocusLost:Connect(function(e) if not e then return end
                local n=tonumber(box.Text); if n then setv(n) else box.Text=tostring(getter()) end end)
            tipFor(f,tooltip); table.insert(self._rows,{frame=f,label=label}); self:_resize()
        end

        function tab:TextInput(label,default,onSubmit,tooltip)
            local f=row(38); f.BackgroundColor3=T.bgRow; corner(f,8); bind(f,{BackgroundColor3="bgRow"})
            ui("TextLabel",{Size=UDim2.new(0,110,1,0),Position=UDim2.fromOffset(14,0),BackgroundTransparency=1,
                Text=label,TextColor3=T.text,TextSize=12,Font=Enum.Font.Gotham,
                TextXAlignment=Enum.TextXAlignment.Left,Parent=f})
            local inp=ui("TextBox",{Size=UDim2.new(1,-132,0,24),Position=UDim2.fromOffset(122,7),
                BackgroundColor3=T.bg,BorderSizePixel=0,Text=default or "",TextColor3=T.text,TextSize=12,
                Font=Enum.Font.Code,ClearTextOnFocus=false,Parent=f}); corner(inp,4); pad(inp,6); bind(inp,{BackgroundColor3="bg"})
            inp.FocusLost:Connect(function(e) if e and onSubmit then onSubmit(inp.Text) end end)
            tipFor(f,tooltip); table.insert(self._rows,{frame=f,label=label}); self:_resize()
        end

        function tab:Keybind(label,kname,getter,setter,tooltip)
            local f=row(34); f.BackgroundColor3=T.bgRow; corner(f,8); bind(f,{BackgroundColor3="bgRow"})
            ui("TextLabel",{Size=UDim2.new(1,-110,1,0),Position=UDim2.fromOffset(14,0),BackgroundTransparency=1,
                Text=label,TextColor3=T.text,TextSize=13,Font=Enum.Font.Gotham,
                TextXAlignment=Enum.TextXAlignment.Left,Parent=f})
            local b=ui("TextButton",{Size=UDim2.fromOffset(94,24),Position=UDim2.new(1,-104,0,5),
                BackgroundColor3=T.bg,BorderSizePixel=0,Text=(getter() and getter().Name) or "—",
                TextColor3=T.accent,TextSize=12,Font=Enum.Font.GothamBold,AutoButtonColor=false,Parent=f})
            corner(b,4); bind(b,{BackgroundColor3="bg"})
            local listening
            b.MouseButton1Click:Connect(function() if listening then return end listening=true
                b.Text="press…"; b.TextColor3=T.warn
                local c; c=UIS.InputBegan:Connect(function(input,gpe)
                    if gpe then return end
                    if input.UserInputType==Enum.UserInputType.Keyboard then
                        setter(input.KeyCode); b.Text=input.KeyCode.Name; b.TextColor3=T.accent
                        listening=false; if c then c:Disconnect() end end end)
            end)
            tipFor(f,tooltip); table.insert(self._rows,{frame=f,label=label}); self:_resize()
        end

        function tab:Dropdown(label,options,getter,setter,tooltip)
            local f=row(34); f.BackgroundColor3=T.bgRow; corner(f,8); bind(f,{BackgroundColor3="bgRow"})
            ui("TextLabel",{Size=UDim2.new(1,-140,1,0),Position=UDim2.fromOffset(14,0),BackgroundTransparency=1,
                Text=label,TextColor3=T.text,TextSize=13,Font=Enum.Font.Gotham,
                TextXAlignment=Enum.TextXAlignment.Left,Parent=f})
            local b=ui("TextButton",{Size=UDim2.fromOffset(120,24),Position=UDim2.new(1,-130,0,5),
                BackgroundColor3=T.bg,BorderSizePixel=0,Text=(getter() or "").."  v",TextColor3=T.accent,
                TextSize=12,Font=Enum.Font.GothamBold,AutoButtonColor=false,Parent=f}); corner(b,4); bind(b,{BackgroundColor3="bg"})
            local open=ui("Frame",{Size=UDim2.fromOffset(120,#options*24),Position=UDim2.fromOffset(0,30),
                BackgroundColor3=T.bg,BorderSizePixel=0,Visible=false,ZIndex=60,Parent=b}); corner(open,4); stroke(open)
            for i,opt in ipairs(options) do
                local o=ui("TextButton",{Size=UDim2.new(1,0,0,24),Position=UDim2.fromOffset(0,(i-1)*24),
                    BackgroundColor3=T.bg,BorderSizePixel=0,Text=opt,TextColor3=T.text,TextSize=12,
                    Font=Enum.Font.Gotham,AutoButtonColor=false,ZIndex=61,Parent=open})
                o.MouseEnter:Connect(function() o.BackgroundColor3=T.bgHover end)
                o.MouseLeave:Connect(function() o.BackgroundColor3=T.bg end)
                o.MouseButton1Click:Connect(function() setter(opt); b.Text=opt.."  v"; open.Visible=false end)
            end
            b.MouseButton1Click:Connect(function() open.Visible=not open.Visible end)
            tipFor(f,tooltip); table.insert(self._rows,{frame=f,label=label}); self:_resize()
        end

        function tab:Custom(builder,h) local f=row(h or 200); builder(f)
            table.insert(self._rows,{frame=f,label="Custom"}); self:_resize() end

        local function activate()
            for _,t in ipairs(self._tabs) do
                local sel=t==tab; t.page.Visible=sel
                tw(t._pill,0.12,{BackgroundColor3=sel and T.accent or T.bgRow})
                t._plbl.TextColor3=sel and Color3.new(1,1,1) or T.textDim
                if sel then self._active=t end
            end
            Settings.set("last_tab",tab.name)
        end
        pill.MouseEnter:Connect(function() if self._active~=tab then tw(pill,0.1,{BackgroundColor3=T.bgHover}) end end)
        pill.MouseLeave:Connect(function() if self._active~=tab then tw(pill,0.1,{BackgroundColor3=T.bgRow}) end end)
        pill.MouseButton1Click:Connect(activate)
        tab._pill=pill; tab._plbl=plbl; tab._activate=activate

        table.insert(self._tabs,tab)
        task.defer(function() tabBar.CanvasSize=UDim2.new(0,tabLayout.AbsoluteContentSize.X+12,0,0) end)
        if #self._tabs==1 then activate() end
        return tab
    end

    function self:JumpToTab(name) local t=self._byName[name]; if t then t._activate() end end
    function self:Notify(...) if _G.__Notify then _G.__Notify(...) end end

    task.defer(function()
        local last=Settings.get("last_tab",nil)
        if last and self._byName[last] then self:JumpToTab(last) end
    end)

    return self
end

return Library

end)
__bundle_register("Utility/MouseUnlock", function(require, _LOADED, __bundle_register, __bundle_modules)
-- MouseUnlock: frees the cursor while a menu window is open.
-- Many combat games (Deepwoken/VV) force MouseBehavior = LockCenter every
-- frame via the camera module, which traps the cursor. We re-assert a free
-- cursor on RenderPriority.Last (after the camera runs) so clicks land on the
-- menu. When no window wants it, we stop overriding and the game resumes.
local RunService = game:GetService("RunService")
local UIS        = game:GetService("UserInputService")
local Conns      = require("Utility/Conns")

local MouseUnlock = {}
local sources = {}      -- name -> true (open windows that want a free cursor)
local active  = 0
local bound   = false

local function step()
    if active <= 0 then return end
    if UIS.MouseBehavior ~= Enum.MouseBehavior.Default then
        UIS.MouseBehavior = Enum.MouseBehavior.Default
    end
    if not UIS.MouseIconEnabled then UIS.MouseIconEnabled = true end
end

local function ensureBound()
    if bound then return end
    bound = true
    -- Run AFTER the camera so our setting is the final word each frame.
    pcall(function()
        RunService:BindToRenderStep("VVMenuMouse", Enum.RenderPriority.Last.Value, step)
    end)
    Conns.onTeardown(function()
        pcall(function() RunService:UnbindFromRenderStep("VVMenuMouse") end)
        bound = false
    end)
end

-- name = unique window id, on = whether that window currently wants free mouse
function MouseUnlock.setSource(name, on)
    sources[name] = on or nil
    local n = 0
    for _ in pairs(sources) do n = n + 1 end
    active = n
    if active > 0 then ensureBound() end
end

return MouseUnlock

end)
__bundle_register("Features/KeybindHud", function(require, _LOADED, __bundle_register, __bundle_modules)
-- KeybindHud: small left-side panel listing all keybinds. Enabled features
-- glow green. Draggable + position persists. Never touches mouse behavior, so
-- it can't trap the cursor (we don't register it with MouseUnlock).
local RunService = game:GetService("RunService")
local UIS        = game:GetService("UserInputService")
local Players    = game:GetService("Players")
local LP         = Players.LocalPlayer
local Conns      = require("Utility/Conns")
local Settings   = require("Utility/Settings")
local Keybinds   = require("Utility/Keybinds")

local KH = {}
local State
local gui, panel
local rowByKb = {}

-- Palette (matches the purple theme)
local C = {
    bg=Color3.fromRGB(12,10,18), row=Color3.fromRGB(26,21,38),
    on=Color3.fromRGB(120,220,150), onBg=Color3.fromRGB(26,46,32),
    text=Color3.fromRGB(238,234,248), dim=Color3.fromRGB(160,152,186),
    accent=Color3.fromRGB(180,130,255), tag=Color3.fromRGB(18,15,26),
}
local function mk(cls,p,par) local i=Instance.new(cls); if p then for k,v in pairs(p) do i[k]=v end end; if par then i.Parent=par end; return i end
local function corner(i,r) mk("UICorner",{CornerRadius=UDim.new(0,r or 6)},i) end

-- label, keybind name, optional State key that means "enabled"
local ENTRIES = {
    { "Menu",       "toggle_menu" },
    { "AutoParry",  "toggle_autoparry",  "AutoParry" },
    { "Fly",        "toggle_fly",        "Fly" },
    { "Noclip",     "toggle_noclip",     "Noclip" },
    { "ESP",        "toggle_esp",        "ESP" },
    { "Sprint",     "toggle_sprint",     "ToggleSprint" },
    { "Visualizer", "toggle_visualizer", "AnimViz" },
}

local function build()
    gui = mk("ScreenGui", { Name="KeybindHud", ResetOnSpawn=false, DisplayOrder=998,
        IgnoreGuiInset=true, Parent=KH._parent })

    local pos = Settings.get("kbhud_pos", { x=14, y=180 })
    panel = mk("Frame", { Size=UDim2.fromOffset(168, 28 + #ENTRIES*24 + 8 + 16),
        Position=UDim2.fromOffset(pos.x, pos.y), BackgroundColor3=C.bg,
        BackgroundTransparency=0.1, BorderSizePixel=0, Parent=gui })
    corner(panel,8)
    mk("UIStroke",{Color=C.accent,Thickness=1,Transparency=0.4},panel)

    local title = mk("TextLabel", { Size=UDim2.new(1,-12,0,22), Position=UDim2.fromOffset(8,4),
        BackgroundTransparency=1, Text="KEYBINDS", TextColor3=C.accent, TextSize=12,
        Font=Enum.Font.GothamBold, TextXAlignment=Enum.TextXAlignment.Left, Parent=panel })

    -- footer hint: tells the user where to change these
    mk("TextLabel", { Size=UDim2.new(1,-12,0,14),
        Position=UDim2.fromOffset(8, 28 + #ENTRIES*24 + 4),
        BackgroundTransparency=1, Text="Change in Menu > Settings",
        TextColor3=C.dim, TextSize=10, Font=Enum.Font.Gotham,
        TextXAlignment=Enum.TextXAlignment.Left, Parent=panel })

    rowByKb = {}
    for i, e in ipairs(ENTRIES) do
        local label, kbName, stateKey = e[1], e[2], e[3]
        local row = mk("Frame", { Size=UDim2.new(1,-12,0,22), Position=UDim2.fromOffset(6, 26 + (i-1)*24),
            BackgroundColor3=C.row, BorderSizePixel=0, Parent=panel })
        corner(row,5)
        local name = mk("TextLabel", { Size=UDim2.new(1,-58,1,0), Position=UDim2.fromOffset(8,0),
            BackgroundTransparency=1, Text=label, TextColor3=C.text, TextSize=12,
            Font=Enum.Font.GothamBold, TextXAlignment=Enum.TextXAlignment.Left, Parent=row })
        local keyTag = mk("TextLabel", { Size=UDim2.fromOffset(46,16), Position=UDim2.new(1,-50,0,3),
            BackgroundColor3=C.tag, BorderSizePixel=0,
            Text="-", TextColor3=C.dim, TextSize=11, Font=Enum.Font.Code, Parent=row })
        corner(keyTag,4)
        rowByKb[kbName] = { row=row, name=name, key=keyTag, stateKey=stateKey }
    end

    -- drag whole panel (persist pos). Does NOT free the mouse, so when the
    -- game mouse is locked the panel just sits there; drag it while the menu
    -- is open (cursor free).
    local drag, ds, sp
    panel.InputBegan:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 then drag=true; ds=inp.Position; sp=panel.Position end
    end)
    UIS.InputChanged:Connect(function(inp)
        if drag and inp.UserInputType==Enum.UserInputType.MouseMovement then
            local d=inp.Position-ds
            panel.Position=UDim2.fromOffset(sp.X.Offset+d.X, sp.Y.Offset+d.Y)
        end
    end)
    UIS.InputEnded:Connect(function(inp)
        if drag and inp.UserInputType==Enum.UserInputType.MouseButton1 then
            drag=false
            Settings.set("kbhud_pos", { x=panel.Position.X.Offset, y=panel.Position.Y.Offset })
        end
    end)

    -- refresh loop (3Hz): colors + key labels
    local last = 0
    Conns.add(RunService.Heartbeat:Connect(function()
        if not gui or not gui.Enabled then return end
        if tick()-last < 0.3 then return end
        last = tick()
        for kbName, r in pairs(rowByKb) do
            local k = Keybinds.get(kbName)
            r.key.Text = k and k.Name or "-"
            local enabled = r.stateKey and State[r.stateKey]
            if enabled then
                r.row.BackgroundColor3 = C.onBg
                r.name.TextColor3 = C.on
                r.key.TextColor3 = C.on
            else
                r.row.BackgroundColor3 = C.row
                r.name.TextColor3 = C.text
                r.key.TextColor3 = C.dim
            end
        end
    end))
end

function KH.setParent(p) KH._parent = p end
function KH.setEnabled(v)
    State.KeybindHud = v
    if v then
        if not gui then build() end
        gui.Enabled = true
    elseif gui then
        gui.Enabled = false
    end
end

function KH.init(state)
    State = state
    Conns.onTeardown(function() if gui then pcall(function() gui:Destroy() end) end; gui=nil end)
end

return KH

end)
__bundle_register("Features/AnimationVisualizer", function(require, _LOADED, __bundle_register, __bundle_modules)
-- Animation Visualizer — clean redesign.
-- Layout is strictly column/list based (UIListLayout everywhere) so NOTHING
-- overlaps. Left = searchable/sortable animation list with categories,
-- favorites and recents. Right = viewport preview + info panel + transport
-- controls + timeline scrubber + "Save as Parry Timing" (each on its own row).
local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS        = game:GetService("UserInputService")
local LP         = Players.LocalPlayer
local Conns      = require("Utility/Conns")
local Settings   = require("Utility/Settings")
local MouseUnlock = require("Utility/MouseUnlock")

local AV = {}
local State

----------------------------------------------------------------------
-- THEME (reads Library theme via shared keys; falls back to purple)
----------------------------------------------------------------------
local C = {
    bg=Color3.fromRGB(8,7,12), bgAlt=Color3.fromRGB(14,12,20),
    row=Color3.fromRGB(24,20,34), hover=Color3.fromRGB(48,34,74),
    border=Color3.fromRGB(58,40,92), accent=Color3.fromRGB(180,130,255),
    accent2=Color3.fromRGB(140,86,235), text=Color3.fromRGB(245,242,252),
    dim=Color3.fromRGB(170,162,195), good=Color3.fromRGB(120,220,150),
    star=Color3.fromRGB(255,210,95),
}
local function mk(cls, props, parent)
    local i = Instance.new(cls)
    if props then for k,v in pairs(props) do i[k]=v end end
    if parent then i.Parent=parent end
    return i
end
local function corner(i,r) mk("UICorner",{CornerRadius=UDim.new(0,r or 6)},i) end
local function stroke(i,c) mk("UIStroke",{Color=c or C.border,Thickness=1},i) end

----------------------------------------------------------------------
-- DATA
----------------------------------------------------------------------
local nameCache = {}      -- id -> animation instance Name
local entityCache = {}    -- id -> cloned rig model (for preview)
local logged = {}         -- id -> { id, name, owner, cat, lastSeen }
local recents = {}        -- ordered ids, newest first
local favorites = Settings.get("av_favorites", {})  -- id -> true (json: array? use map)
if type(favorites) ~= "table" then favorites = {} end

-- Categorize by name keywords.
local CATS = {
    { cat="M1",      keys={"m1","swing","slash","combo"} },
    { cat="Critical",keys={"crit"} },
    { cat="Mantra",  keys={"mantra","cast","spell","talent"} },
    { cat="Heavy",   keys={"heavy","charge","aerial","leap","slam","smash"} },
    { cat="Weapon",  keys={"sword","spear","axe","dagger","scythe","mace",
                            "katana","hammer","bow","gun","rifle","fist","punch","kick"} },
}
local function categorize(name)
    local n = (name or ""):lower()
    for _, c in ipairs(CATS) do
        for _, k in ipairs(c.keys) do
            if n:find(k, 1, true) then return c.cat end
        end
    end
    return "Other"
end

-- Build the name index from every Animation instance in the game.
local function indexAnim(inst)
    if not inst:IsA("Animation") then return end
    local raw = inst.AnimationId or ""
    local id = raw:gsub("rbxassetid://", "")
    if id == "" then return end
    if nameCache[id] then return end
    if inst.Name ~= "" and inst.Name ~= "Animation" then nameCache[id] = inst.Name end
end
task.spawn(function()
    for _, d in ipairs(game:GetDescendants()) do pcall(indexAnim, d) end
end)
Conns.add(game.DescendantAdded:Connect(function(d) pcall(indexAnim, d) end))

function AV.resolveName(id) return nameCache[tostring(id)] end

-- Save favorites
local function saveFavs() Settings.set("av_favorites", favorites) end

----------------------------------------------------------------------
-- LOGGING (enemy animations)
----------------------------------------------------------------------
local sourceMode = "Enemies"   -- Enemies | Self | All
local refreshList   -- fwd

local function logAnim(track, ownerModel)
    local anim = track.Animation
    if not anim then return end
    local id = (anim.AnimationId or ""):gsub("rbxassetid://", "")
    if id == "" then return end
    local name = nameCache[id] or (anim.Name ~= "Animation" and anim.Name) or ("Anim " .. id)
    local entry = logged[id]
    if not entry then
        entry = { id=id, name=name, owner=ownerModel.Name, cat=categorize(name), lastSeen=os.clock() }
        logged[id] = entry
    else
        entry.lastSeen = os.clock()
        entry.owner = ownerModel.Name
        if nameCache[id] and entry.name ~= nameCache[id] then
            entry.name = nameCache[id]; entry.cat = categorize(entry.name)
        end
    end
    -- recents
    for i, rid in ipairs(recents) do if rid == id then table.remove(recents, i); break end end
    table.insert(recents, 1, id)
    while #recents > 30 do table.remove(recents) end
    -- cache rig for preview
    if not entityCache[id] then
        local ok, c = pcall(function() return ownerModel:Clone() end)
        if ok and c then entityCache[id] = c end
    end
    if AV._open and refreshList and not AV._refreshQueued then
        AV._refreshQueued = true
        task.delay(0.2, function()
            AV._refreshQueued = false
            if AV._open and refreshList then refreshList() end
        end)
    end
end

local Humanoids = require("Utility/Humanoids")
local hooked = setmetatable({}, { __mode = "k" })
local function hookHum(hum)
    if hooked[hum] then return end
    hooked[hum] = true
    Conns.add(hum.AnimationPlayed:Connect(function(track)
        local owner = hum.Parent
        if not owner then return end
        local isSelf = owner == LP.Character
        if sourceMode == "Enemies" and isSelf then return end
        if sourceMode == "Self" and not isSelf then return end
        logAnim(track, owner)
    end))
end
Humanoids.onAdded(hookHum)

----------------------------------------------------------------------
-- UI STATE
----------------------------------------------------------------------
local parent
local gui, win
local searchText, catFilter, sortMode = "", "All", "Recent"
local selectedId
local currentTrack, previewModel, viewport, vpCam, vpWM
local playSpeed = 1.0
local paused = false

function AV.setParent(p) parent = p end

----------------------------------------------------------------------
-- PREVIEW
----------------------------------------------------------------------
local function clearPreview()
    if currentTrack then pcall(function() currentTrack:Stop() end); currentTrack = nil end
    if vpWM then for _, c in ipairs(vpWM:GetChildren()) do if c:IsA("Model") then c:Destroy() end end end
    previewModel = nil
end

local infoName, infoId, infoMeta, scrubFill, scrubTime, saveBtn
local function loadPreview(id)
    selectedId = id
    clearPreview()
    local rig = entityCache[id]
    if not rig then
        if infoName then infoName.Text = "No rig captured yet" end
        return
    end
    local model = rig:Clone()
    model.Parent = vpWM
    pcall(function() model:PivotTo(CFrame.new(0,0,0)) end)
    previewModel = model
    if model.PrimaryPart then
        local _, sz = model:GetBoundingBox()
        vpCam.CFrame = CFrame.lookAt(
            model.PrimaryPart.Position - Vector3.new(0,0,sz.Magnitude),
            model.PrimaryPart.Position)
    end
    local animator = model:FindFirstChildWhichIsA("Animator", true)
    if not animator then if infoName then infoName.Text = "No animator" end return end
    for _, t in ipairs(animator:GetPlayingAnimationTracks()) do t:Stop() end
    local a = mk("Animation", { AnimationId = "rbxassetid://" .. id })
    currentTrack = animator:LoadAnimation(a)
    currentTrack.Looped = true
    currentTrack:Play(0, 1, paused and 0 or playSpeed)

    -- info panel
    local e = logged[id] or { name = nameCache[id] or ("Anim " .. id), cat = "?" }
    if infoName then infoName.Text = e.name end
    if infoId then infoId.Text = "rbxassetid://" .. id end
    local pt = _G.__ParryTimings
    local set = pt and pt.lookup and pt.lookup(id)
    if infoMeta then
        infoMeta.Text = string.format("Category: %s   |   Length: %.2fs   |   Parry: %s",
            e.cat or "?", currentTrack.Length,
            set and (math.floor(set*1000) .. "ms") or "not set")
    end
end

----------------------------------------------------------------------
-- LIST
----------------------------------------------------------------------
local listScroll, listLayout
local function rowsForView()
    local out = {}
    local q = searchText:lower()
    local function consider(id)
        local e = logged[id]; if not e then return end
        if catFilter == "Favorites" and not favorites[id] then return end
        if catFilter ~= "All" and catFilter ~= "Favorites" and catFilter ~= "Recent"
            and e.cat ~= catFilter then return end
        if q ~= "" then
            local hay = (e.name .. " " .. e.id .. " " .. (e.owner or "")):lower()
            if not hay:find(q, 1, true) then return end
        end
        table.insert(out, e)
    end
    if catFilter == "Recent" then
        for _, id in ipairs(recents) do consider(id) end
    else
        for id in pairs(logged) do consider(id) end
        if sortMode == "Name" then
            table.sort(out, function(a,b) return a.name:lower() < b.name:lower() end)
        elseif sortMode == "Category" then
            table.sort(out, function(a,b)
                if a.cat == b.cat then return a.name:lower() < b.name:lower() end
                return a.cat < b.cat end)
        elseif sortMode == "ID" then
            table.sort(out, function(a,b) return a.id < b.id end)
        else -- Recent
            table.sort(out, function(a,b) return (a.lastSeen or 0) > (b.lastSeen or 0) end)
        end
    end
    return out
end

refreshList = function()
    if not listScroll then return end
    for _, c in ipairs(listScroll:GetChildren()) do
        if c:IsA("Frame") then c:Destroy() end
    end
    local rows = rowsForView()
    for i, e in ipairs(rows) do
        local row = mk("Frame", {
            Size = UDim2.new(1, -4, 0, 40),
            BackgroundColor3 = (e.id == selectedId) and C.accent2 or C.row,
            BorderSizePixel = 0, LayoutOrder = i,
        }, listScroll)
        corner(row, 5)

        local fav = mk("TextButton", {
            Size = UDim2.fromOffset(26, 26), Position = UDim2.fromOffset(3, 7),
            BackgroundTransparency = 1, Text = "FAV",
            TextColor3 = favorites[e.id] and C.star or C.dim,
            TextSize = 10, Font = Enum.Font.GothamBlack,
        }, row)
        fav.MouseButton1Click:Connect(function()
            favorites[e.id] = (not favorites[e.id]) or nil
            saveFavs(); refreshList()
        end)

        local nameLbl = mk("TextLabel", {
            Size = UDim2.new(1, -90, 0, 18), Position = UDim2.fromOffset(30, 3),
            BackgroundTransparency = 1, Text = e.name, TextColor3 = C.text,
            TextSize = 13, Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
        }, row)
        local subLbl = mk("TextLabel", {
            Size = UDim2.new(1, -90, 0, 14), Position = UDim2.fromOffset(30, 21),
            BackgroundTransparency = 1,
            Text = string.format("%s · %s", e.cat or "?", e.id),
            TextColor3 = C.dim, TextSize = 11, Font = Enum.Font.Code,
            TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
        }, row)

        local copyBtn = mk("TextButton", {
            Size = UDim2.fromOffset(48, 24), Position = UDim2.new(1, -52, 0, 8),
            BackgroundColor3 = C.bg, BorderSizePixel = 0, Text = "Copy",
            TextColor3 = C.accent, TextSize = 11, Font = Enum.Font.GothamBold,
        }, row)
        corner(copyBtn, 4)
        copyBtn.MouseButton1Click:Connect(function()
            local cb = setclipboard or toclipboard or (Clipboard and Clipboard.set)
            if cb then pcall(cb, e.id) end
            copyBtn.Text = "✓"
            task.delay(0.5, function() if copyBtn.Parent then copyBtn.Text = "Copy" end end)
        end)

        local click = mk("TextButton", {
            Size = UDim2.new(1, -58, 1, 0), Position = UDim2.fromOffset(28, 0),
            BackgroundTransparency = 1, Text = "",
        }, row)
        click.MouseButton1Click:Connect(function() loadPreview(e.id); refreshList() end)
    end
    listScroll.CanvasSize = UDim2.new(0, 0, 0, #rows * 44)
    if AV._refreshRail then AV._refreshRail() end   -- keep category rail in sync
end

----------------------------------------------------------------------
-- CATEGORY PICKER (shown when saving a parry timing)
----------------------------------------------------------------------
-- onPick(categoryName) is called with the chosen/created category.
local function promptCategory(id, timeSec, onPick)
    local pt = _G.__ParryTimings
    local cats = (pt and pt.categories and pt.categories()) or {}
    -- Also offer the auto-detected category for this anim.
    local auto = (logged[id] and logged[id].cat)
    local haveAuto = false
    for _, c in ipairs(cats) do if c == auto then haveAuto = true end end
    if auto and auto ~= "" and not haveAuto then table.insert(cats, 1, auto) end

    local mask = mk("TextButton", { Size=UDim2.new(1,0,1,0), BackgroundColor3=Color3.new(0,0,0),
        BackgroundTransparency=0.55, BorderSizePixel=0, Text="", AutoButtonColor=false,
        ZIndex=400, Parent=gui })
    local dlg = mk("Frame", { Size=UDim2.fromOffset(340,360), Position=UDim2.new(0.5,-170,0.5,-180),
        BackgroundColor3=C.bgAlt, BorderSizePixel=0, ZIndex=401, Parent=mask })
    corner(dlg,10); stroke(dlg)
    mk("TextLabel", { Size=UDim2.new(1,-20,0,26), Position=UDim2.fromOffset(14,10),
        BackgroundTransparency=1, Text="💾  Save Parry Timing", TextColor3=C.accent, TextSize=16,
        Font=Enum.Font.GothamBlack, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=402, Parent=dlg })
    mk("TextLabel", { Size=UDim2.new(1,-24,0,18), Position=UDim2.fromOffset(14,38),
        BackgroundTransparency=1,
        Text=string.format("%s  @  %d ms", (logged[id] and logged[id].name) or id, math.floor(timeSec*1000)),
        TextColor3=C.dim, TextSize=12, Font=Enum.Font.Code,
        TextXAlignment=Enum.TextXAlignment.Left, ZIndex=402, Parent=dlg })
    mk("TextLabel", { Size=UDim2.new(1,-24,0,16), Position=UDim2.fromOffset(14,62),
        BackgroundTransparency=1, Text="Choose a category:", TextColor3=C.text, TextSize=12,
        Font=Enum.Font.GothamBold, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=402, Parent=dlg })

    -- existing categories list
    local listF = mk("ScrollingFrame", { Size=UDim2.new(1,-24,0,180), Position=UDim2.fromOffset(12,82),
        BackgroundColor3=C.bg, BorderSizePixel=0, ScrollBarThickness=4,
        CanvasSize=UDim2.new(0,0,0,0), ZIndex=402, Parent=dlg })
    corner(listF,6)
    local ll = mk("UIListLayout", { Padding=UDim.new(0,3), SortOrder=Enum.SortOrder.LayoutOrder }, listF)
    local function finish(cat)
        if pt and pt.set then pt.set(id, timeSec, cat) end
        mask:Destroy()
        if onPick then onPick(cat) end
    end
    if #cats == 0 then
        mk("TextLabel", { Size=UDim2.new(1,0,0,30), BackgroundTransparency=1,
            Text="(no categories yet — make one below)", TextColor3=C.dim, TextSize=12,
            Font=Enum.Font.Gotham, ZIndex=403, Parent=listF })
    end
    for i, cat in ipairs(cats) do
        local b = mk("TextButton", { Size=UDim2.new(1,-4,0,30), BackgroundColor3=C.row,
            BorderSizePixel=0, Text="  "..cat, TextColor3=C.text, TextSize=13,
            Font=Enum.Font.GothamBold, TextXAlignment=Enum.TextXAlignment.Left,
            LayoutOrder=i, ZIndex=403, Parent=listF })
        corner(b,5)
        b.MouseEnter:Connect(function() b.BackgroundColor3=C.hover end)
        b.MouseLeave:Connect(function() b.BackgroundColor3=C.row end)
        b.MouseButton1Click:Connect(function() finish(cat) end)
    end
    listF.CanvasSize = UDim2.new(0,0,0, math.max(#cats,1)*33)

    -- new category input + create
    local newBox = mk("TextBox", { Size=UDim2.new(1,-130,0,30), Position=UDim2.fromOffset(12,272),
        BackgroundColor3=C.bg, BorderSizePixel=0, PlaceholderText="New category name…",
        Text="", TextColor3=C.text, PlaceholderColor3=C.dim, TextSize=12, Font=Enum.Font.Gotham,
        ClearTextOnFocus=false, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=402, Parent=dlg })
    corner(newBox,6); mk("UIPadding",{PaddingLeft=UDim.new(0,8)},newBox)
    local createBtn = mk("TextButton", { Size=UDim2.fromOffset(104,30), Position=UDim2.new(1,-116,0,272),
        BackgroundColor3=C.accent2, BorderSizePixel=0, Text="Create & Save", TextColor3=Color3.new(1,1,1),
        TextSize=12, Font=Enum.Font.GothamBold, ZIndex=402, Parent=dlg })
    corner(createBtn,6)
    createBtn.MouseButton1Click:Connect(function()
        local name = (newBox.Text or ""):gsub("^%s+",""):gsub("%s+$","")
        if name == "" then return end
        finish(name)
    end)

    local cancel = mk("TextButton", { Size=UDim2.new(1,-24,0,28), Position=UDim2.fromOffset(12,318),
        BackgroundColor3=C.row, BorderSizePixel=0, Text="Cancel", TextColor3=C.text,
        TextSize=12, Font=Enum.Font.GothamBold, ZIndex=402, Parent=dlg })
    corner(cancel,6)
    cancel.MouseButton1Click:Connect(function() mask:Destroy() end)
    mask.MouseButton1Click:Connect(function() mask:Destroy() end)
end

----------------------------------------------------------------------
-- BUILD WINDOW
----------------------------------------------------------------------
local function build()
    gui = mk("ScreenGui", {
        Name = "AnimVisualizer", ResetOnSpawn = false,
        DisplayOrder = 1001, IgnoreGuiInset = true, Parent = parent,
    })

    local vpos = Settings.get("av_pos", { x = 150, y = 80 })
    local vsize = Settings.get("av_size", { w = 880, h = 600 })
    win = mk("Frame", {
        Size = UDim2.fromOffset(vsize.w, vsize.h),
        Position = UDim2.fromOffset(vpos.x, vpos.y),
        BackgroundColor3 = C.bg, BorderSizePixel = 0, Parent = gui,
    })
    corner(win, 10); stroke(win)
    -- soft shadow for premium depth
    mk("ImageLabel", { Size=UDim2.new(1,40,1,40), Position=UDim2.fromOffset(-20,-16),
        BackgroundTransparency=1, Image="rbxassetid://6014261993", ImageColor3=Color3.new(0,0,0),
        ImageTransparency=0.5, ZIndex=0, ScaleType=Enum.ScaleType.Slice,
        SliceCenter=Rect.new(49,49,450,450), Parent=win })
    -- resize grip (bottom-right), persists size
    local grip = mk("TextButton", { Size=UDim2.fromOffset(16,16), Position=UDim2.new(1,-18,1,-18),
        BackgroundTransparency=1, Text="//", TextColor3=C.dim, TextSize=12, Font=Enum.Font.GothamBold,
        AutoButtonColor=false, ZIndex=20, Parent=win })
    do local rz
        grip.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then
            rz={x=i.Position.X,y=i.Position.Y,w=win.AbsoluteSize.X,h=win.AbsoluteSize.Y} end end)
        UIS.InputChanged:Connect(function(i) if rz and i.UserInputType==Enum.UserInputType.MouseMovement then
            win.Size=UDim2.fromOffset(math.clamp(rz.w+i.Position.X-rz.x,520,1000),
                                      math.clamp(rz.h+i.Position.Y-rz.y,340,760)) end end)
        UIS.InputEnded:Connect(function(i) if rz and i.UserInputType==Enum.UserInputType.MouseButton1 then
            Settings.set("av_size",{w=win.AbsoluteSize.X,h=win.AbsoluteSize.Y}); rz=nil end end)
    end

    -- ===== Header (drag + close) =====
    local header = mk("Frame", { Size = UDim2.new(1,0,0,34), BackgroundColor3 = C.bgAlt,
        BorderSizePixel = 0, Parent = win })
    corner(header, 10)
    mk("Frame", { Size=UDim2.new(1,0,0,10), Position=UDim2.new(0,0,1,-10),
        BackgroundColor3=C.bgAlt, BorderSizePixel=0, Parent=header })
    mk("TextLabel", { Size=UDim2.new(1,-80,1,0), Position=UDim2.fromOffset(14,0),
        BackgroundTransparency=1, Text="Animation Visualizer", TextColor3=C.text,
        TextSize=15, Font=Enum.Font.GothamBlack, TextXAlignment=Enum.TextXAlignment.Left,
        Parent=header })
    local closeB = mk("TextButton", { Size=UDim2.fromOffset(26,22), Position=UDim2.new(1,-32,0,6),
        BackgroundColor3=C.row, BorderSizePixel=0, Text="×", TextColor3=C.bad and C.text,
        TextSize=16, Font=Enum.Font.GothamBold, Parent=header })
    corner(closeB,4)
    closeB.MouseButton1Click:Connect(function() AV.toggle(false) end)
    -- drag
    do
        local drag, ds, sp
        header.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=true; ds=i.Position; sp=win.Position end end)
        UIS.InputChanged:Connect(function(i) if drag and i.UserInputType==Enum.UserInputType.MouseMovement then
            local d=i.Position-ds; win.Position=UDim2.fromOffset(sp.X.Offset+d.X, sp.Y.Offset+d.Y) end end)
        UIS.InputEnded:Connect(function(i) if drag and i.UserInputType==Enum.UserInputType.MouseButton1 then
            drag=false; Settings.set("av_pos",{x=win.Position.X.Offset,y=win.Position.Y.Offset}) end end)
    end

    -- ===== Toolbar (search + source + sort) =====
    local toolbar = mk("Frame", { Size=UDim2.new(1,-16,0,28), Position=UDim2.fromOffset(8,40),
        BackgroundTransparency=1, Parent=win })

    local searchBox = mk("TextBox", { Size=UDim2.new(0.42,0,1,0), BackgroundColor3=C.bgAlt,
        BorderSizePixel=0, PlaceholderText="Search name / id…", Text="",
        TextColor3=C.text, PlaceholderColor3=C.dim, TextSize=12, Font=Enum.Font.Gotham,
        ClearTextOnFocus=false, TextXAlignment=Enum.TextXAlignment.Left, Parent=toolbar })
    corner(searchBox,5); mk("UIPadding",{PaddingLeft=UDim.new(0,8)},searchBox)
    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        searchText = searchBox.Text; refreshList() end)

    -- Source + Sort cycle buttons (explicit positions; no overlap with search)
    local srcBtn = mk("TextButton", { Size=UDim2.new(0,118,1,0), Position=UDim2.new(0.44,0,0,0),
        BackgroundColor3=C.bgAlt, BorderSizePixel=0, Text="Src: "..sourceMode,
        TextColor3=C.accent, TextSize=12, Font=Enum.Font.GothamBold, Parent=toolbar })
    corner(srcBtn,5)
    srcBtn.MouseButton1Click:Connect(function()
        local opts={"Enemies","Self","All"}; local idx=1
        for i,o in ipairs(opts) do if o==sourceMode then idx=i break end end
        sourceMode=opts[(idx%#opts)+1]; srcBtn.Text="Src: "..sourceMode
        logged={}; recents={}; refreshList()
    end)
    local sortBtn = mk("TextButton", { Size=UDim2.new(0,150,1,0), Position=UDim2.new(0.44,126,0,0),
        BackgroundColor3=C.bgAlt, BorderSizePixel=0, Text="Sort: "..sortMode,
        TextColor3=C.accent, TextSize=12, Font=Enum.Font.GothamBold, Parent=toolbar })
    corner(sortBtn,5)
    sortBtn.MouseButton1Click:Connect(function()
        local opts={"Recent","Name","Category","ID"}; local ci=1
        for i,o in ipairs(opts) do if o==sortMode then ci=i break end end
        sortMode=opts[(ci%#opts)+1]; sortBtn.Text="Sort: "..sortMode; refreshList()
    end)

    -- ===== Body: 3 columns (category rail | animation list | preview) =====
    local body = mk("Frame", { Size=UDim2.new(1,-16,1,-80), Position=UDim2.fromOffset(8,72),
        BackgroundTransparency=1, Parent=win })

    -- COLUMN 1: category rail
    local rail = mk("Frame", { Size=UDim2.new(0,160,1,0), Position=UDim2.fromOffset(0,0),
        BackgroundColor3=C.bgAlt, BorderSizePixel=0, Parent=body })
    corner(rail,8)
    mk("TextLabel", { Size=UDim2.new(1,-12,0,20), Position=UDim2.fromOffset(10,6),
        BackgroundTransparency=1, Text="CATEGORIES", TextColor3=C.accent, TextSize=11,
        Font=Enum.Font.GothamBold, TextXAlignment=Enum.TextXAlignment.Left, Parent=rail })
    local railScroll = mk("ScrollingFrame", { Size=UDim2.new(1,-8,1,-32), Position=UDim2.fromOffset(4,28),
        BackgroundTransparency=1, BorderSizePixel=0, ScrollBarThickness=3,
        CanvasSize=UDim2.new(0,0,0,0), Parent=rail })
    local railLayout = mk("UIListLayout", { Padding=UDim.new(0,3), SortOrder=Enum.SortOrder.LayoutOrder }, railScroll)

    local railBtns = {}
    local FIXED = { {"⭐ Favorites","Favorites"}, {"🕒 Recent","Recent"}, {"📋 All","All"} }
    local function refreshRail(force)
        -- gather dynamic categories present in logged data
        local seen, dyn = {}, {}
        for _, e in pairs(logged) do
            local c = e.cat or "Other"
            if not seen[c] then seen[c] = true; table.insert(dyn, c) end
        end
        table.sort(dyn)
        -- signature guard: skip rebuild if categories + selection unchanged
        local sig = catFilter .. "|" .. table.concat(dyn, ",")
        if not force and sig == AV._railSig then return end
        AV._railSig = sig
        for _, c in ipairs(railScroll:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
        railBtns = {}
        local items = {}
        for _, f in ipairs(FIXED) do table.insert(items, f) end
        for _, c in ipairs(dyn) do table.insert(items, { c, c }) end
        for i, it in ipairs(items) do
            local label, key = it[1], it[2]
            local b = mk("TextButton", { Size=UDim2.new(1,-4,0,28),
                BackgroundColor3=(catFilter==key) and C.accent or C.row, BorderSizePixel=0,
                Text="  "..label, TextColor3=(catFilter==key) and Color3.new(1,1,1) or C.text,
                TextSize=12, Font=Enum.Font.GothamBold, TextXAlignment=Enum.TextXAlignment.Left,
                LayoutOrder=i, Parent=railScroll })
            corner(b,5)
            b.MouseButton1Click:Connect(function() catFilter=key; refreshRail(true); refreshList() end)
            railBtns[key]=b
        end
        railScroll.CanvasSize = UDim2.new(0,0,0,#items*31)
    end
    AV._refreshRail = refreshRail

    -- COLUMN 2: animation list
    local listPane = mk("Frame", { Size=UDim2.new(0.42,-4,1,0), Position=UDim2.fromOffset(168,0),
        BackgroundColor3=C.bgAlt, BorderSizePixel=0, Parent=body })
    corner(listPane,8)
    listScroll = mk("ScrollingFrame", { Size=UDim2.new(1,-8,1,-8), Position=UDim2.fromOffset(4,4),
        BackgroundTransparency=1, BorderSizePixel=0, ScrollBarThickness=4,
        CanvasSize=UDim2.new(0,0,0,0), Parent=listPane })
    listLayout = mk("UIListLayout", { Padding=UDim.new(0,3), SortOrder=Enum.SortOrder.LayoutOrder }, listScroll)

    -- COLUMN 3: preview / detail
    local rightPane = mk("Frame", { Size=UDim2.new(0.58,-164,1,0), Position=UDim2.new(0.42,172,0,0),
        BackgroundColor3=C.bgAlt, BorderSizePixel=0, Parent=body })
    corner(rightPane,8)
    local detail = mk("Frame", { Size=UDim2.new(1,-12,1,-12), Position=UDim2.fromOffset(6,6),
        BackgroundTransparency=1, Parent=rightPane })
    local dLayout = mk("UIListLayout", { Padding=UDim.new(0,6), SortOrder=Enum.SortOrder.LayoutOrder }, detail)

    -- 1) viewport
    viewport = mk("ViewportFrame", { Size=UDim2.new(1,0,0,150), BackgroundColor3=C.bg,
        BorderSizePixel=0, LayoutOrder=1, Parent=detail })
    corner(viewport,6)
    vpWM = mk("WorldModel", {}, viewport)
    vpCam = mk("Camera", { FieldOfView=60 }, viewport); viewport.CurrentCamera = vpCam

    -- 2) info name
    infoName = mk("TextLabel", { Size=UDim2.new(1,0,0,20), BackgroundTransparency=1,
        Text="Select an animation", TextColor3=C.text, TextSize=15, Font=Enum.Font.GothamBold,
        TextXAlignment=Enum.TextXAlignment.Left, LayoutOrder=2, Parent=detail })
    -- 3) info id (with copy)
    local idRow = mk("Frame", { Size=UDim2.new(1,0,0,22), BackgroundTransparency=1, LayoutOrder=3, Parent=detail })
    infoId = mk("TextLabel", { Size=UDim2.new(1,-60,1,0), BackgroundTransparency=1,
        Text="—", TextColor3=C.accent, TextSize=12, Font=Enum.Font.Code,
        TextXAlignment=Enum.TextXAlignment.Left, TextTruncate=Enum.TextTruncate.AtEnd, Parent=idRow })
    local idCopy = mk("TextButton", { Size=UDim2.fromOffset(54,20), Position=UDim2.new(1,-54,0,1),
        BackgroundColor3=C.row, BorderSizePixel=0, Text="Copy ID", TextColor3=C.accent,
        TextSize=11, Font=Enum.Font.GothamBold, Parent=idRow })
    corner(idCopy,4)
    idCopy.MouseButton1Click:Connect(function()
        if not selectedId then return end
        local cb = setclipboard or toclipboard or (Clipboard and Clipboard.set)
        if cb then pcall(cb, selectedId) end
        idCopy.Text="✓"; task.delay(0.5,function() if idCopy.Parent then idCopy.Text="Copy ID" end end)
    end)
    -- 4) meta line
    infoMeta = mk("TextLabel", { Size=UDim2.new(1,0,0,16), BackgroundTransparency=1,
        Text="", TextColor3=C.dim, TextSize=11, Font=Enum.Font.Gotham,
        TextXAlignment=Enum.TextXAlignment.Left, LayoutOrder=4, Parent=detail })

    -- 5) transport controls
    local ctrl = mk("Frame", { Size=UDim2.new(1,0,0,28), BackgroundTransparency=1, LayoutOrder=5, Parent=detail })
    local function tbtn(x,w,txt,fn)
        local b=mk("TextButton",{Size=UDim2.new(0,w,1,0),Position=UDim2.fromOffset(x,0),
            BackgroundColor3=C.row,BorderSizePixel=0,Text=txt,TextColor3=C.text,
            TextSize=13,Font=Enum.Font.GothamBold,Parent=ctrl}); corner(b,5); b.MouseButton1Click:Connect(fn); return b
    end
    local playBtn = tbtn(0,58,"Pause", function()
        if not currentTrack then return end
        paused = not paused
        currentTrack:AdjustSpeed(paused and 0 or playSpeed)
    end)
    playBtn.Name = "play"
    tbtn(62,64,"Restart", function()
        if currentTrack then currentTrack.TimePosition = 0 end
    end)
    -- speed label + slider area
    local spdLbl = mk("TextLabel",{Size=UDim2.new(0,64,1,0),Position=UDim2.fromOffset(132,0),
        BackgroundTransparency=1,Text="Speed 1.0x",TextColor3=C.dim,TextSize=11,
        Font=Enum.Font.Code,TextXAlignment=Enum.TextXAlignment.Left,Parent=ctrl})
    local spdBar = mk("Frame",{Size=UDim2.new(1,-204,0,6),Position=UDim2.fromOffset(200,11),
        BackgroundColor3=C.bg,BorderSizePixel=0,Parent=ctrl}); corner(spdBar,3)
    local spdFill = mk("Frame",{Size=UDim2.new((1.0-0.1)/(2.0-0.1),0,1,0),
        BackgroundColor3=C.accent,BorderSizePixel=0,Parent=spdBar}); corner(spdFill,3)
    do
        local dragging
        local function applySpd(x)
            local rel=math.clamp((x-spdBar.AbsolutePosition.X)/spdBar.AbsoluteSize.X,0,1)
            playSpeed = math.floor((0.1 + rel*(2.0-0.1))*10+0.5)/10
            spdLbl.Text = "Speed "..playSpeed.."x"
            spdFill.Size=UDim2.new(rel,0,1,0)
            if currentTrack and not paused then currentTrack:AdjustSpeed(playSpeed) end
        end
        spdBar.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true; applySpd(i.Position.X) end end)
        UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end end)
        UIS.InputChanged:Connect(function(i) if dragging and i.UserInputType==Enum.UserInputType.MouseMovement then applySpd(i.Position.X) end end)
    end

    -- 6) timeline scrubber (own row)
    local timeRow = mk("Frame", { Size=UDim2.new(1,0,0,30), BackgroundTransparency=1, LayoutOrder=6, Parent=detail })
    scrubTime = mk("TextLabel",{Size=UDim2.new(1,0,0,12),BackgroundTransparency=1,
        Text="0 / 0 ms",TextColor3=C.dim,TextSize=11,Font=Enum.Font.Code,
        TextXAlignment=Enum.TextXAlignment.Left,Parent=timeRow})
    local scrubBar = mk("Frame",{Size=UDim2.new(1,0,0,8),Position=UDim2.fromOffset(0,16),
        BackgroundColor3=C.bg,BorderSizePixel=0,Parent=timeRow}); corner(scrubBar,4)
    scrubFill = mk("Frame",{Size=UDim2.new(0,0,1,0),BackgroundColor3=C.accent,
        BorderSizePixel=0,Parent=scrubBar}); corner(scrubFill,4)
    do
        local dragging
        local function applyScrub(x)
            if not currentTrack then return end
            paused = true
            if playBtn then playBtn.Text = "Play" end
            currentTrack:AdjustSpeed(0)
            local rel=math.clamp((x-scrubBar.AbsolutePosition.X)/scrubBar.AbsoluteSize.X,0,1)
            currentTrack.TimePosition = rel * currentTrack.Length
            scrubFill.Size=UDim2.new(rel,0,1,0)
        end
        scrubBar.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true; applyScrub(i.Position.X) end end)
        UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end end)
        UIS.InputChanged:Connect(function(i) if dragging and i.UserInputType==Enum.UserInputType.MouseMovement then applyScrub(i.Position.X) end end)
    end

    -- 7) Save as parry timing (own row, BELOW scrubber — no overlap)
    saveBtn = mk("TextButton", { Size=UDim2.new(1,0,0,30), BackgroundColor3=C.accent2,
        BorderSizePixel=0, Text="Save current frame as Parry Timing", TextColor3=Color3.fromRGB(255,255,255),
        TextSize=13, Font=Enum.Font.GothamBold, LayoutOrder=7, Parent=detail })
    corner(saveBtn,6)
    saveBtn.MouseButton1Click:Connect(function()
        if not currentTrack or not selectedId then return end
        local id, ts = selectedId, currentTrack.TimePosition
        promptCategory(id, ts, function(cat)
            if _G.__Notify then _G.__Notify("Parry Timing Saved",
                string.format("%s -> %s @ %dms",
                    (logged[id] and logged[id].name) or id, cat, math.floor(ts*1000)),
                2.5, C.good) end
            if selectedId == id then loadPreview(id) end  -- refresh meta
        end)
    end)

    -- live scrubber/time update
    Conns.add(RunService.RenderStepped:Connect(function()
        if not (gui and gui.Parent and currentTrack) then return end
        if playBtn then playBtn.Text = paused and "Play" or "Pause" end
        local len = currentTrack.Length
        local rel = (len > 0) and currentTrack.TimePosition/len or 0
        scrubFill.Size = UDim2.new(rel, 0, 1, 0)
        scrubTime.Text = string.format("%d / %d ms",
            math.floor(currentTrack.TimePosition*1000), math.floor(len*1000))
    end))

    refreshRail(true)
    refreshList()
end

----------------------------------------------------------------------
-- PUBLIC
----------------------------------------------------------------------
function AV.toggle(v)
    State.AnimViz = v
    MouseUnlock.setSource("anim", v)
    if v then
        if not gui then build() end
        gui.Enabled = true; AV._open = true; win.Visible = true
        refreshList()
    else
        AV._open = false
        if gui then gui.Enabled = false end
    end
end

function AV.openWithId(id)
    AV.toggle(true)
    id = tostring(id):gsub("rbxassetid://", "")
    -- ensure it's in the log even if never seen
    if not logged[id] then
        logged[id] = { id=id, name=nameCache[id] or ("Anim "..id), owner="?",
            cat=categorize(nameCache[id] or ""), lastSeen=os.clock() }
    end
    loadPreview(id); refreshList()
end

function AV.init(state)
    State = state
    Conns.onTeardown(function()
        if gui then pcall(function() gui:Destroy() end) end
        gui=nil; win=nil; currentTrack=nil
    end)
end

return AV

end)
__bundle_register("Utility/Humanoids", function(require, _LOADED, __bundle_register, __bundle_modules)
-- Shared humanoid registry. Maintained once via DescendantAdded/Removing so
-- features (ESP, AutoParry, AnimVisualizer) never have to walk
-- workspace:GetDescendants() on a timer — the single biggest perf win.
local Conns = require("Utility/Conns")

local Humanoids = {}
local set = {}            -- humanoid -> true
local addedCbs = {}       -- callbacks(hum) for new humanoids

local function add(h)
    if set[h] then return end
    set[h] = true
    for _, cb in ipairs(addedCbs) do pcall(cb, h) end
end

for _, d in ipairs(workspace:GetDescendants()) do
    if d:IsA("Humanoid") then add(d) end
end
Conns.add(workspace.DescendantAdded:Connect(function(o)
    if o:IsA("Humanoid") then add(o) end
end))
Conns.add(workspace.DescendantRemoving:Connect(function(o)
    if o:IsA("Humanoid") then set[o] = nil end
end))

-- Self-healing rescan: events can miss humanoids in games with streaming or
-- odd load order. Every 1.5s we sweep workspace to add any we missed and drop
-- dead refs. Cheap (runs at <1 Hz) and guarantees ESP/AutoParry see everyone.
local RunService = game:GetService("RunService")
do
    local last = 0
    Conns.add(RunService.Heartbeat:Connect(function()
        if tick() - last < 1.5 then return end
        last = tick()
        for h in pairs(set) do
            if not h.Parent then set[h] = nil end
        end
        for _, d in ipairs(workspace:GetDescendants()) do
            if d:IsA("Humanoid") and not set[d] then add(d) end
        end
    end))
end

-- Iterate current humanoids: for hum in Humanoids.iter() do ... end
function Humanoids.iter() return pairs(set) end
function Humanoids.set() return set end
-- Register a callback fired for every humanoid (existing + future).
function Humanoids.onAdded(cb)
    for h in pairs(set) do pcall(cb, h) end
    table.insert(addedCbs, cb)
end

return Humanoids

end)
__bundle_register("Features/ModeratorChecker", function(require, _LOADED, __bundle_register, __bundle_modules)
-- ModeratorChecker: scans server for known game moderators / admins.
-- Triggers Notification when a moderator is spotted.
--
-- Detection sources (any one triggers):
--   * Username on the user-editable list (getgenv().ModeratorList)
--   * Player has a "Mod" / "Admin" / "Developer" tag attribute set
--   * Player's leaderstats contains "Admin" / "Moderator"
local Players      = game:GetService("Players")
local Conns        = require("Utility/Conns")
local Notification = require("Features/Notification")

local ModeratorChecker = {}
local State

-- Default list (lowercase). User can extend with getgenv().ModeratorList = {...}
local DEFAULT_MODS = {
    -- Add known VV Ultimatum mods here, lowercase.
}

local function isModerator(player)
    local nm = player.Name:lower()
    -- Custom list via globals
    local list = getgenv().ModeratorList
    if type(list) == "table" then
        for _, n in ipairs(list) do
            if nm == tostring(n):lower() then return "Custom list" end
        end
    end
    for _, n in ipairs(DEFAULT_MODS) do
        if nm == n then return "Default list" end
    end
    -- Attribute / tag heuristics
    for _, k in ipairs({"Mod","Moderator","Admin","Developer","Staff"}) do
        if player:GetAttribute(k) then return "Attribute: " .. k end
    end
    -- Leaderstats heuristics
    local ls = player:FindFirstChild("leaderstats")
    if ls then
        for _, v in ipairs(ls:GetChildren()) do
            local n = v.Name:lower()
            if n:find("admin") or n:find("mod") or n:find("staff") then
                return "Leaderstats: " .. v.Name
            end
        end
    end
    return nil
end

local function check(player)
    if not State or not State.ModeratorChecker then return end
    if player == Players.LocalPlayer then return end
    local reason = isModerator(player)
    if reason then
        Notification.send("⚠ Moderator: " .. player.Name,
            "Reason: " .. reason, 8, Color3.fromRGB(255, 90, 90))
    end
end

function ModeratorChecker.scanAll()
    for _, p in ipairs(Players:GetPlayers()) do check(p) end
end
function ModeratorChecker.setEnabled(v)
    State.ModeratorChecker = v
    if v then ModeratorChecker.scanAll() end
end

function ModeratorChecker.init(state)
    State = state
    -- Hook future joiners.
    Conns.add(Players.PlayerAdded:Connect(check))
    -- Initial pass after a tiny delay so Notification UI is up.
    task.delay(1, function() if State.ModeratorChecker then ModeratorChecker.scanAll() end end)
end

return ModeratorChecker

end)
__bundle_register("Features/Notification", function(require, _LOADED, __bundle_register, __bundle_modules)
-- Notification: stackable corner toasts.
-- Other features call:  Notification.send(title, message, duration, color)
local Players  = game:GetService("Players")
local TweenSvc = game:GetService("TweenService")
local LP       = Players.LocalPlayer
local Conns    = require("Utility/Conns")

local Notification = {}
local State

local screen
local active = {}     -- ordered list of frames currently visible
local SPACING = 8

local function repackage()
    local y = 16
    for _, n in ipairs(active) do
        n.frame:TweenPosition(UDim2.new(1, -16, 0, y),
            Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
        y = y + n.frame.AbsoluteSize.Y + SPACING
    end
end

function Notification.send(title, message, duration, color)
    if not State or not State.NotificationsEnabled then return end
    if not screen then return end
    duration = duration or 3
    color    = color    or Color3.fromRGB(96, 175, 255)

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 280, 0, 56)
    frame.Position = UDim2.new(1, 16, 0, 16)      -- start off-screen right
    frame.AnchorPoint = Vector2.new(1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
    frame.BorderSizePixel = 0
    frame.Parent = screen

    local c = Instance.new("UICorner", frame); c.CornerRadius = UDim.new(0, 6)
    local stripe = Instance.new("Frame", frame)
    stripe.Size = UDim2.new(0, 4, 1, 0); stripe.BackgroundColor3 = color
    stripe.BorderSizePixel = 0
    local sc = Instance.new("UICorner", stripe); sc.CornerRadius = UDim.new(0, 4)

    local t = Instance.new("TextLabel", frame)
    t.Size = UDim2.new(1, -16, 0, 18); t.Position = UDim2.new(0, 12, 0, 6)
    t.BackgroundTransparency = 1; t.Text = title or ""
    t.TextColor3 = Color3.fromRGB(240, 240, 245)
    t.TextSize = 14; t.Font = Enum.Font.GothamBold
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.TextTruncate = Enum.TextTruncate.AtEnd

    local m = Instance.new("TextLabel", frame)
    m.Size = UDim2.new(1, -16, 0, 24); m.Position = UDim2.new(0, 12, 0, 24)
    m.BackgroundTransparency = 1; m.Text = message or ""
    m.TextColor3 = Color3.fromRGB(190, 195, 210)
    m.TextSize = 12; m.Font = Enum.Font.Gotham
    m.TextXAlignment = Enum.TextXAlignment.Left
    m.TextWrapped = true

    local entry = { frame = frame }
    table.insert(active, 1, entry)
    repackage()

    task.delay(duration, function()
        if not frame.Parent then return end
        TweenSvc:Create(frame, TweenInfo.new(0.2),
            { Position = UDim2.new(1, 16, frame.Position.Y.Scale, frame.Position.Y.Offset) }):Play()
        task.wait(0.22)
        if frame.Parent then frame:Destroy() end
        for i, e in ipairs(active) do
            if e == entry then table.remove(active, i); break end
        end
        repackage()
    end)
end

function Notification.setParent(p)
    if screen then pcall(function() screen:Destroy() end) end
    screen = Instance.new("ScreenGui")
    screen.Name = "Notifications"
    screen.ResetOnSpawn = false
    screen.DisplayOrder = 1000
    screen.IgnoreGuiInset = true
    screen.Parent = p
end

function Notification.init(state)
    State = state
    Conns.onTeardown(function()
        if screen then pcall(function() screen:Destroy() end) end
        active = {}; screen = nil
    end)
end

return Notification

end)
__bundle_register("Features/Debug", function(require, _LOADED, __bundle_register, __bundle_modules)
-- Debug: on-screen diagnostic panel.
-- Shows FPS, ping, memory, active feature flags, and latest AutoParry result.
local RS       = game:GetService("RunService")
local Stats    = game:GetService("Stats")
local LP       = game:GetService("Players").LocalPlayer
local Conns    = require("Utility/Conns")

local Debug = {}
local State, panel, lines, parent

local function build()
    panel = Instance.new("Frame")
    panel.Name = "DebugPanel"
    panel.Size = UDim2.new(0, 240, 0, 160)
    panel.Position = UDim2.new(1, -260, 0, 60)
    panel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    panel.BackgroundTransparency = 0.4
    panel.BorderSizePixel = 0
    panel.Parent = parent
    local c = Instance.new("UICorner", panel); c.CornerRadius = UDim.new(0, 4)

    lines = {}
    local list = Instance.new("UIListLayout", panel)
    list.Padding = UDim.new(0, 2); list.SortOrder = Enum.SortOrder.LayoutOrder
    local pad = Instance.new("UIPadding", panel)
    pad.PaddingLeft = UDim.new(0, 8); pad.PaddingRight = UDim.new(0, 8)
    pad.PaddingTop = UDim.new(0, 6); pad.PaddingBottom = UDim.new(0, 6)

    for i = 1, 8 do
        local l = Instance.new("TextLabel", panel)
        l.LayoutOrder = i; l.Size = UDim2.new(1, 0, 0, 16)
        l.BackgroundTransparency = 1
        l.TextColor3 = Color3.fromRGB(120, 255, 120)
        l.TextSize = 12; l.Font = Enum.Font.Code
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.Text = ""
        lines[i] = l
    end
end

local function destroy()
    if panel then pcall(function() panel:Destroy() end) end
    panel = nil; lines = nil
end

local frames, t0 = 0, tick()
local fps = 0
local function tick_loop()
    frames = frames + 1
    if tick() - t0 >= 0.5 then
        fps = frames / (tick() - t0)
        frames = 0; t0 = tick()
    end
    if not State or not State.Debug then return end
    if not panel then build() end
    local ping = 0; pcall(function() ping = LP:GetNetworkPing() * 2000 end)  -- ms RTT
    local mem  = math.floor((collectgarbage("count") or 0) / 1024)
    lines[1].Text = ("FPS: %.0f"):format(fps)
    lines[2].Text = ("Ping: %.0f ms"):format(ping)
    lines[3].Text = ("Lua Mem: %d MB"):format(mem)
    lines[4].Text = "—"
    lines[5].Text = ("AutoParry: %s"):format(State.AutoParry and "ON" or "off")
    lines[6].Text = ("Sprint:   %s"):format(State.ToggleSprint and "ON" or "off")
    lines[7].Text = ("Fly: %s | Noclip: %s"):format(
        State.Fly and "ON" or "off", State.Noclip and "ON" or "off")
    lines[8].Text = (_G.__lastParry and ("Last parry: " .. _G.__lastParry))
                    or "Last parry: —"
end

function Debug.setDebug(v)
    State.Debug = v
    if not v then destroy() end
end

function Debug.setParent(p) parent = p end
function Debug.init(state)
    State = state
    Conns.add(RS.RenderStepped:Connect(tick_loop))
    Conns.onTeardown(destroy)
end

return Debug

end)
__bundle_register("Features/Combat", function(require, _LOADED, __bundle_register, __bundle_modules)
-- AutoParry: simple, reliable, easy to configure.
--
-- Each enemy AnimationPlayed builds a Task that fires M2 at `target` seconds
-- relative to anim start. `target` comes from ParryTimings (parrytimings.json),
-- which is built from AutoParryData. The user can also set/override a timing
-- per anim id from the menu (Combat.setManual).
--
-- Spam guards: per-track once, per-id 0.4s, global 0.25s, post-damage 0.3s stun.
local RunService = game:GetService("RunService")
local Players    = game:GetService("Players")
local UIS        = game:GetService("UserInputService")
local VIM        = game:GetService("VirtualInputManager")
local LP         = Players.LocalPlayer
local getCharParts = require("Utility/Char")
local Conns        = require("Utility/Conns")
local Humanoids    = require("Utility/Humanoids")
local Latency      = require("Utility/Latency")
local Notification = require("Features/Notification")

local Combat = {}
local State

local pending = {}              -- track -> { animId, start, target, fired, char }
_G.__AutoParryActive = pending

-- Tight, accurate timing. We fire on the FIRST heartbeat where elapsed
-- crosses the configured target (max ~1 frame / 16ms overshoot), so the
-- value you set in the menu is the value that actually fires.
local GLOBAL_DEBOUNCE = 0.06    -- stops 2 presses on the same frame only
local SAME_TRACK_ONCE = true    -- each track fires exactly once (s.fired)
local HITSTUN         = 0.25    -- ignore window right after taking damage

local lastFire, hitstunUntil = 0, 0

local function pressM2()
    -- Try mouse2press first, else VIM, else firesignal.
    if mouse2press and mouse2release then
        pcall(function() mouse2press(); task.wait(0.02); mouse2release() end); return
    end
    local sent = false
    pcall(function()
        local m = LP:GetMouse()
        local x, y = m.X or 0, m.Y or 0
        VIM:SendMouseButtonEvent(x, y, 1, true, game, 0)
        sent = true
        task.delay(0.02, function()
            pcall(function() VIM:SendMouseButtonEvent(x, y, 1, false, game, 0) end)
        end)
    end)
    if not sent and firesignal then
        local function fake(s)
            return {
                KeyCode = Enum.KeyCode.Unknown,
                UserInputType = Enum.UserInputType.MouseButton2,
                UserInputState = s,
                Position = Vector3.new(), Delta = Vector3.new(),
                IsA = newcclosure and newcclosure(function(_,c) return c=="InputObject" end)
                    or function(_,c) return c=="InputObject" end,
            }
        end
        pcall(function() firesignal(UIS.InputBegan, fake(Enum.UserInputState.Begin), false) end)
        task.delay(0.02, function()
            pcall(function() firesignal(UIS.InputEnded, fake(Enum.UserInputState.End), false) end)
        end)
    end
end

local function inRange(char)
    if not char then return false end
    local r = char:FindFirstChild("HumanoidRootPart")
    local _, me = getCharParts()
    if not (r and me) then return false end
    return (r.Position - me.Position).Magnitude <= State.AutoParryRange
end

-- USER MANUAL OVERRIDES: animId -> impactSec.
local manual = {}
function Combat.setManual(animId, ms)
    if not animId or animId == "" then return end
    if not ms or ms == 0 then manual[animId] = nil; return end
    manual[animId] = ms / 1000
end
function Combat.getManual(animId) return manual[animId] end

-- AutoParry fires ONLY for animation ids that have a saved parry timing.
-- No heuristics, no learned fallback — the saved value is the source of truth.
local function lookup(animId)
    local pt = _G.__ParryTimings
    return pt and pt.lookup and pt.lookup(animId) or nil
end

local function plan(track, char, animId)
    if pending[track] then return end
    local apd = _G.__AutoParryData
    if apd and apd.notePlay then apd.notePlay(animId) end
    local impact = lookup(animId)
    if not impact then return end          -- no saved timing for this anim -> ignore
    impact = impact + (State.AutoParryOffset or 0) / 1000
    if impact < 0 then impact = 0 end
    pending[track] = {
        animId = animId, char = char,
        target = impact,                    -- seconds INTO the animation
        length = track.Length or 0, fired = false,
    }
    local stopConn
    stopConn = track.Stopped:Connect(function()
        pending[track] = nil
        if stopConn then stopConn:Disconnect() end
    end)
    Conns.add(stopConn)
end

-- Fire tick — compares the animation's OWN TimePosition to the saved target,
-- so the parry lands at exactly the frame you set, regardless of how fast the
-- enemy plays the animation (AdjustSpeed-proof).
Conns.add(RunService.Heartbeat:Connect(function()
    if not State or not State.AutoParry then return end
    local now = os.clock()
    if now < hitstunUntil then return end
    for track, s in pairs(pending) do
        if not track or not track.IsPlaying then
            pending[track] = nil
        elseif not s.fired then
            -- Ping compensation (deepwoken model): press RTT earlier so the
            -- input reaches the server at the saved frame.
            local comp = (State.PingComp ~= false) and Latency.rtt() or 0
            local fireAt = s.target - comp
            if track.TimePosition >= fireAt then
                if now - lastFire >= GLOBAL_DEBOUNCE and inRange(s.char) then
                    pressM2()
                    s.fired = true
                    lastFire = now
                    _G.__lastParry = string.format("%s set=%dms ping=-%dms @%dms",
                        s.animId, math.floor(s.target * 1000),
                        math.floor(comp * 1000), math.floor(track.TimePosition * 1000))
                end
            end
        end
    end
end))

-- Hook every Humanoid
local hookedHums = setmetatable({}, { __mode = "k" })
local function hookHum(hum)
    if hookedHums[hum] then return end
    hookedHums[hum] = true
    Conns.add(hum.AnimationPlayed:Connect(function(track)
        if not State or not State.AutoParry then return end
        local char = hum.Parent
        if not char or char == LP.Character then return end
        local anim = track.Animation
        local id = (anim and anim.AnimationId or ""):gsub("rbxassetid://", "")
        if id == "" then return end
        plan(track, char, id)
    end))
end
Humanoids.onAdded(hookHum)   -- existing + future humanoids, one shared scan

-- Local damage -> hit-stun + miss feedback
local function bindLocal(char)
    local hum = char:FindFirstChildWhichIsA("Humanoid") or char:WaitForChild("Humanoid", 5)
    if not hum then return end
    local lastHP = hum.Health
    Conns.add(hum.HealthChanged:Connect(function(h)
        if h < lastHP then hitstunUntil = os.clock() + HITSTUN end
        lastHP = h
    end))
end
if LP.Character then bindLocal(LP.Character) end
Conns.add(LP.CharacterAdded:Connect(bindLocal))

function Combat.setAutoParry(v)
    State.AutoParry = v
    Notification.send("AutoParry", v and "ON" or "OFF", 1.5,
        v and Color3.fromRGB(60,200,120) or Color3.fromRGB(160,160,160))
end

function Combat.init(state) State = state end
return Combat

end)
__bundle_register("Utility/Latency", function(require, _LOADED, __bundle_register, __bundle_modules)
-- Latency — mirrors deepwoken-rewrite's Latency module.
-- Uses Stats.Network "Data Ping" (round-trip, ms) so AutoParry can press
-- early enough that the input reaches the server at the saved frame.
local Stats = game:GetService("Stats")

local Latency = {}

function Latency.rtt()  -- round-trip time, seconds
    local ok, v = pcall(function()
        return Stats.Network.ServerStatsItem["Data Ping"]:GetValue() / 1000
    end)
    if ok and v and v > 0 then return v end
    -- fallback: GetNetworkPing is one-way seconds -> RTT = *2
    local p = 0
    pcall(function() p = game:GetService("Players").LocalPlayer:GetNetworkPing() end)
    return math.max(p * 2, 0)
end

function Latency.rdelay() return math.max(Latency.rtt() / 2, 0) end  -- receive delay
function Latency.sdelay() return math.max(Latency.rtt() / 2, 0) end  -- send delay

return Latency

end)
__bundle_register("Utility/Char", function(require, _LOADED, __bundle_register, __bundle_modules)
-- Tiny helper: returns (character, hrp, humanoid).
local Players = game:GetService("Players")
return function()
    local c = Players.LocalPlayer.Character
    if not c then return nil end
    return c, c:FindFirstChild("HumanoidRootPart"), c:FindFirstChildWhichIsA("Humanoid")
end

end)
__bundle_register("Features/Visuals", function(require, _LOADED, __bundle_register, __bundle_modules)
-- Visuals: ESP, Fullbright, Low GFX. Owns parents for AnimationVisualizer panels.
local RunService = game:GetService("RunService")
local Players    = game:GetService("Players")
local Lighting   = game:GetService("Lighting")
local LP         = Players.LocalPlayer
local getCharParts = require("Utility/Char")
local Conns        = require("Utility/Conns")
local Humanoids    = require("Utility/Humanoids")

local Visuals = {}
local State

--==============================================================
-- ESP — players + every other Humanoid (mobs). Health bar + dist + name.
-- One BillboardGui per character, reused.
--==============================================================
-- Colors: Player = red, NPC (interactable) = green, Mob (hostile) = orange.
local COL_PLAYER = Color3.fromRGB(235, 70, 70)
local COL_NPC    = Color3.fromRGB(90, 215, 120)
local COL_MOB    = Color3.fromRGB(255, 150, 50)

local espTags = {}      -- root -> BillboardGui
local espHL   = {}      -- character Model -> Highlight

local function makeTag(root)
    local bb = Instance.new("BillboardGui")
    bb.Name = "ESP_Tag"
    bb.Size = UDim2.new(0, 180, 0, 78)
    bb.StudsOffset = Vector3.new(0, 2, 0)
    bb.StudsOffsetWorldSpace = Vector3.new(0, 0, 0)
    bb.AlwaysOnTop = true
    bb.LightInfluence = 0
    bb.Parent = root
    local t = Instance.new("TextLabel", bb)
    t.Name = "lbl"; t.Text = ""; t.Size = UDim2.new(1,0,0,18); t.BackgroundTransparency = 1
    t.TextSize = 14; t.Font = Enum.Font.GothamBold; t.TextStrokeTransparency = 0.35
    local k = Instance.new("TextLabel", bb)   -- kind: PLAYER / NPC / MOB
    k.Name = "kind"; k.Text = ""; k.Size = UDim2.new(1,0,0,12); k.Position = UDim2.new(0,0,0,18)
    k.BackgroundTransparency = 1; k.TextSize = 10; k.Font = Enum.Font.GothamBold
    k.TextStrokeTransparency = 0.4
    local d = Instance.new("TextLabel", bb)
    d.Name = "dist"; d.Text = ""; d.Size = UDim2.new(1,0,0,12); d.Position = UDim2.new(0,0,0,30)
    d.BackgroundTransparency = 1; d.TextColor3 = Color3.fromRGB(205,205,205)
    d.TextSize = 11; d.Font = Enum.Font.Gotham; d.TextStrokeTransparency = 0.4
    local wpn = Instance.new("TextLabel", bb)
    wpn.Name = "wpn"; wpn.Text = ""; wpn.Size = UDim2.new(1,0,0,12); wpn.Position = UDim2.new(0,0,0,42)
    wpn.BackgroundTransparency = 1; wpn.TextColor3 = Color3.fromRGB(255,225,140)
    wpn.TextSize = 11; wpn.Font = Enum.Font.GothamBold; wpn.TextStrokeTransparency = 0.4
    -- Vertical health bar on the left edge (fills bottom -> top).
    local hpBg = Instance.new("Frame", bb)
    hpBg.Name = "hpBg"; hpBg.Size = UDim2.new(0, 6, 0, 56)
    hpBg.Position = UDim2.new(0, 2, 0, 6)
    hpBg.BackgroundColor3 = Color3.fromRGB(30,30,30); hpBg.BorderSizePixel = 0
    Instance.new("UICorner", hpBg).CornerRadius = UDim.new(0,3)
    local hp = Instance.new("Frame", hpBg)
    hp.Name = "hp"; hp.AnchorPoint = Vector2.new(0,1)
    hp.Position = UDim2.new(0,0,1,0); hp.Size = UDim2.new(1,0,1,0)
    hp.BackgroundColor3 = Color3.fromRGB(70,210,90); hp.BorderSizePixel = 0
    Instance.new("UICorner", hp).CornerRadius = UDim.new(0,3)
    local hptxt = Instance.new("TextLabel", bb)
    hptxt.Name = "hptxt"; hptxt.Text = ""; hptxt.Size = UDim2.new(1,0,0,12); hptxt.Position = UDim2.new(0,0,0,64)
    hptxt.BackgroundTransparency = 1; hptxt.TextColor3 = Color3.fromRGB(220,220,220)
    hptxt.TextSize = 10; hptxt.Font = Enum.Font.Code; hptxt.TextStrokeTransparency = 0.4
    return bb
end
local function tagFor(root)
    local bb = espTags[root]
    if not bb or not bb.Parent then bb = makeTag(root); espTags[root] = bb end
    return bb
end

-- Outline via Highlight (per character model), colored by kind.
local function outlineFor(char, color)
    if not State.ESPOutline then
        if espHL[char] then pcall(function() espHL[char]:Destroy() end); espHL[char] = nil end
        return
    end
    local hl = espHL[char]
    if not hl or not hl.Parent then
        hl = Instance.new("Highlight")
        hl.Name = "ESP_HL"
        hl.FillTransparency = 0.75
        hl.OutlineTransparency = 0
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Adornee = char
        hl.Parent = char
        espHL[char] = hl
    end
    hl.FillColor = color
    hl.OutlineColor = color
end

-- Best-effort held-weapon name for a character (Tool, hand weapon, attribute).
local function getWeapon(char)
    -- 1) Equipped Tool (most games)
    local tool = char:FindFirstChildWhichIsA("Tool")
    if tool then return tool.Name end
    -- 2) Deepwoken/VV style: RightHand.HandWeapon
    local rh = char:FindFirstChild("RightHand")
    if rh then
        local hw = rh:FindFirstChild("HandWeapon") or rh:FindFirstChildWhichIsA("Model")
        if hw then return hw.Name end
    end
    -- 3) Attribute / value
    local a = char:GetAttribute("Weapon")
    if a and tostring(a) ~= "" then return tostring(a) end
    local sv = char:FindFirstChild("Weapon")
    if sv and sv:IsA("StringValue") and sv.Value ~= "" then return sv.Value end
    return nil
end

local function updateTag(root, char, name, kind, color, hum, dist)
    local bb = tagFor(root)
    bb.lbl.Text = State.ESPName and name or ""
    bb.lbl.TextColor3 = color
    bb.kind.Text = kind
    bb.kind.TextColor3 = color
    bb.dist.Text = State.ESPDistance and string.format("%dm", dist) or ""
    -- Weapon: players + mobs only (not NPCs)
    local showWpn = State.ESPWeapon and kind ~= "NPC"
    if showWpn then
        local w = getWeapon(char)
        bb.wpn.Text = w and ("[" .. w .. "]") or ""
        bb.wpn.Visible = w ~= nil
    else
        bb.wpn.Visible = false
    end
    local showHp = State.ESPHealth and hum ~= nil
    bb.hpBg.Visible = showHp
    bb.hptxt.Visible = showHp
    if showHp then
        local cur = math.floor(hum.Health + 0.5)
        local max = math.max(math.floor(hum.MaxHealth + 0.5), 1)
        local p = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
        bb.hpBg.hp.Size = UDim2.new(1, 0, p, 0)
        -- green -> red as health drops
        bb.hpBg.hp.BackgroundColor3 = Color3.fromRGB(
            math.floor(235*(1-p)+60), math.floor(70 + 150*p), 70)
        bb.hptxt.Text = string.format("%d%%", math.floor(p*100 + 0.5))
    end
    outlineFor(char, color)
end

function Visuals.clearESP()
    for r, bb in pairs(espTags) do if bb then pcall(function() bb:Destroy() end) end end
    for c, hl in pairs(espHL) do if hl then pcall(function() hl:Destroy() end) end end
    espTags = {}; espHL = {}
end

-- Classify a non-player character: NPC (has ProximityPrompt / "NPC" tag) vs Mob.
local function classify(char)
    for _, ch in ipairs(char:GetDescendants()) do
        if ch:IsA("ProximityPrompt") then return "NPC", COL_NPC end
    end
    if char:GetAttribute("NPC") or char:FindFirstChild("IsNPC") then return "NPC", COL_NPC end
    return "MOB", COL_MOB
end

do
    local last = 0
    Conns.add(RunService.Heartbeat:Connect(function()
        if not State or not State.ESP then return end
        if tick() - last < 0.2 then return end           -- 5 Hz; health stays current
        last = tick()
        local _, me = getCharParts(); if not me then return end
        local myPos = me.Position

        -- Cull tags out of range / gone
        for root, bb in pairs(espTags) do
            if not root or not root.Parent
                or (root.Position - myPos).Magnitude > State.ESPRange then
                if bb then pcall(function() bb:Destroy() end) end
                espTags[root] = nil
            end
        end
        -- Cull highlights for gone / out-of-range characters
        for char, hl in pairs(espHL) do
            local r = char and (char:FindFirstChild("HumanoidRootPart")
                or char:FindFirstChildWhichIsA("BasePart"))
            if not char or not char.Parent or not r
                or (r.Position - myPos).Magnitude > State.ESPRange then
                if hl then pcall(function() hl:Destroy() end) end
                espHL[char] = nil
            end
        end

        local playerCharSet = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Character then playerCharSet[p.Character] = p end
        end

        local seen = {}
        for d in Humanoids.iter() do
            if d.Health > 0 then
                local c = d.Parent
                if c and c ~= LP.Character and not seen[c] then
                    seen[c] = true
                    local r = c:FindFirstChild("HumanoidRootPart")
                        or c:FindFirstChildWhichIsA("BasePart")
                    if r then
                        local dist = (r.Position - myPos).Magnitude
                        if dist <= State.ESPRange then
                            local ok, err = pcall(function()
                                local plr = playerCharSet[c]
                                if plr then
                                    updateTag(r, c, plr.DisplayName or plr.Name, "PLAYER", COL_PLAYER, d, dist)
                                else
                                    local kind, col = classify(c)
                                    updateTag(r, c, c.Name, kind, col, d, dist)
                                end
                            end)
                            if not ok then _G.__espErr = tostring(err) end
                        end
                    end
                end
            end
        end
    end))
end
function Visuals.setESP(v) State.ESP = v; if not v then Visuals.clearESP() end end
function Visuals.setESPOutline(v)
    State.ESPOutline = v
    if not v then for c, hl in pairs(espHL) do if hl then pcall(function() hl:Destroy() end) end end; espHL = {} end
end

-- AnimationVisualizer panel parent helpers (kept for compatibility)
local animParent
function Visuals.setAnimParent(p)     animParent = p end
function Visuals.setCrosshairParent() end
function Visuals.setFPSParent()       end
function Visuals.setAnimVis()         end -- inline disabled; use the DW visualizer

--==============================================================
-- FULLBRIGHT
--==============================================================
local origLighting
function Visuals.setFullbright(on)
    State.Fullbright = on
    if on then
        origLighting = origLighting or {
            B  = Lighting.Brightness, A  = Lighting.Ambient, OA = Lighting.OutdoorAmbient,
            CB = Lighting.ColorShift_Bottom, CT = Lighting.ColorShift_Top,
            GS = Lighting.GlobalShadows,
        }
        Lighting.Brightness        = 2
        Lighting.Ambient           = Color3.fromRGB(178,178,178)
        Lighting.OutdoorAmbient    = Color3.fromRGB(178,178,178)
        Lighting.ColorShift_Bottom = Color3.fromRGB(178,178,178)
        Lighting.ColorShift_Top    = Color3.fromRGB(178,178,178)
        Lighting.GlobalShadows     = false
    elseif origLighting then
        Lighting.Brightness        = origLighting.B
        Lighting.Ambient           = origLighting.A
        Lighting.OutdoorAmbient    = origLighting.OA
        Lighting.ColorShift_Bottom = origLighting.CB
        Lighting.ColorShift_Top    = origLighting.CT
        Lighting.GlobalShadows     = origLighting.GS
    end
end

--==============================================================
-- LOW GFX — quality 1, no shadows, no particles, plain materials, etc.
--==============================================================
local lowGfxConn
local lowGfxOrig = {}
local PARTICLE_CLASSES = {
    ParticleEmitter=true, Beam=true, Trail=true, Smoke=true, Fire=true,
    Sparkles=true, Explosion=true,
}
local LIGHT_CLASSES = { PointLight=true, SpotLight=true, SurfaceLight=true }
local POSTFX_CLASSES = {
    BloomEffect=true, BlurEffect=true, ColorCorrectionEffect=true,
    SunRaysEffect=true, DepthOfFieldEffect=true, Atmosphere=true,
}

local function lowApplyOne(inst)
    if PARTICLE_CLASSES[inst.ClassName] then
        if lowGfxOrig[inst] == nil then lowGfxOrig[inst] = { Enabled = inst.Enabled } end
        pcall(function() inst.Enabled = false end)
    elseif LIGHT_CLASSES[inst.ClassName] then
        if lowGfxOrig[inst] == nil then lowGfxOrig[inst] = { Enabled = inst.Enabled } end
        pcall(function() inst.Enabled = false end)
    elseif POSTFX_CLASSES[inst.ClassName] then
        if lowGfxOrig[inst] == nil then lowGfxOrig[inst] = { Enabled = inst.Enabled } end
        pcall(function() inst.Enabled = false end)
    elseif inst:IsA("Decal") or inst:IsA("Texture") then
        if lowGfxOrig[inst] == nil then lowGfxOrig[inst] = { Transparency = inst.Transparency } end
        pcall(function() inst.Transparency = 1 end)
    elseif inst:IsA("SurfaceAppearance") then
        if lowGfxOrig[inst] == nil then lowGfxOrig[inst] = { Parent = inst.Parent } end
        pcall(function() inst.Parent = nil end)
    elseif inst:IsA("MeshPart") then
        if lowGfxOrig[inst] == nil then
            lowGfxOrig[inst] = {
                RenderFidelity = inst.RenderFidelity, TextureID = inst.TextureID,
                Material = inst.Material, Reflectance = inst.Reflectance,
                CastShadow = inst.CastShadow,
            }
        end
        pcall(function()
            inst.RenderFidelity = Enum.RenderFidelity.Performance
            inst.TextureID = ""; inst.Material = Enum.Material.SmoothPlastic
            inst.Reflectance = 0; inst.CastShadow = false
        end)
    elseif inst:IsA("BasePart") then
        if lowGfxOrig[inst] == nil then
            lowGfxOrig[inst] = { Material = inst.Material, Reflectance = inst.Reflectance,
                                  CastShadow = inst.CastShadow }
        end
        pcall(function()
            inst.Material = Enum.Material.SmoothPlastic
            inst.Reflectance = 0; inst.CastShadow = false
        end)
    end
end

function Visuals.setLowGfx(on)
    State.LowGfx = on
    if on then
        pcall(function()
            local US = UserSettings():GetService("UserGameSettings")
            lowGfxOrig.__quality = US.SavedQualityLevel
            US.SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
        end)
        pcall(function()
            Lighting.GlobalShadows = false
            Lighting.FogStart = 1e6; Lighting.FogEnd = 1e6
        end)
        for _, d in ipairs(workspace:GetDescendants()) do lowApplyOne(d) end
        for _, d in ipairs(Lighting:GetDescendants()) do lowApplyOne(d) end
        if not lowGfxConn then
            lowGfxConn = Conns.add(workspace.DescendantAdded:Connect(lowApplyOne))
            Conns.add(Lighting.DescendantAdded:Connect(lowApplyOne))
        end
    else
        if lowGfxConn then lowGfxConn:Disconnect(); lowGfxConn = nil end
        if lowGfxOrig.__quality then
            pcall(function()
                UserSettings():GetService("UserGameSettings").SavedQualityLevel
                    = lowGfxOrig.__quality
            end)
            lowGfxOrig.__quality = nil
        end
        for inst, snap in pairs(lowGfxOrig) do
            if typeof(inst) == "Instance" then
                for k, v in pairs(snap) do pcall(function() inst[k] = v end) end
            end
        end
        lowGfxOrig = {}
    end
end

function Visuals.init(state)
    State = state
    Conns.onTeardown(function()
        Visuals.setFullbright(false); Visuals.setLowGfx(false); Visuals.clearESP()
    end)
end
return Visuals

end)
__bundle_register("Features/Movement", function(require, _LOADED, __bundle_register, __bundle_modules)
-- Movement: Toggle Sprint, Fly, Noclip. Nothing else.
local RunService = game:GetService("RunService")
local UIS        = game:GetService("UserInputService")
local VIM        = game:GetService("VirtualInputManager")
local Players    = game:GetService("Players")
local LP         = Players.LocalPlayer
local getCharParts = require("Utility/Char")
local Conns        = require("Utility/Conns")

local Movement = {}
local State

--==============================================================
-- TOGGLE SPRINT (holds Shift via VIM)
--==============================================================
function Movement.setSprint(on)
    State.ToggleSprint = on
    pcall(function() VIM:SendKeyEvent(on, Enum.KeyCode.LeftShift, false, game) end)
    if _G.__Notify then _G.__Notify("Sprint", on and "ON" or "OFF", 1.2,
        on and Color3.fromRGB(60,200,120) or Color3.fromRGB(160,160,160)) end
end

--==============================================================
-- FLY
--==============================================================
local flyBV, flyBG, flyConn
function Movement.stopFly()
    State.Fly = false
    if flyConn then flyConn:Disconnect(); flyConn = nil end
    if flyBV then flyBV:Destroy(); flyBV = nil end
    if flyBG then flyBG:Destroy(); flyBG = nil end
    local _,_,h = getCharParts(); if h then h.PlatformStand = false end
end
function Movement.startFly()
    local _,hrp,h = getCharParts(); if not hrp or not h then return end
    State.Fly = true; h.PlatformStand = true
    flyBV = Instance.new("BodyVelocity")
    flyBV.MaxForce = Vector3.new(1e5,1e5,1e5); flyBV.Velocity = Vector3.new(); flyBV.Parent = hrp
    flyBG = Instance.new("BodyGyro")
    flyBG.MaxTorque = Vector3.new(1e5,1e5,1e5); flyBG.P = 1e4; flyBG.Parent = hrp
    flyConn = Conns.add(RunService.Heartbeat:Connect(function()
        local _,r,hh = getCharParts()
        if not r or not hh or r ~= hrp then Movement.stopFly() return end
        local cam = workspace.CurrentCamera
        local v = Vector3.new()
        if UIS:IsKeyDown(Enum.KeyCode.W) then v = v + cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then v = v - cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then v = v - cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then v = v + cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space)       then v = v + Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then v = v - Vector3.new(0,1,0) end
        flyBV.Velocity = v * State.FlySpeed
        if v.Magnitude > 0 then flyBG.CFrame = cam.CFrame end
    end))
end
function Movement.setFly(v) if v then Movement.startFly() else Movement.stopFly() end end

--==============================================================
-- NOCLIP
--==============================================================
local noclipConn
local origCollide = {}
function Movement.setNoclip(on)
    State.Noclip = on
    if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
    if on then
        noclipConn = Conns.add(RunService.Stepped:Connect(function()
            local c = LP.Character; if not c then return end
            for _,p in ipairs(c:GetDescendants()) do
                if p:IsA("BasePart") then
                    if origCollide[p] == nil then origCollide[p] = p.CanCollide end
                    if p.CanCollide then p.CanCollide = false end
                end
            end
        end))
    else
        for p, orig in pairs(origCollide) do
            if p and p.Parent then pcall(function() p.CanCollide = orig end) end
        end
        origCollide = {}
    end
end

-- Respawn safety
Conns.add(LP.CharacterAdded:Connect(function()
    if State and State.Fly then Movement.stopFly() end
    if State and State.ToggleSprint then Movement.setSprint(false) end
end))

function Movement.init(state)
    State = state
    Conns.onTeardown(function()
        Movement.stopFly(); Movement.setNoclip(false)
        pcall(function() VIM:SendKeyEvent(false, Enum.KeyCode.LeftShift, false, game) end)
    end)
end
return Movement

end)
__bundle_register("Features/ParryTimings", function(require, _LOADED, __bundle_register, __bundle_modules)
-- ParryTimings: per-animation impact-time table with metadata.
--
-- Storage format (parrytimings.json):
--   { [animId] = { sec = number, cat = string?, note = string?, src = "manual"|"learned"|"kf" } }
-- Old flat format ({ [animId] = number }) is auto-migrated on load.
local Http = game:GetService("HttpService")

local ParryTimings = {}
local timings = {}
local FILE = "parrytimings.json"

local function migrate()
    for id, v in pairs(timings) do
        if type(v) == "number" then
            timings[id] = { sec = v, cat = "Uncategorized", src = "learned" }
        elseif type(v) == "table" then
            v.cat = v.cat or "Uncategorized"
            v.src = v.src or "manual"
        end
    end
end

local function load()
    if isfile and isfile(FILE) then
        local ok, t = pcall(function() return Http:JSONDecode(readfile(FILE)) end)
        if ok and type(t) == "table" then timings = t end
    end
    migrate()
end

local function save()
    pcall(function() writefile(FILE, Http:JSONEncode(timings)) end)
end

-- Distill AutoParryData entries into the table, preserving existing manual ones.
function ParryTimings.generate()
    local apd = _G.__AutoParryData
    if not apd or not apd.all then return 0 end
    local n = 0
    for id, e in pairs(apd.all()) do
        local cur = timings[id]
        if not cur or cur.src ~= "manual" then
            local sec
            local src
            if type(e.kfImpact) == "number" then
                sec = e.kfImpact; src = "kf"
            elseif type(e.calEma) == "number" and (e.calSamples or 0) >= 1 then
                sec = e.calEma; src = "calibration"
            elseif type(e.ema) == "number" then
                sec = e.ema; src = "learned"
            elseif type(e.avg) == "number" and e.avg > 0 then
                sec = e.avg; src = "learned"
            end
            if sec and sec >= 0.05 and sec <= 4.0 then
                timings[id] = { sec = sec, cat = (cur and cur.cat) or "Uncategorized", src = src }
                n = n + 1
            end
        end
    end
    save()
    return n
end

-- Returns the seconds-to-impact for AutoParry. Accepts both formats.
function ParryTimings.lookup(animId)
    local v = timings[animId]
    if not v then return nil end
    if type(v) == "number" then return v end
    return v.sec
end

function ParryTimings.all() return timings end
function ParryTimings.count()
    local c = 0; for _ in pairs(timings) do c = c + 1 end; return c
end

-- Mutators
function ParryTimings.set(animId, seconds, cat, note)
    if not animId or animId == "" or type(seconds) ~= "number" then return end
    local id = tostring(animId)
    local cur = timings[id]
    timings[id] = {
        sec  = seconds,
        cat  = cat  or (cur and cur.cat) or "Uncategorized",
        note = note or (cur and cur.note),
        src  = "manual",
    }
    save()
end
function ParryTimings.setCategory(animId, cat)
    local v = timings[animId]
    if type(v) ~= "table" then return end
    v.cat = cat or "Uncategorized"
    save()
end
function ParryTimings.setNote(animId, note)
    local v = timings[animId]
    if type(v) ~= "table" then return end
    v.note = note
    save()
end
function ParryTimings.remove(animId)
    timings[tostring(animId)] = nil; save()
end
function ParryTimings.clear() timings = {}; save() end

-- Remove every timing belonging to one category. Returns count removed.
function ParryTimings.clearCategory(cat)
    if not cat or cat == "" then return 0 end
    local n = 0
    for id, v in pairs(timings) do
        local c = (type(v) == "table" and (v.cat or "Uncategorized")) or "Uncategorized"
        if c == cat then timings[id] = nil; n = n + 1 end
    end
    if n > 0 then save() end
    return n
end

-- Category helpers
function ParryTimings.categories()
    local seen, list = {}, {}
    for _, v in pairs(timings) do
        local c = (type(v) == "table" and v.cat) or "Uncategorized"
        if not seen[c] then seen[c] = true; table.insert(list, c) end
    end
    table.sort(list)
    return list
end

-- Export / Import (clipboard-friendly JSON)
function ParryTimings.export()
    local json = Http:JSONEncode(timings)
    local cb = setclipboard or toclipboard or (Clipboard and Clipboard.set)
    if cb then pcall(cb, json) end
    return json
end
function ParryTimings.import(json)
    local ok, t = pcall(function() return Http:JSONDecode(json) end)
    if not ok or type(t) ~= "table" then return false, "bad JSON" end
    for k, v in pairs(t) do timings[tostring(k)] = v end
    migrate(); save()
    return true, "imported"
end

function ParryTimings.init() load() end

-- Load immediately at require-time so saved timings exist before anything
-- (Main, AutoParry, the menu) reads them. Prevents accidental overwrite.
load()

return ParryTimings

end)
__bundle_register("Features/AutoParryData", function(require, _LOADED, __bundle_register, __bundle_modules)
-- AutoParryData: passively learns enemy attack timings.
-- How it works:
--   For every nearby enemy humanoid track that starts, we record { hum, startClock }.
--   When the LocalPlayer's Humanoid takes a health drop, we look at every active
--   enemy track and credit the closest one (most recent start) as the attack.
--   We store { anim_id -> { samples=int, avgImpact=secs, minImpact, maxImpact } }.
--   Persisted to "__autoparry.json".
local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpSvc    = game:GetService("HttpService")
local LP         = Players.LocalPlayer
local Conns      = require("Utility/Conns")
local getCharParts = require("Utility/Char")

local AutoParryData = {}
local State

-- Persistent learned data: id -> {samples, sum, min, max, last}
local data = {}
local FILE = "__autoparry.json"

-- Active enemy tracks: hum -> { [animId] = startClock }
local active = setmetatable({}, { __mode = "k" })

local function loadData()
    if isfile and isfile(FILE) then
        local ok, t = pcall(function() return HttpSvc:JSONDecode(readfile(FILE)) end)
        if ok and type(t) == "table" then data = t end
    end
end

local function saveData()
    pcall(function() writefile(FILE, HttpSvc:JSONEncode(data)) end)
end

-- Per-id entry:
--   samples / sum / avg / ema  : impact-time stats (only from CONFIRMED hits)
--   min / max / last           : range info
--   deaths                     : kills (3x weight)
--   plays                      : total times this anim started
--   cancels                    : stopped before reaching predicted impact (feints)
--   misses                     : parry fired but damage still landed
--   conf                       : samples + 3*deaths
--   cancelRate                 : cancels/plays (feint frequency)
local EMA_ALPHA = 0.30
-- Streaming OLS regression: impact ≈ a + b * distance, per anim id.
-- Lets us tell apart instant melee (slope≈0) from long-range/dash attacks
-- whose impact time grows with the start distance.
local function record(animId, impactSec, killed, distance)
    if not animId or animId == "" or animId == "?" then return end
    distance = distance or 0
    local e = data[animId]
    if not e then
        e = { samples=0, sum=0, ema=impactSec, last=impactSec,
              min=impactSec, max=impactSec, deaths=0, avg=impactSec,
              plays=0, cancels=0, misses=0,
              -- regression accumulators
              sumD=0, sumI=0, sumDI=0, sumDD=0,
              distAvg=0, distMin=distance, distMax=distance,
              slope=0, intercept=impactSec,
        }
        data[animId] = e
    end
    e.samples = e.samples + 1
    e.sum = e.sum + impactSec
    e.last = impactSec
    e.avg = e.sum / e.samples
    e.ema = EMA_ALPHA * impactSec + (1 - EMA_ALPHA) * (e.ema or impactSec)
    if impactSec < e.min then e.min = impactSec end
    if impactSec > e.max then e.max = impactSec end
    if killed then e.deaths = (e.deaths or 0) + 1 end
    e.conf = e.samples + 3 * (e.deaths or 0)

    -- Distance tracking
    e.sumD  = (e.sumD  or 0) + distance
    e.sumI  = (e.sumI  or 0) + impactSec
    e.sumDI = (e.sumDI or 0) + distance * impactSec
    e.sumDD = (e.sumDD or 0) + distance * distance
    e.distAvg = e.sumD / e.samples
    if distance < (e.distMin or distance) then e.distMin = distance end
    if distance > (e.distMax or distance) then e.distMax = distance end

    -- Fit linear model when we have enough variation.
    if e.samples >= 3 then
        local n   = e.samples
        local denom = n * e.sumDD - e.sumD * e.sumD
        if math.abs(denom) > 1e-3 then
            e.slope = (n * e.sumDI - e.sumD * e.sumI) / denom
            e.intercept = (e.sumI - e.slope * e.sumD) / n
        else
            e.slope = 0; e.intercept = e.avg
        end
    end

    if e.samples % 3 == 0 or killed then saveData() end
end

local function ensure(animId)
    local e = data[animId]
    if not e then
        e = { samples=0, sum=0, avg=0, ema=nil, min=0, max=0,
              last=0, deaths=0, plays=0, cancels=0, misses=0, conf=0 }
        data[animId] = e
    end
    return e
end

-- Called by Combat when an enemy track starts playing.
function AutoParryData.notePlay(animId)
    if not animId or animId == "" then return end
    local e = ensure(animId); e.plays = (e.plays or 0) + 1
end
-- Called when a track stops before reaching the predicted impact (feint).
function AutoParryData.noteCancel(animId)
    if not animId or animId == "" then return end
    local e = ensure(animId); e.cancels = (e.cancels or 0) + 1
    e.cancelRate = e.cancels / math.max(1, e.plays or 1)
end
-- Called when we fired a parry but still took damage shortly after.
-- Only nudge EMA on profiles that already have real samples, otherwise
-- a fresh anim id can have its timing corrupted before it's learned.
-- Combo gap: tracks the typical seconds between consecutive attack animations
-- from the same enemy. Used to predict when the next swing arrives.
-- Combat calls this with the dt between two consecutive attack starts.
function AutoParryData.noteCombo(prevId, nextId, gapSec)
    if not prevId or not nextId or gapSec <= 0 or gapSec > 1.5 then return end
    local e = ensure(prevId)
    e.combo = e.combo or {}
    local c = e.combo[nextId] or { samples = 0, sum = 0, avg = 0 }
    c.samples = c.samples + 1
    c.sum = c.sum + gapSec
    c.avg = c.sum / c.samples
    e.combo[nextId] = c
end

-- Get the expected gap (seconds) from prevId -> nextId. Returns nil if unknown.
function AutoParryData.comboGap(prevId, nextId)
    local e = data[prevId]
    if not e or not e.combo or not e.combo[nextId] then return nil end
    return e.combo[nextId].avg
end

function AutoParryData.noteMiss(animId)
    if not animId or animId == "" then return end
    local e = ensure(animId); e.misses = (e.misses or 0) + 1
    if (e.samples or 0) >= 3 and e.ema then
        e.ema = e.ema + 0.025
    end
    saveData()
end

-- LIVE LEARNER: blends EMA toward observedImpact more aggressively than
-- the passive record() does. Called from Combat when we see the actual
-- impact moment after a parry attempt.
function AutoParryData.learn(animId, observedImpact, killed)
    if not animId or animId == "" or type(observedImpact) ~= "number" then return end
    if observedImpact <= 0.05 or observedImpact > 4.0 then return end
    local e = ensure(animId)
    e.samples = (e.samples or 0) + 1
    e.sum     = (e.sum or 0) + observedImpact
    e.last    = observedImpact
    e.avg     = e.sum / e.samples
    e.min     = math.min(e.min ~= 0 and e.min or observedImpact, observedImpact)
    e.max     = math.max(e.max or 0, observedImpact)
    local alpha = 0.40  -- aggressive: 40% pull toward observation
    e.ema = alpha * observedImpact + (1 - alpha) * (e.ema or e.avg or observedImpact)
    if killed then e.deaths = (e.deaths or 0) + 1 end
    e.conf = (e.samples or 0) + 3 * (e.deaths or 0)
    e.lastLearned = os.clock()
    saveData()
end

-- Parry succeeded (no damage taken in window). Increments confidence stats.
function AutoParryData.noteSuccess(animId)
    if not animId or animId == "" then return end
    local e = ensure(animId); e.successes = (e.successes or 0) + 1
end

-- USER-CALIBRATED TIMING: called when the human player manually presses M2
-- while an enemy attack anim is in progress. The elapsed time from anim
-- start to the press is the GROUND TRUTH parry timing for that anim — far
-- more reliable than guessing from when damage landed.
-- KEYFRAME-DERIVED TIMING (exact, from animation file).
function AutoParryData.fromKeyframes(animId, impactSec)
    if not animId or animId == "" then return end
    if type(impactSec) ~= "number" or impactSec <= 0.02 or impactSec > 4.0 then return end
    local e = ensure(animId)
    e.kfImpact = impactSec
    e.kfTimestamp = os.clock()
    saveData()
end

-- Mark an animation as confirmed-non-attack based on keyframe inspection
-- (no hit-markers, very few keyframes -> idle/movement).
function AutoParryData.markNonAttack(animId)
    if not animId or animId == "" then return end
    local e = ensure(animId)
    e.kfNonAttack = true
    e.plays = math.max(e.plays or 0, 50) -- so isKnownNonAttack returns true
    saveData()
end

function AutoParryData.calibrate(animId, observedSec)
    if not animId or animId == "" then return end
    if type(observedSec) ~= "number" or observedSec <= 0.05 or observedSec > 4.0 then return end
    local e = ensure(animId)
    e.calSamples = (e.calSamples or 0) + 1
    e.calSum     = (e.calSum or 0) + observedSec
    e.calAvg     = e.calSum / e.calSamples
    -- A single calibration sample is worth ~3 passive samples in trust.
    e.calEma = e.calEma and (0.50 * observedSec + 0.50 * e.calEma) or observedSec
    saveData()
end

-- Sanitize corrupted entries from older runs (inf min, broken types).
local function sanitize()
    for id, e in pairs(data) do
        if type(e.min) ~= "number" then e.min = 0 end
        if type(e.max) ~= "number" then e.max = 0 end
        if type(e.ema) ~= "number" then e.ema = nil end
        if type(e.avg) ~= "number" then e.avg = 0 end
    end
end

-- Per-id profile lookup. Threat criteria:
--   * samples >= 2 OR deaths >= 1   (we have evidence)
--   * impact >= 0.15s               (not at animation start)
-- We DON'T gate on samples/plays anymore: many real attacks hit only
-- occasionally, and the ratio filter was rejecting everything.
-- Predict impact time. If currentDist is provided and we have enough samples
-- to fit a regression line, scale impact by distance (long-range moves slow
-- their impact when started far away).
function AutoParryData.lookup(animId, currentDist)
    local e = data[animId]
    if not e then return nil end
    local samples = e.samples or 0
    local deaths  = e.deaths or 0
    -- Require some evidence: keyframes OR calibration OR ≥1 hit OR ≥1 death.
    if not e.kfImpact and (e.calSamples or 0) < 1 and samples < 1 and deaths < 1 then return nil end

    -- Priority order:
    --   1. KeyframeSequenceProvider data (exact, from animation file)
    --   2. User calibration EMA (ground truth from manual parries)
    --   3. Distance regression (if we have ≥3 samples + meaningful slope)
    --   4. Passive EMA from damage attribution
    local impact
    if e.kfImpact then
        impact = e.kfImpact
    elseif e.calEma and (e.calSamples or 0) >= 1 then
        impact = e.calEma
    elseif currentDist and samples >= 3 and e.slope and e.intercept
        and math.abs(e.slope) > 0.003 then
        local predicted = e.intercept + e.slope * currentDist
        local lo, hi = (e.min or 0), (e.max or predicted)
        impact = math.max(lo, math.min(hi, predicted))
    else
        impact = e.ema or e.avg
    end
    if not impact or impact < 0.15 then return nil end

    local offsetMs = (State and State.AutoParryOffset) or -40
    return impact + offsetMs / 1000
end

-- True if id is a known attack we'll trust enough to parry.
function AutoParryData.isAttack(animId)
    local e = data[animId]
    if not e then return false end
    return (e.samples or 0) >= 2 or (e.deaths or 0) >= 1
end

-- True for ids that played a lot and never dealt damage (idle, run, wind-down).
function AutoParryData.isKnownNonAttack(animId)
    local e = data[animId]
    if not e then return false end
    if e.kfNonAttack then return true end
    return (e.samples or 0) == 0 and (e.deaths or 0) == 0 and (e.plays or 0) >= 20
end

function AutoParryData.all() return data end

function AutoParryData.export()
    local cb = setclipboard or toclipboard or (Clipboard and Clipboard.set)
    if cb then pcall(cb, HttpSvc:JSONEncode(data)) end
    saveData()
end

function AutoParryData.reset()
    data = {}; saveData()
end

local function withinRange(char)
    if not char then return false end
    local r = char:FindFirstChild("HumanoidRootPart")
    local _, me = getCharParts()
    if not (r and me) then return false end
    return (r.Position - me.Position).Magnitude <= 30
end

local hookedHums = setmetatable({}, { __mode = "k" })
local function hookEnemy(hum)
    if not hum or hookedHums[hum] then return end
    hookedHums[hum] = true
    active[hum] = {}
    Conns.add(hum.AnimationPlayed:Connect(function(track)
        if not withinRange(hum.Parent) then return end
        local id = (track.Animation and track.Animation.AnimationId or ""):gsub("rbxassetid://", "")
        if id == "" then return end
        -- Distance at start (used by the regression).
        local dist = 0
        local r  = hum.Parent and hum.Parent:FindFirstChild("HumanoidRootPart")
        local _, me = getCharParts()
        if r and me then dist = (r.Position - me.Position).Magnitude end
        active[hum][id] = { start = os.clock(), dist = dist }
        local stopConn
        stopConn = track.Stopped:Connect(function()
            if active[hum] then active[hum][id] = nil end
            if stopConn then stopConn:Disconnect() end
        end)
        Conns.add(stopConn)
    end))
end

for _, d in ipairs(workspace:GetDescendants()) do
    if d:IsA("Humanoid") and d.Parent ~= LP.Character then hookEnemy(d) end
end
Conns.add(workspace.DescendantAdded:Connect(function(o)
    if o:IsA("Humanoid") and o.Parent ~= LP.Character then hookEnemy(o) end
end))

-- Credit the most-recent active enemy track within range.
local function creditAttack(killed)
    local now = os.clock()
    local bestId, bestStart, bestDist = nil, -math.huge, 0
    for hm, ids in pairs(active) do
        if hm and hm.Parent and withinRange(hm.Parent) then
            for id, info in pairs(ids) do
                local startT = info.start or info  -- back-compat
                if startT > bestStart then
                    bestStart = startT; bestId = id
                    bestDist = info.dist or 0
                end
            end
        end
    end
    if bestId then
        local impact = now - bestStart
        if impact > 0.05 and impact < 3.0 then
            record(bestId, impact, killed, bestDist)
        end
    end
end

-- Damage detection + death analysis on the LocalPlayer's humanoid.
local function bindLocalHumanoid(char)
    local hum = char:WaitForChild("Humanoid", 5)
    if not hum then return end
    local lastHealth = hum.Health
    Conns.add(hum.HealthChanged:Connect(function(h)
        if h < lastHealth then creditAttack(false) end
        lastHealth = h
    end))
    -- Killing blow: stronger evidence; recorded with deaths++ and persisted.
    Conns.add(hum.Died:Connect(function() creditAttack(true) end))
end

if LP.Character then bindLocalHumanoid(LP.Character) end
Conns.add(LP.CharacterAdded:Connect(bindLocalHumanoid))

loadData()
sanitize()

function AutoParryData.init(state) State = state end
return AutoParryData

end)
__bundle_register("Utility/Logger", function(require, _LOADED, __bundle_register, __bundle_modules)
local Logger = {}
local function emit(level, ...)
    local args = {...}
    local parts = {}
    for i, v in ipairs(args) do parts[i] = tostring(v) end
    print("[" .. level .. "] " .. table.concat(parts, " "))
end
function Logger.info(...) emit("info", ...) end
function Logger.warn(...) warn(...) end
function Logger.error(...) emit("error", ...) end
return Logger

end)
__bundle_register("Utility/State", function(require, _LOADED, __bundle_register, __bundle_modules)
-- Shared state. Each feature reads/writes here. Saved per-session only.
return {
    -- Movement
    Fly=false, FlySpeed=80,
    Noclip=false,
    ToggleSprint=false,

    -- Visuals
    Fullbright=false,
    LowGfx=false,
    ESP=false, ESPRange=1500, ESPHealth=true, ESPDistance=true, ESPName=true,
    ESPOutline=true, ESPWeapon=true,
    AnimViz=false, AnimAllChars=true,

    -- Combat / AutoParry
    AutoParry=false, AutoParryRange=30, AutoParryOffset=0,
    AutoParryKey="MouseButton2", PingComp=true,

    -- Mod checker / debug / notifications
    ModeratorChecker=true, Debug=false,
    NotificationsEnabled=true,
    KeybindHud=true,
}

end)
return __bundle_require("__root")