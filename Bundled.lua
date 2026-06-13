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

-- Tear down previous run. The bundle re-runs as a FRESH module graph, so this
-- run's Conns can't see the old run's connections — we stash the teardown in a
-- global so each run cleanly kills the PREVIOUS one. Without this, every
-- loadstring reload stacked another AutoParry/ESP loop (stacked block-release
-- timers cancelled each other → nothing parried).
local prevConns = require("Utility/Conns")
if _G.__VV_Teardown then pcall(_G.__VV_Teardown) end
prevConns.teardown()
_G.__VV_Teardown = prevConns.teardown
do
    local pg = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
    for _, p in ipairs({ pg, gethui and gethui() or nil }) do
        if p then
            for _, n in ipairs({ "MyMenu", "Notifications", "AnimVisualizer", "KeybindHud", "VVFovCircle", "StreakSplash" }) do
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
    RemoteSpy           = require("Features/RemoteSpy"),
    StreamProof         = require("Utility/StreamProof"),
    PlayerTiming        = require("Features/PlayerTiming"),
}
_G.__AutoParryData = features.AutoParryData
_G.__ParryTimings  = features.ParryTimings
_G.__Notify        = features.Notification.send
_G.__AnimViz       = features.AnimationVisualizer   -- for attack-category (M1/Critical) lookup
-- NOTE: we intentionally do NOT auto-generate timings from learned data here.
-- AutoParry only ever uses timings you explicitly saved (parrytimings.json),
-- which are loaded at require-time. "Regenerate" stays available as a button.

for name, mod in pairs(features) do
    if mod.init then mod.init(State) end
    Logger.info("[Init] " .. name)
end

local Menu   = require("Menu/Main")
local Splash = require("GUI/Splash")
do
    local parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    pcall(function() if gethui then parent = gethui() end end)
    -- Animated logo splash, THEN build the menu. If no logo image is present the
    -- splash is skipped and the menu builds immediately.
    Splash.show(parent, function()
        Menu.build(State, features)
        features.Notification.send("Loaded", "Script ready", 2, Color3.fromRGB(96, 175, 255))
    end)
end
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
local Conns           = require("Utility/Conns")

local Menu = {}

-- Live remote-spy list. Renders RemoteSpy.getLog() (newest first) into a
-- scrolling panel, refreshing only when the log version changes. Rows are
-- pooled/reused so a busy game doesn't thrash instances. Click a row to copy
-- the remote's full path to your clipboard.
local function buildSpyList(holder, F)
    local RunSvc = game:GetService("RunService")

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, 0, 1, 0)
    scroll.BackgroundColor3 = Color3.fromRGB(14, 12, 20)
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 5
    scroll.ScrollBarImageColor3 = Color3.fromRGB(150, 120, 220)
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.Parent = holder
    local cn = Instance.new("UICorner", scroll); cn.CornerRadius = UDim.new(0, 8)
    local pd = Instance.new("UIPadding", scroll)
    pd.PaddingLeft = UDim.new(0, 6); pd.PaddingRight = UDim.new(0, 6)
    pd.PaddingTop  = UDim.new(0, 6); pd.PaddingBottom = UDim.new(0, 6)
    local layout = Instance.new("UIListLayout", scroll)
    layout.Padding = UDim.new(0, 4); layout.SortOrder = Enum.SortOrder.LayoutOrder

    local empty = Instance.new("TextLabel")
    empty.Size = UDim2.new(1, 0, 0, 42); empty.BackgroundTransparency = 1
    empty.Text = "No remotes captured yet.\nEnable Spyware above, then play."
    empty.TextColor3 = Color3.fromRGB(150, 150, 170); empty.TextSize = 12
    empty.Font = Enum.Font.Gotham; empty.TextWrapped = true; empty.LayoutOrder = 9999
    empty.Parent = scroll

    local rows = {}
    local lastVersion, lastTime = -1, 0

    local function colorFor(dir)
        return dir == "in" and Color3.fromRGB(250, 165, 80) or Color3.fromRGB(120, 220, 150)
    end

    local function makeRow(i)
        local row = {}
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 40); btn.BackgroundColor3 = Color3.fromRGB(26, 21, 40)
        btn.AutoButtonColor = false; btn.Text = ""; btn.BorderSizePixel = 0; btn.Parent = scroll
        local c = Instance.new("UICorner", btn); c.CornerRadius = UDim.new(0, 6)
        local tag = Instance.new("TextLabel")
        tag.Size = UDim2.new(0, 40, 0, 16); tag.Position = UDim2.fromOffset(8, 4)
        tag.BackgroundTransparency = 1; tag.Font = Enum.Font.GothamBold; tag.TextSize = 11
        tag.TextXAlignment = Enum.TextXAlignment.Left; tag.Parent = btn
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -120, 0, 16); title.Position = UDim2.fromOffset(52, 4)
        title.BackgroundTransparency = 1; title.Font = Enum.Font.GothamBold; title.TextSize = 12
        title.TextColor3 = Color3.fromRGB(245, 242, 252)
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.TextTruncate = Enum.TextTruncate.AtEnd; title.Parent = btn
        local cnt = Instance.new("TextLabel")
        cnt.Size = UDim2.new(0, 56, 0, 16); cnt.Position = UDim2.new(1, -62, 0, 4)
        cnt.BackgroundTransparency = 1; cnt.Font = Enum.Font.Code; cnt.TextSize = 11
        cnt.TextColor3 = Color3.fromRGB(168, 160, 192)
        cnt.TextXAlignment = Enum.TextXAlignment.Right; cnt.Parent = btn
        local args = Instance.new("TextLabel")
        args.Size = UDim2.new(1, -16, 0, 14); args.Position = UDim2.fromOffset(8, 21)
        args.BackgroundTransparency = 1; args.Font = Enum.Font.Code; args.TextSize = 11
        args.TextColor3 = Color3.fromRGB(150, 160, 182)
        args.TextXAlignment = Enum.TextXAlignment.Left
        args.TextTruncate = Enum.TextTruncate.AtEnd; args.Parent = btn
        row.btn, row.tag, row.title, row.cnt, row.args = btn, tag, title, cnt, args
        btn.MouseEnter:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(44, 32, 68) end)
        btn.MouseLeave:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(26, 21, 40) end)
        btn.MouseButton1Click:Connect(function()
            local e = row._entry
            if not e then return end
            local cb = setclipboard or toclipboard or (Clipboard and Clipboard.set)
            if cb then pcall(cb, e.path) end
            F.Notification.send("Spyware", "Copied path: " .. e.name, 2,
                Color3.fromRGB(120, 220, 150))
        end)
        rows[i] = row
        return row
    end

    local function rebuild()
        local logd = F.RemoteSpy.getLog()
        local count = #logd
        empty.Visible = (count == 0)
        for i = 1, count do
            local e = logd[count - i + 1]               -- newest first
            local row = rows[i] or makeRow(i)
            row.btn.Visible = true; row.btn.LayoutOrder = i
            row.tag.Text = (e.dir == "in" and "IN" or "OUT")
            row.tag.TextColor3 = colorFor(e.dir)
            row.title.Text = e.name .. "  (" .. e.method .. ")"
            row.cnt.Text = "x" .. e.count
            row.args.Text = (e.lastArgs ~= "" and e.lastArgs) or "(no args)"
            row._entry = e
        end
        for i = count + 1, #rows do rows[i].btn.Visible = false end
        scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 12)
    end

    rebuild()
    Conns.add(RunSvc.Heartbeat:Connect(function()
        if os.clock() - lastTime < 0.35 then return end
        local v = F.RemoteSpy.getVersion()
        if v == lastVersion then return end
        lastTime = os.clock(); lastVersion = v
        rebuild()
    end))
end

