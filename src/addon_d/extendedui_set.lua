--ExtendedUI Settings

if extui == nil then
	extui = {};
end

extui.ldSettingsUI = {};
extui.lSettingsUI = {};
extui.defaultSettings = {};

function extui.GetSetting(name)
	if extui.lSettingsUI[name] == nil then
		extui.print("[EUI] GettingSetting: ''"..name.."'' not found.");
	end
	return extui.lSettingsUI[name].val;
end

function extui.GetSavedSetting(name)
	if extui.ldSettingsUI[name] == nil then
		extui.ldSettingsUI[name] = extui.defaultSettings[name];
	end
	
	return extui.ldSettingsUI[name];
end

function extui.SetSetting(name, val)
	extui.lSettingsUI[name].val = val;
end

function extui.GetSettings()
	return extui.lSettingsUI;
end

function extui.AddSetting(name, tbl)
	if extui.lSettingsUI[name] ~= nil then
		if tbl.name ~= nil then
			extui.lSettingsUI[name].name = tbl.name;
		end
		if tbl.tool ~= nil then
			extui.lSettingsUI[name].tool = tbl.tool;
		end
	else
		extui.lSettingsUI[name] = tbl;
		extui.lSettingsUI[name].order = extui.tablelength(extui.lSettingsUI);
	end
end

function extui.AddNewLine(n)
	if n == nil then
		n = tostring(math.random(999999)).."_"..tostring(math.random(999999));
	end
	extui.AddSetting("newline_"..tostring(n), {
			["typedata"] = {
				["a"] = "newline",
			}
		}
	);
end

function extui.AddLabelLine(n)
	if n == nil then
		n = tostring(math.random(999999)).."_"..tostring(math.random(999999));
	end
	extui.AddSetting("line_"..tostring(n), {
			["typedata"] = {
				["a"] = "labelline",
			}
		}
	);
end

function extui.AddDefaults(tbl, adef)
	if extui.ldSettingsUI == nil then
		extui.ldSettingsUI = {};
	end

	if #extui.ldSettingsUI > 0 then
		return;
	end

	for k,v in pairs(tbl) do
		if extui.ldSettingsUI[tostring(k)] == nil then

			extui.ldSettingsUI[tostring(k)] = v;

		end
	end

	if adef ~= nil then
		extui.defaultSettings = tbl;
	end
end

