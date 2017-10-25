
## ExtendedUI-2

ExtendedUI-2 allows you to move UI elements on your screen to wherever you want them.  
It also comes with a few nice options to customize your UI even further, including:
- Showing exact experience numbers when hovering over your experience bars
- Disabling recipe item popups
- Removing the Set1/Set2 Buttons from the Joystick Quickslot
- Extended Buff Display

ExtendedUI-2 comes in multiple languages selectable through the Settings Cog.
- English
- German
- BR Portugese
- Traditional Chinese
- Polish

If you would like to add additional languages, please edit the languages.json file and open a [Pull Request](https://github.com/MizukiBelhi/ExtendedUI/pulls).

## Issues

Please send me a private message on the TOS Dev Community [Discord](https://discord.gg/hgxRFwy).  
Alternatively, please open up an [issue](https://github.com/MizukiBelhi/ExtendedUI/issues).


## Installation

___DO NOT DOWNLOAD THE SOURCE DIRECTLY OFF THE REPOSITORY IT WILL NOT WORK___  
___ONLY INSTALL EXTENDEDUI WITH THE ADDON MANAGER___

1. Download the [jAddon Manager](https://github.com/JTosAddon/Tree-of-Savior-Addon-Manager/releases).
2. Find ExtendedUI-2 in the list and install it.
3. Start your game.


## Usage

After installing ExtendedUI-2 you're ready to use it!  
If your installation was successful you should see an addon button on the bottom of your screen, if you click it, one or multiple new icons should appear, in this list find ExtendedUI, this should open the UI-Edit window where you can customize your UI.

1. Frame List
![Screenshot](http://pandadesigns.web44.net/extendedui/options.png)
You are able to select which frame to edit from this list.

2. Only Edit Selected Frames Checkbox
![Screenshot](http://pandadesigns.web44.net/extendedui/options.png)
This checkbox shows all frames that can be edited on the screen, as if you would have selected every frame in the list.

3. Advanced
![Screenshot](http://pandadesigns.web44.net/extendedui/options.png)
Shows advanced settings for editing a selected frame.

4. Settings Cog
![Screenshot](http://pandadesigns.web44.net/extendedui/options.png)
Features and settings for ExtendedUI-2.


## For Developers
1. [Example](#example)
2. [Object and Function Reference](#object-and-function-reference)
	1. [extui](#--extui)
		1. [CreateNewAddon](#extuicreatenewaddon)
	2. [extuiAddon](#--extuiaddon)
		1. [IsInUse](#extuiaddonisinuse)
		2. [AddFrame](#extuiaddonaddframe)
		3. [RemoveFrame](#extuiaddonremoveframe)
	3. [extuiFrame](#--extuiframe)
		1. [frameObject](#frame-object)
		2. [AddChild](#extuiframeaddchild)
	4. [frameTable](#--frametable)


### Example
ExtendedUI-2 allows developers to add their own or already existing frames through the use of ``addon:RegisterMsg``.  
Example:

```Lua
function MY_ADDON_ON_INIT(addon, frame)
	addon:RegisterMsg("EXTENDEDUI_ON_FRAME_LOAD", "MY_FUNCTION");
	...
end

function MY_FUNCTION()
	local euiAddon = extui.CreateNewAddon("YOUR_ADDON");
	local euiFrame = euiAddon:AddFrame("buff", "Buffs");
end
```
This should create a new list, if it doesn't already exist, with "UI" and "YOUR_ADDON" as selections, if selected, the frame list will contain the frames you have added.


### Object and Function Reference

#### - extui

###### extui.CreateNewAddon()
- Parameters: [String]addonName
- Returns:  [Object][extuiAddon](#--extuiaddon).
  

#### - extuiAddon

###### extuiAddon:IsInUse()
- Parameters: -
- Returns:  [Bool]inUse.
- Comments: Returns if addon is in use.

##### extuiAddon:AddFrame()
- Parameters: [String]frameName, [Multiple][frameTable](#--frametable)
- Returns: [Object][extuiFrame](#--extuiframe)

##### extuiAddon:RemoveFrame()
- Parameters: [String]frameName
- Returns: -

#### - extuiFrame

##### frame Object

Please do not write to internal variables, it might break EUI.
- *internal* [String]name
- [Bool]isMovable (default: true)
- *internal* [Bool]hasChild
- [Bool]noResize (default: true)
- *internal* [Bool]show
- *internal* [List]child
- [Function]onUpdate(x, y, w, h)

##### extuiFrame:AddChild()
- Parameters: [String]childFrameName, [String]displayName
- Returns: -


#### - frameTable

Can be [String]displayName or table:
```Lua
	local frameTable = {
		["name"] = "displayName",
		["isMovable"] = true,
		["noResize"] = true,
		["onUpdate"] = function(x, y, w, h) ... end,
	};
```








