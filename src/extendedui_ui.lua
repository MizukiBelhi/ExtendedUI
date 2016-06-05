--ExtendedUI Menu

if extui == nil then
	extui = {};
end

extui.unsavedSettings = false;
extui.selectedFrame = nil;
extui.selectedFrameParent = nil;

function EXTENDEDUI_ON_CHECK_HIDE(frame, ctrl, argStr)
	local frm = ui.GetFrame(argStr);
	frm:ShowWindow(ctrl:IsChecked(), true);
	extui.unsavedSettings = true;
end


function extui.openside()
	extui.oldSlider = {};

	extui.InitSideFrame();


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
				ui.GetFrame("extuidragframe"..tostring(k)):ShowWindow(0);
				if extui.frames[k].hasChild then
					for ch,v in pairs(extui.frames[k]["child"]) do
						 ui.GetFrame("extuidragframe"..k..ch):ShowWindow(0);
					end
				end
				v.show = false;
			end
		end

		--settings
		local _settings = extui.GetSettings();
		for k,v in pairs(_settings) do
			v.val = extui.GetSavedSetting(k);
		end
		
		local frm = ui.GetFrame("EXTENDEDUI_SIDE_FRAME");
		extui.reload();
		frm:ShowWindow(0);
		extui.isSetting = false;
		extui.showAll = false;
		extui.unsavedSettings = false;
	end
end

function extui.UpdateSliders()
	local t,p = pcall(extui.tpUpdateSliders);
	if not(t) then
		extui.print("OnSlide(): "..tostring(p));
	end
end

function extui.tpUpdateSliders()
	local uibox = GET_CHILD(extui.sideFrame, "extuibox", "ui::CGroupBox");

	extui.ForEachFrame(
		function(k,v,toc)
			local textX = GET_CHILD(uibox,"extuilabelvalx"..tostring(k),"ui::CRichText");
			local textY = GET_CHILD(uibox,"extuilabelvaly"..tostring(k),"ui::CRichText");
			local sliderX = GET_CHILD(uibox,"extuislidex"..tostring(k),"ui::CSlideBar");
			local sliderY = GET_CHILD(uibox,"extuislidey"..tostring(k),"ui::CSlideBar");
			
			local xs = extui.framepos[tostring(k)].x;
			local ys = extui.framepos[tostring(k)].y;
			
			sliderX:SetLevel(xs);
			sliderY:SetLevel(ys);
			
			textX:SetText("{@st42b}"..extui.round(xs).."{/}");
			textY:SetText("{@st42b}"..extui.round(ys).."{/}");

			--local toc = ui.GetFrame(k)
			local isVisibleCheck = GET_CHILD(uibox,"extuicheckvis"..tostring(k),"ui::CCheckBox");
			isVisibleCheck:SetCheck(toc:IsVisible());
			
			if not(v.noResize) then
				local textW = GET_CHILD(uibox,"extuilabelvalw"..tostring(k),"ui::CRichText");
				local textH = GET_CHILD(uibox,"extuilabelvalh"..tostring(k),"ui::CRichText");
				local sliderW = GET_CHILD(uibox,"extuislidew"..tostring(k),"ui::CSlideBar");
				local sliderH = GET_CHILD(uibox,"extuislideh"..tostring(k),"ui::CSlideBar");
				
				local ws = extui.framepos[tostring(k)].w;
				local hs = extui.framepos[tostring(k)].h;

				sliderW:SetLevel(ws);
				sliderH:SetLevel(hs);

				textW:SetText("{@st42b}"..extui.round(ws).."{/}");
				textH:SetText("{@st42b}"..extui.round(hs).."{/}");
			end
		end,
		nil,nil,nil,
		function(k, v, ck, cv, toc, tcc)
			local textX = GET_CHILD(uibox,"extuilabelvalx"..tostring(k)..tostring(ck),"ui::CRichText");
			local textY = GET_CHILD(uibox,"extuilabelvaly"..tostring(k)..tostring(ck),"ui::CRichText");
			local sliderX = GET_CHILD(uibox,"extuislidex"..tostring(k)..tostring(ck),"ui::CSlideBar");
			local sliderY = GET_CHILD(uibox,"extuislidey"..tostring(k)..tostring(ck),"ui::CSlideBar");
			
			local xs = extui.framepos[tostring(k)]["child"][tostring(ck)].x;
			local ys = extui.framepos[tostring(k)]["child"][tostring(ck)].y;

			sliderX:SetLevel(xs);
			sliderY:SetLevel(ys);
			
			textX:SetText("{@st42b}"..extui.round(xs).."{/}");
			textY:SetText("{@st42b}"..extui.round(ys).."{/}");
		end);
