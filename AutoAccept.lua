local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PARTY_INVITE_REQUEST")

local function GetInviters()
  print("|cffFFB900AutoAccept invites from:")
  for i = 1, #AutoAccept_Inviters do
    print("|cffFFE800 " .. AutoAccept_Inviters[i])
  end
end

local function GetHelp()
  print("|cffFF9700Usage: /aa [list] [add playerName] [remove playerName]")
end

local function SetInviters(cmd, playerName)
  if cmd == "add" then
    table.insert(AutoAccept_Inviters, playerName)
    print("|cffFFB900AutoAccept: " .. playerName .. " Added.")
  elseif cmd == "remove" then
    table.remove(AutoAccept_Inviters, playerName)
    print("|cffFFB900AutoAccept: " .. playerName .. " Removed.")
  end
end

SLASH_AA1 = "/aa"
SlashCmdList["AA"] = function(msg)
  local _, _, cmd, args = string.find(msg, "%s?(%w+)%s?(.*)")
  if cmd == "list" then
    GetInviters()
  elseif cmd == "add" or cmd == "remove" and args ~= "" then
    SetInviters(cmd, args)
  else
    GetHelp()
  end
end

frame:SetScript("OnEvent", function(self, event, sender)
  if event == "ADDON_LOADED" and sender == "AutoAccept" then
    if AutoAccept_Inviters == nil then
      AutoAccept_Inviters = {}
    end
    print("|cffFF9700AutoAccept loaded.")
    print(GetInviters())
  else
    if tContains(AutoAccept_Inviters, sender) then
      AcceptGroup()
      self:RegisterEvent("GROUP_ROSTER_UPDATE")
      self:SetScript("OnEvent", function(self, event, sender)
        StaticPopup_Hide("PARTY_INVITE")
        self:UnregisterEvent("GROUP_ROSTER_UPDATE")
      end)
    end
   end
end)