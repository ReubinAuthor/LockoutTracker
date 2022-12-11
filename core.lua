----------------------------------------
-- Core
----------------------------------------
local myAddon, core = ...

core.func = {};
core.data = {
    saved = { dungeons = {}, raids_10 = {}, raids_25 = {} }
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

                    -- Coloring Dungeons buttons
                    if string.match(activityGroupName, "Heroic") and data.saved.dungeons[activityInfo.shortName] then
                        button.NameButton.Name:SetTextColor(1,0,0);
                    else
                        button.NameButton.Name:SetTextColor(1,0.82,0);
                    end

                    -- Coloring Raids butttons
                    if string.match(activityGroupName, "Raids") then
                        if string.match(activityGroupName, "10") and data.saved.raids_10[activityInfo.shortName] then
                            button.NameButton.Name:SetTextColor(1,0,0);
                        elseif string.match(activityGroupName, "25") and data.saved.raids_25[activityInfo.shortName] then
                            button.NameButton.Name:SetTextColor(1,0,0);
                        elseif not string.match(activityGroupName, "10") and not string.match(activityGroupName, "25")
                        and (data.saved.raids_10[activityInfo.shortName] or data.saved.raids_25[activityInfo.shortName])
                        then
                            button.NameButton.Name:SetTextColor(1,0,0);
                        else
                            button.NameButton.Name:SetTextColor(1,0.82,0);
                        end
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