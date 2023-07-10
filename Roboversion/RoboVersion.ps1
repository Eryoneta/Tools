﻿# RoboVersion:
#   -OrigPath, -OP:
#     Cominho da pasta com os arquivos a serem versionados
#     O caminho deve existir
#   -DestPath, -DP:
#     Cominho da pasta com os arquivos versionados
#     O caminho deve ser válido
#   -Threads, -T:
#     Número de processos em paralelo
#     Deve ser entre 1 e 128
#   -VersionLimit, -VL, -V:
#     A quantidade máxima de versões antes de deletar os mais antigos
#     Deve ser entre 0 e 99999
#   -RemotionCountdown, -RC, -R:
#     A quantidade de execuções do script antes de deletar os arquivos marcados como removidos
#     Deve ser entre 0 e 99999
#   -Destructive, -D:
#     Garante que não haja arquivos versionados e removidos acima do valor da versão e remoção dados
#   - ListOnly, -LO, -L:
#     Lista apenas, sem alterar os arquivos
Function RoboVersion {
	[CmdletBinding()]
	Param(
		[Parameter(Mandatory = $True, Position = 0, HelpMessage = "Caminho absoluto dos arquivos a serem versionados")]
			[Alias("OP")]
			[ValidateScript({
				If(-Not (Test-Path -Path $_)) {
					Throw [System.Management.Automation.ItemNotFoundException] "A pasta '${_}' não foi encontrada!"
				} Else {
					$True;
				}
			})]
			[string] $OrigPath,
		[Parameter(Mandatory = $True, Position = 1, HelpMessage = "Caminho absoluto da pasta de destino dos arquivos versionados")]
			[Alias("DP")]
			[ValidateScript({
				If(-Not (Test-Path -Path $_ -IsValid)) {
					Throw [System.Management.Automation.ItemNotFoundException] "A pasta '${_}' não é válida!";
				} Else {
					$True;
				}
			})]
			[string] $DestPath,
		[Parameter()]
			[Alias("T")]
			[ValidateRange(1,128)]
			[int] $Threads = 8,
		[Parameter()]
			[Alias("V", "VL")]
			[ValidateRange(0,99999)]
			[int] $VersionLimit = 5,
		[Parameter()]
			[Alias("R", "RC")]
			[ValidateRange(0,99999)]
			[int] $RemotionCountdown = 10,
		[Parameter()]
			[Alias("D")]
			[switch] $Destructive = $False,
		[Parameter()]
			[Alias("L", "LO")]
			[switch] $ListOnly = $False
	)
	. "./FileMap.ps1";
	. "./Functions.ps1";
	. "./FileManager.ps1";
	. "./UpdateVersioned.ps1";
	. "./UpdateRemoved.ps1";
	. "./UpdateToVersion.ps1";
	. "./UpdateToRemove.ps1";
	PrintText ("");
	PrintText ("");
	# Lista os arquivos versionados e removidos
	$modifiedFilesMap = (GetModifiedFilesMap $DestPath $Threads);
	# Atualiza os arquivos versionados e removidos em $DestPath
	PrintText ("Etapa 1: Tratar arquivos versionados no destino");
	$modifiedFilesMap = (UpdateVersioned $modifiedFilesMap $VersionLimit $Destructive $ListOnly);
	PrintText ("");
	PrintText ("Etapa 2: Tratar arquivos removidos no destino");
	$modifiedFilesMap = (UpdateRemoved $modifiedFilesMap $RemotionCountdown $Destructive $ListOnly);
	PrintText ("");
	# Lista os arquivos a versionar ou remover
	$toModifyLists = (GetToModifyFilesMap $OrigPath $DestPath $Threads);
	# Atualiza os arquivos a versionar ou remover em $DestPath
	PrintText ("Etapa 3: Criar versões de arquivos modificados na origem");
	$modifiedFilesMap = (UpdateToVersion $modifiedFilesMap $toModifyLists.ToModifyList $VersionLimit $ListOnly);
	PrintText ("");
	PrintText ("Etapa 4: Criar remoções de arquivos deletados na origem");
	$modifiedFilesMap = (UpdateToRemove $modifiedFilesMap $toModifyLists.ToDeleteList $RemotionCountdown $ListOnly);
	PrintText ("");
	PrintText ("Etapa 5: Iniciar Robocopy e realizar espelhamento");
	# Realiza a cópia
	$list = "";
	If($ListOnly) {
		$list = "/L";
	}
	Robocopy $OrigPath $DestPath /MIR /SJ /SL /R:1 /W:0 /MT:$Threads `
		/XF `
			$wildcardOfVersionedFile `
			$wildcardOfRemovedFile `
			$wildcardOfVersionedAndRemovedFile `
		/XD `
			$wildcardOfRemovedFolder `
		$list /NJH /NJS;
	PrintText ("");
}