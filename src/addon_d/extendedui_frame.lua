--ExtendedUI Frame Handling

if extui == nil then
	extui = {};
end

extui.framepos = {};
extui.defaultFrames = {};

extui.skins = {
		"shadow_box",
		"test_Item_tooltip_normal",
		"systemmenu_vertical",
		"chat_window",
		"popup_rightclick",
		"persoanl_shop_basicframe",
		"tutorial_skin",
		"slot_name",
		"padslot_onskin",
		"padslot_offskin2",
		"monster_skill_bg",
		"tab2_btn",
		"fullblack_bg",
		"testjoo_buttons", --clear
		"test_skin_01_btn_cursoron",
		"test_skin_01_btn_clicked",
		"test_normal_button",
		"frame_bg",
		"textview",
		"listbox",
		"box_glass",
		"tooltip1",
		"textballoon",
		"quest_box",
		"guildquest_box",
		"balloonskin_buy",
		"barrack_creat_win",
		"pip_simple_frame",
	};


--Fixes #1
function extui.TargetInfoUpdate(x,y)
	TARGET_INFO_OFFSET_X = x;
	TARGET_INFO_OFFSET_BOSS_X = x+415;
	TARGET_INFO_OFFSET_Y = y;
end

function extui.ScaleUI(scale)
--todo
end

function extui.ScaleFrame(frame, scale)
--todo
end

extui.frames = {};

local extui_Frame = {};
extui_Frame.name = "Undefined";
extui_Frame.frameName = "Undefined";
extui_Frame.isMovable = true;
extui_Frame.hasChild = false;
extui_Frame.noResize = true;
extui_Frame.show = false;
extui_Frame.child = {};
extui_Frame.onUpdate = function(x,y,w,h) end;
extui_Frame.onNewFrame = function() end;
extui_Frame.onBeforeUpdate = function(x,y,w,h) end;
extui_Frame.onFrameUpdate = function(frame,x,y,w,h) end;
extui.currentNumFrames = 0;

function extui_Frame:AddChild(child, displayName)
	local pfrm = ui.GetFrame(self.frameName);
	
	-- For yall who like to modify this gives you some more info now
	if pfrm == nil then
		print("Frame Not Found? "..tostring(self.frameName));
		return;
	end
	
	local cfrm = pfrm:GetChild(child);
	
	if cfrm == nil then
		print("Child Not Found "..tostring(child));
		return;
	end
	
	if cfrm ~= nil then
	
		self.hasChild = true;

		self.child[string.gsub(child , "%s", "")] = {
				["name"] = string.gsub(displayName or child, "(%a)([%w_']*)", function(a,b) return a:upper()..b:lower(); end),
				["isMovable"] = true,
				["frameName"] = child,
			};
	end
end


function extui.AddFrame(name, frameTbl)
	local fName = string.gsub(name , "%s", "");
	
	if ui.GetFrame(fName) == nil then
		-- For yall who like to modify this gives you some more info now
		print("Frame Not Found "..tostring(fName));
		-- Create a fake object to return so everything doesn't break
		local nonAddedFrame = {};
		
		setmetatable(nonAddedFrame, {__index = extui_Frame});
		
		nonAddedFrame.frameName = fName;
		
		return nonAddedFrame;
	end
	
	extui.frames[fName] = {};

	setmetatable(extui.frames[fName], {__index = extui_Frame});
	
	if type(frameTbl) == "table" then
		local function _thething(_to,_tbl)
			for k,v in pairs(_tbl) do
				if type(v) == "table" then
					if _to[k] == nil then
						_to[k] = {};
					end
					_thething(_to[k], _tbl[k]);
				else
					_to[k] = v;
				end
			end
			return _to;
		end

		extui.frames[fName] = _thething(extui.frames[fName], frameTbl);
	elseif type(frameTbl) == "string" then
		extui.frames[fName].name = frameTbl;
	elseif frameTbl == nil then
		extui.frames[fName].name = string.gsub(name, "(%a)([%w_']*)", function(a,b) return a:upper()..b:lower(); end);
	else
		extui.print(string.format("EUI Internal Error: Cannot Add Frame, frameTbl of type \"%s\" is invalid.", type(frameTbl)));
		return nil;
	end
	
	extui.frames[fName].frameName = fName;
	extui.frames[fName].child = {};
	-- Can be used to sort the array but i don't have enough time now to implement it everywhere
	extui.frames[fName].id = extui.currentNumFrames;
	extui.currentNumFrames = extui.currentNumFrames + 1;

	return extui.frames[fName];
