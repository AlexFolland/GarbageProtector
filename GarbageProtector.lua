--default values for options saved between sessions
local GarbageProtectorDBDefaults = {
    Enabled = true,
    Handlecollectgarbage = true,
    HandleUpdateAddOnMemoryUsage = true
}

--function to initialize missing saved variables with default values
local function InitializeGarbageProtectorDB(defaults)
    if GarbageProtectorDB == nil then GarbageProtectorDB = {} end
    for k,v in pairs(defaults) do
        if GarbageProtectorDB[k] == nil then
            GarbageProtectorDB[k] = defaults[k]
        end
    end
end

--option setter functions
--setter functions exposed globally to allow other addons and scripts to easily override GarbageProtector if they really need to
--both parameters in each setter function are booleans
--force lets you guarantee target state (true == enabled) (false == disabled)
--shouldPrint decides whether the setter prints the setting's new state
function ToggleGarbageProtector(force, shouldPrint)
    if GarbageProtectorDB == nil or GarbageProtectorDB.Enabled == nil then InitializeGarbageProtectorDB(GarbageProtectorDBDefaults) end
    if force ~= nil then GarbageProtectorDB.Enabled = force else GarbageProtectorDB.Enabled = not GarbageProtectorDB.Enabled end
    if shouldPrint ~= nil and shouldPrint == true then
        print("GarbageProtector is now "..(GarbageProtectorDB.Enabled and "enabled." or "disabled."))
    end
    if GarbageProtectorEnabledCheckButton == nil then return end
    GarbageProtectorEnabledCheckButton:SetChecked(GarbageProtectorDB.Enabled)
end

function ToggleHandlecollectgarbage(force, shouldPrint)
    if GarbageProtectorDB == nil or GarbageProtectorDB.Handlecollectgarbage == nil then InitializeGarbageProtectorDB(GarbageProtectorDBDefaults) end
    if force ~= nil then GarbageProtectorDB.Handlecollectgarbage = force else GarbageProtectorDB.Handlecollectgarbage = not GarbageProtectorDB.Handlecollectgarbage end
    if shouldPrint ~= nil and shouldPrint == true then
        print("GarbageProtector: Handling collectgarbage calls is now "..(GarbageProtectorDB.Handlecollectgarbage and "enabled." or "disabled."))
    end
    if GarbageProtectorHandlecollectgarbageCheckButton == nil then return end
    GarbageProtectorHandlecollectgarbageCheckButton:SetChecked(GarbageProtectorDB.Handlecollectgarbage)
end

function ToggleHandleUpdateAddOnMemoryUsage(force, shouldPrint)
    if GarbageProtectorDB == nil or GarbageProtectorDB.HandleUpdateAddOnMemoryUsage == nil then InitializeGarbageProtectorDB(GarbageProtectorDBDefaults) end
    if force ~= nil then GarbageProtectorDB.HandleUpdateAddOnMemoryUsage = force else GarbageProtectorDB.HandleUpdateAddOnMemoryUsage = not GarbageProtectorDB.HandleUpdateAddOnMemoryUsage end
    if shouldPrint ~= nil and shouldPrint == true then
        print("GarbageProtector: Handling UpdateAddOnMemoryUsage calls is now "..(GarbageProtectorDB.HandleUpdateAddOnMemoryUsage and "enabled." or "disabled."))
    end
    if GarbageProtectorHandleUpdateAddOnMemoryUsageCheckButton == nil then return end
    GarbageProtectorHandleUpdateAddOnMemoryUsageCheckButton:SetChecked(GarbageProtectorDB.HandleUpdateAddOnMemoryUsage)
end

--GUI options menu; manually crafted for funzies, mental laziness, naivety, full control, or something
local optionsMenu = CreateFrame("Frame", "GarbageProtectorOptionsMenu", InterfaceOptionsFramePanelContainer)

local enabledCheckButton = CreateFrame("CheckButton", "GarbageProtectorEnabledCheckButton", optionsMenu, "OptionsCheckButtonTemplate")
enabledCheckButton:SetPoint("TOPLEFT", 16, -16)
enabledCheckButton:SetHitRectInsets(0, -50, 0, 0)
enabledCheckButton:SetScript("OnClick", function() ToggleGarbageProtector(nil, false) end)
enabledCheckButton:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_NONE")
    GameTooltip:SetPoint("BOTTOMLEFT", self, "TOPLEFT")
    GameTooltip:AddLine("This option effectively decides whether GarbageProtector's hooks do anything.\nGarbageProtector hooks these functions on load either way.\nIf you want to completely disable the hooks, you'll have to disable GarbageProtector from the addons list and reload UI.",nil,nil,nil,false)
    GameTooltip:Show()
end)
enabledCheckButton:SetScript("OnLeave", function() GameTooltip:Hide() end)
_G[enabledCheckButton:GetName() .. "Text"]:SetText("Enabled")

