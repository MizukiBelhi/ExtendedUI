--ExtendedUI Frame Handling

if extui == nil then
	extui = {};
end

extui.framepos = {};
extui.defaultFrames = {};
extui.frames = {
		["time"] = {
			["isMovable"] = true,
			["hasChild"] = false,
			["name"] = "Time",
			["noResize"] = true,
			["saveHidden"] = true,
			["noScale"] = true,
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
			["noScale"] = true,
		},
		["minimap"] = {
			["isMovable"] = true,
			["hasChild"] = false,
			["name"] = "Mini Map",
			["noResize"] = true,
			["saveHidden"] = true,
		},
		["chat"] = {
			["isMovable"] = true,
			["hasChild"] = false,
			["name"] = "Chat Input",
			["noResize"] = true,
			["noScale"] = true,
		},
		["playtime"] = {
			["isMovable"] = true,
			["hasChild"] = false,
			["name"] = "Playtime",
			["noResize"] = true,
			["saveHidden"] = true,
			["noScale"] = true,
		},
		["chatframe"] = {
			["isMovable"] = true,
			["hasChild"] = false,
			["name"] = "Chat Window",
			["noResize"] = true,
			["noScale"] = true,
		},
		["charbaseinfo"] = {
			["isMovable"] = true,
			["hasChild"] = false,
			["name"] = "EXP Bars",
			["saveHidden"] = true,
			["noScale"] = true,
		},
		["headsupdisplay"] = {
			["isMovable"] = true,
			["hasChild"] = false,
			["name"] = "Character Status",
			["saveHidden"] = true,
			["noScale"] = true,
		},
		["sysmenu"] = {
			["isMovable"] = true,
			["hasChild"] = false,
			["name"] = "Menu",
			["noResize"] = true,
			["saveHidden"] = true,
			["noScale"] = true,
		},
		["channel"] = {
			["isMovable"] = true,
			["hasChild"] = false,
			["name"] = "Channel",
			["noResize"] = true,
			["saveHidden"] = true,
			["noScale"] = true,
		},
		["partyinfo"] = {
			["isMovable"] = true,
			["hasChild"] = false,
			["name"] = "Party",
			["noResize"] = true,
			["saveHidden"] = true,
		},
		["questinfoset_2"] = {
			["isMovable"] = true,
			["hasChild"] = false,
			["name"] = "Quest Log",
			["noResize"] = true,
			["saveHidden"] = true,
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
			["saveHidden"] = true,
		},
		["openingameshopbtn"] = {
			["isMovable"] = true,
			["hasChild"] = false,
			["name"] = "TP Shop Button",
			["saveHidden"] = true,
			["noScale"] = true,
		},
		["quickslotnexpbar"] = {
			["isMovable"] = true,
			["hasChild"] = false,
			["name"] = "Keyboard/Mouse Quickslot",
			["noResize"] = true,
			["isQuickSlot"] = true,
		},
		["restquickslot"] = {
			["isMovable"] = true,
			["hasChild"] = false,
			["name"] = "Rest Quickslot",
			["noResize"] = true,
			["isQuickSlot"] = true,
		},
		["joystickquickslot"] = {
			["isMovable"] = true,
			["hasChild"] = false,
			["name"] = "Joystick Quickslot",
			["noResize"] = true,
			["isQuickSlot"] = true,
		},
		["joystickrestquickslot"] = {
			["isMovable"] = true,
			["hasChild"] = false,
			["name"] = "Joystick Rest Quickslot",
			["noResize"] = true,
			["isQuickSlot"] = true,
		},
		["ctrltargetui"] = {
			["isMovable"] = true,
			["hasChild"] = false,
			["name"] = "CTRL Target Lock",
			["noResize"] = true,
			["saveHidden"] = true,
		},
		["notice"] = {
			["isMovable"] = true,
			["hasChild"] = false,
			["name"] = "Notice",
			["noResize"] = true,
		},
		["fevorcombo"] = {
			["isMovable"] = true,
			["hasChild"] = false,
			["name"] = "Fever Combo",
			["noResize"] = true,
		},
	};



--Fixes #1
function extui.TargetInfoUpdate(x,y)
	TARGET_INFO_OFFSET_X = x;
	TARGET_INFO_OFFSET_BOSS_X = x+415;
	TARGET_INFO_OFFSET_Y = y;
end

function extui.ScaleUI(scale)

	local newScale = scale/100;

	for k,v in pairs(extui.frames) do
		if v.isMovable and not(k=="buff" or k=="targetbuff") and not(v.noScale) then
			local frm = ui.GetFrame(k);
			if frm ~= nil then
				frm:SetScale(newScale, newScale);

				local cnt = frm:GetChildCount();
				for  i = 0, cnt -1 do
					local ch = frm:GetChildByIndex(i);
					ch:SetScale(newScale, newScale);
				end

			end
		end
	end
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
						extui.print("ForEachFrame Err func(): "..tostring(p));
					end
				end
			else
				if nfunc then
					local t,p = pcall(nfunc, k,v,toc);
					if not(t) then
						extui.print("ForEachFrame Err nfunc(): "..tostring(p));
					end
				end
			end
		else
			if nefunc then
				local t,p = pcall(nefunc, k,v,toc);
				if not(t) then
					extui.print("ForEachFrame Err nefunc(): "..tostring(p));
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
								extui.print("ForEachFrame Err cfunc(): "..tostring(p));
							end
						end
					else
						if cnfunc then
							local t,p = pcall(cnfunc, k, v, ck, cv, toc, tcc);
							if not(t) then
								extui.print("ForEachFrame Err cnfunc(): "..tostring(p));
							end
						end
					end
				else
					if cnefunc then
						local t,p = pcall(cnefunc, k, v, ck, cv, toc, tcc);
						if not(t) then
							extui.print("ForEachFrame Err cnefunc(): "..tostring(p));
						end
					end
				end
			end
		end
	end
