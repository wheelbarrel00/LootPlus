local addonName, ns = ...
local addon = ns.addon
local U = ns.U

ns.UI = {}

function ns.UI:Initialize()
    local gui = CreateFrame("Frame", "LootPlusGUI", UIParent, "BasicFrameTemplateWithInset, BackdropTemplate")
    gui:SetSize(520, 680) 
    gui:SetPoint("CENTER") 
    gui:Hide() 
    gui:SetMovable(true) 
    gui:EnableMouse(true) 
    gui:RegisterForDrag("LeftButton")
    gui:SetScript("OnDragStart", gui.StartMoving) 
    gui:SetScript("OnDragStop", gui.StopMovingOrSizing)

    gui.title = gui:CreateFontString(nil, "OVERLAY", "GameFontHighlight") 
    gui.title:SetPoint("CENTER", gui.TitleBg, "CENTER", 0, 0) 
    gui.title:SetText("Loot+ ("..addon.VERSION..")")

    local pages = { 
        layout = CreateFrame("Frame", nil, gui), 
        colors = CreateFrame("Frame", nil, gui), 
        notifications = CreateFrame("Frame", nil, gui),
        customization = CreateFrame("Frame", nil, gui)
    }

    for _, p in pairs(pages) do 
        p:SetSize(500, 550) 
        p:SetPoint("TOP", 0, -110) 
        p:Hide() 
    end

    local function ShowPage(name) 
        for k, p in pairs(pages) do 
            if k == name then p:Show() else p:Hide() end 
        end 
    end

    local function CreateTab(name, label, x)
        local b = CreateFrame("Button", nil, gui, "GameMenuButtonTemplate")
        b:SetSize(100, 25) 
        b:SetPoint("TOPLEFT", x, -30) 
        b:SetText(label)
        local fontString = b:GetFontString()
        if fontString then fontString:SetFont("Fonts\\FRIZQT__.TTF", 10, "") end
        b:SetScript("OnClick", function() ShowPage(name) end)
        return b
    end

    CreateTab("layout", "Layout", 25)
    CreateTab("colors", "Colors", 145)
    CreateTab("notifications", "Notifs", 265)
    CreateTab("customization", "Custom", 385)

    -------------------------------------------------
    -- GLOBAL HEADER AREA
    -------------------------------------------------
    local lockBtn = CreateFrame("Button", nil, gui, "GameMenuButtonTemplate")
    lockBtn:SetPoint("TOPLEFT", 25, -65) 
    lockBtn:SetSize(140, 30)
    lockBtn:SetText(LootPlusConfig.locked and "Unlock Windows" or "Lock Windows")
    lockBtn:SetScript("OnClick", function() 
        LootPlusConfig.locked = not LootPlusConfig.locked 
        addon:UpdateAllVisuals() 
        lockBtn:SetText(LootPlusConfig.locked and "Unlock Windows" or "Lock Windows") 
    end)

    local testBtn = CreateFrame("Button", nil, gui, "GameMenuButtonTemplate")
    testBtn:SetPoint("TOPRIGHT", -25, -65) 
    testBtn:SetSize(140, 30) 
    testBtn:SetText("Start Test Mode")
    testBtn:SetScript("OnClick", function() 
        addon.isTesting = not addon.isTesting 
        if addon.isTesting then 
            testBtn:SetText("Stop Test Mode") 
            addon.combatFrame.display:SetFading(false) 
            addon.lootFrame.display:SetFading(false) 
            addon:PostTestMessages()
        else 
            testBtn:SetText("Start Test Mode") 
            addon:UpdateAllVisuals() 
            addon.combatFrame.display:Clear() 
            addon.lootFrame.display:Clear() 
        end 
    end)

    local outList = {{val="NONE",lbl="None"},{val="OUTLINE",lbl="Thin"},{val="THICKOUTLINE",lbl="Thick"},{val="MONOCHROME",lbl="Pixel"}}

    -------------------------------------------------
    -- TAB 1: LAYOUT
    -------------------------------------------------
    local cSize = U.CreateSlider("LP_CS", "Combat Text Size", pages.layout, 10, 50, 1, "size", "combat")
    cSize.label:SetPoint("TOPLEFT", 30, 0); cSize:SetPoint("TOPLEFT", cSize.label, "BOTTOMLEFT", 0, -10); cSize:SetValue(LootPlusConfig.combat.size)
    local cFade = U.CreateSlider("LP_CFA", "Combat Fade (sec)", pages.layout, 1, 30, 1, "fade", "combat")
    cFade.label:SetPoint("TOPLEFT", cSize, "BOTTOMLEFT", 0, -20); cFade:SetPoint("TOPLEFT", cFade.label, "BOTTOMLEFT", 0, -10); cFade:SetValue(LootPlusConfig.combat.fade)
    local cWidth = U.CreateSlider("LP_CW", "Combat Frame Width", pages.layout, 200, 1200, 10, "width", "combat")
    cWidth.label:SetPoint("TOPLEFT", cFade, "BOTTOMLEFT", 0, -20); cWidth:SetPoint("TOPLEFT", cWidth.label, "BOTTOMLEFT", 0, -10); cWidth:SetValue(LootPlusConfig.combat.width)
    local cHeight = U.CreateSlider("LP_CH", "Combat Frame Height", pages.layout, 50, 800, 10, "height", "combat")
    cHeight.label:SetPoint("TOPLEFT", cWidth, "BOTTOMLEFT", 0, -20); cHeight:SetPoint("TOPLEFT", cHeight.label, "BOTTOMLEFT", 0, -10); cHeight:SetValue(LootPlusConfig.combat.height)
    local cMaxLines = U.CreateSlider("LP_CML", "Max Combat Lines", pages.layout, 1, 20, 1, "maxLines", "combat")
    cMaxLines.label:SetPoint("TOPLEFT", cHeight, "BOTTOMLEFT", 0, -20); cMaxLines:SetPoint("TOPLEFT", cMaxLines.label, "BOTTOMLEFT", 0, -10); cMaxLines:SetValue(LootPlusConfig.combat.maxLines)

    local lSize = U.CreateSlider("LP_LS", "Loot Text Size", pages.layout, 10, 50, 1, "size", "loot")
    lSize.label:SetPoint("TOPRIGHT", -50, 0); lSize:SetPoint("TOPRIGHT", lSize.label, "BOTTOMRIGHT", 0, -10); lSize:SetValue(LootPlusConfig.loot.size)
    local lFade = U.CreateSlider("LP_LFA", "Loot Fade (sec)", pages.layout, 1, 30, 1, "fade", "loot")
    lFade.label:SetPoint("TOPRIGHT", lSize, "BOTTOMRIGHT", 0, -20); lFade:SetPoint("TOPRIGHT", lFade.label, "BOTTOMRIGHT", 0, -10); lFade:SetValue(LootPlusConfig.loot.fade)
    local lWidth = U.CreateSlider("LP_LW", "Loot Frame Width", pages.layout, 200, 1200, 10, "width", "loot")
    lWidth.label:SetPoint("TOPRIGHT", lFade, "BOTTOMRIGHT", 0, -20); lWidth:SetPoint("TOPRIGHT", lWidth.label, "BOTTOMRIGHT", 0, -10); lWidth:SetValue(LootPlusConfig.loot.width)
    local lHeight = U.CreateSlider("LP_LH", "Loot Frame Height", pages.layout, 50, 800, 10, "height", "loot")
    lHeight.label:SetPoint("TOPRIGHT", lWidth, "BOTTOMRIGHT", 0, -20); lHeight:SetPoint("TOPRIGHT", lHeight.label, "BOTTOMRIGHT", 0, -10); lHeight:SetValue(LootPlusConfig.loot.height)
    local lMaxLines = U.CreateSlider("LP_LML", "Max Loot Lines", pages.layout, 1, 20, 1, "maxLines", "loot")
    lMaxLines.label:SetPoint("TOPRIGHT", lHeight, "BOTTOMRIGHT", 0, -20); lMaxLines:SetPoint("TOPRIGHT", lMaxLines.label, "BOTTOMRIGHT", 0, -10); lMaxLines:SetValue(LootPlusConfig.loot.maxLines)

    local syncLayout = CreateFrame("Button", nil, pages.layout, "GameMenuButtonTemplate") 
    syncLayout:SetPoint("BOTTOM", 0, 40); syncLayout:SetSize(220, 25); syncLayout:SetText("Sync Combat Layout to Loot")
    syncLayout:SetScript("OnClick", function() 
        LootPlusConfig.loot.size = LootPlusConfig.combat.size
        LootPlusConfig.loot.fade = LootPlusConfig.combat.fade
        LootPlusConfig.loot.width = LootPlusConfig.combat.width
        LootPlusConfig.loot.height = LootPlusConfig.combat.height
        LootPlusConfig.loot.maxLines = LootPlusConfig.combat.maxLines
        lSize:SetValue(LootPlusConfig.combat.size); lFade:SetValue(LootPlusConfig.combat.fade); lWidth:SetValue(LootPlusConfig.combat.width); lHeight:SetValue(LootPlusConfig.combat.height); lMaxLines:SetValue(LootPlusConfig.combat.maxLines)
        addon:UpdateAllVisuals() 
    end)

    -------------------------------------------------
    -- TAB 2: COLORS
    -------------------------------------------------
    local colorRows = {}
    local function AddColor(key, title, func)
        local row = U.CreateColorRow("LP_CLR_"..title, pages.colors, key, func)
        if #colorRows == 0 then row:SetPoint("TOP", 0, 0) else row:SetPoint("TOP", colorRows[#colorRows], "BOTTOM", 0, -3) end
        table.insert(colorRows, row) 
        row:Refresh()
    end
    
    AddColor("money", "Money", function() return "10 Gold 75 Silver 20 Copper" end)
    AddColor("currency", "Currency", function() return "+ 25 Kej" end)
    AddColor("loot", "Loot", function() return "+1 |T132338:0|t Earthen Shard (24)" end)
    AddColor("combatEnter", "Combat Start", function() return LootPlusConfig.combatEnterText end)
    AddColor("combatLeave", "Combat End", function() return LootPlusConfig.combatLeaveText end)
    AddColor("xp", "Experience", function() return "+ 1,500 XP" end)
    AddColor("delver", "Delver XP", function() return "+ 125 Delver XP" end)
    AddColor("skill", "Skill", function() return "Blacksmithing (Midnight) (50)" end)
    AddColor("honor", "Honor", function() return "+ 15 Honor" end)
    AddColor("repGain", "Rep Gain", function() return "+ 250 Rep: The Midnight Council" end)
    AddColor("repLoss", "Rep Loss", function() return "- 25 Rep: Bloodsail Buccaneers" end)

    local resetBtn = CreateFrame("Button", nil, pages.colors, "GameMenuButtonTemplate")
    resetBtn:SetSize(160, 28); resetBtn:SetPoint("TOP", colorRows[#colorRows], "BOTTOM", 0, -25); resetBtn:SetText("Reset to Defaults")
    resetBtn:SetScript("OnClick", function() addon:ResetDefaults() end)
    local stubC = pages.colors:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall"); stubC:SetPoint("TOP", resetBtn, "BOTTOM", 0, -5); stubC:SetText("Clears all colors, layout, and toggles.")

    -------------------------------------------------
    -- TAB 3: NOTIFICATIONS
    -------------------------------------------------
    local toggles = {}
    local function AddToggle(key, title, colorKey, parentAnchor)
        local cb = CreateFrame("CheckButton", "LP_TGL_"..key, pages.notifications, "InterfaceOptionsCheckButtonTemplate")
        cb:SetPoint("TOPLEFT", parentAnchor, "BOTTOMLEFT", 0, -5)
        local fs = _G[cb:GetName().."Text"]; fs:SetText(title)
        if colorKey and LootPlusConfig.colors[colorKey] then local c = LootPlusConfig.colors[colorKey]; fs:SetTextColor(c.r, c.g, c.b) end
        cb:SetChecked(LootPlusConfig.notifications[key])
        cb:SetScript("OnClick", function(self) LootPlusConfig.notifications[key] = self:GetChecked(); if addon.isTesting then addon:PostTestMessages() end end)
        toggles[key] = cb return cb
    end

    local moneyT = CreateFrame("CheckButton", "LP_TGL_money", pages.notifications, "InterfaceOptionsCheckButtonTemplate")
    moneyT:SetPoint("TOPLEFT", 15, 0); _G[moneyT:GetName().."Text"]:SetText("Display Money")
    local cM = LootPlusConfig.colors["money"] or {r=1, g=1, b=1}; _G[moneyT:GetName().."Text"]:SetTextColor(cM.r, cM.g, cM.b)
    moneyT:SetChecked(LootPlusConfig.notifications["money"])
    moneyT:SetScript("OnClick", function(self) LootPlusConfig.notifications["money"] = self:GetChecked(); if addon.isTesting then addon:PostTestMessages() end end)
    toggles["money"] = moneyT

    local currT = AddToggle("currency", "Display Currency", "currency", moneyT)
    local lootT = AddToggle("loot", "Display Item Loot", "loot", currT)

    local countCheck = CreateFrame("CheckButton", "LP_CountToggle_N", pages.notifications, "InterfaceOptionsCheckButtonTemplate")
    countCheck:SetPoint("TOPLEFT", lootT, "BOTTOMLEFT", 0, -5); _G[countCheck:GetName().."Text"]:SetText("Inject Item Totals (e.g. 14)"); countCheck:SetChecked(LootPlusConfig.showLootCounts)
    countCheck:SetScript("OnClick", function(self) LootPlusConfig.showLootCounts = self:GetChecked(); if addon.isTesting then addon:PostTestMessages() end end)

    local gIconCheck = CreateFrame("CheckButton", "LP_GoldToggle_N", pages.notifications, "InterfaceOptionsCheckButtonTemplate")
    gIconCheck:SetPoint("TOPLEFT", countCheck, "BOTTOMLEFT", 0, -5); _G[gIconCheck:GetName().."Text"]:SetText("Use Coin Icons (Clean Mode only)"); gIconCheck:SetChecked(LootPlusConfig.showMoneyIcons)
    gIconCheck:SetScript("OnClick", function(self) LootPlusConfig.showMoneyIcons = self:GetChecked(); if addon.isTesting then addon:PostTestMessages() end end)

    local cleanCheck = CreateFrame("CheckButton", "LP_CleanToggle_N", pages.notifications, "InterfaceOptionsCheckButtonTemplate")
    cleanCheck:SetPoint("TOPLEFT", gIconCheck, "BOTTOMLEFT", 0, -5); _G[cleanCheck:GetName().."Text"]:SetText("Enable Clean Mode"); cleanCheck:SetChecked(LootPlusConfig.cleanMode)
    cleanCheck:SetScript("OnClick", function(self) LootPlusConfig.cleanMode = self:GetChecked(); if addon.isTesting then addon:PostTestMessages() end end)
    
    local cleanDesc = pages.notifications:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    cleanDesc:SetPoint("TOPLEFT", cleanCheck, "BOTTOMLEFT", 25, 0); cleanDesc:SetTextColor(0.6, 0.6, 0.6); cleanDesc:SetText("(Strips text like 'You receive loot:')")

    local cStrT = CreateFrame("CheckButton", "LP_TGL_combatEnter", pages.notifications, "InterfaceOptionsCheckButtonTemplate")
    cStrT:SetPoint("TOPLEFT", 260, 0); _G[cStrT:GetName().."Text"]:SetText("Display Combat START")
    local cCE = LootPlusConfig.colors["combatEnter"] or {r=1, g=1, b=1}; _G[cStrT:GetName().."Text"]:SetTextColor(cCE.r, cCE.g, cCE.b)
    cStrT:SetChecked(LootPlusConfig.notifications["combatEnter"])
    cStrT:SetScript("OnClick", function(self) LootPlusConfig.notifications["combatEnter"] = self:GetChecked(); if addon.isTesting then addon:PostTestMessages() end end)
    toggles["combatEnter"] = cStrT

    local cEndT = AddToggle("combatLeave", "Display Combat END", "combatLeave", cStrT)
    local xpT = AddToggle("xp", "Display Experience", "xp", cEndT)
    
    local fxpCheck = CreateFrame("CheckButton", "LP_FollowerToggle_N", pages.notifications, "InterfaceOptionsCheckButtonTemplate")
    fxpCheck:SetPoint("TOPLEFT", xpT, "BOTTOMLEFT", 0, -5); _G[fxpCheck:GetName().."Text"]:SetText("Show Combat Follower XP"); fxpCheck:SetChecked(LootPlusConfig.showFollowerXP)
    fxpCheck:SetScript("OnClick", function(self) LootPlusConfig.showFollowerXP = self:GetChecked(); if addon.isTesting then addon:PostTestMessages() end end)

    local delvT = AddToggle("delver", "Display Delve Companion XP", "delver", fxpCheck) 
    local skillT = AddToggle("skill", "Display Skill Gains", "skill", delvT)
    local honorT = AddToggle("honor", "Display Honor Gains", "honor", skillT)
    local repGT = AddToggle("repGain", "Display Reputation GAIN", "repGain", honorT)
    local repLT = AddToggle("repLoss", "Display Reputation LOSS", "repLoss", repGT)

    -------------------------------------------------
    -- TAB 4: CUSTOMIZATION
    -------------------------------------------------
    local cFont = U.CreateFontCycler("LP_CF", "Combat Font", pages.customization, "combat")
    cFont.label:SetPoint("TOPLEFT", 30, 0); cFont:SetPoint("TOPLEFT", cFont.label, "BOTTOMLEFT", 0, -5)

    local cOut = U.CreateGenericCycler("LP_CO", "Combat Outline", pages.customization, outList, "outline", "combat")
    cOut.label:SetPoint("TOPLEFT", cFont, "BOTTOMLEFT", 0, -15); cOut:SetPoint("TOPLEFT", cOut.label, "BOTTOMLEFT", 0, -5)

    local cEntEB = U.CreateEditBox("LP_CE", "Combat Start Text (Enter to Save)", pages.customization, "combatEnterText")
    cEntEB.label:SetPoint("TOPLEFT", cOut, "BOTTOMLEFT", 0, -20); cEntEB:SetPoint("TOPLEFT", cEntEB.label, "BOTTOMLEFT", 5, -5)

    local cLveEB = U.CreateEditBox("LP_CL", "Combat End Text (Enter to Save)", pages.customization, "combatLeaveText")
    cLveEB.label:SetPoint("TOPLEFT", cEntEB, "BOTTOMLEFT", -5, -15); cLveEB:SetPoint("TOPLEFT", cLveEB.label, "BOTTOMLEFT", 5, -5)

    -- Native Minimap Button Toggle added to Customization Tab
    local mmCheck = CreateFrame("CheckButton", "LP_MinimapToggle", pages.customization, "InterfaceOptionsCheckButtonTemplate")
    mmCheck:SetPoint("TOPLEFT", cLveEB, "BOTTOMLEFT", -5, -20)
    _G[mmCheck:GetName().."Text"]:SetText("Show Minimap Icon")
    mmCheck:SetChecked(not LootPlusConfig.minimap.hide)
    mmCheck:SetScript("OnClick", function(self) 
        LootPlusConfig.minimap.hide = not self:GetChecked()
        addon:UpdateAllVisuals() 
    end)

    local lFont = U.CreateFontCycler("LP_LF", "Loot Font", pages.customization, "loot") 
    lFont.label:SetPoint("TOPRIGHT", -50, 0); lFont:SetPoint("TOPRIGHT", lFont.label, "BOTTOMRIGHT", 0, -5); pages.customization.lF = lFont

    local lOut = U.CreateGenericCycler("LP_LO", "Loot Outline", pages.customization, outList, "outline", "loot") 
    lOut.label:SetPoint("TOPRIGHT", lFont, "BOTTOMRIGHT", -40, -15); lOut:SetPoint("TOPRIGHT", lOut.label, "BOTTOMRIGHT", 0, -5); pages.customization.lO = lOut

    local syncCustom = CreateFrame("Button", nil, pages.customization, "GameMenuButtonTemplate") 
    syncCustom:SetPoint("BOTTOM", 0, 80); syncCustom:SetSize(220, 25); syncCustom:SetText("Sync Combat Fonts to Loot")
    syncCustom:SetScript("OnClick", function() 
        LootPlusConfig.loot.font = LootPlusConfig.combat.font; LootPlusConfig.loot.outline = LootPlusConfig.combat.outline
        pages.customization.lF:Refresh(); pages.customization.lO:Refresh(); addon:UpdateAllVisuals() 
    end)

    -------------------------------------------------
    -- REFRESH ENGINE FOR RESET BUTTON
    -------------------------------------------------
    function ns.UI:RefreshAllWidgets()
        cSize:SetValue(LootPlusConfig.combat.size); cFade:SetValue(LootPlusConfig.combat.fade); cWidth:SetValue(LootPlusConfig.combat.width); cHeight:SetValue(LootPlusConfig.combat.height); cMaxLines:SetValue(LootPlusConfig.combat.maxLines)
        lSize:SetValue(LootPlusConfig.loot.size); lFade:SetValue(LootPlusConfig.loot.fade); lWidth:SetValue(LootPlusConfig.loot.width); lHeight:SetValue(LootPlusConfig.loot.height); lMaxLines:SetValue(LootPlusConfig.loot.maxLines)
        cFont:Refresh(); cOut:Refresh(); lFont:Refresh(); lOut:Refresh()
        cEntEB:SetText(LootPlusConfig.combatEnterText); cLveEB:SetText(LootPlusConfig.combatLeaveText)
        cleanCheck:SetChecked(LootPlusConfig.cleanMode); countCheck:SetChecked(LootPlusConfig.showLootCounts); gIconCheck:SetChecked(LootPlusConfig.showMoneyIcons); fxpCheck:SetChecked(LootPlusConfig.showFollowerXP)
        mmCheck:SetChecked(not LootPlusConfig.minimap.hide)
        for _, row in ipairs(colorRows) do row:Refresh() end
        for key, cb in pairs(toggles) do cb:SetChecked(LootPlusConfig.notifications[key]) end
        for key, cb in pairs(toggles) do if LootPlusConfig.colors[key] then local c = LootPlusConfig.colors[key]; _G[cb:GetName().."Text"]:SetTextColor(c.r, c.g, c.b) end end
    end

    ns.UI:RefreshAllWidgets()
    ShowPage("layout")
    SLASH_LOOTPLUS1 = "/lp"
    SlashCmdList["LOOTPLUS"] = function() if addon:IsReady() then if gui:IsShown() then gui:Hide() else gui:Show() end end end
end