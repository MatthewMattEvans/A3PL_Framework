# D�finir les chemins
$sourceFishersIsland = "C:\_Git\FYD\Server Files\POLARION.FishersIsland"
$sourceBackend = "C:\_Git\FYD\Server Files\PO_Backend"
$tempFolder = "C:\_TempFiles"
$mpmissionsPath = "C:\_Servers\A3_1\mpmissions"
$addonsPath = "C:\_Addons\A3_1\@POS\addons"
$pboConsolePath = "C:\_Git\FYD\PBOManager\pboconsole.exe"

# D�finir les variables
$token = "b1416cc852e0bff9be2ba4ed32da16ff38eb0722"
$repoUrl = "https://$token@git.projets-opacity.tech/Projets-Opacity/POLARION_ArmA3-RPG_Framework.git"
$targetDir = "C:\_Git\FYD"
$branchName = "FYD_DEV"

# V�rifier si le r�pertoire existe et s'il contient un d�p�t Git
if ((Test-Path $targetDir) -and (Test-Path "$targetDir\.git")) {
    Write-Host "Le repertoire existe, mise � jour du depot..."
    Set-Location $targetDir
    
    # Fetch tous les changements
    git fetch --all
    
    # V�rifier si la branche dev existe localement
    $localBranch = git branch --list $branchName
    
    if ($localBranch) {
        # Si la branche existe localement, on se positionne dessus et on pull
        git checkout $branchName
        git pull origin $branchName
    } else {
        # Si la branche n'existe pas localement, on la cr�e en se basant sur origin/dev
        git checkout -b $branchName origin/$branchName
    }
    
    Write-Host "Branche $branchName mise � jour avec succ�s"
} else {
    # Si le r�pertoire existe mais n'est pas un d�p�t Git, on le supprime
    if (Test-Path $targetDir) {
        Write-Host "Le repertoire existe mais n'est pas un depot Git. Suppression du repertoire..."
        Remove-Item -Recurse -Force $targetDir
    }

    Write-Host "Clonage du depot dans $targetDir..."
    git clone -b $branchName $repoUrl $targetDir
}

# Cr�er le dossier temporaire s'il n'existe pas
if (-Not (Test-Path $tempFolder)) {
    New-Item -Path $tempFolder -ItemType Directory
}

# Copier les dossiers vers le dossier temporaire
Copy-Item -Path $sourceFishersIsland -Destination $tempFolder -Recurse -Force
Copy-Item -Path $sourceBackend -Destination $tempFolder -Recurse -Force

# Fonction pour empaqueter un dossier en PBO
function Pack-Pbo {
    param (
        [string]$folderPath,  # Le chemin du dossier � empaqueter
        [string]$outputPath   # Le dossier o� le fichier PBO doit �tre d�plac�
    )

    # D�tecter le r�pertoire o� l'application .exe est situ�e (le r�pertoire actuel)
    $exeDirectory = Get-Location

    # Ex�cuter pboconsole.exe pour empaqueter le dossier en PBO
    $process = Start-Process -FilePath $pboConsolePath -ArgumentList "-pack `"$folderPath`"" -NoNewWindow -PassThru -Wait

    # V�rifier si la commande a r�ussi
    if ($process.ExitCode -ne 0) {
        Write-Host "Une erreur s'est produite lors de l'empaquetage en PBO pour le dossier: $folderPath"
    } else {
        Write-Host "Packing en PBO termin� avec succ�s pour le dossier: $folderPath"

        # Chercher les fichiers .pbo qui ont �t� cr��s dans le r�pertoire de l'ex�cutable
        $pboFiles = Get-ChildItem -Path $exeDirectory -Filter "*.pbo"

        if ($pboFiles.Count -gt 0) {
            # Cr�er le dossier de destination s'il n'existe pas
            if (-Not (Test-Path $outputPath)) {
                New-Item -Path $outputPath -ItemType Directory
            }

            # D�placer tous les fichiers PBO vers le dossier de destination
            foreach ($pboFile in $pboFiles) {
                Move-Item -Path $pboFile.FullName -Destination $outputPath -Force
                Write-Host "Le fichier PBO $($pboFile.Name) a �t� d�plac� vers: $outputPath"
            }
        } else {
            Write-Host "Aucun fichier PBO trouv� dans le r�pertoire: $exeDirectory"
        }
    }
}

# Empaqueter les dossiers en PBO et d�placer les fichiers
Pack-Pbo -folderPath "$tempFolder\POLARION.FishersIsland" -outputPath "C:\_TempFiles"
Pack-Pbo -folderPath "$tempFolder\PO_Backend" -outputPath "C:\_TempFiles"

# Supprimer le contenu des dossiers cibles avant le d�placement des fichiers PBO
Remove-Item -Path "$mpmissionsPath\*" -Recurse -Force
Remove-Item -Path "$addonsPath\*" -Recurse -Force

# D�placer les fichiers PBO vers les dossiers cibles appropri�s
Move-Item -Path "$tempFolder\POLARION.FishersIsland.pbo" -Destination $mpmissionsPath -Force
Move-Item -Path "$tempFolder\PO_Backend.pbo" -Destination $addonsPath -Force

# Supprimer le contenu du dossier temporaire sauf pbo.ps1
Get-ChildItem -Path $tempFolder | Where-Object { $_.Name -ne 'pbo.ps1' } | Remove-Item -Recurse -Force

Write-Host "Toutes les op�rations ont �t� effectu�es avec succ�s."