$items = @("*Favicons*","*History*","*Cookies*","*Web Data*","*Media Cache*","*Cache*", "*visited Links*")

$oldErrorActionPreference = $ErrorActionPreference
$ErrorActionPreference = 'SilentlyContinue'

$Chromepath = "$($env:LOCALAPPDATA)\Google\Chrome\User Data\Default"
if (Test-Path -Path $Chromepath -PathType Container) {
    $chrome = Get-Process chrome 
    if($chrome){Stop-Process $chrome -force}
    $Cfiles += $items | ForEach-Object{
        $name = $_
        Get-ChildItem $Chromepath -Recurse -Force |
        Where-Object{$_.Name -like $name}
    }
    #$Cfiles | ForEach-Object {Write-Host $_.FullName}
    $Cfiles| ForEach-Object  {Remove-Item $_.FullName -Force -Recurse -Verbose}
  
}s

$fireFoxPath = "$($env:LOCALAPPDATA)\Mozilla\Firefox\Profiles"
$fireFoxPath2 = "$($env:APPDATA)\\Mozilla\Firefox\Profiles"
if (Test-Path -Path $fireFoxPath -PathType Container) {
    $firefox = Get-Process firefox
    if($firefox){Stop-Process $firefox -Force}
    $ffiles += $items | ForEach-Object{
        $name = $_
        Get-ChildItem $fireFoxPath -Recurse -Force |
        Where-Object{$_.Name -like $name -or $_.name -like 'parent.lock'}
    }
    $ffiles2 += $items | ForEach-Object{
        $name = $_
        Get-ChildItem $fireFoxPath2 -Recurse -Force |
        Where-Object{$_.Name -like $name -or $_.name -like 'parent.lock'}
    }

    <#$ffiles | ForEach-Object {Write-Host $_.FullName}
    $ffiles2 | ForEach-Object {Write-Host $_.FullName}#>
    $ffiles | ForEach-Object  {Remove-Item $_.FullName -Force -Recurse -Verbose}
    $ffiles2 | ForEach-Object  {Remove-Item $_.FullName -Force -Recurse -Verbose}
}

$Edgepath = "$($env:LOCALAPPDATA)\Microsoft\Edge\User Data\default"
if (Test-Path -Path $Edgepath  -PathType Container) {
    $msedge = Get-Process msedge
    if($msedge){stop-process $msedge -force}
    $Efiles += $items | ForEach-Object{
        $name = $_
        Get-ChildItem $Edgepath -Recurse -Force |
        Where-Object{$_.Name -like $name -or $_.name -like 'parent.lock'}
    }
    # $Efiles | ForEach-Object {Write-Host $_.FullName}
    $Efiles | ForEach-Object {remove-item $_.FullName -Force -Recurse -verbose}
}


#clean windows
$ie = get-process iexplore 
if($ie){ Stop-Process $ie}
Remove-item -path "$($env:LOCALAPPDATA)\Microsoft\Windows\history\*" -force -Recurse  -Verbose #clears windows explorer history
Remove-item -path "$($env:LOCALAPPDATA)\Microsoft\Windows\caches\*" -force -Recurse  -Verbose
Remove-item -path "$($env:LOCALAPPDATA)\Microsoft\Windows\INetCache\*" -force -Recurse -Verbose
Remove-item -path "$($env:LOCALAPPDATA)\temp\*" -force -Recurse  -Verbose
Remove-Item -path "$($env:windir)\temp\*" -force -Recurse -Verbose

$ErrorActionPreference = $oldErrorActionPreference