function extui.LoadSettings()
	--default settings

	extui.AddDefaults( {
		["showexp"]		=	true,
		["lockquest"]		=	true,
		["discraft"]			=	false,
		["iconsize"]		=	32,
		["buffcount"]		=	30,
		["extbuff"]			=	true,
		["remjoy"]			=	false,
		["remload"]		=	false,
		["rowamt"]			=	15,
		["buffsec"]			=	false,
		["buffdir"]			=	false,
		["buffdirtb"]		=	false,
		["lang"]				=	"eng",
		["gridSize"]			= 16,
	}, true);

	extui.lSettingsUI = {};

	extui.AddNewLine();

	extui.AddSetting("label1", {
			["name"] = "{@st43}"..extui.TLang("general").."{/}",
			["typedata"] = {
				["t"] = "ui::CRichText",
				["a"] = "richtext",
			},
		}
	);

	extui.AddSetting("remload", {
			["name"] = extui.TLang("loadMessage"),
			["tool"] = extui.TLang("loadMessageDesc"),
			["typedata"] = {
				["t"] = "ui::CCheckBox",
				["a"] = "checkbox",
			},
			["val"] = extui.ldSettingsUI["remload"],
			["callback"] = function(frame, ctrl) extui.SetSetting("remload",ctrl:IsChecked() == 1);	end,
			["oncall"] = ui.LBUTTONUP,
		}
	);

	extui.AddSetting("remjoy", {
			["name"] = extui.TLang("hideJoy"),
			["tool"] = extui.TLang("hideJoyDesc"),
			["typedata"] = {
				["t"] = "ui::CCheckBox",
				["a"] = "checkbox",
			},
			["val"] = extui.ldSettingsUI["remjoy"],
			["callback"] = function(frame, ctrl)
							extui.SetSetting("remjoy",ctrl:IsChecked() == 1);

							extui.RemoveJoySetting();
						end,
			["oncall"] = ui.LBUTTONUP,
		}
	);

	extui.AddSetting("showexp", {
			["name"] = extui.TLang("showExp"),
			["tool"] = extui.TLang("showExpDesc"),
			["typedata"] = {
				["t"] = "ui::CCheckBox",
				["a"] = "checkbox",
			},
			["val"] = extui.ldSettingsUI["showexp"],
			["callback"] = function(frame, ctrl) extui.SetSetting("showexp",ctrl:IsChecked() == 1); end,
			["oncall"] = ui.LBUTTONUP,
		}
	);

	extui.AddSetting("discraft", {
			["name"] = extui.TLang("disablePop"),
			["tool"] = extui.TLang("disablePopDesc"),
			["typedata"] = {
				["t"] = "ui::CCheckBox",
				["a"] = "checkbox",
			},
			["val"] = extui.ldSettingsUI["discraft"],
			["callback"] = function(frame, ctrl) extui.SetSetting("discraft",ctrl:IsChecked() == 1); end,
			["oncall"] = ui.LBUTTONUP,
		}
	);

	extui.AddSetting("lockquest", {
			["name"] = extui.TLang("lockQuest"),
			["tool"] = extui.TLang("lockQuestDesc"),
			["typedata"] = {
				["t"] = "ui::CCheckBox",
				["a"] = "checkbox",
			},
			["val"] = extui.ldSettingsUI["lockquest"],
			["callback"] = function(frame, ctrl) extui.SetSetting("lockquest",ctrl:IsChecked() == 1); end,
			["oncall"] = ui.LBUTTONUP,
		}
	);

	extui.AddSetting("lang", {
			["name"] = extui.TLang("lang"),
			["tool"] = extui.language.GetAuthor(),
			["typedata"] = {
				["a"] = "dropdown",
			},
			["val"] = extui.ldSettingsUI["lang"],
			["dropcall"] = EXTENDEDUI_ON_LANGUAGE_SELECT,
			["callback"] = "EXTENDEDUI_CHOOSE_LANGUAGE",
			["isLanguage"] = true,
		}
	);
	
	extui.AddSetting("gridSize", {
			["name"] = "Grid Size",
			["typedata"] = {
				["t"] = "ui::CSlideBar",
				["a"] = "slidebar",
			},
			["val"] = extui.ldSettingsUI["gridSize"],
			["callback"] = function(frame, ctrl)
							local oldGridSize = extui.GetSetting("gridSize");
							extui.SetSetting("gridSize",ctrl:GetLevel());
							
							if ui.GetFrame("EXTENDEDUI_GRIDFRAME") ~= nil and oldGridSize ~= ctrl:GetLevel() then
								extui.DrawGrid();
							end
						end,
			["oncall"] = ui.LBUTTONUP,
			["max"] = 100,
			["min"] = 5,
		}
	);

	extui.AddLabelLine();

	extui.AddSetting("label3", {
			["name"] = "{@st43}"..extui.TLang("buffs").."{/}",
			["typedata"] = {
				["t"] = "ui::CRichText",
				["a"] = "richtext",
			},
		}
	);

	--extui.AddNewLine();

	extui.AddSetting("iconsize", {
			["name"] = extui.TLang("bIconSize"),
			["typedata"] = {
				["t"] = "ui::CSlideBar",
				["a"] = "slidebar",
			},
			["val"] = extui.ldSettingsUI["iconsize"],
			["callback"] = function(frame, ctrl)
							extui.SetSetting("iconsize",ctrl:GetLevel());

							local eframe = extui.GetFrame("buff");
							if eframe ~= nil then
								for ch,_ in pairs(eframe.child) do
									if (ch == "buffcountslot_sub" or ch=="buffcountslot" or ch=="debuffslot" or ch=="buffslot") then

										extui.UpdateBuffSizes(ch);

									end
								end
							end

							extui.INIT_BUFF_UI(ui.GetFrame("buff"), s_buff_ui, "MY_BUFF_TIME_UPDATE");
							INIT_PREMIUM_BUFF_UI(ui.GetFrame("buff"));
						end,
			["oncall"] = ui.LBUTTONUP,
			["max"] = 100,
			["min"] = 16,
		}
	);

	extui.AddSetting("extbuff", {
			["name"] = extui.TLang("extBuff"),
			["tool"] = extui.TLang("extBuffDesc"),
			["typedata"] = {
				["t"] = "ui::CCheckBox",
				["a"] = "checkbox",
			},
			["val"] = extui.ldSettingsUI["extbuff"],
			["callback"] = function(frame, ctrl)
							extui.SetSetting("extbuff",ctrl:IsChecked() == 1);
						end,
			["oncall"] = ui.LBUTTONUP,
		}
	);
	
	extui.AddSetting("buffdir", {
			["name"] = extui.TLang("buffdir"),
			["tool"] = extui.TLang("buffdirDesc"),
			["typedata"] = {
				["t"] = "ui::CCheckBox",
				["a"] = "checkbox",
			},
			["val"] = extui.ldSettingsUI["buffdir"],
			["callback"] = function(frame, ctrl)
							extui.SetSetting("buffdir",ctrl:IsChecked() == 1);
							
							local eframe = extui.GetFrame("buff");
							if eframe ~= nil then
								for ch,_ in pairs(eframe.child) do
									if (ch == "buffcountslot_sub" or ch=="buffcountslot" or ch=="debuffslot" or ch=="buffslot") then

										extui.UpdateBuffSizes(ch);
									end
								end
							end

							extui.INIT_BUFF_UI(ui.GetFrame("buff"), s_buff_ui, "MY_BUFF_TIME_UPDATE");
							INIT_PREMIUM_BUFF_UI(ui.GetFrame("buff"));
						end,
			["oncall"] = ui.LBUTTONUP,
		}
	);
	
	extui.AddSetting("buffdirtb", {
			["name"] = extui.TLang("buffdirtb"),
			["tool"] = extui.TLang("buffdirtbDesc"),
			["typedata"] = {
				["t"] = "ui::CCheckBox",
				["a"] = "checkbox",
			},
			["val"] = extui.ldSettingsUI["buffdirtb"],
			["callback"] = function(frame, ctrl)
							extui.SetSetting("buffdirtb",ctrl:IsChecked() == 1);
							
							local eframe = extui.GetFrame("buff");
							if eframe ~= nil then
								for ch,_ in pairs(eframe.child) do
									if (ch == "buffcountslot_sub" or ch=="buffcountslot" or ch=="debuffslot" or ch=="buffslot") then

										extui.UpdateBuffSizes(ch);
									end
								end
							end

							extui.INIT_BUFF_UI(ui.GetFrame("buff"), s_buff_ui, "MY_BUFF_TIME_UPDATE");
							INIT_PREMIUM_BUFF_UI(ui.GetFrame("buff"));
						end,
			["oncall"] = ui.LBUTTONUP,
		}
	);
	
	extui.AddSetting("buffcount", {
			["name"] = extui.TLang("buffcount"),
			["tool"] = extui.TLang("buffcountDesc"),
			["typedata"] = {
				["t"] = "ui::CSlideBar",
				["a"] = "slidebar",
			},
			["val"] = extui.ldSettingsUI["buffcount"],
			["callback"] = function(frame, ctrl)
							if ctrl:GetLevel() ~= extui.GetSetting("buffcount") then
								extui.SetSetting("buffcount",ctrl:GetLevel());

								local eframe = extui.GetFrame("buff");
								if eframe ~= nil then
									for ch,_ in pairs(eframe.child) do
										if (ch == "buffcountslot_sub" or ch=="buffcountslot" or ch=="debuffslot" or ch=="buffslot") then

											extui.UpdateBuffSizes(ch);
										end
									end
								end

								extui.INIT_BUFF_UI(ui.GetFrame("buff"), s_buff_ui, "MY_BUFF_TIME_UPDATE");
								INIT_PREMIUM_BUFF_UI(ui.GetFrame("buff"));
							end

						end,
			["oncall"] = ui.LBUTTONUP,
			["min"] = 30,
			["max"] = 200,
			["disabled"] = function() return not(extui.GetSetting("extbuff")); end,
		}
	);

	extui.AddSetting("rowamt", {
			["name"] = extui.TLang("buffAmt"),
			["tool"] = extui.TLang("buffAmtDesc"),
			["typedata"] = {
				["t"] = "ui::CSlideBar",
				["a"] = "slidebar",
			},
			["val"] = extui.ldSettingsUI["rowamt"],
			["callback"] = function(frame, ctrl)
							if ctrl:GetLevel() ~= extui.GetSetting("rowamt") then
							
								--we limit it to whatever the max buffcount is
								local nlvl = ctrl:GetLevel() > extui.ldSettingsUI["buffcount"] and extui.ldSettingsUI["buffcount"] or ctrl:GetLevel();
								
								extui.SetSetting("rowamt", nlvl);
								ctrl:SetLevel(nlvl);

								local eframe = extui.GetFrame("buff");
								if eframe ~= nil then
									for ch,_ in pairs(eframe.child) do
										if (ch == "buffcountslot_sub" or ch=="buffcountslot" or ch=="debuffslot" or ch=="buffslot") then

											extui.UpdateBuffSizes(ch);
										end
									end
								end

								extui.INIT_BUFF_UI(ui.GetFrame("buff"), s_buff_ui, "MY_BUFF_TIME_UPDATE");
								INIT_PREMIUM_BUFF_UI(ui.GetFrame("buff"));
							end

						end,
			["oncall"] = ui.LBUTTONUP,
			["min"] = 1,
			["max"] = 200,
			["disabled"] = function() return not(extui.GetSetting("extbuff")); end,
		}
	);

	extui.AddSetting("buffsec", {
			["name"] = extui.TLang("buffSec"),
			["tool"] = extui.TLang("buffSecDesc"),
			["typedata"] = {
				["t"] = "ui::CCheckBox",
				["a"] = "checkbox",
			},
			["val"] = extui.ldSettingsUI["buffsec"],
			["callback"] = function(frame, ctrl)
							extui.SetSetting("buffsec",ctrl:IsChecked() == 1);
						end,
			["oncall"] = ui.LBUTTONUP,
		}
	);
	
	
	extui.AddNewLine();