local handlecollectgarbageCheckButton = CreateFrame("CheckButton", "GarbageProtectorHandlecollectgarbageCheckButton", optionsMenu, "OptionsCheckButtonTemplate")
handlecollectgarbageCheckButton:SetPoint("TOPLEFT", enabledCheckButton, "BOTTOMLEFT", 0, -8)
handlecollectgarbageCheckButton:SetScript("OnClick", function() ToggleHandlecollectgarbage(nil, false) end)
handlecollectgarbageCheckButton:SetHitRectInsets(0, -170, 0, 0)
handlecollectgarbageCheckButton:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_NONE")
    GameTooltip:SetPoint("BOTTOMLEFT", self, "TOPLEFT")
    GameTooltip:AddLine("Screw those irresponsible collectgarbage calls! Yeah!",nil,nil,nil,false)
    GameTooltip:Show()
end)
handlecollectgarbageCheckButton:SetScript("OnLeave", function() GameTooltip:Hide() end)
_G[handlecollectgarbageCheckButton:GetName() .. "Text"]:SetText("Handle collectgarbage calls")

local handleUpdateAddOnMemoryUsageCheckButton = CreateFrame("CheckButton", "GarbageProtectorHandleUpdateAddOnMemoryUsageCheckButton", optionsMenu, "OptionsCheckButtonTemplate")
handleUpdateAddOnMemoryUsageCheckButton:SetPoint("TOPLEFT", handlecollectgarbageCheckButton, "BOTTOMLEFT", 0, -8)
handleUpdateAddOnMemoryUsageCheckButton:SetScript("OnClick", function() ToggleHandleUpdateAddOnMemoryUsage(nil, false) end)
handleUpdateAddOnMemoryUsageCheckButton:SetHitRectInsets(0, -260, 0, 0)
handleUpdateAddOnMemoryUsageCheckButton:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_NONE")
    GameTooltip:SetPoint("BOTTOMLEFT", self, "TOPLEFT")
    GameTooltip:AddLine("UpdateAddOnMemoryUsage is a waste of CPU time and some addons call it periodically when they shouldn't.\nThis option effectively decides whether GarbageProtector's UpdateAddOnMemoryUsage hook should prevent execution.\nWarning: All in-game memory usage reports obtained with GetAddOnMemoryUsage will be reported as 0 or the last returned value if this is enabled.",nil,nil,nil,false)
    GameTooltip:Show()
end)
handleUpdateAddOnMemoryUsageCheckButton:SetScript("OnLeave", function() GameTooltip:Hide() end)
_G[handleUpdateAddOnMemoryUsageCheckButton:GetName() .. "Text"]:SetText("Handle UpdateAddOnMemoryUsage calls")

optionsMenu.name = "GarbageProtector"
InterfaceOptions_AddCategory(optionsMenu)

--handle PLAYER_ENTERING_WORLD events for initializing GUI options menu widget states at the right time
--UI reload doesn't seem to fire ADDON_LOADED
optionsMenu:RegisterEvent("PLAYER_ENTERING_WORLD")
optionsMenu:RegisterEvent("ADDON_LOADED")
optionsMenu:SetScript("OnEvent", function (self, event, arg1, ...)
    if event == "PLAYER_ENTERING_WORLD" or arg1 == "GarbageProtector" then
        InitializeGarbageProtectorDB(GarbageProtectorDBDefaults)
        GarbageProtectorEnabledCheckButton:SetChecked(GarbageProtectorDB.Enabled)
        GarbageProtectorHandlecollectgarbageCheckButton:SetChecked(GarbageProtectorDB.Handlecollectgarbage)
        GarbageProtectorHandleUpdateAddOnMemoryUsageCheckButton:SetChecked(GarbageProtectorDB.HandleUpdateAddOnMemoryUsage)

        optionsMenu:UnregisterAllEvents()
        optionsMenu:SetScript("OnEvent", nil)
    end
end)

