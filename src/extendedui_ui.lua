--ExtendedUI Menu

if extui == nil then
	extui = {};
end

extui.selectedFrame = nil;
extui.selectedFrameParent = nil;

function EXTENDEDUI_ON_CHECK_HIDE(frame, ctrl, argStr)
	local frm = ui.GetFrame(argStr);
	frm:ShowWindow(ctrl:IsChecked(), true);
	if extui.frames[argStr] then
		if extui.frames[argStr].saveHidden then
			extui.framepos[argStr].hidden = ctrl:IsChecked();
		end
	end
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

		EXTENDEDUI_ON_SAVE();

		local frm = ui.GetFrame("EXTENDEDUI_SIDE_FRAME");
		frm:ShowWindow(0);
		extui.isSetting = false;
		extui.showAll = false;

	end
end

function EXTUI_ON_SLIDE()
	--removed
end

function EXTUI_ON_TAB_CHANGE(frame, ctrl, argStr, argNum)
	local tabObj		    = frame:GetChild("extuitabs");
	local itembox_tab		= tolua.cast(tabObj, "ui::CTabControl");
	local curtabIndex	    = itembox_tab:GetSelectItemIndex();
	
	if curtabIndex == 1 then
		if ui.GetFrame("EXTENDEDUI_MINI_FRAME") == nil then
			extui.showAll = false;
			EXTENDEDUI_ON_BUTTON_FRAME_PRESS(nil,nil,"*all");
			extui.OpenMiniFrame();
		end
		tabObj:SelectTab(0);
	end
end

extui.savedFramePosX = 0;
extui.savedFramePosY = 0;

function EXTENDEDUI_ON_MINI_CANCEL()
	local frm = ui.GetFrame("EXTENDEDUI_MINI_FRAME");
	frm:StopUpdateScript("EXTENDEDUI_MINI_UPDATE");
	frm:ShowWindow(0);

	local mf = ui.GetFrame("EXTENDEDUI_SIDE_FRAME");
	mf:MoveFrame(extui.savedFramePosX, extui.savedFramePosY);

	extui.showAll = true;
	EXTENDEDUI_ON_BUTTON_FRAME_PRESS(nil,nil,"*all");

	extui.reload();
end


function EXTENDEDUI_MINI_ON_SELECT(index, channelID)
	local droplist = ui.GetDropListFrame("EXTENDEDUI_MINI_ON_SELECT");
	
	local frm = ui.GetFrame("EXTENDEDUI_MINI_FRAME");
	local minitext = frm:GetChild("extuiminigrpbox");
	minitext = minitext:GetChild("extuiminitext");
	minitext = tolua.cast(minitext, "ui::CRichText");

	if index == 0 then
		if extui.selectedFrameParent ~= nil then
			extui.frames[extui.selectedFrameParent:GetName()].show = true;
			EXTENDEDUI_ON_BUTTON_FRAME_PRESS(nil, nil, extui.selectedFrameParent:GetName());
		end
		extui.oldSelectedFrameParent = extui.selectedFrameParent;
		extui.selectedFrameParent = nil;
		extui.selectedFrame = nil;
		minitext:SetText(string.format("{@st42b}%s{/}","None Selected"));
		extui.UpdateMiniBox();
		return;
	end

	local selFrame = extui.dropListOptions[index];

	for k,v in pairs(extui.frames) do
		if v.name == selFrame then
			extui.oldSelectedFrameParent = extui.selectedFrameParent;
			extui.selectedFrameParent = ui.GetFrame(k);
			extui.selectedFrame = nil;
			minitext:SetText(string.format("{@st42b}%s{/}",v.name));
			extui.UpdateMiniBox();

			local check_frames = frm:GetChild("extuicheckfram");
			check_frames = tolua.cast(check_frames, "ui::CCheckBox");
			local isChecked = (check_frames:IsChecked() == 1);

			if isChecked then
				if extui.oldSelectedFrameParent ~= nil and extui.oldSelectedFrameParent:GetName() ~= k then
					extui.frames[extui.oldSelectedFrameParent:GetName()].show = true;
					EXTENDEDUI_ON_BUTTON_FRAME_PRESS(nil, nil, extui.oldSelectedFrameParent:GetName());
				end
				extui.frames[k].show = false;

				EXTENDEDUI_ON_BUTTON_FRAME_PRESS(nil, nil, k);
			end
			break;
		end
		if v.hasChild then
			for _k,_v in pairs(v.child) do
				if v.name..".".._v.name == selFrame then
					extui.oldSelectedFrameParent = extui.selectedFrameParent;
					extui.selectedFrame = ui.GetFrame(k):GetChild(_k);
					extui.selectedFrameParent = ui.GetFrame(k);
					minitext:SetText(string.format("{@st42b}%s{/}",v.name.." ==> ".._v.name));
					extui.UpdateMiniBox();

					local check_frames = frm:GetChild("extuicheckfram");
					check_frames = tolua.cast(check_frames, "ui::CCheckBox");
					local isChecked = (check_frames:IsChecked() == 1);

					if isChecked then
						if extui.oldSelectedFrameParent ~= nil and extui.oldSelectedFrameParent:GetName() ~= k then
							extui.frames[extui.oldSelectedFrameParent:GetName()].show = true;
							EXTENDEDUI_ON_BUTTON_FRAME_PRESS(nil, nil, extui.oldSelectedFrameParent:GetName());
						end
						extui.frames[k].show = false;

						EXTENDEDUI_ON_BUTTON_FRAME_PRESS(nil, nil, k);
					end
					break;
				end
			end
		end
	end
