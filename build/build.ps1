$outputDir = "release"
$name = "extendedui"

$ipfDir = "$outputDir\temp\addon_d.ipf\$name";
Write-Output "Creating $ipfDir directory"
New-Item -ItemType Directory -Force $ipfDir | Out-Null

Write-Output "Copying .lua and .xml files"
Get-ChildItem -Filter . .\src\*.lua | Copy-Item -Destination $ipfDir
Get-ChildItem -Filter . .\src\*.xml | Copy-Item -Destination $ipfDir

Write-Output "Creating IPF file"
py -3 ..\build\buildtools\ipf.py -c -f "$outputDir\$name.ipf" "$outputDir\temp"
Write-Output "-done"

Write-Output "Encrypting IPF file"
& ..\build\buildtools\IPFUnpacker\ipf_unpack.exe "$outputDir\$name.ipf" encrypt
Move-Item "$outputDir\$name.ipf" "$outputDir\$name.ipf"

Write-Output "Done"