end

--TODO: Needs to use ForEachFrame
function EXTUI_ON_SLIDE()
	local tabObj		    = extui.sideFrame:GetChild("extuitabs");
	local itembox_tab		= tolua.cast(tabObj, "ui::CTabControl");
	local curtabIndex	    = itembox_tab:GetSelectItemIndex();
	
	-- make sure it only happens when actually on that tab
	if curtabIndex == 0 then return 1; end
	if extui.isReload or extui.IsDragging then return 1; end
	if extui.isSetting then
		
		local uibox = GET_CHILD(extui.sideFrame, "extuibox", "ui::CGroupBox");
	
		for k,v in pairs(extui.frames) do
			if v.isMovable then
				if extui.framepos[tostring(k)] ~= nil then
					local textX = GET_CHILD(uibox,"extuilabelvalx"..tostring(k),"ui::CRichText");
					local textY = GET_CHILD(uibox,"extuilabelvaly"..tostring(k),"ui::CRichText");
					local sliderX = GET_CHILD(uibox,"extuislidex"..tostring(k),"ui::CSlideBar");
					local sliderY = GET_CHILD(uibox,"extuislidey"..tostring(k),"ui::CSlideBar");
					
					local x = sliderX:GetLevel();
					local y = sliderY:GetLevel();
					textX:SetText("{@st42b}"..extui.round(x).."{/}");
					textY:SetText("{@st42b}"..extui.round(y).."{/}");

					local toc = ui.GetFrame(k)
					local doMove = false;

					if toc:GetX() ~= sliderX:GetLevel() or toc:GetY() ~= sliderY:GetLevel() then
						doMove = true;
					end
					
					local doResize = false;
					
					if not(v.noResize) then
						local textW = GET_CHILD(uibox,"extuilabelvalw"..tostring(k),"ui::CRichText");
						local textH = GET_CHILD(uibox,"extuilabelvalh"..tostring(k),"ui::CRichText");
						local sliderW = GET_CHILD(uibox,"extuislidew"..tostring(k),"ui::CSlideBar");
						local sliderH = GET_CHILD(uibox,"extuislideh"..tostring(k),"ui::CSlideBar");
						
						local w = sliderW:GetLevel();
						local h = sliderH:GetLevel();

						textW:SetText("{@st42b}"..extui.round(w).."{/}");
						textH:SetText("{@st42b}"..extui.round(h).."{/}");
						
						if toc:GetWidth() ~= sliderW:GetLevel() or toc:GetHeight() ~= sliderH:GetLevel() then
							doResize = true;
						end

						if doResize then
							local toc = ui.GetFrame(k);
							toc:Resize(w,h);
							
							local tcc = ui.GetFrame("extuidragframe"..tostring(k));
							if tcc ~= nil then
								tcc:Resize(w, h);
							end
							extui.framepos[tostring(k)]["w"] = w;
							extui.framepos[tostring(k)]["h"] = h;
							extui.unsavedSettings = true;
						end
					end

					--local isVisibleCheck = GET_CHILD(uibox,"extuicheckvis"..tostring(k),"ui::CCheckBox");
					--isVisibleCheck:SetCheck(toc:IsVisible());
					if v.saveHidden then
						extui.framepos[tostring(k)]["hidden"] = toc:IsVisible();
					end
					
					if doMove then
						extui.unsavedSettings = true;
						toc:MoveFrame(x, y);
						local tcc = ui.GetFrame("extuidragframe"..tostring(k));
						if tcc ~= nil then
							tcc:MoveFrame(x, y);
							if extui.frames[k].hasChild then
								for ch,v in pairs(extui.frames[k]["child"]) do
									local chfrm = ui.GetFrame("extuidragframe"..k..ch);

									local ssc = toc:GetChild(ch);
									local xc = ssc:GetX();
									local yc = ssc:GetY();

									chfrm:SetOffset(x+xc, y+yc);

									if k == "buff" or k == "targetbuff" then
										extui.MoveBuffCaption(k, ch);
										local frm = ui.GetFrame(k);
										local fch = frm:GetChild(ck);
										fch:Resize(10*extui.GetSetting("iconsize"),extui.GetSetting("iconsize"));
									end
								end
							end

							if k=="targetinfo" then
								extui.TargetInfoUpdate(x,y);
							end
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
							local textX = GET_CHILD(uibox,"extuilabelvalx"..tostring(k)..tostring(ck),"ui::CRichText");
							local textY = GET_CHILD(uibox,"extuilabelvaly"..tostring(k)..tostring(ck),"ui::CRichText");
							local sliderX = GET_CHILD(uibox,"extuislidex"..tostring(k)..tostring(ck),"ui::CSlideBar");
							local sliderY = GET_CHILD(uibox,"extuislidey"..tostring(k)..tostring(ck),"ui::CSlideBar");
							
							local toc = ui.GetFrame(k);
							local tcc = toc:GetChild(ck);
							
							local x = sliderX:GetLevel();
							local y = sliderY:GetLevel();
							
							textX:SetText("{@st42b}"..extui.round(x).."{/}");
							textY:SetText("{@st42b}"..extui.round(y).."{/}");
							
							local doMove = false;

							if toc:GetWidth() ~= sliderX:GetMaxLevel() or toc:GetHeight() ~= sliderY:GetMaxLevel() then
								sliderX:SetMaxSlideLevel(ui.GetClientInitialWidth());
								sliderX:SetMinSlideLevel(-ui.GetClientInitialWidth());
								sliderY:SetMaxSlideLevel(ui.GetClientInitialHeight());
								sliderY:SetMinSlideLevel(-ui.GetClientInitialHeight());
							end
							
							if tcc:GetX() ~= sliderX:GetLevel() or tcc:GetY() ~= sliderY:GetLevel() then
								doMove = true;
							end

							if doMove then
								extui.unsavedSettings = true;
								tcc:SetOffset(x, y);
								extui.framepos[tostring(k)]["child"][tostring(ck)]["x"] = x;
								extui.framepos[tostring(k)]["child"][tostring(ck)]["y"] = y;

								local ssc = ui.GetFrame("extuidragframe"..k..ck);
								if ssc ~= nil then
									ssc:SetOffset(toc:GetX()+x, toc:GetY()+y);
								end

								if k == "buff" or k == "targetbuff" then
									extui.MoveBuffCaption(k, ck);
									local frm = ui.GetFrame(k);
									local fch = frm:GetChild(ck);

									local slotCount = fch:GetSlotCount();
									fch:Resize(slotCount*extui.GetSetting("iconsize"),extui.GetSetting("iconsize"));

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

