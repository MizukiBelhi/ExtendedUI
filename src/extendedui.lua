local addonName = "EXTENDEDUI";

_G["ADDON_LOADER"] = {};
dofile('../addons/cwapi/cwapi.lua');

extui = {};
extui.firstStart = false;
extui.frames = {
		["time"] = {
			["isMovable"] = true,
			["hasChild"] = false,
			["name"] = "Time",
			["noResize"] = true,
			["saveHidden"] = true,
		},
		["targetinfo"] = {
			["isMovable"] = true,
			["hasChild"] = false,
			["name"] = "Target Info",
			["noResize"] = true,
		},
		["buff"] = {
			["isMovable"] = true,
			["hasChild"] = true,
			["name"] = "Buffs",
			["child"] = {
				["buffcountslot"] = {
					["isMovable"] = true,
					["name"] = "Temp Buffs",
				},
				["buffslot"] = {
					["isMovable"] = true,
					["name"] = "Perm Buffs",
				},
				["debuffslot"] = {
					["isMovable"] = true,
					["name"] = "Debuffs",
				},
			},
		},
		["targetbuff"] = {
			["isMovable"] = true,
			["hasChild"] = true,
			["name"] = "Target Buffs",
			["child"] = {
				["buffcountslot"] = {
					["isMovable"] = true,
					["name"] = "Temp Buffs",
				},
				["buffslot"] = {
					["isMovable"] = true,
					["name"] = "Perm Buffs",
				},
				["debuffslot"] = {
					["isMovable"] = true,
					["name"] = "Debuffs",
				},
			},
		},
		["fps"] = {
			["isMovable"] = true,
			["hasChild"] = false,
			["name"] = "FPS",
			["noResize"] = true,
			["saveHidden"] = true,
		},
		["minimap"] = {
			["isMovable"] = true,
			["hasChild"] = false,
			["name"] = "Mini Map",
			["noResize"] = true,
		},
		["chat"] = {
			["isMovable"] = true,
			["hasChild"] = false,
			["name"] = "Chat Input",
			["noResize"] = true,
		},
		["playtime"] = {
			["isMovable"] = true,
			["hasChild"] = false,
			["name"] = "Playtime",
			["noResize"] = true,
			["saveHidden"] = true,
		},
		["chatframe"] = {
			["isMovable"] = true,
			["hasChild"] = false,
			["name"] = "Chat Window",
			["noResize"] = true,
		},
		["charbaseinfo"] = {
			["isMovable"] = true,
			["hasChild"] = false,
			["name"] = "EXP Bars",
		},
		["headsupdisplay"] = {
			["isMovable"] = true,
			["hasChild"] = false,
			["name"] = "Character Status",
		},
		["sysmenu"] = {
			["isMovable"] = true,
			["hasChild"] = false,
			["name"] = "Menu",
			["noResize"] = true,
		},
		["channel"] = {
			["isMovable"] = true,
			["hasChild"] = false,
			["name"] = "Channel",
			["noResize"] = true,
		},
		["partyinfo"] = {
			["isMovable"] = true,
			["hasChild"] = false,
			["name"] = "Party",
			["noResize"] = true,
		},
		
		--[[
		["questinfo"] = {
			["isMovable"] = true,
			["hasChild"] = false,
			["name"] = "Quest Log",
			["noResize"] = true,
		},
		--]]

		["questinfoset_2"] = {
			["isMovable"] = true,
			["hasChild"] = false,
			["name"] = "Quest Log",
			["noResize"] = true,
		},

		["weaponswap"] = {
			["isMovable"] = true,
			["hasChild"] = false,
			["name"] = "Weaponswap",
			["noResize"] = true,
			["saveHidden"] = true,
		},
		["castingbar"] = {
			["isMovable"] = true,
			["hasChild"] = false,
			["name"] = "Castbar",
			["noResize"] = true,
		},
		["durnotify"] = {
			["isMovable"] = true,
			["hasChild"] = false,
			["name"] = "Durability",
			["noResize"] = true,
		},
	};


extui.framepos = {};
extui.sideFrame = nil;
extui.isSetting = false;
extui.isReload = false;
extui.closingSettings = false;
extui.ldSettingsUI = {};
extui.lSettingsUI = {};
extui.IsDragging = false;
extui.defaultFrames = {};



local function spairs(t, order)
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end
    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
		end
    end