end


function EXTENDEDUI_ON_SETTINGS_PRESS(frame, ctrl, argStr)
	
	local _settings = extui.GetSettings();
	
	if _settings[argStr].callback ~= nil then
		local t,p = pcall(_settings[argStr].callback, frame, ctrl);
		if not(t) then
			extui.print(tostring(p));
		end
	end

	--also update all disabled
	for k,v in extui.spairs(_settings, function(t,a,b) return t[b].order > t[a].order end) do
		local typedata = v.typedata;
		local ctrla = typedata.a;
		local isDisabled = v.disabled;

		if type(isDisabled) == "function" then
			isDisabled = isDisabled();
		end

		local cbox = extui.sideFrame; --extui.sideFrame:GetChild("extuiboxs");
		local ctrls = cbox:GetChild("extuisetctrl"..tostring(k));

		if isDisabled then
			ctrls:SetColorTone("FF444444");
			ctrls:SetClickSound("");
			ctrls:SetOverSound("");
			ctrls:CreateOrGetControl("picture", "extuitctrlpd"..tostring(k), 400, 30, ui.LEFT, ui.TOP, 0, 0, 0, 0)
		else
			ctrls:SetColorTone("FFFFFFFF");

			if ctrla == "checkbox" then
				ctrls:SetClickSound("button_click_big");
				ctrls:SetOverSound("button_over");
			end

			ctrls:RemoveChild("extuitctrlpd"..tostring(k));
		end
	end
	
