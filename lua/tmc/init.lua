if CLIENT then
    local notificationsEnabled = CreateClientConVar("tmc_notifications", "1", true, false, "Enable or disable notifications when tmc_togglemousecursor executes", 0, 1):GetBool()
    cvars.AddChangeCallback("tmc_notifications", function(_, _, new) notificationsEnabled = tobool(new) end)
    local enabled = false
    local worldPanel = vgui.GetWorldPanel()
    local hudPanel = GetHUDPanel()
    concommand.Add("tmc_togglemousecursor", function()
        enabled = not enabled
        gui.EnableScreenClicker(enabled)
        worldPanel:SetWorldClicker(enabled)
        hudPanel:SetWorldClicker(enabled)
        if notificationsEnabled then
            local text = enabled and "Cursor Unlocked" or "Cursor Locked"
            notify(text, 1, 0.5)
        end
    end)
end