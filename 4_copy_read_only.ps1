<# 
Sets the permissions to read-only on the evidence copy folder
#>



 $copyFolderName = "evidence-copy"
 $copyFolderPath= Join-Path -Path $PWD -ChildPath $copyFolderName
 
 
  #Set the evidence folder to read-only to prevent changes
  icacls $copyFolderPath\* /grant:r Users:R /T /C

 