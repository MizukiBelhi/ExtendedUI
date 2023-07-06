--ExtendedUI Menu

if extui == nil then
	extui = {};
end

extui.selectedFrame = nil;
extui.selectedFrameParent = nil;
extui.selectedAddon = nil;
extui.selectedChildFrame = nil;
extui.isFrameOpen = false;

function EXTENDEDUI_ON_CHECK_HIDE(frame, ctrl, argStr)
	local frm = ui.GetFrame(argStr);
	frm:ShowWindow(ctrl:IsChecked(), true);

	local eframe = extui.GetFrame(argStr);
	if eframe then
		if eframe.saveHidden then
			extui.framepos[argStr].hidden = ctrl:IsChecked();
		end
	end
end

function EXTENDEDUI_ON_CHECK_HIDECHILD(frame, ctrl, argStr)
	local frm = ui.GetFrame(argStr);
	if frm == nil then
		return;
	end

	if extui.selectedFrame == nil then
		return;
	end
	
	local tcc = frm.GetChild(extui.selectedFrame.GetName());
	if tcc == nil then
		return;
	end
	
	tcc:SetVisible(ctrl:IsChecked());

	local eframe = extui.GetFrame(argStr);
	if eframe then
		extui.framepos[tostring(argStr)]["child"][tostring(c)]["isHidden"] = ctrl:IsChecked();
	end
end
tcc:ShowWindow(extui.framepos[tostring(k)].hidden, extui.framepos[tostring(k)]["child"][tostring(ck)]["isHidden"]);

function EXTENDEDUI_ON_CHECK_UPDATE(frame, ctrl, argStr)
	local frm = ui.GetFrame(argStr);
	local chk = ctrl:IsChecked();

	local eframe = extui.GetFrame(argStr);
	if eframe then
		extui.framepos[argStr].alwaysupdate = chk == 1 and true or false;
		
		if chk == 1 then
			frm:RunUpdateScript("EXTENDEDUI_FULLFRAME_UPDATE");
		else
			frm:StopUpdateScript("EXTENDEDUI_FULLFRAME_UPDATE");
		end
	end
end


function EXTENDEDUI_ON_CHECK_HOVER(frame, ctrl, argStr)
	local frm = ui.GetFrame(argStr);
	frm:ShowWindow(ctrl:IsChecked() == 1 and 0 or 1, true);

	local eframe = extui.GetFrame(argStr);
	if eframe then
		extui.framepos[argStr].hover = ctrl:IsChecked();
		
		if ctrl:IsChecked() == 1 then
			extui.hoverFrames[argStr] = true;
		else
			extui.hoverFrames[argStr] = nil;
		end
	end
end

function extui.IsEditOnlyFrameChecked()
	return true;
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
	if ui.GetFrame("EXTENDEDUI_SIDE_FRAME") ~= nil then
		extui.closingSettings = true;

		EXTENDEDUI_ON_SAVE();

		local frm = ui.GetFrame("EXTENDEDUI_SIDE_FRAME");
		frm:ShowWindow(0);
		extui.isSetting = false;
		extui.showAll = false;

	end
	
	extui.isFrameOpen = false;
	extui.selectedChild = false;
end


extui.savedFramePosX = 0;
extui.savedFramePosY = 0;


function EXTENDEDUI_ON_MINI_CANCEL()
	local frm = ui.GetFrame("EXTENDEDUI_MINI_FRAME");
	frm:StopUpdateScript("EXTENDEDUI_MINI_UPDATE");
	frm:ShowWindow(0);
	extui.close();
	extui.HideGrid();

	extui.HideAllFrameBorders();

	extui.reload();
end

function EXTENDEDUI_MINI_ON_SELECT(index)
	local s, bl = pcall(EXTENDEDUI_MINI_ON_SELECTD, index);
	if not(s) then
		extui.print("[EUI] MiniOnSelect(): "..bl);
	end
end


function EXTENDEDUI_MINI_ON_SELECTD(index)
	local droplist = ui.GetDropListFrame("EXTENDEDUI_MINI_ON_SELECT");
	extui.selectedChild = false;
	
	local frm = ui.GetFrame("EXTENDEDUI_MINI_FRAME");
	local minitext = frm:GetChild("extuiminigrpbox");
	minitext = minitext:GetChild("extuiminitext");
	minitext = tolua.cast(minitext, "ui::CRichText");

	if index == 0 then
		
		extui.HideAllFrameBorders();
		
		extui.selectedFrameParent = nil;
		extui.selectedFrame = nil;
		
		minitext:SetText(string.format("{@st42b}%s{/}",extui.TLang("noSelect")));
		extui.UpdateMiniBox();
		return;
	end

	local selFrameName = extui.dropListOptions[index];
	
	
	local parentFrameName,childFrameName = string.match(selFrameName,"([^.]*).(.*)");
	
	if string.len(childFrameName) == 0 then
		parentFrameName = selFrameName;
	end
	
	if extui.oldSelectedFrameParent ~= nil then

		extui.oldSelectedFrameParent:ShowWindow(extui.oldSelectedFrameParent:GetUserValue("EUI_OLD_VISIBLE"), true);
		extui.oldSelectedFrameParent:SetUserValue("EUI_IS_DRAGGING", 0);

	end
	
	if string.len(childFrameName) ~= 0 then
		local selFrame = extui.GetFrameDirect(parentFrameName);
		local selChildFrame = selFrame.child[childFrameName];
		
		if selChildFrame ~= nil then
			minitext:SetText(string.format("{@st42b}%s{/}",selFrame.name.." ==> "..selChildFrame.name));
			
			extui.oldSelectedFrameParent = extui.selectedFrameParent;
			extui.selectedFrameParent = ui.GetFrame(selFrame.frameName);
			extui.selectedFrame = extui.selectedFrameParent:GetChild(selChildFrame.frameName);
			
			extui.selectedFrameParent:SetUserValue("EUI_OLD_VISIBLE", extui.selectedFrameParent:IsVisible());
			extui.selectedFrameParent:ShowWindow(1, true);
			
			extui.selectedChild = true;
			extui.ShowFrameBorder(selFrame, selChildFrame);
			
			extui.UpdateMiniBox();
			return;
		end
	else
	
		if string.len(parentFrameName) ~= 0 then
			local selFrame = extui.GetFrameDirect(parentFrameName);
			extui.oldSelectedFrameParent = extui.selectedFrameParent;
			extui.selectedFrameParent = ui.GetFrame(selFrame.frameName);
			
			extui.selectedFrame = nil;
			
			minitext:SetText(string.format("{@st42b}%s{/}", selFrame.name));

			extui.selectedFrameParent:SetUserValue("EUI_OLD_VISIBLE", extui.selectedFrameParent:IsVisible());
			extui.selectedFrameParent:ShowWindow(1, true);
			
			extui.selectedChild = false;
			extui.ShowFrameBorder(selFrame);
			
			extui.UpdateMiniBox();
		end
	end
	
	