--CLI options menu
_G["SLASH_GarbageProtector1"] = "/garbageprotector"
_G["SLASH_GarbageProtector2"] = "/gp"
_G["SLASH_GarbageProtector3"] = "/garbage"
SlashCmdList["GarbageProtector"] = function(msg)
    param1, param2, param3 = msg:match("([^%s,]*)[%s,]*([^%s,]*)[%s,]*([^%s,]*)[%s,]*")
    --print("Parameters passed were: "..tostring(param1).." "..tostring(param2).." "..tostring(param3))
    if param1 == "toggle" or param1 == "release" then
        ToggleGarbageProtector(nil, true)
    elseif param1 == "enable" or param1 == "on" or param1 == "start" then
        ToggleGarbageProtector(true, true)
    elseif param1 == "disable" or param1 == "off" or param1 == "stop" then
        ToggleGarbageProtector(false, true)
    elseif param1 == "collectgarbage" then
        if param2 == "enable" or param2 == "on" or param2 == "start" then
            ToggleHandlecollectgarbage(true, true)
        elseif (param2 == "disable" or param2 == "off" or param2 == "stop") then
            ToggleHandlecollectgarbage(false, true)
        else
            ToggleHandlecollectgarbage(nil, true)
        end
    elseif param1 == "UpdateAddOnMemoryUsage" then
        if param2 == "enable" or param2 == "on" or param2 == "start" then
            ToggleHandleUpdateAddOnMemoryUsage(true, true)
        elseif (param2 == "disable" or param2 == "off" or param2 == "stop") then
            ToggleHandleUpdateAddOnMemoryUsage(false, true)
        else
            ToggleHandleUpdateAddOnMemoryUsage(nil, true)
        end
    elseif (param1 == "") then
        InterfaceOptionsFrame_OpenToCategory(optionsMenu)
    else
        print("GarbageProtector: "..(param1 == "help" and "" or "Unrecognized command. ").."Recognized commands:")
        print("    \"/gp\": GUI options menu")
        print("    \"/gp help\": list CLI slash commands")
        print("    \"/gp toggle/[enable/on/start]/[disable/off/stop]\": toggle whether GP should handle any function calls")
        print("    \"/gp collectgarbage [enable/on/start]/[disable/off/stop]\": toggle whether GP should handle collectgarbage calls (prevents collectgarbage calls for slow full garbage collection cycles)")
        print("    \"/gp UpdateAddOnMemoryUsage [enable/on/start]/[disable/off/stop]\": toggle whether GP should handle UpdateAddOnMemoryUsage calls (makes GetAddOnMemoryUsage always return 0 or the last returned value)")
    end
end

--main functionality; dirty collectgarbage hook; so beautiful!
local oldcollectgarbage = collectgarbage
oldcollectgarbage("setpause", 110)
oldcollectgarbage("setstepmul", 200)

collectgarbage = function(opt, arg)
    if GarbageProtectorDB == nil or GarbageProtectorDB.Enabled == nil or GarbageProtectorDB.Handlecollectgarbage == nil then InitializeGarbageProtectorDB(GarbageProtectorDBDefaults) end
    if GarbageProtectorDB.Handlecollectgarbage == false or GarbageProtectorDB.Enabled == false then
        return oldcollectgarbage(opt, arg)
    end

    --print("collectgarbage was called by "..strtrim(debugstack(2, 1, 0)).."; opt == \""..tostring(opt).."\", arg == \""..tostring(arg).."\"")
    if opt == "collect" or opt == nil then
        --fuck addons that want to run full garbage collections, blocking all execution for way too long; no!
    elseif opt == "count" then
        --this probably just returns the GC's current count, so it should be okay
        return oldcollectgarbage(opt, arg)
    elseif opt == "setpause" then
        --prevents addons from changing GC pause from default of 110, but still returns current value
        return oldcollectgarbage("setpause", 110)
    elseif opt == "setstepmul" then
        --prevents addons from changing GC step multiplier from default of 200, but still returns current value
        return oldcollectgarbage("setstepmul", 200)
    elseif opt == "stop" then
        --no brakes!
    elseif opt == "restart" then
        --why?  no
    elseif opt == "step" then
        if arg ~= nil then
            if arg <= 10000 then
                --addons running collectgarbage in small steps are okay
                return oldcollectgarbage(opt, arg)
            end
        else
            --default step value is probably okay too
            return oldcollectgarbage(opt, arg)
        end
    else
        --if lua adds something new like isrunning to this, it should still work
        return oldcollectgarbage(opt, arg)
    end
end

--UpdateAddOnMemoryUsage is a waste of time and some addons like Details call it periodically for no apparent reason
--this hook makes memory profiling addons that call GetAddOnMemoryUsage show 0 or the last returned value of course
local oldUpdateAddOnMemoryUsage = UpdateAddOnMemoryUsage
UpdateAddOnMemoryUsage = function(...)
    if GarbageProtectorDB == nil or GarbageProtectorDB.Enabled == nil or GarbageProtectorDB.HandleUpdateAddOnMemoryUsage == nil then InitializeGarbageProtectorDB(GarbageProtectorDBDefaults) end
    if GarbageProtectorDB.HandleUpdateAddOnMemoryUsage == false or GarbageProtectorDB.Enabled == false then
        return oldUpdateAddOnMemoryUsage(...)
    end
end

--[[
--deprecated, but Tablet-2.0 still uses this and some addons still use that
--commented out because gcinfo is just like collectgarbage("count") which is fine
local oldgcinfo = gcinfo

gcinfo = function(...)
    print("gcinfo was called by "..strtrim(debugstack(2, 1, 0)).."; args == \""..tostring(...).."\"")
    return oldgcinfo(...)
end
]]

--macro to check current addon memory usage
--/run UpdateAddOnMemoryUsage()local total = 0 for i=1,GetNumAddOns()do total=total+GetAddOnMemoryUsage(i)end print(total)