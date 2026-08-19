# D finir les chemins
$sourceFishersIsland = "A3PL.FishersIsland"
$sourceBackend = "A3PL_Backend"
$pboConsolePath = "..\PBOManager\pboconsole.exe"

# Fonction pour empaqueter un dossier en PBO
function Pack-Pbo {
    param (
        [string]$folderPath,  # Le chemin du dossier   empaqueter
        [string]$outputPath   # Le dossier o  le fichier PBO doit  tre d plac 
    )

    # Ex cuter pboconsole.exe pour empaqueter le dossier en PBO
    $process = Start-Process -FilePath $pboConsolePath -ArgumentList "-pack `"$folderPath`"" -NoNewWindow -PassThru -Wait

    # V rifier si la commande a r ussi
    if ($process.ExitCode -ne 0) {
        Write-Host "Une erreur s'est produite lors de l'empaquetage en PBO pour le dossier: $folderPath"
    } else {
        Write-Host "Packing en PBO termine avec succes pour le dossier: $folderPath"
    }
}

# Empaqueter les dossiers en PBO et d placer les fichiers
Pack-Pbo -folderPath "A3PL.FishersIsland"
Pack-Pbo -folderPath "A3PL_Backend"

Write-Host "Toutes les op rations ont  t  effectu es avec succ s."
