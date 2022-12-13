----------------------------------------
-- Core
----------------------------------------
local myAddon, core = ...

core.func = {};
core.data = {
    saved = { dungeons = {}, raids_10 = {}, raids_25 = {}, raids_xx = {} }
};

local func = core.func;
local data = core.data;

-- Checking lockouts
function func:CheckLocks()

    -- Storing locked dungeons names
    for i = 1, GetNumSavedInstances() do
        local name, _, _, difficulty, _, _, _, _, maxPlayers = GetSavedInstanceInfo(i);

        if name then
            if maxPlayers == 5 then
                data.saved.dungeons[name] = 1;
            elseif maxPlayers == 10 then
                data.saved.raids_10[name] = 1;
            elseif maxPlayers == 25 then
                data.saved.raids_25[name] = 1;
            else
                data.saved.raids_xx[name] = 1;
            end
        end
    end

    if not data.hook then
        hooksecurefunc("LFGListingActivityView_InitActivityButton", function(button, elementData)
            for k,v in pairs(elementData) do
                if k == 'activityID' then
                    local activityInfo = C_LFGList.GetActivityInfoTable(v);
                    local activityGroupName = C_LFGList.GetActivityGroupInfo(activityInfo.groupFinderActivityGroupID);
    
                    -- Reseting button colors to default
                    button.NameButton.Name:SetTextColor(1,0.82,0);

                    local function matchDungeons()
                        for k,v in pairs(data.saved.dungeons) do
                            local LFGName = activityInfo.fullName;

                            if string.match(string.lower(LFGName), string.lower(k)) or string.match(string.lower(k), string.lower(LFGName)) then
                                return true;
                            end
                        end
                    end

                    local function matchRaids(raids)
                        if raids then
                            for k,v in pairs(data.saved[raids]) do
                                local LFGName = activityInfo.fullName;

                                if string.match(string.lower(LFGName), string.lower(k)) or string.match(string.lower(k), string.lower(LFGName)) then
                                    return true;
                                end
                            end
                        end
                    end

                    -- Dungeons
                    if (activityInfo.groupFinderActivityGroupID == 289 or activityInfo.groupFinderActivityGroupID == 288) and matchDungeons() then
                        button.NameButton.Name:SetTextColor(1,0,0);
                    -- Wrath 10
                    elseif activityInfo.groupFinderActivityGroupID == 292 and matchRaids("raids_10") then
                        button.NameButton.Name:SetTextColor(1,0,0);
                    -- Wrath 25
                    elseif activityInfo.groupFinderActivityGroupID == 293 and matchRaids("raids_25") then
                        button.NameButton.Name:SetTextColor(1,0,0);
                    -- Rest
                    elseif (activityInfo.groupFinderActivityGroupID == 290 or activityInfo.groupFinderActivityGroupID == 291)
                        and (matchRaids("raids_10") or matchRaids("raids_25") or matchRaids("raids_xx"))
                    then
                        button.NameButton.Name:SetTextColor(1,0,0);
                    else
                        button.NameButton.Name:SetTextColor(1,0.82,0);
                    end
                end
            end
        end);
    
        hooksecurefunc("LFGListingActivityView_InitActivityGroupButton", function(button, elementData, isCollapsed)
            button.NameButton.Name:SetTextColor(0.65, 0.65, 0.65);
        end);

        -- Making sure it will never hook more than once
        data.hook = 1;
    end
end