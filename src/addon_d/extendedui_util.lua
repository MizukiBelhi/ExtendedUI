--ExtendedUI Utility

if extui == nil then
	extui = {};
end


function extui.spairs(t, order)
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

function extui.round(num, idp)
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

function extui.print(t)
	print(t);
	CHAT_SYSTEM(tostring(t));
end

--directly stolen from fiotes cwAPI, much love <3
function extui.tablelength(T)
  	local count = 0
  	for _ in pairs(T) do count = count + 1 end
  	return count
end

function extui.intable(t,v)
	for _,__ in pairs(t) do if __==v then return true; end end
	return false;
end

function extui.FromString(s)
	if s == "false" then
		return false;
	elseif s == "true" then
		return true;
	end

	if tonumber(s) ~= nil then
		return tonumber(s);
	end

	return s;
end

function extui.SaveSettings()
	local acutil = require("acutil");


	for k,v in pairs(extui.lSettingsUI) do
		extui.ldSettingsUI[k] = v.val;
	end
	--acutil.saveJSON("../addons/extendedui/settings.json", extui.ldSettingsUI);
	acutil.saveJSONX('extendedui/settings.json', extui.ldSettingsUI);
end

function extui.SavePositions()
	local acutil = require("acutil");


	extui.SaveSettings();

	--clean frame settings
	local frmTbl = {};
	for k,v in pairs(extui.framepos) do
		if extui.FrameExists(k) then
			frmTbl[k] = v;
			frmTbl[k].hidden = (frmTbl[k].hidden==1 or frmTbl[k].hidden == true) and true or false;
			frmTbl[k].scale = frmTbl[k].scale or 100;
		end
	end

	--acutil.saveJSON("../addons/extendedui/frames.json", frmTbl);
	acutil.saveJSONX('extendedui/frames.json', frmTbl);
end


function extui.LoadExternalFrameList()
	local file, _err = io.open("../addons/extendedui/framelist.txt", "r");
	if file ~= nil then
		for line in file:lines() do
			if line:sub(1, 2) ~= "//" then
				local k,v = string.match(line,"(%w+),(%w+)");

				extui.externalFrameList[k] = v;
			end
		end

		io.close(file);
	else
		extui.SaveDefaultExternalFrameList();
	end
end

--This also means EUI now supports translated names for frames
--However, by default EUI will only come with english
function extui.SaveDefaultExternalFrameList()
	local file, _err = io.open("../addons/extendedui/framelist.txt", "w+");
	if file ~= nil then
		io.write("//frame name, readable name (No Child Frames)");
		io.write("buff,Buffs");
		io.write("targetbuff,Target Buffs");
		io.write("minimizedalarm,Mini Guild Mission");
		io.write("fevorcombo,Fever Combo");
		io.write("joystickrestquickslot,Joystick Rest Quickslot");
		io.write("joystickquickslot,Joystick Quickslot");
		io.write("restquickslot,Rest Quickslot");
		io.write("quickslotnexpbar,Mouse/Keyboard Quickslot");
		io.write("durnotify,Durability");
		io.write("chatframe,Chat Window");
		io.write("chat,Chat Input");
		io.write("notice,Notice");
		io.write("targetinfo,Target Info");
		io.write("questinfoset_2,Quest Log");
		io.write("keypress,Tapping Key");
		io.write("ctrltargetui,CTRL Target Lock");
		io.write("partyinfo,Party");
		io.write("channel,Channel");
		io.write("sysmenu,Menu");
		io.write("headsupdisplay,Character Status");
		io.write("charbaseinfo,EXP Bars");
		io.write("playtime,Playtime");
		io.write("fps,FPS");
		io.write("castingbar,Castbar");
		io.write("minimap,Minimap");
		io.write("mapareatext,Minimap Area Text");
		io.write("minimap_outsidebutton,Minimap Buttons");
		io.write("time,Time");
		io.write("minimizedeventbanner,Event Banner");
		io.write("minimized_tp_button,TP Shop Button");
		io.write("minimized_godprotection_button,God Protect Button");
		io.write("openingameshopbtn,TP Item Button");
		io.write("minimized_event_progress_check_button,Seasonal Event Button");
		io.write("minimized_pvpmine_shop_button,Mercenary Shop Button");
		io.write("minimized_housing_promote_board,Personal Housing");
		io.write("minimized_guild_housing,Guild Housing");
		io.write("summonsinfo,Summon Info");

		io.close(file);
	end
end


function extui.UpdateCheck()
	local acutil = require("acutil");

	--local tload, error = acutil.loadJSON("../addons/extendedui/settings.json");
	local tload, error = acutil.loadJSONX("extendedui/settings.json");
	if not error then
		extui.ldSettingsUI = tload;
	end

	--tload, error = acutil.loadJSON("../addons/extendedui/frames.json");
	tload, error = acutil.loadJSONX("extendedui/frames.json");
	if not error then
		for _,v in pairs(tload) do
			v.hidden = (v.hidden==true) and 1 or 0;
		end
		extui.framepos = tload;
	else
		EXTENDEDUI_ON_SAVE();
	end

	extui.language.LoadFile();
end



function EXTENDEDUI_ON_SAVE()
	local s, bl = pcall(extui.SavePositions);
	if not(s) then
		extui.print("[EUI] OnSave(): "..bl);
	end
end

function extui.DrawBorder(pic, xPos, yPos, width, height, color)
	width = width - 1;
	height = height - 1;
	--Limit width and height to a minimum of 1
	if width < 1 then
		width = 1;
	end
	if height < 1 then
		height = 1;
	end
	
	--pic:SetColorTone("88000000");
	
	-- Top
	local line = pic:CreateOrGetControl("picture", "aa"..tostring(color), xPos, yPos, width, 1);
	AUTO_CAST(line);
	line:SetImage("fullwhite");
	line:SetEnableStretch(1);
	line:SetColorTone(color);
	
	
	-- Bottom
	line = pic:CreateOrGetControl("picture", "ab"..tostring(color), xPos, yPos+height, width, 1);
	AUTO_CAST(line);
	line:SetImage("fullwhite");
	line:SetEnableStretch(1);
	line:SetColorTone(color);
	
	-- Left
	line = pic:CreateOrGetControl("picture", "ac"..tostring(color), xPos, yPos, 1, height);
	AUTO_CAST(line);
	line:SetImage("fullwhite");
	line:SetEnableStretch(1);
	line:SetColorTone(color);
	
	-- Right
	line = pic:CreateOrGetControl("picture", "ad"..tostring(color), xPos+width, yPos, 1, height);
	AUTO_CAST(line);
	line:SetImage("fullwhite");
	line:SetEnableStretch(1);
	line:SetColorTone(color);
	
	--pic:DrawBrush(xPos, yPos, xPos+width, yPos, "spray_1", color);
	
	--pic:DrawBrush(xPos, yPos+height, xPos+width, yPos+height, "spray_1", color);

	--pic:DrawBrush(xPos+width, yPos+height, xPos+width, yPos, "spray_1", color);
	
	--pic:DrawBrush(xPos, yPos+height, xPos, yPos, "spray_1", color);
end