end

function EXTENDEDUI_MINI_CREATE_DROPLIST()

	local t,p = pcall(EXTENDEDUI_MINI_CREATE_DROPLIST_S);
	if not(t) then
		extui.print("[EUI] CreateDroplist(): "..tostring(p));
	end

end

--[[
	"joystickrestquickslot"
	"joystickquickslot"
	"restquickslot"
	"quickslotnexpbar"
]]

function extui.IsDisabledFrame(frameName)
	local isJoyMode = (IsJoyStickMode() == 1);

	if frameName == "joystickquickslot" or frameName == "joystickrestquickslot" then
		if isJoyMode then
			return false;
		else
			return true;
		end
	end
	
	if frameName == "restquickslot" or frameName == "quickslotnexpbar" then
		if isJoyMode then
			return true;
		else
			return false;
		end
	end
	
	return false;
end



extui.dropListOptions = {};
function EXTENDEDUI_MINI_CREATE_DROPLIST_S()
	local frm = ui.GetFrame("EXTENDEDUI_MINI_FRAME");
	local adv_button = frm:GetChild("extuiminiadv");

	local y = -75;

	if adv_button:GetText() ~= "{@st66b}"..extui.TLang("advanced").."{/}" then
		y = y-300;
	end

	local ctrls = ui.MakeDropListFrame(frm, 75, y, 200, 30, 10, ui.LEFT, "EXTENDEDUI_MINI_ON_SELECT", nil, nil);

	ui.AddDropListItem(extui.TLang("noSelect"), "", 1);
	local iii = 1;

	extui.ForEachFrameS(function(k,v)

		if v.isMovable and extui.IsDisabledFrame(tostring(v.name)) ~= true then		
			ui.AddDropListItem(tostring(v.name),"", iii);
			extui.dropListOptions[iii] = tostring(k);
			iii = iii+1;
			if v.hasChild then
				for _k,_v in pairs(v.child) do
					ui.AddDropListItem("==>"..tostring(_v.name), "", iii);
					extui.dropListOptions[iii] = tostring(k).."."..tostring(_k);
					iii = iii+1;
				end
			end
		end
	end);
end


extui.dropListAddonOptions = {};
function EXTENDEDUI_MINI_CREATE_ADDONLIST()
	local frm = ui.GetFrame("EXTENDEDUI_MINI_FRAME");
	local ctrls = ui.MakeDropListFrame(frm, (350/2)+130, 15, 200, 30, 10, ui.LEFT, "EXTENDEDUI_MINI_ON_ADDON_SELECT");

	extui.dropListAddonOptions[1] = "UI";
	ui.AddDropListItem("UI", "", 1);
	local iii = 1;

	for k,v in pairs(extui.Addons) do
		if v.name ~= "UI" then
			ui.AddDropListItem(v.name, "", iii);
			extui.dropListAddonOptions[iii+1] = v.name
			iii = iii+1;
		end
	end
end

function EXTENDEDUI_ON_MINI_ADVANCED()
	local frm = ui.GetFrame("EXTENDEDUI_MINI_FRAME");
	frm:Resize(350, 420);
	frm:MoveFrame(frm:GetX(), frm:GetY()-210);

	local button_adv = frm:GetChild("extuiminiadv");
	local button_close = frm:GetChild("extuiminiclose");
	local button_save = frm:GetChild("extuiminisaveclose");

	button_adv:SetOffset((350/2)-(125/2), 420-35-30);
	button_close:SetOffset(175, 420-35);
	button_save:SetOffset(50, 420-35);

	button_adv:SetEventScript(ui.LBUTTONUP, "EXTENDEDUI_ON_MINI_LESS");
	button_adv:SetText("{@st66b}"..extui.TLang("less").."{/}");

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
	local v = nil;

	if frame ~= nil then
		v = extui.GetFrame(frame:GetName());
	end

	if cframe ~= nil then
		v = extui.GetFrame(frame:GetName()).child[cframe:GetName()];
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
	button_adv:SetText("{@st66b}"..extui.TLang("advanced").."{/}");

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

		if extui.mIsPopulated == false then return 0; end

		local minitext = frm:GetChild("extuiminigrpbox");
		minitext = minitext:GetChild("extuiminitext");
		minitext = tolua.cast(minitext, "ui::CRichText");

		
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

					local eframe = extui.GetFrame(frameName);

					if frameName == "targetinfo" then
						extui.TargetInfoUpdate(x,y);
					end

					frame:MoveFrame(x, y);
				else
					extui.framepos[frame:GetName()].child[frameName].x = sliderx:GetLevel();
					extui.framepos[frame:GetName()].child[frameName].y = slidery:GetLevel();
					x = extui.framepos[frame:GetName()].child[frameName].x;
					y = extui.framepos[frame:GetName()].child[frameName].y;


					if frame:GetName() == "buff" then
						extui.UpdateBuffSizes(frameName);
					end
					
					cframe:SetOffset(x, y);
				end
			end

			labelvalx:SetText(string.format("{@st42b}%d{/}",extui.round(x)));
			labelvaly:SetText(string.format("{@st42b}%d{/}",extui.round(y)));
			sliderx:SetLevel(x);
			slidery:SetLevel(y);


			if cframe == nil then
				if not(extui.GetFrame(frameName).noResize) then
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
	local t,p = pcall(EXTENDEDUI_ON_MINI_SAVES);
	if not(t) then
		extui.print("[EUI] OnMiniSave(): "..tostring(p));
	end
	
	return 1;
