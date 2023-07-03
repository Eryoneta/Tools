﻿Function RoboVersion {
	[CmdletBinding()]
	Param(
		[Parameter(Mandatory = $True, Position = 0, ParameterSetName = "ByParams", HelpMessage = "Caminho absoluto dos arquivos a serem versionados")]
			[Alias("OP")]
			[ValidateScript({
				If(-Not (Test-Path -Path $_)) {
					Throw [System.Management.Automation.ItemNotFoundException] "A pasta '${_}' não foi encontrada!"
				} Else {
					$True;
				}
			})]
			[string] $OrigPath,
		[Parameter(Mandatory = $True, Position = 1, ParameterSetName = "ByParams", HelpMessage = "Caminho absoluto da pasta de destino dos arquivos versionados")]
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


	$origPath="D:\ \BKPM\LOC1";
	$destPath="D:\ \BKPM\LOC2";
	$threads=8;
	$maxVersionLimit=3;
	$remotionCountdown=5;
	$destructive=$True;
	$listOnly=$True;
	. "./FileMap.ps1";
	. "./Functions.ps1";
	. "./FileManager.ps1";
	. "./UpdateVersioned.ps1";
	. "./UpdateRemoved.ps1";
	. "./UpdateToVersion.ps1";
	. "./UpdateToRemove.ps1";
	. "./DevTools.ps1";

	# PrintText $OrigPath;
	# PrintText $DestPath;
	# PrintText $Threads;
	# PrintText $VersionLimit;
	# PrintText $RemotionCountdown;
	# PrintText $Destructive;
	# PrintText $ListOnly;
	# Return;
	
	# Lista os arquivos versionados e removidos
	$modifiedFilesMap = (GetModifiedFilesMap $DestPath $Threads);
	
	PrintText "============ ARQUIVOS MODIFICADOS: ";
	EchoFileMap $modifiedFilesMap;
	PrintText "============";
	
	# Atualiza os arquivos versionados e removidos em $DestPath
	$modifiedFilesMap = (UpdateVersioned $modifiedFilesMap $VersionLimit $Destructive $ListOnly);
	$modifiedFilesMap = (UpdateRemoved $modifiedFilesMap $RemotionCountdown $Destructive $ListOnly);
	PrintText "============ ARQUIVOS MODIFICADOS APÓS UPDATE: ";
	EchoFileMap $modifiedFilesMap;
	PrintText "============";
	
	# Lista os arquivos a versionar ou remover
	$toModifyLists = (GetToModifyFilesMap $OrigPath $DestPath $Threads);
	PrintText "============ ARQUIVOS A MODIFICAR: ";
	ForEach($item In $toModifyLists.ToModifyList) {
		PrintText $item;
	}
	PrintText "============ ARQUIVOS A DELETAR: ";
	ForEach($item In $toModifyLists.ToDeleteList) {
		PrintText $item;
	}
	PrintText "============";
	
	# Atualiza os arquivos a versionar ou remover em $DestPath
	$modifiedFilesMap = (UpdateToVersion $modifiedFilesMap $toModifyLists.ToModifyList $VersionLimit $Destructive $ListOnly);
	$modifiedFilesMap = (UpdateToRemove $modifiedFilesMap $toModifyLists.ToDeleteList $RemotionCountdown $Destructive $ListOnly);
	PrintText "============ ARQUIVOS A MODIFICADOS APÓS 2º UPDATE: ";
	EchoFileMap $modifiedFilesMap;
	PrintText "============";

	# Realiza a cópia
	# Robocopy $OrigPath $DestPath /MIR /SJ /SL /R:1 /W:0 /MT:$Threads `
	# 	/XF `
	# 		$wildcardOfVersionedFile `
	# 		$wildcardOfRemovedFile `
	# 		$wildcardOfVersionedAndRemovedFile `
	# 	/XD `
	# 		$wildcardOfRemovedFolder `
	# 	/NJH /NJS;
}