end

extui.dropListOptions = {};
function EXTENDEDUI_MINI_CREATE_DROPLIST()
	local frm = ui.GetFrame("EXTENDEDUI_MINI_FRAME");
	local adv_button = frm:GetChild("extuiminiadv");

	local y = -75;

	if adv_button:GetText() ~= "{@st66b}Advanced{/}" then
		y = y-280;
	end

	local ctrls = ui.MakeDropListFrame(frm, 75, y, 200, 30, 10, ui.LEFT, "EXTENDEDUI_MINI_ON_SELECT");
	ui.AddDropListItem("None Selected", "", 1);
	local iii = 1;

	for k,v in pairs(extui.frames) do
		if v.isMovable then
			ui.AddDropListItem(tostring(v.name),"", iii);
			extui.dropListOptions[iii] = tostring(v.name);
			iii = iii+1;
			if v.hasChild then
				for _k,_v in pairs(v.child) do
					ui.AddDropListItem(" ==>"..tostring(_v.name), "", iii);
					extui.dropListOptions[iii] = tostring(v.name).."."..tostring(_v.name);
					iii = iii+1;
				end
			end
		end
	end
end

function EXTENDEDUI_MINI_ON_CHECK(frame, ctrl)
	local isChecked = (ctrl:IsChecked() == 1);

	local frm = extui.selectedFrameParent;

	if isChecked and frm ~= nil then
		extui.showAll = true;
		EXTENDEDUI_ON_BUTTON_FRAME_PRESS(nil, nil, "*all", frm:GetName());
	elseif isChecked then
		extui.showAll = true;
		EXTENDEDUI_ON_BUTTON_FRAME_PRESS(nil, nil, "*all");
	else
		extui.showAll = false;
		EXTENDEDUI_ON_BUTTON_FRAME_PRESS(nil, nil, "*all");
	end
end

function EXTENDEDUI_ON_MINI_ADVANCED()
	local frm = ui.GetFrame("EXTENDEDUI_MINI_FRAME");
	frm:Resize(350, 400);
	frm:MoveFrame(frm:GetX(), frm:GetY()-200);

	local button_adv = frm:GetChild("extuiminiadv");
	local button_close = frm:GetChild("extuiminiclose");
	local button_save = frm:GetChild("extuiminisaveclose");

	button_adv:SetOffset((350/2)-(125/2), 400-35-30);
	button_close:SetOffset(175, 400-35);
	button_save:SetOffset(50, 400-35);

	button_adv:SetEventScript(ui.LBUTTONUP, "EXTENDEDUI_ON_MINI_LESS");
	button_adv:SetText("{@st66b}Less{/}");

	local settingbox = frm:GetChild("extuiminigrpsetbox");
	settingbox:ShowWindow(1);

	extui.UpdateMiniBox();
end

function extui.UpdateMiniBox()
	local frm = ui.GetFrame("EXTENDEDUI_MINI_FRAME");
	local settingbox = frm:GetChild("extuiminigrpsetbox");
	settingbox = tolua.cast(settingbox, "ui::CGroupBox");
	settingbox:DeleteAllControl();

	local frame = extui.selectedFrameParent;
	local cframe = extui.selectedFrame;
	local v = extui.frames[frame:GetName()];

	if cframe ~= nil then
		v = extui.frames[frame:GetName()].child[cframe:GetName()];
	end

	if frame ~= nil then
		extui.MiniCreateSliderForFrame(10, 55, settingbox, v);
	end