end

function EXTENDEDUI_ON_MINI_SAVES()
	local frm = ui.GetFrame("EXTENDEDUI_MINI_FRAME");
	frm:StopUpdateScript("EXTENDEDUI_MINI_UPDATE");
	frm:ShowWindow(0);
	
	extui.HideGrid();

	extui.HideAllFrameBorders();

	EXTENDEDUI_ON_SAVE();
	extui.close();
end

function extui.GetDisplayDivider()
	if option.GetClientWidth() >= 3000 then
		return 4;
	else
		return 2;
	end
end

function extui.OpenMiniFrame()
	extui.oldSelectedFrameParent = nil;
	extui.selectedFrameParent = nil;
	extui.selectedFrame = nil;
	
	extui.InitGrid();

	local frm = ui.CreateNewFrame("extendedui", "EXTENDEDUI_MINI_FRAME");
	frm:Resize(350 , 120);
	
	div = extui.GetDisplayDivider();
	
	frm:MoveFrame((ui.GetSceneWidth()/div)-175, (ui.GetSceneHeight()/div)-50);
	frm:SetSkinName("pip_simple_frame");
	frm:RunUpdateScript("EXTENDEDUI_MINI_UPDATE");

	extui.PopulateMiniFrame(frm);
	
	extui.isFrameOpen = true;
end