end

function extui.RemoveFrame(name)
	if extui.frames[name] ~= nil then
		extui.frames[name] = nil;
	end
end

function extui.FrameExists(frame)

	for k,_ in pairs(extui.frames) do
		if k == frame then return true; end
	end

	return false;
end

function extui.GetFrameDirect(frame)
	return extui.frames[frame];
end

function extui.GetFrame(frame)
	for k,v in pairs(extui.frames) do
		if k == frame then return v; end
	end
	return nil;	
end

function extui.IsChild(frame)

	for k,v in pairs(extui.frames) do
		if v.hasChild then
			for k,v in pairs(v.child) do
				if k == frame then
					return v;
				end
			end
		end
	end

	return nil;	
end


function extui.ForceFrameUpdate()

	for k,v in pairs(extui.frames) do
		local toc = ui.GetFrame(k);
		if toc ~= nil then
			local x = toc:GetX() or 0;
			local y = toc:GetY() or 0;
			local w = toc:GetWidth() or 0;
			local h = toc:GetHeight() or 0;
			v.onUpdate(x,y,w,h);
		end
	end

end


function EXTENDEDUI_ON_FRAME_LOADS()
	local euiFrame = extui.AddFrame("buff", "Buffs");
	euiFrame.noResize = false;
	euiFrame.onFrameUpdate = function(frame,x,y,w,h)

					for ch,_ in pairs(extui.defaultFrames[frame:GetName()].child) do
						if (ch == "buffcountslot_sub" or ch=="buffcountslot" or ch=="debuffslot" or ch=="buffslot") then
							
							extui.UpdateBuffSizes(ch, true);

						end
					end


					extui.INIT_BUFF_UI(ui.GetFrame("buff"), s_buff_ui, "MY_BUFF_TIME_UPDATE");
					INIT_PREMIUM_BUFF_UI(ui.GetFrame("buff"));
				end;

	euiFrame:AddChild("buffcountslot", "Self Applied Buffs");
	euiFrame:AddChild("buffcountslot_sub", "Buffs From Others");
	euiFrame:AddChild("buffslot", "Unaffected Buffs");
	euiFrame:AddChild("debuffslot", "Debuffs");
	
	extui.AddFrame("minimizedalarm", "Mini Guild Mission");
	
	euiFrame = extui.AddFrame("targetbuff", "Target Buffs");
	euiFrame.noResize = false;
	euiFrame:AddChild("buffcountslot", "Self Applied Buffs");
	euiFrame:AddChild("buffcountslot_sub", "Buffs From Others");
	euiFrame:AddChild("buffslot", "Unaffected Buffs");
	euiFrame:AddChild("debuffslot", "Debuffs");


	extui.AddFrame("fevorcombo", "Fever Combo");
	extui.AddFrame("joystick rest quickslot");
	extui.AddFrame("joystick quickslot");
	extui.AddFrame("rest quickslot");
	extui.AddFrame("quickslotnexpbar", "Keyboard/Mouse Quickslot");
	extui.AddFrame("durnotify", "Durability");

	extui.AddFrame("chat", "Chat Input");
	extui.AddFrame("notice");
	--euiAddon:AddFrame("indunautomatch", "Queue Window");

	euiFrame = extui.AddFrame("target info");
	euiFrame.onUpdate = function(x,y,w,h)
						extui.TargetInfoUpdate(x,y);
					end;

	euiFrame = extui.AddFrame("questinfoset_2", "Quest Log");
	--euiFrame.saveHidden = true;
	euiFrame = extui.AddFrame("keypress", "Tapping Key");
	euiFrame.saveHidden = true;
	euiFrame = extui.AddFrame("ctrltargetui", "CTRL Target Lock");
	--euiFrame.saveHidden = true;
	--euiFrame = euiAddon:AddFrame("weaponswap");
	--euiFrame.saveHidden = true;
	euiFrame = extui.AddFrame("partyinfo", "Party");
	euiFrame.saveHidden = true;
	euiFrame = extui.AddFrame("channel");
	--euiFrame.saveHidden = true;
	euiFrame.noResize = false;
	euiFrame = extui.AddFrame("sysmenu", "Menu");
	euiFrame.saveHidden = true;
	euiFrame = extui.AddFrame("headsupdisplay", "Character Status");
	euiFrame.saveHidden = true;
	euiFrame.noResize = false;
	euiFrame = extui.AddFrame("charbaseinfo", "EXP Bars");
	euiFrame.onBeforeUpdate = function(x,y,w,h)
						local expFrame = ui.GetFrame("charbaseinfo");
						
						expFrame:Resize(1920,30);
					end;
	euiFrame.onNewFrame = function()
					local expFrame = ui.GetFrame("charbaseinfo");

					expFrame:Resize(1920,30);
					expFrame:MoveFrame(0, 1050);
				end;

	euiFrame = extui.AddFrame("playtime");
	euiFrame.saveHidden = true;
	euiFrame = extui.AddFrame("fps", "FPS");
	euiFrame.saveHidden = true;
	euiFrame = extui.AddFrame("castingbar", "Castbar");
	euiFrame.noResize = false;
	euiFrame = extui.AddFrame("mini map");
    euiFrame.saveHidden = true;
	
	euiFrame = extui.AddFrame("mapareatext", "Minimap Area Text");
	euiFrame.noResize = false;
    euiFrame.saveHidden = true;
	euiFrame:AddChild("mapName", "Map Name");
	euiFrame:AddChild("areaName", "Area Name");
	
	euiFrame = extui.AddFrame("minimap_outsidebutton", "Minimap Buttons");
    euiFrame.saveHidden = true;
    euiFrame = extui.AddFrame("time");
    euiFrame.saveHidden = true;
    euiFrame = extui.AddFrame("minimizedeventbanner", "Event Button");
    euiFrame.saveHidden = true;
	euiFrame = extui.AddFrame("minimized_tp_button", "TP Shop Button");
	euiFrame.saveHidden = true;
	euiFrame = extui.AddFrame("minimized_godprotection_button", "God Protect Button");
	euiFrame = extui.AddFrame("minimized_housing_promote_board", "Personal Housing");
	euiFrame = extui.AddFrame("minimized_guild_housing", "Guild Housing");
	
	
	-- Fix by Sadlion, modified into a ternary by me	
    euiFrame = extui.AddFrame("minimized_event_progress_check_button", (IS_SEASON_SERVER() == "NO" and "Medina FLEX!" or "God Roulette"));
	euiFrame.saveHidden = true;
	euiFrame = extui.AddFrame("minimized_pvpmine_shop_button", "Mercenary Shop Button");
	euiFrame.saveHidden = true;
	euiFrame = extui.AddFrame("openingameshopbtn", "TP Item Button");
	euiFrame.noResize = false;
	euiFrame.saveHidden = true;
	euiFrame = extui.AddFrame("summonsinfo", "Summon Info");
	euiFrame.noResize = false;
