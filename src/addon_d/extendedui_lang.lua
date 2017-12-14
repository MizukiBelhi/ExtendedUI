--ExtendedUI Language System

if extui == nil then
	extui = {};
end

extui.language = {};
extui.language.selectedLanguage = "eng";
extui.language.data = {};
extui.language.names = {};
extui.language.authors = {};
extui.language.extuiname = "ExtendedUI-2"


extui.language.defaultFile = [[{
	"eng": {
		"name": "English",
		"author": "Mizuki",
		"data": {
			"euiSettings": "Settings",
			"noSelect": "None Selected",
			"reloadUI": "Reload UI",
			"restore": "Restore Defaults",
			"savenclose": "Save&Close",
			"cancel": "Cancel",
			"close": "Close",
			"general": "General",
			"advanced": "Advanced",
			"less": "Less",
			"onlySelect": "Only edit selected frame",
			"position": "Position",
			"posxDesc": "Left/Right Position",
			"posyDesc": "Up/Down Position",
			"size": "Size",
			"width": "Width",
			"height": "Height",
			"curSkin": "Current Skin",
			"setSkin": "Set Skin",
			"chooseSkin": "Choose Skin",
			"showFrame": "Show Frame",
			"vistrue": "Visibility will be saved",
			"visfalse": "Visibility will not be saved",
			"loadMessage": "Remove Loaded Message",
			"loadMessageDesc": "Removes the \"ExtendedUI Loaded\" message on startup",
			"hideJoy": "Hide buttons from Joystick Quickslot",
			"hideJoyDesc": "Removes the \"Set 1\"/\"Set 2\" buttons from the Joystick Quickslot",
			"showExp": "Show EXP Numbers",
			"showExpDesc": "Shows exact exp numbers when hovering over the exp bars. (Updates after map change)",
			"disablePop": "Disable Recipe Item Popup",
			"disablePopDesc": "Disables the popup when getting an item for crafting.",
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
			"confirmReset": "Are you sure you want to reset{nl}all frames to their default positions?",
			"options": "Options",
			"lang": "Language",
			"resetFrame": "Reset Frame",
			"author": "Author"
		}
	},
	"ger": {
		"name": "German - Deutsch",
		"author": "Mizuki",
		"data": {
			"euiSettings": "Einstellungen",
			"noSelect": "Nichts Ausgewählt",
			"reloadUI": "UI neu laden",
			"restore": "Standard Wiederherstellen",
			"savenclose": "Schließen",
			"cancel": "Abbrechen",
			"close": "Schließen",
			"general": "Allgemein",
			"advanced": "Erweitert",
			"less": "Weniger",
			"onlySelect": "Nur ausgewählten frame bearbeiten",
			"position": "Position",
			"posxDesc": "Links/Rechts Position",
			"posyDesc": "Hoch/Runter Position",
			"size": "Größe",
			"width": "Breite",
			"height": "Höhe",
			"curSkin": "Aktueller Skin",
			"setSkin": "Skin setzen",
			"chooseSkin": "Skin auswählen",
			"showFrame": "Frame anzeigen",
			"vistrue": "Sichtbarkeit wird gespeichert",
			"visfalse": "Sichtbarkeit wird nicht gespeichert",
			"loadMessage": "Lade Nachricht entfernen",
			"loadMessageDesc": "Entfernt die \"ExtendedUI Loaded\" Nachricht beim start.",
			"hideJoy": "Joystick Quickslot Tasten ausblenden",
			"hideJoyDesc": "Entfernt die \"Set 1\"/\"Set 2\" Tasten vom Joystick Quickslot.",
			"showExp": "Zeige EXP Zahlen",
			"showExpDesc": "Zeigt exakte EXP beim hovern über den EXP-Balken an (Updates nach map änderung).",
			"disablePop": "Deaktiviere Rezept Item Popup",
			"disablePopDesc": "Deaktiviert das popup das angezeigt wird wenn ein item für crafting erhalten wird.",
			"lockQuest": "Quest Log Position Sperren",
			"lockQuestDesc": "Sperrt das Quest-Log, damit es sich nicht mehr in beide Richtungen bewegt, wenn neue Quests hinzugefügt oder entfernt werden.",
			"buffs": "Buffs",
			"bIconSize": "Buff Symbol Größe",
			"extBuff": "Erweiterte Buff Anzeige",
			"extBuffDesc": "Erweitert die buff anzeige um maximal 30 buffs anzuzeigen.",
			"buffAmt": "Betrag in Zeile",
			"buffAmtDesc": "Erzeugt neue Zeilen mit dieser Anzahl von Buffs. (Funktioniert nur bei erweiterter Buff Anzeige)",
			"buffSec": "Immer Sekunden Anzeigen",
			"buffSecDesc": "Zeigs (x)s anstatt (x)m.",
			"confirmReset": "Sind Sie sicher, dass Sie{nl}alle frames auf ihre Standardposition zurücksetzen möchten?",
			"options": "Optionen",
			"lang": "Sprache",
			"resetFrame": "Frame zurücksetzen",
			"author": "Autor"
		}
	},
	"ch": {
        "name": "Chinese - 華文",
        "author": "~Hoi",
        "data": {
			"euiSettings": "設定",
			"noSelect": "未選",
			"reloadUI": "刷新介面",
			"restore": "重置成預設",
			"savenclose": "儲存並關閉",
			"cancel": "取消",
			"close": "關閉",
			"general": "一般",
			"advanced": "進階",
			"less": "減少",
			"onlySelect": "只編輯己選介面",
			"position": "位置",
			"posxDesc": "左/右 位置",
			"posyDesc": "上/下 位置",
			"size": "大小",
			"width": "寬度",
			"height": "高度",
			"curSkin": "目前外觀",
			"setSkin": "設定外觀",
			"chooseSkin": "選擇外觀",
			"showFrame": "顯示介面",
			"vistrue": "將設為顯示",
			"visfalse": "將設為不顯示",
			"loadMessage": "移除己載入的訊息",
			"loadMessageDesc": "開啟遊戲時 將不會顯示 \"己載入 ExtendedUI\" 的訊息",
			"hideJoy": "隱藏 手把快捷鍵介面",
			"hideJoyDesc": "隱藏 手把快捷鍵的 \"Set 1\"/\"Set 2\" 按鈕",
			"showExp": "顯示經驗值數字",
			"showExpDesc": "當滑鼠移到經驗槽時 顯示確切的經驗值 (過圖後刷新)",
			"disablePop": "取消跳出 獲得圖紙材料的訊息",
			"disablePopDesc": "取消跳出 合成後獲得新物品的訊息",
			"lockQuest": "鎖定任務提示介面",
			"lockQuestDesc": "鎖定任務提示介面 且不會因為增加或減少新任務而移動",
			"buffs": "Buffs",
			"bIconSize": "Buff 圖示大小",
			"extBuff": "增加 Buff 顯示",
			"extBuffDesc": "增加 Buff 顯示到最大值30個buffs",
			"buffAmt": "行數",
			"buffAmtDesc": "增加新一行去顯示這個數量的buffs (只有在 \"增加 Buff 顯示\" 啟動中適用)",
			"buffSec": "總是顯示buff的秒數",
			"buffSecDesc": "不顯示分鐘數 (x)m 而只用秒數 (x)s",
			"confirmReset": "你確定你想重置{nl}所有視窗到他們的預設位置嗎?",
			"options": "選項",
			"lang": "語言",
			"resetFrame": "復位框架",
			"author": "作者"
		}
	},
	"por": {
		"name": "Portuguese - Português",
		"author": "Aru",
		"data": {
			"euiSettings": "Configurações",
			"noSelect": "Nada selecionado",
			"reloadUI": "Recarregar UI",
			"restore": "Restaurar Padrões",
			"savenclose": "Fechar&Salvar",
			"cancel": "Cancelar",
			"close": "Fechar",
			"general": "Geral",
			"advanced": "Avançado",
			"less": "Menos",
			"onlySelect": "Editar apenas o frame selecionado",
			"position": "Posição",
			"posxDesc": "Posição Esquerda/Direita",
			"posyDesc": "Posição Cima/Baixo",
			"size": "Tamanho",
			"width": "Largura",
			"height": "Altura",
			"curSkin": "Skin Atual",
			"setSkin": "Definir Skin",
			"chooseSkin": "Escolher Skin",
			"showFrame": "Mostrar Frame",
			"vistrue": "Visibilidade será salva",
			"visfalse": "Visibilidade não será salva",
			"loadMessage": "Remover mensagem de inicialização",
			"loadMessageDesc": "Remove a mensagem \"ExtendedUI Loaded\" ao iniciar",
			"hideJoy": "Esconder botões do Quickslot do Joystick",
			"hideJoyDesc": "Remove os botões \"Set 1\"/\"Set 2\" do Quickslot do Joystick",
			"showExp": "Mostrar Números de EXP",
			"showExpDesc": "Mostra os valores exatos de experiência ao posicionar o mouse sobre as barras de EXP. (Aplicado após mudar de mapa)",
			"disablePop": "Desativa Item Pop-up de Recipes",
			"disablePopDesc": "Desativa a pop-up ao obter items usados para crafting.",
			"lockQuest": "Travar Posição do Quest Log",
			"lockQuestDesc": "Trava o Quest Log evitando que ele se mova em ambas as direções quando novas quests são adicionadas ou removidas.",
			"buffs": "Buffs",
			"bIconSize": "Tamanho dos Ícones de Buffs",
			"extBuff": "Estender Barra de Buffs",
			"extBuffDesc": "Estende a barra de buffs para monstrar um máximo de 30 buffs.",
			"buffAmt": "Quantidade Por Linha",
			"buffAmtDesc": "Cria novas linhas com esse número de buffs. (Funciona somente quando estender barra de buffs está ativo)",
			"buffSec": "Sempre Mostrar Segundos",
			"buffSecDesc": "Mostra (x)s em vez de (x)m.",
			"confirmReset": "Tem certeza de que deseja restaurar{nl}todos os frames para suas posições padrões?",
			"options": "Opções",
			"lang": "Idioma",
			"resetFrame": "redefinir o frame",
			"author": "Autor"
		}
	},
	"pl": {
		"name": "Polish - Polski",
		"author": "Kalafiorek",
		"data": {
			"euiSettings": "Ustawienia",
			"noSelect": "Nie wybrano",
			"reloadUI": "Zresetuj UI",
			"restore": "Przywroc domyslne",
			"savenclose": "Akceptuj",
			"cancel": "Anuluj",
			"close": "Zamknij",
			"general": "Glowne",
			"advanced": "Zaawansowane",
			"less": "Mniej",
			"onlySelect": "Edytuj jedynie wybrana ramke",
			"position": "Pozycja",
			"posxDesc": "Pozycja lewo/prawo",
			"posyDesc": "Pozycja gora/dol",
			"size": "Wymiary",
			"width": "Szerokosc",
			"height": "Wysokosc",
			"curSkin": "Obecna skorka",
			"setSkin": "Zmien skorke",
			"chooseSkin": "Wybierz skorke",
			"showFrame": "Pokaz ramke",
			"vistrue": "Widocznosc zostanie zapisana",
			"visfalse": "Widocznosc nie zostanie zapisana",
			"loadMessage": "Ukryj wiadomosc powitalna",
			"loadMessageDesc": "Ukrywa wiadomosc \"ExtendedUI Loaded\" podczas startu.",
			"hideJoy": "Ukryj guziki zestawow gamepada",
			"hideJoyDesc": "Ukrywa guziki \"Set 1\"/\"Set 2\" oznaczajace zestawy hotkeyow gamepada.",
			"showExp": "Pokaz wartosci doswiadczenia",
			"showExpDesc": "Pokazuje dokladne wartosci liczbowe EXP gdy unosisz nad paskiem doswiadczenia (aktualizowane przy zmianie mapy).",
			"disablePop": "Ukryj wyskakujace okienka recept",
			"disablePopDesc": "Ukrywa okienka popup, ktore wystepuja przy podniesieniu przedmiotu do recepty.",
			"lockQuest": "Zablokuj pozycje dziennika zadan",
			"lockQuestDesc": "Blokuje pozycje dziennika zadan tak, by nie poruszal sie w obu kierunkach, kiedy zadania sa dodawane lub usuwane.",
			"buffs": "Buffy",
			"bIconSize": "Rozmiar ikon buffow",
			"extBuff": "Rozszerz wyswietlanie buffow",
			"extBuffDesc": "Rozszerza wyswietlanie buffow by zezwolic na pokazywanie ich do maksymalnie 30.",
			"buffAmt": "Ilosc w rzedzie",
			"buffAmtDesc": "Tworzy rzedy buffow o podanym rozmiarze (dziala jedynie przy zaznaczeniu powyzszej opcji).",
			"buffSec": "Zawsze pokazuj same sekundy",
			"buffSecDesc": "Pokazuje sekundy w pozostalym czasie trwania buffow zamiast minut.",
			"confirmReset": "Jestes pewny/a, ze chcesz zresetowac{nl}wszystkie ramki do domyslnych pozycji?",
			"options": "Opcje",
			"lang": "Jezyk",
			"resetFrame": "zresetuj ramke",
			"author": "Autor"
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

function extui.language.GetAuthor()
	if extui.language.authors[extui.language.selectedLanguage] == nil then
		return "NoAuthor#"..tostring(extui.language.selectedLanguage);
	end

	return extui.language.authors[extui.language.selectedLanguage];
end

function extui.language.LoadFile()
	local acutil = require("acutil");

	local tload, error = acutil.loadJSON("../addons/extendedui/language.json");
	if not error then
		for k,v in pairs(tload) do
			extui.language.data[k] = v.data;
			extui.language.names[k] = v.name;
			extui.language.authors[k] = v.author;
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