extui.mIsPopulated = false;
function extui.PopulateMiniFrame(frm)
	extui.mIsPopulated = false;

	--frm:RemoveAllChild();
	--buttons
	local ctrls = frm:CreateOrGetControl("button", "extuiminisaveclose", 50, 85, 125, 30);
	ctrls = tolua.cast(ctrls, "ui::CButton");
	ctrls:SetText("{@st66b}"..extui.TLang("savenclose").."{/}");
	ctrls:SetClickSound("button_click_big");
	ctrls:SetOverSound("button_over");
	ctrls:SetEventScript(ui.LBUTTONUP, "EXTENDEDUI_ON_MINI_SAVE");
	ctrls:SetSkinName("test_pvp_btn");

	ctrls = frm:CreateOrGetControl("button", "extuiminiopt", 10, 10, 30, 30);
	ctrls = tolua.cast(ctrls, "ui::CButton");
	ctrls:SetTextTooltip("{@st42b}"..extui.TLang("options").."{/}");
	ctrls:SetClickSound("button_click_big");
	ctrls:SetOverSound("button_over");
	ctrls:SetEventScript(ui.LBUTTONUP, "EXTENDEDUI_ON_OPTIONS");
	ctrls:SetImage("chat_option2_btn");

	ctrls = frm:CreateOrGetControl("button", "extuiminiclose", 175, 85, 125, 30);
	ctrls = tolua.cast(ctrls, "ui::CButton");
	ctrls:SetText("{@st66b}"..extui.TLang("cancel").."{/}");
	ctrls:SetClickSound("button_click_big");
	ctrls:SetOverSound("button_over");
	ctrls:SetEventScript(ui.LBUTTONUP, "EXTENDEDUI_ON_MINI_CANCEL");
	ctrls:SetSkinName("test_pvp_btn");

	ctrls = frm:CreateOrGetControl("button", "extuiminiadv", (350/2)-(125/2), 85-30, 125, 30);
	ctrls = tolua.cast(ctrls, "ui::CButton");
	ctrls:SetText("{@st66b}"..extui.TLang("advanced").."{/}");
	ctrls:SetClickSound("button_click_big");
	ctrls:SetOverSound("button_over");
	ctrls:SetEventScript(ui.LBUTTONUP, "EXTENDEDUI_ON_MINI_ADVANCED");
	ctrls:SetSkinName("test_pvp_btn");
	
	ctrls = frm:CreateOrGetControl("checkbox", "extuicheckfram", (350/2)+110, 15, 30, 30);
	ctrls = tolua.cast(ctrls, "ui::CCheckBox");
	ctrls:SetEventScript(ui.LBUTTONUP, "EXTENDEDUI_MINI_ON_GRIDSNAP");
	ctrls:SetClickSound("button_click_big");
	ctrls:SetOverSound("button_over");
	ctrls:SetTextTooltip("{@st42b}Snap To Grid{/}");
	ctrls:SetCheck(1);

	
	ctrls = frm:CreateOrGetControl("groupbox", "extuiminigrpbox", (350/2)-100, 15, 200, 30);
	ctrls = tolua.cast(ctrls, "ui::CGroupBox");
	ctrls:SetSkinName("property_screenbg");
	ctrls:EnableScrollBar(0);
	ctrls:EnableHittestGroupBox(false);
	

	local ctrlss = ctrls:CreateOrGetControl("richtext", "extuiminitext", 5, 5, 30, 30);
	ctrlss = tolua.cast(ctrlss, "ui::CRichText");
	ctrlss:SetText("{@st42b}"..extui.TLang("noSelect").."{/}");

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

	extui.mIsPopulated = true;
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
	ctrls:SetText("{@st42b}"..extui.TLang("position").."{/}");
	
	iny = iny+10;
	
	ctrls = gbox:CreateOrGetControl("richtext", "extuilabelx", inx, iny+5, 300, 30);
	ctrls = tolua.cast(ctrls, "ui::CRichText");
	ctrls:SetText("{@st42b}x{/}");
	
	ctrls = gbox:CreateOrGetControl("slidebar", "extuislidex", inx+12, iny, 300, 30);
	ctrls = tolua.cast(ctrls, "ui::CSlideBar");
	ctrls:SetMaxSlideLevel(ui.GetClientInitialWidth()*2);
	--ctrls:SetMinSlideLevel(0);
	ctrls:SetLevel(x);
	ctrls:SetTextTooltip("{@st42b}"..extui.TLang("posxDesc").."{/}");
	
	ctrls = gbox:CreateOrGetControl("richtext", "extuilabelvalx", inx+295, iny+5, 300, 30);
	ctrls = tolua.cast(ctrls, "ui::CRichText");
	ctrls:SetText( string.format("{@st42b}%d{/}", extui.round(x)) );

	iny = iny+35;
	
	ctrls = gbox:CreateOrGetControl("richtext", "extuilabely", inx, iny+5, 300, 30);
	ctrls = tolua.cast(ctrls, "ui::CRichText");
	ctrls:SetText("{@st42b}y{/}");

	ctrls = gbox:CreateOrGetControl("slidebar", "extuislidey", inx+12, iny, 300, 30);
	ctrls = tolua.cast(ctrls, "ui::CSlideBar");
	ctrls:SetMaxSlideLevel(ui.GetClientInitialHeight()*2);
	--ctrls:SetMinSlideLevel(0);
	ctrls:SetLevel(y);
	ctrls:SetTextTooltip("{@st42b}"..extui.TLang("posyDesc").."{/}");
	
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
			ctrls:SetText("{@st42b}"..extui.TLang("size").."{/}");
			
			iny = iny+10;
			
			ctrls = gbox:CreateOrGetControl("richtext", "extuilabelw", inx, iny+5, 300, 30);
			ctrls = tolua.cast(ctrls, "ui::CRichText");
			ctrls:SetText("{@st42b}w{/}");
			
			ctrls = gbox:CreateOrGetControl("slidebar", "extuislidew", inx+12, iny, 300, 30);
			ctrls = tolua.cast(ctrls, "ui::CSlideBar");
			ctrls:SetMaxSlideLevel(ui.GetClientInitialWidth());
			ctrls:SetMinSlideLevel(5);
			ctrls:SetLevel(w);
			ctrls:SetTextTooltip("{@st42b}"..extui.TLang("width").."{/}");
			
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
			ctrls:SetMinSlideLevel(5);
			ctrls:SetLevel(h);
			ctrls:SetTextTooltip("{@st42b}"..extui.TLang("height").."{/}");
			
			ctrls = gbox:CreateOrGetControl("richtext", "extuilabelvalh", inx+295, iny+5, 300, 30);
			ctrls = tolua.cast(ctrls, "ui::CRichText");
			ctrls:SetText( string.format("{@st42b}%d{/}", extui.round(h)) );
			
			iny = iny+35;
		
		end


		ctrls = gbox:CreateOrGetControl("checkbox", "extuicheckvis", inx+10, iny, 150, 30);
		ctrls = tolua.cast(ctrls, "ui::CCheckBox");
		ctrls:SetText("{@st42b}"..extui.TLang("showFrame").."{/}");
		ctrls:SetClickSound("button_click_big");
		ctrls:SetOverSound("button_over");
		ctrls:SetEventScript(ui.LBUTTONUP, "EXTENDEDUI_ON_CHECK_HIDE");
		ctrls:SetEventScriptArgString(ui.LBUTTONUP, frame:GetName());
		ctrls:SetCheck(frame:IsVisible());
		if v.saveHidden then
			ctrls:SetColorTone("FF00FF00");
			ctrls:SetTextTooltip("{@st42b}"..extui.TLang("vistrue").."{/}");
		else
			ctrls:SetColorTone("FFFF0000");
			ctrls:SetTextTooltip("{@st42b}"..extui.TLang("visfalse").."{/}");
		end
		
		
		iny = iny+35;

		ctrls = gbox:CreateOrGetControl("checkbox", "extuicheckhover", inx+10, iny, 150, 30);
		ctrls = tolua.cast(ctrls, "ui::CCheckBox");
		ctrls:SetText("{@st42b}"..extui.TLang("visHover").."{/}");
		ctrls:SetClickSound("button_click_big");
		ctrls:SetOverSound("button_over");
		ctrls:SetEventScript(ui.LBUTTONUP, "EXTENDEDUI_ON_CHECK_HOVER");
		ctrls:SetEventScriptArgString(ui.LBUTTONUP, frame:GetName());
		ctrls:SetCheck(extui.framepos[frame:GetName()].hover ~= nil and extui.framepos[frame:GetName()].hover or 0);
		
		iny = iny+25;
		

		-- if this returns false it's a child frame, and those aren't supported for reset
		if extui.FrameExists(frame:GetName()) then
			ctrls = gbox:CreateOrGetControl("checkbox", "extuicheckupdate", inx+10, iny, 150, 30);
			ctrls = tolua.cast(ctrls, "ui::CCheckBox");
			ctrls:SetText("{@st42b}Always Update (Use when position randomly resets){/}");
			ctrls:SetClickSound("button_click_big");
			ctrls:SetOverSound("button_over");
			ctrls:SetEventScript(ui.LBUTTONUP, "EXTENDEDUI_ON_CHECK_UPDATE");
			ctrls:SetEventScriptArgString(ui.LBUTTONUP, frame:GetName());
			ctrls:SetCheck(extui.framepos[frame:GetName()].alwaysupdate ~= nil and extui.framepos[frame:GetName()].alwaysupdate or 0);

			iny = iny+25;
		
			ctrls = gbox:CreateOrGetControl("button", "extuiframereset", inx+90, iny, 150, 30);
			ctrls = tolua.cast(ctrls, "ui::CButton");
			ctrls:SetText("{@st66b}"..extui.TLang("resetFrame").."{/}");
			ctrls:SetClickSound("button_click_big");
			ctrls:SetOverSound("button_over");
			ctrls:SetEventScript(ui.LBUTTONUP, "EXTENDEDUI_ON_FRAME_RESET");
			ctrls:SetEventScriptArgString(ui.LBUTTONUP, frame:GetName());
			ctrls:SetSkinName("test_pvp_btn");
		
		end

	else
		iny = iny+25
		ctrls = gbox:CreateOrGetControl("checkbox", "extuicheckvisc", inx+10, iny, 150, 30);
		ctrls = tolua.cast(ctrls, "ui::CCheckBox");
		ctrls:SetText("{@st42b}"..extui.TLang("showFrame").."{/}");
		ctrls:SetClickSound("button_click_big");
		ctrls:SetOverSound("button_over");
		ctrls:SetEventScript(ui.LBUTTONUP, "EXTENDEDUI_ON_CHECK_HIDECHILD");
		ctrls:SetEventScriptArgString(ui.LBUTTONUP, frame:GetName());
		ctrls:SetCheck(cframe:IsVisible());

		ctrls:SetColorTone("FF00FF00");
		ctrls:SetTextTooltip("{@st42b}"..extui.TLang("vistrue").."{/}");

	end
