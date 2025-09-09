local frame = CreateFrame("Frame")
local Frame = GetMetaTable(frame).__index
local Texture = GetMetaTable(frame:CreateTexture()).__index

local function SetShown(self, show)
    if show then
        self:Show()
    else
        self:Hide()
    end
end

Frame.SetShown = SetShown
Texture.SetShown = SetShown