end

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
	extui.lSettingsUI[name].order = cwAPI.util.tablelength(extui.lSettingsUI);

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
		["confine"]		=	true,
		["discraft"]	=	false,
		["iconsize"]	=	32,
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


	extui.AddSetting("confine", {
			["name"] = "Confine Child To Parent Frames",
			["tool"] = "Experimental Feature",
			["typedata"] = {
				["t"] = "ui::CCheckBox",
				["a"] = "checkbox",
			},
			["val"] = extui.ldSettingsUI["confine"],
			["callback"] = function(frame, ctrl)
								extui.SetSetting("confine",ctrl:IsChecked() == 1); 
								local uibox = GET_CHILD(extui.sideFrame, "extuibox", "ui::CGroupBox");
							
								extui.ForEachFrame(nil,nil,nil,nil,function(k, v, ck, cv, toc, tcc)
									local sliderX = GET_CHILD(uibox,"extuislidex"..tostring(k)..tostring(ck),"ui::CSlideBar");
									local sliderY = GET_CHILD(uibox,"extuislidey"..tostring(k)..tostring(ck),"ui::CSlideBar");

									if ctrl:IsChecked()==1 then
										toc = ui.GetFrame(k);
										tcc = toc:GetChild(tostring(ck));
										local w = tcc:GetWidth();
										local h = tcc:GetHeight();
										sliderX:SetMaxSlideLevel(toc:GetWidth()-w);
										sliderX:SetMinSlideLevel(0);
										sliderY:SetMaxSlideLevel(toc:GetHeight()-h);
										sliderY:SetMinSlideLevel(0);
									else
										sliderX:SetMaxSlideLevel(ui.GetClientInitialWidth());
										sliderX:SetMinSlideLevel(-ui.GetClientInitialWidth());
										sliderY:SetMaxSlideLevel(ui.GetClientInitialHeight());
										sliderY:SetMinSlideLevel(-ui.GetClientInitialHeight());
									end
								end);
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

	--[[
	extui.AddSetting("newline", {
			["typedata"] = {
				["a"] = "newline",
			}
		}
	);

	extui.AddSetting("line", {
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

	extui.AddSetting("newline", {
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
			["callback"] = function(frame, ctrl) end,
			["oncall"] = ui.LBUTTONUP,
			["max"] = 100,
		}
	);--]]


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
			["disabled"] = true,
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
			cwAPI.util.log(tostring(p));
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


-- util
function round(num, idp)
  if idp and idp>0 then
    local mult = 10^idp;
    return math.floor(num * mult + 0.5) / mult;
  end
  return math.floor(num + 0.5);
end

function extui.GetPercent(anum,maxn,amaxn)
	local nn = tonumber(maxn/amaxn);
	return tonumber(nn*anum);
end

function extui.ForEachFrame(func, nfunc, nefunc, cfunc, cnfunc, cnefunc)
	local toc = nil;
	for k,v in pairs(extui.frames) do
		toc = ui.GetFrame(k);
		if v.isMovable and toc ~= nil then
			if extui.framepos[tostring(k)] ~= nil then
				if func then
					local t,p = pcall(func, k,v,toc);
					if not(t) then
						cwAPI.util.log("ForEachFrame Err func(): "..tostring(p));
					end
				end
			else
				if nfunc then
					local t,p = pcall(nfunc, k,v,toc);
					if not(t) then
						cwAPI.util.log("ForEachFrame Err nfunc(): "..tostring(p));
					end
				end
			end
		else
			if nefunc then
				local t,p = pcall(nefunc, k,v,toc);
				if not(t) then
					cwAPI.util.log("ForEachFrame Err nefunc(): "..tostring(p));
				end
			end
		end
		
		
		if v.hasChild and toc ~= nil then
			local tcc = nil;
			for ck,cv in pairs(v.child) do
				tcc = toc:GetChild(tostring(ck));
				
				if cv.isMovable and tcc ~= nil then
					if extui.framepos[tostring(k)]["child"][tostring(ck)] == nil then
						if cfunc then
							local t,p = pcall(cfunc, k, v, ck, cv, toc, tcc);
							if not(t) then
								cwAPI.util.log("ForEachFrame Err cfunc(): "..tostring(p));
							end
						end
					else
						if cnfunc then
							local t,p = pcall(cnfunc, k, v, ck, cv, toc, tcc);
							if not(t) then
								cwAPI.util.log("ForEachFrame Err cnfunc(): "..tostring(p));
							end
						end
					end
				else
					if cnefunc then
						local t,p = pcall(cnefunc, k, v, ck, cv, toc, tcc);
						if not(t) then
							cwAPI.util.log("ForEachFrame Err cnefunc(): "..tostring(p));
						end
					end
				end
			end
		end
	end
end


function extui.listframes()

	if not(extui.isSetting) then
		extui.SavePositions();
	end

	extui.framepos = cwAPI.json.load("extendedui")["frames"];

	EXTENDEDUI_LOAD_POSITIONS(nil,"GAME_START");
	cwAPI.util.log("Reloaded UI");
end

function extui.reload()
	extui.framepos = cwAPI.json.load("extendedui")["frames"];
	EXTENDEDUI_LOAD_POSITIONS(nil,"GAME_START");
end

function EXTENDEDUI_ON_RELOADUI()
	extui.isReload = true;
	extui.oldSlider = {};
	extui.framepos = cwAPI.json.load("extendedui")["frames"];
	EXTENDEDUI_LOAD_POSITIONS(nil,"GAME_START");
	extui.UpdateSliders();
	cwAPI.util.log("Reloaded UI");
	extui.isReload = false;
end

function EXTENDEDUI_ON_RESTORE_R()
	extui.isReload = true;


	extui.ForEachFrame(function(k,v,toc)
							extui.framepos[tostring(k)].x = extui.defaultFrames[tostring(k)].x;
							extui.framepos[tostring(k)].y = extui.defaultFrames[tostring(k)].y;
							toc:MoveFrame(extui.framepos[tostring(k)].x, extui.framepos[tostring(k)].y);
							if not(v.noResize) then
								extui.framepos[tostring(k)].w = extui.defaultFrames[tostring(k)].w;
								extui.framepos[tostring(k)].h = extui.defaultFrames[tostring(k)].h;
								toc:Resize(extui.framepos[tostring(k)].w, extui.framepos[tostring(k)].h);
							end
						end,
						nil, nil, nil,
						function(k, v, ck, cv, toc, tcc)
							extui.framepos[tostring(k)]["child"][tostring(ck)].x = extui.defaultFrames[tostring(k)]["child"][tostring(ck)].x;
							extui.framepos[tostring(k)]["child"][tostring(ck)].y = extui.defaultFrames[tostring(k)]["child"][tostring(ck)].y;
							tcc:SetOffset(extui.framepos[tostring(k)]["child"][tostring(ck)].x, extui.framepos[tostring(k)]["child"][tostring(ck)].y);
						end,
						nil);

	extui.SavePositions();
	extui.UpdateSliders();
	extui.isReload = false;
end

function EXTENDEDUI_ON_RESTORE()
	ui.MsgBox("Are you sure you want to reset{nl}all frames to their default positions?","EXTENDEDUI_ON_RESTORE_R","Nope");
end

function EXTENDEDUI_ON_SAVE()
	extui.SavePositions();
end

function EXTENDEDUI_ON_DRAGGING(frame)
	if extui.closingSettings then
		return 0;
	end
	
	local x = frame:GetX();
	local y = frame:GetY();
	local isFrame = frame:GetUserValue("FRAME_NAME");
	local mFrame = ui.GetFrame(isFrame);
	
	if mFrame ~= nil then
		local xs = mFrame:GetX();
		local ys = mFrame:GetY();
		local doMove = false;
		if x ~= xs then
			doMove = true;
		end
		if y ~= ys then
			doMove = true;
		end
		
		if doMove then
			mFrame:MoveFrame(x,y);
			extui.framepos[tostring(isFrame)]["x"] = x;
			extui.framepos[tostring(isFrame)]["y"] = y;

			--move the childs
			if extui.frames[isFrame].hasChild then
				for ch,v in pairs(extui.frames[isFrame]["child"]) do
					local chfrm = ui.GetFrame("extuiframectrls"..isFrame..ch);

					local ssc = mFrame:GetChild(ch);
					local xc = ssc:GetX();
					local yc = ssc:GetY();

					chfrm:SetOffset(x+xc, y+yc);

					if isFrame == "buff" or isFrame == "targetbuff" then
						extui.MoveBuffCaption(isFrame, ch);
					end
				end
			end
			extui.UpdateSliders();
		end
	end
	return 1;
end

function EXTENDEDUI_VOID()
end

function EXTENDEDUI_ON_DRAGGING_CHILD(frame)
	if extui.closingSettings then
		return 0;
	end
	
	local x = frame:GetX();
	local y = frame:GetY();
	local isFrame = frame:GetUserValue("FRAME_NAME");
	local isChild = frame:GetUserValue("CHILD_NAME");
	local mFrame = ui.GetFrame(isFrame);
	
	if mFrame ~= nil then
		local cFrame = mFrame:GetChild(isChild);

		if cFrame ~= nil then

			local xs = mFrame:GetX();
			local ys = mFrame:GetY();
			local xc = cFrame:GetX();
			local yc = cFrame:GetY();

			local doMove = false;
			if x ~= xs+xc then
				doMove = true;
			end
			if y ~= ys+yc then
				doMove = true;
			end
			
			if doMove then
				cFrame:SetOffset(x-xs,y-ys);
				extui.framepos[tostring(isFrame)]["child"][isChild]["x"] = x-xs;
				extui.framepos[tostring(isFrame)]["child"][isChild]["y"] = y-ys;

				extui.UpdateSliders();

				if isFrame == "buff" or isFrame == "targetbuff" then
					extui.MoveBuffCaption(isFrame, isChild);
				end
			end
		end
	end
	return 1;
end

function EXTENDEDUI_ON_DRAG_START_END()
	extui.IsDragging = not(extui.IsDragging);
end

extui.showAll = false;
--TODO: Needs to use ForEachFrame
function topcall(frame, ctrl, argStr)
	if argStr == "*all" then
		if not(extui.showAll) then
			for k,v in pairs(extui.frames) do
				if v.isMovable then
					local ss = ui.GetFrame(k);

					local w = ss:GetWidth();
					local h = ss:GetHeight();
					local x = ss:GetX();
					local y = ss:GetY();

					local frm = ui.CreateNewFrame("extendedui", "extuiframectrls"..k);
					frm:Resize(w , h);
					frm:MoveFrame(x, y);
					frm:RunUpdateScript("EXTENDEDUI_ON_DRAGGING");
					frm:SetEventScript(ui.LBUTTONDOWN, "EXTENDEDUI_ON_DRAG_START_END");
					frm:SetEventScript(ui.LBUTTONUP, "EXTENDEDUI_ON_DRAG_START_END");
					frm:SetUserValue("FRAME_NAME", k);

					if extui.frames[k].hasChild then
						for ch,_v in pairs(extui.frames[k]["child"]) do
							local chfrm = ui.CreateNewFrame("extendedui", "extuiframectrls"..k..ch);
							local ssc = ss:GetChild(ch);

							local wc = ssc:GetWidth();
							local hc = ssc:GetHeight();
							local xc = ssc:GetX();
							local yc = ssc:GetY();

							chfrm:Resize(wc , hc);
							chfrm:SetOffset(x+xc, y+yc);
							chfrm:SetUserValue("FRAME_NAME", k);
							chfrm:SetUserValue("CHILD_NAME", ch);
							chfrm:RunUpdateScript("EXTENDEDUI_ON_DRAGGING_CHILD");
							chfrm:SetEventScript(ui.LBUTTONDOWN, "EXTENDEDUI_ON_DRAG_START_END");
							chfrm:SetEventScript(ui.LBUTTONUP, "EXTENDEDUI_ON_DRAG_START_END");
							chfrm = tolua.cast(chfrm, "ui::CRichText");
							chfrm:SetColorTone("FF00FF00");
						end
					end
					
					extui.frames[k].show = true;
				end
			end
			extui.showAll = true;
		else
			for k,v in pairs(extui.frames) do
				if v.isMovable and v.show then
					local tocc = ui.GetFrame("extuiframectrls"..tostring(k));
					if tocc ~= nil then
						tocc:ShowWindow(0);
						if extui.frames[k].hasChild then
							for ch,v in pairs(extui.frames[k]["child"]) do
								 ui.GetFrame("extuiframectrls"..k..ch):ShowWindow(0);
							end
						end
					end
					v.show = false;
				end
			end
			extui.showAll = false;
		end
	else
		if not(extui.frames[argStr].show) then
			local ss = ui.GetFrame(argStr);

			local w = ss:GetWidth();
			local h = ss:GetHeight();
			local x = ss:GetX();
			local y = ss:GetY();

			local frm = ui.CreateNewFrame("extendedui", "extuiframectrls"..argStr);
			frm:Resize(w , h);
			frm:MoveFrame(x, y);
			frm:RunUpdateScript("EXTENDEDUI_ON_DRAGGING");
			frm:SetEventScript(ui.LBUTTONDOWN, "EXTENDEDUI_ON_DRAG_START_END");
			frm:SetEventScript(ui.LBUTTONUP, "EXTENDEDUI_ON_DRAG_START_END");
			frm:SetUserValue("FRAME_NAME", argStr);

			if extui.frames[argStr].hasChild then
				for ch,v in pairs(extui.frames[argStr]["child"]) do
					local chfrm = ui.CreateNewFrame("extendedui", "extuiframectrls"..argStr..ch);
					local ssc = ss:GetChild(ch);

					local wc = ssc:GetWidth();
					local hc = ssc:GetHeight();
					local xc = ssc:GetX();
					local yc = ssc:GetY();

					chfrm:Resize(wc , hc);
					chfrm:SetOffset(x+xc, y+yc);
					chfrm:SetUserValue("FRAME_NAME", argStr);
					chfrm:SetUserValue("CHILD_NAME", ch);
					chfrm:RunUpdateScript("EXTENDEDUI_ON_DRAGGING_CHILD");
					chfrm:SetEventScript(ui.LBUTTONDOWN, "EXTENDEDUI_ON_DRAG_START_END");
					chfrm:SetEventScript(ui.LBUTTONUP, "EXTENDEDUI_ON_DRAG_START_END");
					chfrm = tolua.cast(chfrm, "ui::CRichText");
					chfrm:SetColorTone("FF00FF00");
				end
			end
			
			extui.frames[argStr].show = true;
		else
			local tocc = ui.GetFrame("extuiframectrls"..argStr);
			if tocc ~= nil then
				tocc:ShowWindow(0);
				if extui.frames[argStr].hasChild then
					for ch,v in pairs(extui.frames[argStr]["child"]) do
						ui.GetFrame("extuiframectrls"..argStr..ch):ShowWindow(0);
					end
				end
			end
			extui.frames[argStr].show = false;
		end
	end
end

function EXTENDEDUI_ON_BUTTON_FRAME_PRESS(frame, ctrl, argStr)
	local t,p = pcall(topcall, frame, ctrl, argStr);
	if not(t) then
		cwAPI.util.log(tostring(p));
	end
end

function EXTENDEDUI_ON_CHECK_HIDE(frame, ctrl, argStr)
	local frm = ui.GetFrame(argStr);
	frm:ShowWindowToggle();
end


function EXTENDEDUI_LOAD_POSITIONS(_frame, msg)
	local hasNew = false;

	if not(msg == "TAKE_DAMAGE" or msg == "TAKE_HEAL") then

		extui.ForEachFrame(
			function(k,v,toc)
				local x = extui.framepos[tostring(k)].x;
				local y = extui.framepos[tostring(k)].y;
				local w = extui.framepos[tostring(k)].w;
				local h = extui.framepos[tostring(k)].h;

				local xs = toc:GetX() or 0;
				local ys = toc:GetY() or 0;
				local ws = toc:GetWidth() or 0;
				local hs = toc:GetHeight() or 0;
				
				toc:MoveFrame(x, y);
				if not(v.noResize) then
					toc:Resize(w, h);
				end

				if not(extui.firstStart) then
					extui.defaultFrames[tostring(k)] = {};
					extui.defaultFrames[tostring(k)]["x"] = xs;
					extui.defaultFrames[tostring(k)]["y"] = ys;
					extui.defaultFrames[tostring(k)]["w"] = ws;
					extui.defaultFrames[tostring(k)]["h"] = hs;
					if v.hasChild then
						extui.defaultFrames[tostring(k)]["child"] = {};
					end
				end

				if v.saveHidden then
					toc:ShowWindow(extui.framepos[tostring(k)].hidden or toc:IsVisible());
					extui.framepos[tostring(k)]["hidden"] = toc:IsVisible();
				end
			end,
			function(k,v,toc)
				local x = toc:GetX() or 0;
				local y = toc:GetY() or 0;
				local w = toc:GetWidth() or 0;
				local h = toc:GetHeight() or 0;
				extui.framepos[tostring(k)] = {};
				extui.framepos[tostring(k)]["x"] = x;
				extui.framepos[tostring(k)]["y"] = y;
				extui.framepos[tostring(k)]["w"] = w;
				extui.framepos[tostring(k)]["h"] = h;

				if not(extui.firstStart) then
					extui.defaultFrames[tostring(k)] = extui.framepos[tostring(k)];
				end

				hasNew = true;
				if v.hasChild then
					extui.framepos[tostring(k)]["child"] = {};
				end
				if v.saveHidden then
					extui.framepos[tostring(k)]["hidden"] = toc:IsVisible();
				end
			end,
			function(k,v)
				if extui.framepos[tostring(k)] == nil then
					extui.framepos[tostring(k)] = {};
					if v.hasChild then
						extui.framepos[tostring(k)]["child"] = {};
					end
				end
			end,
			function(k,v,ck,cv,toc,tcc)
				local x = tcc:GetX() or 0;
				local y = tcc:GetY() or 0;
				extui.framepos[tostring(k)]["child"][tostring(ck)] = {};
				extui.framepos[tostring(k)]["child"][tostring(ck)]["x"] = x;
				extui.framepos[tostring(k)]["child"][tostring(ck)]["y"] = y;

				if not(extui.firstStart) then
					extui.defaultFrames[tostring(k)]["child"][tostring(ck)] = extui.framepos[tostring(k)]["child"][tostring(ck)];
				end
				hasNew = true;
			end,
			function(k,v,ck,cv,toc,tcc)
				local x = extui.framepos[tostring(k)]["child"][tostring(ck)].x;
				local y = extui.framepos[tostring(k)]["child"][tostring(ck)].y;

				local xs = tcc:GetX() or 0;
				local ys = tcc:GetY() or 0;

				if not(extui.firstStart) then
					extui.defaultFrames[tostring(k)]["child"][tostring(ck)] = {};
					extui.defaultFrames[tostring(k)]["child"][tostring(ck)].x = xs;
					extui.defaultFrames[tostring(k)]["child"][tostring(ck)].y = ys;
				end


				tcc:SetOffset(x, y);

				if k == "buff" or k == "targetbuff" then
					extui.MoveBuffCaption(k, ck);
				end

			end,
			function(k,v,ck,cv,toc,tcc)
				if extui.framepos[tostring(k)]["child"][tostring(ck)] == nil then
					extui.framepos[tostring(k)]["child"][tostring(ck)] = {};
				end
			end
		);
		end

	if hasNew then
		extui.SavePositions();
	end

	extui.firstStart = true;

end

function extui.SavePositions()
	
	for k,v in pairs(extui.lSettingsUI) do
		if extui.ldSettingsUI[tostring(k)] ~= nil then
			extui.ldSettingsUI[tostring(k)] = v.val;
		end
	end
	
	local tosave = {
		["settings"] = extui.ldSettingsUI,
		["frames"] = extui.framepos,
	};


	local s, bl = pcall(cwAPI.json.save, tosave, "extendedui");
	if not(s) then
		cwAPI.util.log("JSON ERROR: "..bl);
	end
end

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


-- UI

function extui.openside()
	extui.oldSlider = {};

	local t,p = pcall(extui.InitSideFrame);
	if not(t) then
		cwAPI.util.log(tostring(p));
	end


	if extui.sideFrame then
		extui.closingSettings = false;
		extui.isSetting = true;
	end
end

function extui.close()
	if extui.sideFrame then
		extui.closingSettings = true;
		--we want to close all the frame borders as well
		for k,v in pairs(extui.frames) do
			if v.isMovable and v.show then
				ui.GetFrame("extuiframectrls"..tostring(k)):ShowWindow(0);
				if extui.frames[k].hasChild then
					for ch,v in pairs(extui.frames[k]["child"]) do
						 ui.GetFrame("extuiframectrls"..k..ch):ShowWindow(0);
					end
				end
				v.show = false;
			end
		end
		
		local frm = ui.GetFrame("EXTENDEDUI_SIDE_FRAME");
		extui.reload();
		frm:ShowWindow(0);
		extui.isSetting = false;
		extui.showAll = false;
	end
end


function extui.UpdateSliders()
	local uibox = GET_CHILD(extui.sideFrame, "extuibox", "ui::CGroupBox");

	extui.ForEachFrame(
		function(k,v,toc)
			local textX = GET_CHILD(uibox,"extuitxtccp"..tostring(k),"ui::CRichText");
			local textY = GET_CHILD(uibox,"extuitxtccsp"..tostring(k),"ui::CRichText");
			local sliderX = GET_CHILD(uibox,"extuislidex"..tostring(k),"ui::CSlideBar");
			local sliderY = GET_CHILD(uibox,"extuislidey"..tostring(k),"ui::CSlideBar");
			
			local xs = extui.framepos[tostring(k)].x;
			local ys = extui.framepos[tostring(k)].y;
			
			sliderX:SetLevel(xs);
			sliderY:SetLevel(ys);
			
			textX:SetText("{@st42b}"..round(xs).."{/}");
			textY:SetText("{@st42b}"..round(ys).."{/}");

			--local toc = ui.GetFrame(k)
			local isVisibleCheck = GET_CHILD(uibox,"extuictbuthh"..tostring(k),"ui::CCheckBox");
			isVisibleCheck:SetCheck(toc:IsVisible());
			
			if not(v.noResize) then
				local textW = GET_CHILD(uibox,"extuitxtcw"..tostring(k),"ui::CRichText");
				local textH = GET_CHILD(uibox,"extuitxtch"..tostring(k),"ui::CRichText");
				local sliderW = GET_CHILD(uibox,"extuislidew"..tostring(k),"ui::CSlideBar");
				local sliderH = GET_CHILD(uibox,"extuislideh"..tostring(k),"ui::CSlideBar");
				
				local ws = extui.framepos[tostring(k)].w;
				local hs = extui.framepos[tostring(k)].h;

				sliderW:SetLevel(ws);
				sliderH:SetLevel(hs);

				textW:SetText("{@st42b}"..round(ws).."{/}");
				textH:SetText("{@st42b}"..round(hs).."{/}");
			end
		end,
		nil,nil,nil,
		function(k, v, ck, cv, toc, tcc)
			local textX = GET_CHILD(uibox,"extuitxtccp"..tostring(k)..tostring(ck),"ui::CRichText");
			local textY = GET_CHILD(uibox,"extuitxtccfp"..tostring(k)..tostring(ck),"ui::CRichText");
			local sliderX = GET_CHILD(uibox,"extuislidex"..tostring(k)..tostring(ck),"ui::CSlideBar");
			local sliderY = GET_CHILD(uibox,"extuislidey"..tostring(k)..tostring(ck),"ui::CSlideBar");
			
			local xs = extui.framepos[tostring(k)]["child"][tostring(ck)].x;
			local ys = extui.framepos[tostring(k)]["child"][tostring(ck)].y;
			
			sliderX:SetLevel(xs);
			sliderY:SetLevel(ys);
			
			textX:SetText("{@st42b}"..round(xs).."{/}");
			textY:SetText("{@st42b}"..round(ys).."{/}");
		end);
end

--TODO: Needs to use ForEachFrame
function EXTUI_ON_SLIDE()
	if extui.isReload or extui.IsDragging then return 1; end
	if extui.isSetting then
		
		local uibox = GET_CHILD(extui.sideFrame, "extuibox", "ui::CGroupBox");
	
		for k,v in pairs(extui.frames) do
			if v.isMovable then
				if extui.framepos[tostring(k)] ~= nil then
					local textX = GET_CHILD(uibox,"extuitxtccp"..tostring(k),"ui::CRichText");
					local textY = GET_CHILD(uibox,"extuitxtccsp"..tostring(k),"ui::CRichText");
					local sliderX = GET_CHILD(uibox,"extuislidex"..tostring(k),"ui::CSlideBar");
					local sliderY = GET_CHILD(uibox,"extuislidey"..tostring(k),"ui::CSlideBar");
					
					local x = sliderX:GetLevel();
					local y = sliderY:GetLevel();
					textX:SetText("{@st42b}"..round(x).."{/}");
					textY:SetText("{@st42b}"..round(y).."{/}");

					local toc = ui.GetFrame(k)
					local doMove = false;

					if toc:GetX() ~= sliderX:GetLevel() then
						doMove = true;
					elseif toc:GetY() ~= sliderY:GetLevel() then
						doMove = true;
					end
					
					local doResize = false;
					
					if not(v.noResize) then
						local textW = GET_CHILD(uibox,"extuitxtcw"..tostring(k),"ui::CRichText");
						local textH = GET_CHILD(uibox,"extuitxtch"..tostring(k),"ui::CRichText");
						local sliderW = GET_CHILD(uibox,"extuislidew"..tostring(k),"ui::CSlideBar");
						local sliderH = GET_CHILD(uibox,"extuislideh"..tostring(k),"ui::CSlideBar");
						
						local w = sliderW:GetLevel();
						local h = sliderH:GetLevel();

						textW:SetText("{@st42b}"..round(w).."{/}");
						textH:SetText("{@st42b}"..round(h).."{/}");
						
						if toc:GetWidth() ~= sliderW:GetLevel() then
							doResize = true;
						elseif toc:GetHeight() ~= sliderH:GetLevel() then
							doResize = true;
						end

						if doResize then
							local toc = ui.GetFrame(k);
							toc:Resize(w,h);
							
							local tcc = ui.GetFrame("extuiframectrls"..tostring(k));
							if tcc ~= nil then
								tcc:Resize(w, h);
							end
							extui.framepos[tostring(k)]["w"] = w;
							extui.framepos[tostring(k)]["h"] = h;
						end
					end

					local isVisibleCheck = GET_CHILD(uibox,"extuictbuthh"..tostring(k),"ui::CCheckBox");
					isVisibleCheck:SetCheck(toc:IsVisible());
					if v.saveHidden then
						extui.framepos[tostring(k)]["hidden"] = toc:IsVisible();
					end
					
					if doMove then
						toc:MoveFrame(x, y);
						local tcc = ui.GetFrame("extuiframectrls"..tostring(k));
						if tcc ~= nil then
							tcc:MoveFrame(x, y);
						end
						extui.framepos[tostring(k)]["x"] = x;
						extui.framepos[tostring(k)]["y"] = y;
					end
				end
			end
			
			if v.hasChild then
				for ck,cv in pairs(v.child) do
					if cv.isMovable then
						if extui.framepos[tostring(k)]["child"][tostring(ck)] ~= nil then
							local textX = GET_CHILD(uibox,"extuitxtccp"..tostring(k)..tostring(ck),"ui::CRichText");
							local textY = GET_CHILD(uibox,"extuitxtccfp"..tostring(k)..tostring(ck),"ui::CRichText");
							local sliderX = GET_CHILD(uibox,"extuislidex"..tostring(k)..tostring(ck),"ui::CSlideBar");
							local sliderY = GET_CHILD(uibox,"extuislidey"..tostring(k)..tostring(ck),"ui::CSlideBar");
							
							local toc = ui.GetFrame(k);
							local tcc = toc:GetChild(ck);
							
							local x = sliderX:GetLevel();
							local y = sliderY:GetLevel();
							
							textX:SetText("{@st42b}"..round(x).."{/}");
							textY:SetText("{@st42b}"..round(y).."{/}");
							
							local doMove = false;

							if extui.GetSetting("confine") then
								if toc:GetWidth() ~= sliderX:GetMaxLevel() then
									sliderX:SetMaxSlideLevel(toc:GetWidth()-tcc:GetWidth());
									sliderX:SetMinSlideLevel(0);
								end
								if toc:GetHeight() ~= sliderY:GetMaxLevel() then
									sliderY:SetMaxSlideLevel(toc:GetHeight()-tcc:GetHeight());
									sliderY:SetMinSlideLevel(0);
								end
							else
								if toc:GetWidth() ~= sliderX:GetMaxLevel() or toc:GetHeight() ~= sliderY:GetMaxLevel() then
									sliderX:SetMaxSlideLevel(ui.GetClientInitialWidth());
									sliderX:SetMinSlideLevel(-ui.GetClientInitialWidth());
									sliderY:SetMaxSlideLevel(ui.GetClientInitialHeight());
									sliderY:SetMinSlideLevel(-ui.GetClientInitialHeight());
								end
							end
							

							if tcc:GetX() ~= sliderX:GetLevel() then
								doMove = true;
							elseif tcc:GetY() ~= sliderY:GetLevel() then
								doMove = true;
							end

							if doMove then
								tcc:SetOffset(x, y);
								extui.framepos[tostring(k)]["child"][tostring(ck)]["x"] = x;
								extui.framepos[tostring(k)]["child"][tostring(ck)]["y"] = y;

								local ssc = ui.GetFrame("extuiframectrls"..k..ck);
								if ssc ~= nil then
									ssc:SetOffset(toc:GetX()+x, toc:GetY()+y);
								end

								if k == "buff" or k == "targetbuff" then
									extui.MoveBuffCaption(k, ck);
								end
							end
						end
					end
				end
			end
		end
	end

	return 1;
end

function EXTUI_ON_TAB_CHANGE(frame, ctrl, argStr, argNum)
	local tabObj		    = frame:GetChild("extuitabs");
	local itembox_tab		= tolua.cast(tabObj, "ui::CTabControl");
	local curtabIndex	    = itembox_tab:GetSelectItemIndex();
	
	if curtabIndex == 0 then
		frame:GetChild("extuibox"):ShowWindow(0);
		frame:GetChild("extuiboxs"):ShowWindow(1);
	elseif curtabIndex == 1 then
		frame:GetChild("extuibox"):ShowWindow(1);
		frame:GetChild("extuiboxs"):ShowWindow(0);
	end
end


--TODO: Needs to use ForEachFrame
function extui.InitSideFrame()
	if extui.isSetting then
		if ui.GetFrame("EXTENDEDUI_SIDE_FRAME") ~= nil then
			return;
		else
			extui.isSetting = false;
		end
	end

	local frm = ui.CreateNewFrame("extendedui", "EXTENDEDUI_SIDE_FRAME");
	frm:Resize(800 , 600);
	frm:MoveFrame((ui.GetSceneWidth()/2)-400, (ui.GetSceneHeight()/2)-300);
	frm:SetSkinName("mainwindow2");


	local ctrl = frm
	ctrl = tolua.cast(ctrl, "ui::CFrame");

	local nctrl = frm:CreateOrGetControl("richtext", "extuititlet", 290, 25, 300, 30);
	nctrl = tolua.cast(nctrl, "ui::CRichText");
	nctrl:SetText("{@st43}ExtendedUI Settings{/}");
	
	--tabs
	local ctab = ctrl:CreateOrGetControl("tab", "extuitabs", 50, 90, 740, 30);
	ctab = tolua.cast(ctab, "ui::CTabControl");
	ctab:SetEventScript(ui.LBUTTONDOWN, "EXTUI_ON_TAB_CHANGE");
	ctab:AddItem("{@st66b}    Settings    {/}"); --yay hacks
	ctab:AddItem("{@st66b}     Frames     {/}");
	ctab:SetClickSound("button_click_big");
	ctab:SetOverSound("button_over");
	ctab:SetSkinName("tab2");


	--settings box
	local cbox = ctrl:CreateOrGetControl("groupbox", "extuiboxs", 30, 120, 740, 430);
	cbox = tolua.cast(cbox, "ui::CGroupBox");
	cbox:SetSkinName("bg2");
	
	local ctrls = nil;
	local inx = 20;
	local iny = 20;
	local _settings = extui.GetSettings();
	local iii = 1;
	for k,v in spairs(_settings, function(t,a,b) return t[b].order > t[a].order end) do
		local typedata = v.typedata;
		local ctrltype = typedata.t;
		local ctrla = typedata.a;
		local value = v.val;
		local name = v.name;
		local tool = v.tool;
		local oncall = v.oncall;
		local oncreate = v.oncreate;
		local isDisabled = v.disabled;
		
		
		if ctrla ~= "newline" then
			ctrls = cbox:CreateOrGetControl(ctrla, "extuitctrl"..tostring(k), inx, iny, 150, 30);
		end
		if ctrltype then
			ctrls = tolua.cast(ctrls, ctrltype);
		end

		if tool ~= nil and tool ~= "" then
			ctrls:SetTextTooltip(string.format("{@st42b}"..tool.."{/}"));
		end

		if ctrla == "checkbox" then
			ctrls:SetText("{@st42b}"..tostring(name).."{/}");
			ctrls:SetEventScript(oncall, "EXTENDEDUI_ON_SETTINGS_PRESS");
			ctrls:SetEventScriptArgString(oncall, tostring(k));
			ctrls:SetCheck(value==true and 1 or 0);
			ctrls:SetClickSound("button_click_big");
			ctrls:SetOverSound("button_over");

			if isDisabled then
				ctrls:SetEventScript(oncall, "EXTENDEDUI_VOID");
			end

		elseif ctrla == "slidebar" then
			ctrls:SetMaxSlideLevel(v.max);
			ctrls:SetMinSlideLevel(0);
			ctrls:SetLevel(value);
			ctrls:Resize(300,30);
			ctrls:RunUpdateScript("EXTENDEDUI_ON_SETTINGS_SLIDE");

			local ctrlst = cbox:CreateOrGetControl("richtext", "extuitctrlst"..tostring(k), inx, iny-12, 150, 30);
			ctrlst = tolua.cast(ctrlst, "ui::CRichText");
			ctrlst:SetText("{@st42b}"..tostring(name).."{/}");

			if isDisabled then
				ctrlst:SetColorTone("FF444444");
				ctrls:RunUpdateScript("EXTENDEDUI_VOID");
			end

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

	
	--frame box
	cbox = ctrl:CreateOrGetControl("groupbox", "extuibox", 30, 120, 740, 430);
	cbox = tolua.cast(cbox, "ui::CGroupBox");
	cbox:SetSkinName("bg2");


	--lots of slidersssss yaaay!
	ctrls = nil;
	inx = 10;
	iny = 10;


	ctrls = cbox:CreateOrGetControl("richtext", "extuitxtll"..tostring(k), inx, iny, 300, 30);
	ctrls = tolua.cast(ctrls, "ui::CRichText");
	ctrls:SetText("{@st43}All Frames{/}");
	iny = iny+35;
	ctrls = cbox:CreateOrGetControl("checkbox", "extuictbut"..tostring(k), inx+10, iny, 150, 30);
	ctrls = tolua.cast(ctrls, "ui::CCheckBox");
	ctrls:SetText("{@st42b}Show Frame Area{/}");
	ctrls:SetClickSound("button_click_big");
	ctrls:SetOverSound("button_over");
	ctrls:SetEventScript(ui.LBUTTONUP, "EXTENDEDUI_ON_BUTTON_FRAME_PRESS");
	ctrls:SetEventScriptArgString(ui.LBUTTONUP, "*all");


	iny = iny+35;
	ctrls = cbox:CreateOrGetControl("labelline", "extuitline"..tostring(k), inx+5, iny+10, 700, 1);
	iny = iny+35;

	for k,v in pairs(extui.frames) do
		inx = 10;
		toc = ui.GetFrame(k);
		
		if v.isMovable then
			if extui.framepos[tostring(k)] ~= nil then
				
				ctrls = cbox:CreateOrGetControl("richtext", "extuitxtll"..tostring(k), inx, iny, 300, 30);
				ctrls = tolua.cast(ctrls, "ui::CRichText");
				ctrls:SetText("{@st43}"..tostring(v.name).."{/}");
				
				iny = iny+35;
			
				
				local x = extui.framepos[tostring(k)].x;
				local y = extui.framepos[tostring(k)].y;
				local w = extui.framepos[tostring(k)].w;
				local h = extui.framepos[tostring(k)].h;
				
				ctrls = cbox:CreateOrGetControl("richtext", "extuitxtfff"..tostring(k), inx, iny, 300, 30);
				ctrls = tolua.cast(ctrls, "ui::CRichText");
				ctrls:SetText("{@st42b}Position{/}");
				
				iny = iny+10;
				
				ctrls = cbox:CreateOrGetControl("richtext", "extuitxtx"..tostring(k), inx, iny+5, 300, 30);
				ctrls = tolua.cast(ctrls, "ui::CRichText");
				ctrls:SetText("{@st42b}x{/}");
				
				ctrls = cbox:CreateOrGetControl("slidebar", "extuislidex"..tostring(k), inx+12, iny, 300, 30);
				ctrls = tolua.cast(ctrls, "ui::CSlideBar");
				ctrls:SetMaxSlideLevel(ui.GetClientInitialWidth());
				ctrls:SetMinSlideLevel(0);
				ctrls:SetLevel(x);
				
				ctrls = cbox:CreateOrGetControl("richtext", "extuitxtccp"..tostring(k), inx+295, iny+5, 300, 30);
				ctrls = tolua.cast(ctrls, "ui::CRichText");
				ctrls:SetText("{@st42b}"..round(x).."{/}");


				iny = iny+35;
				
				ctrls = cbox:CreateOrGetControl("richtext", "extuitxty"..tostring(k), inx, iny+5, 300, 30);
				ctrls = tolua.cast(ctrls, "ui::CRichText");
				ctrls:SetText("{@st42b}y{/}");
				
				ctrls = cbox:CreateOrGetControl("slidebar", "extuislidey"..tostring(k), inx+12, iny, 300, 30);
				ctrls = tolua.cast(ctrls, "ui::CSlideBar");
				ctrls:SetMaxSlideLevel(ui.GetClientInitialHeight());
				ctrls:SetMinSlideLevel(0);
				ctrls:SetLevel(y);
				
				ctrls = cbox:CreateOrGetControl("richtext", "extuitxtccsp"..tostring(k), inx+295, iny+5, 300, 30);
				ctrls = tolua.cast(ctrls, "ui::CRichText");
				ctrls:SetText("{@st42b}"..round(y).."{/}");
				
				iny = iny+35;
				
				if not(v.noResize) then
					ctrls = cbox:CreateOrGetControl("richtext", "extuitxtff"..tostring(k), inx, iny, 300, 30);
					ctrls = tolua.cast(ctrls, "ui::CRichText");
					ctrls:SetText("{@st42b}Size{/}");
					
					iny = iny+10;
					
					ctrls = cbox:CreateOrGetControl("richtext", "extuitxtw"..tostring(k), inx, iny+5, 300, 30);
					ctrls = tolua.cast(ctrls, "ui::CRichText");
					ctrls:SetText("{@st42b}w{/}");
					
					ctrls = cbox:CreateOrGetControl("slidebar", "extuislidew"..tostring(k), inx+12, iny, 300, 30);
					ctrls = tolua.cast(ctrls, "ui::CSlideBar");
					ctrls:SetMaxSlideLevel(ui.GetClientInitialWidth());
					ctrls:SetMinSlideLevel(0);
					ctrls:SetLevel(w);
					
					ctrls = cbox:CreateOrGetControl("richtext", "extuitxtcw"..tostring(k), inx+295, iny+5, 300, 30);
					ctrls = tolua.cast(ctrls, "ui::CRichText");
					ctrls:SetText("{@st42b}"..round(w).."{/}");
					
					iny = iny+35;
					
					ctrls = cbox:CreateOrGetControl("richtext", "extuitxth"..tostring(k), inx, iny+5, 300, 30);
					ctrls = tolua.cast(ctrls, "ui::CRichText");
					ctrls:SetText("{@st42b}h{/}");
					
					ctrls = cbox:CreateOrGetControl("slidebar", "extuislideh"..tostring(k), inx+12, iny, 300, 30);
					ctrls = tolua.cast(ctrls, "ui::CSlideBar");
					ctrls:SetMaxSlideLevel(ui.GetClientInitialHeight());
					ctrls:SetMinSlideLevel(0);
					ctrls:SetLevel(h);
					
					ctrls = cbox:CreateOrGetControl("richtext", "extuitxtch"..tostring(k), inx+295, iny+5, 300, 30);
					ctrls = tolua.cast(ctrls, "ui::CRichText");
					ctrls:SetText("{@st42b}"..round(h).."{/}");
					
					iny = iny+35;
				
				end
				
				ctrls = cbox:CreateOrGetControl("checkbox", "extuictbuthh"..tostring(k), inx+10, iny, 150, 30);
				ctrls = tolua.cast(ctrls, "ui::CCheckBox");
				ctrls:SetText("{@st42b}Show Frame{/}");
				ctrls:SetClickSound("button_click_big");
				ctrls:SetOverSound("button_over");
				ctrls:SetEventScript(ui.LBUTTONUP, "EXTENDEDUI_ON_CHECK_HIDE");
				ctrls:SetEventScriptArgString(ui.LBUTTONUP, tostring(k));
				ctrls:SetCheck(toc:IsVisible());
				
				iny = iny+30;
				
				ctrls = cbox:CreateOrGetControl("checkbox", "extuictbut"..tostring(k), inx+10, iny, 150, 30);
				ctrls = tolua.cast(ctrls, "ui::CCheckBox");
				ctrls:SetText("{@st42b}Show Frame Area{/}");
				ctrls:SetClickSound("button_click_big");
				ctrls:SetOverSound("button_over");
				ctrls:SetEventScript(ui.LBUTTONUP, "EXTENDEDUI_ON_BUTTON_FRAME_PRESS");
				ctrls:SetEventScriptArgString(ui.LBUTTONUP, tostring(k));
			
				iny = iny+35;
			end
		end
		
		if v.hasChild then
			local tcc = nil;
			
			inx = inx+350;
			iny = iny-147;
			if not(v.noResize) then
				iny = iny-80;
			end
			
			for ck,cv in pairs(v.child) do
				tcc = toc:GetChild(tostring(ck));
				
				if cv.isMovable and tcc ~= nil then
					if extui.framepos[tostring(k)]["child"][tostring(ck)] ~= nil then
						local x = extui.framepos[tostring(k)]["child"][tostring(ck)].x;
						local y = extui.framepos[tostring(k)]["child"][tostring(ck)].y;
						local w = tcc:GetWidth();
						local h = tcc:GetHeight();
						
						
						
						ctrls = cbox:CreateOrGetControl("richtext", "extuitxtlccc"..tostring(k)..tostring(ck), inx, iny, 300, 30);
						ctrls = tolua.cast(ctrls, "ui::CRichText");
						ctrls:SetText("{@st42b}"..tostring(cv.name).."{/}");
						
						iny = iny+12;

						
						ctrls = cbox:CreateOrGetControl("richtext", "extuitxtx"..tostring(k)..tostring(ck), inx, iny+5, 300, 30);
						ctrls = tolua.cast(ctrls, "ui::CRichText");
						ctrls:SetText("{@st42b}x{/}");
						
						ctrls = cbox:CreateOrGetControl("slidebar", "extuislidex"..tostring(k)..tostring(ck), inx+12, iny, 300, 30);
						ctrls = tolua.cast(ctrls, "ui::CSlideBar");						
						ctrls:SetMaxSlideLevel(toc:GetWidth()-w);
						ctrls:SetMinSlideLevel(0);
						ctrls:SetLevel(x);
						
						ctrls = cbox:CreateOrGetControl("richtext", "extuitxtccp"..tostring(k)..tostring(ck), inx+295, iny+5, 300, 30);
						ctrls = tolua.cast(ctrls, "ui::CRichText");
						ctrls:SetText("{@st42b}"..round(x).."{/}");
						
						iny = iny+35;
						
						ctrls = cbox:CreateOrGetControl("richtext", "extuitxty"..tostring(k)..tostring(ck), inx, iny+5, 300, 30);
						ctrls = tolua.cast(ctrls, "ui::CRichText");
						ctrls:SetText("{@st42b}y{/}");
						
						ctrls = cbox:CreateOrGetControl("slidebar", "extuislidey"..tostring(k)..tostring(ck), inx+12, iny, 300, 30);
						ctrls = tolua.cast(ctrls, "ui::CSlideBar");
						ctrls:SetMaxSlideLevel(toc:GetHeight()-h);
						ctrls:SetMinSlideLevel(0);
						ctrls:SetLevel(y);
						
						ctrls = cbox:CreateOrGetControl("richtext", "extuitxtccfp"..tostring(k)..tostring(ck), inx+295, iny+5, 300, 30);
						ctrls = tolua.cast(ctrls, "ui::CRichText");
						ctrls:SetText("{@st42b}"..round(y).."{/}");
						
						iny = iny+35;
					end
				end
			end
		end
		if v.hasChild then
			inx=inx-350;
		end
		ctrls = cbox:CreateOrGetControl("labelline", "extuitline"..tostring(k), inx+5, iny+10, 700, 1);
		iny = iny+20;
	end
	
	--buttons
	local ctrls = ctrl:CreateOrGetControl("button", "extuiclbut", 50, 600-45, 150, 30);
	ctrls = tolua.cast(ctrls, "ui::CButton");
	ctrls:SetText("{@st66b}Reload UI{/}");
	ctrls:SetClickSound("button_click_big");
	ctrls:SetOverSound("button_over");
	ctrls:SetEventScript(ui.LBUTTONUP, "EXTENDEDUI_ON_RELOADUI");
	ctrls:SetSkinName("test_pvp_btn");
	
	local ctrls = ctrl:CreateOrGetControl("button", "extuicslbut", 400+15, 600-45, 150, 30);
	ctrls = tolua.cast(ctrls, "ui::CButton");
	ctrls:SetText("{@st66b}Save{/}");
	ctrls:SetClickSound("button_click_big");
	ctrls:SetOverSound("button_over");
	ctrls:SetEventScript(ui.LBUTTONUP, "EXTENDEDUI_ON_SAVE");
	ctrls:SetSkinName("test_pvp_btn");

	local ctrls = ctrl:CreateOrGetControl("button", "extuicslsbut", 400-165, 600-45, 150, 30);
	ctrls = tolua.cast(ctrls, "ui::CButton");
	ctrls:SetText("{@st66b}Restore Defaults{/}");
	ctrls:SetClickSound("button_click_big");
	ctrls:SetOverSound("button_over");
	ctrls:SetEventScript(ui.LBUTTONUP, "EXTENDEDUI_ON_RESTORE");
	ctrls:SetSkinName("test_pvp_btn");
	
	local ctrls = ctrl:CreateOrGetControl("button", "extuicsslbut", 750-150, 600-45, 150, 30);
	ctrls = tolua.cast(ctrls, "ui::CButton");
	ctrls:SetText("{@st66b}Close{/}");
	ctrls:SetClickSound("button_click_big");
	ctrls:SetOverSound("button_over");
	ctrls:SetEventScript(ui.LBUTTONUP, "EXTENDEDUI_ON_CLOSE_UI");
	ctrls:SetSkinName("test_pvp_btn");
	
	ctab:SelectTab(0);
	extui.sideFrame = ctrl;
	
	--doing it this way since we can't access the sliders scp
	extui.sideFrame:RunUpdateScript("EXTUI_ON_SLIDE");
	
	extui.sideFrame:GetChild("extuibox"):ShowWindow(0);
	extui.sideFrame:GetChild("extuiboxs"):ShowWindow(1);

end

function EXTENDEDUI_ON_CLOSE_UI(frame)
	extui.close();
end

function EXTENDEDUI_ON_OPEN_UI()

	extui.openside();
end



function EXTENDEDUI_ON_BUFF()
end


--debuff = 2
--temp = 0
--perm = 1
function extui.MoveBuffCaption(name, slotname)
	local typ = -1;
	local buff_ui = nil;
	if slotname == "debuffslot" then
		typ = 2;
	elseif slotname == "buffslot" then
		typ = 1;
	elseif slotname == "buffcountslot" then
		typ = 0;
	end

	if typ == -1 then return; end

	if name == "buff" then
		buff_ui = s_buff_ui;
	elseif name == "targetbuff" then
		buff_ui = t_buff_ui;
	end

	if buff_ui == nil then return; end

	local clist = buff_ui["captionlist"][typ]
	for k,v in pairs(clist) do
		local slot = buff_ui["slotlist"][typ][k];
		local x = buff_ui["slotsets"][typ]:GetX() + slot:GetX() + buff_ui["txt_x_offset"];
		local y = buff_ui["slotsets"][typ]:GetY() + slot:GetY() + slot:GetHeight() + buff_ui["txt_y_offset"];


		v:SetOffset(x, y);
	end
end


function EXTENDEDUI_ON_GAME()
	cwAPI.commands.register("/reloadui",extui.listframes);
	cwAPI.commands.register("/saveframes",extui.SavePositions);
	cwAPI.commands.register("/uisettings",extui.openside);
	cwAPI.commands.register("/uiclose",extui.close);
	
	extui.LoadSettings();
end

--only runs on first startup since *_ON_INIT gets called on map change etc
if _G["EXTUI_LOADED"] == nil then
	cwAPI.util.log("ExtendedUI Loaded");
	_G["EXTUI_LOADED"] = true;
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
	addon:RegisterMsg("BUFF_ADD", "EXTENDEDUI_ON_BUFF");

	addon:RegisterOpenOnlyMsg("LEVEL_UPDATE", "EXTENDEDUI_ON_CHAR_EXP");
	addon:RegisterMsg("EXP_UPDATE", "EXTENDEDUI_ON_CHAR_EXP");
	addon:RegisterMsg("JOB_EXP_UPDATE", "EXTENDEDUI_ON_JOB_EXP");
	addon:RegisterMsg("JOB_EXP_ADD", "EXTENDEDUI_ON_JOB_EXP");
	addon:RegisterMsg("CHANGE_COUNTRY", "EXTENDEDUI_ON_CHAR_EXP");
	addon:RegisterMsg("ESCAPE_PRESSED", "EXTENDEDUI_ON_CLOSE_UI");


	extui.isSetting = false;


	local file, error = io.open("../addons/extendedui/extendedui.json", "r");
	if file == nil then
		file, error = io.open("../addons/extendedui/extendedui.json", "w");
		if not(error) then
			file:write("{\r\t\"settings\": {\r\t},\r\t\"frames\": {\r\t}\r}");
		    io.close(file);
		end
	else
		io.close(file);
	end

	local s, bl = pcall(cwAPI.json.load,"extendedui");
	if s then
		extui.framepos = bl["frames"];
		extui.ldSettingsUI = bl["settings"];
	else
		cwAPI.util.log("JSON ERROR: "..bl);
	end

	
	s, bl = pcall(EXTENDEDUI_ON_GAME);
	if not(s) then
		cwAPI.util.log("all the err"..bl);
	end

	if _G["_PUMP_RECIPE_OPEN_EXTOLD"] == nil then
		_G["_PUMP_RECIPE_OPEN_EXTOLD"] = _G["_PUMP_RECIPE_OPEN"];
		_G["_PUMP_RECIPE_OPEN"] = function(...) 
									if extui.GetSetting("discraft") == false then
										_G["_PUMP_RECIPE_OPEN_EXTOLD"](...);
									end
								end;
	end

	local frame = ui.GetFrame("systemoption")
	local ctrls = frame:CreateOrGetControl("button", "extuiopenbutton", 50, 271, 208, 35);
	ctrls = tolua.cast(ctrls, "ui::CButton");
	ctrls:SetText("{@st66b}ExtendedUI{/}");
	ctrls:SetClickSound("button_click_big");
	ctrls:SetOverSound("button_over");
	ctrls:SetEventScript(ui.LBUTTONUP, "EXTENDEDUI_ON_OPEN_UI");
	ctrls:SetSkinName("test_pvp_btn");


end