end

function EXTENDEDUI_ON_MINI_LESS()
	local frm = ui.GetFrame("EXTENDEDUI_MINI_FRAME");
	frm:Resize(350, 120);
	frm:MoveFrame(frm:GetX(), frm:GetY()+200);

	local button_adv = frm:GetChild("extuiminiadv");
	local button_close = frm:GetChild("extuiminiclose");
	local button_save = frm:GetChild("extuiminisaveclose");

	button_adv:SetOffset((350/2)-(125/2), 85-30);
	button_close:SetOffset(175, 85);
	button_save:SetOffset(50, 85);

	button_adv:SetEventScript(ui.LBUTTONUP, "EXTENDEDUI_ON_MINI_ADVANCED");
	button_adv:SetText("{@st66b}Advanced{/}");

	local settingbox = frm:GetChild("extuiminigrpsetbox");
	settingbox:ShowWindow(0);
	settingbox:DeleteAllControl();
end


function EXTENDEDUI_MINI_UPDATE()
	local frame = extui.selectedFrameParent;
	local cframe = extui.selectedFrame;

	if frame ~= nil then
		local frm = ui.GetFrame("EXTENDEDUI_MINI_FRAME");
		if frm == nil then return 0; end

		local minitext = frm:GetChild("extuiminigrpbox");
		minitext = minitext:GetChild("extuiminitext");
		minitext = tolua.cast(minitext, "ui::CRichText");

		local selFrame = frame:GetName();
		selFrame = extui.frames[selFrame].name;

		if cframe ~= nil then
			selFrame = selFrame.." ==> "..extui.frames[frame:GetName()].child[cframe:GetName()].name;
		end

		selFrame = string.format("{@st42b}%s{/}",selFrame);

		if minitext:GetText() ~= selFrame then
			local check_frames = frm:GetChild("extuicheckfram");
			check_frames = tolua.cast(check_frames, "ui::CCheckBox");
			local isChecked = (check_frames:IsChecked() == 1);

			if isChecked then
				if extui.oldSelectedFrameParent ~= nil and extui.oldSelectedFrameParent:GetName() ~= frame:GetName() then
					extui.frames[extui.oldSelectedFrameParent:GetName()].show = true;
					EXTENDEDUI_ON_BUTTON_FRAME_PRESS(nil, nil, extui.oldSelectedFrameParent:GetName());
				end
				extui.frames[frame:GetName()].show = false;

				EXTENDEDUI_ON_BUTTON_FRAME_PRESS(nil, nil, frame:GetName());
			end
			minitext:SetText(selFrame);
			extui.UpdateMiniBox();
		end

		local frameName = frame:GetName();
		if cframe ~= nil then
			frameName = cframe:GetName();
		end


		local settingbox = frm:GetChild("extuiminigrpsetbox");
		local labelvalx = settingbox:GetChild("extuilabelvalx");
		if labelvalx then
			local sliderx = settingbox:GetChild("extuislidex");
			sliderx = tolua.cast(sliderx, "ui::CSlideBar");
			local labelvaly = settingbox:GetChild("extuilabelvaly");
			local slidery = settingbox:GetChild("extuislidey");
			slidery = tolua.cast(slidery, "ui::CSlideBar");

			local x = 0;
			local y = 0;
			if cframe == nil then
				x = extui.framepos[frameName].x;
				y = extui.framepos[frameName].y;
			else
				x = extui.framepos[frame:GetName()].child[frameName].x;
				y = extui.framepos[frame:GetName()].child[frameName].y;
			end

			if (x ~= sliderx:GetLevel() or y ~= slidery:GetLevel()) and not(extui.IsDragging) then

				if cframe == nil then
					extui.framepos[frameName].x = sliderx:GetLevel();
					extui.framepos[frameName].y = slidery:GetLevel();
					x = extui.framepos[frameName].x;
					y = extui.framepos[frameName].y;

					local tcc = ui.GetFrame("extuidragframe"..frameName);
					if tcc ~= nil then
						tcc:MoveFrame(x, y);
						if extui.frames[frameName].hasChild then
							for ch,v in pairs(extui.frames[frameName]["child"]) do
								local chfrm = ui.GetFrame("extuidragframe"..frameName..ch);

								local ssc = frame:GetChild(ch);
								local xc = ssc:GetX();
								local yc = ssc:GetY();

								chfrm:MoveFrame(x+xc, y+yc);

								if frameName == "buff" or frameName == "targetbuff" then
									extui.MoveBuffCaption(frameName, ch);
								end
							end
						end
					end

					if frameName == "targetinfo" then
						extui.TargetInfoUpdate(x,y);
					end

					frame:MoveFrame(x, y);
				else
					extui.framepos[frame:GetName()].child[frameName].x = sliderx:GetLevel();
					extui.framepos[frame:GetName()].child[frameName].y = slidery:GetLevel();
					x = extui.framepos[frame:GetName()].child[frameName].x;
					y = extui.framepos[frame:GetName()].child[frameName].y;

					local tcc = ui.GetFrame("extuidragframe"..frame:GetName()..frameName);
					if tcc ~= nil then
						local xm = frame:GetX();
						local ym = frame:GetY();
						tcc:MoveFrame(xm+x, ym+y);
					end

					if frame:GetName() == "buff" or frame:GetName() == "targetbuff" then
						extui.MoveBuffCaption(frame:GetName(), frameName);
						local slotc = extui.GetSetting("rowamt");
						local rowc = extui.round(30/slotc);

						cframe:Resize(slotc*extui.GetSetting("iconsize"),rowc*extui.GetSetting("iconsize"));
					end
					
					cframe:SetOffset(x, y);
				end
			end

			labelvalx:SetText(string.format("{@st42b}%d{/}",extui.round(x)));
			labelvaly:SetText(string.format("{@st42b}%d{/}",extui.round(y)));
			sliderx:SetLevel(x);
			slidery:SetLevel(y);


			if cframe == nil then
				if not(extui.frames[frameName].noResize) then
					local labelvalw = settingbox:GetChild("extuilabelvalw");
					local sliderw = settingbox:GetChild("extuislidew");
					sliderw = tolua.cast(sliderw, "ui::CSlideBar");
					local labelvalh = settingbox:GetChild("extuilabelvalh");
					local sliderh = settingbox:GetChild("extuislideh");
					sliderh = tolua.cast(sliderh, "ui::CSlideBar");

					local w = extui.framepos[frameName].w;
					local h = extui.framepos[frameName].h;

					if (w ~= sliderx:GetLevel() or h ~= slidery:GetLevel()) and not(extui.IsDragging)  then
						extui.framepos[frameName].w = sliderw:GetLevel();
						extui.framepos[frameName].h = sliderh:GetLevel();
						w = extui.framepos[frameName].w;
						h = extui.framepos[frameName].h;
						local tcc = ui.GetFrame("extuidragframe"..frameName);
						if tcc ~= nil then
							tcc:Resize(w, h);
						end

						frame:Resize(w, h);
					end


					labelvalw:SetText(string.format("{@st42b}%d{/}",extui.round(w)));
					labelvalh:SetText(string.format("{@st42b}%d{/}",extui.round(h)));
					sliderw:SetLevel(w);
					sliderh:SetLevel(h);
				end
			end

		end

	end

	return 1;