local savedFramePosX = 0;
local savedFramePosY = 0;

function EXTENDEDUI_ON_MINI_CANCEL()
	ui.GetFrame("EXTENDEDUI_MINI_FRAME"):ShowWindow(0);

	local mf = ui.GetFrame("EXTENDEDUI_SIDE_FRAME");
	mf:MoveFrame(savedFramePosX, savedFramePosY);
	local uibox = GET_CHILD(mf, "extuibox", "ui::CGroupBox");
	local chbox = GET_CHILD(uibox,"extuicheckallframes","ui::CCheckBox");
	chbox:SetCheck(0);

	EXTENDEDUI_ON_BUTTON_FRAME_PRESS(nil,nil,"*all");
end

function EXTENDEDUI_MINI_UPDATE()
	local frame = extui.selectedFrameParent;
	local cframe = extui.selectedFrame;

	if frame ~= nil then
		local minidrop = ui.GetFrame("EXTENDEDUI_MINI_FRAME")
		if minidrop == nil then return 0; end

		minidrop = minidrop:GetChild("extuiminidrop");
		minidrop = tolua.cast(minidrop, "ui::CDropList");

		local selFrame = frame:GetName();
		selFrame = extui.frames[selFrame].name;

		if cframe ~= nil then
			selFrame = selFrame.."."..extui.frames[frame:GetName()].child[cframe:GetName()].name;
		end

		if minidrop:GetSelItemCaption() ~= selFrame then
			minidrop:SelectItemByKey(selFrame);
			minidrop:Invalidate();
		end
	end

	return 1;
end

function EXTENDEDUI_MINI_ON_SELECT(frame)
	local droplist = GET_CHILD(frame, "extuiminidrop", "ui::CDropList");
	local selFrame = droplist:GetSelItemKey();

	if selFrame == "0" then
		extui.selectedFrameParent = nil;
		extui.selectedFrame = nil;
		return;
	end

	for k,v in pairs(extui.frames) do
		if v.name == selFrame then
			extui.selectedFrameParent = ui.GetFrame(v.name);
			extui.selectedFrame = nil;
			break;
		end
		if v.hasChild then
			for _k,_v in pairs(v.child) do
				if v.name..".".._v.name == selFrame then
					extui.selectedFrame = ui.GetFrame(v.name):GetChild(_v.name);
					extui.selectedFrameParent = ui.GetFrame(v.name);
					break;
				end
			end
		end
	end
