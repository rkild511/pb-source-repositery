; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; CODE G�N�R� AUTOMATIQUEMENT, NE PAS MODIFIER �
; MOINS D'AVOIR UNE RAISON TR�S TR�S VALABLE !!!
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; Code g�n�r� par : Dev-Type V3.18.3
; Nom du projet : Le nom du projet ici
; Nom du fichier : Nom du fichier
; Version du fichier : 0.0.0
; Programmation : � v�rifier
; Programm� par : Votre Nom Ici
; Alias : Votre Pseudo Ici
; Courriel : adresse@quelquechose.com
; Date : 25-09-2011
; Mise � jour : 25-09-2011
; Cod� pour PureBasic V4.60
; Plateforme : Windows, Linux, MacOS X
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< D�claration de la Structure <<<<<

Structure HttpFile

  Name.s
  Path.s

EndStructure

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Les observateurs <<<<<

Macro GetHttpFileName(HttpFileA)

  HttpFileA\Name

EndMacro

Macro GetHttpFilePath(HttpFileA)

  HttpFileA\Path

EndMacro

; <<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Les mutateurs <<<<<

Macro SetHttpFileName(HttpFileA, P_Name)

  GetHttpFileName(HttpFileA) = P_Name

EndMacro

Macro SetHttpFilePath(HttpFileA, P_Path)

  GetHttpFilePath(HttpFileA) = P_Path

EndMacro

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< L'op�rateur Update <<<<<

Macro UpdateHttpFile(HttpFileA, P_Name, P_Path)

  SetHttpFileName(HttpFileA, P_Name)
  SetHttpFilePath(HttpFileA, P_Path)

EndMacro

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< L'op�rateur Reset <<<<<

Macro ResetHttpFile(HttpFileA)
  
  SetHttpFileName(HttpFileA, "")
  SetHttpFilePath(HttpFileA, "")
  
  ; ClearStructure(HttpFileA, HttpFile)

EndMacro

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Macro de d�boguage <<<<<

Macro DebugHttpFile(HttpFileA)

  Debug "Name : " + GetHttpFileName(HttpFileA)
  Debug "Path : " + GetHttpFilePath(HttpFileA)
  
EndMacro

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Code g�n�r� en : 00.006 secondes (15000.00 lignes/seconde) <<<<<
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; <<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< FIN DU FICHIER <<<<<
; <<<<<<<<<<<<<<<<<<<<<<<<<<
; IDE Options = PureBasic 4.60 RC 1 (Linux - x64)
; CursorPosition = 96
; Folding = --
; EnableXP