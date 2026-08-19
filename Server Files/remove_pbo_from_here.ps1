# D�finit le chemin d'ex�cution du script
$scriptPath = $PSScriptRoot

# D�finir les noms des fichiers � supprimer
$filesToDelete = @("A3PL_Backend.pbo", "A3PL.FishersIsland.pbo")

# Boucle � travers les fichiers et les supprime s'ils existent
foreach ($file in $filesToDelete) {
    $filePath = Join-Path -Path $scriptPath -ChildPath $file
    if (Test-Path $filePath) {
        Remove-Item -Path $filePath -Force
        Write-Output "Fichier supprime : $filePath"
    } else {
        Write-Output "Fichier non trouve : $filePath"
    }
}