end

function extui.OpenMiniFrame()
	local mf = ui.GetFrame("EXTENDEDUI_SIDE_FRAME");
	savedFramePosY = mf:GetX();
	savedFramePosX = mf:GetY();
	mf:MoveFrame(9999,9999);--move frame out of view

	local frm = ui.CreateNewFrame("extendedui", "EXTENDEDUI_MINI_FRAME");
	frm:Resize(350 , 100);
	frm:MoveFrame((ui.GetSceneWidth()/2)-175, (ui.GetSceneHeight()/2)-50);
	frm:SetSkinName("pip_simple_frame");

	--buttons
	local ctrls = frm:CreateOrGetControl("button", "extuiminisaveclose", 50, 65, 125, 30);
	ctrls = tolua.cast(ctrls, "ui::CButton");
	ctrls:SetText("{@st66b}Save&Close{/}");
	ctrls:SetClickSound("button_click_big");
	ctrls:SetOverSound("button_over");
	ctrls:SetEventScript(ui.LBUTTONUP, "EXTENDEDUI_ON_MINI_SAVE");
	ctrls:SetSkinName("test_pvp_btn");

	ctrls = frm:CreateOrGetControl("button", "extuiminiclose", 175, 65, 125, 30);
	ctrls = tolua.cast(ctrls, "ui::CButton");
	ctrls:SetText("{@st66b}Cancel{/}");
	ctrls:SetClickSound("button_click_big");
	ctrls:SetOverSound("button_over");
	ctrls:SetEventScript(ui.LBUTTONUP, "EXTENDEDUI_ON_MINI_CANCEL");
	ctrls:SetSkinName("test_pvp_btn");

	ctrls = frm:CreateOrGetControl("droplist", "extuiminidrop", (350/2)-100, 15, 200, 30);
	ctrls = tolua.cast(ctrls, "ui::CDropList");
	ctrls:SetSkinName("droplist_normal");
	ctrls:SetTextAlign("left", "left");
	ctrls:AddItem(0, "None Selected");

	for k,v in pairs(extui.frames) do
		if v.isMovable then
			ctrls:AddItem(tostring(v.name),tostring(v.name));
			if v.hasChild then
				for _k,_v in pairs(v.child) do
					ctrls:AddItem(tostring(v.name).."."..tostring(_v.name), tostring(v.name).."."..tostring(_v.name));
				end
			end
		end
	end

	ctrls:SelectItem(0);
	ctrls:SetSelectedScp("EXTENDEDUI_MINI_ON_SELECT");
	ctrls:Invalidate();

	frm:RunUpdateScript("EXTENDEDUI_MINI_UPDATE");
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
	
	extui.UIAddSettings(cbox);
	
	--frame box
	cbox = ctrl:CreateOrGetControl("groupbox", "extuibox", 30, 120, 740, 430);
	cbox = tolua.cast(cbox, "ui::CGroupBox");
	cbox:SetSkinName("bg2");

	--lots of slidersssss yaaay!
	local inx = 10;
	local iny = 10;

	local ctrls = cbox:CreateOrGetControl("richtext", "extuitxtllall", inx, iny, 300, 30);
	ctrls = tolua.cast(ctrls, "ui::CRichText");
	ctrls:SetText("{@st43}All Frames{/}");
	iny = iny+35;
	ctrls = cbox:CreateOrGetControl("checkbox", "extuicheckallframes", inx+10, iny, 150, 30);
	ctrls = tolua.cast(ctrls, "ui::CCheckBox");
	ctrls:SetText("{@st42b}Edit All Frames{/}");
	ctrls:SetClickSound("button_click_big");
	ctrls:SetOverSound("button_over");
	ctrls:SetEventScript(ui.LBUTTONUP, "EXTENDEDUI_ON_BUTTON_FRAME_PRESS");
	ctrls:SetEventScriptArgString(ui.LBUTTONUP, "*all");

	iny = iny+35;
	cbox:CreateOrGetControl("labelline", "extuitlinegen", inx+5, iny+10, 700, 1);
	iny = iny+35;

	for k,v in pairs(extui.frames) do
		inx = 10;
		toc = ui.GetFrame(k);
		
		if v.isMovable then
			if extui.framepos[tostring(k)] ~= nil then
				
				ctrls = cbox:CreateOrGetControl("richtext", "extuilabelname"..tostring(k), inx, iny, 300, 30);
				ctrls = tolua.cast(ctrls, "ui::CRichText");
				ctrls:SetText("{@st43}"..tostring(v.name).."{/}");
				
				iny = iny+35;
				
				local x = extui.framepos[tostring(k)].x;
				local y = extui.framepos[tostring(k)].y;
				local w = extui.framepos[tostring(k)].w;
				local h = extui.framepos[tostring(k)].h;
				
				ctrls = cbox:CreateOrGetControl("richtext", "extuilabelpos"..tostring(k), inx, iny, 300, 30);
				ctrls = tolua.cast(ctrls, "ui::CRichText");
				ctrls:SetText("{@st42b}Position{/}");
				
				iny = iny+10;
				
				ctrls = cbox:CreateOrGetControl("richtext", "extuilabelx"..tostring(k), inx, iny+5, 300, 30);
				ctrls = tolua.cast(ctrls, "ui::CRichText");
				ctrls:SetText("{@st42b}x{/}");
				
				ctrls = cbox:CreateOrGetControl("slidebar", "extuislidex"..tostring(k), inx+12, iny, 300, 30);
				ctrls = tolua.cast(ctrls, "ui::CSlideBar");
				ctrls:SetMaxSlideLevel(ui.GetClientInitialWidth());
				ctrls:SetMinSlideLevel(0);
				ctrls:SetLevel(x);
				ctrls:SetTextTooltip(string.format("{@st42b}Left/Right Position{/}"));
				
				ctrls = cbox:CreateOrGetControl("richtext", "extuilabelvalx"..tostring(k), inx+295, iny+5, 300, 30);
				ctrls = tolua.cast(ctrls, "ui::CRichText");
				ctrls:SetText("{@st42b}"..extui.round(x).."{/}");

				iny = iny+35;
				
				ctrls = cbox:CreateOrGetControl("richtext", "extuilabely"..tostring(k), inx, iny+5, 300, 30);
				ctrls = tolua.cast(ctrls, "ui::CRichText");
				ctrls:SetText("{@st42b}y{/}");
				
				ctrls = cbox:CreateOrGetControl("slidebar", "extuislidey"..tostring(k), inx+12, iny, 300, 30);
				ctrls = tolua.cast(ctrls, "ui::CSlideBar");
				ctrls:SetMaxSlideLevel(ui.GetClientInitialHeight());
				ctrls:SetMinSlideLevel(0);
				ctrls:SetLevel(y);
				ctrls:SetTextTooltip(string.format("{@st42b}Up/Down Position{/}"));
				
				ctrls = cbox:CreateOrGetControl("richtext", "extuilabelvaly"..tostring(k), inx+295, iny+5, 300, 30);
				ctrls = tolua.cast(ctrls, "ui::CRichText");
				ctrls:SetText("{@st42b}"..extui.round(y).."{/}");
				
				iny = iny+35;
				
				if not(v.noResize) then
					ctrls = cbox:CreateOrGetControl("richtext", "extuilabelsize"..tostring(k), inx, iny, 300, 30);
					ctrls = tolua.cast(ctrls, "ui::CRichText");
					ctrls:SetText("{@st42b}Size{/}");
					
					iny = iny+10;
					
					ctrls = cbox:CreateOrGetControl("richtext", "extuilabelw"..tostring(k), inx, iny+5, 300, 30);
					ctrls = tolua.cast(ctrls, "ui::CRichText");
					ctrls:SetText("{@st42b}w{/}");
					
					ctrls = cbox:CreateOrGetControl("slidebar", "extuislidew"..tostring(k), inx+12, iny, 300, 30);
					ctrls = tolua.cast(ctrls, "ui::CSlideBar");
					ctrls:SetMaxSlideLevel(ui.GetClientInitialWidth());
					ctrls:SetMinSlideLevel(0);
					ctrls:SetLevel(w);
					ctrls:SetTextTooltip(string.format("{@st42b}Width{/}"));
					
					ctrls = cbox:CreateOrGetControl("richtext", "extuilabelvalw"..tostring(k), inx+295, iny+5, 300, 30);
					ctrls = tolua.cast(ctrls, "ui::CRichText");
					ctrls:SetText("{@st42b}"..extui.round(w).."{/}");
					
					iny = iny+35;
					
					ctrls = cbox:CreateOrGetControl("richtext", "extuilabelh"..tostring(k), inx, iny+5, 300, 30);
					ctrls = tolua.cast(ctrls, "ui::CRichText");
					ctrls:SetText("{@st42b}h{/}");
					
					ctrls = cbox:CreateOrGetControl("slidebar", "extuislideh"..tostring(k), inx+12, iny, 300, 30);
					ctrls = tolua.cast(ctrls, "ui::CSlideBar");
					ctrls:SetMaxSlideLevel(ui.GetClientInitialHeight());
					ctrls:SetMinSlideLevel(0);
					ctrls:SetLevel(h);
					ctrls:SetTextTooltip(string.format("{@st42b}Height{/}"));
					
					ctrls = cbox:CreateOrGetControl("richtext", "extuilabelvalh"..tostring(k), inx+295, iny+5, 300, 30);
					ctrls = tolua.cast(ctrls, "ui::CRichText");
					ctrls:SetText("{@st42b}"..extui.round(h).."{/}");
					
					iny = iny+35;
				
				end
				
				ctrls = cbox:CreateOrGetControl("checkbox", "extuicheckvis"..tostring(k), inx+10, iny, 150, 30);
				ctrls = tolua.cast(ctrls, "ui::CCheckBox");
				ctrls:SetText("{@st42b}Show Frame{/}");
				ctrls:SetClickSound("button_click_big");
				ctrls:SetOverSound("button_over");
				ctrls:SetEventScript(ui.LBUTTONUP, "EXTENDEDUI_ON_CHECK_HIDE");
				ctrls:SetEventScriptArgString(ui.LBUTTONUP, tostring(k));
				ctrls:SetCheck(toc:IsVisible());
				if extui.frames[tostring(k)].saveHidden then
					ctrls:SetColorTone("FF00FF00");
					ctrls:SetTextTooltip(string.format("{@st42b}Visibility will be saved{/}"));
				else
					ctrls:SetColorTone("FFFF0000");
					ctrls:SetTextTooltip(string.format("{@st42b}Visibility will not be saved{/}"));
				end
				
				iny = iny+30;
				
				ctrls = cbox:CreateOrGetControl("checkbox", "extuicheckarea"..tostring(k), inx+10, iny, 150, 30);
				ctrls = tolua.cast(ctrls, "ui::CCheckBox");
				ctrls:SetText("{@st42b}Show Frame Area{/}");
				ctrls:SetClickSound("button_click_big");
				ctrls:SetOverSound("button_over");
				ctrls:SetEventScript(ui.LBUTTONUP, "EXTENDEDUI_ON_BUTTON_FRAME_PRESS");
				ctrls:SetEventScriptArgString(ui.LBUTTONUP, tostring(k));
				ctrls:SetTextTooltip(string.format("{@st42b}Enables/Disables dragging{/}"));
			
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
						
						ctrls = cbox:CreateOrGetControl("richtext", "extuilabelname"..tostring(k)..tostring(ck), inx, iny, 300, 30);
						ctrls = tolua.cast(ctrls, "ui::CRichText");
						ctrls:SetText("{@st42b}"..tostring(cv.name).."{/}");
						
						iny = iny+12;

						ctrls = cbox:CreateOrGetControl("richtext", "extuilabelx"..tostring(k)..tostring(ck), inx, iny+5, 300, 30);
						ctrls = tolua.cast(ctrls, "ui::CRichText");
						ctrls:SetText("{@st42b}x{/}");
						
						ctrls = cbox:CreateOrGetControl("slidebar", "extuislidex"..tostring(k)..tostring(ck), inx+12, iny, 300, 30);
						ctrls = tolua.cast(ctrls, "ui::CSlideBar");						
						ctrls:SetMaxSlideLevel(toc:GetWidth()-w);
						ctrls:SetMinSlideLevel(0);
						ctrls:SetLevel(x);
						ctrls:SetTextTooltip(string.format("{@st42b}Left/Right Position{/}"));
						
						ctrls = cbox:CreateOrGetControl("richtext", "extuilabelvalx"..tostring(k)..tostring(ck), inx+295, iny+5, 300, 30);
						ctrls = tolua.cast(ctrls, "ui::CRichText");
						ctrls:SetText("{@st42b}"..extui.round(x).."{/}");
						
						iny = iny+35;
						
						ctrls = cbox:CreateOrGetControl("richtext", "extuilabely"..tostring(k)..tostring(ck), inx, iny+5, 300, 30);
						ctrls = tolua.cast(ctrls, "ui::CRichText");
						ctrls:SetText("{@st42b}y{/}");
						
						ctrls = cbox:CreateOrGetControl("slidebar", "extuislidey"..tostring(k)..tostring(ck), inx+12, iny, 300, 30);
						ctrls = tolua.cast(ctrls, "ui::CSlideBar");
						ctrls:SetMaxSlideLevel(toc:GetHeight()-h);
						ctrls:SetMinSlideLevel(0);
						ctrls:SetLevel(y);
						ctrls:SetTextTooltip(string.format("{@st42b}Up/Down Position{/}"));
						
						ctrls = cbox:CreateOrGetControl("richtext", "extuilabelvaly"..tostring(k)..tostring(ck), inx+295, iny+5, 300, 30);
						ctrls = tolua.cast(ctrls, "ui::CRichText");
						ctrls:SetText("{@st42b}"..extui.round(y).."{/}");
						
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
	local ctrls = ctrl:CreateOrGetControl("button", "extuibuttonreload", 50, 600-45, 150, 30);
	ctrls = tolua.cast(ctrls, "ui::CButton");
	ctrls:SetText("{@st66b}Reload UI{/}");
	ctrls:SetClickSound("button_click_big");
	ctrls:SetOverSound("button_over");
	ctrls:SetEventScript(ui.LBUTTONUP, "EXTENDEDUI_ON_RELOADUI");
	ctrls:SetSkinName("test_pvp_btn");
	
	local ctrls = ctrl:CreateOrGetControl("button", "extuibuttonsave", 400+15, 600-45, 150, 30);
	ctrls = tolua.cast(ctrls, "ui::CButton");
	ctrls:SetText("{@st66b}Save{/}");
	ctrls:SetClickSound("button_click_big");
	ctrls:SetOverSound("button_over");
	ctrls:SetEventScript(ui.LBUTTONUP, "EXTENDEDUI_ON_SAVE");
	ctrls:SetSkinName("test_pvp_btn");

	local ctrls = ctrl:CreateOrGetControl("button", "extuibuttonrestore", 400-165, 600-45, 150, 30);
	ctrls = tolua.cast(ctrls, "ui::CButton");
	ctrls:SetText("{@st66b}Restore Defaults{/}");
	ctrls:SetClickSound("button_click_big");
	ctrls:SetOverSound("button_over");
	ctrls:SetEventScript(ui.LBUTTONUP, "EXTENDEDUI_ON_RESTORE");
	ctrls:SetSkinName("test_pvp_btn");
	
	local ctrls = ctrl:CreateOrGetControl("button", "extuibuttonclose", 750-150, 600-45, 150, 30);
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

