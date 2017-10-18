local addonName = "EXTENDEDUI";

if extui == nil then
	extui = {};
end

extui.firstStart = false;
extui.sideFrame = nil;
extui.isSetting = false;
extui.isReload = false;
extui.closingSettings = false;
extui.IsDragging = false;




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

	local expObject = GET_CHILD(frame, 'skillexp', "ui::CGauge");
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