end



function EXTENDEDUI_LOAD_POSITIONS(_frame, msg)
	local hasNew = false;

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

			if v.saveHidden then
				toc:ShowWindow(extui.framepos[tostring(k)].hidden, true);
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

			if k=="targetinfo" then
				extui.TargetInfoUpdate(x,y);
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

			if v.saveHidden then
				extui.framepos[tostring(k)]["hidden"] = toc:IsVisible();
			end

			if not(extui.firstStart) then
				extui.defaultFrames[tostring(k)] = extui.framepos[tostring(k)];
			end

			hasNew = true;
			if v.hasChild then
				extui.framepos[tostring(k)]["child"] = {};
			end
		end,
		function(k,v)
			--do nothing, Fix #5
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
				local frm = ui.GetFrame(k);
				local fch = frm:GetChild(ck);

				local slotCount = fch:GetSlotCount();
				fch:Resize(slotCount*extui.GetSetting("iconsize"),extui.GetSetting("iconsize"));
			end

		end,
		function(k,v,ck,cv,toc,tcc)
			--do nothing, Fix #5
		end
	);

	if hasNew then
		extui.SavePositions();
	end

	extui.firstStart = true;

	extui.ScaleUI(extui.GetSetting("uiscale"));

	--re-init buff ui to get more slots!
	extui.INIT_BUFF_UI(ui.GetFrame("buff"), s_buff_ui, "MY_BUFF_TIME_UPDATE");
	INIT_PREMIUM_BUFF_UI(ui.GetFrame("buff"));
	extui.INIT_BUFF_UI(ui.GetFrame("targetbuff"), t_buff_ui, "TARGET_BUFF_UPDATE");

	extui.RemoveJoySetting();
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

	local bslot = ui.GetFrame(name):GetChild(slotname);
	local aslotset = tolua.cast(bslot, 'ui::CSlotSet');

	if extui.GetSetting("extbuff") == true then
		aslotset:SetColRow(30,1);
		aslotset:CreateSlots();
	else
		aslotset:SetColRow(10,1);
	end


	local clist = buff_ui["captionlist"][typ]
	for k,v in pairs(clist) do
		local slot = buff_ui["slotlist"][typ][k];

		local slotsize = extui.GetSetting("iconsize");
		slot:Resize(slotsize,slotsize);
		slot:SetOffset((slotsize*k),slot:GetY());

		local x = buff_ui["slotsets"][typ]:GetX() + slot:GetX() + buff_ui["txt_x_offset"];
		local y = buff_ui["slotsets"][typ]:GetY() + slot:GetY() + slot:GetHeight() + buff_ui["txt_y_offset"];


		v:SetOffset(x, y);
	end
end

--directly taken from lib_uiscp with some minor modifications
function extui.INIT_BUFF_UI(frame, buff_ui, updatescp)

	local slotcountSetPt		= frame:GetChild('buffcountslot');
	local slotSetPt				= frame:GetChild('buffslot');
	local deslotSetPt			= frame:GetChild('debuffslot');

	buff_ui["slotsets"][0]			= tolua.cast(slotcountSetPt, 'ui::CSlotSet');
	buff_ui["slotsets"][1]			= tolua.cast(slotSetPt, 'ui::CSlotSet');
	buff_ui["slotsets"][2]			= tolua.cast(deslotSetPt, 'ui::CSlotSet');

	for i = 0 , buff_ui["buff_group_cnt"] do
	buff_ui["slotcount"][i] = 0;
	--buff_ui["slotlist"][i] = {};
	--buff_ui["captionlist"][i] = {};
		while 1 do
			if buff_ui["slotsets"][i] == nil then
				break;
			end

			local slot = buff_ui["slotsets"][i]:GetSlotByIndex(buff_ui["slotcount"][i]);
			if slot == nil then
				break;
			end

			--we just add new ones
			if buff_ui["slotlist"][i][buff_ui["slotcount"][i]] == nil then
				buff_ui["slotlist"][i][buff_ui["slotcount"][i]] = slot;

				slot:ShowWindow(0);
				local icon = CreateIcon(slot);
				icon:SetDrawCoolTimeText(0);


				local x = buff_ui["slotsets"][i]:GetX() + slot:GetX() + buff_ui["txt_x_offset"];
				local y = buff_ui["slotsets"][i]:GetY() + slot:GetY() + slot:GetHeight() + buff_ui["txt_y_offset"];

				local capt = frame:CreateOrGetControl('richtext', "_t_" .. i .. "_".. buff_ui["slotcount"][i], x, y, 50, 20);

				capt:SetFontName("yellow_13");
				buff_ui["captionlist"][i][buff_ui["slotcount"][i]] = capt;

			end
			buff_ui["slotcount"][i] = buff_ui["slotcount"][i] + 1;
		end

	end

	local timer = frame:GetChild("addontimer");
	tolua.cast(timer, "ui::CAddOnTimer");
	timer:SetUpdateScript(updatescp);
	timer:Start(0.45);
end



--minimap, sorry..
--minimap is made visible/hidden by client so we have to do this
function EXTUI_MINIMAP_VISIBILITY_CHECK()
	if extui.isSetting then return 1; end

	local minimap_frame = ui.GetFrame("minimap");
	if extui.framepos["minimap"].hidden == 0 then
		if minimap_frame:IsVisible() == 1 then
			minimap_frame:ShowWindow(0, true);
		end
	else
		if minimap_frame:IsVisible() == 0 then
			minimap_frame:ShowWindow(1, true);
		end
	end

	return 1;
end


