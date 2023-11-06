local addonName = "EXTENDEDUI";

if extui == nil then
	extui = {};
end

extui.firstStart = false;
extui.sideFrame = nil;
extui.isSetting = false;
extui.isReload = false;
extui.closingSettings = false;


function EXTENDEDUI_ON_JOB_EXP(frame, msg, str, exp, tableinfo)
	if not(extui.GetSetting("showexp")) then return; end

	frame = ui.GetFrame("charbaseinfo");
	local curExp = exp - tableinfo.startExp;
	local maxExp = tableinfo.endExp - tableinfo.startExp;

	if tableinfo.isLastLevel == true then
		curExp = tableinfo.before:GetLevelExp();
		maxExp = curExp;
	end

	local percent = curExp / maxExp * 100;
	if percent > 100 then
		percent = 100.0;
	end

	local expObject = GET_CHILD(frame, "skillexp", "ui::CGauge");
	expObject:SetTextTooltip(string.format("{@st42b}%.1f%% / %.1f%%{/} (%i / %i)", percent, 100.0, curExp , maxExp));

end

function EXTENDEDUI_ON_CHAR_EXP(frame, msg, argStr, argNum)
	if not(extui.GetSetting("showexp")) then return; end

	frame = ui.GetFrame("charbaseinfo");
	if msg == "EXP_UPDATE"  or  msg == "STAT_UPDATE" or msg == "LEVEL_UPDATE" or msg == "CHANGE_COUNTRY" then
		local expGauge 			= GET_CHILD(frame, "exp", "ui::CGauge");
		local percent = session.GetEXP() / session.GetMaxEXP() * 100;
		if percent > 100 then
			percent = 100.0;
		end

		expGauge:SetTextTooltip(string.format("{@st42b}%.1f%% / %.1f%%{/} (%i / %i)", percent, 100.0, session.GetEXP(), session.GetMaxEXP() ));

	end

end

