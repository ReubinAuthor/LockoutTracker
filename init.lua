----------------------------------------
-- CORE
----------------------------------------
local myAddon, core = ...;
local func = core.func;
local data = core.data;

----------------------------------------
-- HANDLING EVENTS 
----------------------------------------
function core:init(event, ...)
    local arg = ...

    if event == "PLAYER_ENTERING_WORLD"
    or event == "UPDATE_INSTANCE_INFO"
    or event == "LFG_LIST_AVAILABILITY_UPDATE"
    then
        func:CheckLocks();
    end

    --[[
    if event == "BOSS_KILL"
    or event == "INSTANCE_LOCK_START"
    or event == "INSTANCE_LOCK_STOP"
    then
        print(event);
    end
    ]]
end

----------------------------------------
-- REGISTERING EVENTS
----------------------------------------
local events = CreateFrame("Frame");

-- Events
events:RegisterEvent("PLAYER_ENTERING_WORLD");
events:RegisterEvent("UPDATE_INSTANCE_INFO");
events:RegisterEvent("LFG_LIST_AVAILABILITY_UPDATE");
--events:RegisterEvent("BOSS_KILL");
--events:RegisterEvent("INSTANCE_LOCK_START");
--events:RegisterEvent("INSTANCE_LOCK_STOP");

-- Scripts
events:SetScript("OnEvent", core.init);