end


function EXTENDEDUI_ON_SETTINGS_SLIDE(ctrl)
	local t,p = pcall(EXTENDEDUI_ON_SETTINGS_SLIDES, ctrl);
	if not(t) then
		extui.print("[EUI] Settings Error: "..tostring(p));
	end
	
	return 1;
end

function EXTENDEDUI_ON_SETTINGS_SLIDES(ctrl)
	local _settings = extui.GetSettings();
	local uibox = extui.sideFrame;
	uibox = uibox:GetChild("extuisetgrpbox");
	ctrl = tolua.cast(ctrl, "ui::CSlideBar");
	local n = ctrl:GetName();
	local argStr = string.sub(tostring(n), string.len("extuisetctrl")+1);

	if _settings[argStr] ~= nil then
		if ctrl:GetLevel() ~= _settings[argStr].val then
			local labelval = GET_CHILD(uibox,"extuisetlabelval"..argStr,"ui::CRichText");
			labelval:SetText("{@st42b}"..tostring(ctrl:GetLevel()).."{/}");
		end

		if _settings[argStr].callback ~= nil then

			_settings[argStr].callback(uibox, ctrl);

		end
	end

	return 1;
end


function extui.UIAddSettings(cbox)
	local t,p = pcall(extui.UIAddSettingsS, cbox);
	if not(t) then
		extui.print("ERRRRR func(): "..tostring(p));
	end

