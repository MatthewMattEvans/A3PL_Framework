# Developped by Arma 3 Project Life Team
# Cet outil permet de faire un FETCH du repository du framework, puis de pack en pbo et les dÃ©placer dans les folders du serveur A3
# Il doit fonctionner avec le Server Manager
#
#
#
#
#
# NE PAS TOUCHER
#
#
#
#
#
#
#
# DÃ©finir les chemins
$sourceFishersIsland = "C:\Git\Server Files\A3PL.FishersIsland"
$sourceBackend = "C:\Git\Server Files\A3PL_Backend"
$tempFolder = "C:\TempFiles"
$mpmissionsPath = "C:\Server\mpmissions"
$addonsPath = "C:\Addons\@framework\addons"
$pboConsolePath = "C:\Scripts\PBOManager\pboconsole.exe"

# DÃ©finir les variables
$repoUrl = "git@git.northbridgeinteractive.com:a3pl-sqf-developer/framework.git"
$targetDir = "C:\Git"
$sshKeyPath = "C:\Scripts\.ssh\id_ed25519"

# Configurer SSH pour Git
$env:GIT_SSH_COMMAND = "ssh -i `"$sshKeyPath`" -p 2222 -o StrictHostKeyChecking=no"

# VÃ©rifier si le rÃ©pertoire existe et s'il contient un dÃ©pÃ´t Git
if ((Test-Path $targetDir) -and (Test-Path "$targetDir\.git")) {
    Write-Host "Le repertoire existe, mise a jour du depot..."
    Set-Location $targetDir
    
    # VÃ©rifier s'il y a des modifications locales Ã  sauvegarder
    $hasChanges = git diff --quiet; $LASTEXITCODE -ne 0
    $hasUntracked = (git ls-files --others --exclude-standard).Count -gt 0
    
    $stashCreated = $false
    if ($hasChanges -or $hasUntracked) {
        Write-Host "Sauvegarde des modifications locales..."
        git add -A
        git stash push -m "Auto-stash before update"
        $stashCreated = $true
    }
    
    git fetch --all
    git checkout main
    
    # VÃ©rifier s'il y a des diffÃ©rences entre local et remote
    $localCommit = git rev-parse HEAD
    $remoteCommit = git rev-parse origin/main
    
    if ($localCommit -ne $remoteCommit) {
        Write-Host "Des modifications ont ete detectees sur le serveur distant."
        $response = Read-Host "Voulez-vous ecraser vos fichiers locaux avec ceux du serveur? (y/N)"
        
        if ($response -eq "y" -or $response -eq "Y") {
            Write-Host "Ecrasement des fichiers locaux..."
            git reset --hard origin/main
            git clean -fd
            Write-Host "Fichiers synchronises avec le serveur distant."
        } else {
            Write-Host "Operation annulee par l'utilisateur."
            # Restaurer les modifications si elles ont Ã©tÃ© stashÃ©es
            if ($stashCreated) {
                git stash pop
            }
            exit 1
        }
    } else {
        Write-Host "Aucune modification detectee sur le serveur distant."
        # Forcer la synchronisation pour s'assurer que tous les fichiers sont prÃ©sents
        git reset --hard origin/main
        git clean -fd
    }
    
    # Restaurer les modifications locales si elles ont Ã©tÃ© stashÃ©es et si l'utilisateur a acceptÃ©
    if ($stashCreated -and ($response -eq "y" -or $response -eq "Y" -or $localCommit -eq $remoteCommit)) {
        Write-Host "Restauration des modifications locales..."
        git stash pop
    }
} else {
    # Si le rÃ©pertoire existe mais n'est pas un dÃ©pÃ´t Git, on le supprime
    if (Test-Path $targetDir) {
        Write-Host "Le repertoire existe mais n'est pas un depot Git. Suppression du repertoire..."
        Remove-Item -Recurse -Force $targetDir
    }

    Write-Host "Clonage du depot dans $targetDir..."
    git clone $repoUrl $targetDir
}

# CrÃ©er le dossier temporaire s'il n'existe pas
if (-Not (Test-Path $tempFolder)) {
    New-Item -Path $tempFolder -ItemType Directory
}

# Copier les dossiers vers le dossier temporaire
Copy-Item -Path $sourceFishersIsland -Destination $tempFolder -Recurse -Force
Copy-Item -Path $sourceBackend -Destination $tempFolder -Recurse -Force


# Fonction pour empaqueter un dossier en PBO
function Pack-Pbo {
    param (
        [string]$folderPath,  # Le chemin du dossier ï¿½ empaqueter
        [string]$outputPath   # Le dossier oÃ¹ le fichier PBO doit Ãªtre dÃ©placÃ©
    )

    # DÃ©tecter le rÃ©pertoire oÃ¹ l'application .exe est situÃ©e (le rÃ©pertoire actuel)
    $exeDirectory = Get-Location

    # Exï¿½cuter pboconsole.exe pour empaqueter le dossier en PBO
    $process = Start-Process -FilePath $pboConsolePath -ArgumentList "-pack `"$folderPath`"" -NoNewWindow -PassThru -Wait

    # VÃ©rifier si la commande a rÃ©ussi
    if ($process.ExitCode -ne 0) {
        Write-Host "Une erreur s'est produite lors de l'empaquetage en PBO pour le dossier: $folderPath"
    } else {
        Write-Host "Packing en PBO termine avec succes pour le dossier: $folderPath"

        # Chercher les fichiers .pbo qui ont Ã©tÃ© crÃ©Ã©s dans le rÃ©pertoire de l'exÃ©cutable
        $pboFiles = Get-ChildItem -Path $exeDirectory -Filter "*.pbo"

        if ($pboFiles.Count -gt 0) {
            # CrÃ©er le dossier de destination s'il n'existe pas
            if (-Not (Test-Path $outputPath)) {
                New-Item -Path $outputPath -ItemType Directory
            }

            # DÃ©placer tous les fichiers PBO vers le dossier de destination
            foreach ($pboFile in $pboFiles) {
                Move-Item -Path $pboFile.FullName -Destination $outputPath -Force
                Write-Host "Le fichier PBO $($pboFile.Name) a ete deplace vers: $outputPath"
            }
        } else {
            Write-Host "Aucun fichier PBO trouvÃ© dans le repertoire: $exeDirectory"
        }
    }
}

# Empaqueter les dossiers en PBO et dÃ©placer les fichiers
Pack-Pbo -folderPath "$tempFolder\A3PL.FishersIsland" -outputPath $tempFolder
Pack-Pbo -folderPath "$tempFolder\A3PL_Backend" -outputPath $tempFolder


# Supprimer le contenu des dossiers cibles avant le dÃ©placement des fichiers PBO
Remove-Item -Path "$mpmissionsPath\*" -Recurse -Force
Remove-Item -Path "$addonsPath\*" -Recurse -Force

# DÃ©placer les fichiers PBO vers les dossiers cibles appropriÃ©s
Move-Item -Path "$tempFolder\A3PL.FishersIsland.pbo" -Destination $mpmissionsPath -Force
Move-Item -Path "$tempFolder\A3PL_Backend.pbo" -Destination $addonsPath -Force

# Supprimer le contenu du dossier temporaire sauf pbo.ps1
Get-ChildItem -Path $tempFolder | Where-Object { $_.Name -ne 'pbo.ps1' } | Remove-Item -Recurse -Force

Write-Host "Toutes les opÃ©rations ont Ã©tÃ© effectuÃ©es avec succÃ¨s."