end

function EXTENDEDUI_ON_MINI_SAVE()
	local frm = ui.GetFrame("EXTENDEDUI_MINI_FRAME");
	frm:StopUpdateScript("EXTENDEDUI_MINI_UPDATE");
	frm:ShowWindow(0);

	local mf = ui.GetFrame("EXTENDEDUI_SIDE_FRAME");
	mf:MoveFrame(extui.savedFramePosX, extui.savedFramePosY);

	extui.showAll = true;
	EXTENDEDUI_ON_BUTTON_FRAME_PRESS(nil,nil,"*all");

	EXTENDEDUI_ON_SAVE();
end

function extui.OpenMiniFrame()
	extui.oldSelectedFrameParent = nil;
	extui.selectedFrameParent = nil;
	extui.selectedFrame = nil;

	local mf = ui.GetFrame("EXTENDEDUI_SIDE_FRAME");
	extui.savedFramePosX = mf:GetX();
	extui.savedFramePosY = mf:GetY();
	mf:MoveFrame(9999,9999);--move frame out of view

	local frm = ui.CreateNewFrame("extendedui", "EXTENDEDUI_MINI_FRAME");
	frm:Resize(350 , 120);
	frm:MoveFrame((ui.GetSceneWidth()/2)-175, (ui.GetSceneHeight()/2)-50);
	frm:SetSkinName("pip_simple_frame");

	--buttons
	local ctrls = frm:CreateOrGetControl("button", "extuiminisaveclose", 50, 85, 125, 30);
	ctrls = tolua.cast(ctrls, "ui::CButton");
	ctrls:SetText("{@st66b}Save&Close{/}");
	ctrls:SetClickSound("button_click_big");
	ctrls:SetOverSound("button_over");
	ctrls:SetEventScript(ui.LBUTTONUP, "EXTENDEDUI_ON_MINI_SAVE");
	ctrls:SetSkinName("test_pvp_btn");

	ctrls = frm:CreateOrGetControl("button", "extuiminiclose", 175, 85, 125, 30);
	ctrls = tolua.cast(ctrls, "ui::CButton");
	ctrls:SetText("{@st66b}Cancel{/}");
	ctrls:SetClickSound("button_click_big");
	ctrls:SetOverSound("button_over");
	ctrls:SetEventScript(ui.LBUTTONUP, "EXTENDEDUI_ON_MINI_CANCEL");
	ctrls:SetSkinName("test_pvp_btn");

	ctrls = frm:CreateOrGetControl("button", "extuiminiadv", (350/2)-(125/2), 85-30, 125, 30);
	ctrls = tolua.cast(ctrls, "ui::CButton");
	ctrls:SetText("{@st66b}Advanced{/}");
	ctrls:SetClickSound("button_click_big");
	ctrls:SetOverSound("button_over");
	ctrls:SetEventScript(ui.LBUTTONUP, "EXTENDEDUI_ON_MINI_ADVANCED");
	ctrls:SetSkinName("test_pvp_btn");


	ctrls = frm:CreateOrGetControl("checkbox", "extuicheckfram", (350/2)+110, 15, 150, 30);
	ctrls = tolua.cast(ctrls, "ui::CCheckBox");
	--ctrls:SetText(" ");
	ctrls:SetEventScript(ui.LBUTTONUP, "EXTENDEDUI_MINI_ON_CHECK");
	ctrls:SetClickSound("button_click_big");
	ctrls:SetOverSound("button_over");
	ctrls:SetTextTooltip("{@st42b}Only edit selected frame{/}");

	ctrls = frm:CreateOrGetControl("groupbox", "extuiminigrpbox", (350/2)-100, 15, 200, 30);
	ctrls = tolua.cast(ctrls, "ui::CGroupBox");
	ctrls:SetSkinName("property_screenbg");
	ctrls:EnableScrollBar(0);
	ctrls:EnableHittestGroupBox(false);

	local ctrlss = ctrls:CreateOrGetControl("richtext", "extuiminitext", 5, 5, 30, 30);
	ctrlss = tolua.cast(ctrlss, "ui::CRichText");
	ctrlss:SetText("{@st42b}None Selected{/}");

	local ctrlss = ctrls:CreateOrGetControl("button", "extuiminidropbut", 200-35, 0, 30, 30);
	ctrlss = tolua.cast(ctrlss, "ui::CButton");
	ctrlss:EnableImageStretch(false);
	ctrlss:SetImage("count_down_btn");
	ctrlss:SetEventScript(ui.LBUTTONUP, "EXTENDEDUI_MINI_CREATE_DROPLIST");

	local gbox = frm:CreateOrGetControl("groupbox", "extuiminigrpsetbox", 0, 0, 350, 400);
	gbox = tolua.cast(gbox, "ui::CGroupBox");
	gbox:SetSkinName("");
	gbox:EnableScrollBar(0);
	gbox:EnableHittestGroupBox(false);
	gbox:ShowWindow(0);

	frm:RunUpdateScript("EXTENDEDUI_MINI_UPDATE");
