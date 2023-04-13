local unitId = 192934; -- Inactive Infuser

local visitedGuid = nil;
local currentMarkerIndex = 0;

local frame = CreateFrame("Frame");

local markers = {
  [1] = 1, -- star
  [2] = 2, -- circle
  [3] = 6, -- square
  [4] = 4, -- triangle
  [5] = 3, -- diamond
};

local function onTargetChanged()
  if not IsShiftKeyDown() or not IsAltKeyDown() then
    return;
  end

  local guid = UnitGUID("target");

  if not guid then
    return;
  end

  local unit_type = strsplit("-", guid);

  if unit_type ~= "Creature" then
    return;
  end

  if visitedGuid == guid then
    return;
  end

  local _, _, server_id, instance_id, zone_id, npc_id, spawn_id = strsplit("-", guid);

  if tonumber(npc_id) ~= unitId then
    return;
  end

  currentMarkerIndex = (currentMarkerIndex % #markers) + 1;
  local currentMarkerId = markers[currentMarkerIndex];
  SetRaidTarget("target", currentMarkerId);
end

frame:SetScript("OnEvent", function(_, event, unitId)
  if event == "UNIT_TARGET" then
    if unitId == "player" then
      onTargetChanged();
    end
  end
end)

frame:RegisterEvent("UNIT_TARGET");