end


function EXTENDEDUI_ON_FRAME_RESET(frame, ctrl, argStr)
	local frm = ui.GetFrame(argStr);
	if frm == nil then return; end

	local k = argStr;
	local v = extui.GetFrame(argStr);
	local toc = frm;

	if v == nil then return; end

	extui.framepos[tostring(k)].x = extui.defaultFrames[tostring(k)].x;
	extui.framepos[tostring(k)].y = extui.defaultFrames[tostring(k)].y;
	toc:MoveFrame(extui.framepos[tostring(k)].x, extui.framepos[tostring(k)].y);
	if not(v.noResize) then
		extui.framepos[tostring(k)].w = extui.defaultFrames[tostring(k)].w;
		extui.framepos[tostring(k)].h = extui.defaultFrames[tostring(k)].h;
		toc:Resize(extui.framepos[tostring(k)].w, extui.framepos[tostring(k)].h);
	end

	if v.hasChild then
		for ck,_ in pairs(v.child) do
			local tcc = ui.GetFrame(ck);
			if tcc ~= nil then
				extui.framepos[tostring(k)]["child"][tostring(ck)].x = extui.defaultFrames[tostring(k)]["child"][tostring(ck)].x;
				extui.framepos[tostring(k)]["child"][tostring(ck)].y = extui.defaultFrames[tostring(k)]["child"][tostring(ck)].y;
				tcc:SetOffset(extui.framepos[tostring(k)]["child"][tostring(ck)].x, extui.framepos[tostring(k)]["child"][tostring(ck)].y);
			end
		end
	end

	extui.UpdateMiniBox();
end

extui.dropListOptionsLang = {};
function EXTENDEDUI_ON_LANGUAGE_SELECT()
	local frm = ui.GetFrame("EXTENDEDUI_SIDE_FRAME");

	local box = frm:GetChild("extuisetgrpbox")
	box = tolua.cast(box, "ui::CGroupBox");
	local list = box:GetChild("extuiminidropdownlang");
	list = tolua.cast(list, "ui::CDropList");
	list:ClearItems();

	local toSel = 0;

	local iii = 0;
	for k,v in pairs(extui.language.names) do
		list:AddItem(iii, tostring(v));
		extui.dropListOptionsLang[iii] = tostring(k);
		if extui.language.selectedLanguage == tostring(k) then
			toSel = iii;
		end
		iii = iii+1;
	end
	list:SelectItem(toSel);
end

extui.isInDrop = false;
function EXTENDEDUI_CHOOSE_LANGUAGE(frm)
	extui.isInDrop = true;
	local list = frm:GetChild("extuiminidropdownlang");
	list = tolua.cast(list, "ui::CDropList");
	local idx = list:GetSelItemIndex();

	local lang = extui.dropListOptionsLang[idx];

	extui.language.selectedLanguage = lang;
	extui.SetSetting("lang",lang);

	extui.SaveSettings();
	extui.LoadSettings();

	extui.PopulateMiniFrame(ui.GetFrame("EXTENDEDUI_MINI_FRAME"));

	extui.PopulateSideFrame(ui.GetFrame("EXTENDEDUI_SIDE_FRAME"));
	extui.isInDrop = false;
end


function EXTENDEDUI_ON_CLOSE_UI()
	extui.close();
	extui.isFrameOpen = false;
end

function EXTENDEDUI_ON_OPEN_UI()
	--extui.openside();
	if ui.GetFrame("EXTENDEDUI_MINI_FRAME") == nil then
		--curtabName = string.gsub(curtabName, "%s", "");
		--extui.selectedAddon = "UI";--string.gsub(curtabName, "({@[%w_']*})([%w_']*)({/})", function(_,d) return d; end);
		extui.language.selectedLanguage = extui.GetSetting("lang");
		extui.LoadSettings();
		extui.OpenMiniFrame();
		--extui.showAll = true;
		--EXTENDEDUI_ON_BUTTON_FRAME_PRESS(nil,nil,"*all");
		
		--hide all frame borders
		extui.HideAllFrameBorders();
	else
		EXTENDEDUI_ON_MINI_SAVE();
	end
end


function EXTENDEDUI_ON_OPTIONS()
	extui.openside();
end

extui.oldSelectedFrameParent = nil;


extui.ShowAllFrames = false;
function extui.HideAllFrameBorders()
	extui.selectedChild = false;
	local borderParent = ui.GetFrame("extui_borderParent");
	if borderParent ~= nil then
		borderParent:StopUpdateScript("EXTENDEDUI_FRAMEBORDER_UPDATE");
		borderParent:ShowWindow(0);
	end
end