end



function extui.MiniCreateSliderForFrame(inx, iny, gbox, v)
	local cframe = extui.selectedFrame;
	local frame = extui.selectedFrameParent;

	local x = frame:GetX();
	local y = frame:GetY();

	if cframe ~= nil then
		x = cframe:GetX();
		y = cframe:GetY();
	end

	ctrls = gbox:CreateOrGetControl("richtext", "extuilabelpos", inx, iny, 300, 30);
	ctrls = tolua.cast(ctrls, "ui::CRichText");
	ctrls:SetText("{@st42b}Position{/}");
	
	iny = iny+10;
	
	ctrls = gbox:CreateOrGetControl("richtext", "extuilabelx", inx, iny+5, 300, 30);
	ctrls = tolua.cast(ctrls, "ui::CRichText");
	ctrls:SetText("{@st42b}x{/}");
	
	ctrls = gbox:CreateOrGetControl("slidebar", "extuislidex", inx+12, iny, 300, 30);
	ctrls = tolua.cast(ctrls, "ui::CSlideBar");
	ctrls:SetMaxSlideLevel(ui.GetClientInitialWidth());
	ctrls:SetMinSlideLevel(0);
	ctrls:SetLevel(x);
	ctrls:SetTextTooltip("{@st42b}Left/Right Position{/}");
	
	ctrls = gbox:CreateOrGetControl("richtext", "extuilabelvalx", inx+295, iny+5, 300, 30);
	ctrls = tolua.cast(ctrls, "ui::CRichText");
	ctrls:SetText( string.format("{@st42b}%d{/}", extui.round(x)) );

	iny = iny+35;
	
	ctrls = gbox:CreateOrGetControl("richtext", "extuilabely", inx, iny+5, 300, 30);
	ctrls = tolua.cast(ctrls, "ui::CRichText");
	ctrls:SetText("{@st42b}y{/}");

	ctrls = gbox:CreateOrGetControl("slidebar", "extuislidey", inx+12, iny, 300, 30);
	ctrls = tolua.cast(ctrls, "ui::CSlideBar");
	ctrls:SetMaxSlideLevel(ui.GetClientInitialHeight());
	ctrls:SetMinSlideLevel(0);
	ctrls:SetLevel(y);
	ctrls:SetTextTooltip("{@st42b}Up/Down Position{/}");
	
	ctrls = gbox:CreateOrGetControl("richtext", "extuilabelvaly", inx+295, iny+5, 300, 30);
	ctrls = tolua.cast(ctrls, "ui::CRichText");
	ctrls:SetText( string.format("{@st42b}%d{/}", extui.round(y)) );

	iny = iny+35;

	if cframe == nil then
		if not(v.noResize) then
			local w = frame:GetWidth();
			local h = frame:GetHeight();

			ctrls = gbox:CreateOrGetControl("richtext", "extuilabelsize", inx, iny, 300, 30);
			ctrls = tolua.cast(ctrls, "ui::CRichText");
			ctrls:SetText("{@st42b}Size{/}");
			
			iny = iny+10;
			
			ctrls = gbox:CreateOrGetControl("richtext", "extuilabelw", inx, iny+5, 300, 30);
			ctrls = tolua.cast(ctrls, "ui::CRichText");
			ctrls:SetText("{@st42b}w{/}");
			
			ctrls = gbox:CreateOrGetControl("slidebar", "extuislidew", inx+12, iny, 300, 30);
			ctrls = tolua.cast(ctrls, "ui::CSlideBar");
			ctrls:SetMaxSlideLevel(ui.GetClientInitialWidth());
			ctrls:SetMinSlideLevel(0);
			ctrls:SetLevel(w);
			ctrls:SetTextTooltip("{@st42b}Width{/}");
			
			ctrls = gbox:CreateOrGetControl("richtext", "extuilabelvalw", inx+295, iny+5, 300, 30);
			ctrls = tolua.cast(ctrls, "ui::CRichText");
			ctrls:SetText( string.format("{@st42b}%d{/}", extui.round(w)) );
			
			iny = iny+35;
			
			ctrls = gbox:CreateOrGetControl("richtext", "extuilabelh", inx, iny+5, 300, 30);
			ctrls = tolua.cast(ctrls, "ui::CRichText");
			ctrls:SetText("{@st42b}h{/}");
			
			ctrls = gbox:CreateOrGetControl("slidebar", "extuislideh", inx+12, iny, 300, 30);
			ctrls = tolua.cast(ctrls, "ui::CSlideBar");
			ctrls:SetMaxSlideLevel(ui.GetClientInitialHeight());
			ctrls:SetMinSlideLevel(0);
			ctrls:SetLevel(h);
			ctrls:SetTextTooltip("{@st42b}Height{/}");
			
			ctrls = gbox:CreateOrGetControl("richtext", "extuilabelvalh", inx+295, iny+5, 300, 30);
			ctrls = tolua.cast(ctrls, "ui::CRichText");
			ctrls:SetText( string.format("{@st42b}%d{/}", extui.round(h)) );
			
			iny = iny+35;
		
		end

		ctrls = gbox:CreateOrGetControl("richtext", "extuilabelskin", inx, iny, 300, 30);
		ctrls = tolua.cast(ctrls, "ui::CRichText");
		ctrls:SetText( string.format("{@st42b}Current Skin: %s{/}", tostring(extui.framepos[frame:GetName()].skin)) );
		iny = iny+15;

		ctrls = gbox:CreateOrGetControl("button", "extuisetskin", inx+10, iny, 125, 30);
		ctrls = tolua.cast(ctrls, "ui::CButton");
		ctrls:SetText("{@st66b}Set Skin{/}");
		ctrls:SetClickSound("button_click_big");
		ctrls:SetOverSound("button_over");
		ctrls:SetEventScript(ui.LBUTTONUP, "EXTENDEDUI_OPEN_CONTEXT");
		ctrls:SetSkinName("test_pvp_btn");

		iny = iny+35;

		ctrls = gbox:CreateOrGetControl("checkbox", "extuicheckvis", inx+10, iny, 150, 30);
		ctrls = tolua.cast(ctrls, "ui::CCheckBox");
		ctrls:SetText("{@st42b}Show Frame{/}");
		ctrls:SetClickSound("button_click_big");
		ctrls:SetOverSound("button_over");
		ctrls:SetEventScript(ui.LBUTTONUP, "EXTENDEDUI_ON_CHECK_HIDE");
		ctrls:SetEventScriptArgString(ui.LBUTTONUP, frame:GetName());
		ctrls:SetCheck(frame:IsVisible());
		if v.saveHidden then
			ctrls:SetColorTone("FF00FF00");
			ctrls:SetTextTooltip("{@st42b}Visibility will be saved{/}");
		else
			ctrls:SetColorTone("FFFF0000");
			ctrls:SetTextTooltip("{@st42b}Visibility will not be saved{/}");
		end

	end