end


function EXTENDEDUI_ON_OPENCOLORWHEEL(frm, ctrl)
	local t,p = pcall(EXTENDEDUI_ON_OPENCOLORWHEELS, ctrl);
	if not(t) then
		extui.print("ERRRRR func(): "..tostring(p));
	end

end
function EXTENDEDUI_ON_OPENCOLORWHEELS(ctrl)
	extui.CreateColorWheel(ctrl:GetUserValue("settingName"));
end

function extui.UIAddSettingsS(cbox)
	local ctrls = nil;
	local inx = 20;
	local iny = 0;
	local _settings = extui.GetSettings();
	local iii = 1;
	for k,v in extui.spairs(_settings, function(t,a,b) return t[b].order > t[a].order end) do
		local isHidden = v.hidden or false;
		
		if isHidden == false then
			local typedata = v.typedata;
			local ctrltype = typedata.t;
			local ctrla = typedata.a;
			local name = v.name;
			local value = extui.GetSavedSetting(tostring(k));
			local tool = v.tool;
			local oncall = v.oncall;
			local oncreate = v.oncreate;
			local isDisabled = v.disabled;

			if type(isDisabled) == "function" then
				isDisabled = isDisabled();
			end

			
			if ctrla ~= "newline" and ctrla ~= "dropdown" and ctrla ~= "rgbaselect" and ctrla ~= "advdropdown" then
				ctrls = cbox:CreateOrGetControl(ctrla, "extuisetctrl"..tostring(k), inx, iny, 150, 30);
			end
			if ctrltype then
				ctrls = tolua.cast(ctrls, ctrltype);
			end

			if tool ~= nil and tool ~= "" and ctrla ~= "dropdown" and ctrla ~= "rgbaselect" and ctrla ~= "advdropdown" then
				ctrls:SetTextTooltip(string.format("{@st42b}"..tool.."{/}"));
			end

			if ctrla == "checkbox" then
				ctrls:SetText("{@st42b}"..tostring(name).."{/}");
				ctrls:SetEventScriptArgString(oncall, tostring(k));
				ctrls:SetCheck(value==true and 1 or 0);
				ctrls:SetClickSound("button_click_big");
				ctrls:SetOverSound("button_over");

				if isDisabled == nil then
					ctrls:SetEventScript(oncall, "EXTENDEDUI_ON_SETTINGS_PRESS");
				end

			elseif ctrla == "slidebar" then
				ctrls:SetMaxSlideLevel(v.max);
				ctrls:SetMinSlideLevel(v.min or 0);
				ctrls:SetLevel(value);
				ctrls:Resize(260,30);
				iny = iny+5;
				ctrls:SetOffset(inx,iny);

				local ctrlst = cbox:CreateOrGetControl("richtext", "extuisetlabelval"..tostring(k), inx+255, iny+5, 150, 30);
				ctrlst = tolua.cast(ctrlst, "ui::CRichText");
				ctrlst:SetText("{@st42b}"..tostring(value).."{/}");

				local ctrlsst = cbox:CreateOrGetControl("richtext", "extuisetctrlsl"..tostring(k), inx, iny-12, 150, 30);
				ctrlsst = tolua.cast(ctrlsst, "ui::CRichText");
				ctrlsst:SetText("{@st42b}"..tostring(name).."{/}");

				if isDisabled then
					ctrlst:SetColorTone("FF444444");
					ctrlsst:SetColorTone("FF444444");
				else
					ctrls:RunUpdateScript("EXTENDEDUI_ON_SETTINGS_SLIDE");
				end

				iny = iny-5;

			elseif ctrla == "richtext" then
				ctrls:SetText(name);
			elseif ctrla == "labelline" then
				ctrls:SetOffset(inx,iny);
				ctrls:Resize(300,4);

				iny = iny-30;
			elseif ctrla == "dropdown" then
				local ctrlst = cbox:CreateOrGetControl("richtext", "extuisetdroplabel"..tostring(k), inx+5, iny, 150, 30);
				ctrlst = tolua.cast(ctrlst, "ui::CRichText");
				ctrlst:SetText("{@st42b}"..tostring(name).."{/}");
				
				if v.isLanguage ~= nil then
					ctrlst = cbox:CreateOrGetControl("richtext", "extuisetauthorlabel"..tostring(k), inx+100, iny+20, 150, 30);
					ctrlst = tolua.cast(ctrlst, "ui::CRichText");
					ctrlst:SetText("{@st62}"..extui.TLang("author")..": "..tostring(tool).."{/}");
				end

				if extui.isInDrop == false then
					cbox:CreateOrGetControl("richtext", "extuisetctrl"..tostring(k), inx, iny, 0, 0); --needed
					ctrlss = cbox:CreateOrGetControl("droplist", "extuiminidropdown"..tostring(k), inx+100, iny, 200, 40);
					ctrlss = tolua.cast(ctrlss, "ui::CDropList");
					ctrlss:SetSkinName("droplist_normal");
					ctrlss:SetTextAlign("left","left");
					if v.callback ~= nil then
						ctrlss:SetSelectedScp(v.callback);
					end
					
					if v.dropcall ~= nil then
						v.dropcall();
					end
				end
			elseif ctrla == "rgbaselect" then
				local ctrlst = cbox:CreateOrGetControl("richtext", "extuisetdroplabel"..tostring(k), inx+5, iny+15, 150, 30);
				ctrlst = tolua.cast(ctrlst, "ui::CRichText");
				ctrlst:SetText("{@st42b}"..tostring(name).."{/}");
				
				local ctrlss = cbox:CreateOrGetControl("button","setcolPreview"..tostring(k),inx+60, iny, 30, 30);
				AUTO_CAST(ctrlss);
				ctrlss:SetImage("euiwhite");
				ctrlss:SetColorTone("FF"..extui.GetSetting(tostring(k)));
				ctrlss:SetTextTooltip("{@st42b}Open Color Wheel{/}");
				ctrlss:SetEventScript(ui.LBUTTONUP, "EXTENDEDUI_ON_OPENCOLORWHEEL");
				ctrlss:SetClickSound("button_click_big");
				ctrlss:SetOverSound("button_over");
				ctrlss:SetUserValue("settingName", tostring(k));
				
				iny=iny+15;

			elseif ctrla == "advdropdown" then
				local ctrlst = cbox:CreateOrGetControl("richtext", "extuisetdroplabel"..tostring(k), inx+5, iny, 150, 30);
				ctrlst = tolua.cast(ctrlst, "ui::CRichText");
				ctrlst:SetText("{@st42b}"..tostring(name).."{/}");
				
				ctrlss = cbox:CreateOrGetControl("droplist", "extuisetdropdown"..tostring(k), inx+100, iny, 200, 40);
				AUTO_CAST(ctrlss);
				ctrlss:SetSkinName("droplist_normal");
				ctrlss:SetTextAlign("left","left");
				ctrlss:SetUserValue("SETTING", tostring(k));
				
				if v.callback ~= nil then
					ctrlss:SetSelectedScp(v.callback);
				end
				
				if v.dropcall ~= nil then
					v.dropcall(ctrlss, tostring(k));
				end
				
			end

			if isDisabled then
				ctrls:SetColorTone("FF444444");
				ctrls:SetClickSound("");
				ctrls:SetOverSound("");
				ctrls:CreateOrGetControl("picture", "extuitctrlpd"..tostring(k), 400, 30, ui.LEFT, ui.TOP, 0, 0, 0, 0)
			end

			if oncreate ~= nil then
				oncreate(ctrls, inx, iny);
			end

			iny = iny+40;
			inx = 20;
		end

	end

end



function extui.RemoveJoySetting()
	local set = extui.GetSetting("remjoy");

	local frm = ui.GetFrame("joystickquickslot");
	local ch = frm:GetChild("L2R2_Set1");
	ch:ShowWindow( not(set) and 1 or 0 );
	ch = frm:GetChild("L2R2_Set2");
	ch:ShowWindow( not(set) and 1 or 0 );
	ch = frm:GetChild("L2R2");
	ch:ShowWindow( not(set) and 1 or 0 );
	ch = frm:GetChild("refreshBtn");
	ch:ShowWindow( not(set) and 1 or 0 );
	frm = ui.GetFrame("joystickrestquickslot");
	ch = frm:GetChild("restmode");
	ch:ShowWindow( not(set) and 1 or 0 );
end