-- Player Timing panel: lists timings/projectiles captured from watching other
-- players parry. Each row offers Replace (overwrite your saved timing), Add (new
-- timing), or — for projectiles — Add to the Hitbox Range capture list.
-- Reads F.PlayerTiming.captured and rebuilds whenever its `rev` counter bumps.
local function buildPlayerTiming(holder, F, ST)
    local RunSvc = game:GetService("RunService")
    local PT = F.PlayerTiming
    local root = Instance.new("Frame")
    root.Size = UDim2.new(1,0,1,0); root.BackgroundTransparency = 1; root.Parent = holder

    local clearBtn = Instance.new("TextButton")
    clearBtn.Size = UDim2.new(1,0,0,26); clearBtn.BackgroundColor3 = Color3.fromRGB(70,30,30)
    clearBtn.BorderSizePixel = 0; clearBtn.AutoButtonColor = false; clearBtn.Text = "Clear Captured"
    clearBtn.TextColor3 = Color3.fromRGB(235,235,245); clearBtn.TextSize = 12; clearBtn.Font = Enum.Font.GothamBold
    clearBtn.Parent = root
    Instance.new("UICorner", clearBtn).CornerRadius = UDim.new(0,6)
    clearBtn.MouseButton1Click:Connect(function() if PT and PT.clear then PT.clear() end end)

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1,0,1,-32); scroll.Position = UDim2.fromOffset(0,32)
    scroll.BackgroundColor3 = Color3.fromRGB(14,12,20); scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 5; scroll.ScrollBarImageColor3 = Color3.fromRGB(150,120,220)
    scroll.CanvasSize = UDim2.new(0,0,0,0); scroll.Parent = root
    Instance.new("UICorner", scroll).CornerRadius = UDim.new(0,8)
    local layout = Instance.new("UIListLayout", scroll)
    layout.Padding = UDim.new(0,4); layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scroll.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 12)
    end)
    local pdg = Instance.new("UIPadding", scroll)
    pdg.PaddingTop = UDim.new(0,6); pdg.PaddingLeft = UDim.new(0,6); pdg.PaddingRight = UDim.new(0,6)

    local AV = _G.__AnimViz
    local function nameFor(id) return (AV and AV.resolveName and AV.resolveName(id)) or id end
    local function catFor(id)  return (AV and AV.categoryOf and AV.categoryOf(id)) or "Other" end

    local rows = {}
    local function smallBtn(parent, xoff, txt, col, fn)
        local b = Instance.new("TextButton")
        b.Size = UDim2.fromOffset(52,20); b.Position = UDim2.new(1,xoff,0.5,-10)
        b.BackgroundColor3 = col; b.BorderSizePixel = 0; b.Text = txt
        b.TextColor3 = Color3.new(1,1,1); b.TextSize = 11; b.Font = Enum.Font.GothamBold; b.Parent = parent
        Instance.new("UICorner", b).CornerRadius = UDim.new(0,4)
        b.MouseButton1Click:Connect(fn); return b
    end
    local function refresh()
        for _, r in ipairs(rows) do r:Destroy() end; rows = {}
        local cap = (PT and PT.captured) or {}
        if #cap == 0 then
            local r = Instance.new("TextLabel"); r.Size = UDim2.new(1,0,0,26); r.BackgroundTransparency = 1
            r.Text = (ST and ST.PlayerTiming) and "  Block/parry a mob attack to capture its timing"
                or "  Turn on 'Capture My Timings' above"
            r.TextColor3 = Color3.fromRGB(150,150,170); r.TextSize = 12; r.Font = Enum.Font.Gotham
            r.TextXAlignment = Enum.TextXAlignment.Left; r.Parent = scroll
            rows[#rows+1] = r; return
        end
        for i, e in ipairs(cap) do
            local r = Instance.new("Frame"); r.Size = UDim2.new(1,0,0,28); r.BackgroundColor3 = Color3.fromRGB(26,21,40)
            r.BorderSizePixel = 0; r.LayoutOrder = i; r.Parent = scroll
            Instance.new("UICorner", r).CornerRadius = UDim.new(0,6)
            local lbl = Instance.new("TextLabel"); lbl.Size = UDim2.new(1,-118,1,0); lbl.Position = UDim2.fromOffset(8,0)
            lbl.BackgroundTransparency = 1; lbl.TextColor3 = Color3.fromRGB(235,235,245); lbl.TextSize = 12
            lbl.Font = Enum.Font.Gotham; lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.TextTruncate = Enum.TextTruncate.AtEnd; lbl.Parent = r
            if e.kind == "parry" then
                lbl.Size = UDim2.new(1,-174,1,0)   -- room for View + Add + Replace
                lbl.Text = string.format("%s  @ %dms%s", nameFor(e.id), e.ms,
                    e.attacker and ("  (vs "..e.attacker..")") or "")
                -- View: open this animation in the Animation Visualizer.
                smallBtn(r, -56, "View", Color3.fromRGB(70,90,170), function()
                    ST.AnimViz = true
                    if F.AnimationVisualizer and F.AnimationVisualizer.openWithId then
                        F.AnimationVisualizer.openWithId(e.id)
                    end
                end)
                local pt = _G.__ParryTimings
                local has = pt and pt.getTimes and #pt.getTimes(e.id) > 0
                if has then
                    smallBtn(r, -112, "Add", Color3.fromRGB(50,140,70), function()
                        if pt and pt.addParry then pt.addParry(e.id, e.ms/1000, catFor(e.id)) end
                        if _G.__Notify then _G.__Notify("Timing Added", nameFor(e.id).." +"..e.ms.."ms", 2, Color3.fromRGB(120,220,150)) end
                    end)
                    smallBtn(r, -168, "Replace", Color3.fromRGB(185,120,40), function()
                        if pt and pt.set then pt.set(e.id, e.ms/1000, catFor(e.id)) end
                        if _G.__Notify then _G.__Notify("Timing Replaced", nameFor(e.id).." → "..e.ms.."ms", 2, Color3.fromRGB(120,220,150)) end
                    end)
                else
                    smallBtn(r, -112, "Save", Color3.fromRGB(50,140,70), function()
                        if pt and pt.addParry then pt.addParry(e.id, e.ms/1000, catFor(e.id)) end
                        if _G.__Notify then _G.__Notify("Timing Saved", nameFor(e.id).." @ "..e.ms.."ms", 2, Color3.fromRGB(120,220,150)) end
                    end)
                end
            else
                local extra = (e.label and e.label ~= "" and e.label ~= e.pname) and ("  ·  "..e.label) or ""
                lbl.Text = string.format("📦 %s%s  (deflected)", e.pname, extra)
                smallBtn(r, -56, "Add", Color3.fromRGB(50,140,70), function()
                    _G.__ProjectileNames = _G.__ProjectileNames or {}; _G.__ProjectileNames[e.pname] = true
                    Settings.set("projectile_names", _G.__ProjectileNames)
                    if _G.__Notify then _G.__Notify("Projectile Added", e.pname, 2, Color3.fromRGB(120,220,150)) end
                end)
            end
            rows[#rows+1] = r
        end
    end
    refresh()
    local lastRev = -1
    Conns.add(RunSvc.Heartbeat:Connect(function()
        local rev = (PT and PT.rev) or 0
        if rev ~= lastRev then lastRev = rev; refresh() end
    end))
end

-- Capture Projectiles panel: teaches the Hitbox Range blocker new projectiles.
-- Click "Start Capture", get hit by a ranged move once, and any part that reached
-- you appears below — click "+ Add" to save it. Combat reads _G.__ProjectileNames;
-- we persist to Settings("projectile_names").
local function buildProjectileCapture(holder, F)
    local RunSvc  = game:GetService("RunService")
    local Players = game:GetService("Players")
    local LP      = Players.LocalPlayer

    local candidates = {}      -- name -> parent string
    local capturing, capConn = false, nil
    local searchQ = ""         -- filters the saved + captured lists

    local root = Instance.new("Frame")
    root.Size = UDim2.new(1,0,1,0); root.BackgroundTransparency = 1; root.Parent = holder

    local capBtn = Instance.new("TextButton")
    capBtn.Size = UDim2.new(1,0,0,30); capBtn.BackgroundColor3 = Color3.fromRGB(40,30,60)
    capBtn.BorderSizePixel = 0; capBtn.AutoButtonColor = false
    capBtn.Text = "▶  Start Capture — then get hit by the move"
    capBtn.TextColor3 = Color3.fromRGB(235,235,245); capBtn.TextSize = 12; capBtn.Font = Enum.Font.GothamBold
    capBtn.Parent = root
    Instance.new("UICorner", capBtn).CornerRadius = UDim.new(0,6)

    -- Options strip: Auto-Add · Scan source · Clear All ---------------------
    local opt = {
        autoAdd = Settings.get("proj_autoadd", false),
        scanWS  = Settings.get("proj_scan_ws", false),
    }
    local function mkBtn(x, w)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(w,-3,0,22); b.Position = UDim2.new(x, x>0 and 3 or 0, 0, 34)
        b.BackgroundColor3 = Color3.fromRGB(34,26,52); b.BorderSizePixel = 0; b.AutoButtonColor = false
        b.TextColor3 = Color3.fromRGB(235,235,245); b.TextSize = 11; b.Font = Enum.Font.GothamBold; b.Parent = root
        Instance.new("UICorner", b).CornerRadius = UDim.new(0,5)
        return b
    end
    local autoBtn, scanBtn, clearBtn = mkBtn(0,0.34), mkBtn(0.34,0.33), mkBtn(0.67,0.33)
    clearBtn.Text = "Clear Captured"; clearBtn.BackgroundColor3 = Color3.fromRGB(70,30,30)
    local function refreshOptBtns()
        autoBtn.Text = "Auto-Add: " .. (opt.autoAdd and "ON" or "OFF")
        autoBtn.BackgroundColor3 = opt.autoAdd and Color3.fromRGB(40,90,55) or Color3.fromRGB(34,26,52)
        scanBtn.Text = "Scan: " .. (opt.scanWS and "Workspace" or "Debris")
    end

    -- Add-by-name row -------------------------------------------------------
    local nameBox = Instance.new("TextBox")
    nameBox.Size = UDim2.new(1,-62,0,22); nameBox.Position = UDim2.fromOffset(0,60)
    nameBox.BackgroundColor3 = Color3.fromRGB(14,12,20); nameBox.BorderSizePixel = 0
    nameBox.PlaceholderText = "Add projectile by exact part name…"; nameBox.Text = ""
    nameBox.TextColor3 = Color3.fromRGB(235,235,245); nameBox.PlaceholderColor3 = Color3.fromRGB(120,120,140)
    nameBox.TextSize = 11; nameBox.Font = Enum.Font.Gotham; nameBox.ClearTextOnFocus = false
    nameBox.TextXAlignment = Enum.TextXAlignment.Left; nameBox.Parent = root
    Instance.new("UICorner", nameBox).CornerRadius = UDim.new(0,5)
    Instance.new("UIPadding", nameBox).PaddingLeft = UDim.new(0,8)
    local addNameBtn = Instance.new("TextButton")
    addNameBtn.Size = UDim2.fromOffset(56,22); addNameBtn.Position = UDim2.new(1,-56,0,60)
    addNameBtn.BackgroundColor3 = Color3.fromRGB(50,140,70); addNameBtn.BorderSizePixel = 0
    addNameBtn.Text = "+ Add"; addNameBtn.TextColor3 = Color3.fromRGB(255,255,255)
    addNameBtn.TextSize = 11; addNameBtn.Font = Enum.Font.GothamBold; addNameBtn.Parent = root
    Instance.new("UICorner", addNameBtn).CornerRadius = UDim.new(0,5)

    -- Search row -----------------------------------------------------------
    local searchBox = Instance.new("TextBox")
    searchBox.Size = UDim2.new(1,0,0,22); searchBox.Position = UDim2.fromOffset(0,90)
    searchBox.BackgroundColor3 = Color3.fromRGB(14,12,20); searchBox.BorderSizePixel = 0
    searchBox.PlaceholderText = "🔍  Search projectiles…"; searchBox.Text = ""
    searchBox.TextColor3 = Color3.fromRGB(235,235,245); searchBox.PlaceholderColor3 = Color3.fromRGB(120,120,140)
    searchBox.TextSize = 11; searchBox.Font = Enum.Font.Gotham; searchBox.ClearTextOnFocus = false
    searchBox.TextXAlignment = Enum.TextXAlignment.Left; searchBox.Parent = root
    Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0,5)
    Instance.new("UIPadding", searchBox).PaddingLeft = UDim.new(0,8)

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1,0,1,-118); scroll.Position = UDim2.fromOffset(0,118)
    scroll.BackgroundColor3 = Color3.fromRGB(14,12,20); scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 5; scroll.ScrollBarImageColor3 = Color3.fromRGB(150,120,220)
    scroll.CanvasSize = UDim2.new(0,0,0,0); scroll.Parent = root
    Instance.new("UICorner", scroll).CornerRadius = UDim.new(0,8)
    local layout = Instance.new("UIListLayout", scroll)
    layout.Padding = UDim.new(0,4); layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scroll.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 12)
    end)
    local pd = Instance.new("UIPadding", scroll)
    pd.PaddingTop = UDim.new(0,6); pd.PaddingLeft = UDim.new(0,6); pd.PaddingRight = UDim.new(0,6)

    local function inCharacter(part)
        local m = part:FindFirstAncestorWhichIsA("Model")
        while m do if m:FindFirstChildOfClass("Humanoid") then return true end; m = m:FindFirstAncestorWhichIsA("Model") end
        return false
    end
    local function nearPlayer(part)
        local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return false end
        return (part.Position - hrp.Position).Magnitude <= (part.Size.Magnitude * 0.5 + 18)
    end
    local function persist() Settings.set("projectile_names", _G.__ProjectileNames or {}) end

    local function onPart(o)
        if not capturing or not o:IsA("BasePart") or inCharacter(o) then return end
        local nm, par = o.Name, (o.Parent and o.Parent.Name or "?")
        task.delay(0.25, function()
            if not capturing or not o.Parent or not nearPlayer(o) then return end
            if _G.__ProjectileNames and _G.__ProjectileNames[nm] then return end
            if opt.autoAdd then
                _G.__ProjectileNames = _G.__ProjectileNames or {}
                _G.__ProjectileNames[nm] = true; persist()
                if _G.__Notify then _G.__Notify("Projectile Auto-Added", nm, 2, Color3.fromRGB(120,220,150)) end
            else
                candidates[nm] = par
            end
        end)
    end
    local function setCapturing(on)
        capturing = on
        if capConn then capConn:Disconnect(); capConn = nil end
        if on then
            local src = (opt.scanWS and workspace) or workspace:FindFirstChild("Debris") or workspace
            capConn = src.DescendantAdded:Connect(onPart)
            capBtn.Text = "⏹  Stop Capture  (get hit now…)"; capBtn.BackgroundColor3 = Color3.fromRGB(120,40,40)
        else
            capBtn.Text = "▶  Start Capture — then get hit by the move"; capBtn.BackgroundColor3 = Color3.fromRGB(40,30,60)
        end
    end
    capBtn.MouseButton1Click:Connect(function() setCapturing(not capturing) end)
    Conns.onTeardown(function() if capConn then capConn:Disconnect() end end)

    local rows = {}
    local function row(order, text, color, btnText, btnColor, onClick)
        local r = Instance.new("Frame")
        r.Size = UDim2.new(1,0,0,26); r.BackgroundColor3 = Color3.fromRGB(26,21,40)
        r.BorderSizePixel = 0; r.LayoutOrder = order; r.Parent = scroll
        Instance.new("UICorner", r).CornerRadius = UDim.new(0,6)
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1,-66,1,0); lbl.Position = UDim2.fromOffset(8,0); lbl.BackgroundTransparency = 1
        lbl.Text = text; lbl.TextColor3 = color; lbl.TextSize = 12; lbl.Font = Enum.Font.Gotham
        lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.TextTruncate = Enum.TextTruncate.AtEnd; lbl.Parent = r
        if btnText then
            local b = Instance.new("TextButton")
            b.Size = UDim2.fromOffset(54,18); b.Position = UDim2.new(1,-60,0.5,-9)
            b.BackgroundColor3 = btnColor; b.BorderSizePixel = 0; b.Text = btnText
            b.TextColor3 = Color3.fromRGB(255,255,255); b.TextSize = 11; b.Font = Enum.Font.GothamBold; b.Parent = r
            Instance.new("UICorner", b).CornerRadius = UDim.new(0,4)
            b.MouseButton1Click:Connect(onClick)
        end
        rows[#rows+1] = r
    end
    local function matches(name) return searchQ == "" or name:lower():find(searchQ, 1, true) ~= nil end
    local function refresh()
        for _, r in ipairs(rows) do r:Destroy() end; rows = {}
        local o = 0
        o = o + 1; row(o, "KNOWN PROJECTILES", Color3.fromRGB(120,225,255))
        local anySaved = false
        for name in pairs(_G.__ProjectileNames or {}) do
            if matches(name) then
                anySaved = true; o = o + 1
                row(o, name, Color3.fromRGB(120,220,150), "Remove", Color3.fromRGB(150,50,50), function()
                    _G.__ProjectileNames[name] = nil; persist(); refresh()
                end)
            end
        end
        if not anySaved then o = o + 1; row(o, searchQ ~= "" and "  (no matches)" or "  (none yet)", Color3.fromRGB(150,150,170)) end
        o = o + 1; row(o, "CAPTURED — CLICK + ADD", Color3.fromRGB(255,210,95))
        local anyCand = false
        for name, par in pairs(candidates) do
            if matches(name) then
                anyCand = true; o = o + 1
                row(o, name .. "   ◂ " .. par, Color3.fromRGB(235,235,245), "+ Add", Color3.fromRGB(50,140,70), function()
                    _G.__ProjectileNames = _G.__ProjectileNames or {}
                    _G.__ProjectileNames[name] = true; candidates[name] = nil; persist(); refresh()
                    if _G.__Notify then _G.__Notify("Projectile Added", name, 2, Color3.fromRGB(120,220,150)) end
                end)
            end
        end
        if not anyCand then o = o + 1; row(o, searchQ ~= "" and "  (no matches)" or (capturing and "  (waiting — get hit by the move)" or "  (start capture, then get hit)"), Color3.fromRGB(150,150,170)) end
    end

    refresh()
    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        searchQ = searchBox.Text:lower(); refresh()
    end)
    -- Wire the option controls now that refresh()/persist()/setCapturing exist.
    refreshOptBtns()
    autoBtn.MouseButton1Click:Connect(function()
        opt.autoAdd = not opt.autoAdd; Settings.set("proj_autoadd", opt.autoAdd); refreshOptBtns()
    end)
    scanBtn.MouseButton1Click:Connect(function()
        opt.scanWS = not opt.scanWS; Settings.set("proj_scan_ws", opt.scanWS); refreshOptBtns()
        if capturing then setCapturing(false); setCapturing(true) end   -- rebind to new source
    end)
    clearBtn.MouseButton1Click:Connect(function()
        -- Clear only the CAPTURED candidates, never the saved/added list.
        for k in pairs(candidates) do candidates[k] = nil end
        refresh()
        if _G.__Notify then _G.__Notify("Projectiles", "Cleared captured — saved ones kept", 2, Color3.fromRGB(240,150,90)) end
    end)
    local function addByName(nm)
        nm = (nm or ""):gsub("^%s+",""):gsub("%s+$","")
        if nm == "" then return end
        _G.__ProjectileNames = _G.__ProjectileNames or {}; _G.__ProjectileNames[nm] = true
        candidates[nm] = nil; persist(); refresh()
        if _G.__Notify then _G.__Notify("Projectile Added", nm, 2, Color3.fromRGB(120,220,150)) end
    end
    addNameBtn.MouseButton1Click:Connect(function() addByName(nameBox.Text); nameBox.Text = "" end)
    nameBox.FocusLost:Connect(function(enter) if enter then addByName(nameBox.Text); nameBox.Text = "" end end)
    local lastSig, lastT = "", 0
    Conns.add(RunSvc.Heartbeat:Connect(function()
        if os.clock() - lastT < 0.4 then return end
        lastT = os.clock()
        local parts = {}
        for k in pairs(_G.__ProjectileNames or {}) do parts[#parts+1] = "s:" .. k end
        for k in pairs(candidates) do parts[#parts+1] = "c:" .. k end
        table.sort(parts)
        local sig = table.concat(parts, "|")
        if sig ~= lastSig then lastSig = sig; refresh() end
    end))
end

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
    -- Re-apply persisted Spyware state now that State is restored (init ran
    -- before the restore, so the hook wasn't installed for a saved-on session).
    F.RemoteSpy.setEnabled(State.Spyware == true)
    local function persistent(setter, key)
        return function(v) setter(v); Settings.set("state__" .. key, v) end
    end

    local W = Library.new(parent, "Streak", "VV ULTIMATUM")

    -- Hiding the menu also hides the Animation Visualizer (and re-shows it
    -- when the menu comes back, if it was open).
    local avWasOpen = false
    W:OnVisibleChanged(function(visible)
        if not visible then
            avWasOpen = State.AnimViz == true
            if avWasOpen then
                State.AnimViz = false
                F.AnimationVisualizer.toggle(false)
            end
        elseif avWasOpen then
            State.AnimViz = true
            F.AnimationVisualizer.toggle(true)
            avWasOpen = false
        end
    end)

    -- Keybinds. Each toggle can be bound to a key from Settings → Keybinds.
    local function flip(key, setter)
        return function()
            local v = not State[key]
            setter(v); Settings.set("state__" .. key, v)
            F.Notification.send("Keybind", key .. ": " .. (v and "ON" or "OFF"), 1,
                v and Color3.fromRGB(120,220,150) or Color3.fromRGB(160,160,160), "Toggle")
        end
    end
    Keybinds.register("toggle_menu",      Enum.KeyCode.PageUp, function() W:ToggleVisible() end)
    Keybinds.register("toggle_kbhud",     Enum.KeyCode.Unknown, function()
        State.KeybindHud = not State.KeybindHud
        F.KeybindHud.setEnabled(State.KeybindHud)
        Settings.set("state__KeybindHud", State.KeybindHud)
    end)
    Keybinds.register("toggle_autoparry", Enum.KeyCode.F, flip("AutoParry",    F.Combat.setAutoParry))
    Keybinds.register("toggle_fly",       Enum.KeyCode.G, flip("Fly",          F.Movement.setFly))
    Keybinds.register("toggle_noclip",    Enum.KeyCode.H, flip("Noclip",       F.Movement.setNoclip))
    Keybinds.register("toggle_esp",       Enum.KeyCode.J, flip("ESP",          F.Visuals.setESP))
    Keybinds.register("toggle_sprint",    Enum.KeyCode.K, flip("ToggleSprint", F.Movement.setSprint))
    Keybinds.register("toggle_ttb",       Enum.KeyCode.T, flip("TweenToBack", F.Movement.setTweenToBack))
    Keybinds.register("toggle_visualizer",Enum.KeyCode.V, function()
        State.AnimViz = not State.AnimViz; F.AnimationVisualizer.toggle(State.AnimViz) end)
    -- Panic Hide — instantly hide/show EVERY script GUI (menu, ESP tags, debug,
    -- notifications…). The reliable way to clear the screen before a screenshare
    -- on executors (like Volt) that can't exclude ScreenGuis from capture.
    local _guiHidden = false
    Keybinds.register("panic_hide", Enum.KeyCode.Unknown, function()
        _guiHidden = not _guiHidden
        if not _guiHidden then F.StreamProof.setAllVisible(true) end   -- show first so the toast lands
        F.Notification.send("Panic Hide", _guiHidden and "Hiding all GUIs" or "GUIs restored", 1,
            _guiHidden and Color3.fromRGB(240,150,90) or Color3.fromRGB(120,220,150))
        if _guiHidden then task.defer(function() F.StreamProof.setAllVisible(false) end) end
    end)

    --========================================
    -- COMBAT — basic AutoParry only (fires your saved timings).
    --========================================
    W:TabGroup("Combat")
    local cmb = W:Tab("Combat", "⚔️")

    cmb:Section("AutoParry")
    cmb:Toggle("AutoParry", function() return State.AutoParry end,
        persistent(F.Combat.setAutoParry, "AutoParry"),
        "Auto-blocks (M2) at the exact frame of an enemy attack, using your saved timings.")
    -- Detection Range: the single distance knob. Routes through setDetectionRange,
    -- which pins the proximity gate AND the attack-hitbox size/reach to this value.
    cmb:Slider("Detection Range", 5, 60, function() return State.DetectionRange end,
        persistent(function(v) F.Combat.setDetectionRange(v) end, "DetectionRange"), " studs",
        "The ONE distance AutoParry uses for everything: how close an enemy must be for their attack to be detected, validated and parried, AND the attack hitbox's size + forward reach. Lower it to stop parrying far-away attacks — detection range and hitbox range always scale together so they can never mismatch.", 18)
    cmb:Toggle("Auto Dodge", function() return State.AutoDodge end,
        persistent(function(v) State.AutoDodge = v end, "AutoDodge"),
        "On attacks where you saved a DODGE timing (Animation Visualizer → Save Dodge Timing), DASH instead of block — in the direction you're moving (WASD), or backward if idle. Parry timings still block. Needs AutoParry on.")
    -- Timing fine-tune (ms shown, seconds stored). + = fire later, − = earlier.
    cmb:Slider("Timing Offset", -150, 150, function() return math.floor((State.TimingOffset or 0)*1000) end,
        function(v) State.TimingOffset = v/1000; Settings.set("state__TimingOffset", State.TimingOffset) end,
        " ms",
        "Fine-tune the parry moment. + fires later, − fires earlier. Leave at 0 unless parries feel consistently early or late.", 0)
    if math.abs(State.TimingOffset or 0) > 5 then State.TimingOffset = (State.TimingOffset or 0)/1000 end
    cmb:Slider("Block Hold", 100, 800, function() return math.floor((State.BlockHold or 0.35)*1000) end,
        function(v) State.BlockHold = v/1000; Settings.set("state__BlockHold", State.BlockHold) end,
        " ms",
        "How long to keep blocking after a parry fires. Too short and the block drops before the hit lands; longer is safer vs multiple/fast attackers.", 350)
    if (State.BlockHold or 0) > 5 then State.BlockHold = (State.BlockHold or 0)/1000 end
    cmb:Toggle("High Ping Mode", function() return State.HighPing end,
        persistent(function(v) State.HighPing = v end, "HighPing"),
        "For high / jittery ping (150ms+). Presses the block a touch earlier AND holds it ~your-ping longer, so it stays UP across the uncertainty window even when latency varies shot-to-shot. Turn on if parries inconsistently miss at high ping. (Tip: also enable Repeat on Miss as a safety net.)")
    cmb:Toggle("Nearest Target Only", function() return State.ParryNearestOnly end,
        persistent(function(v) State.ParryNearestOnly = v end, "ParryNearestOnly"),
        "Only parry the closest attacking enemy.")
    cmb:Toggle("Players Only", function() return State.ParryPlayersOnly end,
        persistent(function(v) State.ParryPlayersOnly = v end, "ParryPlayersOnly"),
        "Ignore mobs/NPCs; only parry real players.")
    cmb:Toggle("Mobs Only", function() return State.ParryMobsOnly end,
        persistent(function(v) State.ParryMobsOnly = v end, "ParryMobsOnly"),
        "Ignore players and dialogue/quest NPCs; only parry enemy mobs (Hollows, etc.).")
    cmb:Toggle("Facing Me Only", function() return State.ParryFacingMe end,
        persistent(function(v) State.ParryFacingMe = v end, "ParryFacingMe"),
        "Only parry attackers whose front is pointed at you (~70° cone). Ignores enemies swinging away from you.")
    cmb:Toggle("Facing Prediction", function() return State.FacingPredict end,
        persistent(function(v) State.FacingPredict = v end, "FacingPredict"),
        "Smarter 'Facing Me Only': predicts where a TURNING attacker will be aimed when the hit lands (from how fast they're spinning), so spin attacks / turn-ins still parry. Only affects the Facing Me Only filter. (deepwoken's facing prediction.)")
    cmb:Toggle("Parry While Tabbed Out", function() return State.ParryWhenUnfocused end,
        persistent(function(v) State.ParryWhenUnfocused = v end, "ParryWhenUnfocused"),
        "Off (default): never parry while the Roblox window is unfocused.")
    cmb:Toggle("Hitbox Prediction", function() return State.HitboxPredict end,
        persistent(function(v) State.HitboxPredict = v end, "HitboxPredict"),
        "Refines parrying by direction: only parry when you're actually inside the attacker's forward ATTACK box (the box ESP draws while they swing), not just within range. Includes where they'll be at impact (velocity-predicted). The box is sized by Detection Range and never reaches past it; stacks with Players/Mobs/Nearest/Facing.")
    cmb:Toggle("Hitbox History", function() return State.HitboxHistory end,
        persistent(function(v) State.HitboxHistory = v end, "HitboxHistory"),
        "Works with Hitbox Prediction: also tests the attacker's recent PAST positions, so a fast-moving attacker or a laggy frame doesn't slip the box. (deepwoken's position interpolation.)")
    cmb:Toggle("Repeat on Miss", function() return State.RepeatOnMiss end,
        persistent(function(v) State.RepeatOnMiss = v end, "RepeatOnMiss"),
        "If a parry whiffs (you take damage), re-press block to catch the next hit in the combo.")
    cmb:Slider("Repeat Attempts", 1, 5, function() return State.RepeatOnMissMax end,
        persistent(function(v) State.RepeatOnMissMax = v end, "RepeatOnMissMax"), "",
        "How many follow-up blocks a single missed parry may trigger.", 2)
    cmb:Toggle("Repeat Until End", function() return State.RPUE end,
        persistent(function(v) State.RPUE = v end, "RPUE"),
        "deepwoken RPUE: after the first parry, keep re-blocking every interval while that attack is still playing, so drawn-out / multi-hit attacks stay blocked.")
    cmb:Slider("Repeat Interval", 50, 500, function() return State.RPUEInterval end,
        persistent(function(v) State.RPUEInterval = v end, "RPUEInterval"), " ms",
        "How often Repeat Until End re-presses block while the attack plays.", 200)
    cmb:Toggle("AP-Breaker Filter", function() return State.APBreaker end,
        persistent(function(v) State.APBreaker = v end, "APBreaker"),
        "Ignore SPOOFED animations used to bait your parry — ones playing at an abnormal speed or with near-zero weight (a 'fake' attack). It won't parry those.")
    cmb:Slider("Max Anim Speed", 2, 20, function() return State.APBreakerSpeed end,
        persistent(function(v) State.APBreakerSpeed = v end, "APBreakerSpeed"), "x",
        "With AP-Breaker Filter on: animations at or above this speed multiplier are treated as spoofed and ignored.", 6)
    cmb:Toggle("Failure Simulation", function() return State.FailSim end,
        persistent(function(v) State.FailSim = v end, "FailSim"),
        "Intentionally MISS some parries to look human instead of frame-perfect. How often = Failure Rate.")
    cmb:Slider("Failure Rate", 0, 100, function() return State.FailRate end,
        persistent(function(v) State.FailRate = v end, "FailRate"), " %",
        "Chance (%) that any given parry is intentionally skipped while Failure Simulation is on.", 10)
    cmb:Toggle("Feint Attacks", function() return State.Feint end,
        persistent(function(v) State.Feint = v end, "Feint"),
        "If AutoParry needs to block while you're mid-swing, it feints your attack first (Combat 'Feint') so the block can come out — only at the START of your swing.")
    -- Slider shows ms but we persist SECONDS (State[k] is restored verbatim, so
    -- saving ms would reload as 250s — the old MinBlockGap double-convert bug).
    cmb:Slider("Feint Window", 50, 600, function() return math.floor((State.FeintWindow or 0.25)*1000) end,
        function(v) State.FeintWindow = v/1000; Settings.set("state__FeintWindow", State.FeintWindow) end,
        " ms",
        "How early in your swing a feint is still allowed (the 'beginning' of the swing).", 250)
    -- Self-heal any value mistakenly stored in ms from an older build.
    if (State.FeintWindow or 0) > 5 then State.FeintWindow = State.FeintWindow / 1000 end

    cmb:Toggle("Auto Feint", function() return State.SmartHit end,
        persistent(function(v) State.SmartHit = v end, "SmartHit"),
        "deepwoken-style: keep swinging freely, but the instant a REAL parry window is coming it feints (cancels) your swing so you don't whiff into their block — then AutoParry blocks. Outside a window your swings go through normally. Needs AutoParry on.")
    cmb:Dropdown("Auto Feint Type", { "Passive", "Aggressive" },
        function() return State.AutoFeintType or "Passive" end,
        persistent(function(v) State.AutoFeintType = v end, "AutoFeintType"),
        "Passive: only feint when the enemy hit would land BEFORE your swing ends (lets safe swings finish). Aggressive: always feint as soon as the parry window opens.")
    cmb:Toggle("Delayed Feints", function() return State.DelayedFeints end,
        persistent(function(v) State.DelayedFeints = v end, "DelayedFeints"),
        "Hold the feint until the last possible moment instead of cancelling early — your swing stays out as long as it's safe.")
    cmb:Slider("Auto Feint Window", 50, 500, function() return math.floor((State.SmartHitWindow or 0.25)*1000) end,
        function(v) State.SmartHitWindow = v/1000; Settings.set("state__SmartHitWindow", State.SmartHitWindow) end, " ms",
        "How early before a parry your swing is cancelled (Aggressive / non-delayed). Higher = stops you sooner.", 250)
    if (State.SmartHitWindow or 0) > 5 then State.SmartHitWindow = State.SmartHitWindow / 1000 end

    --========================================
    -- HITBOX RANGE — projectile/hitbox proximity detection (separate engine)
    --========================================
    cmb:Section("Hitbox Range (Projectiles)")
    cmb:Toggle("Hitbox Range Mode", function() return State.HitboxRangeMode end,
        persistent(F.Combat.setHitboxRangeMode, "HitboxRangeMode"),
        "Projectile detection mode — separate from AutoParry's animation timing. For RANGED attacks it reacts to the real projectile entering your range instead of the (too-early) attack animation. Runs independently (works even with AutoParry off). Lightweight: only tracks fast, un-owned parts that appear near you.")
    cmb:Toggle("Auto-Detect Projectiles", function() return State.HitboxAutoDetect end,
        persistent(function(v) State.HitboxAutoDetect = v end, "HitboxAutoDetect"),
        "NAME-AGNOSTIC catch-all. Instead of only parrying projectiles whose name is in your capture list, this reacts to ANY part that BEHAVES like a projectile — it spawned, TRAVELLED toward you, and reached your Hitbox Parry Range. Catches brand-new abilities you've never captured. Tiny effect particles (sparks/blood) are ignored by size. Leave ON; turn off only if you want strict name-list-only matching.")
    cmb:Toggle("Parry on Entry", function() return State.HitboxRangeParry end,
        persistent(function(v) State.HitboxRangeParry = v end, "HitboxRangeParry"),
        "When a projectile enters Hitbox Parry Range, fire a parry (block).")
    cmb:Slider("Hitbox Parry Range", 5, 80, function() return State.HitboxParryRange end,
        persistent(function(v) State.HitboxParryRange = v end, "HitboxParryRange"), " studs",
        "Distance at which an incoming projectile triggers a parry. Bigger = react earlier (good for fast projectiles).", 25)
    cmb:Slider("Min Spawn Distance", 0, 80, function() return State.HitboxMinDist or 0 end,
        persistent(function(v) State.HitboxMinDist = v end, "HitboxMinDist"), " studs",
        "0 = watch ALL projectiles (default; projectile parry always works). Raise it to ignore parts that appear closer than this — filters the local melee-effect particles (sparks/smoke) that spawn on you. NOTE: too high also ignores close-range real projectiles, so tune carefully (try 6–10).", 0)
    cmb:Slider("Hitbox Parry Delay", 0, 300, function() return math.floor((State.HitboxParryDelay or 0)*1000) end,
        function(v) State.HitboxParryDelay = v/1000; Settings.set("state__HitboxParryDelay", State.HitboxParryDelay) end, " ms",
        "Wait this long AFTER the projectile enters range before parrying. 0 = parry immediately on entry; raise it if you parry slightly too early.", 0)
    if (State.HitboxParryDelay or 0) > 5 then State.HitboxParryDelay = State.HitboxParryDelay / 1000 end
    cmb:Toggle("Dodge on Entry", function() return State.HitboxRangeDodge end,
        persistent(function(v) State.HitboxRangeDodge = v end, "HitboxRangeDodge"),
        "When a projectile enters Hitbox Dodge Range, DASH instead of parrying. If both this and Parry on Entry apply, parry takes priority within its range.")
    cmb:Slider("Hitbox Dodge Range", 5, 80, function() return State.HitboxDodgeRange end,
        persistent(function(v) State.HitboxDodgeRange = v end, "HitboxDodgeRange"), " studs",
        "Distance at which an incoming projectile triggers a dodge (DASH in your movement direction, or backward if idle).", 25)
    cmb:Slider("Hitbox Dodge Delay", 0, 300, function() return math.floor((State.HitboxDodgeDelay or 0)*1000) end,
        function(v) State.HitboxDodgeDelay = v/1000; Settings.set("state__HitboxDodgeDelay", State.HitboxDodgeDelay) end, " ms",
        "Wait this long AFTER the projectile enters range before dodging. 0 = dodge immediately on entry.", 0)
    if (State.HitboxDodgeDelay or 0) > 5 then State.HitboxDodgeDelay = State.HitboxDodgeDelay / 1000 end

    --========================================
    -- TIMINGS — full manager
    --========================================
    local tim = W:Tab("Timings", "⏱️")
    tim:Wide(function(holder)
        TimingsManager.build(holder, {
            timings = F.ParryTimings,
            notify  = F.Notification.send,
            resolveName = F.AnimationVisualizer.resolveName,
            openVisualizer = function(id)
                State.AnimViz = true
                F.AnimationVisualizer.openWithId(id)
            end,
        })
    end, 420, nil)

    --========================================
    -- MOVEMENT — sprint / fly / noclip grouped logically.
    --========================================
    W:TabGroup("Movement")
    local mov = W:Tab("Movement", "🏃")

    mov:Section("Speed")
    mov:Toggle("Toggle Sprint", function() return State.ToggleSprint end,
        persistent(F.Movement.setSprint, "ToggleSprint"),
        "Holds LeftShift via VirtualInputManager (no WalkSpeed change).")

    mov:Section("Flight")
    mov:Toggle("Fly", function() return State.Fly end,
        persistent(F.Movement.setFly, "Fly"),
        "WASD = move, Space = up, Ctrl = down.")
    mov:Slider("Fly Speed", 10, 300, function() return State.FlySpeed end,
        persistent(function(v) State.FlySpeed = v end, "FlySpeed"), nil,
        "Higher = faster fly.")

    mov:Section("Collision")
    mov:Toggle("Noclip", function() return State.Noclip end,
        persistent(F.Movement.setNoclip, "Noclip"),
        "Disables collision on your character. Original collisions restored on toggle off.")


    --========================================
    -- VISUALS — ESP is split into core + display elements,
    -- world rendering settings live in their own section.
    --========================================
    W:TabGroup("World")
    local vis = W:Tab("Visuals", "👁️")

    vis:Section("ESP")
    vis:Toggle("ESP", function() return State.ESP end,
        persistent(F.Visuals.setESP, "ESP"),
        "Through-wall tags. Red = player, Green = NPC, Orange = mob.")
    vis:Slider("Range", 100, 3000, function() return State.ESPRange end,
        persistent(function(v) State.ESPRange = v end, "ESPRange"), " studs",
        "How far the tags follow enemies.")
    vis:Toggle("Outline", function() return State.ESPOutline end,
        persistent(F.Visuals.setESPOutline, "ESPOutline"),
        "Glowing character outline, colored by type.")
    vis:Toggle("Show Hitboxes", function() return State.ESPHitbox end,
        persistent(function(v) State.ESPHitbox = v end, "ESPHitbox"),
        "Draw an enemy's attack hitbox ONLY while they're swinging (size from Combat → Hitbox Size). Green = normal/M1, Red = critical. It's the exact box AutoParry's Hitbox Prediction tests — stand inside it and a parry fires.")

    vis:Section("ESP Box")
    vis:Toggle("2D Box", function() return State.ESPBox end,
        persistent(function(v) State.ESPBox = v end, "ESPBox"),
        "Draw a 2D screen-space box framing each target (needs a Drawing-capable executor).")
    vis:Toggle("Box Health Bar", function() return State.ESPBoxBar end,
        persistent(function(v) State.ESPBoxBar = v end, "ESPBoxBar"),
        "Show a vertical health bar on the left edge of the 2D box.")

    vis:Section("ESP Optimization")
    vis:Toggle("Limit ESP Updates", function() return State.ESPLimitUpdates end,
        persistent(function(v) State.ESPLimitUpdates = v end, "ESPLimitUpdates"),
        "Throttle how often ESP redraws (saves FPS). Off = update every frame.")
    vis:Slider("ESP Refresh Rate", 1, 144, function() return State.ESPRefreshRate end,
        persistent(function(v) State.ESPRefreshRate = v end, "ESPRefreshRate"), "/s",
        "Max ESP updates per second when 'Limit ESP Updates' is on.", 30)
    vis:Slider("Max Targets", 0, 100, function() return State.ESPMaxTargets end,
        persistent(function(v) State.ESPMaxTargets = v end, "ESPMaxTargets"), "",
        "Only render the NEAREST N targets (0 = unlimited). The biggest FPS win at long range — keep a huge Range but cap how many boxes/highlights draw at once.", 0)
    vis:Toggle("Split Updates", function() return State.ESPSplitUpdates end,
        persistent(function(v) State.ESPSplitUpdates = v end, "ESPSplitUpdates"),
        "Spread tag updates across several frames — smoother FPS with many targets.")
    vis:Slider("Split Frames", 1, 16, function() return State.ESPSplitFrames end,
        persistent(function(v) State.ESPSplitFrames = v end, "ESPSplitFrames"), " frames",
        "How many frames to spread ESP updates over (higher = lighter, less responsive).", 3)
    vis:Toggle("No Persistent ESP", function() return State.NoPersistentESP end,
        persistent(function(v) State.NoPersistentESP = v end, "NoPersistentESP"),
        "Let ESP'd character models stream out normally instead of staying loaded.")

    vis:Section("ESP Filters")
    vis:Toggle("Players", function() return State.ESPPlayers end,
        persistent(function(v) State.ESPPlayers = v end, "ESPPlayers"),
        "Show real players (red). Turn off to hide them.")
    vis:Toggle("NPCs", function() return State.ESPNPCs end,
        persistent(function(v) State.ESPNPCs = v end, "ESPNPCs"),
        "Show interactable NPCs (green). Turn off to hide them.")
    vis:Toggle("Mobs", function() return State.ESPMobs end,
        persistent(function(v) State.ESPMobs = v end, "ESPMobs"),
        "Show hostile mobs (orange). Turn off to hide them.")
    vis:Slider("Text Scale", 50, 200, function() return State.ESPTextScale end,
        persistent(function(v) State.ESPTextScale = v end, "ESPTextScale"), "%",
        "Scale all ESP text (name / role / distance / health / weapon).", 100)

    vis:Section("ESP Display")
    vis:Toggle("Show Name",     function() return State.ESPName     end,
        persistent(function(v) State.ESPName = v end, "ESPName"),
        "Display the character's name above their head.")
    vis:Slider("Name Scale", 50, 250, function() return State.ESPNameScale end,
        persistent(function(v) State.ESPNameScale = v end, "ESPNameScale"), "%",
        "Scale just the name text, on top of the overall ESP text scale.", 100)
    vis:Toggle("Show Distance", function() return State.ESPDistance end,
        persistent(function(v) State.ESPDistance = v end, "ESPDistance"),
        "Show how far the enemy is from you.")
    vis:Toggle("Show Health",   function() return State.ESPHealth   end,
        persistent(function(v) State.ESPHealth = v end, "ESPHealth"),
        "Show the vertical health bar next to the enemy.")
    vis:Toggle("Split Health",  function() return State.ESPSplitHealth end,
        persistent(function(v) State.ESPSplitHealth = v end, "ESPSplitHealth"),
        "Move the health % up into the text stack above the head. The vertical bar stays on the side.")
    vis:Toggle("Show Weapon",   function() return State.ESPWeapon end,
        persistent(function(v) State.ESPWeapon = v end, "ESPWeapon"),
        "Shows the held weapon for players and mobs (not NPCs).")

    vis:Section("Combat Stats")
    vis:Toggle("Show Reiatsu", function() return State.ESPReiatsu end,
        persistent(function(v) State.ESPReiatsu = v end, "ESPReiatsu"),
        "Show the target's Reiatsu (spirit-energy resource), read live from their Status.")
    vis:Toggle("Show Posture", function() return State.ESPPosture end,
        persistent(function(v) State.ESPPosture = v end, "ESPPosture"),
        "Show the target's Posture (guard-break meter) as a % — high = about to be guard-broken.")
    vis:Toggle("Show Stamina", function() return State.ESPStamina end,
        persistent(function(v) State.ESPStamina = v end, "ESPStamina"),
        "Show the target's Shunpo (dash) stamina.")
    vis:Toggle("Show Race / Form", function() return State.ESPRaceForm end,
        persistent(function(v) State.ESPRaceForm = v end, "ESPRaceForm"),
        "Show the target's race/form (Soul Reaper / Hollow / Quincy, Hollow type) plus a [BOSS] tag.")
    vis:Toggle("Show States", function() return State.ESPStates end,
        persistent(function(v) State.ESPStates = v end, "ESPStates"),
        "Show active combat states (Blocking · Riposte · Projectile-Deflecting) when they're on.")

    vis:Section("Graphics")
    vis:Toggle("Fullbright", function() return State.Fullbright end,
        persistent(F.Visuals.setFullbright, "Fullbright"),
        "Pumps Lighting brightness + ambient and disables shadows.")
    -- The exact deepwoken-rewrite visual-removal set, each toggleable on its own.
    -- (Settings → Performance Mode flips all four at once.)
    vis:Toggle("No Fog", function() return State.NoFog end,
        persistent(F.Visuals.setNoFog, "NoFog"),
        "Push fog out to infinity and zero every Atmosphere density.")
    vis:Toggle("No Blur", function() return State.NoBlur end,
        persistent(F.Visuals.setNoBlur, "NoBlur"),
        "Set every BlurEffect size to 0.")
    vis:Toggle("No Shadows", function() return State.NoShadows end,
        persistent(F.Visuals.setNoShadows, "NoShadows"),
        "Disable Lighting.GlobalShadows.")
    vis:Toggle("No Animated Sea", function() return State.NoAnimatedSea end,
        persistent(F.Visuals.setNoAnimatedSea, "NoAnimatedSea"),
        "Disable the SeaClient water-animation scripts (no-op if the map has none).")

    --========================================
    -- SAFETY — server awareness + diagnostics.
    --========================================
    local saf = W:Tab("Safety", "🛡️")

    saf:Section("Server Awareness")
    saf:Toggle("Moderator Checker", function() return State.ModeratorChecker end,
        persistent(F.ModeratorChecker.setEnabled, "ModeratorChecker"),
        "Toast when a known moderator/admin joins the server.")
    saf:Toggle("YouTuber Checker", function() return State.YouTuberChecker end,
        persistent(F.ModeratorChecker.setYouTuberEnabled, "YouTuberChecker"),
        "Toast when a known content creator / YouTuber joins the server.")
    saf:Button("Scan players now", function() F.ModeratorChecker.scanAll() end,
        "Re-check every current player against the moderator + YouTuber lists.")

    saf:Section("Privacy")
    saf:Toggle("Stream Proof", function() return State.StreamProof end,
        persistent(F.StreamProof.set, "StreamProof"),
        "Routes GUIs into the hidden CoreGui layer. To actually hide from OBS/Discord GAME capture on Volt, also enable Volt's own 'OBS Stream Proof Graphics' setting. (Full screen/monitor capture can never be hidden.)")

    saf:Section("Notifications")
    saf:Toggle("Show Notifications", function() return State.NotificationsEnabled end,
        persistent(function(v) State.NotificationsEnabled = v end, "NotificationsEnabled"),
        "Master switch for corner toast notifications.")
    saf:Toggle("Feature Toggle Toasts", function() return State.NotifToggles end,
        persistent(function(v) State.NotifToggles = v end, "NotifToggles"),
        "Show a toast whenever ANY feature is toggled on/off. Turn this off to silence the on/off spam while keeping other notifications.")
    saf:Toggle("Safety Alerts", function() return State.NotifSafety end,
        persistent(function(v) State.NotifSafety = v end, "NotifSafety"),
        "Show Moderator Checker alerts — when a known mod joins, or scan results.")

    saf:Section("Diagnostics")
    saf:Toggle("Debug Panel", function() return State.Debug end,
        persistent(F.Debug.setDebug, "Debug"),
        "Floating HUD with FPS / ping / state / last parry.")

    --========================================
    -- MISC — utility tools grouped together: Attach (Tween To Back), the
    -- Animation Visualizer, and the remote spy (Spyware).
    --========================================
    W:TabGroup("Misc")
    local misc = W:Tab("Misc", "🧰")

    misc:Section("Attach")
    misc:Toggle("Tween To Back", function() return State.TweenToBack end,
        persistent(F.Movement.setTweenToBack, "TweenToBack"),
        "Smoothly slide to a point BEHIND the nearest enemy and hold there, facing them. Noclips while moving. Bindable in Settings → Keybinds.")
    misc:Toggle("Sticky Attach", function() return State.TTBSticky end,
        persistent(function(v) State.TTBSticky = v end, "TTBSticky"),
        "Keep following the SAME target until it dies, instead of always snapping to whoever's nearest.")
    misc:Toggle("Ignore Players", function() return State.TTBIgnorePlayers end,
        persistent(function(v) State.TTBIgnorePlayers = v end, "TTBIgnorePlayers"),
        "Only attach to mobs/NPCs, never to real players.")
    misc:Slider("Max Range", 10, 500, function() return State.TTBRange end,
        persistent(function(v) State.TTBRange = v end, "TTBRange"), " studs",
        "Only attach to an enemy this close or nearer — enemies farther than this are ignored.", 300)
    misc:Slider("Distance", -100, 100, function() return State.TTBDistance end,
        persistent(function(v) State.TTBDistance = v end, "TTBDistance"), " studs",
        "How far behind the target to sit. Positive = behind them, negative = in front.", 5)
    misc:Slider("Height Offset", -100, 30, function() return State.TTBHeight end,
        persistent(function(v) State.TTBHeight = v end, "TTBHeight"), " studs",
        "Vertical offset from the target (e.g. float above or sink below).", 0)
    misc:Slider("Tween Speed", 50, 1000, function() return State.TTBSpeed end,
        persistent(function(v) State.TTBSpeed = v end, "TTBSpeed"), " st/s",
        "How fast you slide toward the attach point (studs per second).", 200)

    misc:Section("Animation")
    misc:Toggle("Animation Visualizer", function() return State.AnimViz end,
        F.AnimationVisualizer.toggle,
        "Open the visualizer/scrubber window. Use the Save button there to capture parry timing.")
    misc:Button("Open Timings Tab", function() W:JumpToTab("Timings") end,
        "Manage every parry timing (search / edit / categorise).")

    misc:Section("Capture Projectiles")
    misc:Wide(function(holder) buildProjectileCapture(holder, F) end, 330, nil)

    --========================================
    -- SPYWARE — remote spy. Logs what your client fires (and optionally what
    -- the server fires at you), in a live list. This is how the parry remote
    -- (Requests.Combat:FireServer("Block", true)) was found.
    --========================================
    misc:Section("Spyware (Remote Spy)")
    misc:Toggle("Spyware", function() return State.Spyware end,
        persistent(F.RemoteSpy.setEnabled, "Spyware"),
        "Master switch. Captures every RemoteEvent/RemoteFunction call so you can see what the game fires. Needs an executor with hookmetamethod.")
    misc:Toggle("Self (Outgoing)", function() return State.SpySelf end,
        persistent(F.RemoteSpy.setSelf, "SpySelf"),
        "Log remotes YOUR client sends to the server (FireServer / InvokeServer). Leave on — this is what reveals your own ability/parry remotes.")
    misc:Toggle("Enemies (Incoming)", function() return State.SpyEnemies end,
        persistent(F.RemoteSpy.setEnemies, "SpyEnemies"),
        "Also log remotes the SERVER fires at you (OnClientEvent) — often enemy actions/state. Connects to every RemoteEvent in ReplicatedStorage.")

    misc:Section("Spyware Controls")
    misc:Toggle("Pause Capture", function() return State.SpyPaused end,
        persistent(F.RemoteSpy.setPaused, "SpyPaused"),
        "Freeze the list so you can read it without new calls scrolling it. Turn off to resume capturing.")
    misc:Button("Clear Log", function() F.RemoteSpy.clear() end,
        "Wipe every captured remote from the list below.")

    misc:Section("Captured Remotes")
    misc:Wide(function(holder) buildSpyList(holder, F) end, 320, nil)

    --========================================
    -- PLAYER TIMING — learn parry timings by watching OTHER players parry.
    --========================================
    W:TabGroup("Capture")
    local ptm = W:Tab("Player Timing", "🎯")
    ptm:Section("Player Timing")
    ptm:Toggle("Capture My Timings", function() return State.PlayerTiming end,
        persistent(F.PlayerTiming.setEnabled, "PlayerTiming"),
        "PARRY: when YOU block a mob's attack, capture the attacker's animation + the frame you blocked at. PROJECTILE: ANY projectile that flies at you and comes within the Projectile Distance is captured by its real name (the moving part, not effect particles). Then Replace/Add below.")
    ptm:Slider("Parry Capture Range", 8, 80, function() return State.PlayerTimingRange end,
        persistent(function(v) State.PlayerTimingRange = v end, "PlayerTimingRange"), " studs",
        "For PARRY timings: only capture when the attacker is this close when you block.", 22)
    ptm:Slider("Projectile Distance", 5, 150, function() return State.PlayerTimingProjDist or 40 end,
        persistent(function(v) State.PlayerTimingProjDist = v end, "PlayerTimingProjDist"), " studs",
        "For PROJECTILES: capture a projectile once it flies within this distance. Lower = only grab ones that get close (less junk); higher = catch them earlier/farther.", 40)
    ptm:Section("Captured (Replace / Add)")
    ptm:Wide(function(holder) buildPlayerTiming(holder, F, State) end, 320, nil)

    --========================================
    -- SETTINGS — top-to-bottom flow:
    --   Appearance (theme/accent/scale)  →  Interface (HUDs)
    --   →  Keybinds  →  Profiles  →  Performance  →  Reset  →  Script
    --========================================
    local set = W:Tab("Settings", "⚙️")

    set:Section("Appearance")
    set:Dropdown("Theme", { "Purple", "Black", "Midnight", "Abyss", "Light" },
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

    set:Section("Interface")
    set:Toggle("Keybind HUD", function() return State.KeybindHud end,
        persistent(F.KeybindHud.setEnabled, "KeybindHud"),
        "Show the keybind list panel on the left. Enabled features glow green.")

    set:Section("Keybinds")
    local function kb(label, name, tip)
        set:Keybind(label, name,
            function() return Keybinds.get(name) end,
            function(k) Keybinds.set(name, k) end, tip)
    end
    kb("Toggle Menu",       "toggle_menu",       "Show/hide the menu.")
    kb("Panic Hide (all GUIs)", "panic_hide",    "Instantly hide/show EVERY script GUI — clear the screen before a screenshare.")
    kb("Keybind HUD",       "toggle_kbhud",      "Show/hide the on-screen keybind list.")
    kb("Toggle AutoParry",  "toggle_autoparry",  "Turn Perfect Block on/off.")
    kb("Toggle ESP",        "toggle_esp",        "Turn ESP on/off.")
    kb("Toggle Fly",        "toggle_fly",        "Turn Fly on/off.")
    kb("Toggle Noclip",     "toggle_noclip",     "Turn Noclip on/off.")
    kb("Toggle Sprint",     "toggle_sprint",     "Toggle held-sprint.")
    kb("Tween To Back",     "toggle_ttb",        "Toggle Tween To Back (attach behind nearest enemy).")
    kb("Toggle Visualizer", "toggle_visualizer", "Open/close the Animation Visualizer.")

    set:Section("Profiles")
    local profileName = "default"
    local function profileOptions()
        local list = Settings.listProfiles() or {}
        if #list == 0 then list = {"default"} end
        return list
    end
    set:Dropdown("Select Profile", profileOptions,
        function() return profileName end,
        function(p) profileName = p
            F.Notification.send("Profiles", "Selected '" .. p .. "'", 1.5)
        end,
        "Pick a saved profile, then press Load Profile to apply it.")
    set:TextInput("New Profile Name", "default", function(v) profileName = v end,
        "Type a name here, then Save Profile to create a new entry.")
    set:Button("Save Profile", function()
        if Settings.saveProfile(profileName) then
            F.Notification.send("Profiles", "Saved '" .. profileName .. "'", 2,
                Color3.fromRGB(80, 200, 130))
        end
    end, "Snapshot every toggle/value into the selected profile.")
    set:Button("Load Profile", function()
        if Settings.loadProfile(profileName) then
            F.Notification.send("Profiles", "Loaded '" .. profileName .. "' — Restart to apply", 3)
        else
            F.Notification.send("Profiles", "No profile '" .. profileName .. "'", 2,
                Color3.fromRGB(240, 96, 96))
        end
    end, "Apply the selected profile (Restart to fully apply).")
    set:Button("Delete Profile", function()
        Settings.deleteProfile(profileName)
        F.Notification.send("Profiles", "Deleted '" .. profileName .. "'", 2)
    end, "Remove the selected profile from disk.", true)

    set:Section("Performance")
    set:Toggle("Performance Mode", function() return State.LowGfx end, function(v)
        F.Visuals.setLowGfx(v); State.LowGfx = v; Settings.set("state__LowGfx", v)
    end, "No Fog · No Blur · No Shadows · No Animated Sea (same set deepwoken-rewrite removes).")

    set:Section("Reset")
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

-- saved[name] can be:
--   a KeyCode name string -> that key
--   false                 -> explicitly unbound (user pressed Escape)
--   nil                   -> never set, use the default
local function resolve(name, defaultKey)
    local k = saved[name]
    if k == false then return nil end                 -- explicitly cleared
    if type(k) == "string" then return Enum.KeyCode[k] end
    return defaultKey
end

function Keybinds.register(name, defaultKey, fn)
    registry[name] = { key = resolve(name, defaultKey), fn = fn, default = defaultKey }
end
function Keybinds.set(name, key)
    if not registry[name] then return end
    registry[name].key = key
    saved[name] = key and key.Name or false          -- false = persist "none"
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
__bundle_register("Features/PlayerTiming", function(require, _LOADED, __bundle_register, __bundle_modules)
-- PlayerTiming: learn YOUR parry timings by capturing them as you play.
--
-- Type Soul has no "parried" Status flag — a parry IS the block action
-- (Requests.Combat:FireServer("Block", true), the same remote AutoParry uses).
-- So we observe that remote: the moment YOU block while an enemy attack (or a
-- projectile) is nearby, we snapshot the attacker's animation id + its exact
-- TimePosition — the frame you parried at, a ready-to-use timing. The "Player
-- Timing" tab then lets you REPLACE your saved timing, ADD it as a new one, or
-- (projectiles) add the name to the Hitbox Range capture list.
--
-- Your own AutoParry blocks are ignored (Combat stamps _G.__VVBlockFired), so
-- only YOUR MANUAL parries are learned.
local Players    = game:GetService("Players")
local RS         = game:GetService("ReplicatedStorage")
local LP         = Players.LocalPlayer
local Conns      = require("Utility/Conns")
local RunService = game:GetService("RunService")

local PlayerTiming = {}
local State

PlayerTiming.captured = {}      -- newest-first list of capture entries
PlayerTiming.rev = 0            -- bumps on every change (the UI polls this)
local captured = PlayerTiming.captured
local function bump() PlayerTiming.rev = PlayerTiming.rev + 1 end

local function rootOf(c)
    return c and (c:FindFirstChild("HumanoidRootPart") or c:FindFirstChildWhichIsA("BasePart"))
end

--==================== live attack-track registry ====================
-- Every currently-playing one-shot animation on any OTHER rig, so when you block
-- we can find the attack you reacted to. Only filled while the feature is on.
local liveTracks = setmetatable({}, { __mode = "k" })   -- track -> { owner, id }
local hooked     = setmetatable({}, { __mode = "k" })
local function onTrack(owner, track)
    if not (State and State.PlayerTiming) then return end
    if not owner or owner == LP.Character or track.Looped then return end
    local anim = track.Animation
    local id = anim and ((anim.AnimationId or ""):gsub("rbxassetid://", "")) or ""
    if id == "" then return end
    liveTracks[track] = { owner = owner, id = id }
    local c; c = track.Stopped:Connect(function()
        liveTracks[track] = nil
        if c then c:Disconnect() end
    end)
    Conns.add(c)
end
local function hookAnimator(an)
    if hooked[an] then return end
    hooked[an] = true
    Conns.add(an.AnimationPlayed:Connect(function(track)
        onTrack(an:FindFirstAncestorWhichIsA("Model"), track)
    end))
end

--==================== capture helpers ====================
local AV
local function animName(id)
    AV = AV or _G.__AnimViz
    return (AV and AV.resolveName and AV.resolveName(id)) or nil
end
local function pushParry(id, ms, attacker)
    for _, e in ipairs(captured) do
        if e.kind == "parry" and e.id == id and math.abs(e.ms - ms) <= 25 then return end
    end
    table.insert(captured, 1, { kind = "parry", id = id, ms = ms,
        name = animName(id), attacker = attacker, t = os.clock() })
    while #captured > 60 do table.remove(captured) end
    bump()
end
-- The travelling part is usually named the same generic thing ("Start") for many
-- different abilities, so on its own it's confusing in the Timings list. We walk up
-- the part's ancestors to the first MEANINGFUL name (the ability/model) and show
-- that as a label next to the real part name — the Add button still adds the part
-- name, the label is just so YOU can tell which projectile it was.
local GENERIC = { Start=true, Part=true, MeshPart=true, Handle=true, Hitbox=true,
    Union=true, Mesh=true, Effect=true, Effects=true, Model=true, Debris=true,
    Bone=true, Beam=true, Attachment=true, Visuals=true, Rig=true }
local function descLabel(p)
    local node = p.Parent
    for _ = 1, 5 do
        if not node or node == workspace then break end
        local n = node.Name
        if n and n ~= "" and not GENERIC[n] then return n end
        node = node.Parent
    end
    return nil
end
local function pushProj(pname, label)
    if not pname or pname == "" then return end
    for _, e in ipairs(captured) do
        if e.kind == "proj" and e.pname == pname and e.label == label then return end
    end
    table.insert(captured, 1, { kind = "proj", pname = pname, label = label, t = os.clock() })
    while #captured > 60 do table.remove(captured) end
    bump()
end

-- Nearest OTHER rig that's mid-attack within range of me.
local function nearestAttack(myPos, range)
    local best, bd
    for track, info in pairs(liveTracks) do
        if track.IsPlaying and info.owner and info.owner ~= LP.Character and info.owner.Parent then
            local r = rootOf(info.owner)
            if r then
                local d = (r.Position - myPos).Magnitude
                if d <= range and (not bd or d < bd) then bd = d; best = { id = info.id, tp = track.TimePosition, attacker = info.owner.Name } end
            end
        end
    end
    return best
end
-- Continuous PROJECTILE capture (independent of parrying). Any part that has
-- TRAVELLED and is APPROACHING you and comes within PlayerTimingProjDist studs is
-- grabbed by NAME — so you learn the REAL projectile name (the thing flying at
-- you), not the local effect particles (which spawn ON you and never "approach").
-- The distance keeps it from grabbing everything.
local projTrack = setmetatable({}, { __mode = "k" })   -- part -> {lastPos,lastDist,moved,t0,captured}
local function trackPart(p)
    if not (State and State.PlayerTiming) then return end
    if not p:IsA("BasePart") or projTrack[p] then return end
    local me = rootOf(LP.Character); if not me then return end
    if (p.Position - me.Position).Magnitude > 200 then return end   -- ignore far cross-map effects
    projTrack[p] = { lastPos = p.Position, lastDist = math.huge, moved = 0, t0 = os.clock() }
end
local lastProjT = 0
Conns.add(RunService.Heartbeat:Connect(function()
    if not (State and State.PlayerTiming) then return end
    local now = os.clock(); if now - lastProjT < 0.06 then return end; lastProjT = now
    local me = rootOf(LP.Character); if not me then return end
    local myPos = me.Position
    local capDist = State.PlayerTimingProjDist or 40
    for p, t in pairs(projTrack) do
        if not p.Parent or (now - t.t0) > 8 then
            projTrack[p] = nil
        else
            local d = (p.Position - myPos).Magnitude
            t.moved = t.moved + (p.Position - t.lastPos).Magnitude
            local approaching = d < (t.lastDist - 0.2)
            t.lastPos = p.Position; t.lastDist = d
            -- real incoming projectile: it has TRAVELLED, is APPROACHING, and is now
            -- within the capture distance. Capture each part once.
            if not t.captured and approaching and t.moved > 8 and d <= capDist then
                t.captured = true
                pushProj(p.Name, descLabel(p))
            end
        end
    end
end))

-- The heavy parry-timing capture (does :method calls — deferred, never inside the
-- namecall hook).
local function doCapture()
    if not (State and State.PlayerTiming) then return end
    local me = rootOf(LP.Character); if not me then return end
    local range = State.PlayerTimingRange or 22
    local hit = nearestAttack(me.Position, range)
    if hit then pushParry(hit.id, math.floor(hit.tp * 1000), hit.attacker) end
end
-- Called (via the namecall hook) the instant YOU fire Block. This runs INSIDE
-- the namecall, so it must be method-call-FREE — only table indexes, os.clock
-- and a defer. Doing ANY :method() here corrupts the real Block call and stops
-- you actually blocking. So we only defer the real work to just after the block.
local function onBlock()
    if not (State and State.PlayerTiming) then return end
    if _G.__VVBlockFired and (os.clock() - _G.__VVBlockFired) < 0.08 then return end   -- skip our own AutoParry blocks
    task.defer(doCapture)
end
_G.__VVPT_onBlock = onBlock      -- the persistent hook calls the LATEST module's handler

--==================== block-remote observer (installed once) ====================
local function getCombat()
    local req = RS:FindFirstChild("Requests")
    return req and req:FindFirstChild("Combat") or nil
end
local function installHook()
    if getgenv().__VVPT_hooked then return end
    if type(getrawmetatable) ~= "function" or type(setreadonly) ~= "function"
        or type(newcclosure) ~= "function" or type(getnamecallmethod) ~= "function" then return end
    pcall(function()
        getgenv().__VVPT_hooked = true
        local mt  = getrawmetatable(game)
        local old = mt.__namecall
        setreadonly(mt, false)
        mt.__namecall = newcclosure(function(self, ...)
            -- Cheap, NO :method() before old() — only == compare + getnamecallmethod.
            -- The remote is pre-resolved into _G.__VVPT_combat (set in init).
            if getgenv().__VVPT_active and self == _G.__VVPT_combat then
                local okm, m = pcall(getnamecallmethod)
                if okm and m == "FireServer" then
                    local a1, a2 = ...
                    if a1 == "Block" and a2 == true then
                        local f = _G.__VVPT_onBlock
                        if f then pcall(f) end   -- onBlock is method-call-free + defers
                    end
                end
            end
            return old(self, ...)
        end)
        setreadonly(mt, true)
    end)
end

--==================== public API ====================
function PlayerTiming.setEnabled(on)
    State.PlayerTiming = on
    getgenv().__VVPT_active = on and true or false   -- gates the namecall observer cheaply
end
function PlayerTiming.clear()
    for i = #captured, 1, -1 do captured[i] = nil end
    bump()
end
function PlayerTiming.init(state)
    State = state
    getgenv().__VVPT_active = State.PlayerTiming and true or false
    -- Pre-resolve the Block remote OUTSIDE the namecall hook (so the hook never
    -- has to make a :method() call). Retry until it exists.
    _G.__VVPT_combat = getCombat()
    if not _G.__VVPT_combat then
        task.spawn(function()
            while not _G.__VVPT_combat do task.wait(1); _G.__VVPT_combat = getCombat() end
        end)
    end
    for _, d in ipairs(workspace:GetDescendants()) do
        if d:IsA("Animator") then hookAnimator(d) end
    end
    Conns.add(workspace.DescendantAdded:Connect(function(d)
        if d:IsA("Animator") then hookAnimator(d) end
    end))
    -- Register new Debris parts for the projectile approach-tracker (gated: when
    -- the feature is off, trackPart returns immediately).
    local dbg = workspace:FindFirstChild("Debris") or workspace
    Conns.add(dbg.DescendantAdded:Connect(trackPart))
    installHook()
end

return PlayerTiming

end)
__bundle_register("Utility/StreamProof", function(require, _LOADED, __bundle_register, __bundle_modules)
-- StreamProof: hide the script's GUIs from screen capture / OBS / recordings.
-- Mirrors deepwoken-rewrite's protectgui approach, but as a toggle: ON re-parents
-- every script ScreenGui into a hidden container (gethui()/CoreGui) and calls the
-- executor's protect-gui; OFF moves them back to PlayerGui so they show normally.
-- Works purely by ScreenGui name, so it never has to touch the GUI modules.
local Players = game:GetService("Players")
local StreamProof = {}
local State

-- Every ScreenGui this script creates.
local NAMES = {
    MyMenu = true, Notifications = true, VVDebug = true,
    KeybindHud = true, AnimVisualizer = true, StreakSplash = true,
}
local PROTECT = (syn and syn.protect_gui)
    or (type(protectgui) == "function" and protectgui)
    or function() end

local function hiddenParent()
    local ok, h = pcall(function() return gethui and gethui() end)
    if ok and h then return h end
    local ok2, cg = pcall(function() return game:GetService("CoreGui") end)
    if ok2 and cg then return cg end
    return Players.LocalPlayer:FindFirstChild("PlayerGui")
end

-- Find our ScreenGuis wherever they currently live.
local function collect()
    local out, seen, cands = {}, {}, {}
    pcall(function() if gethui then cands[#cands+1] = gethui() end end)
    pcall(function() cands[#cands+1] = game:GetService("CoreGui") end)
    local pg = Players.LocalPlayer:FindFirstChild("PlayerGui")
    if pg then cands[#cands+1] = pg end
    for _, par in ipairs(cands) do
        local ok, kids = pcall(function() return par:GetChildren() end)
        if ok then
            for _, g in ipairs(kids) do
                if not seen[g] and g:IsA("ScreenGui") and NAMES[g.Name] then
                    seen[g] = true; out[#out + 1] = g
                end
            end
        end
    end
    return out
end

function StreamProof.set(on)
    if State then State.StreamProof = on end
    local target = on and hiddenParent()
        or (Players.LocalPlayer:FindFirstChild("PlayerGui") or hiddenParent())
    for _, g in ipairs(collect()) do
        if on then pcall(PROTECT, g) end
        pcall(function() g.Parent = target end)
    end
end

-- Panic Hide: instantly disable (or re-enable) EVERY script ScreenGui. On Volt
-- the menu/billboards can't be excluded from screen capture, so this is the
-- reliable way to make the whole UI vanish in one keystroke before sharing.
-- (Drawing-based ESP is hidden separately by Volt's own OBS Stream Proof setting.)
function StreamProof.setAllVisible(v)
    for _, g in ipairs(collect()) do pcall(function() g.Enabled = v end) end
end

function StreamProof.init(state)
    State = state
    task.defer(function() StreamProof.set(State.StreamProof ~= false) end)
end

return StreamProof

end)
__bundle_register("Utility/Logo", function(require, _LOADED, __bundle_register, __bundle_modules)
-- Resolves the custom "Streak" logo to an Image content string usable by an
-- ImageLabel, or nil (callers fall back to text). Resolved once and cached.
--
-- Source priority:
--   1. getgenv().StreakLogo  -> a number (asset id) or a string ("rbxassetid://..."
--                               or a URL the executor can load).
--   2. a local file "streak_logo.png" in the executor's workspace, loaded via
--      getcustomasset / getsynasset (so you can just drop the PNG in the folder).
--   3. nil.
local Logo = {}
local cached, done = nil, false

function Logo.get()
    if done then return cached end
    done = true

    -- 1) explicit override
    local genv = (type(getgenv) == "function") and getgenv() or nil
    local id = genv and genv.StreakLogo
    if id ~= nil then
        cached = (type(id) == "number") and ("rbxassetid://" .. id) or tostring(id)
        return cached
    end

    -- 2) local workspace file via custom-asset
    local getasset = (type(getcustomasset) == "function" and getcustomasset)
        or (type(getsynasset) == "function" and getsynasset)
        or (syn and syn.getcustomasset)
    if getasset and type(isfile) == "function" then
        for _, name in ipairs({ "streak_logo.png", "streak.png", "Streak.png" }) do
            local okf = pcall(isfile, name)
            if okf and isfile(name) then
                local ok, content = pcall(getasset, name)
                if ok and content then cached = content; return cached end
            end
        end
    end

    cached = nil
    return cached
end

-- Background watermark image (the big "Streak" art). Same resolution model as
-- the logo: getgenv().StreakBackground override, else a local PNG in the
-- executor workspace loaded via custom-asset. Returns an Image string or nil.
local bgCached, bgDone = nil, false
function Logo.getBackground()
    if bgDone then return bgCached end
    bgDone = true

    local genv = (type(getgenv) == "function") and getgenv() or nil
    local id = genv and genv.StreakBackground
    if id ~= nil then
        bgCached = (type(id) == "number") and ("rbxassetid://" .. id) or tostring(id)
        return bgCached
    end

    local getasset = (type(getcustomasset) == "function" and getcustomasset)
        or (type(getsynasset) == "function" and getsynasset)
        or (syn and syn.getcustomasset)
    if getasset and type(isfile) == "function" then
        for _, name in ipairs({ "streaktp.png", "streak_bg.png", "background.png" }) do
            local okf = pcall(isfile, name)
            if okf and isfile(name) then
                local ok, content = pcall(getasset, name)
                if ok and content then bgCached = content; return bgCached end
            end
        end
    end

    bgCached = nil
    return bgCached
end

return Logo

end)
__bundle_register("GUI/Splash", function(require, _LOADED, __bundle_register, __bundle_modules)
-- Splash screen: shows the Streak logo with an animated entrance + exit, then
-- calls done() (which builds the menu). If no logo image is available it skips
-- straight to done() so nothing is delayed/blocked.
local Splash = {}
local Tween = game:GetService("TweenService")
local Logo  = require("Utility/Logo")

local QUAD = Enum.EasingStyle.Quad
local BACK = Enum.EasingStyle.Back

function Splash.show(parent, done)
    local img = Logo.get()
    if not img or not parent then
        if done then pcall(done) end
        return
    end

    local sg = Instance.new("ScreenGui")
    sg.Name = "StreakSplash"; sg.ResetOnSpawn = false
    sg.IgnoreGuiInset = true; sg.DisplayOrder = 5000; sg.Parent = parent

    -- Logo ONLY — no backdrop, so the game behind stays fully visible/unaffected.
    local logo = Instance.new("ImageLabel", sg)
    logo.AnchorPoint = Vector2.new(0.5, 0.5); logo.Position = UDim2.new(0.5, 0, 0.5, 0)
    logo.Size = UDim2.fromOffset(440, 440); logo.BackgroundTransparency = 1
    logo.Image = img; logo.ImageTransparency = 1; logo.ScaleType = Enum.ScaleType.Fit
    logo.Rotation = -10
    local scale = Instance.new("UIScale", logo); scale.Scale = 0.5

    -- FADE IN from nothing (transparency 1 -> 0) while it pops up + straightens.
    Tween:Create(logo,  TweenInfo.new(0.8,  QUAD, Enum.EasingDirection.Out), { ImageTransparency = 0, Rotation = 0 }):Play()
    Tween:Create(scale, TweenInfo.new(0.85, BACK, Enum.EasingDirection.Out), { Scale = 1.0 }):Play()

    -- HOLD, then FADE OUT -> the menu appears once the logo is fully gone.
    task.delay(3.2, function()
        Tween:Create(scale, TweenInfo.new(0.7, BACK, Enum.EasingDirection.In), { Scale = 1.35 }):Play()
        local fade = Tween:Create(logo, TweenInfo.new(0.7, QUAD, Enum.EasingDirection.In), { ImageTransparency = 1, Rotation = 8 })
        fade:Play()
        fade.Completed:Connect(function()
            pcall(function() sg:Destroy() end)
            if done then pcall(done) end
        end)
    end)
end

return Splash

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

-- Debounced save: slider drags spam Settings.set many times per frame. Writing
-- the JSON to disk every single time was a measurable hitch; instead we mark
-- the file dirty and write at most once every ~250ms (and once immediately
-- after the last edit settles).
local dirty, scheduled = false, false
local function flush()
    if not dirty then return end
    dirty = false
    pcall(function() writefile(FILE, Http:JSONEncode(data)) end)
end
local function save()
    dirty = true
    if scheduled then return end
    scheduled = true
    task.delay(0.25, function() scheduled = false; flush() end)
end

function Settings.get(key, default) return data[key] == nil and default or data[key] end
function Settings.set(key, v) data[key] = v; save() end
function Settings.all() return data end
function Settings.reset() data = {}; dirty = true; flush() end
-- Force an immediate write (used on critical exits).
function Settings.flush() flush() end

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
-- Make sure any debounced edit is flushed before the script is unloaded.
local okConns, Conns = pcall(require, "Utility/Conns")
if okConns and Conns and Conns.onTeardown then
    Conns.onTeardown(function() pcall(flush) end)
end
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
local RunService = game:GetService("RunService")
local Conns = require("Utility/Conns")

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
    -- A dodge-only entry has no .sec (no parry time), so guard against nil:
    -- fall back to its first parry time, then its first dodge time, then 0.
    local function asMs(v)
        if type(v) ~= "table" then return (v or 0) * 1000 end
        local s = v.sec or (v.times and v.times[1]) or (v.dodges and v.dodges[1]) or 0
        return s * 1000
    end
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

    -- Build / refresh list rows. Returns the row height so the caller can
    -- accumulate the scroll canvas correctly (rows now grow with #timings).
    local HEADER_H, LINE_H, PAD = 44, 30, 6
    local function buildRow(id, v, i)
        -- Collect this animation's parry timings (may be several).
        local times = (PT.getTimes and PT.getTimes(id)) or {}
        if #times == 0 then
            times = { (type(v) == "table" and v.sec) or (type(v) == "number" and v) or 0 }
        end
        local nT = #times
        local rowH = HEADER_H + nT * LINE_H + PAD

        local row = Instance.new("Frame", list)
        row.Size = UDim2.new(1, -4, 0, rowH)
        row.BackgroundColor3 = (i % 2 == 0) and C.rowAlt or C.row
        row.BorderSizePixel = 0
        row.LayoutOrder = i
        corner(row)

        local name = resolveName(id) or "—"
        local title = Instance.new("TextLabel", row)
        title.Size = UDim2.new(1, -130, 0, 18); title.Position = UDim2.new(0, 8, 0, 4)
        title.BackgroundTransparency = 1
        title.Text = name
        title.TextColor3 = C.text; title.TextSize = 13; title.Font = Enum.Font.GothamBold
        title.TextXAlignment = Enum.TextXAlignment.Left; title.TextTruncate = Enum.TextTruncate.AtEnd

        local sub = Instance.new("TextLabel", row)
        sub.Size = UDim2.new(1, -130, 0, 14); sub.Position = UDim2.new(0, 8, 0, 24)
        sub.BackgroundTransparency = 1
        sub.Text = string.format("id=%s  ·  cat=%s  ·  %d timing%s", id, asCat(v), nT, nT == 1 and "" or "s")
        sub.TextColor3 = C.dim; sub.TextSize = 11; sub.Font = Enum.Font.Code
        sub.TextXAlignment = Enum.TextXAlignment.Left; sub.TextTruncate = Enum.TextTruncate.AtEnd

        -- View (whole animation) + Delete (whole animation) on the header line.
        local previewBtn = Instance.new("TextButton", row)
        previewBtn.Size = UDim2.new(0, 56, 0, 26); previewBtn.Position = UDim2.new(1, -116, 0, 8)
        previewBtn.BackgroundColor3 = C.accent; previewBtn.BorderSizePixel = 0
        previewBtn.Text = "View"; previewBtn.TextColor3 = Color3.fromRGB(255,255,255)
        previewBtn.TextSize = 12; previewBtn.Font = Enum.Font.GothamBold
        corner(previewBtn)
        previewBtn.MouseButton1Click:Connect(function() openV(id) end)

        local delBtn = Instance.new("TextButton", row)
        delBtn.Size = UDim2.new(0, 52, 0, 26); delBtn.Position = UDim2.new(1, -56, 0, 8)
        delBtn.BackgroundColor3 = C.red; delBtn.BorderSizePixel = 0
        delBtn.Text = "Delete"; delBtn.TextColor3 = Color3.fromRGB(255,255,255)
        delBtn.TextSize = 12; delBtn.Font = Enum.Font.GothamBold
        corner(delBtn)
        delBtn.MouseButton1Click:Connect(function()
            PT.remove(id)
            notify("Timings", "removed " .. id, 1.5, C.red)
            refresh()
        end)

        -- One editable line PER timing.
        for idx, sec in ipairs(times) do
            local y = HEADER_H + (idx - 1) * LINE_H
            local lbl = Instance.new("TextLabel", row)
            lbl.Size = UDim2.new(0, 30, 0, 24); lbl.Position = UDim2.new(0, 12, 0, y)
            lbl.BackgroundTransparency = 1; lbl.Text = "#" .. idx
            lbl.TextColor3 = C.dim; lbl.TextSize = 12; lbl.Font = Enum.Font.GothamBold
            lbl.TextXAlignment = Enum.TextXAlignment.Left

            local msBox = Instance.new("TextBox", row)
            msBox.Size = UDim2.new(0, 80, 0, 24); msBox.Position = UDim2.new(0, 46, 0, y)
            msBox.BackgroundColor3 = C.bg; msBox.BorderSizePixel = 0
            msBox.Text = tostring(math.floor(sec * 1000 + 0.5))
            msBox.TextColor3 = C.accent; msBox.TextSize = 13; msBox.Font = Enum.Font.Code
            msBox.ClearTextOnFocus = false
            corner(msBox)

            local msLbl = Instance.new("TextLabel", row)
            msLbl.Size = UDim2.new(0, 22, 0, 24); msLbl.Position = UDim2.new(0, 128, 0, y)
            msLbl.BackgroundTransparency = 1; msLbl.Text = "ms"
            msLbl.TextColor3 = C.dim; msLbl.TextSize = 11; msLbl.Font = Enum.Font.Gotham
            msLbl.TextXAlignment = Enum.TextXAlignment.Left

            local thisIdx = idx
            msBox.FocusLost:Connect(function(enter)
                if not enter then return end
                local n = tonumber(msBox.Text)
                if not n then return end
                if PT.setParryAt then PT.setParryAt(id, thisIdx, n / 1000)
                else PT.set(id, n / 1000, asCat(v)) end
                notify("Timings", string.format("%s #%d = %d ms", id, thisIdx, n), 1.5, C.green)
                refresh()    -- re-sort & re-render
            end)

            -- Per-timing remove (only show the X when there is more than one,
            -- otherwise the header Delete handles the single timing).
            if nT > 1 then
                local rm = Instance.new("TextButton", row)
                rm.Size = UDim2.new(0, 24, 0, 24); rm.Position = UDim2.new(0, 158, 0, y)
                rm.BackgroundColor3 = C.red; rm.BorderSizePixel = 0
                rm.Text = "×"; rm.TextColor3 = Color3.fromRGB(255,255,255)
                rm.TextSize = 15; rm.Font = Enum.Font.GothamBold
                corner(rm)
                rm.MouseButton1Click:Connect(function()
                    if PT.removeParryAt then PT.removeParryAt(id, thisIdx) end
                    notify("Timings", string.format("removed %s #%d", id, thisIdx), 1.5, C.red)
                    refresh()
                end)
            end
        end

        return rowH
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
                        order = order + 1; canvas = canvas + buildRow(r.id, r.v, order) + 2
                        visible = visible + 1
                    end
                else
                    visible = visible + #grp
                end
            end
        else
            table.sort(rows, function(a, b) return a.ms < b.ms end)
            for _, r in ipairs(rows) do
                order = order + 1; canvas = canvas + buildRow(r.id, r.v, order) + 2
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
    -- Auto-refresh whenever timings change from ANY source (Player Timing's
    -- Replace/Add, the Animation Visualizer's Save, etc.) — PT.rev bumps on save.
    do
        local lastRev = -1
        Conns.add(RunService.Heartbeat:Connect(function()
            local r = PT.rev or 0
            if r ~= lastRev then lastRev = r; refresh() end
        end))
    end
    return { refresh = refresh }
end

return TimingsManager

end)
__bundle_register("GUI/Library", function(require, _LOADED, __bundle_register, __bundle_modules)
-- Simple, reliable window library — top tab-bar layout.
-- Public API:
--   W = Library.new(parent, title, subtitle?)
--   W:TabGroup(name)               -- no-op (kept for compatibility)
--   tab = W:Tab(name, icon)
--   tab:Section(text)
--   tab:Toggle(label,getter,setter,tooltip,defaultKey?)  -- defaultKey ignored here
--   tab:Button / Slider / TextInput / Keybind / Dropdown / Custom / Wide
--   W:JumpToTab(name)  W:SetVisible W:ToggleVisible W:OnVisibleChanged
--   W:GetScale W:SetScale  W:Confirm  W:Notify
--   Library.setTheme(name)  Library.setAccent(name)  Library.themes / accents
local UIS      = game:GetService("UserInputService")
local Tween    = game:GetService("TweenService")
local RunSvc   = game:GetService("RunService")
local Settings = require("Utility/Settings")
local MouseUnlock = require("Utility/MouseUnlock")
local Conns       = require("Utility/Conns")
local Logo        = require("Utility/Logo")

local Library = {}

--==================== THEMES ====================
local THEMES = {
    -- "Streak" look: near-black background with vivid neon-purple accents (matches the logo).
    -- `glow` = the second neon flow color (purple→glow flowing borders/particles).
    Purple = { bg=Color3.fromRGB(8,6,11), bgAlt=Color3.fromRGB(14,10,20),
        bgRow=Color3.fromRGB(23,16,34), bgHover=Color3.fromRGB(52,28,86),
        border=Color3.fromRGB(98,46,158), accent=Color3.fromRGB(198,74,255),
        accent2=Color3.fromRGB(150,48,238), good=Color3.fromRGB(120,220,150),
        warn=Color3.fromRGB(250,185,85),    bad=Color3.fromRGB(250,92,122),
        text=Color3.fromRGB(246,242,252),   textDim=Color3.fromRGB(172,150,202),
        glow=Color3.fromRGB(255,95,205) },
    Midnight = { bg=Color3.fromRGB(10,12,18), bgAlt=Color3.fromRGB(18,21,30),
        bgRow=Color3.fromRGB(28,32,44), bgHover=Color3.fromRGB(44,52,72),
        border=Color3.fromRGB(46,54,74), accent=Color3.fromRGB(96,170,255),
        accent2=Color3.fromRGB(56,130,225), good=Color3.fromRGB(90,205,140),
        warn=Color3.fromRGB(245,170,70),    bad=Color3.fromRGB(240,100,100),
        text=Color3.fromRGB(236,240,250),   textDim=Color3.fromRGB(150,160,182),
        glow=Color3.fromRGB(120,200,255) },
    Abyss = { bg=Color3.fromRGB(6,8,10), bgAlt=Color3.fromRGB(12,16,18),
        bgRow=Color3.fromRGB(20,26,30), bgHover=Color3.fromRGB(28,48,52),
        border=Color3.fromRGB(34,52,56), accent=Color3.fromRGB(70,230,200),
        accent2=Color3.fromRGB(40,180,160), good=Color3.fromRGB(110,225,160),
        warn=Color3.fromRGB(245,190,90),    bad=Color3.fromRGB(245,110,120),
        text=Color3.fromRGB(235,248,246),   textDim=Color3.fromRGB(150,178,178),
        glow=Color3.fromRGB(90,235,210) },
    -- Light: a SOFT grey (not near-white) with deep, saturated accents so text,
    -- borders and the neon flow all stay readable on a light background.
    Light = { bg=Color3.fromRGB(158,163,178), bgAlt=Color3.fromRGB(172,177,191),
        bgRow=Color3.fromRGB(148,154,170), bgHover=Color3.fromRGB(130,137,158),
        border=Color3.fromRGB(108,115,138), accent=Color3.fromRGB(92,42,168),
        accent2=Color3.fromRGB(66,30,132), good=Color3.fromRGB(28,120,72),
        warn=Color3.fromRGB(158,96,16),     bad=Color3.fromRGB(178,42,64),
        text=Color3.fromRGB(16,18,28),      textDim=Color3.fromRGB(58,64,86),
        glow=Color3.fromRGB(158,24,116) },
    -- Black: pure-black OLED background with the neon-purple accents.
    Black = { bg=Color3.fromRGB(0,0,0), bgAlt=Color3.fromRGB(10,8,14),
        bgRow=Color3.fromRGB(20,16,28), bgHover=Color3.fromRGB(46,26,74),
        border=Color3.fromRGB(80,40,130), accent=Color3.fromRGB(198,74,255),
        accent2=Color3.fromRGB(150,48,238), good=Color3.fromRGB(120,220,150),
        warn=Color3.fromRGB(250,185,85),    bad=Color3.fromRGB(250,92,122),
        text=Color3.fromRGB(245,242,250),   textDim=Color3.fromRGB(165,150,195),
        glow=Color3.fromRGB(255,95,205) },
}
local ACCENTS = {
    Purple=Color3.fromRGB(198,74,255), Blue=Color3.fromRGB(96,170,255),
    Teal=Color3.fromRGB(70,230,200),    Green=Color3.fromRGB(110,220,140),
    Pink=Color3.fromRGB(245,120,200),   Red=Color3.fromRGB(245,100,110),
    Orange=Color3.fromRGB(250,165,80),  Gold=Color3.fromRGB(245,205,90),
}
Library.themes  = THEMES
Library.accents = ACCENTS

local T = THEMES[Settings.get("theme","Purple")] or THEMES.Purple
-- Choosing an accent also tints the menu text to match it — but pushed toward
-- white on dark themes (and toward black on light themes) so it stays clearly
-- READABLE while still reading as the accent hue.
local WHITE, BLACK = Color3.new(1,1,1), Color3.new(0,0,0)
local function lum(c) return 0.299*c.R + 0.587*c.G + 0.114*c.B end
local function applyAccent(c)
    T.accent = c
    if lum(T.bg) < 0.5 then            -- dark theme → brighten accent for text
        T.text    = c:Lerp(WHITE, 0.6)
        T.textDim = c:Lerp(WHITE, 0.32)
    else                                -- light theme → darken accent for text
        T.text    = c:Lerp(BLACK, 0.5)
        T.textDim = c:Lerp(BLACK, 0.25)
    end
end
do local a=Settings.get("accent_name",nil); if a and ACCENTS[a] then applyAccent(ACCENTS[a]) end end
local registry = {}
local function reapply()
    for _, r in ipairs(registry) do
        for prop, key in pairs(r.map) do pcall(function() r.inst[prop] = T[key] end) end
    end
end
function Library.setTheme(name)
    local nt = THEMES[name]; if not nt then return end
    local accentName = Settings.get("accent_name", nil)
    T = setmetatable({}, { __index = nt })
    for k,v in pairs(nt) do T[k]=v end
    if accentName and ACCENTS[accentName] then applyAccent(ACCENTS[accentName]) end
    Settings.set("theme", name); reapply()
end
function Library.setAccent(name)
    local c = ACCENTS[name]; if not c then return end
    applyAccent(c); Settings.set("accent_name", name); reapply()
end

--==================== HELPERS ====================
local function ui(cls, props, parent)
    local i = Instance.new(cls)
    if props then for k,v in pairs(props) do i[k]=v end end
    if parent then i.Parent=parent end
    return i
end
local function corner(i,r) ui("UICorner",{CornerRadius=UDim.new(0,r or 8)},i) end
local function pad(i,l,t,rr,b)
    ui("UIPadding",{PaddingLeft=UDim.new(0,l or 0),PaddingTop=UDim.new(0,t or 0),
        PaddingRight=UDim.new(0,rr or 0),PaddingBottom=UDim.new(0,b or 0)},i)
end
local function bind(i, map) table.insert(registry,{inst=i,map=map}); return i end
local function stroke(i,key)
    local s=ui("UIStroke",{Color=T[key or "border"],Thickness=1,Transparency=0.2},i)
    bind(s,{Color=key or "border"}); return s
end
local function tw(i,t,p)
    Tween:Create(i,TweenInfo.new(t or 0.14,Enum.EasingStyle.Quad),p):Play()
end

--==================== NEON FX (purely visual) ====================
-- Animated, flowing purple↔pink gradient borders + soft bloom + floating
-- particles. None of this captures input or changes any layout — the particle
-- frames are non-Active, so clicks pass straight through to the widgets below.
local PINK = Color3.fromRGB(255,95,205)
local animGrads = {}            -- { {g=UIGradient, sp=degrees/sec}, ... }
local animDots  = {}            -- floating particle state
local menuShown = true          -- FX loops idle while the menu is hidden (saves FPS)
-- Attach a flowing 3-stop gradient (c1→c2→c1) to any stroke OR frame and have
-- it slowly rotate, giving the "light running around the edge" look.
local function flowStroke(inst, c1, c2, speed)
    local g = ui("UIGradient",{
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   c1),
            ColorSequenceKeypoint.new(0.5, c2),
            ColorSequenceKeypoint.new(1,   c1) }),
        Rotation = 0 }, inst)
    table.insert(animGrads, { g=g, sp=speed or 60 })
    return inst
end
-- Sprinkle n soft glowing dots that drift upward and twinkle.
local function spawnParticles(parent, n)
    for i=1,(n or 16) do
        local sz=math.random(2,5)
        local f=ui("Frame",{Size=UDim2.fromOffset(sz,sz),
            BackgroundColor3=(i%2==0) and T.accent or (T.glow or PINK),
            BackgroundTransparency=0.55,BorderSizePixel=0,ZIndex=5,Active=false,
            Position=UDim2.new(math.random(),0,math.random(),0),Parent=parent})
        ui("UICorner",{CornerRadius=UDim.new(1,0)},f)
        table.insert(animDots,{ f=f, sp=0.02+math.random()*0.05,
            dx=(math.random()-0.5)*0.03, base=0.45+math.random()*0.2,
            tw=1+math.random()*2, ph=math.random()*6.28 })
    end
end
-- ONE driver loop for every gradient + particle. Idles entirely while the menu
-- is hidden (zero in-game cost), and when open it's throttled to ~30 fps — the
-- flow looks identical but costs ~half a per-frame loop. Particle motion uses
-- the ACCUMULATED dt so speed is unchanged regardless of frame rate.
local FX_DT, fxAccum = 1/30, 0
Conns.add(RunSvc.RenderStepped:Connect(function(dt)
    if not menuShown then return end
    fxAccum = fxAccum + dt
    if fxAccum < FX_DT then return end
    local step = fxAccum; fxAccum = 0
    local t = tick()
    for i=1,#animGrads do animGrads[i].g.Rotation=(t*animGrads[i].sp)%360 end
    for i=1,#animDots do
        local d=animDots[i]; local p=d.f
        local y=p.Position.Y.Scale - d.sp*step
        local x=p.Position.X.Scale + d.dx*step
        if y<-0.05 then y=1.05; x=math.random() end
        if x<0 then x=1 elseif x>1 then x=0 end
        p.Position=UDim2.new(x,0,y,0)
        p.BackgroundTransparency=d.base + 0.18*math.sin(t*d.tw + d.ph)
    end
end))

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
-- Shared slider drag: this ONE InputChanged (reused from the tooltip mover) plus
-- ONE InputEnded drive EVERY slider, instead of two global connections per slider.
local _activeSlider   -- the active slider's setter fn(mouseX), or nil
Conns.add(UIS.InputChanged:Connect(function(i)
    if i.UserInputType~=Enum.UserInputType.MouseMovement then return end
    if _activeSlider then _activeSlider(i.Position.X) end
    if tip and tip.Visible then
        tip.Position=UDim2.fromOffset(i.Position.X+14,i.Position.Y+18)
    end
end))
Conns.add(UIS.InputEnded:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 then _activeSlider=nil end
end))

--==================== WINDOW ====================
function Library.new(parent, title, subtitle)
    local self = { _tabs={}, _byName={}, _active=nil, _vis={}, _getters={} }
    local window = self

    local sg = ui("ScreenGui",{Name="MyMenu",ResetOnSpawn=false,DisplayOrder=1000,
        IgnoreGuiInset=true,Parent=parent})
    self.gui = sg
    tipSetup(sg)

    local pos  = Settings.get("menu_pos",{x=120,y=90})
    local size = Settings.get("menu_size",{w=640,h=440})

    local W = ui("Frame",{Size=UDim2.fromOffset(size.w,size.h),
        Position=UDim2.fromOffset(pos.x,pos.y),BackgroundColor3=T.bg,
        BorderSizePixel=0,ClipsDescendants=true,Parent=sg})
    bind(W,{BackgroundColor3="bg"}); corner(W,12)
    -- Neon accent border — bright glowing edge with flowing purple↔pink light.
    do local ws=ui("UIStroke",{Color=Color3.new(1,1,1),Thickness=2,Transparency=0.05},W)
        flowStroke(ws, T.accent, (T.glow or PINK), 70) end
    self.window = W

    -- Neon purple bloom / drop shadow around the window.
    local sh=ui("ImageLabel",{Size=UDim2.new(1,56,1,56),Position=UDim2.fromOffset(-28,-24),
        BackgroundTransparency=1,Image="rbxassetid://6014261993",
        ImageColor3=T.accent,ImageTransparency=0.4,ZIndex=0,
        ScaleType=Enum.ScaleType.Slice,SliceCenter=Rect.new(49,49,450,450),Parent=W})
    bind(sh,{ImageColor3="accent"})
    -- Second, wider pink bloom layer for the purple+pink glow blend.
    ui("ImageLabel",{Size=UDim2.new(1,84,1,84),Position=UDim2.fromOffset(-42,-36),
        BackgroundTransparency=1,Image="rbxassetid://6014261993",
        ImageColor3=PINK,ImageTransparency=0.62,ZIndex=0,
        ScaleType=Enum.ScaleType.Slice,SliceCenter=Rect.new(49,49,450,450),Parent=W})
    -- Floating purple/pink particles drifting behind the widgets.
    spawnParticles(W, 16)

    local uiScale = ui("UIScale",{Scale=Settings.get("ui_scale",1.0)},W)
    function self:SetScale(s) s=math.clamp(s,0.6,1.6); uiScale.Scale=s; Settings.set("ui_scale",s) end
    function self:GetScale() return uiScale.Scale end

    --======== HEADER ========
    local header = ui("Frame",{Size=UDim2.new(1,0,0,44),BackgroundColor3=T.bgAlt,
        BorderSizePixel=0,ZIndex=2,Parent=W})
    bind(header,{BackgroundColor3="bgAlt"})
    local strip = ui("Frame",{Size=UDim2.new(1,0,0,2),Position=UDim2.new(0,0,1,-2),
        BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,ZIndex=3,Parent=header})
    flowStroke(strip, T.accent, (T.glow or PINK), 90)

    -- Top-left logo: the Streak image if available, otherwise the title text.
    local logoImg = Logo.get()
    local logo
    if logoImg then
        logo = ui("ImageLabel",{Size=UDim2.fromOffset(150,40),Position=UDim2.fromOffset(10,2),
            BackgroundTransparency=1,Image=logoImg,ScaleType=Enum.ScaleType.Fit,
            ZIndex=3,Parent=header})
    else
        logo = ui("TextLabel",{Size=UDim2.fromOffset(180,22),Position=UDim2.fromOffset(16,5),
            BackgroundTransparency=1,Text=title or "Menu",TextColor3=Color3.fromRGB(255,255,255),
            TextSize=17,Font=Enum.Font.GothamBlack,
            TextXAlignment=Enum.TextXAlignment.Left,ZIndex=3,Parent=header})
    end
    if subtitle and subtitle ~= "" and not logoImg then
        local sub = ui("TextLabel",{Size=UDim2.fromOffset(180,14),Position=UDim2.fromOffset(16,24),
            BackgroundTransparency=1,Text=subtitle,TextColor3=T.textDim,
            TextSize=10,Font=Enum.Font.GothamBold,
            TextXAlignment=Enum.TextXAlignment.Left,ZIndex=3,Parent=header})
        bind(sub,{TextColor3="textDim"})
    end

    -- search
    local searchHolder = ui("Frame",{Size=UDim2.fromOffset(230,26),Position=UDim2.new(0.5,-115,0,9),
        BackgroundColor3=T.bg,BorderSizePixel=0,ZIndex=3,Parent=header})
    bind(searchHolder,{BackgroundColor3="bg"}); corner(searchHolder,6); flowStroke(stroke(searchHolder), T.accent, (T.glow or PINK), 55)
    ui("TextLabel",{Size=UDim2.fromOffset(24,26),BackgroundTransparency=1,Text="S",
        TextColor3=T.textDim,TextSize=12,Font=Enum.Font.GothamBold,ZIndex=4,Parent=searchHolder})
    local searchBox = ui("TextBox",{Size=UDim2.new(1,-30,1,0),Position=UDim2.fromOffset(28,0),
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
    winBtn("-",-72,nil,function() self:ToggleMinimize() end,"Minimize")
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
    bind(content,{BackgroundColor3="bgAlt"}); corner(content,10); content.ClipsDescendants=true
    -- Thin glowing flowing outline on the content panel.
    do local cs=ui("UIStroke",{Color=Color3.new(1,1,1),Thickness=1,Transparency=0.1},content)
        flowStroke(cs, T.accent, (T.glow or PINK), 45) end
    -- Streak watermark background — faded, centered, sitting behind every panel.
    -- ZIndex 1 (not 0) so it draws ABOVE the content panel's own dark fill even
    -- under Global ZIndexBehavior; the transparent pages/translucent panels on
    -- top still render over it (created later at the same ZIndex).
    do local bgImg=Logo.getBackground()
        if bgImg then
            ui("ImageLabel",{Size=UDim2.fromScale(0.95,0.95),Position=UDim2.fromScale(0.5,0.52),
                AnchorPoint=Vector2.new(0.5,0.5),BackgroundTransparency=1,Image=bgImg,
                ImageTransparency=0.55,ScaleType=Enum.ScaleType.Fit,ZIndex=1,
                Active=false,Parent=content})
        end
    end

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

    --======== RESIZE (3 corners: bottom-right, bottom-left, top-left) ========
    local MINW, MAXW, MINH, MAXH = 460, 1600, 300, 1100
    local rz   -- shared active-drag state across all handles + the global move listener
    -- corner = which corner the handle is on; dirX/dirY = which way size grows
    -- relative to mouse delta; moveX/moveY = whether the window's top-left moves.
    local function makeHandle(corner, anchorPos, dirX, dirY, moveX, moveY, glyph, glyphPos)
        local h = ui("TextButton",{Size=UDim2.fromOffset(18,18),Position=anchorPos,
            BackgroundTransparency=1,Text=glyph or "",TextColor3=T.textDim,TextSize=12,
            Font=Enum.Font.GothamBold,AutoButtonColor=false,ZIndex=6,Parent=W})
        if glyph then bind(h,{TextColor3="textDim"}) end
        Conns.add(h.InputBegan:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseButton1 then
                rz = { mx=i.Position.X, my=i.Position.Y,
                       w=W.AbsoluteSize.X, h=W.AbsoluteSize.Y,
                       x=W.Position.X.Offset, y=W.Position.Y.Offset,
                       dirX=dirX, dirY=dirY, moveX=moveX, moveY=moveY }
            end
        end))
        return h
    end
    -- bottom-right (visible grip), bottom-left, top-left
    local grip = makeHandle("BR", UDim2.new(1,-20,1,-20),  1,  1, false, false, "//")
    makeHandle("BL", UDim2.new(0,2,1,-20),   -1,  1, true,  false)
    makeHandle("TL", UDim2.fromOffset(0,0),   -1, -1, true,  true)
    Conns.add(UIS.InputChanged:Connect(function(i)
        if not rz or i.UserInputType~=Enum.UserInputType.MouseMovement then return end
        local dx = (i.Position.X - rz.mx) * rz.dirX
        local dy = (i.Position.Y - rz.my) * rz.dirY
        local newW = math.clamp(rz.w + dx, MINW, MAXW)
        local newH = math.clamp(rz.h + dy, MINH, MAXH)
        local newX = rz.moveX and (rz.x + (rz.w - newW)) or rz.x
        local newY = rz.moveY and (rz.y + (rz.h - newH)) or rz.y
        W.Size     = UDim2.fromOffset(newW, newH)
        W.Position = UDim2.fromOffset(newX, newY)
    end))
    Conns.add(UIS.InputEnded:Connect(function(i)
        if rz and i.UserInputType==Enum.UserInputType.MouseButton1 then
            Settings.set("menu_size",{w=W.AbsoluteSize.X,h=W.AbsoluteSize.Y})
            Settings.set("menu_pos",{x=W.Position.X.Offset,y=W.Position.Y.Offset})
            rz=nil
        end
    end))

    --======== DRAG ========
    do local d,ds,sp
        Conns.add(header.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then
            d=true; ds=i.Position; sp=W.Position end end))
        Conns.add(UIS.InputChanged:Connect(function(i) if d and i.UserInputType==Enum.UserInputType.MouseMovement then
            local dl=i.Position-ds; W.Position=UDim2.fromOffset(sp.X.Offset+dl.X,sp.Y.Offset+dl.Y) end end))
        Conns.add(UIS.InputEnded:Connect(function(i) if d and i.UserInputType==Enum.UserInputType.MouseButton1 then
            d=false; Settings.set("menu_pos",{x=W.Position.X.Offset,y=W.Position.Y.Offset}) end end))
    end

    --======== VISIBILITY ========
    self._visible=Settings.get("menu_visible",true); W.Visible=self._visible
    menuShown=self._visible                          -- match saved visibility
    self._min=false
    MouseUnlock.setSource("menu", self._visible)
    function self:SetVisible(v) self._visible=v; W.Visible=v; Settings.set("menu_visible",v)
        menuShown=v                                  -- pause/resume neon FX loops
        MouseUnlock.setSource("menu", v)
        for _,fn in ipairs(self._vis) do pcall(fn,v) end end
    function self:ToggleVisible() self:SetVisible(not self._visible) end
    function self:OnVisibleChanged(fn) table.insert(self._vis,fn) end
    function self:ToggleMinimize()
        self._min=not self._min
        content.Visible=not self._min; footer.Visible=not self._min
        tabBar.Visible=not self._min; grip.Visible=not self._min
        W.Size=self._min and UDim2.fromOffset(W.AbsoluteSize.X,44)
            or UDim2.fromOffset(Settings.get("menu_size",{w=640}).w,Settings.get("menu_size",{h=440}).h)
    end

    --======== FOOTER STATUS ========
    local fps,fr,ft=60,0,tick()
    local lastFooter=0
    Conns.add(RunSvc.Heartbeat:Connect(function()
        fr=fr+1
        local now=tick()
        if now-ft>=0.5 then fps=fr/(now-ft); fr,ft=0,now end
        if not self._visible then return end
        if now-lastFooter<0.5 then return end
        lastFooter=now
        local n=0; for _,g in ipairs(self._getters) do if g() then n=n+1 end end
        fL.Text=("%d active"):format(n)
        fR.Text=("FPS %d   %s"):format(math.floor(fps), self._active and self._active.name or "")
    end))

    --======== SEARCH ========
    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local q=searchBox.Text:lower()
        for _,t in ipairs(self._tabs) do
            for _,r in ipairs(t._rows) do
                if r.frame then r.frame.Visible=(q=="" or r.label:lower():find(q,1,true)~=nil) end
            end
            -- A groupbox shows only if the query is empty or one of its rows matches.
            if t._groups then for _,inner in ipairs(t._groups) do
                local show=(q=="")
                if not show then for _,c in ipairs(inner:GetChildren()) do
                    if c:IsA("Frame") and c.Visible then show=true; break end
                end end
                if inner.Parent then inner.Parent.Visible=show end
            end end
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

    --======== TAB GROUP (no-op for compatibility) ========
    function self:TabGroup(_) end

    --======== TAB ========
    function self:Tab(name, icon)
        local tab={name=name,_rows={},_sections={},_groups={}}
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
            ScrollBarImageColor3=T.accent,CanvasSize=UDim2.new(0,0,0,0),
            AutomaticCanvasSize=Enum.AutomaticSize.Y,Visible=false,Parent=content})
        bind(page,{ScrollBarImageColor3="accent"})
        ui("UIListLayout",{Padding=UDim.new(0,8),SortOrder=Enum.SortOrder.LayoutOrder},page)
        ui("UIPadding",{PaddingBottom=UDim.new(0,8)},page)
        tab.page=page
        function tab:_resize() end   -- AutomaticCanvasSize handles the canvas now

        -- Two-column GROUPBOX layout. :Section opens a titled, bordered box that
        -- flows into the shorter of two columns; widgets after it land inside that
        -- box. :Wide / :Custom span the full width and start a fresh column pair.
        local colsHolder, colL, colR, colHL, colHR
        local curContent, pendingTitle, ord = nil, nil, 0
        local function newCols()
            ord = ord + 1
            colsHolder=ui("Frame",{Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,
                BackgroundTransparency=1,LayoutOrder=ord,Parent=page})
            local function col(x)
                local c=ui("Frame",{Size=UDim2.new(0.5,-5,0,0),Position=UDim2.new(x,x==0 and 0 or 5,0,0),
                    AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,Parent=colsHolder})
                ui("UIListLayout",{Padding=UDim.new(0,8),SortOrder=Enum.SortOrder.LayoutOrder},c)
                return c
            end
            colL=col(0); colR=col(0.5); colHL=0; colHR=0
        end
        local function groupbox(title)
            if not colsHolder then newCols() end
            local left = colHL <= colHR
            if left then colHL=colHL+40 else colHR=colHR+40 end
            local gb=ui("Frame",{Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,
                BackgroundColor3=T.bgAlt,BackgroundTransparency=0.3,BorderSizePixel=0,Parent=left and colL or colR})
            corner(gb,8); bind(gb,{BackgroundColor3="bgAlt"})
            local st=ui("UIStroke",{Color=Color3.new(1,1,1),Thickness=1,Transparency=0.28},gb)
            flowStroke(st, T.accent, (T.glow or PINK), 36)
            ui("UIListLayout",{Padding=UDim.new(0,4),SortOrder=Enum.SortOrder.LayoutOrder},gb)
            ui("UIPadding",{PaddingTop=UDim.new(0,8),PaddingBottom=UDim.new(0,10),
                PaddingLeft=UDim.new(0,8),PaddingRight=UDim.new(0,8)},gb)
            local lbl=ui("TextLabel",{Size=UDim2.new(1,0,0,16),BackgroundTransparency=1,Text=(title or ""):upper(),
                TextColor3=T.accent,TextSize=11,Font=Enum.Font.GothamBold,
                TextXAlignment=Enum.TextXAlignment.Left,LayoutOrder=0,Parent=gb}); bind(lbl,{TextColor3="accent"})
            local inner=ui("Frame",{Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,
                BackgroundTransparency=1,LayoutOrder=1,Parent=gb})
            ui("UIListLayout",{Padding=UDim.new(0,4),SortOrder=Enum.SortOrder.LayoutOrder},inner)
            curContent=inner; table.insert(tab._groups,inner)
        end
        local function row(h)
            if not curContent then groupbox(pendingTitle or tab.name); pendingTitle=nil end
            return ui("Frame",{Size=UDim2.new(1,0,0,h),BackgroundTransparency=1,Parent=curContent})
        end

        function tab:Section(text)
            pendingTitle=text; curContent=nil   -- next widget opens a box titled this
        end

        function tab:Toggle(label,getter,setter,tooltip)
            local f=row(30); f.BackgroundColor3=T.bgRow; corner(f,7); bind(f,{BackgroundColor3="bgRow"})
            -- Whole-row click target (easier to hit than the small switch).
            local hit=ui("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,
                Text="",AutoButtonColor=false,ZIndex=2,Parent=f})
            local l=ui("TextLabel",{Size=UDim2.new(1,-58,1,0),Position=UDim2.fromOffset(12,0),
                BackgroundTransparency=1,Text=label,TextColor3=T.text,TextSize=13,Font=Enum.Font.Gotham,
                TextXAlignment=Enum.TextXAlignment.Left,ZIndex=3,Parent=f}); bind(l,{TextColor3="text"})
            local sw=ui("Frame",{Size=UDim2.fromOffset(38,20),Position=UDim2.new(1,-46,0.5,-10),
                BackgroundColor3=getter() and T.accent or T.bg,BorderSizePixel=0,ZIndex=3,Parent=f})
            corner(sw,10)
            local kn=ui("Frame",{Size=UDim2.fromOffset(14,14),
                Position=getter() and UDim2.fromOffset(21,3) or UDim2.fromOffset(3,3),
                BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,ZIndex=4,Parent=sw}); corner(kn,7)
            local function flip()
                local v=not getter(); setter(v)
                tw(sw,0.14,{BackgroundColor3=v and T.accent or T.bg})
                tw(kn,0.14,{Position=v and UDim2.fromOffset(21,3) or UDim2.fromOffset(3,3)})
                if _G.__Notify then _G.__Notify(label, v and "ON" or "OFF", 1.2,
                    v and Color3.fromRGB(60,200,120) or Color3.fromRGB(160,160,160), "Toggle") end
            end
            hit.MouseButton1Click:Connect(flip)
            hit.MouseEnter:Connect(function() tw(f,0.1,{BackgroundColor3=T.bgHover}) end)
            hit.MouseLeave:Connect(function() tw(f,0.1,{BackgroundColor3=T.bgRow}) end)
            tipFor(f,tooltip); table.insert(self._rows,{frame=f,label=label})
            if getter then table.insert(window._getters,getter) end
            self:_resize()
        end

        function tab:Button(label,fn,tooltip,danger)
            local f=row(30)
            local b=ui("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundColor3=danger and T.bad or T.bgRow,
                BorderSizePixel=0,AutoButtonColor=false,Text=label,TextColor3=Color3.new(1,1,1),TextSize=13,
                Font=Enum.Font.GothamBold,Parent=f}); corner(b,7)
            if not danger then bind(b,{BackgroundColor3="bgRow"}) end
            local base=danger and T.bad or T.bgRow
            b.MouseEnter:Connect(function() tw(b,0.1,{BackgroundColor3=danger and Color3.fromRGB(255,125,140) or T.accent2}) end)
            b.MouseLeave:Connect(function() tw(b,0.1,{BackgroundColor3=base}) end)
            b.MouseButton1Click:Connect(function()
                if danger then window:Confirm("Run "..label.."?",fn) else fn() end end)
            tipFor(f,tooltip); table.insert(self._rows,{frame=f,label=label}); self:_resize()
        end

        function tab:Slider(label,min,max,getter,setter,suffix,tooltip,default)
            local f=row(44); f.BackgroundColor3=T.bgRow; corner(f,7); bind(f,{BackgroundColor3="bgRow"})
            local l=ui("TextLabel",{Size=UDim2.new(1,-110,0,16),Position=UDim2.fromOffset(12,4),
                BackgroundTransparency=1,Text=label,TextColor3=T.text,TextSize=12,Font=Enum.Font.Gotham,
                TextXAlignment=Enum.TextXAlignment.Left,Parent=f}); bind(l,{TextColor3="text"})
            local box=ui("TextBox",{Size=UDim2.fromOffset(56,18),Position=UDim2.new(1,-(default~=nil and 86 or 62),0,4),
                BackgroundColor3=T.bg,BorderSizePixel=0,Text=tostring(getter()),TextColor3=T.accent,
                TextSize=12,Font=Enum.Font.Code,ClearTextOnFocus=false,Parent=f}); corner(box,4)
            bind(box,{BackgroundColor3="bg"})
            local bar=ui("Frame",{Size=UDim2.new(1,-24,0,6),Position=UDim2.fromOffset(12,30),
                BackgroundColor3=T.bg,BorderSizePixel=0,Parent=f}); corner(bar,3); bind(bar,{BackgroundColor3="bg"})
            local fill=ui("Frame",{Size=UDim2.new((getter()-min)/(max-min),0,1,0),
                BackgroundColor3=T.accent,BorderSizePixel=0,Parent=bar}); corner(fill,3); bind(fill,{BackgroundColor3="accent"})
            -- Draggable circle knob sitting at the end of the fill (grab to slide).
            local knob=ui("Frame",{Size=UDim2.fromOffset(13,13),AnchorPoint=Vector2.new(0.5,0.5),
                Position=UDim2.new(1,0,0.5,0),BackgroundColor3=Color3.new(1,1,1),
                BorderSizePixel=0,ZIndex=4,Parent=fill})
            ui("UICorner",{CornerRadius=UDim.new(1,0)},knob)
            local kstroke=ui("UIStroke",{Color=T.accent2,Thickness=2},knob); bind(kstroke,{Color="accent2"})
            if default~=nil then
                local rb=ui("TextButton",{Size=UDim2.fromOffset(20,18),Position=UDim2.new(1,-24,0,4),
                    BackgroundColor3=T.bgHover,BorderSizePixel=0,Text="R",TextColor3=T.textDim,
                    TextSize=11,Font=Enum.Font.GothamBold,Parent=f}); corner(rb,4)
                rb.MouseButton1Click:Connect(function() setter(default); box.Text=tostring(default)
                    fill.Size=UDim2.new((default-min)/(max-min),0,1,0) end)
                tipFor(rb,"Reset to default")
            end
            local function setv(v,fromBar)
                v=math.clamp(v,min,max); setter(v); box.Text=tostring(v)
                if fromBar then fill.Size=UDim2.new((v-min)/(max-min),0,1,0)
                else tw(fill,0.05,{Size=UDim2.new((v-min)/(max-min),0,1,0)}) end
            end
            -- Drag is driven by the shared window-level InputChanged/InputEnded
            -- (one pair for all sliders); pressing the bar or knob just registers
            -- this slider as active.
            local function dragTo(px)
                setv(math.floor(min+(max-min)*math.clamp((px-bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1)+0.5),true)
            end
            bar.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then
                _activeSlider=dragTo; dragTo(i.Position.X) end end)
            knob.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then
                _activeSlider=dragTo end end)
            box.FocusLost:Connect(function(e) if not e then return end
                local n=tonumber(box.Text); if n then setv(n) else box.Text=tostring(getter()) end end)
            tipFor(f,tooltip); table.insert(self._rows,{frame=f,label=label}); self:_resize()
        end

        function tab:TextInput(label,default,onSubmit,tooltip)
            local f=row(30); f.BackgroundColor3=T.bgRow; corner(f,7); bind(f,{BackgroundColor3="bgRow"})
            ui("TextLabel",{Size=UDim2.new(0,104,1,0),Position=UDim2.fromOffset(12,0),BackgroundTransparency=1,
                Text=label,TextColor3=T.text,TextSize=12,Font=Enum.Font.Gotham,
                TextXAlignment=Enum.TextXAlignment.Left,Parent=f})
            local inp=ui("TextBox",{Size=UDim2.new(1,-124,0,22),Position=UDim2.new(0,116,0.5,-11),
                BackgroundColor3=T.bg,BorderSizePixel=0,Text=default or "",TextColor3=T.text,TextSize=12,
                Font=Enum.Font.Code,ClearTextOnFocus=false,Parent=f}); corner(inp,4); pad(inp,6); bind(inp,{BackgroundColor3="bg"})
            -- Commit on ANY focus loss (Enter OR clicking away), and also on
            -- every keystroke, so the value is current the instant a button is
            -- clicked — previously it only committed on Enter.
            if onSubmit then
                inp.FocusLost:Connect(function() onSubmit(inp.Text) end)
                inp:GetPropertyChangedSignal("Text"):Connect(function() onSubmit(inp.Text) end)
            end
            tipFor(f,tooltip); table.insert(self._rows,{frame=f,label=label}); self:_resize()
        end

        function tab:Keybind(label,kname,getter,setter,tooltip)
            local f=row(30); f.BackgroundColor3=T.bgRow; corner(f,7); bind(f,{BackgroundColor3="bgRow"})
            ui("TextLabel",{Size=UDim2.new(1,-164,1,0),Position=UDim2.fromOffset(12,0),BackgroundTransparency=1,
                Text=label,TextColor3=T.text,TextSize=13,Font=Enum.Font.Gotham,
                TextXAlignment=Enum.TextXAlignment.Left,Parent=f})
            -- key display / rebind button
            local b=ui("TextButton",{Size=UDim2.fromOffset(92,22),Position=UDim2.new(1,-100,0.5,-11),
                BackgroundColor3=T.bg,BorderSizePixel=0,Text=(getter() and getter().Name) or "-",
                TextColor3=T.accent,TextSize=12,Font=Enum.Font.GothamBold,AutoButtonColor=false,Parent=f})
            corner(b,4); bind(b,{BackgroundColor3="bg"})
            -- small Unbind button to the left of the key button
            local ub=ui("TextButton",{Size=UDim2.fromOffset(50,22),Position=UDim2.new(1,-154,0.5,-11),
                BackgroundColor3=T.bgHover,BorderSizePixel=0,Text="Unbind",
                TextColor3=T.textDim,TextSize=11,Font=Enum.Font.GothamBold,
                AutoButtonColor=false,Parent=f})
            corner(ub,4); bind(ub,{BackgroundColor3="bgHover"})
            ub.MouseEnter:Connect(function() tw(ub,0.1,{BackgroundColor3=T.bad}) end)
            ub.MouseLeave:Connect(function() tw(ub,0.1,{BackgroundColor3=T.bgHover}) end)
            ub.MouseButton1Click:Connect(function()
                setter(nil); b.Text="-"; b.TextColor3=T.accent
            end)
            local listening
            b.MouseButton1Click:Connect(function() if listening then return end listening=true
                b.Text="press..."; b.TextColor3=T.warn
                local c; c=UIS.InputBegan:Connect(function(input,gpe)
                    if gpe then return end
                    if input.UserInputType==Enum.UserInputType.Keyboard then
                        if input.KeyCode==Enum.KeyCode.Escape then
                            setter(nil); b.Text="-"; b.TextColor3=T.accent
                        else
                            setter(input.KeyCode); b.Text=input.KeyCode.Name; b.TextColor3=T.accent
                        end
                        listening=false; if c then c:Disconnect() end end end)
            end)
            tipFor(f,tooltip); table.insert(self._rows,{frame=f,label=label}); self:_resize()
        end

        -- KeyPicker(label, getKeyName, setKeyName, tooltip)
        -- Looks/behaves like a Keybind row (press a key, Unbind button, Escape
        -- clears) but it does NOT register a global hotkey — it just stores the
        -- chosen key NAME (a string) via setKeyName. Used for e.g. the dodge key.
        function tab:KeyPicker(label, getKeyName, setKeyName, tooltip)
            local f=row(30); f.BackgroundColor3=T.bgRow; corner(f,7); bind(f,{BackgroundColor3="bgRow"})
            ui("TextLabel",{Size=UDim2.new(1,-164,1,0),Position=UDim2.fromOffset(12,0),BackgroundTransparency=1,
                Text=label,TextColor3=T.text,TextSize=13,Font=Enum.Font.Gotham,
                TextXAlignment=Enum.TextXAlignment.Left,Parent=f})
            local function disp() local n=getKeyName(); return (n and n~="" and n) or "-" end
            local b=ui("TextButton",{Size=UDim2.fromOffset(92,22),Position=UDim2.new(1,-100,0.5,-11),
                BackgroundColor3=T.bg,BorderSizePixel=0,Text=disp(),
                TextColor3=T.accent,TextSize=12,Font=Enum.Font.GothamBold,AutoButtonColor=false,Parent=f})
            corner(b,4); bind(b,{BackgroundColor3="bg"})
            local ub=ui("TextButton",{Size=UDim2.fromOffset(50,22),Position=UDim2.new(1,-154,0.5,-11),
                BackgroundColor3=T.bgHover,BorderSizePixel=0,Text="Unbind",
                TextColor3=T.textDim,TextSize=11,Font=Enum.Font.GothamBold,
                AutoButtonColor=false,Parent=f})
            corner(ub,4); bind(ub,{BackgroundColor3="bgHover"})
            ub.MouseEnter:Connect(function() tw(ub,0.1,{BackgroundColor3=T.bad}) end)
            ub.MouseLeave:Connect(function() tw(ub,0.1,{BackgroundColor3=T.bgHover}) end)
            ub.MouseButton1Click:Connect(function()
                setKeyName(nil); b.Text="-"; b.TextColor3=T.accent
            end)
            local listening
            b.MouseButton1Click:Connect(function() if listening then return end listening=true
                b.Text="press..."; b.TextColor3=T.warn
                local c; c=UIS.InputBegan:Connect(function(input,gpe)
                    if gpe then return end
                    if input.UserInputType==Enum.UserInputType.Keyboard then
                        if input.KeyCode==Enum.KeyCode.Escape then
                            setKeyName(nil); b.Text="-"
                        else
                            setKeyName(input.KeyCode.Name); b.Text=input.KeyCode.Name
                        end
                        b.TextColor3=T.accent
                        listening=false; if c then c:Disconnect() end end end)
            end)
            tipFor(f,tooltip); table.insert(self._rows,{frame=f,label=label}); self:_resize()
        end

        -- Dropdown. `options` may be a table OR a function returning a table
        -- (functions are re-read each time the menu opens, so dynamic lists
        -- like saved profiles stay current).
        function tab:Dropdown(label,options,getter,setter,tooltip)
            local f=row(30); f.BackgroundColor3=T.bgRow; corner(f,7); bind(f,{BackgroundColor3="bgRow"})
            ui("TextLabel",{Size=UDim2.new(1,-136,1,0),Position=UDim2.fromOffset(12,0),BackgroundTransparency=1,
                Text=label,TextColor3=T.text,TextSize=13,Font=Enum.Font.Gotham,
                TextXAlignment=Enum.TextXAlignment.Left,Parent=f})
            local b=ui("TextButton",{Size=UDim2.fromOffset(118,22),Position=UDim2.new(1,-126,0.5,-11),
                BackgroundColor3=T.bg,BorderSizePixel=0,Text=(getter() or "").."  v",TextColor3=T.accent,
                TextSize=12,Font=Enum.Font.GothamBold,AutoButtonColor=false,Parent=f}); corner(b,4); bind(b,{BackgroundColor3="bg"})
            local open=ui("Frame",{Size=UDim2.fromOffset(118,0),Position=UDim2.fromOffset(0,26),
                BackgroundColor3=T.bg,BorderSizePixel=0,Visible=false,ZIndex=60,
                ClipsDescendants=true,Parent=b}); corner(open,4); stroke(open)
            local function getOpts()
                local o = type(options)=="function" and options() or options
                return o or {}
            end
            local function rebuild()
                for _,c in ipairs(open:GetChildren()) do
                    if c:IsA("TextButton") then c:Destroy() end
                end
                local opts = getOpts()
                open.Size = UDim2.fromOffset(120, #opts*24)
                for i,opt in ipairs(opts) do
                    local o=ui("TextButton",{Size=UDim2.new(1,0,0,24),Position=UDim2.fromOffset(0,(i-1)*24),
                        BackgroundColor3=T.bg,BorderSizePixel=0,Text=opt,TextColor3=T.text,TextSize=12,
                        Font=Enum.Font.Gotham,AutoButtonColor=false,ZIndex=61,Parent=open})
                    o.MouseEnter:Connect(function() o.BackgroundColor3=T.bgHover end)
                    o.MouseLeave:Connect(function() o.BackgroundColor3=T.bg end)
                    o.MouseButton1Click:Connect(function() setter(opt); b.Text=opt.."  v"; open.Visible=false end)
                end
            end
            b.MouseButton1Click:Connect(function()
                if open.Visible then open.Visible=false
                else rebuild(); open.Visible=true end
            end)
            -- Keep the button text in sync with the live getter.
            tab._dropdownSyncs = tab._dropdownSyncs or {}
            table.insert(tab._dropdownSyncs, function() b.Text=(getter() or "").."  v" end)
            tipFor(f,tooltip); table.insert(self._rows,{frame=f,label=label}); self:_resize()
        end

        function tab:Custom(builder,h)
            colsHolder=nil; curContent=nil; ord=ord+1     -- full width: break the columns
            h=h or 200
            local box=ui("Frame",{Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,
                BackgroundColor3=T.bgAlt,BackgroundTransparency=0.3,BorderSizePixel=0,LayoutOrder=ord,Parent=page})
            corner(box,8); bind(box,{BackgroundColor3="bgAlt"})
            local st=ui("UIStroke",{Color=Color3.new(1,1,1),Thickness=1,Transparency=0.28},box)
            flowStroke(st, T.accent, (T.glow or PINK), 36)
            ui("UIListLayout",{Padding=UDim.new(0,6),SortOrder=Enum.SortOrder.LayoutOrder},box)
            ui("UIPadding",{PaddingTop=UDim.new(0,8),PaddingBottom=UDim.new(0,8),
                PaddingLeft=UDim.new(0,8),PaddingRight=UDim.new(0,8)},box)
            if pendingTitle then
                local lbl=ui("TextLabel",{Size=UDim2.new(1,0,0,16),BackgroundTransparency=1,Text=pendingTitle:upper(),
                    TextColor3=T.accent,TextSize=11,Font=Enum.Font.GothamBold,
                    TextXAlignment=Enum.TextXAlignment.Left,LayoutOrder=0,Parent=box}); bind(lbl,{TextColor3="accent"})
                pendingTitle=nil
            end
            local holder=ui("Frame",{Size=UDim2.new(1,0,0,h),BackgroundTransparency=1,LayoutOrder=1,Parent=box})
            builder(holder)
            colsHolder=nil; curContent=nil
        end
        function tab:Wide(builder,h,_) self:Custom(builder, h or 360) end

        local function activate()
            for _,t in ipairs(self._tabs) do
                local sel=t==tab
                t.page.Visible=sel
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
    -- Compatibility no-ops for the removed 3-column panel.
    function self:SetFeatureInfo() end

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
    Conns.add(panel.InputBegan:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 then drag=true; ds=inp.Position; sp=panel.Position end
    end))
    Conns.add(UIS.InputChanged:Connect(function(inp)
        if drag and inp.UserInputType==Enum.UserInputType.MouseMovement then
            local d=inp.Position-ds
            panel.Position=UDim2.fromOffset(sp.X.Offset+d.X, sp.Y.Offset+d.Y)
        end
    end))
    Conns.add(UIS.InputEnded:Connect(function(inp)
        if drag and inp.UserInputType==Enum.UserInputType.MouseButton1 then
            drag=false
            Settings.set("kbhud_pos", { x=panel.Position.X.Offset, y=panel.Position.Y.Offset })
        end
    end))

    -- refresh loop (3Hz): only writes properties when a row actually changes,
    -- so an idle HUD does no property churn.
    local last = 0
    Conns.add(RunService.Heartbeat:Connect(function()
        if not gui or not gui.Enabled then return end
        local now = tick()
        if now-last < 0.3 then return end
        last = now
        for kbName, r in pairs(rowByKb) do
            local k = Keybinds.get(kbName)
            local keyText = k and k.Name or "-"
            if r._lastKey ~= keyText then r._lastKey = keyText; r.key.Text = keyText end
            local enabled = (r.stateKey and State[r.stateKey]) and true or false
            if r._lastOn ~= enabled then
                r._lastOn = enabled
                if enabled then
                    r.row.BackgroundColor3  = C.onBg
                    r.name.TextColor3 = C.on
                    r.key.TextColor3  = C.on
                else
                    r.row.BackgroundColor3  = C.row
                    r.name.TextColor3 = C.text
                    r.key.TextColor3  = C.dim
                end
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
-- Normalize any persisted table to STRING keys (animation ids are numeric
-- strings; a stray number key would make JSONEncode fail on a sparse array and
-- silently wipe the whole save — which is why blacklists were vanishing).
local function normKeys(t)
    local o = {}
    if type(t) == "table" then for k, v in pairs(t) do o[tostring(k)] = v end end
    return o
end
local favorites = normKeys(Settings.get("av_favorites", {}))  -- id -> true
local blacklist = normKeys(Settings.get("av_blacklist", {}))  -- id -> true (hidden permanently)
-- Save IMMEDIATELY (not debounced): blacklisting/favoriting is a rare deliberate
-- action, so we flush to disk right away so it survives a rejoin/reload.
local function saveFavs()
    Settings.set("av_favorites", normKeys(favorites))
    if Settings.flush then Settings.flush() end
end
local function saveBL()
    Settings.set("av_blacklist", normKeys(blacklist))
    if Settings.flush then Settings.flush() end
end
AV._loadPaused = false       -- when true, new animations stop being logged

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
-- Public category lookup (M1 / Critical / Heavy / Mantra / Weapon / Other) for a
-- given animation id, resolved from its indexed name. Used by Combat/Visuals to
-- color the attack hitbox (Critical = red, everything else = green).
function AV.categoryOf(id) return categorize(nameCache[tostring(id)]) end

----------------------------------------------------------------------
-- LOGGING (enemy animations)
----------------------------------------------------------------------
local sourceMode = "Enemies"   -- Enemies | Self | All
local logPaused = false        -- when true, stop logging new animations
local refreshList   -- fwd

local function logAnim(track, ownerModel)
    if logPaused or AV._loadPaused then return end
    local anim = track.Animation
    if not anim then return end
    local id = (anim.AnimationId or ""):gsub("rbxassetid://", "")
    if id == "" then return end
    if blacklist[id] then return end
    -- Distance gate: skip capture from owners beyond AnimVizRange (0 = unlimited).
    local maxR = State and State.AnimVizRange or 0
    if maxR and maxR > 0 and ownerModel and LP.Character then
        local me = LP.Character:FindFirstChild("HumanoidRootPart")
        local r  = ownerModel:FindFirstChild("HumanoidRootPart")
            or ownerModel:FindFirstChildWhichIsA("BasePart")
        if me and r and (r.Position - me.Position).Magnitude > maxR then return end
    end
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
    -- cache rig for preview — but ONLY while the visualizer is open. Cloning a
    -- full rig model on every new animation id is expensive (deep clone + GC),
    -- and doing it continuously while the window is CLOSED was the main FPS hit.
    -- When open, we still snapshot rigs as they appear (same preview behaviour);
    -- when closed we just log the id (cheap) and clone lazily on preview instead.
    if AV._open and not entityCache[id] then
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
local RunSvc2   = game:GetService("RunService")
local hooked = setmetatable({}, { __mode = "k" })
-- Shared handler: an Animator-owner (Humanoid OR AnimationController) played a
-- track. `owner` is the model it belongs to (humanoid OR custom creature rig).
local function onAnimPlayed(owner, track)
    if not owner then return end
    local isSelf = owner == LP.Character
    if sourceMode == "Enemies" and isSelf then return end
    if sourceMode == "Self" and not isSelf then return end
    logAnim(track, owner)
end
local function hookHum(hum)
    if hooked[hum] then return end
    hooked[hum] = true
    Conns.add(hum.AnimationPlayed:Connect(function(track)
        onAnimPlayed(hum.Parent, track)
    end))
end
Humanoids.onAdded(hookHum)

-- Non-humanoid rigs (bosses / creatures / props) animate via an
-- AnimationController instead of a Humanoid. Hook those too so their
-- animations are logged AND their real rig is captured for preview.
local function hookController(ac)
    if hooked[ac] then return end
    hooked[ac] = true
    Conns.add(ac.AnimationPlayed:Connect(function(track)
        onAnimPlayed(ac.Parent, track)
    end))
end
-- THE reliable source: the Animator itself. Modern/replicated animations are
-- loaded on the Animator (not the Humanoid/AnimationController), so those events
-- DON'T fire — which is why some monsters' animations showed up and others
-- didn't. Hooking every Animator's AnimationPlayed catches them all.
local function hookAnimator(an)
    if hooked[an] then return end
    hooked[an] = true
    Conns.add(an.AnimationPlayed:Connect(function(track)
        onAnimPlayed(an:FindFirstAncestorWhichIsA("Model"), track)
    end))
end
do
    for _, d in ipairs(workspace:GetDescendants()) do
        if d:IsA("AnimationController") then hookController(d)
        elseif d:IsA("Animator") then hookAnimator(d) end
    end
    Conns.add(workspace.DescendantAdded:Connect(function(d)
        if d:IsA("AnimationController") then hookController(d)
        elseif d:IsA("Animator") then hookAnimator(d) end
    end))
end

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
-- ViewportFrames do NOT evaluate Animators, so we drive the rig manually
-- from the animation's KeyframeSequence (this is the only way to preview a
-- moving rig inside a ViewportFrame).
local KSP = game:GetService("KeyframeSequenceProvider")
local poseFrames   -- sorted array: { {t=secs, poses={[jointName]=CFrame}}, ... }
local motorMap     -- jointName -> Motor6D in the current preview model

local function clearPreview()
    if currentTrack then pcall(function() currentTrack:Stop() end); currentTrack = nil end
    poseFrames, motorMap = nil, nil
    if vpWM then for _, c in ipairs(vpWM:GetChildren()) do if c:IsA("Model") then c:Destroy() end end end
    previewModel = nil
end

-- Fetch + parse the KeyframeSequence into poseFrames. Also detect the rig type
-- the animation was authored for (R6 vs R15) from its pose names, so we can
-- preview it on a matching rig (the #1 reason a preview "won't animate" is an
-- R6 anim being shown on an R15 rig).
local function fetchKeyframes(id)
    poseFrames = {}
    local ok, seq = pcall(function()
        return KSP:GetKeyframeSequenceAsync("rbxassetid://" .. id)
    end)
    if not ok or not seq then return false, tostring(seq) end
    local kfs = {}
    for _, kf in ipairs(seq:GetChildren()) do
        if kf:IsA("Keyframe") then kfs[#kfs+1] = kf end
    end
    table.sort(kfs, function(a, b) return a.Time < b.Time end)
    local maxT, isR15 = 0, false
    for _, kf in ipairs(kfs) do
        local poses = {}
        local function walk(p)
            for _, c in ipairs(p:GetChildren()) do
                if c:IsA("Pose") then
                    poses[c.Name] = c.CFrame
                    if c.Name == "UpperTorso" or c.Name == "LowerTorso"
                    or c.Name == "LeftUpperArm" or c.Name == "RightUpperArm" then
                        isR15 = true
                    end
                    walk(c)
                end
            end
        end
        walk(kf)
        poseFrames[#poseFrames+1] = { t = kf.Time, poses = poses }
        if kf.Time > maxT then maxT = kf.Time end
    end
    if #poseFrames == 0 then return false, "no keyframes" end
    return true, maxT, (isR15 and "R15" or "R6")
end

-- Map the rig's Motor6Ds by the child-part name the poses reference.
local function mapMotors(model)
    motorMap = {}
    for _, d in ipairs(model:GetDescendants()) do
        if d:IsA("Motor6D") and d.Part1 then motorMap[d.Part1.Name] = d end
    end
end

-- Pose the rig at time t by lerping between surrounding keyframes.
local function applyPose(t)
    if not (poseFrames and motorMap) or #poseFrames == 0 then return end
    local f0, f1 = poseFrames[1], poseFrames[#poseFrames]
    for i = 1, #poseFrames - 1 do
        if t >= poseFrames[i].t and t <= poseFrames[i+1].t then
            f0, f1 = poseFrames[i], poseFrames[i+1]; break
        end
    end
    local span  = f1.t - f0.t
    local alpha = span > 0 and (t - f0.t) / span or 0
    for joint, m in pairs(motorMap) do
        local c0, c1 = f0.poses[joint], f1.poses[joint]
        if c0 and c1 then m.Transform = c0:Lerp(c1, alpha)
        elseif c0 then m.Transform = c0
        elseif c1 then m.Transform = c1 end
    end
end
AV._applyPose = applyPose

-- Default preview rig: a CLONE of the local player's real character. Real
-- (already-simulated) rigs animate correctly inside a ViewportFrame and match
-- the game's rig type (R6/R15) — synthetic CreateHumanoidModelFromDescription
-- rigs often refuse to animate in a viewport, which is what broke playback.
local function cloneLocalChar()
    local char = LP.Character
    if not char or not char:FindFirstChildWhichIsA("Humanoid") then return nil end
    local prev = char.Archivable
    char.Archivable = true
    local ok, clone = pcall(function() return char:Clone() end)
    char.Archivable = prev
    if not ok or not clone then return nil end
    -- Strip anything that could error / interfere; keep parts + joints + humanoid.
    for _, d in ipairs(clone:GetDescendants()) do
        if d:IsA("Script") or d:IsA("LocalScript") or d:IsA("ModuleScript")
        or d:IsA("ProximityPrompt") or d:IsA("BillboardGui") or d:IsA("Sound") then
            pcall(function() d:Destroy() end)
        end
    end
    return clone
end

-- Standard humanoid joint names (R6 + R15). If an animation's poses are all in
-- this set it's a normal humanoid anim; otherwise it's a custom rig.
local HUMANOID_JOINTS = {}
for _, n in ipairs({
    "HumanoidRootPart","Torso","Head","Left Arm","Right Arm","Left Leg","Right Leg",
    "LowerTorso","UpperTorso","LeftUpperArm","LeftLowerArm","LeftHand",
    "RightUpperArm","RightLowerArm","RightHand","LeftUpperLeg","LeftLowerLeg","LeftFoot",
    "RightUpperLeg","RightLowerLeg","RightFoot","RightGrip","LeftGrip","Handle",
}) do HUMANOID_JOINTS[n] = true end

-- Find the real model in the game whose part names match the animation's pose
-- names (custom mobs name their parts the same as their animation joints).
-- One pass over workspace + ReplicatedStorage, scoring each candidate model.
local function findRigForPoses(nameSet)
    local want = 0
    for _ in pairs(nameSet) do want = want + 1 end
    if want == 0 then return nil end
    local function nearestModel(inst)
        local p = inst.Parent
        while p and p ~= game do
            if p:IsA("Model") then return p end
            p = p.Parent
        end
    end
    -- Pass 1: which models contain each matched joint name.
    local nameModels = {}   -- name -> { [model]=true }
    local modelNames = {}   -- model -> { [name]=true }
    for _, container in ipairs({ workspace, game:GetService("ReplicatedStorage") }) do
        for _, d in ipairs(container:GetDescendants()) do
            if d:IsA("BasePart") and nameSet[d.Name] then
                local m = nearestModel(d)
                if m then
                    nameModels[d.Name] = nameModels[d.Name] or {}
                    nameModels[d.Name][m] = true
                    modelNames[m] = modelNames[m] or {}
                    modelNames[m][d.Name] = true
                end
            end
        end
    end
    -- Frequency of each name across distinct models (common names = low weight).
    local freq = {}
    for name, models in pairs(nameModels) do
        local c = 0; for _ in pairs(models) do c = c + 1 end; freq[name] = c
    end
    -- Pass 2: score each model by SUM of 1/freq over its matched names, so a
    -- model owning rare/distinctive joints (the real rig) beats one that only
    -- shares generic names like "Head".
    local best, bestScore = nil, 0
    for m, names in pairs(modelNames) do
        local s, matched = 0, 0
        for name in pairs(names) do s = s + 1 / (freq[name] or 1); matched = matched + 1 end
        if matched >= 3 and s > bestScore then bestScore = s; best = m end
    end
    return best
end

-- Last-resort synthetic rig (only if there's no character to clone).
local fallbackRigs = {}
local function getFallbackRig(rigType)
    rigType = (rigType == "R6") and "R6" or "R15"
    local cached = fallbackRigs[rigType]
    if cached then return cached end
    local rt = (rigType == "R6") and Enum.HumanoidRigType.R6 or Enum.HumanoidRigType.R15
    local ok, m = pcall(function()
        return Players:CreateHumanoidModelFromDescription(Instance.new("HumanoidDescription"), rt)
    end)
    if ok and m then fallbackRigs[rigType] = m end
    return fallbackRigs[rigType]
end

local infoName, infoId, infoMeta, scrubFill, scrubTime, saveBtn, playBtn
local function loadPreview(id)
    selectedId = id
    clearPreview()
    AV._lastLoadId = id

    -- Parse the animation so we know its joint/part names + rig type.
    local _, _, rigType = fetchKeyframes(id)
    local nameSet = {}
    local isHumanoidAnim = true
    if poseFrames then
        for _, f in ipairs(poseFrames) do
            for n in pairs(f.poses) do
                nameSet[n] = true
                if not HUMANOID_JOINTS[n] then isHumanoidAnim = false end
            end
        end
    end

    -- Pick a rig to play on, best first:
    --   1) the captured rig that actually played this anim
    --   2) custom anim -> find the matching model in the game by part names
    --   3) humanoid anim -> a clone of YOUR real character
    --   4) synthetic fallback (last resort)
    local model
    if entityCache[id] then
        model = entityCache[id]:Clone()
    elseif not isHumanoidAnim then
        local found = findRigForPoses(nameSet)
        if found then
            local prev = found.Archivable
            found.Archivable = true
            local okc, clone = pcall(function() return found:Clone() end)
            found.Archivable = prev
            if okc and clone then
                model = clone
                entityCache[id] = clone:Clone()   -- cache for next time
            end
        end
    end
    if not model and isHumanoidAnim then model = cloneLocalChar() end
    if not model then model = cloneLocalChar() end   -- last resort for custom w/o match
    if not model then
        local fb = getFallbackRig(rigType or "R15")
        if fb then model = fb:Clone() end
    end
    if not model then
        if infoName then infoName.Text = "Could not build a rig" end
        return
    end
    -- Strip anything that could run/error or clutter the preview.
    for _, d in ipairs(model:GetDescendants()) do
        if d:IsA("Script") or d:IsA("LocalScript") or d:IsA("ModuleScript")
        or d:IsA("ProximityPrompt") or d:IsA("BillboardGui") or d:IsA("Sound")
        or d:IsA("ParticleEmitter") or d:IsA("Fire") or d:IsA("Smoke") then
            pcall(function() d:Destroy() end)
        end
    end
    model.Parent = vpWM
    -- Non-humanoid rigs often have no PrimaryPart; give one so PivotTo + the
    -- camera framing still work.
    if not model.PrimaryPart then
        local root = model:FindFirstChild("HumanoidRootPart")
            or model:FindFirstChild("Torso")
            or model:FindFirstChildWhichIsA("BasePart", true)
        if root then model.PrimaryPart = root end
    end
    model:PivotTo(CFrame.new(0, 0, 0))
    previewModel = model
    -- Camera setup — identical to the type-soul / deepwoken-rewrite reference.
    if model.PrimaryPart then
        local _, bbs = model:GetBoundingBox()
        vpCam.CFrame = CFrame.lookAt(
            model.PrimaryPart.Position - Vector3.new(0, 0, bbs.Magnitude),
            model.PrimaryPart.Position)
    end
    -- 3) Animator playback. ViewportFrames DO evaluate Animators (verified), so
    --    we LoadAnimation + Play at speed 0 and drive TimePosition manually.
    --    Anchor ONLY the root: the joints position every other part, and an
    --    anchored part would ignore its Motor6D (that's what froze the rig).
    local rootPart = model.PrimaryPart or model:FindFirstChild("HumanoidRootPart")
        or model:FindFirstChildWhichIsA("BasePart")
    for _, p in ipairs(model:GetDescendants()) do
        if p:IsA("BasePart") then p.Anchored = (p == rootPart) end
    end
    local ac = model:FindFirstChildWhichIsA("Humanoid")
        or model:FindFirstChildWhichIsA("AnimationController")
    if not ac then ac = Instance.new("AnimationController", model) end
    local animator = ac:FindFirstChildWhichIsA("Animator") or Instance.new("Animator", ac)
    for _, t in ipairs(animator:GetPlayingAnimationTracks()) do pcall(function() t:Stop() end) end
    local okp, err = pcall(function()
        local a = mk("Animation", { AnimationId = "rbxassetid://" .. id })
        currentTrack = animator:LoadAnimation(a)
        currentTrack.Looped = true
        currentTrack.Priority = Enum.AnimationPriority.Action
        currentTrack:Play(0.0, 100, 0.0)        -- fade 0, weight 100, speed 0
    end)
    if not okp or not currentTrack then
        currentTrack = nil
        if infoName then infoName.Text = "Failed to load — press Retry" end
        if infoMeta then infoMeta.Text = "Error: " .. tostring(err) end
        if AV._retryBtn then AV._retryBtn.Visible = true end
        return
    end
    paused = false
    if playBtn then playBtn.Text = "Pause" end
    if AV._retryBtn then AV._retryBtn.Visible = false end

    -- info panel
    local e = logged[id] or { name = nameCache[id] or ("Anim " .. id), cat = "?" }
    if infoName then infoName.Text = e.name end
    if infoId then infoId.Text = "rbxassetid://" .. id end
    local pt = _G.__ParryTimings
    if infoMeta then
        local function fmt(list)
            if not list or #list == 0 then return "none" end
            local parts = {}
            for _, s in ipairs(list) do parts[#parts+1] = math.floor(s*1000).."ms" end
            return table.concat(parts, ", ")
        end
        local parry  = pt and pt.getTimes  and pt.getTimes(id)  or {}
        local dodge  = pt and pt.getDodges and pt.getDodges(id) or {}
        infoMeta.Text = string.format("Len %.2fs  |  Parry: %s  |  Dodge: %s",
            currentTrack.Length, fmt(parry), fmt(dodge))
    end
end
AV._loadPreview = loadPreview

----------------------------------------------------------------------
-- LIST
----------------------------------------------------------------------
local listScroll, listLayout
local function rowsForView()
    local out = {}
    local q = searchText:lower()
    local viewingBL = (catFilter == "Blacklist")
    local function consider(id, e)
        e = e or logged[id]; if not e then return end
        if viewingBL then
            if not blacklist[id] then return end
        else
            if blacklist[id] then return end                 -- hide blacklisted everywhere else
            if catFilter == "Favorites" and not favorites[id] then return end
            if catFilter ~= "All" and catFilter ~= "Favorites" and catFilter ~= "Recent"
                and e.cat ~= catFilter then return end
        end
        if q ~= "" then
            local hay = (e.name .. " " .. e.id .. " " .. (e.owner or "")):lower()
            if not hay:find(q, 1, true) then return end
        end
        table.insert(out, e)
    end
    if viewingBL then
        -- Show EVERY blacklisted id, even ones not seen (logged) this session —
        -- otherwise a freshly-loaded blacklist renders empty, which reads as
        -- "my blacklist didn't save". Synthesize a minimal row when needed so
        -- the entry still shows (with its name if we've indexed it) and stays
        -- un-blacklist-able.
        for id in pairs(blacklist) do
            consider(id, logged[id] or {
                id = id, name = nameCache[id] or ("Anim " .. id),
                owner = "?", cat = categorize(nameCache[id]), lastSeen = 0,
            })
        end
    elseif catFilter == "Recent" then
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
            Size = UDim2.fromOffset(48, 16), Position = UDim2.new(1, -52, 0, 4),
            BackgroundColor3 = C.bg, BorderSizePixel = 0, Text = "Copy",
            TextColor3 = C.accent, TextSize = 11, Font = Enum.Font.GothamBold,
        }, row)
        corner(copyBtn, 4)
        copyBtn.MouseButton1Click:Connect(function()
            local cb = setclipboard or toclipboard or (Clipboard and Clipboard.set)
            if cb then pcall(cb, e.id) end
            copyBtn.Text = "OK"
            task.delay(0.5, function() if copyBtn.Parent then copyBtn.Text = "Copy" end end)
        end)

        local blView = (catFilter == "Blacklist")
        local blBtn = mk("TextButton", {
            Size = UDim2.fromOffset(48, 16), Position = UDim2.new(1, -52, 0, 22),
            BackgroundColor3 = blView and C.accent2 or C.row, BorderSizePixel = 0,
            Text = blView and "Show" or "Hide",
            TextColor3 = blView and Color3.new(1,1,1) or C.dim,
            TextSize = 11, Font = Enum.Font.GothamBold,
        }, row)
        corner(blBtn, 4)
        blBtn.MouseButton1Click:Connect(function()
            if blacklist[e.id] then blacklist[e.id] = nil else blacklist[e.id] = true end
            saveBL(); refreshList()
        end)

        local click = mk("TextButton", {
            Size = UDim2.new(1, -110, 1, 0), Position = UDim2.fromOffset(28, 0),
            BackgroundTransparency = 1, Text = "",
        }, row)
        click.MouseButton1Click:Connect(function() loadPreview(e.id); refreshList() end)
    end
    listScroll.CanvasSize = UDim2.new(0, 0, 0, #rows * 44)
    if AV._refreshRail then AV._refreshRail() end   -- keep category rail in sync
    if AV._status then
        local total = 0; for _ in pairs(logged) do total = total + 1 end
        local bl = 0; for _ in pairs(blacklist) do bl = bl + 1 end
        AV._status.Text = string.format("%d shown · %d total · %d hidden%s",
            #rows, total, bl, logPaused and " · LOADING PAUSED" or "")
    end
end

----------------------------------------------------------------------
-- CATEGORY PICKER (shown when saving a parry timing)
----------------------------------------------------------------------
-- onPick(categoryName) is called with the chosen/created category.
local function promptCategory(id, timeSec, onPick, kind)
    kind = kind or "parry"
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
        BackgroundTransparency=1,
        Text = (kind=="dodge" and "💾  Save Dodge Timing" or "💾  Save Parry Timing"),
        TextColor3=C.accent, TextSize=16,
        Font=Enum.Font.GothamBlack, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=402, Parent=dlg })
    mk("TextLabel", { Size=UDim2.new(1,-24,0,18), Position=UDim2.fromOffset(14,38),
        BackgroundTransparency=1,
        Text=string.format("%s  @  %d ms", (logged[id] and logged[id].name) or id, math.floor(timeSec*1000)),
        TextColor3=C.dim, TextSize=12, Font=Enum.Font.Code,
        TextXAlignment=Enum.TextXAlignment.Left, ZIndex=402, Parent=dlg })
    mk("TextLabel", { Size=UDim2.new(1,-24,0,16), Position=UDim2.fromOffset(14,62),
        BackgroundTransparency=1, Text="Choose a category:", TextColor3=C.text, TextSize=12,
        Font=Enum.Font.GothamBold, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=402, Parent=dlg })

    local function finish(cat)
        if pt then
            if kind == "dodge" and pt.addDodge then pt.addDodge(id, timeSec, cat)
            elseif pt.addParry then pt.addParry(id, timeSec, cat)        -- append (allows multiple)
            elseif pt.set then pt.set(id, timeSec, cat) end
        end
        mask:Destroy()
        if onPick then onPick(cat, kind) end
    end

    -- search box: filter the category list as you type.
    local searchBox = mk("TextBox", { Size=UDim2.new(1,-24,0,26), Position=UDim2.fromOffset(12,80),
        BackgroundColor3=C.bg, BorderSizePixel=0, PlaceholderText="Search categories…",
        Text="", TextColor3=C.text, PlaceholderColor3=C.dim, TextSize=12, Font=Enum.Font.Gotham,
        ClearTextOnFocus=false, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=402, Parent=dlg })
    corner(searchBox,6); mk("UIPadding",{PaddingLeft=UDim.new(0,8)},searchBox)

    -- existing categories list (shifted down to make room for the search box)
    local listF = mk("ScrollingFrame", { Size=UDim2.new(1,-24,0,150), Position=UDim2.fromOffset(12,112),
        BackgroundColor3=C.bg, BorderSizePixel=0, ScrollBarThickness=4,
        CanvasSize=UDim2.new(0,0,0,0), ZIndex=402, Parent=dlg })
    corner(listF,6)
    mk("UIListLayout", { Padding=UDim.new(0,3), SortOrder=Enum.SortOrder.LayoutOrder }, listF)

    local function rebuildList(query)
        query = (query or ""):lower()
        for _, c in ipairs(listF:GetChildren()) do
            if not c:IsA("UIListLayout") then c:Destroy() end
        end
        local shown = 0
        for i, cat in ipairs(cats) do
            if query == "" or string.find(cat:lower(), query, 1, true) then
                shown = shown + 1
                local b = mk("TextButton", { Size=UDim2.new(1,-4,0,30), BackgroundColor3=C.row,
                    BorderSizePixel=0, Text="  "..cat, TextColor3=C.text, TextSize=13,
                    Font=Enum.Font.GothamBold, TextXAlignment=Enum.TextXAlignment.Left,
                    LayoutOrder=i, ZIndex=403, Parent=listF })
                corner(b,5)
                b.MouseEnter:Connect(function() b.BackgroundColor3=C.hover end)
                b.MouseLeave:Connect(function() b.BackgroundColor3=C.row end)
                b.MouseButton1Click:Connect(function() finish(cat) end)
            end
        end
        if shown == 0 then
            mk("TextLabel", { Size=UDim2.new(1,0,0,30), BackgroundTransparency=1,
                Text = (#cats == 0) and "(no categories yet — make one below)"
                    or "(no match — type below to make a new one)",
                TextColor3=C.dim, TextSize=12, Font=Enum.Font.Gotham, ZIndex=403, Parent=listF })
        end
        listF.CanvasSize = UDim2.new(0,0,0, math.max(shown,1)*33)
    end
    rebuildList("")
    searchBox:GetPropertyChangedSignal("Text"):Connect(function() rebuildList(searchBox.Text) end)

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
-- REPLACE-OR-ADD PICKER
-- Shown when the animation ALREADY has parry timing(s) and the user tries
-- to save another. They can replace a specific existing timing, or add this
-- frame as an additional timing. onAdd() is called if they choose "add new".
----------------------------------------------------------------------
local function promptReplaceOrAdd(id, timeSec, existing, onChanged, onAdd, kind)
    kind = kind or "parry"
    local pt = _G.__ParryTimings
    local setAt = (kind == "dodge") and (pt and pt.setDodgeAt) or (pt and pt.setParryAt)
    local label = (kind == "dodge") and "dodge" or "parry"
    local newMs = math.floor(timeSec * 1000)
    local mask = mk("TextButton", { Size=UDim2.new(1,0,1,0), BackgroundColor3=Color3.new(0,0,0),
        BackgroundTransparency=0.55, BorderSizePixel=0, Text="", AutoButtonColor=false,
        ZIndex=410, Parent=gui })
    local listH = math.min(#existing, 6) * 33
    local dlgH  = 150 + listH + 40
    local dlg = mk("Frame", { Size=UDim2.fromOffset(360, dlgH), Position=UDim2.new(0.5,-180,0.5,-dlgH/2),
        BackgroundColor3=C.bgAlt, BorderSizePixel=0, ZIndex=411, Parent=mask })
    corner(dlg,10); stroke(dlg)
    mk("TextLabel", { Size=UDim2.new(1,-20,0,26), Position=UDim2.fromOffset(14,10), BackgroundTransparency=1,
        Text="⚠  Timing already exists", TextColor3=C.accent, TextSize=16, Font=Enum.Font.GothamBlack,
        TextXAlignment=Enum.TextXAlignment.Left, ZIndex=412, Parent=dlg })
    mk("TextLabel", { Size=UDim2.new(1,-24,0,34), Position=UDim2.fromOffset(14,38), BackgroundTransparency=1,
        Text=string.format("%s already has %d %s timing(s).\nReplace one with %d ms, or add as a new one?",
            (logged[id] and logged[id].name) or id, #existing, label, newMs),
        TextColor3=C.dim, TextSize=12, Font=Enum.Font.Gotham, TextWrapped=true,
        TextXAlignment=Enum.TextXAlignment.Left, TextYAlignment=Enum.TextYAlignment.Top, ZIndex=412, Parent=dlg })

    local listF = mk("ScrollingFrame", { Size=UDim2.new(1,-24,0,listH), Position=UDim2.fromOffset(12,84),
        BackgroundColor3=C.bg, BorderSizePixel=0, ScrollBarThickness=4,
        CanvasSize=UDim2.new(0,0,0,#existing*33), ZIndex=412, Parent=dlg })
    corner(listF,6)
    mk("UIListLayout", { Padding=UDim.new(0,3), SortOrder=Enum.SortOrder.LayoutOrder }, listF)
    for i, sec in ipairs(existing) do
        local b = mk("TextButton", { Size=UDim2.new(1,-4,0,30), BackgroundColor3=C.row, BorderSizePixel=0,
            Text=string.format("  Replace #%d   (%d ms  →  %d ms)", i, math.floor(sec*1000), newMs),
            TextColor3=C.text, TextSize=13, Font=Enum.Font.GothamBold,
            TextXAlignment=Enum.TextXAlignment.Left, LayoutOrder=i, ZIndex=413, Parent=listF })
        corner(b,5)
        b.MouseEnter:Connect(function() b.BackgroundColor3=C.hover end)
        b.MouseLeave:Connect(function() b.BackgroundColor3=C.row end)
        b.MouseButton1Click:Connect(function()
            if setAt then setAt(id, i, timeSec) end
            mask:Destroy()
            if _G.__Notify then _G.__Notify("Timing Replaced",
                string.format("%s #%d → %d ms", (logged[id] and logged[id].name) or id, i, newMs), 2.5, C.good) end
            if onChanged then onChanged() end
        end)
    end

    local addBtn = mk("TextButton", { Size=UDim2.new(1,-24,0,30), Position=UDim2.fromOffset(12,84+listH+8),
        BackgroundColor3=C.accent2, BorderSizePixel=0,
        Text=string.format("+ Add as new timing  (now %d)", #existing+1), TextColor3=Color3.new(1,1,1),
        TextSize=13, Font=Enum.Font.GothamBold, ZIndex=412, Parent=dlg })
    corner(addBtn,6)
    addBtn.MouseButton1Click:Connect(function() mask:Destroy(); if onAdd then onAdd() end end)

    local cancel = mk("TextButton", { Size=UDim2.new(1,-24,0,26), Position=UDim2.fromOffset(12,84+listH+44),
        BackgroundColor3=C.row, BorderSizePixel=0, Text="Cancel", TextColor3=C.text,
        TextSize=12, Font=Enum.Font.GothamBold, ZIndex=412, Parent=dlg })
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
    local vsize = Settings.get("av_size", { w = 1120, h = 860 })
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
        Conns.add(UIS.InputChanged:Connect(function(i) if rz and i.UserInputType==Enum.UserInputType.MouseMovement then
            win.Size=UDim2.fromOffset(math.clamp(rz.w+i.Position.X-rz.x,520,1400),
                                      math.clamp(rz.h+i.Position.Y-rz.y,340,1000)) end end))
        Conns.add(UIS.InputEnded:Connect(function(i) if rz and i.UserInputType==Enum.UserInputType.MouseButton1 then
            Settings.set("av_size",{w=win.AbsoluteSize.X,h=win.AbsoluteSize.Y}); rz=nil end end))
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
        Conns.add(UIS.InputChanged:Connect(function(i) if drag and i.UserInputType==Enum.UserInputType.MouseMovement then
            local d=i.Position-ds; win.Position=UDim2.fromOffset(sp.X.Offset+d.X, sp.Y.Offset+d.Y) end end))
        Conns.add(UIS.InputEnded:Connect(function(i) if drag and i.UserInputType==Enum.UserInputType.MouseButton1 then
            drag=false; Settings.set("av_pos",{x=win.Position.X.Offset,y=win.Position.Y.Offset}) end end))
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

    -- ===== Second toolbar row: manual ID load + pause loading + status =====
    local row2 = mk("Frame", { Size=UDim2.new(1,-16,0,26), Position=UDim2.fromOffset(8,72),
        BackgroundTransparency=1, Parent=win })
    -- "Asset ID" label so the input is obvious as a paste section.
    mk("TextLabel", { Size=UDim2.fromOffset(58,26), Position=UDim2.fromOffset(0,0),
        BackgroundTransparency=1, Text="ASSET ID", TextColor3=C.accent,
        TextSize=11, Font=Enum.Font.GothamBlack, TextXAlignment=Enum.TextXAlignment.Left,
        Parent=row2 })
    local idBox = mk("TextBox", { Size=UDim2.new(0,294,1,0), Position=UDim2.fromOffset(62,0),
        BackgroundColor3=C.bgAlt, BorderSizePixel=0,
        PlaceholderText="Paste ID or roblox.com URL…", Text="",
        TextColor3=C.text, PlaceholderColor3=C.dim, TextSize=12, Font=Enum.Font.Code,
        ClearTextOnFocus=false, TextXAlignment=Enum.TextXAlignment.Left, Parent=row2 })
    corner(idBox,5); mk("UIPadding",{PaddingLeft=UDim.new(0,8)},idBox)
    local loadBtn = mk("TextButton", { Size=UDim2.new(0,70,1,0), Position=UDim2.fromOffset(360,0),
        BackgroundColor3=C.accent2, BorderSizePixel=0, Text="Load",
        TextColor3=Color3.new(1,1,1), TextSize=12, Font=Enum.Font.GothamBold, Parent=row2 })
    corner(loadBtn,5)
    -- Accepts:  "1234"  "rbxassetid://1234"  "https://www.roblox.com/library/1234/..."
    --          "https://create.roblox.com/store/asset/1234/..."  "...?id=1234"
    local function parseAssetId(raw)
        if not raw then return "" end
        raw = raw:gsub("%s+", "")
        if raw == "" then return "" end
        -- Try common URL patterns first.
        local m = raw:match("[%?&]ID?=(%d+)")              -- ?id=12345
              or raw:match("/asset/?(%d+)")                 -- /asset/12345
              or raw:match("/library/(%d+)")                -- /library/12345
              or raw:match("/catalog/(%d+)")                -- /catalog/12345
              or raw:match("rbxassetid://(%d+)")            -- rbxassetid://12345
              or raw:match("(%d+)$")                        -- trailing digits
        return m or raw
    end
    local function loadManual()
        local id = parseAssetId(idBox.Text)
        if id == "" or not id:match("^%d+$") then
            if infoName then infoName.Text = "Bad asset ID" end
            return
        end
        if not logged[id] then
            logged[id] = { id = id,
                name = nameCache[id] or ("Anim " .. id),
                owner = "manual",
                cat = categorize(nameCache[id] or ""),
                lastSeen = os.clock() }
        end
        loadPreview(id); refreshList()
    end
    loadBtn.MouseButton1Click:Connect(loadManual)
    idBox.FocusLost:Connect(function(enter) if enter then loadManual() end end)

    local pauseBtn = mk("TextButton", { Size=UDim2.new(0,128,1,0), Position=UDim2.fromOffset(436,0),
        BackgroundColor3=C.row, BorderSizePixel=0, Text="Pause Loading",
        TextColor3=C.text, TextSize=12, Font=Enum.Font.GothamBold, Parent=row2 })
    corner(pauseBtn,5)
    pauseBtn.MouseButton1Click:Connect(function()
        logPaused=not logPaused
        pauseBtn.Text = logPaused and "Resume Loading" or "Pause Loading"
        pauseBtn.BackgroundColor3 = logPaused and C.accent or C.row
        pauseBtn.TextColor3 = logPaused and Color3.new(1,1,1) or C.text
    end)
    -- Distance gate: only capture animations from owners within X studs.
    local RANGES = { 0, 50, 100, 200, 500, 1000 }   -- 0 = unlimited
    local function rangeText()
        local r = State and State.AnimVizRange or 0
        if r == 0 then return "Range: All" end
        return "Range: " .. r
    end
    local rangeBtn = mk("TextButton", { Size=UDim2.new(0,100,1,0), Position=UDim2.fromOffset(568,0),
        BackgroundColor3=C.bgAlt, BorderSizePixel=0, Text=rangeText(),
        TextColor3=C.accent, TextSize=12, Font=Enum.Font.GothamBold, Parent=row2 })
    corner(rangeBtn,5)
    rangeBtn.MouseButton1Click:Connect(function()
        local cur = State and State.AnimVizRange or 0
        local idx = 1
        for i, v in ipairs(RANGES) do if v == cur then idx = i break end end
        local nxt = RANGES[(idx % #RANGES) + 1]
        if State then State.AnimVizRange = nxt end
        Settings.set("state__AnimVizRange", nxt)
        rangeBtn.Text = rangeText()
    end)
    -- Clear button: wipes the captured animation list + recents (preserves
    -- favorites, blacklist and parry timings).
    local clearBtn = mk("TextButton", { Size=UDim2.new(0,72,1,0), Position=UDim2.fromOffset(672,0),
        BackgroundColor3=Color3.fromRGB(200,70,90), BorderSizePixel=0,
        Text="Clear", TextColor3=Color3.new(1,1,1), TextSize=12, Font=Enum.Font.GothamBold,
        Parent=row2 })
    corner(clearBtn,5)
    -- Two-step confirm so an accidental click doesn't wipe a long session.
    local pendingClear = false
    clearBtn.MouseButton1Click:Connect(function()
        if not pendingClear then
            pendingClear = true
            clearBtn.Text = "Confirm?"
            task.delay(2, function()
                if clearBtn.Parent and clearBtn.Text == "Confirm?" then
                    clearBtn.Text = "Clear"; pendingClear = false
                end
            end)
            return
        end
        pendingClear = false; clearBtn.Text = "Clear"
        logged = {}; recents = {}; entityCache = {}
        if clearPreview then clearPreview() end
        if AV._refreshRail then AV._refreshRail() end
        refreshList()
    end)
    local statusLbl = mk("TextLabel", { Size=UDim2.new(1,-752,1,0), Position=UDim2.fromOffset(748,0),
        BackgroundTransparency=1, Text="", TextColor3=C.dim, TextSize=11, Font=Enum.Font.Code,
        TextXAlignment=Enum.TextXAlignment.Left, Parent=row2 })
    AV._status = statusLbl

    -- ===== Body: 3 columns (category rail | animation list | preview) =====
    local body = mk("Frame", { Size=UDim2.new(1,-16,1,-110), Position=UDim2.fromOffset(8,102),
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
    local FIXED = { {"⭐ Favorites","Favorites"}, {"🕒 Recent","Recent"}, {"📋 All","All"}, {"🚫 Blacklist","Blacklist"} }
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
    viewport = mk("ViewportFrame", { Size=UDim2.new(1,0,0,460), BackgroundColor3=C.bg,
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
    playBtn = tbtn(0,58,"Pause", function()
        if not currentTrack then return end
        paused = not paused
        currentTrack:AdjustSpeed(paused and 0 or playSpeed)
    end)
    playBtn.Name = "play"
    tbtn(62,64,"Restart", function()
        if currentTrack then currentTrack.TimePosition = 0 end
    end)
    -- retry button (hidden unless a load failed)
    local retryBtn = tbtn(128,58,"Retry", function()
        if AV._lastLoadId and AV._loadPreview then AV._loadPreview(AV._lastLoadId) end
    end)
    retryBtn.BackgroundColor3 = C.accent2; retryBtn.Visible = false; retryBtn.ZIndex = 5
    AV._retryBtn = retryBtn
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
        Conns.add(UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end end))
        Conns.add(UIS.InputChanged:Connect(function(i) if dragging and i.UserInputType==Enum.UserInputType.MouseMovement then applySpd(i.Position.X) end end))
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
        Conns.add(UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end end))
        Conns.add(UIS.InputChanged:Connect(function(i) if dragging and i.UserInputType==Enum.UserInputType.MouseMovement then applyScrub(i.Position.X) end end))
    end

    -- 7) Save buttons (own rows, BELOW scrubber — no overlap).
    -- Parry timings ADD (you can save several frames per animation).
    saveBtn = mk("TextButton", { Size=UDim2.new(1,0,0,30), BackgroundColor3=C.accent2,
        BorderSizePixel=0, Text="+ Add this frame as Parry Timing", TextColor3=Color3.fromRGB(255,255,255),
        TextSize=13, Font=Enum.Font.GothamBold, LayoutOrder=7, Parent=detail })
    corner(saveBtn,6)
    saveBtn.MouseButton1Click:Connect(function()
        if not currentTrack or not selectedId then return end
        local id, ts = selectedId, currentTrack.TimePosition
        local pt = _G.__ParryTimings
        local existing = (pt and pt.getTimes and pt.getTimes(id)) or {}
        local function doAddNew()
            promptCategory(id, ts, function(cat)
                if _G.__Notify then _G.__Notify("Parry Timing Added",
                    string.format("%s -> %s @ %dms",
                        (logged[id] and logged[id].name) or id, cat, math.floor(ts*1000)),
                    2.5, C.good) end
                if selectedId == id then loadPreview(id) end  -- refresh meta
            end, "parry")
        end
        if #existing > 0 then
            -- Ask: replace an existing timing, or add this as another?
            promptReplaceOrAdd(id, ts, existing,
                function() if selectedId == id then loadPreview(id) end end,  -- onChanged (replaced)
                doAddNew)                                                     -- onAdd (new)
        else
            doAddNew()
        end
    end)
    -- Dodge timing (separate list — AutoParry dodges instead of blocks here).
    local saveDodgeBtn = mk("TextButton", { Size=UDim2.new(1,0,0,30),
        BackgroundColor3=C.row, BorderSizePixel=0,
        Text="+ Add this frame as Dodge Timing", TextColor3=C.text,
        TextSize=13, Font=Enum.Font.GothamBold, LayoutOrder=8, Parent=detail })
    corner(saveDodgeBtn,6)
    saveDodgeBtn.MouseEnter:Connect(function() saveDodgeBtn.BackgroundColor3=C.hover end)
    saveDodgeBtn.MouseLeave:Connect(function() saveDodgeBtn.BackgroundColor3=C.row end)
    saveDodgeBtn.MouseButton1Click:Connect(function()
        if not currentTrack or not selectedId then return end
        local id, ts = selectedId, currentTrack.TimePosition
        local pt = _G.__ParryTimings
        local existing = (pt and pt.getDodges and pt.getDodges(id)) or {}
        local function doAddNew()
            promptCategory(id, ts, function(cat)
                if _G.__Notify then _G.__Notify("Dodge Timing Added",
                    string.format("%s -> %s @ %dms",
                        (logged[id] and logged[id].name) or id, cat, math.floor(ts*1000)),
                    2.5, C.good) end
                if selectedId == id then loadPreview(id) end
            end, "dodge")
        end
        if #existing > 0 then
            -- Replace an existing dodge timing, or add this as another.
            promptReplaceOrAdd(id, ts, existing,
                function() if selectedId == id then loadPreview(id) end end,  -- onChanged (replaced)
                doAddNew, "dodge")                                            -- onAdd (new)
        else
            doAddNew()
        end
    end)
    -- Per-attack PARRY RANGE (deepwoken imdd/imxd). Blank = use the global Detection
    -- Range. Combat reads _G.__ParryRanges[animId] = { min, max }.
    do
        local rr = mk("Frame", { Size=UDim2.new(1,0,0,28), BackgroundTransparency=1, LayoutOrder=10, Parent=detail })
        mk("TextLabel", { Size=UDim2.fromOffset(110,28), BackgroundTransparency=1, Text="Parry range (studs)",
            TextColor3=C.dim, TextSize=11, Font=Enum.Font.Gotham, TextXAlignment=Enum.TextXAlignment.Left, Parent=rr })
        local function box(x, ph)
            local b = mk("TextBox", { Size=UDim2.fromOffset(58,22), Position=UDim2.fromOffset(x,3),
                BackgroundColor3=C.bgAlt, BorderSizePixel=0, PlaceholderText=ph, Text="",
                TextColor3=C.text, PlaceholderColor3=C.dim, TextSize=12, Font=Enum.Font.Code,
                ClearTextOnFocus=false, Parent=rr }); corner(b,5)
            mk("UIPadding", { PaddingLeft=UDim.new(0,6) }, b)
            return b
        end
        local minB = box(114, "min")
        mk("TextLabel", { Size=UDim2.fromOffset(14,28), Position=UDim2.fromOffset(176,0), BackgroundTransparency=1,
            Text="–", TextColor3=C.dim, TextSize=14, Font=Enum.Font.GothamBold, Parent=rr })
        local maxB = box(190, "max")
        local function apply()
            if not selectedId then return end
            local id = tostring(selectedId)
            local mn, mx = tonumber(minB.Text), tonumber(maxB.Text)
            _G.__ParryRanges = _G.__ParryRanges or {}
            if (not mn or mn <= 0) and (not mx or mx <= 0) then
                _G.__ParryRanges[id] = nil
            else
                _G.__ParryRanges[id] = { min = mn or 0, max = mx or 1000 }
            end
            Settings.set("parry_ranges", _G.__ParryRanges)
        end
        minB.FocusLost:Connect(apply); maxB.FocusLost:Connect(apply)
        local shown
        Conns.add(RunService.RenderStepped:Connect(function()
            if selectedId == shown then return end
            shown = selectedId
            local rng = selectedId and _G.__ParryRanges and _G.__ParryRanges[tostring(selectedId)]
            minB.Text = rng and tostring(rng.min) or ""
            maxB.Text = rng and tostring(rng.max) or ""
        end))
    end

    -- live scrubber/time update.
    -- ViewportFrame animations do NOT auto-advance, so we manually tick
    -- TimePosition each frame while playing — this is what makes the rig move.
    local lastPlayLabel, lastTimeText
    Conns.add(RunService.RenderStepped:Connect(function(dt)
        if not (gui and gui.Enabled and currentTrack) then return end
        local wantLabel = paused and "Play" or "Pause"
        if playBtn and lastPlayLabel ~= wantLabel then
            lastPlayLabel = wantLabel; playBtn.Text = wantLabel
        end
        local len = currentTrack.Length
        if len > 0 and not paused then
            local nt = currentTrack.TimePosition + dt * playSpeed
            if nt >= len then nt = nt % len end       -- loop
            currentTrack.TimePosition = nt             -- Animator poses the rig
        end
        local rel = (len > 0) and currentTrack.TimePosition/len or 0
        scrubFill.Size = UDim2.new(rel, 0, 1, 0)
        -- Time text only changes at ms granularity; skip identical writes.
        local timeText = string.format("%d / %d ms",
            math.floor(currentTrack.TimePosition*1000), math.floor(len*1000))
        if lastTimeText ~= timeText then lastTimeText = timeText; scrubTime.Text = timeText end
    end))

    -- ===== Hitbox Range (projectiles) — a detection MODE surfaced in the Visualizer =====
    -- Mirrors the Combat-tab controls; both read/write the SAME State, so changing
    -- one side changes the other. Floating panel, opened by the header "HBR" button.
    do
        local function persistHB(key, v) Settings.set("state__"..key, v) end
        local panel = mk("Frame", { Size=UDim2.fromOffset(304,384), AnchorPoint=Vector2.new(0.5,0.5),
            Position=UDim2.new(0.5,0,0.5,0), BackgroundColor3=C.bgAlt, BorderSizePixel=0,
            Visible=false, ZIndex=61, Parent=win })
        corner(panel,10); mk("UIStroke",{Color=C.border,Thickness=1,Transparency=0.15},panel)
        mk("TextLabel",{ Size=UDim2.new(1,-44,0,30), Position=UDim2.fromOffset(14,6),
            BackgroundTransparency=1, Text="🎯 Hitbox Range", TextColor3=C.text, TextSize=14,
            Font=Enum.Font.GothamBold, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=62, Parent=panel })
        local pClose = mk("TextButton",{ Size=UDim2.fromOffset(24,22), Position=UDim2.new(1,-30,0,6),
            BackgroundColor3=C.row, BorderSizePixel=0, Text="×", TextColor3=C.text, TextSize=15,
            Font=Enum.Font.GothamBold, ZIndex=62, Parent=panel }); corner(pClose,4)
        pClose.MouseButton1Click:Connect(function() panel.Visible=false end)
        local bodyF = mk("ScrollingFrame",{ Size=UDim2.new(1,-18,1,-46), Position=UDim2.fromOffset(12,40),
            BackgroundTransparency=1, BorderSizePixel=0, ScrollBarThickness=4, ScrollBarImageColor3=C.accent2,
            CanvasSize=UDim2.new(), AutomaticCanvasSize=Enum.AutomaticSize.Y, ZIndex=62, Parent=panel })
        mk("UIListLayout",{ Padding=UDim.new(0,6), SortOrder=Enum.SortOrder.LayoutOrder }, bodyF)

        local paints, ord = {}, 0
        local function row(h) ord = ord + 1
            return mk("Frame",{ Size=UDim2.new(1,0,0,h), BackgroundTransparency=1, LayoutOrder=ord, ZIndex=62, Parent=bodyF })
        end
        local function hbToggle(labelTxt, get, set)
            local r = row(28)
            mk("TextLabel",{ Size=UDim2.new(1,-52,1,0), BackgroundTransparency=1, Text=labelTxt,
                TextColor3=C.text, TextSize=12, Font=Enum.Font.Gotham, TextXAlignment=Enum.TextXAlignment.Left,
                ZIndex=62, Parent=r })
            local pill = mk("TextButton",{ Size=UDim2.fromOffset(44,20), Position=UDim2.new(1,-44,0.5,-10),
                BackgroundColor3=C.row, BorderSizePixel=0, Text="", AutoButtonColor=false, ZIndex=62, Parent=r }); corner(pill,10)
            local knob = mk("Frame",{ Size=UDim2.fromOffset(16,16), Position=UDim2.fromOffset(2,2),
                BackgroundColor3=C.text, BorderSizePixel=0, ZIndex=62, Parent=pill }); corner(knob,8)
            local function paint() local on=get()
                pill.BackgroundColor3 = on and C.accent or C.row
                knob.Position = UDim2.fromOffset(on and 26 or 2, 2) end
            pill.MouseButton1Click:Connect(function() set(not get()); paint() end)
            paints[#paints+1]=paint; paint()
        end
        local function hbSlider(labelTxt, mn, mx, get, set, suffix)
            local r = row(42)
            local lbl = mk("TextLabel",{ Size=UDim2.new(1,0,0,16), BackgroundTransparency=1, Text=labelTxt,
                TextColor3=C.dim, TextSize=11, Font=Enum.Font.Code, TextXAlignment=Enum.TextXAlignment.Left,
                ZIndex=62, Parent=r })
            local bar = mk("Frame",{ Size=UDim2.new(1,0,0,8), Position=UDim2.fromOffset(0,24),
                BackgroundColor3=C.bg, BorderSizePixel=0, ZIndex=62, Parent=r }); corner(bar,4)
            local fill = mk("Frame",{ Size=UDim2.new(0,0,1,0), BackgroundColor3=C.accent,
                BorderSizePixel=0, ZIndex=62, Parent=bar }); corner(fill,4)
            local function paint() local v=get()
                local rel=math.clamp((v-mn)/math.max(mx-mn,1),0,1); fill.Size=UDim2.new(rel,0,1,0)
                lbl.Text=labelTxt.."  "..tostring(v)..(suffix or "") end
            local dragging
            local function apply(x)
                local rel=math.clamp((x-bar.AbsolutePosition.X)/math.max(bar.AbsoluteSize.X,1),0,1)
                set(math.floor(mn+rel*(mx-mn)+0.5)); paint() end
            bar.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true; apply(i.Position.X) end end)
            Conns.add(UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end end))
            Conns.add(UIS.InputChanged:Connect(function(i) if dragging and i.UserInputType==Enum.UserInputType.MouseMovement then apply(i.Position.X) end end))
            paints[#paints+1]=paint; paint()
        end

        hbToggle("Hitbox Range Mode", function() return State.HitboxRangeMode end, function(v)
            if _G.__SetHitboxRangeMode then _G.__SetHitboxRangeMode(v) else State.HitboxRangeMode=v end
            persistHB("HitboxRangeMode", v) end)
        hbToggle("Parry on Entry", function() return State.HitboxRangeParry end, function(v)
            State.HitboxRangeParry=v; persistHB("HitboxRangeParry", v) end)
        hbSlider("Parry Range", 5, 80, function() return State.HitboxParryRange or 25 end, function(v)
            State.HitboxParryRange=v; persistHB("HitboxParryRange", v) end, " studs")
        hbSlider("Parry Delay", 0, 300, function() return math.floor((State.HitboxParryDelay or 0)*1000) end, function(v)
            State.HitboxParryDelay=v/1000; persistHB("HitboxParryDelay", State.HitboxParryDelay) end, " ms")
        hbToggle("Dodge on Entry", function() return State.HitboxRangeDodge end, function(v)
            State.HitboxRangeDodge=v; persistHB("HitboxRangeDodge", v) end)
        hbSlider("Dodge Range", 5, 80, function() return State.HitboxDodgeRange or 25 end, function(v)
            State.HitboxDodgeRange=v; persistHB("HitboxDodgeRange", v) end, " studs")
        hbSlider("Dodge Delay", 0, 300, function() return math.floor((State.HitboxDodgeDelay or 0)*1000) end, function(v)
            State.HitboxDodgeDelay=v/1000; persistHB("HitboxDodgeDelay", State.HitboxDodgeDelay) end, " ms")

        local hintR = row(34)
        mk("TextLabel",{ Size=UDim2.new(1,0,1,0), BackgroundTransparency=1,
            Text="Reacts to incoming projectiles by RANGE, independent of animation timing. Mirrors the Combat tab.",
            TextColor3=C.dim, TextSize=10, Font=Enum.Font.Gotham, TextWrapped=true,
            TextXAlignment=Enum.TextXAlignment.Left, TextYAlignment=Enum.TextYAlignment.Top, ZIndex=62, Parent=hintR })

        -- Header button that opens/closes the panel (re-syncs the controls on open).
        local hbBtn = mk("TextButton",{ Size=UDim2.fromOffset(38,22), Position=UDim2.new(1,-74,0,6),
            BackgroundColor3=C.row, BorderSizePixel=0, Text="HBR", TextColor3=C.accent, TextSize=11,
            Font=Enum.Font.GothamBold, Parent=header }); corner(hbBtn,4)
        hbBtn.MouseButton1Click:Connect(function()
            panel.Visible = not panel.Visible
            if panel.Visible then for _,p in ipairs(paints) do p() end end
        end)
    end

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
    local lastPrune, lastScan = 0, 0
    Conns.add(RunService.Heartbeat:Connect(function()
        local now = tick()
        -- Cheap: drop dead refs (small set) every couple seconds.
        if now - lastPrune >= 2 then
            lastPrune = now
            for h in pairs(set) do
                if not h.Parent then set[h] = nil end
            end
        end
        -- Expensive: a full workspace:GetDescendants() allocates a 30k+ table
        -- and was running every 1.5s (constant GC churn / stutter). DescendantAdded
        -- already catches every new Humanoid, so this rescan is only a safety net
        -- for streaming/odd load order — run it rarely.
        if now - lastScan >= 10 then
            lastScan = now
            for _, d in ipairs(workspace:GetDescendants()) do
                if d:IsA("Humanoid") and not set[d] then add(d) end
            end
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
-- ModeratorChecker: scans the server for known game moderators / admins, and
-- (separately) known content creators / YouTubers.
--
-- Moderator detection sources (any one triggers):
--   * Username on the built-in DEFAULT_MODS list, or getgenv().ModeratorList
--   * Player has a "Mod" / "Admin" / "Developer" tag attribute set
--   * Player's leaderstats contains "Admin" / "Moderator"
-- YouTuber detection:
--   * Username on the built-in DEFAULT_YOUTUBERS list, or getgenv().YouTuberList
local Players      = game:GetService("Players")
local Conns        = require("Utility/Conns")
local Notification = require("Features/Notification")

local ModeratorChecker = {}
local State

-- Known moderators (Roblox usernames, lowercase, de-duplicated).
local DEFAULT_MODS = {
    "3kazo","greathorne1","marrsworid","bufordith","crazywealth","songofancient",
    "koveszn","killer67564564643","emrahdior","ashapira","kyutality","den4ick100",
    "zdissy","rareredbutterflies","nixhwa","kenanqk","taisabu_il","plamitic",
    "briancf1","bonbabrtime","iale11","nicolasmm12","mkmosc","ragingsama",
    "imtonindo","arthemist","lazarovip2","externaltv_man","utility5452",
    "frankxlin17","qasward","colossalturtle",
}

-- Known content creators / YouTubers (Roblox usernames, lowercase).
local DEFAULT_YOUTUBERS = {
    "ivtwig","hauntedrecalling","vasmery","crimsonmoonxiii","hollowed_requiem",
    "kingnogo","realryujiyt","inczsss","fake_borgor","zsayfu","foururex",
    "raizer_albertiks","sifanprayer","zentubaa","xxabsolutoxx","yoimaginetho",
    "yourenotben","mizurri","123monkeydluffy","ashtek01","whenwemustpart",
    "rayva1y","stumble99999999999","luffy_08363","life9s","nellyumi","10josse75",
    "banzigotop","pikayo_yt","soggy_turkeyflaps","47dere","ponpungo","jariius",
    "zigzagfangamer","dopestar210","snotzakdoekjes","bronyman013","sa1tyt",
    "mightfreedy","ghostzbunny","marvyflex","lnsignius","desiredc0des",
    "iisciencecow","gggameslytl","nanoprodigy","notgcool360","iiverm",
    "eternalsurgeheim","chawyjr","drizzyontopp","saintethan","justkenshiiii",
    "shinou40","rozzande","follow_aa1nt","rayquazas2828","imjustalpha1","xxarpcc",
    "jadendragon87690","o0f5s","lastword_mutt","2veloyt","peep3w","ttsuciohh",
    "exvar","boipsuu","yileenas","clxud9z","carcerality","whoelsebutbaggy",
    "hw5567","qwerghuiles","dumboyyyy","rusticblackops01","ygsnipaa",
    "uzumakipedriin","sap906","mrcaptkiddjr","shewantshermes","guizeratrue",
    "w3_s7","casualcause","d9ubt","superzydan","sagez_szg","baderasaurus",
    "af1errain","legroupleader","ezzotik","fadedlanded","cxrsedhakii","5rz4",
    "itsmumed","universalpanthers","planetcea17","yelixo","mk47ss","spikey_28",
    "jimmy_bnks","zperqs","jamaldingel","c1isontop","nwarplay","adm_5778c",
    "builderboy100009","ashysrr","midnytejay","sly_kage","yezxfxz","syoct",
    "az1nu","sweepeerblx","cuongbots","breazsy","convictvince","thebigtanjiroo",
    "davonnydripy","trop555","adriano_thebos","fentfein38","itsosskar","unotwoyt",
    "newbami1","supremexxape_games","sagee4","truth_rain","holvenom",
    "slyalphagronk","reaconteur_real","maxgonebed","yunuskakas","dannyplayz80",
    "tariqrbx_1","waludy_yt","jayyment","deadpoolj81","supercoolrami214",
    "bundlelf5","m1xm55","bohemianfart","kj_gmr2","jeffrlgamer","zombieylol",
    "whoisnikkx","leisurement","zentiiyt","nrh_cam","notraf_dev","aceyywayce",
    "bushidof3","nanerki","svkqqqq","exotcixz","fexler","imshredsy","xseweffect",
    "remkaioh","godden3","0mervons","forgetkas","jagritifrance","ffangoat",
    "1b0di","skyintriga","hey_carnival","qbe100","corgivr_yt","spidaboy1",
    "potatoswagcrea","batslc","kaiserflowss","ghostinthecosmosv2","yourprogenltor",
    "realwicky","ixoy","smallliuyt","lotus0yt","llvoidzz","j4y2e",
    "ghostinthecosmos","bugzbylee","s_supaa","therealpunchee","agamatsu",
    "ttvsmilezt_t","uncleyogu","jp55123","stayglide","imbenni","madecalm",
    "felineemu","xlayoox","pokeyyyxd","valekisyt","terrabl0x","mojayxy",
    "necaelum","bizarrelies","ltzakuu","lts_nin","hatetana","neckolauu","rvsaix",
    "najiswrldd","d_mlno","captinttbyt","revolverragz",
}

-- O(1) lookup sets.
local MOD_SET, YT_SET = {}, {}
for _, n in ipairs(DEFAULT_MODS)      do MOD_SET[n] = true end
for _, n in ipairs(DEFAULT_YOUTUBERS) do YT_SET[n]  = true end

-- Returns a reason string if `player` is a moderator, else nil.
local function isModerator(player)
    local nm = player.Name:lower()
    local list = getgenv().ModeratorList
    if type(list) == "table" then
        for _, n in ipairs(list) do
            if nm == tostring(n):lower() then return "Custom list" end
        end
    end
    if MOD_SET[nm] then return "Known moderator" end
    for _, k in ipairs({ "Mod","Moderator","Admin","Developer","Staff" }) do
        if player:GetAttribute(k) then return "Attribute: " .. k end
    end
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

-- Returns a reason string if `player` is a known YouTuber, else nil.
local function isYouTuber(player)
    local nm = player.Name:lower()
    local list = getgenv().YouTuberList
    if type(list) == "table" then
        for _, n in ipairs(list) do
            if nm == tostring(n):lower() then return "Custom list" end
        end
    end
    if YT_SET[nm] then return "Known YouTuber" end
    return nil
end

-- Detect + notify one player as a moderator. Returns true if matched.
local function flag(player)
    if player == Players.LocalPlayer then return false end
    local reason = isModerator(player)
    if reason then
        Notification.send("⚠ Moderator: " .. player.Name,
            "Reason: " .. reason, 8, Color3.fromRGB(255, 90, 90), "Safety")
        return true
    end
    return false
end
-- Detect + notify one player as a YouTuber. Returns true if matched.
local function flagYT(player)
    if player == Players.LocalPlayer then return false end
    local reason = isYouTuber(player)
    if reason then
        Notification.send("📹 YouTuber: " .. player.Name,
            "Reason: " .. reason, 8, Color3.fromRGB(120, 170, 255), "Safety")
        return true
    end
    return false
end

-- Gated auto-hook: flag joiners against whichever checks are enabled.
local function onJoin(player)
    if State and State.ModeratorChecker then flag(player) end
    if State and State.YouTuberChecker then flagYT(player) end
end

-- Scan every current player and report results (runs regardless of the toggles,
-- so the "Scan players now" button always gives feedback).
function ModeratorChecker.scanAll()
    local mods, yts = 0, 0
    for _, p in ipairs(Players:GetPlayers()) do
        if flag(p)   then mods = mods + 1 end
        if flagYT(p) then yts  = yts  + 1 end
    end
    if mods == 0 and yts == 0 then
        Notification.send("Server Scan", "No moderators or YouTubers found.",
            4, Color3.fromRGB(120, 200, 150), "Safety")
    else
        Notification.send("Server Scan",
            ("%d moderator(s), %d YouTuber(s) found."):format(mods, yts),
            4, Color3.fromRGB(120, 200, 150), "Safety")
    end
end

function ModeratorChecker.setEnabled(v)
    State.ModeratorChecker = v
    if v then
        for _, p in ipairs(Players:GetPlayers()) do flag(p) end
    end
end
function ModeratorChecker.setYouTuberEnabled(v)
    State.YouTuberChecker = v
    if v then
        for _, p in ipairs(Players:GetPlayers()) do flagYT(p) end
    end
end

function ModeratorChecker.init(state)
    State = state
    Conns.add(Players.PlayerAdded:Connect(onJoin))
    task.delay(1, function()
        for _, p in ipairs(Players:GetPlayers()) do onJoin(p) end
    end)
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

-- Notification categories -> the State flag that enables them (default on). A
-- notification tagged with a category is suppressed when its flag is false.
local CAT_KEY = { Toggle = "NotifToggles", Safety = "NotifSafety" }
function Notification.send(title, message, duration, color, category)
    if not State or not State.NotificationsEnabled then return end
    if category then local k = CAT_KEY[category]; if k and State[k] == false then return end end
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
local State, panel, lines, parent, debugGui

local function build()
    if not parent then return end   -- wait until the menu has set our parent
    -- A raw Frame parented to PlayerGui does NOT render — it needs a ScreenGui.
    debugGui = Instance.new("ScreenGui")
    debugGui.Name = "VVDebug"; debugGui.ResetOnSpawn = false
    debugGui.IgnoreGuiInset = true; debugGui.DisplayOrder = 999; debugGui.Parent = parent
    panel = Instance.new("Frame")
    panel.Name = "DebugPanel"
    panel.Size = UDim2.new(0, 240, 0, 160)
    panel.Position = UDim2.new(1, -260, 0, 60)
    panel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    panel.BackgroundTransparency = 0.4
    panel.BorderSizePixel = 0
    panel.Parent = debugGui
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
    if debugGui then pcall(function() debugGui:Destroy() end) end
    debugGui = nil; panel = nil; lines = nil
end

local frames, t0 = 0, tick()
local fps, lastDraw = 0, 0
local function tick_loop()
    frames = frames + 1
    local now = tick()
    if now - t0 >= 0.5 then fps = frames / (now - t0); frames = 0; t0 = now end
    if not State or not State.Debug then return end
    if not panel then build() end
    -- Only redraw the panel text twice a second (was every frame).
    if now - lastDraw < 0.5 then return end
    lastDraw = now
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
    Conns.add(RS.Heartbeat:Connect(tick_loop))
    Conns.onTeardown(destroy)
end

return Debug

end)
__bundle_register("Features/RemoteSpy", function(require, _LOADED, __bundle_register, __bundle_modules)
-- RemoteSpy ("Spyware"): logs RemoteEvent / RemoteFunction traffic so you can
-- see exactly what your client fires (and optionally what the server fires at
-- you). This is the same technique that captured the parry remote
--   ReplicatedStorage.Requests.Combat:FireServer("Block", true)
-- used by Features/Combat.
--
-- Two capture directions:
--   * "out" (Self)    — FireServer / InvokeServer your client sends. Caught via
--                       a single __namecall hook (installed once, _G-guarded so
--                       a Restart never stacks a second hook).
--   * "in"  (Enemies) — OnClientEvent the server fires at you. Caught by
--                       connecting to every RemoteEvent under ReplicatedStorage.
--
-- The UI lives in Menu/Main (Misc → Spyware). This module only owns the hooks,
-- the log, and the pause/clear/filter state.
local Players = game:GetService("Players")
local RS      = game:GetService("ReplicatedStorage")
local Conns   = require("Utility/Conns")

local RemoteSpy = {}
local State

local MAX_ENTRIES = 250        -- ring buffer cap (oldest dropped past this)

local log     = {}             -- ordered array of entries (oldest first)
local byKey   = {}             -- "dir\1path\1method" -> entry (dedup/aggregate)
local updateCb                 -- optional UI refresh callback
local version = 0              -- bumped on any change; UI polls this

-- Incoming (OnClientEvent) listeners, kept so we can detach on disable.
local incomingConns  = {}      -- remote -> RBXScriptConnection
local incomingScan             -- DescendantAdded watcher

-- Executor capability check. Without these, outgoing capture is impossible.
local hasHook = (type(hookmetamethod) == "function")
    and (type(getnamecallmethod) == "function")

local function notify(...) if _G.__Notify then _G.__Notify(...) end end

--========================================================
-- Serialization (safe, bounded — never let a weird arg error the hook).
--========================================================
local function fullName(inst)
    local ok, n = pcall(function() return inst:GetFullName() end)
    if ok and n then return n end
    return tostring(inst)
end

local function short(s, n)
    n = n or 60; s = tostring(s)
    if #s > n then return s:sub(1, n) .. "…" end
    return s
end

local function ser(v, depth)
    depth = depth or 0
    local t = typeof(v)
    if t == "Instance" then return fullName(v)
    elseif t == "string" then return '"' .. short(v) .. '"'
    elseif t == "number" or t == "boolean" then return tostring(v)
    elseif t == "nil" then return "nil"
    elseif t == "Vector3" then return ("Vector3(%.1f, %.1f, %.1f)"):format(v.X, v.Y, v.Z)
    elseif t == "CFrame" then local p = v.Position
        return ("CFrame(%.1f, %.1f, %.1f)"):format(p.X, p.Y, p.Z)
    elseif t == "table" then
        if depth >= 2 then return "{...}" end
        local parts, i = {}, 0
        for k, val in pairs(v) do
            i = i + 1; if i > 6 then parts[#parts + 1] = "…"; break end
            parts[#parts + 1] = tostring(k) .. "=" .. ser(val, depth + 1)
        end
        return "{" .. table.concat(parts, ", ") .. "}"
    else return t end
end

local function argstr(args, n)
    local parts = {}
    for i = 1, n do parts[i] = ser(args[i]) end
    return table.concat(parts, ", ")
end

--========================================================
-- Log recording.
--========================================================
-- Capturing is live only when the master switch is on and not paused.
local function active() return State and State.Spyware and not State.SpyPaused end

local function record(dir, remote, method, args, n)
    if not remote then return end
    local path = fullName(remote)
    local key  = dir .. "\1" .. path .. "\1" .. method
    local e = byKey[key]
    if not e then
        e = { key = key, remote = remote, name = remote.Name, path = path,
              class = remote.ClassName, dir = dir, method = method, count = 0 }
        byKey[key] = e
        table.insert(log, e)
        if #log > MAX_ENTRIES then
            local rm = table.remove(log, 1)
            if rm then byKey[rm.key] = nil end
        end
    end
    e.count    = e.count + 1
    e.lastArgs = argstr(args, n)
    e.lastTime = os.clock()
    version = version + 1
    if updateCb then pcall(updateCb) end
end

--========================================================
-- Outgoing capture: ONE __namecall hook, installed once per executor session.
-- The actual recording goes through _G.__VVSpyRecord, swapped each run, so a
-- Restart updates behaviour without ever stacking a second metamethod hook.
--========================================================
_G.__VVSpyRecord = function(self, ...)
    if not (active() and State.SpySelf) then return end
    if typeof(self) ~= "Instance" then return end
    local method = getnamecallmethod()
    if method ~= "FireServer" and method ~= "InvokeServer" then return end
    local cls = self.ClassName
    if cls == "RemoteEvent" or cls == "RemoteFunction"
        or cls == "UnreliableRemoteEvent" then
        record("out", self, method, { ... }, select("#", ...))
    end
end

local function installHook()
    if not hasHook or _G.__VVSpyInstalled then return end
    _G.__VVSpyInstalled = true
    local old
    old = hookmetamethod(game, "__namecall", function(self, ...)
        local cb = _G.__VVSpyRecord
        if cb then pcall(cb, self, ...) end   -- pcall: a logging error must never break the game
        return old(self, ...)
    end)
end

--========================================================
-- Incoming capture: connect OnClientEvent on every RemoteEvent in
-- ReplicatedStorage (where this game keeps its Requests). Only the gate
-- State.SpyEnemies decides whether the callback actually records.
--========================================================
local function attachIncoming(remote)
    if incomingConns[remote] then return end
    if remote.ClassName == "RemoteEvent" or remote.ClassName == "UnreliableRemoteEvent" then
        local c = remote.OnClientEvent:Connect(function(...)
            if active() and State.SpyEnemies then
                record("in", remote, "OnClientEvent", { ... }, select("#", ...))
            end
        end)
        incomingConns[remote] = c
        Conns.add(c)
    end
end

local function startIncoming()
    if incomingScan then return end
    for _, d in ipairs(RS:GetDescendants()) do
        if d:IsA("RemoteEvent") or d:IsA("UnreliableRemoteEvent") then attachIncoming(d) end
    end
    incomingScan = RS.DescendantAdded:Connect(function(d)
        if d:IsA("RemoteEvent") or d:IsA("UnreliableRemoteEvent") then attachIncoming(d) end
    end)
    Conns.add(incomingScan)
end

local function stopIncoming()
    for _, c in pairs(incomingConns) do pcall(function() c:Disconnect() end) end
    incomingConns = {}
    if incomingScan then pcall(function() incomingScan:Disconnect() end); incomingScan = nil end
end

--========================================================
-- Public API.
--========================================================
function RemoteSpy.setEnabled(v)
    State.Spyware = v
    if v then
        if not hasHook then
            notify("Spyware", "This executor has no hookmetamethod — outgoing capture unavailable.",
                4, Color3.fromRGB(245, 100, 110))
        else
            installHook()
        end
        if State.SpyEnemies then startIncoming() end
    else
        stopIncoming()
    end
end

function RemoteSpy.setPaused(v) State.SpyPaused = v end
function RemoteSpy.setSelf(v)   State.SpySelf   = v end

function RemoteSpy.setEnemies(v)
    State.SpyEnemies = v
    if v then
        if State.Spyware then startIncoming() end
    else
        stopIncoming()
    end
end

function RemoteSpy.clear()
    log = {}; byKey = {}; version = version + 1
    if updateCb then pcall(updateCb) end
end

function RemoteSpy.getLog()      return log end
function RemoteSpy.getVersion()  return version end
function RemoteSpy.onUpdate(fn)  updateCb = fn end
function RemoteSpy.supported()   return hasHook end

function RemoteSpy.init(state)
    State = state
    -- A persisted-on state is re-applied from Menu/Main after Settings restore,
    -- so we don't enable here (State isn't restored yet at init time).
end

return RemoteSpy

end)
__bundle_register("Features/Combat", function(require, _LOADED, __bundle_register, __bundle_modules)
-- AutoParry — minimal core (mirrors the deepwoken / type-soul reference model):
--   * Hook every enemy Humanoid's AnimationPlayed.
--   * If the animation id has a saved timing (parrytimings.json — YOUR timings),
--     watch the track's TimePosition and press M2 exactly at that frame.
--   * Ping-compensated and AdjustSpeed-proof (lead scales with track.Speed).
--
-- Filters (the only options): Range, Nearest Target Only, Players Only,
-- Parry While Tabbed Out. Nothing else.
local RunService = game:GetService("RunService")
local Players    = game:GetService("Players")
local UIS        = game:GetService("UserInputService")
local VIM        = game:GetService("VirtualInputManager")
local RS         = game:GetService("ReplicatedStorage")
local LP         = Players.LocalPlayer
local getCharParts = require("Utility/Char")
local Conns        = require("Utility/Conns")
local Humanoids    = require("Utility/Humanoids")
local Notification = require("Features/Notification")
local Settings     = require("Utility/Settings")
local Latency      = require("Utility/Latency")   -- ping lead (so parries LAND on time)

local Combat = {}
local State

local pending = {}              -- track -> { animId, char, events={ {at,fired} } }
_G.__AutoParryActive = pending

local DEBOUNCE   = 0.10         -- min seconds between two presses (anti double-fire)
local HITSTUN    = 0.25         -- ignore window right after taking damage
local HOLD       = 0.02         -- M2 tap length (input-sim fallback only)
local lastFire, hitstunUntil = 0, 0
-- For repeat-on-miss: remember the most recent parry attempt.
local lastParry = { track = nil, t = 0, count = 0 }
-- Shared by BOTH reaction systems (animation-timing + Hitbox Range) so they
-- never double-fire a block/dodge for the same incoming hit.
local lastReactT = 0
local REACT_CD   = 0.15         -- min seconds between cross-system reactions

--========================================================
-- Input / Block
--
-- VV Ultimatum performs a block by firing ONE remote with a string action:
--   ReplicatedStorage.Requests.Combat:FireServer("Block", true)   -- start
--   ReplicatedStorage.Requests.Combat:FireServer("Block", false)  -- release
-- (captured live via a __namecall spy). We fire that remote directly, exactly
-- like the deepwoken reference fires its own Block remote — so it is
-- REBIND-PROOF: it works no matter what key the player has block bound to.
--========================================================

-- Cached remote lookup (re-resolves if the instance is replaced).
local _combatRemote
local function combatRemote()
    if _combatRemote and _combatRemote.Parent then return _combatRemote end
    local req = RS:FindFirstChild("Requests")
    _combatRemote = req and req:FindFirstChild("Combat") or nil
    return _combatRemote
end

-- Input-simulation fallback (only used if the remote can't be found).
local function pressM2Fallback()
    if mouse2press and mouse2release then
        pcall(function() mouse2press(); task.wait(HOLD); mouse2release() end); return
    end
    pcall(function()
        local m = LP:GetMouse()
        local x, y = m.X or 0, m.Y or 0
        VIM:SendMouseButtonEvent(x, y, 1, true, game, 0)
        task.delay(HOLD, function()
            pcall(function() VIM:SendMouseButtonEvent(x, y, 1, false, game, 0) end)
        end)
    end)
end

-- Fire the game's block: start, hold, release. The hold must be long enough to
-- still be active when the hit lands (the hit arrives ~150-240ms after we fire
-- at typical ping; a 150ms hold released too early and we ate the hit).
local function fireBlock()
    local r = combatRemote()
    if not r then pressM2Fallback(); return end
    _G.__VVBlockFired = os.clock()      -- mark: this block is OURS (Player Timing skips it)
    pcall(function() r:FireServer("Block", true) end)
    -- High Ping Mode: hold the block longer (by ~your round-trip ping) so it's
    -- still active when a jittery high-ping hit actually lands.
    local hold = State.BlockHold or 0.35
    if State.HighPing then hold = hold + (Latency.rtt() or 0) end
    task.delay(hold, function()
        local r2 = combatRemote()
        if r2 then pcall(function() r2:FireServer("Block", false) end) end
    end)
end

-- FEINT: VV cancels your in-progress swing with Requests.Combat:FireServer("Feint")
-- (captured live — the game fires this itself when you press block mid-swing).
-- We track the local swing so we only feint at the BEGINNING of it.
local localSwing = { track = nil, t = 0 }   -- most recent non-looped local anim
local function fireFeint()
    local r = combatRemote()
    if r then pcall(function() r:FireServer("Feint") end) end
end
-- True if we are early enough in a local swing that feinting still cancels it.
local function midSwingBeginning(now)
    local s = localSwing
    if not (s.track and s.track.IsPlaying) then return false end
    return (now - s.t) <= (State.FeintWindow or 0.25)
end

-- Perform a parry: feint first if we're mid-swing (and the option is on), then block.
local function doParry(now)
    if State.Feint and midSwingBeginning(now) then
        fireFeint()           -- cancel our swing so the block can come out
    end
    fireBlock()
end
-- Back-compat alias (older call sites).
local pressM2 = fireBlock

--========================================================
-- DODGE — animations with a saved DODGE timing make us DASH instead of block.
-- VV's dash is a RemoteFunction:
--   ReplicatedStorage.Requests.Dash:InvokeServer("LookVector", <deg>)
-- where <deg> is the horizontal angle to rotate the character's look by to get
-- the dash direction (0 = forward, +90 = left, -90 = right, 180 = back).
-- We dash in the player's CURRENT movement direction (where WASD is held), so
-- pressing A dashes left, D right, S back, etc. If no direction is held we dodge
-- BACKWARD (never straight forward).
--========================================================
local _dashRemote
local function dashRemote()
    if _dashRemote and _dashRemote.Parent then return _dashRemote end
    local req = RS:FindFirstChild("Requests")
    _dashRemote = req and req:FindFirstChild("Dash") or nil
    return _dashRemote
end
local function fireDodge()
    local r = dashRemote(); if not r then return end
    local char = LP.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    local hum  = char and char:FindFirstChildWhichIsA("Humanoid")
    if not (hrp and hum) then return end
    -- Reference look (the character's facing), flattened to the ground plane.
    local look = hrp.CFrame.LookVector
    look = Vector3.new(look.X, 0, look.Z)
    if look.Magnitude < 1e-3 then return end
    look = look.Unit
    -- Desired dash direction = where the player is actually moving (WASD).
    local move = hum.MoveDirection
    move = Vector3.new(move.X, 0, move.Z)
    local deg
    if move.Magnitude < 0.1 then
        deg = 180                                    -- not moving -> dodge backward
    else
        move = move.Unit
        -- Signed horizontal angle from look -> move (about the Y axis).
        deg = math.deg(math.atan2(look:Cross(move).Y, look:Dot(move)))
    end
    -- InvokeServer yields for the server reply; run it off the Heartbeat thread.
    task.spawn(function() pcall(function() r:InvokeServer("LookVector", deg) end) end)
end

--========================================================
-- Helpers / filters
--========================================================
local function rootOf(char)
    return char and (char:FindFirstChild("HumanoidRootPart")
        or char:FindFirstChildWhichIsA("BasePart"))
end

--========================================================
-- Entity history (deepwoken's EntityHistory, trimmed). Per attacking enemy we
-- keep a short ring of {t, yaw, cf} samples — recorded only while their attack is
-- pending, so it's cheap and bounded. Powers facing PREDICTION (how fast they're
-- turning) and hitbox INTERPOLATION (test their recent past positions too).
--========================================================
local hist = setmetatable({}, { __mode = "k" })  -- char -> { s = {samples}, head }
local HIST_LEN = 8
local function recordHistory(char, now)
    local r = rootOf(char); if not r then return end
    local h = hist[char]
    if not h then h = { s = {}, head = 0 }; hist[char] = h end
    h.head = (h.head % HIST_LEN) + 1
    local lv = r.CFrame.LookVector
    h.s[h.head] = { t = now, yaw = math.atan2(lv.X, lv.Z), cf = r.CFrame }
end
-- Turn rate (rad/s) from the newest sample vs one ~0.05-0.3s older.
local function yawRate(char)
    local h = hist[char]; if not h then return 0 end
    local latest = h.s[h.head]; if not latest then return 0 end
    local prev
    for _, sm in pairs(h.s) do
        local age = latest.t - sm.t
        if sm ~= latest and age >= 0.05 and age <= 0.3 then
            if not prev or sm.t > prev.t then prev = sm end
        end
    end
    if not prev then return 0 end
    local dy = latest.yaw - prev.yaw
    while dy >  math.pi do dy = dy - 2 * math.pi end
    while dy < -math.pi do dy = dy + 2 * math.pi end
    local dt = latest.t - prev.t
    return dt > 0 and (dy / dt) or 0
end

-- Distance gate. Uses this animation's PER-ATTACK range (deepwoken imdd/imxd) if
-- one is saved for it, otherwise the global Detection Range.
local function inRange(char, animId)
    local r = rootOf(char)
    local _, me = getCharParts()
    if not (r and me) then return false end
    local d = (r.Position - me.Position).Magnitude
    local rng = animId and _G.__ParryRanges and _G.__ParryRanges[animId]
    if rng then return d >= (rng.min or 0) and d <= (rng.max or 1e9) end
    return d <= (State.DetectionRange or 18)
end
-- Hitbox prediction — ported from the reference (Defender.hitbox + HitboxOptions):
--   * Build the attack hitbox at the attacker's root CFrame, pushed forward by
--     half its depth: usedCFrame = root.CFrame * CFrame.new(0,0,-Z/2).
--   * Test workspace:GetPartBoundsInBox against our character (are we inside it?).
--   * If spredict and the current box misses, repeat at the EXTRAPOLATED position
--     root.CFrame + root.AssemblyLinearVelocity * ptime  (where will they be when
--     the hit lands). ptime mirrors their fsecs(): 0.15 + ping.
-- We can't pull their per-animation hitbox *sizes* (those live in their Modules),
-- so the box is a cube of Detection Range on every side — the single distance
-- value that also drives the proximity gate, so detection and hitbox can't differ.
local function boxHitsMe(cf, size)
    local myChar = LP.Character
    if not myChar then return false end
    local used = cf * CFrame.new(0, 0, -(size.Z / 2))   -- forward-depth box
    local op = OverlapParams.new()
    op.FilterType = Enum.RaycastFilterType.Exclude       -- robust across executors
    op.FilterDescendantsInstances = {}
    local parts = workspace:GetPartBoundsInBox(used, size, op)
    for _, p in ipairs(parts) do
        if p:IsDescendantOf(myChar) then return true end
    end
    return false
end
local function hitboxCheck(char)
    local r = char:FindFirstChild("HumanoidRootPart") or rootOf(char)
    if not r then return false end
    local R    = State.DetectionRange or 18
    local size = Vector3.new(R, R, R)                     -- width, height, forward reach (all = Detection Range)
    if boxHitsMe(r.CFrame, size) then return true end     -- current position
    -- Predicted position (reference fsecs ~= 0.15 + ping).
    local ptime = 0.15 + (Latency.rtt() or 0)
    if boxHitsMe(r.CFrame + r.AssemblyLinearVelocity * ptime, size) then return true end
    -- History interpolation (deepwoken phd): also test their recent past CFrames,
    -- so a fast-moving attacker or a laggy frame doesn't slip past the box.
    if State.HitboxHistory ~= false then
        local h = hist[char]
        if h then for _, sm in pairs(h.s) do if boxHitsMe(sm.cf, size) then return true end end end
    end
    return false
end
local function isPlayerChar(char)
    return Players:GetPlayerFromCharacter(char) ~= nil
end
-- A "mob" = an enemy that is NOT a player and NOT a dialogue/quest NPC.
-- NPCs are identified the same way ESP does: a ProximityPrompt, an "NPC"
-- attribute, or an IsNPC child (e.g. Village Guards).
local function isNpcChar(char)
    if char:GetAttribute("NPC") or char:FindFirstChild("IsNPC") then return true end
    for _, d in ipairs(char:GetDescendants()) do
        if d:IsA("ProximityPrompt") then return true end
    end
    return false
end
local function isMobChar(char)
    return not isPlayerChar(char) and not isNpcChar(char)
end
-- True if the attacker is roughly facing us (their front points our way).
-- Uses a ~70° cone on the horizontal plane. If we can't tell, allow it.
local function isFacingMe(char)
    local r = rootOf(char)
    local _, me = getCharParts()
    if not (r and me) then return true end
    local to = me.Position - r.Position
    to = Vector3.new(to.X, 0, to.Z)
    if to.Magnitude < 0.1 then return true end
    to = to.Unit
    local look = r.CFrame.LookVector
    look = Vector3.new(look.X, 0, look.Z)
    if look.Magnitude < 0.01 then return true end
    look = look.Unit
    local dot = State.FacingDot or 0.35
    if look:Dot(to) >= dot then return true end
    -- Facing PREDICTION (deepwoken pfh): if they're turning, predict where they'll
    -- be aimed when the hit lands and accept that too — catches spins / turn-ins.
    if State.FacingPredict ~= false then
        local rate = yawRate(char)
        if math.abs(rate) > 0.25 then
            local lead = (Latency.rtt() or 0) + 0.12
            local yaw  = math.atan2(look.X, look.Z) + rate * lead
            if Vector3.new(math.sin(yaw), 0, math.cos(yaw)):Dot(to) >= dot then return true end
        end
    end
    return false
end
-- A character is a valid parry target THIS INSTANT only if it passes EVERY
-- active filter. Each filter is an independent AND-gate, so stacking them never
-- ruins another — e.g. Players Only + Hitbox = only parry a PLAYER whose ATTACK
-- hitbox you're standing in.
--   * Players Only / Mobs Only : type filter
--   * Facing Me                : the attacker's front points at you
--   * Hitbox Prediction        : you're inside their ATTACK hitbox (the forward
--                                box ESP draws while they swing). This REFINES
--                                the Detection Range gate (which ALWAYS applies)
--                                — it never widens it, so attacks beyond
--                                Detection Range are always ignored.
-- Nearest Only is applied separately (it picks the nearest target that already
-- passes everything here — so "nearest" means nearest *valid* target).
local function targetOk(char, animId)
    if State.ParryPlayersOnly and not isPlayerChar(char) then return false end
    if State.ParryMobsOnly    and not isMobChar(char)    then return false end
    if State.ParryFacingMe    and not isFacingMe(char)   then return false end
    -- HARD outer wall: never react beyond range — this attack's PER-ATTACK range
    -- if it has one saved, else the global Detection Range. Applies in BOTH modes.
    if not inRange(char, animId) then return false end
    -- Hitbox Prediction only REFINES within that range: you must also be inside
    -- the attacker's forward attack box (itself sized to Detection Range).
    if State.HitboxPredict then return hitboxCheck(char) end
    return true
end

-- Nearest VALID target (one that already passes targetOk), so Nearest Only
-- stacks cleanly with Players/Mobs/Facing/Hitbox instead of fighting them.
local function nearestTarget()
    local _, me = getCharParts(); if not me then return nil end
    local best, bd
    for _, s in pairs(pending) do
        local c = s.char
        if c and targetOk(c, s.animId) then
            local r = rootOf(c)
            if r then
                local d = (r.Position - me.Position).Magnitude
                if not bd or d < bd then bd = d; best = c end
            end
        end
    end
    return best
end

-- Never parry while the Roblox window is unfocused (unless allowed).
local windowFocused = true
Conns.add(UIS.WindowFocused:Connect(function() windowFocused = true end))
Conns.add(UIS.WindowFocusReleased:Connect(function() windowFocused = false end))

--========================================================
-- Timings (YOUR saved timings)
--========================================================
local function getTimes(animId)
    local pt = _G.__ParryTimings
    return (pt and pt.getTimes and pt.getTimes(animId)) or {}
end
local function getDodges(animId)
    local pt = _G.__ParryTimings
    return (pt and pt.getDodges and pt.getDodges(animId)) or {}
end

local function plan(track, char, animId)
    if pending[track] then return end
    local apd = _G.__AutoParryData
    if apd and apd.notePlay then apd.notePlay(animId) end
    -- One event per DISTINCT timing (collapse near-duplicates within 10ms) so we
    -- act exactly once per timing: once for a single-timing attack, and once on
    -- EACH timing for a multi-hit attack — never twice for the same one.
    -- Parry timings BLOCK; dodge timings DASH (kind tags which to do).
    local events = {}
    local function addEvents(list, kind)
        for _, sec in ipairs(list) do
            sec = math.max(sec, 0)
            local dup = false
            for _, ev in ipairs(events) do
                if ev.kind == kind and math.abs(ev.at - sec) < 0.01 then dup = true; break end
            end
            if not dup then events[#events+1] = { at = sec, fired = false, kind = kind } end
        end
    end
    addEvents(getTimes(animId),  "parry")
    addEvents(getDodges(animId), "dodge")
    if #events == 0 then return end          -- no saved timing -> ignore
    pending[track] = { animId = animId, char = char, events = events }
    local stopConn
    stopConn = track.Stopped:Connect(function()
        pending[track] = nil
        if stopConn then stopConn:Disconnect() end
    end)
    Conns.add(stopConn)
end

--========================================================
-- Smart Hit: while a REAL parry is about to fire (a tracked enemy attack is within
-- `window` track-seconds of its timing AND passes the target filters), cancel our
-- own swing so we don't whiff into it. Weak-keyed so each swing is feinted once.
--========================================================
local smartFeinted = setmetatable({}, { __mode = "k" })
-- Smallest track-time until a REAL upcoming parry fires (nil if none imminent).
-- Powers Auto Feint's timing (Passive/Aggressive + Delayed).
local function imminentParryDt(now, lead)
    local best
    for track, s in pairs(pending) do
        if track and track.IsPlaying then
            local spd    = (track.Speed and track.Speed > 0) and track.Speed or 1
            local predTP = track.TimePosition + lead / spd
            for _, ev in ipairs(s.events) do
                if ev.kind ~= "dodge" and not ev.fired then
                    local dt = ev.at - predTP            -- track-time until this parry fires
                    if dt >= -0.05 and targetOk(s.char, s.animId) and (not best or dt < best) then
                        best = dt
                    end
                end
            end
        end
    end
    return best
end

--========================================================
-- deepwoken extras: AP-breaker filter + Repeat-Until-Parry-End (failure
-- simulation is inline in the fire tick below).
--========================================================
-- A track that looks like an AP-breaker bait: a barely-weighted "fake" animation,
-- or one spoofed to an abnormal playback speed to blow through the timing.
local function looksSpoofed(track)
    if not track then return false end
    if (track.WeightTarget or 1) <= 0.08 then return true end
    if (track.Speed or 1) >= (State.APBreakerSpeed or 6) then return true end
    return false
end
-- Repeat Until Parry End: after the first parry, keep re-blocking every interval
-- while the same attack track is still playing (deepwoken's RPUE) — so a drawn-out
-- or multi-hit attack stays blocked. One loop per track; stops if you move out.
local rpueActive = setmetatable({}, { __mode = "k" })
local function startRPUE(track, char, animId)
    if rpueActive[track] then return end
    rpueActive[track] = true
    task.spawn(function()
        local t0 = os.clock()
        while track.IsPlaying and (os.clock() - t0) < 5 do
            task.wait((State.RPUEInterval or 200) / 1000)
            if not (track.IsPlaying and State.AutoParry and State.RPUE) then break end
            if targetOk(char, animId) then
                doParry(os.clock())
                lastReactT = os.clock()
            end
        end
        rpueActive[track] = nil
    end)
end

--========================================================
-- Fire tick — compares the track's OWN TimePosition to your saved timing,
-- so the parry lands on the exact saved frame regardless of playback speed.
--========================================================
-- Forward declaration: the SEPARATE projectile-defender loop (added after this
-- one) references updateProjWatch, which is defined further below; without this
-- forward local the name would bind to a nil global and throw.
local updateProjWatch
-- AUTO PARRY — animation-timing ONLY. Fully independent of the projectile
-- (Hitbox Range) system, which runs in its own loop below. This loop never
-- touches projectile state and the projectile loop never touches this one.
Conns.add(RunService.Heartbeat:Connect(function()
    if not State or not State.AutoParry then return end
    local now = os.clock()
    if not windowFocused and not State.ParryWhenUnfocused then return end
    if now < hitstunUntil then return end

    -- Lead the parry by your round-trip ping (so the block reaches the server in
    -- time — without this, parries fire too late at any real ping and miss) plus
    -- your manual Timing Offset. This is internal AutoParry timing, not a toggle.
    local lead = (Latency.rtt() or 0) + (State.TimingOffset or 0)
    -- High Ping Mode: press a touch earlier (a fraction of ping) so the block is
    -- already up if jitter makes the hit arrive early; the longer block hold
    -- covers it arriving late.
    if State.HighPing then lead = lead + (Latency.rtt() or 0) * 0.25 end
    local nearest = State.ParryNearestOnly and nearestTarget() or nil

    for track, s in pairs(pending) do
        if not track or not track.IsPlaying then
            pending[track] = nil
        else
            recordHistory(s.char, now)   -- feed facing-prediction + hitbox history
            -- AnimatorDefender:tp() — predicted time position:
            --   TimePosition + (offset + lead) / Speed
            local spd     = (track.Speed and track.Speed > 0) and track.Speed or 1
            local predTP  = track.TimePosition + lead / spd
            for _, ev in ipairs(s.events) do
                -- Fire once the predicted position has crossed the keyframe.
                -- ev.fired makes each timing fire EXACTLY ONCE; there's no global
                -- cooldown, so a multi-timing animation still parries on every
                -- timing even when two are close together.
                if not ev.fired and predTP >= ev.at then
                    if targetOk(s.char, s.animId)
                       and (not State.ParryNearestOnly or s.char == nearest)
                       and not (ev.kind == "dodge" and State.AutoDodge == false) then
                        if (State.APBreaker and looksSpoofed(track))
                           or (State.FailSim and math.random(100) <= (State.FailRate or 0)) then
                            ev.fired = true     -- skip: AP-breaker bait / intentional human miss
                        else
                            if ev.kind == "dodge" then fireDodge() else doParry(now) end
                            ev.fired = true
                            lastFire = now
                            lastReactT = now            -- shared with Hitbox Range (anti double-fire)
                            lastParry.track, lastParry.t, lastParry.count = track, now, 0
                            _G.__lastParry = string.format("%s %s set=%dms lead=%dms @%dms",
                                ev.kind or "parry", s.animId, math.floor(ev.at * 1000),
                                math.floor(lead * 1000), math.floor(track.TimePosition * 1000))
                            if State.RPUE and ev.kind ~= "dodge" then startRPUE(track, s.char, s.animId) end
                        end
                    end
                end
            end
        end
    end

    -- Auto Feint (deepwoken-style): while you're mid-swing and a REAL parry is
    -- coming, feint your swing so you don't whiff into it (AutoParry still blocks
    -- at its own timing). Outside a window your swings go through normally.
    --   Passive    — only feint if the enemy hit would land BEFORE your swing
    --                ends (lets safe swings finish, like deepwoken's Passive).
    --   Aggressive — always feint as soon as the window opens.
    --   Delayed Feints — hold the feint to the last moment instead of early.
    if State.SmartHit then
        local sw = localSwing
        if sw.track and sw.track.IsPlaying and not smartFeinted[sw.track] then
            local dt = imminentParryDt(now, lead)
            if dt then
                local window  = State.SmartHitWindow or 0.25
                local trigger = State.DelayedFeints and math.min(0.06, window) or window
                local within  = dt <= trigger and dt >= -0.05
                local pass = true
                if State.AutoFeintType == "Passive" then
                    local spd = (sw.track.Speed and sw.track.Speed > 0) and sw.track.Speed or 1
                    local swingLeft = (sw.track.Length - sw.track.TimePosition) / spd
                    pass = dt < swingLeft   -- enemy lands before our swing ends
                end
                if within and pass then
                    fireFeint()
                    smartFeinted[sw.track] = true
                end
            end
        end
    end
end))

-- PROJECTILE HITBOX PARRY — its OWN loop, fully independent of AutoParry above.
-- Watches only the saved/captured projectiles and reacts the instant one enters
-- your hitbox, using ONLY its own ranges/delays (never AutoParry's Detection
-- Range or animation timings). Runs whenever Hitbox Range mode is on, regardless
-- of the AutoParry toggle. (lastReactT is shared purely to avoid a double-block
-- if an animation parry and a projectile parry coincide.)
Conns.add(RunService.Heartbeat:Connect(function()
    if State and State.HitboxRangeMode then updateProjWatch(os.clock()) end
end))

--========================================================
-- ESP attack-hitbox tracker
--
-- Records which enemies are CURRENTLY mid-attack, and whether the swing is a
-- Critical, so Visuals can draw the parry hitbox box ONLY while they're actually
-- attacking — green for normal/M1 swings, red for criticals. This runs no matter
-- whether AutoParry is on, so the ESP "Show Hitboxes" option works on its own.
--========================================================
local attacking = setmetatable({}, { __mode = "k" })   -- char -> { n=int, crit=int }
function Combat.attackInfo(char)
    local r = attacking[char]
    if not r then return nil end
    return { critical = (r.crit or 0) > 0 }
end
_G.__AttackInfo = Combat.attackInfo

-- Is this animation an attack we should draw a box for? Saved timing, a learned
-- attack, or a name that categorises as a swing all count.
local function isAttackAnim(animId, cat)
    if #getTimes(animId) > 0 then return true end
    local apd = _G.__AutoParryData
    if apd and apd.isAttack and apd.isAttack(animId) then return true end
    return cat == "M1" or cat == "Critical" or cat == "Heavy"
end
local function noteAttackVisual(owner, track, animId)
    local av  = _G.__AnimViz
    local cat = (av and av.categoryOf and av.categoryOf(animId)) or "Other"
    if not isAttackAnim(animId, cat) then return end
    local wasCrit = (cat == "Critical")
    local rec = attacking[owner]
    if not rec then rec = { n = 0, crit = 0 }; attacking[owner] = rec end
    rec.n = rec.n + 1
    if wasCrit then rec.crit = rec.crit + 1 end
    local stopConn
    stopConn = track.Stopped:Connect(function()
        local r = attacking[owner]
        if r then
            r.n = r.n - 1
            if wasCrit then r.crit = math.max(0, r.crit - 1) end
            if r.n <= 0 then attacking[owner] = nil end
        end
        if stopConn then stopConn:Disconnect() end
    end)
    Conns.add(stopConn)
end

--========================================================
-- Hook enemy humanoids + non-humanoid rigs + local hit-stun
--========================================================
--========================================================
-- HITBOX RANGE — projectile defender (ported from deepwoken's PartDefender).
--
-- We match incoming projectiles by PART NAME (or an ancestor's name) against a
-- saved set (_G.__ProjectileNames, seeded with Type Soul's Cero). Only matched
-- parts are watched, so the thousands of unrelated Debris effects cost nothing.
-- A watched part reacts ONCE the moment its (inflated) hitbox touches you —
-- "delay until in hitbox", exactly like the reference.
--========================================================
local projWatch = {}            -- BasePart -> spawn os.clock()
local projConn                  -- Debris DescendantAdded (only while mode on)
local PROJ_TTL = 8              -- seconds before a watched part is dropped

-- True if the part, or one of its first 3 ancestors, is a named projectile.
local function matchProjectileName(part)
    local set = _G.__ProjectileNames
    if not set then return false end
    if set[part.Name] then return true end
    local p = part.Parent
    for _ = 1, 3 do
        if not p or p == workspace then break end
        if set[p.Name] then return true end
        p = p.Parent
    end
    return false
end
-- DescendantAdded handler (connected only while the mode is on). Two ways a part
-- gets watched:
--   * NAMED   — its name (or an ancestor's) is in the capture list. Trusted: reacts
--               the instant its box reaches you (no motion proof needed).
--   * AUTO    — name-agnostic. ANY newly-spawned part of plausible projectile size
--               is watched; updateProjWatch only reacts once it PROVES it's a real
--               projectile (it has travelled and is approaching you). This is what
--               lets us catch new abilities WITHOUT having their name in the list.
local function biggestAxis(sz) return math.max(sz.X, sz.Y, sz.Z) end
local function considerProjectile(part)
    if not part:IsA("BasePart") then return end
    if projWatch[part] then return end
    local named = matchProjectileName(part)
    if not named then
        if not State.HitboxAutoDetect then return end
        -- Skip tiny particles (sparks/blood/embers) and oversized terrain chunks —
        -- real projectiles sit between these bounds. NOTE: Type Soul ceros can be
        -- ~100 studs, so the upper bound is deliberately high (see HitboxAutoMaxAxis).
        local a = biggestAxis(part.Size)
        if a < (State.HitboxAutoMinAxis or 1.2) or a > (State.HitboxAutoMaxAxis or 130) then return end
    end
    -- Distance requirement: only watch a projectile that APPEARS at least
    -- HitboxMinDist studs away — so local melee-effect particles (which spawn
    -- right on you) are ignored. 0 = off. Tunable in the Hitbox Range menu.
    local minD = State.HitboxMinDist or 0
    if minD > 0 then
        local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if hrp and (part.Position - hrp.Position).Magnitude < minD then return end
    end
    projWatch[part] = { t0 = os.clock(), lastPos = part.Position, lastDist = math.huge, moved = 0, named = named }
end
local function connectProjectiles()
    if projConn then return end
    local src = workspace:FindFirstChild("Debris") or workspace
    projConn = Conns.add(src.DescendantAdded:Connect(considerProjectile))
end

-- Per-tick: for each watched projectile, react ONCE its (inflated) box touches us.
local _projOP = OverlapParams.new()
_projOP.FilterType = Enum.RaycastFilterType.Include
local _projChar
function updateProjWatch(now)
    if not windowFocused and not State.ParryWhenUnfocused then return end
    local myChar = LP.Character
    if not myChar then return end
    if _projChar ~= myChar then _projOP.FilterDescendantsInstances = { myChar }; _projChar = myChar end
    local myHrp = myChar:FindFirstChild("HumanoidRootPart")
    local myPos = myHrp and myHrp.Position
    local doDodge = State.HitboxRangeDodge and (State.HitboxRangeParry == false)
    local m = doDodge and (State.HitboxDodgeRange or 25) or (State.HitboxParryRange or 25)
    local inflate = Vector3.new(m * 2, m * 2, m * 2)
    for part, rec in pairs(projWatch) do
        if not part.Parent or (now - rec.t0) > PROJ_TTL then
            projWatch[part] = nil
        else
            -- Motion bookkeeping (used by AUTO parts to prove they're real projectiles).
            if myPos then
                local d = (part.Position - myPos).Magnitude
                rec.moved = rec.moved + (part.Position - rec.lastPos).Magnitude
                rec.approaching = d < (rec.lastDist - 0.15)
                rec.lastPos = part.Position; rec.lastDist = d
            end
            -- NAMED parts are trusted immediately; AUTO parts must have travelled and
            -- be currently approaching before we'll treat them as an incoming threat.
            local eligible = rec.named or (rec.approaching and rec.moved > 6)
            if eligible and (now - lastReactT) >= REACT_CD
               -- Are we inside the projectile's hitbox (its box + margin on each side)?
               and #workspace:GetPartBoundsInBox(part.CFrame, part.Size + inflate, _projOP) > 0 then
                projWatch[part] = nil
                lastReactT = now
                if doDodge then
                    local d = State.HitboxDodgeDelay or 0
                    if d > 0 then task.delay(d, function() fireDodge() end) else fireDodge() end
                else
                    local d = State.HitboxParryDelay or 0
                    if d > 0 then task.delay(d, function() doParry(os.clock()) end) else doParry(os.clock()) end
                end
            end
        end
    end
end

-- Shared handler: a track started on some enemy rig (humanoid OR controller).
local function onEnemyAnim(owner, track)
    if not owner or owner == LP.Character then return end
    local anim = track.Animation
    local id = (anim and anim.AnimationId or ""):gsub("rbxassetid://", "")
    if id == "" then return end
    noteAttackVisual(owner, track, id)            -- ESP hitbox tracking (always on)
    if not State or not State.AutoParry then return end
    plan(track, owner, id)
end

local hookedHums = setmetatable({}, { __mode = "k" })
local function hookHum(hum)
    if hookedHums[hum] then return end
    hookedHums[hum] = true
    Conns.add(hum.AnimationPlayed:Connect(function(track)
        onEnemyAnim(hum.Parent, track)
    end))
end
Humanoids.onAdded(hookHum)

-- Many VV mobs are NON-humanoid rigs driven by an AnimationController instead
-- of a Humanoid (the Animation Visualizer hooks these; AutoParry must too, or
-- their attacks are never seen and their saved timings never fire).
local hookedCtrls = setmetatable({}, { __mode = "k" })
local function hookCtrl(ctrl)
    if hookedCtrls[ctrl] then return end
    hookedCtrls[ctrl] = true
    Conns.add(ctrl.AnimationPlayed:Connect(function(track)
        -- AnimationController usually sits directly under the rig model.
        onEnemyAnim(ctrl.Parent, track)
    end))
end
for _, d in ipairs(workspace:GetDescendants()) do
    if d:IsA("AnimationController") then hookCtrl(d) end
end
Conns.add(workspace.DescendantAdded:Connect(function(o)
    if o:IsA("AnimationController") then hookCtrl(o) end
end))

local function bindLocal(char)
    local hum = char:FindFirstChildWhichIsA("Humanoid") or char:WaitForChild("Humanoid", 5)
    if not hum then return end
    -- Track the local swing so we can feint at the START of it. Looped tracks
    -- (idle / run) are ignored; a swing is a one-shot animation.
    Conns.add(hum.AnimationPlayed:Connect(function(track)
        if track and not track.Looped then
            localSwing.track, localSwing.t = track, os.clock()
        end
    end))
    local lastHP = hum.Health
    Conns.add(hum.HealthChanged:Connect(function(h)
        if h < lastHP then
            local t = os.clock()
            hitstunUntil = t + HITSTUN
            -- Repeat on miss: a parry we just fired clearly whiffed (we took
            -- damage). If the attacker's animation is still going, re-fire the
            -- parry to catch the next hit in the combo, up to a capped number.
            if State and State.AutoParry and State.RepeatOnMiss
               and lastParry.track and lastParry.track.IsPlaying
               and (t - lastParry.t) <= 0.6
               and lastParry.count < (State.RepeatOnMissMax or 2) then
                doParry(t)
                lastParry.count = lastParry.count + 1
                lastFire = t
            end
        end
        lastHP = h
    end))
end
if LP.Character then bindLocal(LP.Character) end
Conns.add(LP.CharacterAdded:Connect(bindLocal))

--========================================================
-- API
--========================================================
-- Detection Range — the SINGLE source of truth for every distance check in
-- AutoParry. Setting it pins the proximity gate AND the attack-hitbox
-- width/height/reach to one number, and mirrors it into the legacy keys so the
-- ESP hitbox box (and anything else) reads the very same value — detection range
-- and hitbox range can never disagree. No notification: this is a slider.
local function syncRange(r)
    r = math.max(tonumber(r) or 18, 1)
    State.DetectionRange = r
    State.AutoParryRange = r        -- proximity gate (legacy mirror)
    State.HitboxSize     = r        -- attack-box width & height (legacy mirror)
    State.HitboxReach    = r        -- attack-box forward depth (legacy mirror)
    return r
end
function Combat.setDetectionRange(v) syncRange(v) end

-- Hitbox Range master toggle. Connects the Debris projectile watcher only while
-- on; per-tick updateProjWatch reacts when a matched projectile reaches you.
function Combat.setHitboxRangeMode(on)
    State.HitboxRangeMode = on
    if on then
        connectProjectiles()
    else
        if projConn then projConn:Disconnect(); projConn = nil end
        for k in pairs(projWatch) do projWatch[k] = nil end
    end
end
-- Exposed so the Animation Visualizer's Hitbox Range panel toggles the very same
-- mode (with its connection management) instead of duplicating the logic.
_G.__SetHitboxRangeMode = Combat.setHitboxRangeMode

function Combat.setAutoParry(v)
    State.AutoParry = v
end
function Combat.init(state)
    State = state
    syncRange(State.DetectionRange or 18)   -- collapse any stale legacy values to the master on load
    -- Projectile names matched by the Hitbox Range defender. "Start" is the part
    -- that actually travels toward you (the Cero/beam body, confirmed live); the
    -- rest are Cero seeds. Works out of the box.
    local set = Settings.get("projectile_names", nil)
    if type(set) ~= "table" or next(set) == nil then
        set = { Start = true, CeroFX = true, Cero1 = true, Cero = true,
                ChargeEffect = true, wbeam = true, SpitShot = true }
        Settings.set("projectile_names", set)
    end
    _G.__ProjectileNames = set
    if State.HitboxRangeMode then connectProjectiles() end   -- restore saved mode
    -- Per-attack parry ranges (animId -> {min,max}); set in the Animation Visualizer.
    _G.__ParryRanges = Settings.get("parry_ranges", nil) or {}
end
return Combat

end)
__bundle_register("Utility/Latency", function(require, _LOADED, __bundle_register, __bundle_modules)
-- Latency — mirrors deepwoken-rewrite's Latency module.
-- Uses Stats.Network "Data Ping" (round-trip, ms) so AutoParry can press
-- early enough that the input reaches the server at the saved frame.
local Stats = game:GetService("Stats")

local Latency = {}

-- rtt() is read every frame by the AutoParry tick. Ping doesn't change
-- meaningfully frame-to-frame, so cache it and refresh at most ~10x/sec.
-- This removes a Stats.Network lookup from every Heartbeat with no behaviour
-- change (timing still tracks ping within 0.1s).
local _cached, _cachedAt = 0, 0
local function compute()
    local ok, v = pcall(function()
        return Stats.Network.ServerStatsItem["Data Ping"]:GetValue() / 1000
    end)
    if ok and v and v > 0 then return v end
    -- fallback: GetNetworkPing is one-way seconds -> RTT = *2
    local p = 0
    pcall(function() p = game:GetService("Players").LocalPlayer:GetNetworkPing() end)
    return math.max(p * 2, 0)
end
function Latency.rtt()  -- round-trip time, seconds (cached ~0.1s)
    local now = os.clock()
    if now - _cachedAt >= 0.1 then
        _cached = compute()
        _cachedAt = now
    end
    return _cached
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
-- Attack hitbox box colors: green for normal/M1 swings, red for criticals.
local COL_HB_NORMAL = Color3.fromRGB(70, 220, 110)
local COL_HB_CRIT   = Color3.fromRGB(235, 70, 70)
-- Active-state names shown by the "Show States" ESP stat (hoisted; read each tick).
local ESP_STATE_NAMES = { "Blocking", "Riposte", "ProjectileDeflecting" }

local espTags = {}      -- root -> BillboardGui
local espHL   = {}      -- character Model -> Highlight
local espHB   = {}      -- root -> BoxHandleAdornment (parry hitbox box)

-- Attack hitbox box. Mirrors Combat's hitbox check EXACTLY (a cube of
-- State.DetectionRange at the root pushed forward by half its depth), so what
-- you see is the very box AutoParry's "Hitbox Prediction" tests you against.
-- Shown ONLY while the enemy is actually mid-attack (Combat reports this), and
-- colored green for normal/M1 swings, red for criticals.
local function hitboxFor(root, char)
    local info = (State.ESPHitbox and char and _G.__AttackInfo)
        and _G.__AttackInfo(char) or nil
    if not info then
        if espHB[root] then pcall(function() espHB[root]:Destroy() end); espHB[root] = nil end
        return
    end
    local R = State.DetectionRange or State.HitboxSize or 12
    local adorn = espHB[root]
    if not adorn or not adorn.Parent then
        adorn = Instance.new("BoxHandleAdornment")
        adorn.Name = "ESP_Hitbox"
        adorn.ZIndex = 0
        adorn.AlwaysOnTop = true
        adorn.Transparency = 0.6
        adorn.Adornee = root
        adorn.Parent = root
        espHB[root] = adorn
    end
    adorn.Color3 = info.critical and COL_HB_CRIT or COL_HB_NORMAL
    adorn.Size = Vector3.new(R, R, R)               -- width, height, forward reach (all = Detection Range)
    adorn.CFrame = CFrame.new(0, 0, -(R / 2))       -- forward-depth offset (like Combat)
end

-- Two billboards per character:
--  1) TEXT billboard ABOVE the head — stacked centered: NAME / ROLE / DISTANCE / WEAPON.
--  2) HP billboard at TORSO level — horizontal layout: [%] then vertical bar,
--     offset to the camera-left of the character via StudsOffset.X.
local function makeTag(root)
    -- TEXT (above head)
    local bb = Instance.new("BillboardGui")
    bb.Name = "ESP_Tag"
    bb.Size = UDim2.new(0, 200, 0, 140)
    bb.StudsOffset = Vector3.new(0, 3, 0)
    bb.AlwaysOnTop = true
    bb.LightInfluence = 0
    bb.Parent = root

    local function tl(name, y, h, size, font, color, strokeT)
        local t = Instance.new("TextLabel", bb)
        t.Name = name; t.Text = ""
        t.Size = UDim2.new(1, 0, 0, h); t.Position = UDim2.new(0, 0, 0, y)
        t.BackgroundTransparency = 1
        t.TextSize = size; t.Font = font
        t:SetAttribute("baseSize", size)   -- for the text-scale slider
        t.TextColor3 = color
        t.TextStrokeTransparency = strokeT or 0.35
        t.TextXAlignment = Enum.TextXAlignment.Center
        return t
    end
    -- Combat stats sit at the TOP (above the name), then the name stack below.
    -- BillboardGui does NOT render content above its top edge, so the stats can't
    -- use a negative Y — instead the frame is taller and the name is pushed down,
    -- keeping the stats on-screen. CHANGE THE STAT TEXT COLOR HERE.
    local stats = tl("stats", 2,   52, 12, Enum.Font.GothamBold,  Color3.fromRGB(130,225,255), 0.35)
    stats.TextYAlignment = Enum.TextYAlignment.Bottom
    tl("lbl",   56,  20, 15, Enum.Font.GothamBlack, Color3.fromRGB(255,255,255), 0.3)   -- name
    tl("kind",  76,  14, 12, Enum.Font.GothamBold,  Color3.fromRGB(255,255,255), 0.4)   -- role
    tl("dist",  90,  14, 12, Enum.Font.Gotham,      Color3.fromRGB(235,235,235), 0.4)   -- distance
    tl("hppct", 104, 14, 12, Enum.Font.GothamBold,  Color3.fromRGB(120,230,150), 0.4)   -- health % (split mode)
    tl("wpn",   118, 14, 12, Enum.Font.GothamBold,  Color3.fromRGB(255,225,140), 0.4)   -- weapon

    -- HEALTH (at torso, to the camera-left of the character)
    local hb = Instance.new("BillboardGui")
    hb.Name = "ESP_HP"
    hb.Size = UDim2.new(0, 60, 0, 60)
    hb.StudsOffset = Vector3.new(-2.2, 0, 0)      -- shift left on screen
    hb.AlwaysOnTop = true
    hb.LightInfluence = 0
    hb.Parent = root

    -- Percentage label sits to the LEFT of the bar.
    local pct = Instance.new("TextLabel", hb)
    pct.Name = "pct"; pct.Text = ""
    pct.AnchorPoint = Vector2.new(1, 0.5)
    pct.Position = UDim2.new(1, -14, 0.5, 0)
    pct.Size = UDim2.new(0, 40, 0, 16)
    pct.BackgroundTransparency = 1
    pct.TextColor3 = Color3.fromRGB(255,255,255)
    pct.TextStrokeTransparency = 0.35
    pct.TextSize = 12; pct.Font = Enum.Font.GothamBold
    pct:SetAttribute("baseSize", 12)
    pct.TextXAlignment = Enum.TextXAlignment.Right

    -- Vertical bar to the right of the % text.
    local hpBg = Instance.new("Frame", hb)
    hpBg.Name = "hpBg"
    hpBg.AnchorPoint = Vector2.new(1, 0.5)
    hpBg.Position = UDim2.new(1, -2, 0.5, 0)
    hpBg.Size = UDim2.new(0, 6, 0, 56)
    hpBg.BackgroundColor3 = Color3.fromRGB(30,30,30); hpBg.BorderSizePixel = 0
    Instance.new("UICorner", hpBg).CornerRadius = UDim.new(0,3)
    local hp = Instance.new("Frame", hpBg)
    hp.Name = "hp"; hp.AnchorPoint = Vector2.new(0, 1)
    hp.Position = UDim2.new(0, 0, 1, 0); hp.Size = UDim2.new(1, 0, 1, 0)
    hp.BackgroundColor3 = Color3.fromRGB(70,210,90); hp.BorderSizePixel = 0
    Instance.new("UICorner", hp).CornerRadius = UDim.new(0,3)

    return { text = bb, hp = hb }
end

local function tagFor(root)
    local pair = espTags[root]
    if not pair or not pair.text or not pair.text.Parent then
        pair = makeTag(root); espTags[root] = pair
    end
    return pair
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

-- Best-effort held-weapon name for a character.
local function getWeapon(char)
    -- VV / Type-Soul: the weapon is a "WeaponModel" model on the character; its
    -- name lives in a WeaponName StringValue (mirrored by a WeaponModelName
    -- attribute and a WeaponType StringValue).
    local wm = char:FindFirstChild("WeaponModel")
    if wm then
        local wn = wm:FindFirstChild("WeaponName")
        if wn and wn:IsA("StringValue") and wn.Value ~= "" then return wn.Value end
        local a = wm:GetAttribute("WeaponModelName")
        if a and tostring(a) ~= "" then return tostring(a) end
        local wt = wm:FindFirstChild("WeaponType")
        if wt and wt:IsA("StringValue") and wt.Value ~= "" then return wt.Value end
    end
    -- Fallbacks for other rigs / games:
    local tool = char:FindFirstChildWhichIsA("Tool")          -- equipped Tool
    if tool then return tool.Name end
    local rh = char:FindFirstChild("RightHand")               -- Deepwoken-style hand weapon
    if rh then
        local hw = rh:FindFirstChild("HandWeapon") or rh:FindFirstChildWhichIsA("Model")
        if hw then return hw.Name end
    end
    local a = char:GetAttribute("Weapon")                     -- attribute / value
    if a and tostring(a) ~= "" then return tostring(a) end
    local sv = char:FindFirstChild("Weapon")
    if sv and sv:IsA("StringValue") and sv.Value ~= "" then return sv.Value end
    return nil
end

-- Per-character caches. Weapon name + the Head reference almost never change, so
-- re-running their FindFirstChild chains EVERY tick for EVERY tag was a big ESP
-- cost at long range. Cache them (weak-keyed; weapon refreshed ~every 1.5s).
local weaponCache = setmetatable({}, { __mode = "k" })   -- char -> { name, t }
local function getWeaponCached(char)
    local c = weaponCache[char]
    local now = os.clock()
    if c and (now - c.t) < 1.5 then return c.name end
    local n = getWeapon(char)
    weaponCache[char] = { name = n, t = now }
    return n
end
local headCache = setmetatable({}, { __mode = "k" })     -- char -> Head BasePart
local function headOf(char)
    local h = headCache[char]
    if h and h.Parent then return h end
    h = char:FindFirstChild("Head")
    headCache[char] = h
    return h
end

-- Best human-readable name for a non-player character (mob / NPC).
-- VV's mob rigs sit under Workspace.Living with EMPTY model names; their real
-- identity lives in attributes (HollowType="MantisHollow", Team="VillageGuard",
-- Race="Hollow"…). Named rigs ("Lost Soul", "Giant Dragonfly") use the model
-- name. So: model name → Humanoid.DisplayName → attributes → string values.
local NAME_SKIP = { DefaultEnemy = true, Default = true, Living = true, Enemy = true, NPC = true }
-- "MantisHollow" -> "Mantis Hollow", "VillageGuard" -> "Village Guard".
local function prettify(s)
    s = tostring(s):gsub("(%l)(%u)", "%1 %2"):gsub("(%u%u)(%u%l)", "%1 %2")
    return s
end
local function pickAttr(char)
    for _, a in ipairs({ "MobName", "EnemyName", "DisplayName", "Title",
                         "HollowType", "Name", "Race", "Team" }) do
        local v = char:GetAttribute(a)
        if type(v) == "string" and v ~= "" and not NAME_SKIP[v] then return prettify(v) end
    end
end
-- Names never change for a given character; resolve once and cache (weak-keyed
-- so dead characters are collected). Avoids re-scanning attributes every tick.
local nameCache = setmetatable({}, { __mode = "k" })
local function bestNameUncached(char, hum)
    -- 1) explicit, meaningful model name
    local mn = char.Name
    if mn and mn ~= "" and not NAME_SKIP[mn] then return mn end
    -- 2) humanoid display name
    if hum and type(hum.DisplayName) == "string"
        and hum.DisplayName ~= "" and hum.DisplayName ~= "Humanoid" then
        return hum.DisplayName
    end
    -- 3) VV attributes
    local a = pickAttr(char); if a then return a end
    -- 4) string-value children
    for _, n in ipairs({ "DisplayName", "MobName", "Title" }) do
        local o = char:FindFirstChild(n)
        if o and o:IsA("StringValue") and o.Value ~= "" then return o.Value end
    end
    return (mn ~= "" and mn) or "Enemy"
end
local function bestName(char, hum)
    local hit = nameCache[char]
    if hit ~= nil then return hit end
    local n = bestNameUncached(char, hum)
    nameCache[char] = n
    return n
end

-- Apply the user's text-scale to every label in a tag pair (only when the
-- scale actually changed, so it's free at steady state).
local function applyScale(pair, sc)
    if pair._scale == sc then return end
    pair._scale = sc
    for _, bb in ipairs({ pair.text, pair.hp }) do
        for _, t in ipairs(bb:GetDescendants()) do
            local base = t:GetAttribute("baseSize")
            if base then t.TextSize = math.max(1, math.floor(base * sc + 0.5)) end
        end
    end
end

-- Race / form label (mobs: HollowType / Race attribute; players: Race attribute
-- or a Status.Race string value). prettify() turns "MantisHollow" -> "Mantis Hollow".
local function getRace(char)
    local ht = char:GetAttribute("HollowType")
    if type(ht) == "string" and ht ~= "" then return prettify(ht) end
    local r = char:GetAttribute("Race")
    if type(r) == "string" and r ~= "" then return prettify(r) end
    local st = char:FindFirstChild("Status")
    local sr = st and st:FindFirstChild("Race")
    if sr and sr:IsA("StringValue") and sr.Value ~= "" then return prettify(sr.Value) end
    return nil
end

--==============================================================
-- 2D SCREEN-SPACE BOX + side health bar (Drawing API, executor-provided).
-- A box that frames the character with a vertical health bar to its left.
-- Positioned every RenderStepped (smooth), but only over already-tracked
-- targets, so it costs a couple of WorldToViewportPoint calls per visible enemy.
-- Defined ABOVE updateTag so updateTag's references resolve to these locals.
--==============================================================
local DrawingLib = (type(Drawing) == "table" and Drawing) or nil
local espBox = {}      -- root -> { box, barbg, bar, color, frac }
local function removeBox(root)
    local b = espBox[root]; if not b then return end
    pcall(function() b.box:Remove() end)
    pcall(function() b.barbg:Remove() end)
    pcall(function() b.bar:Remove() end)
    espBox[root] = nil
end
local function boxFor(root)
    if not DrawingLib then return nil end
    local b = espBox[root]; if b then return b end
    local function sq(filled)
        local s = DrawingLib.new("Square")
        s.Thickness = 1; s.Filled = filled; s.Transparency = 1; s.Visible = false
        return s
    end
    b = { box = sq(false), barbg = sq(true), bar = sq(true) }
    b.barbg.Color = Color3.fromRGB(18,18,18)
    espBox[root] = b
    return b
end

local function updateTag(root, char, name, kind, color, hum, dist)
    local pair = tagFor(root)
    local txt, hb = pair.text, pair.hp
    applyScale(pair, (State.ESPTextScale or 100) / 100)

    -- Reposition the text billboard so it sits just above the head.
    do
        local head = headOf(char)
        local r = root
        if head and r and head:IsA("BasePart") and r:IsA("BasePart") then
            local dy = (head.Position.Y - r.Position.Y) + (head.Size.Y * 0.5) + 2.4
            txt.StudsOffset = Vector3.new(0, dy, 0)
        end
    end

    txt.lbl.Text = State.ESPName and name or ""
    txt.lbl.TextColor3 = color
    -- Name gets its OWN scale on top of the overall ESP text scale.
    txt.lbl.TextSize = math.max(1, math.floor((txt.lbl:GetAttribute("baseSize") or 15)
        * ((State.ESPTextScale or 100) / 100) * ((State.ESPNameScale or 100) / 100) + 0.5))
    txt.kind.Text = kind
    txt.kind.TextColor3 = Color3.fromRGB(255,255,255)
    txt.dist.Text = State.ESPDistance and string.format("%dm", dist) or ""
    -- Weapon: players + mobs only (not NPCs)
    local showWpn = State.ESPWeapon and kind ~= "NPC"
    if showWpn then
        local w = getWeaponCached(char)
        txt.wpn.Text = w and ("[" .. w .. "]") or ""
        txt.wpn.Visible = w ~= nil
    else
        txt.wpn.Visible = false
    end

    -- Health: side panel (vertical bar + %) by default; in Split mode the side
    -- panel is hidden entirely and only the % shows in the text stack.
    local showHp = State.ESPHealth and hum ~= nil
    local split  = State.ESPSplitHealth
    hb.Enabled = showHp and not split
    if showHp then
        local p = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
        local pctTxt = string.format("%d%%", math.floor(p*100 + 0.5))
        local barCol = Color3.fromRGB(
            math.floor(235*(1-p)+60), math.floor(70 + 150*p), 70)
        if not split then
            local bar = hb.hpBg.hp
            bar.Size = UDim2.new(1, 0, p, 0)
            bar.BackgroundColor3 = barCol
            hb.pct.Visible = true
            hb.pct.Text = pctTxt
            hb.pct.TextColor3 = Color3.fromRGB(255,255,255)
            txt.hppct.Visible = false
        else
            txt.hppct.Visible = true
            txt.hppct.Text = pctTxt
            txt.hppct.TextColor3 = barCol
        end
    else
        txt.hppct.Visible = false
    end
    -- Combat-state stats: one multi-line label above the name. Status is only
    -- looked up when a value-stat is on, and `lines` is built lazily, so an idle
    -- tick (no stats shown — the common case) allocates nothing.
    do
        local st = (State.ESPReiatsu or State.ESPPosture or State.ESPStamina or State.ESPStates)
            and char:FindFirstChild("Status") or nil
        local lines
        if st then
            if State.ESPReiatsu then
                local o = st:FindFirstChild("Reiatsu")
                if o then lines = lines or {}; lines[#lines+1] = ("Reiatsu %d"):format(math.floor(o.Value + 0.5)) end
            end
            if State.ESPPosture then
                local o = st:FindFirstChild("Posture")
                if o then
                    local mx = (o:IsA("DoubleConstrainedValue") and o.MaxValue) or 0
                    lines = lines or {}
                    if mx > 0 then lines[#lines+1] = ("Posture %d%%"):format(math.floor(o.Value / mx * 100 + 0.5))
                    else lines[#lines+1] = ("Posture %d"):format(math.floor(o.Value + 0.5)) end
                end
            end
            if State.ESPStamina then
                local o = st:FindFirstChild("ShunpoStamina")
                if o then lines = lines or {}; lines[#lines+1] = ("Stamina %d"):format(math.floor(o.Value + 0.5)) end
            end
            if State.ESPStates then
                local active
                for _, sn in ipairs(ESP_STATE_NAMES) do
                    local o = st:FindFirstChild(sn)
                    if o and o.Value and o.Value > 0 then active = active or {}; active[#active+1] = sn end
                end
                if active then lines = lines or {}; lines[#lines+1] = table.concat(active, " · ") end
            end
        end
        if State.ESPRaceForm then
            local race = getRace(char)
            if race then lines = lines or {}; lines[#lines+1] = race .. (char:GetAttribute("IsBoss") and "  [BOSS]" or "") end
        end
        if lines then
            txt.stats.Text = table.concat(lines, "\n"); txt.stats.Visible = true
        else
            txt.stats.Visible = false
        end
    end
    outlineFor(char, color)
    hitboxFor(root, char)
    -- 2D box + side bar track the same target (color + health fraction).
    if State.ESPBox then
        local b = boxFor(root)
        if b then
            b.color = color
            b.frac = (hum and hum.MaxHealth and hum.MaxHealth > 0) and (hum.Health / hum.MaxHealth) or 1
        end
    else
        removeBox(root)
    end
    -- No Persistent ESP: allow the character model to stream out normally.
    if State.NoPersistentESP then
        pcall(function() char.ModelStreamingMode = Enum.ModelStreamingMode.Default end)
    end
end

local function destroyPair(pair)
    if not pair then return end
    if pair.text then pcall(function() pair.text:Destroy() end) end
    if pair.hp   then pcall(function() pair.hp:Destroy()   end) end
end

function Visuals.clearESP()
    for _, pair in pairs(espTags) do destroyPair(pair) end
    for c, hl in pairs(espHL) do if hl then pcall(function() hl:Destroy() end) end end
    for r, hb in pairs(espHB) do if hb then pcall(function() hb:Destroy() end) end end
    for r in pairs(espBox) do removeBox(r) end
    espTags = {}; espHL = {}; espHB = {}
end

-- Smooth per-frame box positioner.
local boxAccum = 0
Conns.add(RunService.RenderStepped:Connect(function(dt)
    if not DrawingLib then return end
    local on = State and State.ESP and State.ESPBox
    if not on then
        for _, b in pairs(espBox) do b.box.Visible=false; b.barbg.Visible=false; b.bar.Visible=false end
        return
    end
    boxAccum = boxAccum + (dt or 0)         -- throttle to ~30 Hz (boxes don't need 60+)
    if boxAccum < 1/30 then return end
    boxAccum = 0
    local cam = workspace.CurrentCamera; if not cam then return end
    for root, b in pairs(espBox) do
        if root and root.Parent then
            local cf = root.CFrame
            local tv = cam:WorldToViewportPoint((cf * CFrame.new(0,  2.8, 0)).Position)
            local bv = cam:WorldToViewportPoint((cf * CFrame.new(0, -3.2, 0)).Position)
            if tv.Z > 0 and bv.Z > 0 then
                local h = math.abs(bv.Y - tv.Y)
                local w = h * 0.62
                local x = (tv.X + bv.X) * 0.5 - w * 0.5
                local y = math.min(tv.Y, bv.Y)
                b.box.Size = Vector2.new(w, h); b.box.Position = Vector2.new(x, y)
                b.box.Color = b.color or COL_PLAYER; b.box.Visible = true
                if State.ESPBoxBar and State.ESPHealth ~= false then
                    local frac = math.clamp(b.frac or 1, 0, 1)
                    local bx = x - 5
                    b.barbg.Size = Vector2.new(3, h); b.barbg.Position = Vector2.new(bx, y); b.barbg.Visible = true
                    local bh = h * frac
                    b.bar.Size = Vector2.new(3, bh); b.bar.Position = Vector2.new(bx, y + (h - bh))
                    b.bar.Color = Color3.fromRGB(math.floor(255*(1-frac)), math.floor(210*frac), 70)
                    b.bar.Visible = true
                else
                    b.barbg.Visible=false; b.bar.Visible=false
                end
            else
                b.box.Visible=false; b.barbg.Visible=false; b.bar.Visible=false
            end
        else
            b.box.Visible=false; b.barbg.Visible=false; b.bar.Visible=false
        end
    end
end))

-- Name-based overrides (lowercase substring match):
--  ESP_IGNORE  -> never tagged at all (e.g. the training dummy)
--  ESP_AS_NPC  -> always classified as NPC regardless of prompts
local ESP_IGNORE = { "dummy", "training" }
local ESP_AS_NPC = { "swordretrieve" }
local function nameMatches(name, list)
    local n = (name or ""):lower()
    for _, k in ipairs(list) do if n:find(k, 1, true) then return true end end
    return false
end
local function isIgnored(char) return nameMatches(char.Name, ESP_IGNORE) end

-- Classify a non-player character: NPC (has ProximityPrompt / "NPC" tag) vs Mob.
-- Result is cached per character — walking GetDescendants() every tick was the
-- single biggest ESP cost on busy servers. Cache is purged automatically when
-- the character leaves the tag dictionary (see clearESP / cull loop).
local classifyCache = setmetatable({}, { __mode = "k" })
local function classify(char)
    local hit = classifyCache[char]
    if hit then return hit[1], hit[2] end
    local kind, col = "MOB", COL_MOB
    if nameMatches(char.Name, ESP_AS_NPC) then
        kind, col = "NPC", COL_NPC
    else
        for _, ch in ipairs(char:GetDescendants()) do
            if ch:IsA("ProximityPrompt") then kind, col = "NPC", COL_NPC; break end
        end
        if kind == "MOB" and (char:GetAttribute("NPC") or char:FindFirstChild("IsNPC")) then
            kind, col = "NPC", COL_NPC
        end
    end
    classifyCache[char] = { kind, col }
    return kind, col
end

do
    local lastTick = 0
    -- Reused buffer tables; clearing-and-refilling avoids per-tick allocations.
    local playerCharSet = {}
    local seen = {}
    local elig = {}            -- this-tick allowed targets (split-frame slicing)
    local splitPart = 0        -- rotating slice index for ESP Split Updates
    Conns.add(RunService.Heartbeat:Connect(function()
        if not State or not State.ESP then return end
        local now = tick()
        -- ESP Limit Updates + Refresh Rate (deepwoken-style throttle). When the
        -- limiter is on, cap updates to ESPRefreshRate per second; off = every
        -- Heartbeat. Default 30/s (was a fixed 5 Hz).
        if State.ESPLimitUpdates ~= false then
            local rate = State.ESPRefreshRate or 30; if rate < 1 then rate = 1 end
            if now - lastTick < 1 / rate then return end
        end
        lastTick = now
        local _, me = getCharParts(); if not me then return end
        local myPos = me.Position
        -- Squared-distance compare avoids the sqrt inside Magnitude.
        local range  = State.ESPRange
        local range2 = range * range
        -- Per-tick budget for CREATING new ESP objects. Moving into a crowd used
        -- to spawn dozens of BillboardGuis + Highlights in one frame (Highlights
        -- are heavy to instantiate) -> a lag spike. Cap new creations per tick so
        -- they amortise over a few ticks. Already-tagged entities still update
        -- every tick, so nothing visible changes except a slight stagger on appear.
        local newBudget = 8

        -- Cull tags out of range / gone
        for root, pair in pairs(espTags) do
            if not root or not root.Parent
                or (root.Position - myPos).Magnitude > range then
                destroyPair(pair)
                espTags[root] = nil
            end
        end
        -- Cull hitbox boxes out of range / gone / disabled
        for root, hb in pairs(espHB) do
            if not State.ESPHitbox or not root or not root.Parent
                or (root.Position - myPos).Magnitude > range then
                if hb then pcall(function() hb:Destroy() end) end
                espHB[root] = nil
            end
        end
        -- Cull highlights for gone / out-of-range characters
        for char, hl in pairs(espHL) do
            local r = char and (char:FindFirstChild("HumanoidRootPart")
                or char:FindFirstChildWhichIsA("BasePart"))
            if not char or not char.Parent or not r
                or (r.Position - myPos).Magnitude > range then
                if hl then pcall(function() hl:Destroy() end) end
                espHL[char] = nil
            end
        end
        -- Cull 2D boxes out of range / gone / disabled
        for root in pairs(espBox) do
            if not State.ESPBox or not root or not root.Parent
                or (root.Position - myPos).Magnitude > range then
                removeBox(root)
            end
        end

        -- Reuse buffers
        for k in pairs(playerCharSet) do playerCharSet[k] = nil end
        for k in pairs(seen) do seen[k] = nil end
        local plist = Players:GetPlayers()
        for i = 1, #plist do
            local p = plist[i]; local c = p.Character
            if c then playerCharSet[c] = p end
        end

        -- PASS 1 — discover allowed targets into `elig` and clean up filtered ones.
        -- (Cheap per-target work every tick; the heavy tag update is PASS 2.)
        local nElig = 0
        for d in Humanoids.iter() do
            if d.Health > 0 then
                local c = d.Parent
                if c and c ~= LP.Character and not seen[c] then
                    seen[c] = true
                    local r = c:FindFirstChild("HumanoidRootPart")
                        or c:FindFirstChildWhichIsA("BasePart")
                    if r then
                        local off = r.Position - myPos
                        local d2  = off.X*off.X + off.Y*off.Y + off.Z*off.Z
                        if d2 <= range2 then
                            -- Resolve kind first so per-type filters can skip it.
                            local plr = playerCharSet[c]
                            local kind, col, nm
                            if plr then
                                kind, col, nm = "PLAYER", COL_PLAYER, (plr.DisplayName or plr.Name)
                            else
                                kind, col = classify(c); nm = bestName(c, d)
                            end
                            local allowed =
                                  (kind == "PLAYER" and State.ESPPlayers ~= false)
                               or (kind == "NPC"    and State.ESPNPCs    ~= false)
                               or (kind == "MOB"    and State.ESPMobs    ~= false)
                            -- Never tag ignored characters (training dummy, etc).
                            if not plr and isIgnored(c) then allowed = false end
                            if allowed then
                                nElig = nElig + 1
                                local e = elig[nElig]
                                if not e then e = {}; elig[nElig] = e end
                                e.r, e.c, e.nm, e.kind, e.col, e.hum, e.dist =
                                    r, c, nm, kind, col, d, math.sqrt(d2)
                            else
                                -- Filtered out: drop any tag/outline/box it had.
                                local pair = espTags[r]
                                if pair then destroyPair(pair); espTags[r] = nil end
                                local hl = espHL[c]
                                if hl then pcall(function() hl:Destroy() end); espHL[c] = nil end
                                removeBox(r)
                            end
                        end
                    end
                end
            end
        end

        -- ESP Max Targets: render only the nearest N (0 = unlimited). Farther
        -- in-range targets get their tag/outline/box removed so nothing lingers.
        local total = nElig
        local cap = State.ESPMaxTargets or 0
        if cap > 0 and total > cap then
            table.sort(elig, function(a, b)
                local ad = (a and a.r) and (a.dist or 1e9) or math.huge
                local bd = (b and b.r) and (b.dist or 1e9) or math.huge
                return ad < bd
            end)
            for i = cap + 1, total do
                local e = elig[i]
                if e and e.r then
                    local pair = espTags[e.r]; if pair then destroyPair(pair); espTags[e.r] = nil end
                    if e.c then local hl = espHL[e.c]; if hl then pcall(function() hl:Destroy() end); espHL[e.c] = nil end end
                    removeBox(e.r)
                end
            end
            nElig = cap
        end

        -- PASS 2 — update tags. Normally every eligible target; with Split
        -- Updates on, only a rotating 1/ESPSplitFrames slice per tick (the rest
        -- keep their last tag, so the heavy work spreads across frames). New
        -- targets still obey the per-tick creation budget.
        local lo, hi = 1, nElig
        if State.ESPSplitUpdates and nElig > 0 then
            local frames = State.ESPSplitFrames or 3; if frames < 1 then frames = 1 end
            local per = math.ceil(nElig / frames)
            splitPart = (splitPart % frames) + 1
            lo = (splitPart - 1) * per + 1
            hi = math.min(splitPart * per, nElig)
        end
        for i = lo, hi do
            local e = elig[i]
            if e and e.r then
                local isNew = espTags[e.r] == nil
                if not (isNew and newBudget <= 0) then
                    if isNew then newBudget = newBudget - 1 end
                    local ok, err = pcall(updateTag, e.r, e.c, e.nm, e.kind, e.col, e.hum, e.dist)
                    if not ok then _G.__espErr = tostring(err) end
                end
            end
        end
        -- Release references so culled characters can be collected.
        for i = 1, total do local e = elig[i]; if e then e.c, e.r, e.hum, e.nm = nil, nil, nil, nil end end
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
-- PERFORMANCE / VISUAL REMOVALS — the EXACT set deepwoken-rewrite removes,
-- exposed both as individual toggles AND bundled under "Performance Mode".
--   No Fog          : Lighting.FogStart/FogEnd = 9e9 ; every Atmosphere.Density = 0
--   No Blur         : every BlurEffect.Size = 0
--   No Shadows      : Lighting.GlobalShadows = false
--   No Animated Sea : disable the "SeaClient" container + its LocalScripts
-- Each setter snapshots originals into its own table and restores on toggle-off.
--==============================================================

-- No Shadows -------------------------------------------------
local shadowsOrig
function Visuals.setNoShadows(on)
    State.NoShadows = on
    if on then
        if shadowsOrig == nil then shadowsOrig = Lighting.GlobalShadows end
        pcall(function() Lighting.GlobalShadows = false end)
    else
        if shadowsOrig ~= nil then
            pcall(function() Lighting.GlobalShadows = shadowsOrig end); shadowsOrig = nil
        end
    end
end

-- No Fog -----------------------------------------------------
local noFogConn, noFogOrig, fogOrig = nil, {}, nil
local function noFogApply(inst)
    if inst:IsA("Atmosphere") then
        if noFogOrig[inst] == nil then noFogOrig[inst] = inst.Density end
        pcall(function() inst.Density = 0 end)
    end
end
function Visuals.setNoFog(on)
    State.NoFog = on
    if on then
        if fogOrig == nil then fogOrig = { FogStart = Lighting.FogStart, FogEnd = Lighting.FogEnd } end
        pcall(function() Lighting.FogStart = 9e9; Lighting.FogEnd = 9e9 end)
        for _, d in ipairs(Lighting:GetDescendants()) do noFogApply(d) end
        if not noFogConn then noFogConn = Conns.add(Lighting.DescendantAdded:Connect(noFogApply)) end
    else
        if noFogConn then noFogConn:Disconnect(); noFogConn = nil end
        if fogOrig then
            pcall(function() Lighting.FogStart = fogOrig.FogStart; Lighting.FogEnd = fogOrig.FogEnd end)
            fogOrig = nil
        end
        for inst, v in pairs(noFogOrig) do
            if typeof(inst) == "Instance" then pcall(function() inst.Density = v end) end
        end
        noFogOrig = {}
    end
end

-- No Blur ----------------------------------------------------
local noBlurConn, noBlurOrig = nil, {}
local function noBlurApply(inst)
    if inst:IsA("BlurEffect") then
        if noBlurOrig[inst] == nil then noBlurOrig[inst] = inst.Size end
        pcall(function() inst.Size = 0 end)
    end
end
function Visuals.setNoBlur(on)
    State.NoBlur = on
    if on then
        for _, d in ipairs(Lighting:GetDescendants()) do noBlurApply(d) end
        for _, d in ipairs(workspace:GetDescendants()) do noBlurApply(d) end
        if not noBlurConn then
            noBlurConn = Conns.add(Lighting.DescendantAdded:Connect(noBlurApply))
            Conns.add(workspace.DescendantAdded:Connect(noBlurApply))
        end
    else
        if noBlurConn then noBlurConn:Disconnect(); noBlurConn = nil end
        for inst, v in pairs(noBlurOrig) do
            if typeof(inst) == "Instance" then pcall(function() inst.Size = v end) end
        end
        noBlurOrig = {}
    end
end

-- No Animated Sea --------------------------------------------
local noSeaConn, noSeaOrig = nil, {}
local function noSeaApply(inst)
    if inst.Name == "SeaClient" then
        if noSeaOrig[inst] == nil then noSeaOrig[inst] = inst.Enabled end
        pcall(function() inst.Enabled = false end)
        for _, d in ipairs(inst:GetDescendants()) do
            if d:IsA("LocalScript") then
                if noSeaOrig[d] == nil then noSeaOrig[d] = d.Enabled end
                pcall(function() d.Enabled = false end)
            end
        end
    end
end
function Visuals.setNoAnimatedSea(on)
    State.NoAnimatedSea = on
    if on then
        for _, d in ipairs(workspace:GetDescendants()) do noSeaApply(d) end
        if not noSeaConn then noSeaConn = Conns.add(workspace.DescendantAdded:Connect(noSeaApply)) end
    else
        if noSeaConn then noSeaConn:Disconnect(); noSeaConn = nil end
        for inst, v in pairs(noSeaOrig) do
            if typeof(inst) == "Instance" then pcall(function() inst.Enabled = v end) end
        end
        noSeaOrig = {}
    end
end

-- Performance Mode (master) — flips all four together.
function Visuals.setLowGfx(on)
    State.LowGfx = on
    Visuals.setNoFog(on)
    Visuals.setNoBlur(on)
    Visuals.setNoShadows(on)
    Visuals.setNoAnimatedSea(on)
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
local noclipConn, noclipAddConn, noclipCharConn
local origCollide = {}
local cachedParts = {}                      -- char -> { BasePart, ... }
local function rebuildPartCache(c)
    if not c then return end
    local list = {}
    for _, p in ipairs(c:GetDescendants()) do
        if p:IsA("BasePart") then list[#list+1] = p end
    end
    cachedParts[c] = list
end
function Movement.setNoclip(on)
    State.Noclip = on
    if noclipConn       then noclipConn:Disconnect();       noclipConn       = nil end
    if noclipAddConn    then noclipAddConn:Disconnect();    noclipAddConn    = nil end
    if noclipCharConn   then noclipCharConn:Disconnect();   noclipCharConn   = nil end
    if on then
        -- Build the cache once; refresh only when parts are added/removed.
        local function bindChar(c)
            if not c then return end
            rebuildPartCache(c)
            noclipAddConn = Conns.add(c.DescendantAdded:Connect(function(p)
                if p:IsA("BasePart") then
                    local list = cachedParts[c]; if list then list[#list+1] = p end
                end
            end))
        end
        bindChar(LP.Character)
        noclipCharConn = Conns.add(LP.CharacterAdded:Connect(bindChar))
        noclipConn = Conns.add(RunService.Stepped:Connect(function()
            local c = LP.Character; if not c then return end
            local list = cachedParts[c]
            if not list then rebuildPartCache(c); list = cachedParts[c] end
            for i = 1, #list do
                local p = list[i]
                if p.Parent then
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
        for k in pairs(cachedParts) do cachedParts[k] = nil end
    end
end

--==============================================================
-- TWEEN TO BACK — smoothly slide the player to a point BEHIND the nearest enemy
-- (offset distance + height, facing them), and hold there. Noclips while moving.
-- Ported from the deepwoken reference's "Tween To Back".
--==============================================================
local Humanoids = require("Utility/Humanoids")
local ttbConn
local ttbCached                              -- sticky target (a character Model)
local ttbCollideOrig = {}                    -- BasePart -> original CanCollide
local ttbParts = setmetatable({}, { __mode = "k" })  -- char -> cached BasePart list

local function ttbRestoreCollide()
    for p, orig in pairs(ttbCollideOrig) do
        if p and p.Parent then pcall(function() p.CanCollide = orig end) end
    end
    ttbCollideOrig = {}
end
-- Lightweight noclip on the body parts while tweening. The BasePart list is
-- cached per character (weak-keyed), so we don't allocate a GetChildren() table
-- (or re-run IsA on every part) each frame while attached.
local function ttbNoclip(char)
    local list = ttbParts[char]
    if not list then
        list = {}
        for _, p in ipairs(char:GetChildren()) do
            if p:IsA("BasePart") then list[#list + 1] = p end
        end
        ttbParts[char] = list
    end
    for i = 1, #list do
        local p = list[i]
        if p.Parent and p.CanCollide then
            if ttbCollideOrig[p] == nil then ttbCollideOrig[p] = p.CanCollide end
            p.CanCollide = false
        end
    end
end

-- A character is a live attach candidate: exists, isn't us, has a Humanoid with
-- health, and has an HRP. (Position sanity is covered by the range check.)
local function ttbAlive(c)
    if not (c and c.Parent and c ~= LP.Character) then return false end
    local h = c:FindFirstChildWhichIsA("Humanoid")
    if not (h and h.Health > 0) then return false end
    return c:FindFirstChild("HumanoidRootPart") ~= nil
end
-- Type filters applied when PICKING a fresh target.
local function ttbAllowed(c)
    if State.TTBIgnorePlayers and Players:GetPlayerFromCharacter(c) then return false end
    if c:GetAttribute("NPC") or c:FindFirstChild("IsNPC") then return false end   -- skip dialogue NPCs
    return true
end

-- Nearest allowed, living enemy within range.
local function ttbNearest()
    local _, me = getCharParts()
    if not me then return nil end
    local myPos = me.Position
    local range = State.TTBRange or 300
    local best, bd
    for hum in Humanoids.iter() do
        if hum.Health > 0 then
            local c = hum.Parent
            if c and ttbAlive(c) and ttbAllowed(c) then
                local r = c:FindFirstChild("HumanoidRootPart")
                local d = (r.Position - myPos).Magnitude
                if d <= range and (not bd or d < bd) then bd = d; best = c end
            end
        end
    end
    return best
end

-- Hold the current target instead of re-picking every frame (stops flip-flopping
-- between enemies). Sticky = hold until it dies; otherwise hold while it's in range.
local function ttbKeep(c)
    if not ttbAlive(c) then return false end
    if State.TTBSticky then return true end
    local _, me = getCharParts()
    local r = c:FindFirstChild("HumanoidRootPart")
    return (me and r and (r.Position - me.Position).Magnitude <= (State.TTBRange or 300)) or false
end

local function ttbStep(dt)
    if not State or not State.TweenToBack then return end
    local char = LP.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- Hold the current target while it's still good; otherwise pick the nearest.
    local target
    if ttbCached and ttbKeep(ttbCached) then
        target = ttbCached
    else
        target = ttbNearest(); ttbCached = target
    end
    if not target then ttbRestoreCollide(); return end

    local thrp = target:FindFirstChild("HumanoidRootPart")
    if not thrp then ttbRestoreCollide(); return end

    -- Goal = a point behind the target (+Z local is behind it).
    local goalPos = (thrp.CFrame * CFrame.new(0, State.TTBHeight or 0, State.TTBDistance or 5)).Position

    ttbNoclip(char)

    -- Slide toward the goal at TTBSpeed studs/sec (smooth 3D — no Y snapping).
    local startPos = hrp.Position
    local toGoal   = goalPos - startPos
    local dist     = toGoal.Magnitude
    local newPos
    if dist < 0.01 then
        newPos = goalPos
    else
        local stepD = (State.TTBSpeed or 200) * dt
        newPos = (stepD >= dist) and goalPos or (startPos + toGoal.Unit * stepD)
    end

    -- Face the target by YAW ONLY — a horizontal look can never be a NaN CFrame,
    -- which is what flung the character to the void before.
    local flat = Vector3.new(thrp.Position.X - newPos.X, 0, thrp.Position.Z - newPos.Z)
    if flat.Magnitude > 0.001 then
        hrp.CFrame = CFrame.lookAt(newPos, newPos + flat)
    else
        hrp.CFrame = CFrame.new(newPos)
    end
end

function Movement.setTweenToBack(on)
    State.TweenToBack = on
    if ttbConn then ttbConn:Disconnect(); ttbConn = nil end
    ttbCached = nil
    if on then
        ttbConn = Conns.add(RunService.Heartbeat:Connect(ttbStep))
    else
        ttbRestoreCollide()
    end
end

-- Respawn safety
Conns.add(LP.CharacterAdded:Connect(function(char)
    if State and State.Fly then Movement.stopFly() end
    if State and State.ToggleSprint then Movement.setSprint(false) end
    ttbCollideOrig = {}; ttbCached = nil          -- old parts are gone
end))

function Movement.init(state)
    State = state
    -- One-time heal: a previous build could leave a character with Landed /
    -- FallingDown disabled (constant falling). Re-enable them on every load.
    pcall(function()
        local hum = LP.Character and LP.Character:FindFirstChildWhichIsA("Humanoid")
        if hum then
            hum:SetStateEnabled(Enum.HumanoidStateType.Landed, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
        end
    end)
    Conns.onTeardown(function()
        Movement.stopFly(); Movement.setNoclip(false); ttbRestoreCollide()
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

-- Each entry now holds arrays of parry times + dodge times:
--   { sec=<times[1] mirror>, times={t1,t2,...}, dodges={d1,...}, cat, src, note }
-- `sec` stays in sync with times[1] for any old code/UI that reads it.
local function syncSec(e)
    e.sec = (e.times and e.times[1]) or e.sec
end
local function migrate()
    for id, v in pairs(timings) do
        if type(v) == "number" then
            timings[id] = { sec = v, times = { v }, dodges = {}, cat = "Uncategorized", src = "learned" }
        elseif type(v) == "table" then
            v.cat = v.cat or "Uncategorized"
            v.src = v.src or "manual"
            if type(v.times) ~= "table" then
                v.times = (type(v.sec) == "number") and { v.sec } or {}
            end
            if type(v.dodges) ~= "table" then v.dodges = {} end
            syncSec(v)
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

-- Bumps on every mutation so UIs (Timings tab) can auto-refresh when timings
-- change from ANY source (manual edit, Animation Visualizer, Player Timing…).
ParryTimings.rev = 0
local function save()
    ParryTimings.rev = ParryTimings.rev + 1
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
                timings[id] = { sec = sec, times = { sec },
                    dodges = (cur and cur.dodges) or {},
                    cat = (cur and cur.cat) or "Uncategorized", src = src }
                n = n + 1
            end
        end
    end
    save()
    return n
end

-- Returns the FIRST parry time (compat). Use getTimes for the full list.
function ParryTimings.lookup(animId)
    local v = timings[animId]
    if not v then return nil end
    if type(v) == "number" then return v end
    return (v.times and v.times[1]) or v.sec
end

-- Full lists. Always return a (possibly empty) array.
function ParryTimings.getTimes(animId)
    local v = timings[animId]
    if type(v) ~= "table" then
        return (type(v) == "number") and { v } or {}
    end
    return v.times or {}
end
function ParryTimings.getDodges(animId)
    local v = timings[animId]
    return (type(v) == "table" and v.dodges) or {}
end

local function ensureEntry(id, cat)
    local e = timings[id]
    if type(e) ~= "table" then
        e = { times = {}, dodges = {}, cat = cat or "Uncategorized", src = "manual" }
        timings[id] = e
    end
    e.times  = e.times  or {}
    e.dodges = e.dodges or {}
    if cat then e.cat = cat end
    return e
end
local function insertSorted(list, sec)
    -- avoid near-duplicates (within 10ms)
    for _, t in ipairs(list) do if math.abs(t - sec) < 0.01 then return false end end
    table.insert(list, sec)
    table.sort(list)
    return true
end

-- Append a parry time (multi-hit attacks can have several).
function ParryTimings.addParry(animId, seconds, cat)
    if not animId or animId == "" or type(seconds) ~= "number" then return false end
    local e = ensureEntry(tostring(animId), cat)
    local added = insertSorted(e.times, seconds)
    e.src = "manual"; syncSec(e); save()
    return added
end
-- Append a dodge time.
function ParryTimings.addDodge(animId, seconds, cat)
    if not animId or animId == "" or type(seconds) ~= "number" then return false end
    local e = ensureEntry(tostring(animId), cat)
    local added = insertSorted(e.dodges, seconds)
    e.src = "manual"; save()
    return added
end
-- Replace the parry time at index `idx` with a new value (keeps category).
-- Re-sorts afterwards so the list stays ordered. Returns true on success.
function ParryTimings.setParryAt(animId, idx, seconds)
    if type(seconds) ~= "number" then return false end
    local e = timings[animId]
    if type(e) == "table" and e.times and e.times[idx] then
        e.times[idx] = math.max(seconds, 0)
        table.sort(e.times)
        e.src = "manual"; syncSec(e); save()
        return true
    end
    return false
end
function ParryTimings.removeParryAt(animId, idx)
    local e = timings[animId]
    if type(e) == "table" and e.times and e.times[idx] then
        table.remove(e.times, idx); syncSec(e)
        if #e.times == 0 and #(e.dodges or {}) == 0 then timings[animId] = nil end
        save()
    end
end
function ParryTimings.removeDodgeAt(animId, idx)
    local e = timings[animId]
    if type(e) == "table" and e.dodges and e.dodges[idx] then
        table.remove(e.dodges, idx)
        if #(e.times or {}) == 0 and #e.dodges == 0 then timings[animId] = nil end
        save()
    end
end
-- Replace the dodge time at index `idx` with a new value (keeps the list sorted).
function ParryTimings.setDodgeAt(animId, idx, seconds)
    if type(seconds) ~= "number" then return false end
    local e = timings[animId]
    if type(e) == "table" and e.dodges and e.dodges[idx] then
        e.dodges[idx] = math.max(seconds, 0)
        table.sort(e.dodges)
        e.src = "manual"; save()
        return true
    end
    return false
end

function ParryTimings.all() return timings end
function ParryTimings.count()
    local c = 0; for _ in pairs(timings) do c = c + 1 end; return c
end

-- Mutators
-- Sets the PRIMARY parry time (times[1]); keeps any extra times + dodges.
function ParryTimings.set(animId, seconds, cat, note)
    if not animId or animId == "" or type(seconds) ~= "number" then return end
    local id = tostring(animId)
    local e = ensureEntry(id, cat)
    if e.times[1] then e.times[1] = seconds else table.insert(e.times, seconds) end
    table.sort(e.times)
    if note then e.note = note end
    e.src = "manual"; syncSec(e); save()
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
local Humanoids  = require("Utility/Humanoids")

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

-- Use the shared Humanoids registry instead of a second workspace scan +
-- DescendantAdded listener (those duplicated work the registry already does).
Humanoids.onAdded(function(hum)
    if hum.Parent ~= LP.Character then hookEnemy(hum) end
end)

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
    Fly=false, FlySpeed=100,
    Noclip=false,
    ToggleSprint=false,
    -- Tween To Back (attach behind nearest enemy)
    TweenToBack=false, TTBSticky=false, TTBIgnorePlayers=true,
    TTBDistance=5, TTBHeight=0, TTBSpeed=200, TTBRange=300,

    -- Visuals
    Fullbright=false,
    LowGfx=false,
    -- Individual visual removals (deepwoken-rewrite set). LowGfx flips all four.
    NoFog=false, NoBlur=false, NoShadows=false, NoAnimatedSea=false,
    ESP=false, ESPRange=1500, ESPHealth=true, ESPDistance=true, ESPName=true,
    ESPOutline=true, ESPWeapon=true, ESPSplitHealth=false,
    ESPPlayers=true, ESPNPCs=true, ESPMobs=true, ESPTextScale=100, ESPNameScale=100,
    ESPHitbox=false,                            -- draw the parry hitbox box
    ESPLimitUpdates=true, ESPRefreshRate=30,    -- throttle ESP redraws (updates/sec)
    ESPMaxTargets=0,                            -- cap rendered ESP objects to nearest N (0 = unlimited)
    ESPBox=false, ESPBoxBar=true,               -- 2D screen-space box + side health bar
    ESPSplitUpdates=false, ESPSplitFrames=3,    -- spread tag updates across N ticks
    NoPersistentESP=false,                      -- let ESP character models stream out
    StreamProof=true,                           -- hide the menu/GUIs from screen capture
    YouTuberChecker=false,                       -- toast when a known YouTuber joins
    -- ESP combat stats (Type Soul: read from each character's Status folder)
    ESPReiatsu=false, ESPPosture=false, ESPStamina=false, ESPRaceForm=false, ESPStates=false,
    AnimViz=false, AnimAllChars=true, AnimVizRange=0,   -- 0 = unlimited

    -- Combat / AutoParry  (tuned defaults: reliable parrying out of the box)
    -- DetectionRange is the SINGLE distance AutoParry uses for everything:
    -- proximity gate + attack-hitbox width/height/reach. The legacy keys below
    -- are kept in lockstep with it (Combat.setDetectionRange / Combat.init) so
    -- they can never drift. Lower it to stop parrying far-away attacks.
    AutoParry=false, DetectionRange=18, AutoParryKey="MouseButton2",
    AutoParryRange=18,                          -- derived from DetectionRange
    AutoDodge=true,                             -- dash (Requests.Dash) on saved dodge timings
    TimingOffset=0,                             -- manual fine-tune (seconds, +later/−earlier)
    BlockHold=0.35,                             -- how long to hold block so it's active at impact (s)
    ParryNearestOnly=false, ParryPlayersOnly=false, ParryMobsOnly=false,
    ParryFacingMe=false, FacingDot=0.35,        -- only parry attackers facing you (~70° cone)
    FacingPredict=true, HitboxHistory=true,     -- deepwoken-style: predict turn-ins + test recent positions
    ParryWhenUnfocused=false,
    HitboxPredict=false, HitboxSize=18,         -- derived from DetectionRange (width/height, studs)
    HitboxReach=18,                             -- derived from DetectionRange (forward depth, studs)
    -- Hitbox Range — projectile/hitbox PROXIMITY detection, separate from the
    -- animation-timing parry and from Detection Range above. Reacts to the actual
    -- projectile position for ranged attacks instead of the (early) animation.
    HitboxRangeMode=false,                       -- master toggle for the mode
    HitboxRangeParry=true, HitboxRangeDodge=false,  -- which reaction fires on entry
    HitboxParryRange=25, HitboxParryDelay=0,     -- studs ; seconds after entry
    HitboxDodgeRange=25, HitboxDodgeDelay=0,     -- studs ; seconds after entry
    HitboxMinDist=0,                             -- only watch projectiles that APPEAR ≥ this far (filters local melee effects); 0 = off (default, so projectile parry always works)
    HitboxAutoDetect=true,                       -- name-agnostic: react to ANY part that travels + approaches you (no capture list needed)
    HitboxAutoMinAxis=1.2,                       -- auto-detect ignores parts whose biggest dimension is under this (skips tiny spark/blood particles)
    HitboxAutoMaxAxis=130,                        -- auto-detect ignores parts BIGGER than this (skips map geometry; ceros can be ~100 studs so keep this high)
    RepeatOnMiss=true, RepeatOnMissMax=2,       -- re-attempt parry if one whiffs
    HighPing=false,                             -- press earlier + hold longer for jittery 150ms+ ping
    Feint=false, FeintWindow=0.25,              -- feint your swing if mid-attack when parrying
    SmartHit=false, SmartHitWindow=0.25,        -- "Auto Feint": feint own swing when a parry is imminent
    AutoFeintType="Passive", DelayedFeints=false, -- Auto Feint mode (Passive/Aggressive) + hold to latest moment
    PlayerTiming=false, PlayerTimingRange=22,   -- learn parry timings; PlayerTimingProjDist = projectile capture distance
    PlayerTimingProjDist=40,                      -- only capture projectiles that come within this far
    -- deepwoken extras
    FailSim=false, FailRate=10,                 -- intentionally miss FailRate% of parries (look human)
    RPUE=false, RPUEInterval=200,               -- repeat-until-end: re-block every N ms while the attack plays
    APBreaker=false, APBreakerSpeed=6,          -- ignore spoofed animations (abnormal speed / near-zero weight)

    -- Spyware / Remote Spy
    Spyware=false, SpyPaused=false, SpySelf=true, SpyEnemies=false,

    -- Mod checker / debug / notifications
    ModeratorChecker=true, Debug=false,
    NotificationsEnabled=true,
    NotifToggles=true, NotifSafety=true,        -- per-category notification filters
    KeybindHud=true,
}

end)
return __bundle_require("__root")