end


function EXTENDEDUI_OPEN_CONTEXT()
	local ctx = ui.CreateContextMenu("EXTENDEDUI_CONTEXT", "Choose Skin", 0, 0, 300, 100);

	for i = 1,#extui.skins do
		ui.AddContextMenuItem(ctx, extui.skins[i], string.format("EXTENDEDUI_SKIN('%s')", extui.skins[i]));
	end
	ctx:Resize(300, ctx:GetHeight());

	ui.OpenContextMenu(ctx);
end

function EXTENDEDUI_SKIN(skin)
	local frm = extui.selectedFrameParent;
	frm:SetSkinName(skin);
	--oops!
	extui.framepos[frm:GetName()].skin = skin;

	frm = ui.GetFrame("EXTENDEDUI_MINI_FRAME");
	local box = frm:GetChild("extuiminigrpsetbox");
	local ctrl = box:GetChild("extuilabelskin");
	ctrl = tolua.cast(ctrl, "ui::CRichText");
	ctrl:SetText( string.format("{@st42b}Current Skin: %s{/}", tostring(skin)) );
end

function EXTENDEDUI_ON_CLOSE_UI()
	if ui.GetFrame("EXTENDEDUI_MINI_FRAME") ~= nil then
		EXTENDEDUI_ON_MINI_CANCEL();
	end
	extui.close();
