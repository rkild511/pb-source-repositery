; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; Nom du projet : Thothbox
; Nom du fichier : Thothbox - Main.pb
; Version du fichier : 0.1.1
; Programmation : En cours
; Programmé par : Guillaume Saumure
; Alias : Guimauve
; Courriel : gsaumure79@videotron.ca
; Date : 23-09-2011
; Mise à jour : 02-10-2011
; Code PureBasic : 4.60
; Plateforme : Windows, Linux, MacOS X
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

IncludeFile "Gadget Helpers Macros.pbi"
IncludeFile "Desktop Configuration File.pbi"
IncludeFile "Levenshtein Distance.pbi"
IncludeFile "Chronometer.pbi"
IncludeFile "GoScintilla.pbi"

IncludeFile "Thothbox - Constants.pb"

IncludeFile "Thothbox - Support Function.pb"

IncludeFile "Thothbox - Language.pb"
IncludeFile "Thothbox - Window.pb"
IncludeFile "Thothbox - TwinState.pb"
IncludeFile "Thothbox - Credit.pb"

; IncludeFile ""
; IncludeFile ""
; IncludeFile ""
; IncludeFile ""
; IncludeFile ""
; IncludeFile ""
; IncludeFile ""

IncludeFile "Thothbox - Proxy.pb"
IncludeFile "Thothbox - Connection.pb"

IncludeFile "Thothbox - HttpFile.pb"
IncludeFile "Thothbox - Query.pb"

IncludeFile "Thothbox - Thothbox.pb"

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Routine d'initialisation du programme <<<<<

InitializeThothbox(Thothbox.Thothbox)

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Ouverture de la fenètre principale <<<<<

OpenThothboxWindow(Thothbox)

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Gestion des évènements <<<<<

ThothboxEventManager(Thothbox)

; <<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< FIN DU FICHIER <<<<<
; <<<<<<<<<<<<<<<<<<<<<<<<<<
; IDE Options = PureBasic 4.60 RC 2 (Linux - x64)
; CursorPosition = 3
; FirstLine = 20
; EnableUnicode
; EnableXP
; DisableDebugger
; CompileSourceDirectory
; EnableBuildCount = 0