function extui.ShowFrameBorder(parentFrame, childFrame)
	local masterFrame = ui.GetFrame(parentFrame.frameName);
	
	local w = masterFrame:GetWidth();
	local h = masterFrame:GetHeight();
	local x = masterFrame:GetX();
	local y = masterFrame:GetY();
	local pic = nil;

	local borderParent = ui.GetFrame("extui_borderParent");
	if borderParent ~= nil then
		borderParent:StopUpdateScript("EXTENDEDUI_FRAMEBORDER_UPDATE");
		borderParent:RemoveAllChild();

		--pic = borderParent:CreateOrGetControl("picture", "pic", 0, 0, w, h);

		--AUTO_CAST(pic);
		--pic:CreateInstTexture();

	else
	
		borderParent = ui.CreateNewFrame("extendedui", "extui_borderParent");
		
		--pic = borderParent:CreateOrGetControl("picture", "pic", 0, 0, w, h);

		--AUTO_CAST(pic);
		--pic:CreateInstTexture();
	end
	
	borderParent:ShowWindow(1);
	borderParent:Resize(w+1 , h+1);
	borderParent:MoveFrame(x-1, y-1);
	borderParent:SetSkinName("chat_window");
	borderParent:EnableHitTest(1);
	borderParent:SetUserValue("FRAME_NAME", parentFrame.frameName);
	borderParent:SetUserValue("CHILD_NAME", "None");
	borderParent:RunUpdateScript("EXTENDEDUI_FRAMEBORDER_UPDATE");
	
	--pic = borderParent:CreateOrGetControl("picture", "pic", 0, 0, w, h);

	--AUTO_CAST(pic);
	--pic:EnableHitTest(1);
	
	borderParent:SetColorTone("88000000");
	--pic:FillClonePicture("88000000");
	
	if childFrame ~= nil then
		extui.DrawBorder(borderParent, 0, 0, w, h, "88FF0000");
	else
		extui.DrawBorder(borderParent, 0, 0, w, h, "8800FF00");
	end
	
	if childFrame ~= nil then
		local masterChildFrame = masterFrame:GetChild(childFrame.frameName);
		
		local wc = masterChildFrame:GetWidth();
		local hc = masterChildFrame:GetHeight();
		local xc = masterChildFrame:GetX();
		local yc = masterChildFrame:GetY();
		
		extui.DrawBorder(borderParent, xc, yc, wc, hc, "8800FF00");
		
		borderParent:SetUserValue("CHILD_NAME", childFrame.frameName);
	end
	
end


function EXTENDEDUI_FRAMEBORDER_UPDATE(border)
	local t,p = pcall(EXTENDEDUI_FRAMEBORDER_UPDATE_S, border);
	if not(t) then
		extui.print("[EUI] FrameBorderUpdate(): "..tostring(p));
	end
	
	return 1
end

function EXTENDEDUI_FRAMEBORDER_UPDATE_S(border)
	local borderFrameName = border:GetUserValue("FRAME_NAME");
	local borderChildFrameName = border:GetUserValue("CHILD_NAME");
	
	if borderFrameName ~= nil and borderFrameName ~= "None" then
		local borderFrame = ui.GetFrame(borderFrameName);
		if borderFrame ~= nil then
		
			local w = borderFrame:GetWidth();
			local h = borderFrame:GetHeight();
			local x = borderFrame:GetX();
			local y = borderFrame:GetY();

			if w < 5 then
				w = 5;
			end
			
			if h < 5 then
				h = 5;
			end

			local borderFrm = ui.GetFrame("extui_borderParent");
			if borderFrm == nil then
				return 1;
			end

			borderFrm:Resize(w+1 , h+1);
			borderFrm:MoveFrame(x-1, y-1);
			
			--local pic = borderFrm:GetChild("pic");
			--if pic:GetWidth() ~= w or pic:GetHeight() ~= h then
			
			--	borderFrm:RemoveChild("pic");
				
				--pic = borderFrm:CreateOrGetControl("picture", "pic", 0, 0, w, h);

				--AUTO_CAST(pic);

				--pic:CreateInstTexture();
			
			--end
			
			--AUTO_CAST(pic);
			--borderFrm:SetColorTone("88000000");
			--pic:FillClonePicture("88000000");

			
			if borderChildFrameName ~= nil and borderChildFrameName ~= "None" then
			
				local masterChildFrame = borderFrame:GetChild(borderChildFrameName);
				
				if masterChildFrame ~= nil then
					local wc = masterChildFrame:GetWidth();
					local hc = masterChildFrame:GetHeight();
					local xc = masterChildFrame:GetX();
					local yc = masterChildFrame:GetY();
					
					extui.DrawBorder(borderFrm, 0, 0, w, h, "88FF0000");
					extui.DrawBorder(borderFrm, xc, yc, wc, hc, "8800FF00");
				end
				
			else
				extui.DrawBorder(borderFrm, 0, 0, w, h, "8800FF00");
			end
			
		end
	end
	
	return 1;
	
end

extui.selectedChild = false;
extui.showAll = false;


function extui.listframes()

	if not(extui.isSetting) then
		extui.SavePositions();
	end

	extui.UpdateCheck();


	EXTENDEDUI_LOAD_POSITIONS();
	extui.print("Reloaded UI");
end

function extui.reload()
	extui.UpdateCheck();

	EXTENDEDUI_LOAD_POSITIONS(nil,true);
end

function EXTENDEDUI_ON_RELOADUI()
	extui.isReload = true;
	extui.oldSlider = {};
	extui.UpdateCheck();

	EXTENDEDUI_LOAD_POSITIONS(nil,true);
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
	ui.MsgBox(extui.TLang("confirmReset"),"EXTENDEDUI_ON_RESTORE_R","Nope");
end


function EXTENDEDUI_VOID()
end


function extui.UpdateSliders()
	--removed
end

