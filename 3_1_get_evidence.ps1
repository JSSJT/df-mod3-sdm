<#
This will pull the last 1000 login events.  I tried tinkering with the filter to remove the System username logins but I couldn't get it to work.  
I also tried filtering by LogType of 2 (local) or 11 (remote credentials) but that returned nothing, even though the full log has my logins of type 11
It at least pulls the log events, just requires some scrolling.

Must execute with elevated PS privileges.
#>

$evidenceFolderName = "evidence"
$evidenceFolderPath = Join-Path -Path $PWD -ChildPath $evidenceFolderName
 
 
 #If the copy folder exists already, skip creating one, otherwise make a subfolder
 if (Test-Path -Path $evidenceFolderPath -PathType Container) {
     Write-Output ""
     Write-Output " evidence subfolder exists"
     Write-Output ""
 } else {
     Write-Output ""
     Write-Output "copy subfolder does not exist, creating:"
     New-Item -Path $evidenceFolderPath -ItemType Directory
     Write-Output ""
     Write-Output "done."
 }


# Get the Security event log entries for Event ID 4624 (successful logon) where the TargetUserName is not "System"
$logonEvents = Get-WinEvent -LogName Security -FilterXPath '*[System[(EventID=4624)]]' -MaxEvents 1000 | Where-Object {
    $eventXml = [xml]$_."ToXml()"
    $targetUserName = $eventXml.Event.EventData.Data | Where-Object { $_.Name -eq 'TargetUserName' } | Select-Object -ExpandProperty '#text'
    $targetUserName -ne 'System'
}

# Format the full text of each event
$eventTexts = $logonEvents | ForEach-Object {
    $_.ToXml() | Out-String
}

# Write the full text of events to the text file
$eventTexts | Out-File -FilePath $evidenceFolderPath\events.txt -Encoding UTF8
Write-Output ""
Write-Output "Filtered full event texts have been saved to $evidenceFolderPath\events.txt"
Write-Output ""

<#
This will search the registry for email accounts (used for a Windows login) and output to a text file in the evidence folder.
This is an example only, it could be modified to look in the registry for other email client applications, other accounts, etc.
For demonstration only.

Must execute with elevated PS privileges.
#>

Reg Query HKEY_Current_User\Software\Microsoft\Office\16.0\Outlook\Profiles\Outlook /s /f hotmail > $evidenceFolderPath\email.txt
Write-Output ""
Write-Output "Email result written to $evidenceFolderPath\email.txt"
Write-Output ""