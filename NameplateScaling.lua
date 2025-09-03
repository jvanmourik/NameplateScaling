local ADDON_NAME = ...

local defaultSettings = {
    -- Raises the nameplate slightly above the entity
    nameplateZ = 1.0,
    -- Fades the nameplate when its entity is behind terrain
    nameplateIntersectOpacity = 0.1,
    -- Use camera-to-entity intersection instead of player-to-entity
    nameplateIntersectUseCamera = 1,
    -- Fades nameplates in smoothly instead of appearing instantly
    nameplateFadeIn = 1
}

local addon = CreateFrame("Frame");

function addon:ADDON_LOADED(name)
    if name ~= ADDON_NAME then
        return
    end

    SetCVar("nameplateZ", defaultSettings.nameplateZ)
    SetCVar("nameplateIntersectOpacity", defaultSettings.nameplateIntersectOpacity)
    SetCVar("nameplateIntersectUseCamera", defaultSettings.nameplateIntersectUseCamera)
    SetCVar("nameplateFadeIn", defaultSettings.nameplateFadeIn)

    self:UnregisterEvent("ADDON_LOADED")
end

function addon:OnEvent(event, ...)
    self[event](self, ...)
end

local function isNameplate(frame)
	local healthBarBorder = select(2, frame:GetRegions())
	return healthBarBorder and healthBarBorder:GetObjectType() == "Texture" and
    healthBarBorder:GetTexture() == [[Interface\Tooltips\Nameplate-Border]]
end

local function getNameplateRegions(nameplate)
    local regions = {}
    regions.threatGlow, regions.healthBarBorder, regions.castBarBorder, regions.castBarShieldBorder, regions.spellIcon, regions.highlight, regions.name, regions.level, regions.skullIcon, regions.raidIcon, regions.eliteIcon = nameplate:GetRegions()
    return regions
end

local function onFrameShow(frame)
    local nameplate = frame:GetParent()
    local healthBar, _ = nameplate:GetChildren()
    local regions = getNameplateRegions(nameplate)

    frame.eliteIcon:SetShown(regions.eliteIcon:IsShown())

    if regions.skullIcon:IsShown() then
        frame.skullIcon:Show()
        frame.level:Hide()
    else
        frame.skullIcon:Hide()
        frame.level:Show()
    end

    frame.healthBar:SetMinMaxValues(healthBar:GetMinMaxValues())
    frame.healthBar:SetValue(healthBar:GetValue())
    frame.healthBar:SetStatusBarColor(healthBar:GetStatusBarColor())
    frame.name:SetText(regions.name:GetText())
    frame.level:SetText(regions.level:GetText())
    frame.level:SetTextColor(regions.level:GetTextColor())
end

local function onHealthBarValueChanged(frame, value)
    local nameplate = frame:GetParent()
    local regions = getNameplateRegions(nameplate)

    frame.healthBar:SetValue(value)
end

local function onCastBarShow(frame)
    local nameplate = frame:GetParent()
    local _, castBar = nameplate:GetChildren()
    local regions = getNameplateRegions(nameplate)
    local castIsInterruptible = regions.castBarBorder:IsShown()
    
    frame.castBar:Show()
    frame.spellIcon:Show()

    if castIsInterruptible then
        frame.castBarBorder:Show()
        frame.castBar:SetPoint("BOTTOMRIGHT", frame.castBarBorder, -6, 6)
        frame.spellIcon:SetPoint("CENTER", frame.castBarBorder, "BOTTOMLEFT", 18, 14)
    else
        frame.castBarShieldBorder:Show()
        frame.castBar:SetPoint("BOTTOMRIGHT", frame.castBarShieldBorder, -6, 18)
        frame.spellIcon:SetPoint("CENTER", frame.castBarShieldBorder, "BOTTOMLEFT", 18, 25)
    end

    frame.castBar:SetMinMaxValues(castBar:GetMinMaxValues())
    frame.castBar:SetValue(castBar:GetValue())
end

local function onCastBarHide(frame)
    frame.castBar:Hide()
    frame.castBarBorder:Hide()
    frame.castBarShieldBorder:Hide()
    frame.spellIcon:Hide()
end

local function onCastBarValueChanged(frame, value)
    local nameplate = frame:GetParent()
    local regions = getNameplateRegions(nameplate)

    frame.castBar:SetValue(value)
    frame.spellIcon:SetTexture(regions.spellIcon:GetTexture())
end

local frames = {}

local function attachFrame(nameplate)
    -- Hide nameplate
    local healthBar, castBar = nameplate:GetChildren()
    local regions = getNameplateRegions(nameplate)
    healthBar:Hide()
    castBar:SetStatusBarTexture(nil)
    regions.threatGlow:SetTexCoord(0, 0, 0, 0)
    regions.healthBarBorder:SetTexture(nil)
    regions.castBarBorder:SetTexture(nil)
    regions.castBarShieldBorder:SetTexture(nil)
    regions.spellIcon:SetWidth(0.1)
    regions.highlight:SetTexture(nil)
    regions.name:SetWidth(0.1)
    regions.level:SetWidth(0.1)
    regions.skullIcon:SetTexture(nil)
    regions.raidIcon:SetTexture(nil)
    regions.eliteIcon:SetTexture(nil)

    -- Attach a custom frame to this nameplate
    local frame = CreateFrame("Frame", "NameplateFrame" .. #frames, nameplate, "NameplateFrameTemplate")
    table.insert(frames, frame)

    frame:SetScale(UIParent:GetScale())
    frame.healthBar:SetFrameLevel(frame:GetFrameLevel() - 1)
    frame.castBar:SetFrameLevel(frame:GetFrameLevel() - 1)

    frame:SetScript("OnShow", onFrameShow)
    castBar:HookScript("OnShow", function() onCastBarShow(frame) end)
    castBar:HookScript("OnHide", function() onCastBarHide(frame) end)
    healthBar:HookScript("OnValueChanged", function(self, ...) onHealthBarValueChanged(frame, ...) end)
    castBar:HookScript("OnValueChanged", function(self, ...) onCastBarValueChanged(frame, ...) end)
    
    onFrameShow(frame)
end

local frameLevelSpacing = 3  -- allows children to occupy intermediate frame levels without risk of overlapping incorrectly

local function updateFrames()
    table.sort(frames, function(a, b)
        return a:GetEffectiveDepth() > b:GetEffectiveDepth()
    end)

    for i, frame in ipairs(frames) do
        frame:SetFrameLevel(i * frameLevelSpacing)

        local nameplate = frame:GetParent()
        local regions = getNameplateRegions(nameplate)

        frame.threatGlow:SetShown(regions.threatGlow:IsShown())
        frame.highlight:SetShown(regions.highlight:IsShown())
        frame.raidIcon:SetShown(regions.raidIcon:IsShown())
        
        frame.name:SetTextColor(regions.name:GetTextColor())
        frame.raidIcon:SetTexCoord(regions.raidIcon:GetTexCoord())
    end
end

local numChildren = 1

function addon:OnUpdate(elapsed)
    local currentNumChildren = WorldFrame:GetNumChildren()
    for i = numChildren + 1, currentNumChildren do -- skip first child, not a nameplate
        local nameplate = select(i, WorldFrame:GetChildren())
        if isNameplate(nameplate) then
            attachFrame(nameplate)
        end
    end
    numChildren = currentNumChildren

    updateFrames()
end

addon:RegisterEvent("ADDON_LOADED")
addon:SetScript("OnEvent", addon.OnEvent)
addon:SetScript("OnUpdate", addon.OnUpdate)