function EXTENDEDUI_ON_INIT(addon, frame)
    if _G["ADDONS"] == nil then
        _G["ADDONS"] = {};
    end

    if _G["ADDONS"][addonName] == nil then
        _G["ADDONS"][addonName] = {};
    end

    _G["ADDONS"][addonName]["addon"] = addon;
    _G["ADDONS"][addonName]["frame"] = frame;
	
	addon:RegisterMsg("GAME_START_3SEC", "EXTENDEDUI_LOAD_POSITIONS");

	addon:RegisterOpenOnlyMsg("LEVEL_UPDATE", "EXTENDEDUI_ON_CHAR_EXP");
	addon:RegisterMsg("EXP_UPDATE", "EXTENDEDUI_ON_CHAR_EXP");
	addon:RegisterMsg("JOB_EXP_UPDATE", "EXTENDEDUI_ON_JOB_EXP");
	addon:RegisterMsg("JOB_EXP_ADD", "EXTENDEDUI_ON_JOB_EXP");
	addon:RegisterMsg("CHANGE_COUNTRY", "EXTENDEDUI_ON_CHAR_EXP");
	addon:RegisterMsg("ESCAPE_PRESSED", "EXTENDEDUI_ON_CLOSE_UI");
	addon:RegisterMsg("EXTENDEDUI_ON_FRAME_LOAD", "EXTENDEDUI_ON_FRAME_LOADS");
		

	extui.UpdateCheck();

	extui.isSetting = false;

	extui.LoadSettings();
	
	extui.doFirstPositionLoad = false;

	if _G["CTRLSET_CREATE_EXTOLD"] == nil then
		_G["CTRLSET_CREATE_EXTOLD"] = _G["CTRLSET_CREATE"];
		_G["CTRLSET_CREATE"] = function(frame, handle, buff, buffCls, buffIndex, buffID)
			if frame ~= nil then
				frame:ShowWindow(1);
			end

			local gbox = GET_CHILD_RECURSIVELY(frame, "buffGBox");
			if gbox == nil then
				return;
			end

			if handle == nil then
				return; 
			end

			local colCnt = tonumber(frame:GetUserConfig("COL_COUNT"));
			local row = tonumber(frame:GetUserConfig("BUFF_ROW"));
			local col = tonumber(frame:GetUserConfig("BUFF_COL"));

			if col % colCnt == 0 and col >= colCnt then
				col = 0;
				row = row + 1;
				frame:SetUserConfig(row_configname, row);
			end     

			local ctrlSet = gbox:CreateOrGetControlSet("bufficon_slot", "BUFFSLOT_buff"..buffID, 0, 0);
			if ctrlSet == nil then
				return;
			end
			
			col = col + 1;
			frame:SetUserConfig(col_configname, col);

			local slotsize = extui.GetSetting("iconsize");
			ctrlSet:Resize(slotsize,slotsize);
			

			local slot = GET_CHILD_RECURSIVELY(ctrlSet, "slot");
			local caption = GET_CHILD_RECURSIVELY(ctrlSet, "caption");
			if slot ~= nil and caption ~= nil then
				local icon = CreateIcon(slot);
				local iconImageName = GET_BUFF_ICON_NAME(buffCls);
				if iconImageName == "icon_ability_Warrior_Hoplite39" then
					iconImageName = "ability_Warrior_Hoplite39";    
				end
				
				slot:Resize(slotsize,slotsize);

				icon:SetDrawCoolTimeText(0);
				icon:Set(iconImageName, "BUFF", buffID, 0);
				if buffIndex ~= nil then
					icon:SetUserValue("BuffIndex", buffIndex);
				end             

				local bufflockoffset = tonumber(frame:GetUserConfig("DEFAULT_BUFF_LOCK_OFFSET"));
				local buffGroup1 = TryGetProp(buffCls, "Group1", "Buff");
				local IsRemove = TryGetProp(buffCls, "RemoveBySkill", "NO");
				if buffGroup1 == "Debuff" and IsRemove == "YES" then
					local bufflv = TryGetProp(buffCls, "Lv", "99");
					if bufflv <= 3 then
						slot:SetBgImage("buff_lock_icon_3");
					elseif bufflv == 4 then
						slot:SetBgImage("buff_lock_icon_4");
					end
					slot:SetBgImageSize(slot:GetWidth() + bufflockoffset, slot:GetHeight() + bufflockoffset);
				end

				if buff.over > 1 then
					slot:SetText('{s13}{ol}{b}'..buff.over, 'count', ui.RIGHT, ui.BOTTOM, -5, -3);
				else
					slot:SetText("");
				end

				if slot:GetTopParentFrame():GetName() ~= "targetbuff" then
					slot:SetEventScript(ui.RBUTTONUP, 'REMOVE_BUF');
					slot:SetEventScriptArgNumber(ui.RBUTTONUP, buffID);
				end 

				slot:EnableDrop(0);
				slot:EnableDrag(0);

				caption:ShowWindow(1);
				caption:SetText(GET_BUFF_TIME_TXT(buff.time, 0));

				local targetinfo = info.GetTargetInfo(handle);
				if targetinfo ~= nil then
					if targetinfo.TargetWindow == 0 then
						slot:ShowWindow(0); 
					else
						slot:ShowWindow(1);
					end
				else
					slot:ShowWindow(1);
				end

				if buffCls.ClassName == "Premium_Nexon" or buffCls.ClassName == "Premium_Token" then
					icon:SetTooltipType("premium");
					icon:SetTooltipArg(handle, buffID, buff.arg1);
				else
					icon:SetTooltipType("buff");
					if buffIndex ~= nil then
						icon:SetTooltipArg(handle, buffID, buffIndex);
					end
				end

				slot:Invalidate();
			end

			local offsetX = tonumber(frame:GetUserConfig("DEFAULT_SLOT_X_OFFSET"));
			local offsetY = tonumber(frame:GetUserConfig("DEFAULT_SLOT_Y_OFFSET"));
			local gboxAdd = tonumber(frame:GetUserConfig("GBOX_ADD"));
			local defaultwidth = tonumber(frame:GetUserConfig("DEFAULT_GBOX_WIDTH"));
			BUFF_SEPARATEDLIST_CTRLSET_GBOX_AUTO_ALIGN(gbox, 10, offsetX, gboxAdd, defaultwidth, true, offsetY, true);
			
			local nCol = colCnt;
			if row < 2 then
				nCol = 1;
			end
			gbox:Resize((nCol*extui.GetSetting("iconsize")) + 15, (row+1) * extui.GetSetting("iconsize"));
			frame:Resize((nCol*extui.GetSetting("iconsize")) + 15, (row+1) * extui.GetSetting("iconsize"));
			gbox:Invalidate();
		end;
	end

	if _G["_PUMP_RECIPE_OPEN_EXTOLD"] == nil then
		_G["_PUMP_RECIPE_OPEN_EXTOLD"] = _G["_PUMP_RECIPE_OPEN"];
		_G["_PUMP_RECIPE_OPEN"] = function(...) 
									if extui.GetSetting("discraft") == false then
										_G["_PUMP_RECIPE_OPEN_EXTOLD"](...);
									end
								end;
	end

	if _G["QUESTINFOSET_2_AUTO_ALIGN_EXTOLD"] == nil then
		_G["QUESTINFOSET_2_AUTO_ALIGN_EXTOLD"] = _G["QUESTINFOSET_2_AUTO_ALIGN"];
		_G["QUESTINFOSET_2_AUTO_ALIGN"] = function(frame, GroupCtrl)
											if extui.GetSetting("lockquest") == false then
												_G["QUESTINFOSET_2_AUTO_ALIGN_EXTOLD"](frame, GroupCtrl);
											else
												_G["QUESTINFOSET_2_AUTO_ALIGN_EXTOLD"](frame, GroupCtrl);
												local frm = ui.GetFrame("questinfoset_2");
												frm:MoveFrame(extui.framepos["questinfoset_2"].x, extui.framepos["questinfoset_2"].y);
											end
										end;
	end
	if _G["GET_BUFF_TIME_TXT_EXTOLD"] == nil then
		_G["GET_BUFF_TIME_TXT_EXTOLD"] = _G["GET_BUFF_TIME_TXT"];
		_G["GET_BUFF_TIME_TXT"] = function(time, istooltip)
									if extui.GetSetting("buffsec") == false then
										return _G["GET_BUFF_TIME_TXT_EXTOLD"](time, istooltip);
									else
										if time == 0.0 then
											return "";
										end

										local sec = math.floor(time / 1000);

										local txt = "{#FFFF00}{ol}{s12}";

										if sec < 0 then
											sec = 0;
										end

										return txt .. sec .. ScpArgMsg("Auto_Cho");
									end
								end;
	end

	--Minimap.. sorry
	--uieffect always visible, so we put an update script into there to check for minimap
	local uieffect_frame = ui.GetFrame("uieffect");
	uieffect_frame:RunUpdateScript("EXTUI_MINIMAP_VISIBILITY_CHECK");

	local acutil = require("acutil");
	acutil.addSysIcon("extui", "addonmenu_extui", "ExtendedUI", "EXTENDEDUI_ON_OPEN_UI");

	--only runs on first startup because *_ON_INIT gets called on map change
	if _G["EXTUI_LOADED"] == nil then
		if not(extui.GetSetting("remload")) then
			extui.print("ExtendedUI Loaded");
		end


		extui.OldToggleFrame = ui.ToggleFrame;
		ui.ToggleFrame = function(frm) 
							if extui.GetFrame(frm) == nil then
								extui.OldToggleFrame(frm);
							end
						end;
		extui.OldGetFrame = ui.GetFrame;
		ui.GetFrame = function(frm)
							if extui.GetFrame(frm) ~= nil then
								local nframe = extui.OldGetFrame(frm);

								if nframe.OldShowWindow ~= nil then return nframe; end

								nframe.OldShowWindow = nframe.ShowWindow;

								function nframe:ShowWindow(b,ex)
									local eframe = extui.GetFrame(self:GetName());
									if eframe ~= nil then
										if eframe.saveHidden ~= nil then
											if ex then
												self:OldShowWindow(b);
											end
										else
											self:OldShowWindow(b);
										end
									else
										self:OldShowWindow(b);
									end
								end

								return nframe;
							else
								return extui.OldGetFrame(frm);
							end
						end;
		
		_G["EXTUI_LOADED"] = true;
	end

end
