<# 
Makes a copy of evidence files
Sets permissions to read-only
#>


 #Set the subfolder name, create the path string
$evidenceFolderName = "evidence"
$evidenceFolderPath = Join-Path -Path $PWD -ChildPath $evidenceFolderName

$copyFolderName = "evidence-copy"
$copyFolderPath= Join-Path -Path $PWD -ChildPath $copyFolderName


#If the copy folder exists already, skip creating one, otherwise make a subfolder
if (Test-Path -Path $copyFolderPath -PathType Container) {
    Write-Output ""
    Write-Output " evidence-copy subfolder exists"
    Write-Output ""
} else {
    Write-Output ""
    Write-Output "copy subfolder does not exist, creating:"
    New-Item -Path $copyFolderPath -ItemType Directory
    Write-Output ""
    Write-Output "done."
}


$filelist = Get-ChildItem -Path $evidencefolderPath -File -Recurse
foreach ($file in $filelist){
    $activeFileName = $file.Name
    $outputFileName = "copy_${activeFileName}"
    Copy-Item -Path $file.FullName -Destination $copyFolderPath\$outputFileName
}