function extui.InitSideFrame()
	if extui.isSetting then
		if ui.GetFrame("EXTENDEDUI_SIDE_FRAME") == nil then
			extui.isSetting = false;
		end
	end

	if ui.GetFrame("EXTENDEDUI_SIDE_FRAME") ~= nil then
		EXTENDEDUI_ON_CLOSE_UI();
		return;
	end

	local frm = ui.CreateNewFrame("extendedui", "EXTENDEDUI_SIDE_FRAME");
	frm:Resize(385 , 600);
	
	local div = extui.GetDisplayDivider();
	
	frm:MoveFrame((ui.GetSceneWidth()/div)-400, (ui.GetSceneHeight()/div)-300);
	frm:SetSkinName("test_frame_low");

	local ctrl = frm
	ctrl = tolua.cast(ctrl, "ui::CFrame");
	extui.sideFrame = ctrl;

	extui.PopulateSideFrame(ctrl);
end

extui.sIsPopulated = false;
function extui.PopulateSideFrame(frm)
	extui.sIsPopulated = false;

	--frm:RemoveAllChild();

	local nctrl = frm:CreateOrGetControl("richtext", "extuititlet", 5, 10, 360, 30);
	nctrl = tolua.cast(nctrl, "ui::CRichText");
	nctrl:SetTextAlign("center","center");
	nctrl:SetText("{@st43}"..extui.language.extuiname.." "..extui.TLang("euiSettings").."{/}");
	
	ctrls = frm:CreateOrGetControl("groupbox", "extuisetgrpbox", 0, 50, 365, 500);
	ctrls = tolua.cast(ctrls, "ui::CGroupBox");
	ctrls:SetSkinName("None");
	ctrls:EnableScrollBar(1);
	ctrls:EnableHittestGroupBox(false);
	

	extui.UIAddSettings(ctrls);

	local ctrls = frm:CreateOrGetControl("button", "extuibuttonrestore", 20, 600-45, 150, 30);
	ctrls = tolua.cast(ctrls, "ui::CButton");
	ctrls:SetText("{@st66b}"..extui.TLang("restore").."{/}");
	ctrls:SetClickSound("button_click_big");
	ctrls:SetOverSound("button_over");
	ctrls:SetEventScript(ui.LBUTTONUP, "EXTENDEDUI_ON_RESTORE", false);
	ctrls:SetSkinName("test_pvp_btn");
	
	extui.sIsPopulated = true;
end


------- Grid

extui.GridFrame = nil;
extui.GridSize = 10;
extui.SnapToGrid = true;

function extui.DrawGrid()

	extui.GridSize = extui.GetSetting("gridSize") or extui.GridSize;
	
	local pic = extui.GridFrame:GetChild("pic");
	
	AUTO_CAST(pic);
	pic:RemoveAllChild();
	
	
	local gridWidth = extui.GridFrame:GetWidth();
	local gridHeight = extui.GridFrame:GetHeight();
	
	local gridColCount = gridWidth/extui.GridSize;
	local gridRowCount = gridHeight/extui.GridSize;
	
	for _gy=0, gridRowCount, 1 do
	
		local line = extui.GridFrame:CreateOrGetControl("picture", "aa"..tostring(_gy), 0, extui.GridSize*_gy, gridWidth, 1);
		AUTO_CAST(line);
		line:SetImage("fullwhite");
		line:SetEnableStretch(1);
		line:SetColorTone("88FFFFFF");
	
		--pic:DrawBrush(0, extui.GridSize*_gy , extui.GridFrame:GetWidth(), (extui.GridSize*_gy)+1, "spray_1", "88FFFFFF");
	
	end
	
	for _gx=0, gridColCount, 1 do
	
		local line = extui.GridFrame:CreateOrGetControl("picture", "ab"..tostring(_gx), extui.GridSize*_gx, 0, 1, gridHeight);
		AUTO_CAST(line);
		line:SetImage("fullwhite");
		line:SetEnableStretch(1);
		line:SetColorTone("88FFFFFF");
		
		--pic:DrawBrush(extui.GridSize*_gx, 0, (extui.GridSize*_gx)+1, extui.GridFrame:GetHeight(), "spray_1", "88FFFFFF");
	
	end
end

function extui.HideGrid()
	if ui.GetFrame("EXTENDEDUI_GRIDFRAME") ~= nil then
		extui.GridFrame:ShowWindow(0);
	end
end


function extui.InitGrid()
	if ui.GetFrame("EXTENDEDUI_GRIDFRAME") == nil then
		extui.GridFrame = ui.CreateNewFrame("extendedui", "EXTENDEDUI_GRIDFRAME");
		extui.GridFrame:Resize(option.GetClientWidth()*2, option.GetClientHeight()*2);
		extui.GridFrame:MoveFrame(-1, -1);
		extui.GridFrame:SetSkinName("chat_window");
		
		extui.GridFrame:SetLayerLevel(-10000);
		
		local pic = extui.GridFrame:CreateOrGetControl("picture", "pic", 0, 0, extui.GridFrame:GetWidth(), extui.GridFrame:GetHeight());

		AUTO_CAST(pic);
		pic:EnableHitTest(1);
		
	end
	
	
	extui.GridFrame:ShowWindow(1);

	extui.DrawGrid();
end


function EXTENDEDUI_MINI_ON_GRIDSNAP(frame, ctrl)
	local isChecked = (ctrl:IsChecked() == 1);
	
	extui.SnapToGrid = isChecked;
end

-------  Hover addition

extui.hoverFrames = {};
extui.IsDragging = false;


function extui.resizeFrame(frameName, scale)
	local frame = ui.GetFrame(frameName);
	
	local cnt = frame:GetChildCount();
	for i = 0, cnt - 1 do
		local ctrl = frame:GetChildByIndex(i);
		
		local oWidth = ctrl:GetOriginalWidth();
		local oHeight = ctrl:GetOriginalHeight();
		
		local ctrlScaleW = oWidth * (scale/100);
		local ctrlScaleH = oHeight * (scale/100);
		
		local offsetX = oWidth - ctrlScaleW;
		local offsetY = oHeight - ctrlScaleH;
		
		ctrl:SetOffset(ctrl:GetX()-offsetX, ctrl:GetY()-offsetY);
		
		ctrl:Resize(ctrlScaleW, ctrlScaleH);
	end
	
	local frameScaleW = frame:GetOriginalWidth() * (scale/100);
	local frameScaleH = frame:GetOriginalHeight() * (scale/100);
	
	frame:Resize(frameScaleW, frameScaleH);
