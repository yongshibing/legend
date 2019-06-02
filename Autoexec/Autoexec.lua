--收集的一些实用代码
--11 屏蔽系统施法条
do 
  for i = 1, 3 do 
    _G['MirrorTimer' .. i]:UnregisterAllEvents() 
    _G['MirrorTimer' .. i]:ClearAllPoints()
    _G['MirrorTimer' .. i]:Hide() 
  end
  CastingBarFrame_SetUnit(CastingBarFrame, nil)
end

--10 CVar设置
local function defaultcvar()
  SetCVar("overrideArchive", 0) --反和谐
  SetCVar("ffxGlow", 0)		--全屏泛光
  SetCVar("profanityFilter", 0) --语言过滤
  SetCVar("screenshotQuality", 10)	--截图质量
  SetCVar("screenshotFormat", "jpg") 	--截图格式
  SetCVar("mapFade", 0) 	--地图移动透明
  SetCVar("floatingCombatTextCombatHealing", 1)	--显示治疗
  SetCVar("floatingCombatTextCombatDamage", 1)	--显示伤害
  SetCVar("floatingCombatTextCombatState", 0)	--进入战斗
  SetCVar("scriptErrors", 0)	--LUA错误
  SetCVar("SpellQueueWindow", 400) --施法序列
  SetCVar("cameraDistanceMaxZoomFactor", 1.9)	--最大视距
end 
local frame = CreateFrame("FRAME", "defaultcvar") 
  frame:RegisterEvent("PLAYER_ENTERING_WORLD") 
     local function eventHandler(self, event, ...) 
         defaultcvar() 
end
frame:SetScript("OnEvent", eventHandler)

--9 网格界面 
SLASH_EA1 = "/grid" 
local f
SlashCmdList["EA"] = function()
	if f then
		f:Hide()
		f = nil		
	else
		f = CreateFrame('Frame', nil, UIParent) 
		f:SetAllPoints(UIParent)
		local w = GetScreenWidth() / 64
		local h = GetScreenHeight() / 36
		for i = 0, 64 do
			local t = f:CreateTexture(nil, 'BACKGROUND')
			if i == 32 then
				t:SetColorTexture(1, 0, 0, 0.5)
			else
				t:SetColorTexture(0, 0, 0, 0.5)
			end
			t:SetPoint('TOPLEFT', f, 'TOPLEFT', i * w - 1, 0)
			t:SetPoint('BOTTOMRIGHT', f, 'BOTTOMLEFT', i * w + 1, 0)
		end
		for i = 0, 36 do
			local t = f:CreateTexture(nil, 'BACKGROUND')
			if i == 18 then
				t:SetColorTexture(1, 0, 0, 0.5)
			else
				t:SetColorTexture(0, 0, 0, 0.5)
			end
			t:SetPoint('TOPLEFT', f, 'TOPLEFT', 0, -i * h + 1)
			t:SetPoint('BOTTOMRIGHT', f, 'TOPRIGHT', 0, -i * h - 1)
		end	
	end
end

--8 重载命令 
SlashCmdList["RELOADUI"] = function() ReloadUI() end 
SLASH_RELOADUI1 = "/rl"

--7 自动卖灰
local f = CreateFrame("Frame") 
f:SetScript("OnEvent", function(...) 
   local c = 0 
   for b=0,4 do 
      for s=1,GetContainerNumSlots(b) do 
         local l = GetContainerItemLink(b, s) 
         if l and select(3, GetItemInfo(l))==0 then 
            local p = select(11, GetItemInfo(l))*select(2, GetContainerItemInfo(b, s)) 
            if p>0 then 
               UseContainerItem(b, s) 
               PickupMerchantItem() 
               c = c+p 
            end 
         end 
      end 
   end 
   if c>0 then 
      local g, s, c = math.floor(c/10000) or 0, math.floor((c%10000)/100) or 0, c%100 
      DEFAULT_CHAT_FRAME:AddMessage("|cff44CCFF售卖垃圾: |r".." |cffffcc00"..g.."金".." |cffffcc00"..s.."银".." |cffffcc00"..c.."铜")
   end 
end) 
f:RegisterEvent("MERCHANT_SHOW")

--6 自动修理 
local AutoRepair = true 
local g = CreateFrame("Frame") 
g:RegisterEvent("MERCHANT_SHOW") 
g:SetScript("OnEvent", function() 
if(AutoRepair==true and CanMerchantRepair()) then 
local cost = GetRepairAllCost() 
if cost > 0 then 
local money = GetMoney() 
if IsInGuild() then 
local guildMoney = GetGuildBankWithdrawMoney() 
if guildMoney > GetGuildBankMoney() then 
guildMoney = GetGuildBankMoney() 
end 
if guildMoney > cost and CanGuildBankRepair() then 
RepairAllItems(1) 
print(format("|cff44CCFF公会修理花费:|r  |cffffcc00%.1f金|r", cost * 0.0001)) 
return 
end 
end 
if money > cost then 
RepairAllItems() 
print(format("|cff44CCFF修理花费:|r  |cffffcc00%.1f金|r", cost * 0.0001))
else 
print("Go farm newbie.") 
end 
end 
end 
end)

