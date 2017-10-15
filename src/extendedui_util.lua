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
	acutil.saveJSON("../addons/extendedui/settings.json", extui.ldSettingsUI);
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
			frmTbl[k].skin = frmTbl[k].skin or "@default";

			frmTbl[k].skin = dictionary.ReplaceDicIDInCompStr(frmTbl[k].skin);
		end
	end

	acutil.saveJSON("../addons/extendedui/frames.json", frmTbl);
end


function extui.UpdateCheck()
	local acutil = require("acutil");

	local file, _err = io.open("../addons/extendedui/settings.extui", "r");

	if file == nil then

		local tload, error = acutil.loadJSON("../addons/extendedui/settings.json");
		if not error then
			extui.ldSettingsUI = tload;
		end

		tload, error = acutil.loadJSON("../addons/extendedui/frames.json");
		if not error then
			for _,v in pairs(tload) do
				v.hidden = (v.hidden==true) and 1 or 0;
			end
			extui.framepos = tload;
		else
			EXTENDEDUI_ON_SAVE();
		end

	else

		if file ~= nil then
			for line in file:lines() do
		    	local k,v = string.match(line,"(%w+),(%w+)");
				extui.ldSettingsUI[k] = extui.FromString(v);
		    end

			io.close(file);

			os.remove("../addons/extendedui/settings.extui");
		end

		local file, _err = io.open("../addons/extendedui/frames.extui", "r");
		if file ~= nil then
			local _str = file:read("*all");

			if string.len(_str) > 1 then

				local version = 0;

				local opFrames = StringSplit(_str, "\n");
				for k,v in pairs(opFrames) do
					if string.sub(v, 1, 2) == "//" then
						version = 1;
					else
						if version == 0 then
							local iFrames = StringSplit(v, ",");

							local name = iFrames[1];
							local x = extui.FromString(iFrames[2]);
							local y = extui.FromString(iFrames[3]);
							local w = extui.FromString(iFrames[4]);
							local h = extui.FromString(iFrames[5]);
							local hidden = (extui.FromString(iFrames[6])==true) and 1 or 0;
							local hasChild = extui.FromString(iFrames[7]);
							local childs = {};
							if hasChild then
								local onL = 8;
								while true do
									local cname = iFrames[onL];

									if cname == "0" then
										break;
									end

									local cx,cy = extui.FromString(iFrames[onL+1]), extui.FromString(iFrames[onL+2]);

									childs[cname] = {
											["x"] = cx,
											["y"] = cy,
										};

									onL = onL+3;
								end

							end

							extui.framepos[name] = {
									["x"] = x,
									["y"] = y,
									["w"] = w,
									["h"] = h,
									["hidden"] = hidden,
									["child"] = childs,
								};
						else
							local iFrames = StringSplit(v, ",");

							local name = iFrames[1];
							local x = extui.FromString(iFrames[2]);
							local y = extui.FromString(iFrames[3]);
							local w = extui.FromString(iFrames[4]);
							local h = extui.FromString(iFrames[5]);
							local hidden = (extui.FromString(iFrames[6])==true) and 1 or 0;
							local scale = extui.FromString(iFrames[7]);
							local skin = iFrames[8];
							local hasChild = extui.FromString(iFrames[9]);
							local childs = {};
							if hasChild then
								local onL = 10;
								while true do
									local cname = iFrames[onL];

									if cname == "0" then
										break;
									end

									local cx,cy = extui.FromString(iFrames[onL+1]), extui.FromString(iFrames[onL+2]);

									childs[cname] = {
											["x"] = cx,
											["y"] = cy,
										};

									onL = onL+3;
								end

							end

							extui.framepos[name] = {
									["x"] = x,
									["y"] = y,
									["w"] = w,
									["h"] = h,
									["hidden"] = hidden,
									["skin"] = skin,
									["scale"] = scale,
									["child"] = childs,
								};
						end
					end
				end
			end

			io.close(file);
			os.remove("../addons/extendedui/frames.extui");
		end
	end
	extui.language.LoadFile();
end



function EXTENDEDUI_ON_SAVE()
	local s, bl = pcall(extui.SavePositions);
	if not(s) then
		extui.print("ERROR: "..bl);
	end
end
