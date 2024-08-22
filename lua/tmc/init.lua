if CLIENT then
    surface.CreateFont("tmc_NotifyFont", {
        font = "Arial",
        size = 24,
        additive = true,
        weight = 50,
    })

    local notificationsEnabled = CreateClientConVar("tmc_notifications", "1", true, false, "Enable or disable notifications when tmc_togglemousecursor executes", 0, 1):GetBool()
    cvars.AddChangeCallback("tmc_notifications", function(_, _, new) notificationsEnabled = tobool(new) end)
    local enabled = false
    local worldPanel = vgui.GetWorldPanel()
    local hudPanel = GetHUDPanel()
    local debounce = false
    local WHITE = Color(255, 255, 255, 255)
    local playPing
    do
        local sound = Sound("resource/warning.wav")
        function playPing()
            EmitSound(sound, vector_origin, -2, CHAN_AUTO, 0.05, 75, 0, 255, 3, 105)
        end
    end

    -- changes EnableScreenClicker so even if another addon disables screen clicking, this addon's state still keeps it enabled
    -- naturally introduces incompatibilities with addons that change gui.EnableScreenClicker 
    gui.tmc_EnableScreenClickerInternal = gui.EnableScreenClicker
    function gui.EnableScreenClicker(bool)
        gui.tmc_EnableScreenClickerInternal(bool or enabled)
    end

    local function notify(text, lifetime, debounceTime)
        if debounce then return end
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
        timer.Simple(debounceTime, function() debounce = false end)
        timer.Simple(lifetime + 1, function() notifyPanel:Remove() end)
    end

    local function handleToggleMouse()
        enabled = not enabled
        gui.EnableScreenClicker(enabled)
        worldPanel:SetWorldClicker(enabled)
        hudPanel:SetWorldClicker(enabled)
        if notificationsEnabled then
            local text = enabled and "Cursor Unlocked" or "Cursor Locked"
            notify(text, 1, 0.5)
        end
    end

    concommand.Add("tmc_togglemousecursor", handleToggleMouse)
end