function EXTENDEDUI_ON_CLOSE_UI()
	if extui.unsavedSettings then
		ui.MsgBox("Are you sure you want to close without saving?","R_EXTENDEDUI_ON_CLOSE_UI","Nope");
	else
		extui.close();
	end
end

function R_EXTENDEDUI_ON_CLOSE_UI()
	extui.close();
end

function EXTENDEDUI_ON_OPEN_UI()
	extui.openside();
end

function EXTENDEDUI_ON_DRAG_START_END(frame, argStr)
	extui.IsDragging = not(extui.IsDragging);

	if argStr == "start" then
		extui.selectedFrameParent = ui.GetFrame(frame:GetUserValue("FRAME_NAME"));
		extui.selectedFrame = nil;
	elseif argStr == "startc" then
		extui.selectedFrame = ui.GetFrame(frame:GetUserValue("FRAME_NAME")):GetChild(frame:GetUserValue("CHILD_NAME"));
		extui.selectedFrameParent = ui.GetFrame(frame:GetUserValue("FRAME_NAME"));
	end
end

extui.showAll = false;
--TODO: Needs to use ForEachFrame
function EXTENDEDUI_ON_BUTTON_FRAME_PRESS(frame, ctrl, argStr)
	if argStr == "*all" then
		if not(extui.showAll) then
			extui.OpenMiniFrame();
			for k,v in pairs(extui.frames) do
				if v.isMovable then
					local ss = ui.GetFrame(k);

					local w = ss:GetWidth();
					local h = ss:GetHeight();
					local x = ss:GetX();
					local y = ss:GetY();

					local frm = ui.CreateNewFrame("extendedui", "extuidragframe"..k);
					frm:Resize(w , h);
					frm:MoveFrame(x, y);
					frm:RunUpdateScript("EXTENDEDUI_ON_DRAGGING");
					frm:SetEventScript(ui.LBUTTONDOWN, "EXTENDEDUI_ON_DRAG_START_END");
					frm:SetEventScriptArgString(ui.LBUTTONDOWN, "start");
					frm:SetEventScript(ui.LBUTTONUP, "EXTENDEDUI_ON_DRAG_START_END");
					frm:SetUserValue("FRAME_NAME", k);

					if extui.frames[k].hasChild then
						for ch,_ in pairs(extui.frames[k]["child"]) do
							local chfrm = ui.CreateNewFrame("extendedui", "extuidragframe"..k..ch);
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
							chfrm:SetEventScriptArgString(ui.LBUTTONDOWN, "startc");
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
					local tocc = ui.GetFrame("extuidragframe"..tostring(k));
					if tocc ~= nil then
						tocc:ShowWindow(0);
						if extui.frames[k].hasChild then
							for ch,_ in pairs(extui.frames[k]["child"]) do
								 ui.GetFrame("extuidragframe"..k..ch):ShowWindow(0);
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

			local frm = ui.CreateNewFrame("extendedui", "extuidragframe"..argStr);
			frm:Resize(w , h);
			frm:MoveFrame(x, y);
			frm:RunUpdateScript("EXTENDEDUI_ON_DRAGGING");
			frm:SetEventScript(ui.LBUTTONDOWN, "EXTENDEDUI_ON_DRAG_START_END");
			frm:SetEventScript(ui.LBUTTONUP, "EXTENDEDUI_ON_DRAG_START_END");
			frm:SetUserValue("FRAME_NAME", argStr);

			if extui.frames[argStr].hasChild then
				for ch,_ in pairs(extui.frames[argStr]["child"]) do
					local chfrm = ui.CreateNewFrame("extendedui", "extuidragframe"..argStr..ch);
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
				end
			end
			
			extui.frames[argStr].show = true;
		else
			local tocc = ui.GetFrame("extuidragframe"..argStr);
			if tocc ~= nil then
				tocc:ShowWindow(0);
				if extui.frames[argStr].hasChild then
					for ch,v in pairs(extui.frames[argStr]["child"]) do
						ui.GetFrame("extuidragframe"..argStr..ch):ShowWindow(0);
					end
				end
			end
			extui.frames[argStr].show = false;
		end
	end
