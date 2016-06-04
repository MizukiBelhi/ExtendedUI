--ExtendedUI Settings

if extui == nil then
	extui = {};
end

extui.ldSettingsUI = {};
extui.lSettingsUI = {};

function extui.GetSetting(name)
	return extui.lSettingsUI[name].val;
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

function extui.AddDefaults(tbl)
	if extui.ldSettingsUI == nil then
		extui.ldSettingsUI = {};
	end

	for k,v in pairs(tbl) do
		if extui.ldSettingsUI[tostring(k)] == nil then

			extui.ldSettingsUI[tostring(k)] = v;

		end
	end
end

function extui.LoadSettings()
	--default settings

	extui.AddDefaults( {
		["showexp"]		=	true,
		["lockquest"]	=	true,
		["nopet"]		=	true,
		["extquest"]	=	true,
		["discraft"]	=	false,
		["iconsize"]	=	32,
		["extbuff"]		=	true,
		["uiscale"]		=	100,
	});

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

	extui.AddSetting("uiscale", {
			["name"] = "UI Scale",
			["tool"] = "Scales UI, does not affect buffs",
			["typedata"] = {
				["t"] = "ui::CSlideBar",
				["a"] = "slidebar",
			},
			["val"] = extui.ldSettingsUI["uiscale"],
			["callback"] = function(frame, ctrl)
							local newScale = ctrl:GetLevel();
							extui.SetSetting("uiscale", newScale);
							extui.ScaleUI(newScale);
						end,
			["oncall"] = ui.LBUTTONUP,
			["max"] = 150,
			["min"] = 10,
		}
	);

	extui.AddSetting("remjoy", {
			["name"] = "Removes thingies from Joystick Quickslot",
			["tool"] = "I don't even know.. let me sleep!",
			["typedata"] = {
				["t"] = "ui::CCheckBox",
				["a"] = "checkbox",
			},
			["val"] = extui.ldSettingsUI["remjoy"],
			["callback"] = function(frame, ctrl) extui.SetSetting("remjoy",ctrl:IsChecked() == 1); end,
			["oncall"] = ui.LBUTTONUP,
			["disabled"] = true,
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
								if v.isMovable and (k=="buff" or k=="targetbuff") then
									if extui.frames[k].hasChild then
										for ch,v in pairs(extui.frames[k]["child"]) do
											if (ch=="buffcountslot" or ch=="debuffslot" or ch=="buffslot") then

												extui.MoveBuffCaption(k, ch);

												local frm = ui.GetFrame(k);
												local fch = frm:GetChild(ch);

												local slotCount = fch:GetSlotCount();
												fch:Resize(slotCount*ctrl:GetLevel(),ctrl:GetLevel());

												ui.GetFrame("extuiframectrls"..k..ch):Resize(slotCount*ctrl:GetLevel(),ctrl:GetLevel());
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
			["disabled"] = true,
		}
	);


	extui.AddSetting("line", {
			["typedata"] = {
				["a"] = "labelline",
			},
		}
	);


	extui.AddSetting("label2", {
			["name"] = "{@st43}Future Features{/}",
			["typedata"] = {
				["t"] = "ui::CRichText",
				["a"] = "richtext",
			},
		}
	);

	extui.AddSetting("newline2", {
			["typedata"] = {
				["a"] = "newline",
			}
		}
	);
	
	extui.AddSetting("nopet", {
			["name"] = "Remove Pet Click",
			["tool"] = "Makes pets non-clickable.",
			["typedata"] = {
				["t"] = "ui::CCheckBox",
				["a"] = "checkbox",
			},
			["val"] = extui.ldSettingsUI["nopet"],
			["callback"] = function(frame, ctrl) extui.SetSetting("nopet",ctrl:IsChecked() == 1); end,
			["oncall"] = ui.LBUTTONUP,
			["disabled"] = true,
		}
	);
	
	extui.AddSetting("extquest", {
			["name"] = "Extended Quest Log",
			["tool"] = "Allows for more quests tracked.",
			["typedata"] = {
				["t"] = "ui::CCheckBox",
				["a"] = "checkbox",
			},
			["val"] = extui.ldSettingsUI["extquest"],
			["callback"] = function(frame, ctrl) extui.SetSetting("extquest",ctrl:IsChecked() == 1); end,
			["oncall"] = ui.LBUTTONUP,
			["disabled"] = true,
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
	local _settings = extui.GetSettings();

	local tabObj		    = extui.sideFrame:GetChild("extuitabs");
	local itembox_tab		= tolua.cast(tabObj, "ui::CTabControl");
	local curtabIndex	    = itembox_tab:GetSelectItemIndex();
	
	-- make sure it only happens when actually on that tab
	if curtabIndex == 0 then

		local uibox = GET_CHILD(extui.sideFrame, "extuiboxs", "ui::CGroupBox");
		local n = ctrl:GetName();
		local argStr = string.sub(tostring(n), string.len("extuitctrl")+1);

		if _settings[argStr] ~= nil then
			if _settings[argStr].callback ~= nil then

				_settings[argStr].callback(uibox, ctrl);

			end
		end
	end
	return 1;
end