end

function extui.ForEachFrameN(func)

	for k,v in pairs(extui.frames) do
		if func and extui.IsDisabledFrame(k) ~= true then
			local t,p = pcall(func, k,v);
			if not(t) then
				extui.print("ForEachFrameN func(): "..tostring(p));
			end
		end
	end

end

function extui.ForEachFrameS(func)
	for k,v in pairs(extui.frames) do
		if func and extui.IsDisabledFrame(k) ~= true then
			local t,p = pcall(func, k,v);
			if not(t) then
				extui.print("ForEachFrameS func(): "..tostring(p));
			end
		end
	end
end

function extui.ForEachFrame(func, nfunc, nefunc, cfunc, cnfunc, cnefunc)
	local toc = nil;

	for k,v in pairs(extui.frames) do
		toc = ui.GetFrame(k);
		if v.isMovable and toc ~= nil and extui.IsDisabledFrame(k) ~= true then
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

extui.cloktime = 0;
extui.debug = {};
extui.doFirstPositionLoad = true;

function EXTENDEDUI_LOAD_POSITIONS()

	
	local hasNew = false;

	imcAddOn.BroadMsg("EXTENDEDUI_ON_FRAME_LOAD");
	
	extui.IsDragging = false;
	extui.isFrameOpen = false;

	extui.ForEachFrame(
		function(k,v,toc)
			local x = extui.framepos[tostring(k)].x;
			local y = extui.framepos[tostring(k)].y;
			local w = extui.framepos[tostring(k)].w;
			local h = extui.framepos[tostring(k)].h;
			local nskin = extui.framepos[tostring(k)].skin or "@default";
			local nscale = extui.framepos[tostring(k)].scale or 100;
			local hover = extui.framepos[tostring(k)].hover or 0;

			local xs = toc:GetX() or 0;
			local ys = toc:GetY() or 0;
			local ws = toc:GetWidth() or 0;
			local hs = toc:GetHeight() or 0;
			local scale = 100;
			local skin = toc:GetSkinName();
			
			v.onBeforeUpdate(x, y, w, h);
			
			toc:MoveFrame(x, y);
			if not(v.noResize) then
				toc:Resize(w, h);
			end

			if scale ~= nscale then
				toc:SetScale(nscale, nscale);
			end

			if nskin ~= "@default" then
				nskin = dictionary.ReplaceDicIDInCompStr(nskin);
				toc:SetSkinName(nskin);
			else
				skin = dictionary.ReplaceDicIDInCompStr(skin);
				extui.framepos[tostring(k)].skin = skin;
			end
			

			if v.saveHidden and hover == 0 then
				extui.framepos[tostring(k)].hidden = (extui.framepos[tostring(k)].hidden==1 or extui.framepos[tostring(k)].hidden == true) and 1 or 0
				toc:ShowWindow(extui.framepos[tostring(k)].hidden, true);
			end
			
			if hover == 1 then
				extui.hoverFrames[tostring(k)] = true;
				toc:ShowWindow(0, true);
			end


			if not(extui.firstStart) then
				extui.defaultFrames[tostring(k)] = {};
				extui.defaultFrames[tostring(k)]["x"] = xs;
				extui.defaultFrames[tostring(k)]["y"] = ys;
				extui.defaultFrames[tostring(k)]["w"] = ws;
				extui.defaultFrames[tostring(k)]["h"] = hs;
				extui.defaultFrames[tostring(k)]["scale"] = scale;
				extui.defaultFrames[tostring(k)]["skin"] = skin;
				extui.defaultFrames[tostring(k)]["hover"] = 0;
				if v.hasChild then
					extui.defaultFrames[tostring(k)]["child"] = {};
				end

			end

			if not extui.intable(extui.skins, skin) then
				table.insert(extui.skins, skin);
			end
			
			toc:RunUpdateScript("EXTENDEDUI_FULLFRAME_UPDATE");

			v.onUpdate(x,y,w,h);
			--if k=="targetinfo" then
			--	extui.TargetInfoUpdate(x,y);
			--end

		end,
		function(k,v,toc)
			
			v.onNewFrame();
			
			local x = toc:GetX() or 0;
			local y = toc:GetY() or 0;
			local w = toc:GetWidth() or 0;
			local h = toc:GetHeight() or 0;
			local scale = 100;
			local skin = dictionary.ReplaceDicIDInCompStr(toc:GetSkinName());
			extui.framepos[tostring(k)] = {};
			extui.framepos[tostring(k)]["x"] = x;
			extui.framepos[tostring(k)]["y"] = y;
			extui.framepos[tostring(k)]["w"] = w;
			extui.framepos[tostring(k)]["h"] = h;
			extui.framepos[tostring(k)]["skin"] = skin;
			extui.framepos[tostring(k)]["scale"] = scale;

			if v.saveHidden then
				extui.framepos[tostring(k)]["hidden"] = toc:IsVisible();
			end

			if not(extui.firstStart) then
				extui.defaultFrames[tostring(k)] = extui.framepos[tostring(k)];
			end

			if not extui.intable(extui.skins, skin) then
				table.insert(extui.skins, skin);
			end

			hasNew = true;
			if v.hasChild then
				extui.framepos[tostring(k)]["child"] = {};
			end
			
			toc:RunUpdateScript("EXTENDEDUI_FULLFRAME_UPDATE");

			v.onUpdate(x,y,w,h);
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

			if k == "buff" then
				extui.UpdateBuffSizes(ck, true);
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

	--re-init buff ui to get more slots!
	extui.INIT_BUFF_UI(ui.GetFrame("buff"), s_buff_ui, "MY_BUFF_TIME_UPDATE");
	INIT_PREMIUM_BUFF_UI(ui.GetFrame("buff"));

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
	elseif snotname == "buffcountslot_sub" then
		typ = 3;
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
	local buffc = extui.ldSettingsUI["buffcount"];

    if name == "buff" then
        if extui.GetSetting("extbuff") == true then
            local slotc = extui.GetSetting("rowamt");
            local rowc = extui.round(buffc/slotc);

            aslotset:SetColRow(slotc,rowc);
            aslotset:CreateSlots();
        else
            aslotset:SetColRow(10,1);
        end
    end

    local clist = buff_ui["captionlist"][typ]
    local onrow = 0;
    local ncount = 0;
    for k,v in pairs(clist) do
        local slot = buff_ui["slotlist"][typ][k-1];

        local slotsize = extui.GetSetting("iconsize");
        if slot ~= nil then
            slot:Resize(slotsize,slotsize);
        end

        local sy = 0;
        local sx = slotsize*k;

        if extui.GetSetting("extbuff") == true then
            local slotc = extui.GetSetting("rowamt")+1;

            if (ncount+1)%slotc == 0 then
                onrow = onrow+1;
                ncount = 0;
            end
			
			sy = (slotsize+(15))*onrow;
			sx = slotsize*ncount;

        end

        if slot ~= nil then
			local bdir = extui.GetSetting("buffdir");
			local bdirtb = extui.GetSetting("buffdirtb");
			

			slot:SetOffset(sx,sy);

			local x = buff_ui["slotsets"][typ]:GetX() + sx + buff_ui["txt_x_offset"];
			local y = buff_ui["slotsets"][typ]:GetY() + sy + slot:GetHeight() + buff_ui["txt_y_offset"];
			v:SetOffset(x, y);
		
		
			local buffc = extui.ldSettingsUI["buffcount"];
			local slotc = extui.GetSetting("rowamt");
			local rowc = extui.round(buffc/slotc);
			
			local ax = 0;
			local ay = 0;
			
			ax = (slotc-1)*extui.GetSetting("iconsize")+5;
			ay = ((rowc-1)*extui.GetSetting("iconsize"))+(rowc*15);
			
			if bdir == true then
				slot:SetOffset(ax+ -sx, sy);

				local x = buff_ui["slotsets"][typ]:GetX() + sx + buff_ui["txt_x_offset"];
				local y = buff_ui["slotsets"][typ]:GetY() + sy + slot:GetHeight() + buff_ui["txt_y_offset"];
				v:SetOffset(ax+ -x, y);
			end
			if bdirtb == true then
				slot:SetOffset(sx,ay+ -sy);

				local x = buff_ui["slotsets"][typ]:GetX() + sx + buff_ui["txt_x_offset"];
				local y = buff_ui["slotsets"][typ]:GetY() + sy + slot:GetHeight() + buff_ui["txt_y_offset"];
				v:SetOffset(x, ay+ -y);
			end
			if bdirtb == true and bdir == true then
				slot:SetOffset(ax+ -sx,ay+ -sy);

				local x = buff_ui["slotsets"][typ]:GetX() + sx + buff_ui["txt_x_offset"];
				local y = buff_ui["slotsets"][typ]:GetY() + sy + slot:GetHeight() + buff_ui["txt_y_offset"];
				v:SetOffset(ax+ -x, ay+ -y);
			end

        end

        ncount = ncount+1;
    end
end

--directly taken from lib_uiscp with some minor modifications
function extui.INIT_BUFF_UI(frame, buff_ui, updatescp)

    local slotcountSetPt = frame:GetChild('buffcountslot');
    local slotSetPt = frame:GetChild('buffslot');
    local deslotSetPt = frame:GetChild('debuffslot');
    local slotcountsubSetPt = frame:GetChild("buffcountslot_sub");

    buff_ui["slotsets"][0] = tolua.cast(slotcountSetPt, 'ui::CSlotSet');
    buff_ui["slotsets"][1] = tolua.cast(slotSetPt, 'ui::CSlotSet');
    buff_ui["slotsets"][2] = tolua.cast(deslotSetPt, 'ui::CSlotSet');
    buff_ui["slotsets"][3] = tolua.cast(slotcountsubSetPt, "ui::CSlotSet");

    for i = 0 , buff_ui["buff_group_cnt"] do

        buff_ui["slotcount"][i] = 0;
        buff_ui["slotlist"][i] = {};
        buff_ui["captionlist"][i] = {};

        while 1 do
            if buff_ui["slotsets"][i] == nil then
                break;
            end

            local slot = buff_ui["slotsets"][i]:GetSlotByIndex(buff_ui["slotcount"][i]);
            if slot == nil then
                break;
            end

            buff_ui["slotlist"][i][buff_ui["slotcount"][i]] = slot;

            if slot:GetIcon() == nil then
                slot:ShowWindow(0);
                local icon = CreateIcon(slot);
                icon:SetDrawCoolTimeText(0);
            end

            local x = buff_ui["slotsets"][i]:GetX() + slot:GetX() + buff_ui["txt_x_offset"];
            local y = buff_ui["slotsets"][i]:GetY() + slot:GetY() + slot:GetHeight() + buff_ui["txt_y_offset"];

            local capt = frame:CreateOrGetControl('richtext', "_t_" .. i .. "_".. buff_ui["slotcount"][i], x, y, 50, 20);

            capt:SetFontName("yellow_13");
            buff_ui["captionlist"][i][buff_ui["slotcount"][i]] = capt;

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
	--we might as well put that here instead of creating a new one
	extui.CheckForHover();

	if extui.isSetting then return 1; end

	local minimap_frame = ui.GetFrame("minimap");
	if extui.framepos["minimap"].hidden == 0 then
		if minimap_frame:IsVisible() == 1 then
			minimap_frame:ShowWindow(0, true);
		end
	end

	return 1;
end



function EXTENDEDUI_FULLFRAME_UPDATE(frame)
	if extui.isSetting then return 1; end
	
	local isHovering = frame:GetUserIValue("EUI_IS_HOVERING");
	if isHovering ~= nil and isHovering == 1 then
		return 1;
	end
	
	
	local k = frame:GetName();
	local v = extui.GetFrame(k);
	
	
	local x = extui.framepos[tostring(k)].x;
	local y = extui.framepos[tostring(k)].y;
	local w = extui.framepos[tostring(k)].w;
	local h = extui.framepos[tostring(k)].h;
	local nskin = extui.framepos[tostring(k)].skin or "@default";
	local nscale = extui.framepos[tostring(k)].scale or 100;
	local hover = extui.framepos[tostring(k)].hover or 0;
	local isHidden = (extui.framepos[tostring(k)].hidden==true or extui.framepos[tostring(k)].hidden==1) and 1 or 0;

	local xs = frame:GetX() or 0;
	local ys = frame:GetY() or 0;
	local ws = frame:GetWidth() or 0;
	local hs = frame:GetHeight() or 0;
	local scale = 100;

	v.onBeforeUpdate(x, y, w, h);
	
	frame:MoveFrame(x, y);
	if not(v.noResize) then
		frame:Resize(w, h);
	end

	if scale ~= nscale then
		frame:SetScale(nscale, nscale);
	end	

	if v.saveHidden and hover == 0 then
		frame:ShowWindow(isHidden, true);
	end
	
	if hover == 1 then
		frame:ShowWindow(0, true);
	end

	v.onUpdate(x,y,w,h);
	
	if v.hasChild then
		for ck,cv in pairs(v.child) do
			local tcc = frame:GetChild(tostring(ck));
						
			if cv.isMovable and tcc ~= nil then
				if extui.framepos[tostring(k)]["child"][tostring(ck)] ~= nil then
					local cx = extui.framepos[tostring(k)]["child"][tostring(ck)].x;
					local cy = extui.framepos[tostring(k)]["child"][tostring(ck)].y;

					tcc:SetOffset(cx, cy);

					if k == "buff" then
						extui.UpdateBuffSizes(ck, true);
					end
				end
			end
		end
	end
	
	v.onFrameUpdate(frame, x,y,w,h);
	
	return 1;
end



function extui.UpdateBuffSizes(ck, req)
	extui.MoveBuffCaption("buff", ck);
	
	if req ~= nil then
		local frm = ui.GetFrame("buff");
		local fch = frm:GetChild(ck);

		local buffc = extui.ldSettingsUI["buffcount"];
		local slotc = extui.GetSetting("rowamt");
		local rowc = extui.round(buffc/slotc);

		fch:Resize(slotc*extui.GetSetting("iconsize"),(rowc*extui.GetSetting("iconsize"))+(rowc*15));
	end
end
