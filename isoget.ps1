Install-Module -Name Invoke-WebRequest -Force
Install-Module -Name XML -Force

param (
   [string]$ISOFileName,
   [string]$Version
)

# Repository dosyasını yükleyin ve içeriğini okuyun
$RepoFile = "C:\Repositories\repository.xml"
$RepoContent = Get-Content $RepoFile

# ISO dosyasını arayın ve linkini alın
$ISO = Select-Xml -Content $RepoContent -XPath "//iso[name='$ISOFileName' and version='$Version']"
$ISOLink = $ISO.Node.link.InnerText

# ISO dosyasını indirin
Invoke-WebRequest -Uri $ISOLink -OutFile "$ISOFileName-$Version.iso"
