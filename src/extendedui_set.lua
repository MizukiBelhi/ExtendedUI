--ExtendedUI Settings

if extui == nil then
	extui = {};
end

extui.ldSettingsUI = {};
extui.lSettingsUI = {};
extui.defaultSettings = {};

function extui.GetSetting(name)
	return extui.lSettingsUI[name].val;
end

function extui.GetSavedSetting(name)
	return extui.ldSettingsUI[name];
end

function extui.SetSetting(name, val)
	extui.lSettingsUI[name].val = val;
end

function extui.GetSettings()
	return extui.lSettingsUI;
end

function extui.AddSetting(name, tbl)
	extui.lSettingsUI[name] = tbl;
	extui.lSettingsUI[name].order = extui.tablelength(extui.lSettingsUI);

end

function extui.AddDefaults(tbl, adef)
	if extui.ldSettingsUI == nil then
		extui.ldSettingsUI = {};
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
		["lockquest"]	=	true,
		["discraft"]	=	false,
		["iconsize"]	=	32,
		["extbuff"]		=	true,
		["remjoy"]		=	false,
		["remload"]		=	false,
		["rowamt"]		=	15,
		["buffsec"]		=	false,
	}, true);

	extui.lSettingsUI = {};

	extui.AddSetting("label1", {
			["name"] = "{@st43}General{/}",
			["typedata"] = {
				["t"] = "ui::CRichText",
				["a"] = "richtext",
			},
		}
	);

	extui.AddSetting("newline", {
			["typedata"] = {
				["a"] = "newline",
			}
		}
	);


	extui.AddSetting("remload", {
			["name"] = "Remove Loaded Message",
			["tool"] = "Removes the \"ExtendedUI Loaded\" message on startup",
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
			["name"] = "Hide buttons from Joystick Quickslot",
			["tool"] = "Removes the \"Set 1\"/\"Set 2\" buttons from the Joystick Quickslot",
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
			["name"] = "Show EXP Numbers",
			["tool"] = "Shows exact exp numbers when hovering over the exp bars. (Updates after map change)",
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
			["name"] = "Disable Recipe Item Popup",
			["tool"] = "Disables the popup when getting an item for crafting.",
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
			["name"] = "Lock Quest Log Position",
			["tool"] = "Locks the Quest Log so it no longer moves in both directions when new quests are added or removed.",
			["typedata"] = {
				["t"] = "ui::CCheckBox",
				["a"] = "checkbox",
			},
			["val"] = extui.ldSettingsUI["lockquest"],
			["callback"] = function(frame, ctrl) extui.SetSetting("lockquest",ctrl:IsChecked() == 1); end,
			["oncall"] = ui.LBUTTONUP,
		}
	);


	extui.AddSetting("line4", {
			["typedata"] = {
				["a"] = "labelline",
			},
		}
	);

	extui.AddSetting("label3", {
			["name"] = "{@st43}Buffs{/}",
			["typedata"] = {
				["t"] = "ui::CRichText",
				["a"] = "richtext",
			},
		}
	);

	extui.AddSetting("newline3", {
			["typedata"] = {
				["a"] = "newline",
			}
		}
	);


	extui.AddSetting("iconsize", {
			["name"] = "Buff Icon Size",
			["typedata"] = {
				["t"] = "ui::CSlideBar",
				["a"] = "slidebar",
			},
			["val"] = extui.ldSettingsUI["iconsize"],
			["callback"] = function(frame, ctrl)
							extui.SetSetting("iconsize",ctrl:GetLevel());

							for k,v in pairs(extui.frames) do
								if v.isMovable and k=="buff" then
									if extui.frames[k].hasChild then
										for ch,v in pairs(extui.frames[k]["child"]) do
											if (ch=="buffcountslot" or ch=="debuffslot" or ch=="buffslot") then

												extui.MoveBuffCaption(k, ch);

												local frm = ui.GetFrame(k);
												local fch = frm:GetChild(ch);

												local slotc = extui.GetSetting("rowamt");
												local rowc = extui.round(30/slotc);

												fch:Resize(slotc*ctrl:GetLevel(),rowc*ctrl:GetLevel());
											end
										end
									end
								end
							end

						end,
			["oncall"] = ui.LBUTTONUP,
			["max"] = 100,
		}
	);

	extui.AddSetting("extbuff", {
			["name"] = "Extend Buff Display",
			["tool"] = "Extends the buff display to show a maximum of 30 buffs.",
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

	extui.AddSetting("rowamt", {
			["name"] = "Amount In Row",
			["tool"] = "Creates new rows with this amount of buffs. (Only works with extended buff display on)",
			["typedata"] = {
				["t"] = "ui::CSlideBar",
				["a"] = "slidebar",
			},
			["val"] = extui.ldSettingsUI["rowamt"],
			["callback"] = function(frame, ctrl)
							if ctrl:GetLevel() ~= extui.GetSetting("rowamt") then
								extui.SetSetting("rowamt",ctrl:GetLevel());

								for k,v in pairs(extui.frames) do
									if v.isMovable and k=="buff" then
										if extui.frames[k].hasChild then
											for ch,v in pairs(extui.frames[k]["child"]) do
												if (ch=="buffcountslot" or ch=="debuffslot" or ch=="buffslot") then

													extui.MoveBuffCaption(k, ch);

													local frm = ui.GetFrame(k);
													local fch = frm:GetChild(ch);

													local slotc = extui.GetSetting("rowamt");
													local rowc = extui.round(30/slotc);

													fch:Resize(slotc*extui.GetSetting("iconsize"),rowc*extui.GetSetting("iconsize"));
												end
											end
										end
									end
								end

								extui.INIT_BUFF_UI(ui.GetFrame("buff"), s_buff_ui, "MY_BUFF_TIME_UPDATE");
								INIT_PREMIUM_BUFF_UI(ui.GetFrame("buff"));
							end

						end,
			["oncall"] = ui.LBUTTONUP,
			["min"] = 1,
			["max"] = 30,
		}
	);

	extui.AddSetting("buffsec", {
			["name"] = "Always Show Seconds",
			["tool"] = "Shows (x)s instead of (x)m.",
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

end


function EXTENDEDUI_ON_SETTINGS_PRESS(frame, ctrl, argStr)
	
	local _settings = extui.GetSettings();
	
	if _settings[argStr].callback ~= nil then
		local t,p = pcall(_settings[argStr].callback, frame, ctrl);
		if not(t) then
			extui.print(tostring(p));
		end
	end
	
end


function EXTENDEDUI_ON_SETTINGS_SLIDE(ctrl)
	local tabObj		    = extui.sideFrame:GetChild("extuitabs");
	local itembox_tab		= tolua.cast(tabObj, "ui::CTabControl");
	local curtabIndex	    = itembox_tab:GetSelectItemIndex();
	
	-- make sure it only happens when actually on that tab
	if curtabIndex == 0 then
		local _settings = extui.GetSettings();
		local uibox = GET_CHILD(extui.sideFrame, "extuiboxs", "ui::CGroupBox");
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

	end
	return 1;
end


function extui.UIAddSettings(cbox)
	local ctrls = nil;
	local inx = 20;
	local iny = 20;
	local _settings = extui.GetSettings();
	local iii = 1;
	for k,v in extui.spairs(_settings, function(t,a,b) return t[b].order > t[a].order end) do
		local typedata = v.typedata;
		local ctrltype = typedata.t;
		local ctrla = typedata.a;
		local name = v.name;
		local value = extui.GetSavedSetting(tostring(k));
		local tool = v.tool;
		local oncall = v.oncall;
		local oncreate = v.oncreate;
		local isDisabled = v.disabled;
		
		
		if ctrla ~= "newline" then
			ctrls = cbox:CreateOrGetControl(ctrla, "extuisetctrl"..tostring(k), inx, iny, 150, 30);
		end
		if ctrltype then
			ctrls = tolua.cast(ctrls, ctrltype);
		end

		if tool ~= nil and tool ~= "" then
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
			inx=20;
			iny = iny+40;

			if iii%2 ~= 0 then
				iny = iny-40;
			end

			ctrls:SetOffset(inx,iny);
			ctrls:Resize(700,1);

			if iii%2 == 0 then
				iny = iny-30;
			else
				iny = iny-30;
				iii=iii+1;
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
		
		inx = inx+400;
		
		if iii%2 == 0 then
			iny = iny+40;
			inx = 20;
		end
		
		iii = iii+1;
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
	frm = ui.GetFrame("joystickrestquickslot");
	ch = frm:GetChild("restmode");
	ch:ShowWindow( not(set) and 1 or 0 );
end
