param (
   [string]$ISOFileName
)

# Repository dosyasını indirin ve içeriğini okuyun
$RepoUrl = "http://example.com/repository.xml"
$LocalRepoFile = ".\repo.xml"
Invoke-WebRequest -Uri $RepoUrl -OutFile $LocalRepoFile
$RepoContent = Get-Content $LocalRepoFile

# Indirilmiş ISO dosyalarını tarayın ve güncel sürümlerini indirin
$LocalISOs = Get-ChildItem -Path ".\download" | Where-Object { $_.Extension -eq ".iso" }
foreach ($LocalISO in $LocalISOs)
{
   # ISO dosyasının adını ve sürümünü alın
   $Name = $LocalISO.Name -replace ".iso", ""
   $Version = $LocalISO.Name -replace "$Name-", "" -replace ".iso", ""

   # ISO dosyasının güncel sürümünü alın
   $ISO = Select-Xml -Content $RepoContent -XPath "//iso[name='$Name' and version>'$Version']"
   if ($ISO)
   {
      # Güncel sürüm varsa, indirin
      $ISOLink = $ISO.Node.link.InnerText
      Invoke-WebRequest -Uri $ISOLink -OutFile "$Name-$($ISO.Node.version).iso"
   }
}