end


function extui.listframes()

	if not(extui.isSetting) then
		extui.SavePositions();
	end

	extui.UpdateCheck();


	EXTENDEDUI_LOAD_POSITIONS(nil,"GAME_START");
	extui.print("Reloaded UI");
end

function extui.reload()
	extui.UpdateCheck();

	EXTENDEDUI_LOAD_POSITIONS(nil,"GAME_START");
end

function EXTENDEDUI_ON_RELOADUI()
	extui.isReload = true;
	extui.oldSlider = {};
	extui.UpdateCheck();

	EXTENDEDUI_LOAD_POSITIONS(nil,"GAME_START");
	extui.UpdateSliders();
	extui.print("Reloaded UI");
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

function EXTENDEDUI_ON_DRAGGING(frame)
	if extui.closingSettings then return 0;	end
	if not(extui.IsDragging) then return 1; end
	
	local x = frame:GetX();
	local y = frame:GetY();
	local isFrame = frame:GetUserValue("FRAME_NAME");
	local mFrame = ui.GetFrame(isFrame);
	
	if mFrame ~= nil then
		local xs = mFrame:GetX();
		local ys = mFrame:GetY();
		local doMove = false;

		if x ~= xs or y ~= ys then
			doMove = true;
		end
		
		if doMove then
			mFrame:MoveFrame(x,y);
			extui.framepos[tostring(isFrame)]["x"] = x;
			extui.framepos[tostring(isFrame)]["y"] = y;

			--move the childs
			if extui.frames[isFrame].hasChild then
				for ch,v in pairs(extui.frames[isFrame]["child"]) do
					local chfrm = ui.GetFrame("extuidragframe"..isFrame..ch);

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
			extui.unsavedSettings = true;
		end
	end
	return 1;
end

function EXTENDEDUI_VOID()
end


function EXTENDEDUI_ON_DRAGGING_CHILD(frame)
	if extui.closingSettings then return 0;	end
	if not(extui.IsDragging) then return 1; end
	
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
				extui.unsavedSettings = true;
			end
		end
	end
	return 1;
end


