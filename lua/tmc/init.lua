if SERVER then
	return
end

local NOTIFICATION_PATH = "tmc/notification.json"
local SOUND_PATH = "tmc/notification.mp3"
local DEFAULT_NOTIFICATION = {
	["unlocked"] = "Cursor Unlocked",
	["locked"] = "Cursor Locked",
}
local WHITE = Color(255, 255, 255, 255)

surface.CreateFont("tmc_NotifyFont", {
	font = "Arial",
	size = 24,
	weight = 50,
	shadow = true,
})

local notificationsEnabled = CreateClientConVar(
	"tmc_notifications",
	"1",
	true,
	false,
	"Enable or disable notifications when tmc_togglemousecursor executes",
	0,
	1
)

local blockEntityMenu = CreateClientConVar(
	"tmc_blockentitymenu",
	"0",
	true,
	false,
	"Disable context options pop-up when right-clicking on an entity",
	0,
	1
)

local enabled = false
local debounce = false
local worldPanel = vgui.GetWorldPanel()
local hudPanel = GetHUDPanel()

local playPing
do
	sound.Add({
		sound = SOUND_PATH,
		name = "tmc_notificationSound",
		channel = CHAN_STATIC,
		level = SNDLVL_NONE,
		volume = 1,
		pitch = 100,
	})
	function playPing()
		surface.PlaySound(SOUND_PATH)
	end
end

-- Track when the context key is set, so we can still attempt to open the entity menu
-- when the context menu key is down
local isContextKeyDown = false
hook.Remove("OnContextMenuOpen", "tmc_trackContextMenu")
hook.Add("OnContextMenuOpen", "tmc_trackContextMenu", function()
	isContextKeyDown = true
end)
hook.Remove("OnContextMenuClose", "tmc_trackContextMenu")
hook.Add("OnContextMenuClose", "tmc_trackContextMenu", function()
	isContextKeyDown = false
end)

-- detours EnableScreenClicker so even if another addon disables screen clicking, this addon's state still keeps it enabled
gui.tmc_EnableScreenClickerInternal = gui.tmc_EnableScreenClickerInternal or gui.EnableScreenClicker
function gui.EnableScreenClicker(bool, ...)
	return gui.tmc_EnableScreenClickerInternal(bool or enabled, ...)
end

-- detours OpenEntityMenu to control opening the entity menu by ConVar if the cursor is free
properties.tmc_OpenEntityMenuInternal = properties.tmc_OpenEntityMenuInternal or properties.OpenEntityMenu
function properties.OpenEntityMenu(ent, tr, ...)
	if blockEntityMenu:GetBool() and enabled and not isContextKeyDown then
		return
	end

	return properties.tmc_OpenEntityMenuInternal(ent, tr, ...)
end

---Get custom cursor text from a json file located in the path.
---Called everytime we want to notify. Hence, live updates are possible.
---@param path string
---@return TMCData
local function getCustomText(path)
	if not file.Exists("tmc", "DATA") then
		file.CreateDir("tmc")
	end
	if not file.Exists(path, "DATA") then
		file.Write(path, util.TableToJSON(DEFAULT_NOTIFICATION, true))
	end

	local data = file.Read(path, "DATA")
	return data and util.JSONToTable(data)
end

---Tell the user that they have locked or unlocked their cursor
---@param text string
---@param lifetime number
---@param debounceTime number
local function notify(text, lifetime, debounceTime)
	if debounce then
		return
	end
	playPing()
	local notifyPanel = vgui.Create("DNotify")
	local scrW, scrH = ScrW(), ScrH()
	local xSize, ySize = scrW * 0.25, scrH * 0.1
	local screenX, screenY = scrW / 2 - xSize / 2, scrH / 2 - 80
	notifyPanel:SetSize(xSize, ySize)
	notifyPanel:SetPos(screenX, screenY)
	local lbl = vgui.Create("DLabel", notifyPanel)
	lbl:Dock(FILL)
	lbl:SetText(text)
	lbl:SetFont("tmc_NotifyFont")
	lbl:SetColor(WHITE)
	lbl:SetContentAlignment(5)
	lbl:SetWorldClicker(true)
	notifyPanel:AddItem(lbl, lifetime)
	notifyPanel:MoveTo(screenX, screenY - 30, lifetime, 0, 2)
	notifyPanel:SetWorldClicker(true)
	debounce = true
	timer.Simple(debounceTime, function()
		debounce = false
	end)
	timer.Simple(lifetime + 1, function()
		notifyPanel:Remove()
	end)
end

local function handleToggleMouse()
	enabled = not enabled
	gui.EnableScreenClicker(enabled)
	worldPanel:SetWorldClicker(enabled)
	hudPanel:SetWorldClicker(enabled)
	if notificationsEnabled:GetBool() then
		local customText = getCustomText(NOTIFICATION_PATH)
		local text = enabled and customText.unlocked or customText.locked
		notify(text, 1, 0.5)
	end
end

concommand.Add("tmc_togglemousecursor", handleToggleMouse)