end



function extui.CheckForHover()
	local t,p = pcall(extui.CheckForHovers);
	if not(t) then
		extui.print("[EUI] CheckForHover(): "..tostring(p));
	end
	
	return 1
end


function extui.CheckForHovers()
	local mx, my = GET_MOUSE_POS();
	mx = mx / ui.GetRatioWidth();
	my = my / ui.GetRatioHeight();
	
	local isMousePressed = mouse.IsLBtnPressed() == 1 and true or false;
	
	for frm,bl in pairs(extui.hoverFrames) do
		if bl ~= nil then
			local toc = ui.GetFrame(frm);
			
			local xs = toc:GetX() or 0;
			local ys = toc:GetY() or 0;
			local ws = toc:GetWidth() or 0;
			local hs = toc:GetHeight() or 0;
			
			--print("checking for "..frm.." at x: "..xs.." y: "..ys.." w: "..ws.." h: "..hs);
			if toc:GetUserValue("EUI_IS_DRAGGING") ~= 1 then
				if mx >= xs and my >= ys and mx <= xs+ws and my <= ys+hs then
					toc:ShowWindow(1, true);
					toc:SetUserValue("EUI_IS_HOVERING", 1);
				else
					toc:ShowWindow(0, true);
					toc:SetUserValue("EUI_IS_HOVERING", 0);
				end
			end
			
		end
	end
	
	
	if isMousePressed and extui.isFrameOpen and extui.IsDragging == false then
		if ui.GetFrame("extui_borderParent") == nil then return 1; end;
		
		local toc = extui.selectedFrameParent;
		
		if extui.selectedChild == true then
			toc = extui.selectedFrame;
		end
		
		if toc ~= nil then
			local xs = toc:GetX() or 0;
			local ys = toc:GetY() or 0;
			local ws = toc:GetWidth() or 0;
			local hs = toc:GetHeight() or 0;
			
			if extui.selectedChild == true then
				xs = extui.selectedFrameParent:GetX() + xs;
				ys = extui.selectedFrameParent:GetY() + ys;
			end

			if mx >= xs and my >= ys and mx <= xs+ws and my <= ys+hs and extui.IsDragging == false then

				if extui.selectedChild ~= true then
					toc:SetUserValue("EUI_OLD_VISIBLE", toc:IsVisible());
					toc:ShowWindow(1, true);
				end
				toc:SetUserValue("EUI_IS_DRAGGING", 1);
				EUI_MOVE_FRAME(toc, nil);
				
				extui.IsDragging = true;
			end
		end
	end
	
	if extui.IsDragging and isMousePressed == false then
		local toc = extui.selectedFrameParent;
		
		if extui.selectedChild == true then
			toc = extui.selectedFrame;
		end
		
		toc:SetUserValue("EUI_IS_DRAGGING", 0);
		
		if extui.selectedChild ~= true then
			toc:ShowWindow(toc:GetUserValue("EUI_OLD_VISIBLE"), true);
		end
		
		extui.IsDragging = false;

		toc:StopUpdateScript("EUI_PROCESS_MOVE_FRAME");
		
	end
end




function EUI_MOVE_FRAME(parent, ctrl)
	if extui.IsDragging then return; end

	local frame = parent:GetTopParentFrame();
	
	if extui.selectedChild == true then
		frame = parent;
	end
	
	local mx, my = GET_MOUSE_POS();
	mx = mx / ui.GetRatioWidth();
	my = my / ui.GetRatioHeight();
	frame:SetUserValue("MOUSE_X", mx);
	frame:SetUserValue("MOUSE_Y", my);
	frame:SetUserValue("BEFORE_W", frame:GetX());
	frame:SetUserValue("BEFORE_H", frame:GetY());
	frame:RunUpdateScript("EUI_PROCESS_MOVE_FRAME");
end

function EUI_PROCESS_MOVE_FRAME(frame)

	if mouse.IsLBtnPressed() == 0 or ui.GetFrame("extui_borderParent") == nil then
		if extui.selectedChild ~= true then
			frame:ShowWindow(frame:GetUserValue("EUI_OLD_VISIBLE"), true);
		end

			extui.IsDragging = false;
			frame:SetUserValue("EUI_IS_DRAGGING", 0);
			frame:StopUpdateScript("EUI_PROCESS_MOVE_FRAME");

		return 0;
	end

	local mx, my = GET_MOUSE_POS();
	mx = mx / ui.GetRatioWidth();
	my = my / ui.GetRatioHeight();
	local bx = frame:GetUserIValue("MOUSE_X");
	local by = frame:GetUserIValue("MOUSE_Y");

	local dx = (mx - bx);
	local dy = (my - by);

	local width = frame:GetUserIValue("BEFORE_W");
	local height = frame:GetUserIValue("BEFORE_H");
	width = width + dx;
	height = height + dy;
	
	if extui.SnapToGrid then
		width = extui.round(width / extui.GridSize) * extui.GridSize;
		height = extui.round(height / extui.GridSize) * extui.GridSize;
	end
	
	frame:SetOffset(width, height);
	
	if extui.selectedChild == true then
		local frameName = frame:GetName();
		local parentFrame = frame:GetParent();
		
		extui.framepos[parentFrame:GetName()].child[frameName]["x"] = frame:GetX();
		extui.framepos[parentFrame:GetName()].child[frameName]["y"] = frame:GetY();

		if parentFrame:GetName() == "buff" then
			extui.UpdateBuffSizes(frameName);
		end
	else
		
		local frameName = frame:GetName();
		extui.framepos[frameName]["x"] = frame:GetX();
		extui.framepos[frameName]["y"] = frame:GetY();
		extui.framepos[frameName]["w"] = frame:GetWidth();
		extui.framepos[frameName]["h"] = frame:GetHeight();

	end


	return 1;

end
