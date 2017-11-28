$outputDir = "release"
$name = "extendedui"

$ipfDir = "$outputDir\temp\addon_d.ipf\$name";
$uiBaseDir = "$outputDir\temp\ui.ipf\baseskinset";
$uiSkinDir = "$outputDir\temp\ui.ipf\skin";
Write-Output "Creating $ipfDir directory"
New-Item -ItemType Directory -Force $ipfDir | Out-Null
New-Item -ItemType Directory -Force $uiDir | Out-Null

Write-Output "Copying .lua and .xml files"
Get-ChildItem -Filter . .\src\addon_d\*.lua | Copy-Item -Destination $ipfDir
Get-ChildItem -Filter . .\src\addon_d\*.xml | Copy-Item -Destination $ipfDir
Get-ChildItem -Filter . .\src\ui\baseskinset\*.xml | Copy-Item -Destination $uiBaseDir
Get-ChildItem -Filter . .\src\ui\skin\*.tga | Copy-Item -Destination $uiSkinDir

Write-Output "Creating IPF file"
py -3 $PSScriptRoot\buildtools\ipf.py -c -f "$outputDir\$name.ipf" "$outputDir\temp"
Write-Output "-done"

Write-Output "Encrypting IPF file"
& $PSScriptRoot\buildtools\IPFUnpacker\ipf_unpack.exe "$outputDir\$name.ipf" encrypt

Move-Item "$outputDir\$name.ipf" "$PSScriptRoot\..\extendedui.ipf"
Write-Output "Done"
