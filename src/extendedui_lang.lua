--ExtendedUI Language System

if extui == nil then
	extui = {};
end

extui.language = {};
extui.language.selectedLanguage = "eng";
extui.language.data = {};
extui.language.names = {};


extui.language.defaultFile = [[{
	"eng": {
		"name": "English",
		"data": {
			"euiSettings": "ExtendedUI Settings",
			"reloadUI": "Reload UI",
			"restore": "Restore Defaults",
			"savenclose": "Save&Close",
			"cancel": "Cancel",
			"close": "Close",
			"general": "General",
			"advanced": "Advanced",
			"less": "Less",
			"position": "Position",
			"posxDesc": "Left/Right Position",
			"posyDesc": "Up/Down Position",
			"size": "Size",
			"width": "Width",
			"height": "Height",
			"curSkin": "Current Skin",
			"setSkin": "Set Skin",
			"chooseSkin": "Choose Skin",
			"showframe": "Show Frame",
			"vistrue": "Visibility will be saved",
			"visfalse": "Visibility will not be saved",
			"loadMessage": "Remove Loaded Message",
			"loadMessageDesc": "Removes the \"ExtendedUI Loaded\" message on startup",
			"hideJoy": "Hide buttons from Joystick Quickslot",
			"hideJoyDesc": "Removes the \"Set 1\"/\"Set 2\" buttons from the Joystick Quickslot",
			"showExp": "Show EXP Numbers",
			"showExpDesc": "Shows exact exp numbers when hovering over the exp bars. (Updates after map change)",
			"disablePop": "Disable Recipe Item Popup",
			"disabelPopDesc": "Disables the popup when getting an item for crafting.",
			"lockQuest": "Lock Quest Log Position",
			"lockQuestDesc": "Locks the Quest Log so it no longer moves in both directions when new quests are added or removed.",
			"buffs": "Buffs",
			"bIconSize": "Buff Icon Size",
			"extBuff": "Extend Buff Display",
			"extBuffDesc": "Extends the buff display to show a maximum of 30 buffs.",
			"buffAmt": "Amount In Row",
			"buffAmtDesc": "Creates new rows with this amount of buffs. (Only works with extended buff display on)",
			"buffSec": "Always Show Seconds",
			"buffSecDesc": "Shows (x)s instead of (x)m.",
			"confirmReset": "Are you sure you want to reset{nl}all frames to their default positions?"
		}
	}
}]];

function extui.language.GetTranslation(transString)
	if extui.language.data[extui.language.selectedLanguage] == nil then
		return "NoLang#"..transString;
	end

	if extui.language.data[extui.language.selectedLanguage][transString] == nil then
		return "NoTrans#"..transString;
	end


	return extui.language.data[extui.language.selectedLanguage][transString];
end

function extui.language.LoadFile()
	local acutil = require("acutil");

	local tload, error = acutil.loadJSON("../addons/extendedui/language.json");
	if not error then
		for k,v in pairs(tload) do
			extui.language.data[k] = v.data;
			extui.language.names[k] = v.name;
		end
	else
		--Create default
		file, error = io.open("../addons/extendedui/language.json", "w");
		if file ~= nil then
			file:write(extui.language.defaultFile);
			io.close(file);

			--Load it again
			extui.language.LoadFile();
		end
	end
end

--For easy access
function extui.TLang(transString)
	return extui.language.GetTranslation(transString);
end