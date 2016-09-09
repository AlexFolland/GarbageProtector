local oldcollectgarbage = collectgarbage
oldcollectgarbage("setpause", 110)
oldcollectgarbage("setstepmul", 200)

collectgarbage = function(opt, arg)
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

--[[
--deprecated, but Tablet-2.0 still uses this and some addons still use that
local oldgcinfo = gcinfo

gcinfo = function(...)
    print("gcinfo was called by "..strtrim(debugstack(2, 1, 0)).."; args == \""..tostring(...).."\"")
    return oldgcinfo(...)
end
]]