end

function EXTENDEDUI_ON_OPEN_UI()
	extui.openside();
end

extui.oldSelectedFrameParent = nil;

function EXTENDEDUI_ON_DRAG_START_END(frame, argStr)
	if argStr == "start" then
		extui.oldSelectedFrameParent = extui.selectedFrameParent;
		extui.selectedFrameParent = ui.GetFrame(frame:GetUserValue("FRAME_NAME"));
		extui.selectedFrame = nil;
		extui.IsDragging = true;
	elseif argStr == "startc" then
		extui.oldSelectedFrameParent = extui.selectedFrameParent;
		extui.selectedFrame = ui.GetFrame(frame:GetUserValue("FRAME_NAME")):GetChild(frame:GetUserValue("CHILD_NAME"));
		extui.selectedFrameParent = ui.GetFrame(frame:GetUserValue("FRAME_NAME"));
		extui.IsDragging = true;
	else
		extui.IsDragging = false;
	end
end


extui.showAll = false;
--TODO: Needs to use ForEachFrame
function EXTENDEDUI_ON_BUTTON_FRAME_PRESS(frame, ctrl, argStr, exclude)
	if exclude == nil then exclude = ""; end

	if argStr == "*all" then
		if not(extui.showAll) then

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
							local ssc = ss:GetChild(ch);
							local wc = ssc:GetWidth();
							local hc = ssc:GetHeight();
							local xc = ssc:GetX();
							local yc = ssc:GetY();

							local chfrm = ui.CreateNewFrame("extendedui", "extuidragframe"..k..ch);
							chfrm:Resize(wc , hc);
							chfrm:SetOffset(x+xc, y+yc);
							chfrm:SetUserValue("FRAME_NAME", k);
							chfrm:SetUserValue("CHILD_NAME", ch);
							chfrm:RunUpdateScript("EXTENDEDUI_ON_DRAGGING_CHILD");
							chfrm:SetEventScript(ui.LBUTTONDOWN, "EXTENDEDUI_ON_DRAG_START_END");
							chfrm:SetEventScriptArgString(ui.LBUTTONDOWN, "startc");
							chfrm:SetEventScript(ui.LBUTTONUP, "EXTENDEDUI_ON_DRAG_START_END");
						end
					end
					
					extui.frames[k].show = true;
				end
			end
			extui.showAll = true;
		else
			for k,v in pairs(extui.frames) do
				if v.isMovable and v.show then
					if k ~= exclude then
						local tocc = ui.GetFrame("extuidragframe"..tostring(k));
						if tocc ~= nil then
							tocc:StopUpdateScript("EXTENDEDUI_ON_DRAGGING");
							tocc:ShowWindow(0);
							if extui.frames[k].hasChild then
								for ch,_ in pairs(extui.frames[k]["child"]) do
									 local chf = ui.GetFrame("extuidragframe"..k..ch);
									 chf:StopUpdateScript("EXTENDEDUI_ON_DRAGGING_CHILD");
									 chf:ShowWindow(0);
								end
							end
						end
						v.show = false;
					end
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
			frm:SetEventScriptArgString(ui.LBUTTONDOWN, "start");
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
					chfrm:SetEventScriptArgString(ui.LBUTTONDOWN, "startc");
					chfrm:SetEventScript(ui.LBUTTONUP, "EXTENDEDUI_ON_DRAG_START_END");
				end
			end
			
			extui.frames[argStr].show = true;
		else
			local tocc = ui.GetFrame("extuidragframe"..argStr);
			if tocc ~= nil then
				tocc:StopUpdateScript("EXTENDEDUI_ON_DRAGGING");
				tocc:ShowWindow(0);
				if extui.frames[argStr].hasChild then
					for ch,v in pairs(extui.frames[argStr]["child"]) do
						local chf = ui.GetFrame("extuidragframe"..argStr..ch);
						chf:StopUpdateScript("EXTENDEDUI_ON_DRAGGING_CHILD");
						chf:ShowWindow(0);
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

					chfrm:MoveFrame(x+xc, y+yc);

					if isFrame == "buff" or isFrame == "targetbuff" then
						extui.MoveBuffCaption(isFrame, ch);
					end
				end
			end
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

				if isFrame == "buff" or isFrame == "targetbuff" then
					extui.MoveBuffCaption(isFrame, isChild);
				end
			end
		end
	end
	return 1;
end

function extui.UpdateSliders()
	--removed
end

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
	
	--buttons
	local ctrls = ctrl:CreateOrGetControl("button", "extuibuttonreload", 50, 600-45, 150, 30);
	ctrls = tolua.cast(ctrls, "ui::CButton");
	ctrls:SetText("{@st66b}Reload UI{/}");
	ctrls:SetClickSound("button_click_big");
	ctrls:SetOverSound("button_over");
	ctrls:SetEventScript(ui.LBUTTONUP, "EXTENDEDUI_ON_RELOADUI");
	ctrls:SetSkinName("test_pvp_btn");

	local ctrls = ctrl:CreateOrGetControl("button", "extuibuttonrestore", 400-75, 600-45, 150, 30);
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

	extui.sideFrame:GetChild("extuiboxs"):ShowWindow(1);
end
