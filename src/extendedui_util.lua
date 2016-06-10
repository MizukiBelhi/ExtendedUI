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



function extui.SavePositions()
	
	for k,v in pairs(extui.lSettingsUI) do
		if extui.ldSettingsUI[tostring(k)] ~= nil then
			extui.ldSettingsUI[tostring(k)] = v.val;
		end
	end
	
	local file, error = io.open("../addons/extendedui/settings.extui", "w");
	if file ~= nil then
		local _str = "";

		for k,v in pairs(extui.ldSettingsUI) do
			_str = _str..k..","..tostring(v).."\n";
		end

		file:write(_str);
		io.close(file);
	end

	file, error = io.open("../addons/extendedui/frames.extui", "w");
	if file ~= nil then
		local _str = "//exts 1.0\n";

		for k,v in pairs(extui.framepos) do
			if extui.frames[k] then
				local name = k;
				local x,y = tostring(v.x),tostring(v.y);
				local w,h = tostring(v.w),tostring(v.h);
				local hidden = (v.hidden==1 or v.hidden == true) and true or false;
				local scale = v.scale or 100;
				local skin = v.skin or "@default";
				local hasChild = extui.frames[k].hasChild or false;

				--if string.sub(skin, 1, 4) == "@dic" then
					skin = dictionary.ReplaceDicIDInCompStr(skin);
				--end

				_str = _str..name..","..x..","..y..","..w..","..h..","..tostring(hidden)..","..tostring(scale)..","..tostring(skin)..","..tostring(hasChild);

				if hasChild then

					for ck,cv in pairs(v.child) do
						local cname = ck;
						local cx,cy = tostring(cv.x),tostring(cv.y);

						_str = _str..","..cname..","..cx..","..cy;
					end

					_str = _str..",0";
				end

				_str = _str.."\n";
			end
		end

		file:write(_str);
		io.close(file);
	end
end


function extui.UpdateCheck()
	local file, error = io.open("../addons/extendedui/settings.extui", "r");
	if file ~= nil then
		for line in file:lines() do
	    	local k,v = string.match(line,"(%w+),(%w+)");
			extui.ldSettingsUI[k] = extui.FromString(v);
	    end

		io.close(file);
	end

	local file, error = io.open("../addons/extendedui/frames.extui", "r");
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
	end
end



function EXTENDEDUI_ON_SAVE()
	local s, bl = pcall(extui.SavePositions);
	if not(s) then
		extui.print("ERROR: "..bl);
	end
end