--5 移动特殊能量条
PlayerPowerBarAlt:ClearAllPoints()
PlayerPowerBarAlt:SetPoint("TOP", UIParent, "CENTER", 0,100)
PlayerPowerBarAlt:SetScale(0.85)
PlayerPowerBarAlt:SetMovable(true)
PlayerPowerBarAlt:SetUserPlaced(true)
PlayerPowerBarAlt:SetFrameStrata("HIGH")
PlayerPowerBarAlt:SetScript("OnMouseDown", function()
if (IsAltKeyDown()) then
PlayerPowerBarAlt:ClearAllPoints()
PlayerPowerBarAlt:StartMoving()
end
end)
PlayerPowerBarAlt:SetScript('OnMouseUp', function(self, button)
PlayerPowerBarAlt:StopMovingOrSizing()
end)

--4 鼠标提示添加法术ID
hooksecurefunc(GameTooltip, 'SetUnitBuff', function(self,...) 
    local id = select(10, UnitBuff(...)) 
    if (id) then 
        self:AddLine('ID: '..id, 1, 1, 1) 
        self:Show() 
    end 
end) 

hooksecurefunc(GameTooltip, 'SetUnitDebuff', function(self,...) 
    local id = select(10, UnitDebuff(...)) 
    if (id) then 
        self:AddLine('ID: '..id, 1, 1, 1) 
        self:Show() 
    end 
end) 

hooksecurefunc(GameTooltip, 'SetUnitAura', function(self,...) 
    local id = select(10, UnitAura(...)) 
    if (id) then 
        self:AddLine('ID: '..id, 1, 1, 1) 
        self:Show() 
    end 
end) 

hooksecurefunc('SetItemRef', function(link, text, button, chatFrame) 
    if (string.find(link,'^spell:')) then 
        local id = string.sub(link, 7) 
        ItemRefTooltip:AddLine('ID: '..id, 1, 1, 1) 
        ItemRefTooltip:Show() 
    end 
end) 

GameTooltip:HookScript('OnTooltipSetSpell', function(self) 
    local id = select(2, self:GetSpell()) 
    if (id) then 
        for i = 1, self:NumLines() do 
            if _G['GameTooltipTextLeft'..i]:GetText() == 'ID: '..id then 
                return 
            end 
        end 

        self:AddLine('ID: '..id, 1, 1, 1) 
        self:Show() 
    end 
end)

--3 显示移动速度代码
do  
local tempstatFrame
hooksecurefunc("PaperDollFrame_SetMovementSpeed",function(statFrame, unit)
   if(tempstatFrame and tempstatFrame~=statFrame)then
      tempstatFrame:SetScript("OnUpdate",nil);
   end
   statFrame:SetScript("OnUpdate", MovementSpeed_OnUpdate);
   tempstatFrame = statFrame;
   statFrame:Show();
end)
PAPERDOLL_STATINFO["MOVESPEED"].updateFunc =  function(statFrame, unit) PaperDollFrame_SetMovementSpeed(statFrame, unit); end
table.insert(PAPERDOLL_STATCATEGORIES[1].stats,{ stat = "MOVESPEED" })
end

--2 去掉头像上跳动的伤害和治疗数字
PlayerHitIndicator:SetText(nil)
PlayerHitIndicator.SetText = function() end


--1 成就自动截屏
local function TakeScreen(delay, func, ...)
local waitTable = {}
local waitFrame = CreateFrame("Frame", "WaitFrame", UIParent)
   waitFrame:SetScript("onUpdate", function (self, elapse)
      local count = #waitTable
      local i = 1
      while (i <= count) do
         local waitRecord = tremove(waitTable, i)
         local d = tremove(waitRecord, 1)
         local f = tremove(waitRecord, 1)
         local p = tremove(waitRecord, 1)
         if (d > elapse) then
            tinsert(waitTable, i, {d-elapse, f, p})
            i = i + 1
         else
            count = count - 1
            f(unpack(p))
         end
      end
   end)
   tinsert(waitTable, {delay, func, {...} })
end
local function OnEvent(...)
   TakeScreen(1, Screenshot)
end
local AchScreen = CreateFrame("Frame")
AchScreen:RegisterEvent("ACHIEVEMENT_EARNED")
AchScreen:SetScript("OnEvent", OnEvent)
