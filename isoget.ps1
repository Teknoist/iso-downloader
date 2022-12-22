Install-Module -Name Invoke-WebRequest -Force
Install-Module -Name XML -Force

param (
   [string]$install,
   [string]$ver
)

# Repository dosyasını indirin
$RepoUrl = "http://example.com/repository.xml"
$LocalRepoFile = ".\repo.xml"
Invoke-WebRequest -Uri $RepoUrl -OutFile $LocalRepoFile

# Repository dosyasını yükleyin ve içeriğini okuyun
$RepoFile = ".\repo.xml"
$RepoContent = Get-Content $RepoFile

# ISO dosyasını arayın ve linkini alın
$ISO = Select-Xml -Content $RepoContent -XPath "//iso[name='$install' and version='$ver']"
$ISOLink = $ISO.Node.link.InnerText

# ISO dosyasını indirin
Invoke-WebRequest -Uri $ISOLink -OutFile "$install-$ver.iso"
