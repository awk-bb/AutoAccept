local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")

local function GetIndex(table, item)
  for i = 1, #table do
    if table[i] == item then
      return i
    end
  end
end

local function Capitalize(str)
  return (str:gsub("^%l", string.upper))
end

local function GetInviters()
  print("|cffFFB900AutoAccept invites from:")
  for i = 1, #AutoAccept_Inviters do
    print("|cffFFE800 " .. AutoAccept_Inviters[i])
  end
end

local function GetHelp()
  print("|cffFF9700Usage: /aa [list] [on] [off] [add playerName] [remove playerName]")
end

local function GetStatus()
  if AutoAccept_Startup == 1 then
    print("|cffFF9700AutoAccept is ON.")
  elseif AutoAccept_Startup == 0 then
    print("|cffFF9700AutoAccept is OFF.")
  end
end

local function SetStatus(cmd)
  if cmd == "init" then
    frame:RegisterEvent("PARTY_INVITE_REQUEST")
    AutoAccept_Startup = 1
  elseif cmd == "on" and AutoAccept_Startup ~= 1 then
    frame:RegisterEvent("PARTY_INVITE_REQUEST")
    AutoAccept_Startup = 1
  elseif cmd == "off" and AutoAccept_Startup ~= 0 then
    frame:UnregisterEvent("PARTY_INVITE_REQUEST")
    AutoAccept_Startup = 0
  end
  GetStatus()
end

local function SetInviters(cmd, playerName)
  if cmd == "add" then
    table.insert(AutoAccept_Inviters, playerName)
    print("|cffFFB900AutoAccept: " .. playerName .. " Added.")
  elseif cmd == "remove" then
    table.remove(AutoAccept_Inviters, GetIndex(AutoAccept_Inviters, playerName))
    print("|cffFFB900AutoAccept: " .. playerName .. " Removed.")
  end
end

local function EventHandler(self, event, sender)
  if event == "ADDON_LOADED" and sender == "AutoAccept" then
    if AutoAccept_Inviters == nil then
      AutoAccept_Inviters = {}
    end
    print("|cffFF9700AutoAccept loaded.")
    if AutoAccept_Startup == nil or AutoAccept_Startup == 1 then
      SetStatus("init")
    end
    print(GetInviters())
    GetStatus()
  elseif event == "PARTY_INVITE_REQUEST" and tContains(AutoAccept_Inviters, sender) then
    AcceptGroup()
    self:RegisterEvent("GROUP_ROSTER_UPDATE")
    self:SetScript("OnEvent", function(self, event, sender)
        StaticPopup_Hide("PARTY_INVITE")
        self:UnregisterEvent("GROUP_ROSTER_UPDATE")
      end)
  end
end

SLASH_AA1 = "/aa"
SlashCmdList["AA"] = function(msg)
  local _, _, cmd, args = string.find(msg, "%s?(%w+)%s?(.*)")
  if cmd == "list" then
    GetInviters()
    GetStatus()
  elseif cmd == "on" or cmd == "off" then
    SetStatus(cmd)
  elseif cmd == "add" or cmd == "remove" and args ~= "" then
    for arg in args:gmatch("%S+") do
      local playerName = Capitalize(arg)
      if not tContains(AutoAccept_Inviters, playerName) then
        SetInviters(cmd, playerName)
      end
    end
  else
    GetHelp()
  end
end

frame:SetScript("OnEvent", EventHandler)