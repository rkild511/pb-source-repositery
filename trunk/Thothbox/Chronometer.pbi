; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; CODE GÉNÉRÉ AUTOMATIQUEMENT, NE PAS MODIFIER À
; MOINS D'AVOIR UNE RAISON TRÈS TRÈS VALABLE !!!
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; Code généré par : Dev-Type V2.0.0
; Nom du projet : Chronometer
; Nom du fichier : Chronometer.pbi
; Version du fichier : 2.0.0
; Programmation : OK
; Programmé par : Guillaume Saumure
; Alias : Guimauve
; Courriel : gsaumure79@videotron.ca
; Date : 21-03-2010
; Mise à jour : 21-03-2010
; Codé pour PureBasic V4.41
; Plateforme : Windows, Linux, MacOS X
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Déclaration de la Structure <<<<<

Structure Chronometer
  
  StartTime.l
  TotalTime.l
  Running.b
  
EndStructure

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Les observateurs <<<<<

Macro GetChronometerStartTime(ChronometerA)
  
  ChronometerA\StartTime
  
EndMacro

Macro GetChronometerTotalTime(ChronometerA)
  
  ChronometerA\TotalTime
  
EndMacro

Macro GetChronometerRunning(ChronometerA)
  
  ChronometerA\Running
  
EndMacro

; <<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Les mutateurs <<<<<

Macro SetChronometerStartTime(ChronometerA, P_StartTime)
  
  GetChronometerStartTime(ChronometerA) = P_StartTime
  
EndMacro

Macro SetChronometerTotalTime(ChronometerA, P_TotalTime)
  
  GetChronometerTotalTime(ChronometerA) = P_TotalTime
  
EndMacro

Macro SetChronometerRunning(ChronometerA, P_Running)
  
  GetChronometerRunning(ChronometerA) = P_Running
  
EndMacro

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< L'opérateur Reset <<<<<

Macro ResetChronometer(ChronometerA)
  
  ClearStructure(ChronometerA, Chronometer)
  
EndMacro

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< L'opérateur Copy : A = Source : B = Destination <<<<<

Macro CopyChronometer(ChronometerA, ChronometerB)
  
  CopyMemory(ChronometerA, ChronometerB, SizeOf(Chronometer))
  
EndMacro

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< L'opérateur Compare <<<<<

Macro CompareChronometer(ChronometerA, ChronometerB)
  
  CompareMemory(ChronometerA, ChronometerB, SizeOf(Chronometer))
  
EndMacro

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< L'opérateur Swap <<<<<

Macro SwapChronometer(ChronometerA, ChronometerB)
  
  Swap GetChronometerStartTime(ChronometerA), GetChronometerStartTime(ChronometerB)
  Swap GetChronometerTotalTime(ChronometerA), GetChronometerTotalTime(ChronometerB)
  Swap GetChronometerRunning(ChronometerA), GetChronometerRunning(ChronometerB)
  
EndMacro

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Lecture sur fichier Binaire <<<<<

Macro ReadChronometer(FileID, ChronometerA)
  
  ReadData(FileID, ChronometerA, SizeOf(Chronometer))
  
EndMacro

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Écriture sur fichier Binaire <<<<<

Macro WriteChronometer(FileID, ChronometerA)
  
  WriteData(FileID, ChronometerA, SizeOf(Chronometer))
  
EndMacro

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Code généré en : 00.012 secondes (13666.67 lignes/seconde) <<<<<
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Convertir des secondes en MS <<<<<

Macro SecondsToMilliseconds(Seconds)
  
  (Seconds * 1000)
  
EndMacro 

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Convertir des minutes en MS <<<<<

Macro MinutesToMilliseconds(Minutes)
  
  (Minutes * 60000)
  
EndMacro 

Macro MillisecondsToMinutes(Milliseconds)
  
  (Milliseconds / 60000)
  
EndMacro 

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Convertir des heures en MS <<<<<

Macro HoursToMilliseconds(Hours)
  
  (Hours * 3600000)
  
EndMacro 

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Convertir des Jours en MS <<<<<

Macro DaysToMilliseconds(Days)
  
  (Days * 86400000)
  
EndMacro 

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Trouver le nombre de Millisecondes <<<<<

Macro CalculateMilliseconds(MilliSeconds, Seconds = 0, Minutes = 0, Hours = 0, Days = 0)
  
  (MilliSeconds + SecondsToMilliseconds(Seconds) + MinutesToMilliseconds(Minutes) + HoursToMilliseconds(Hours) + DaysToMilliseconds(Days))
  
EndMacro 

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Démmarer Chronometer <<<<<

Procedure StartChronometer(*ChronoA.Chronometer)
  
  If GetChronometerRunning(*ChronoA) = #False
    
    SetChronometerStartTime(*ChronoA, ElapsedMilliseconds())
    SetChronometerRunning(*ChronoA, #True)
    
  EndIf
  
EndProcedure 

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Arrèter Chronometer <<<<<

Procedure StopChronometer(*ChronoA.Chronometer)
  
  If GetChronometerRunning(*ChronoA) = #True
    
    SetChronometerTotalTime(*ChronoA, GetChronometerTotalTime(*ChronoA) + ElapsedMilliseconds() - GetChronometerStartTime(*ChronoA))
    SetChronometerRunning(*ChronoA, #False)
    
  EndIf 
  
EndProcedure 

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Consulter Chronometer <<<<<

Procedure.l ConsultChronometer(*ChronoA.Chronometer)
  
  If GetChronometerRunning(*ChronoA) = #True
    
    TotalTime.l = GetChronometerTotalTime(*ChronoA) + ElapsedMilliseconds() - GetChronometerStartTime(*ChronoA)
    
  Else
    
    TotalTime = GetChronometerTotalTime(*ChronoA)
    
  EndIf 
  
  ProcedureReturn TotalTime
EndProcedure 

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Ajuster le temps du Temporizer <<<<<

Procedure SetTemporizerTotalTime(*ChronoA.Chronometer, MilliSeconds.l, Seconds.l, Minutes.l, Hours.l, Days.l)
  
  SetChronometerTotalTime(*ChronoA, MilliSeconds + SecondsToMilliseconds(Seconds) + MinutesToMilliseconds(Minutes) + HoursToMilliseconds(Hours) + DaysToMilliseconds(Days))
  
EndProcedure 

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Démmarer Temporisateur <<<<<

Procedure StartTemporizer(*ChronoA.Chronometer)
  
  If GetChronometerRunning(*ChronoA) = #False
    
    SetChronometerStartTime(*ChronoA, ElapsedMilliseconds())
    SetChronometerRunning(*ChronoA, #True)
    
  EndIf
  
EndProcedure 

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Arrèter le Temporisateur <<<<<

Procedure StopTemporizer(*ChronoA.Chronometer)
  
  If GetChronometerRunning(*ChronoA) = #True
    
    SetChronometerTotalTime(*ChronoA, GetChronometerTotalTime(*ChronoA) - ElapsedMilliseconds() + GetChronometerStartTime(*ChronoA))
    SetChronometerRunning(*ChronoA, #False)
    
  EndIf 
  
EndProcedure 

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Consulter le Temporisateur <<<<<

Procedure.l ConsultTemporizer(*ChronoA.Chronometer)
  
  If GetChronometerRunning(*ChronoA) = #True
    
    TotalTime.l = GetChronometerTotalTime(*ChronoA) - ElapsedMilliseconds() + GetChronometerStartTime(*ChronoA)
    
  Else
    
    TotalTime = GetChronometerTotalTime(*ChronoA)
    
  EndIf 
  
  ProcedureReturn TotalTime
EndProcedure 

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Reset du temporisateur >>>>>

Procedure ResetTemporizer(*ChronoA.Chronometer, TotalTime.l)
  
  SetChronometerStartTime(*ChronoA, 0)
  SetChronometerTotalTime(*ChronoA, TotalTime)
  SetChronometerRunning(*ChronoA, #False)
  
EndProcedure

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Conversion de milliseconde vers en j : H : M : S : Ms <<<<<

Procedure.s FormatMilliseconds(Mask.s, MilliSeconds.l)
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< On fait l'extraction des jours, Heures, minutes, secondes et des MS <<<<<
  
  If MilliSeconds < 0 
    MilliSeconds = MilliSeconds * -1
  EndIf 
  
  Days = MilliSeconds / 86400000 
  MilliSeconds % 86400000
  
  Hours = MilliSeconds / 3600000
  MilliSeconds % 3600000
  
  Minutes = MilliSeconds / 60000
  MilliSeconds % 60000
  
  Seconds = MilliSeconds / 1000
  MilliSeconds % 1000
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< On s'occupe du filtre de sortie <<<<<
  
  If FindString(Mask, "%dd", 1)
    
    Mask = ReplaceString(Mask,"%dd", RSet(Str(Days), 2, "0"))
    
  EndIf 
  
  If FindString(Mask, "%hh", 1)
    
    Mask = ReplaceString(Mask,"%hh", RSet(Str(Hours), 2, "0"))
    
  EndIf 
  
  If FindString(Mask, "%mm", 1)
    
    Mask = ReplaceString(Mask,"%mm", RSet(Str(Minutes), 2, "0"))
    
  EndIf 
  
  If FindString(Mask, "%ss", 1)
    
    Mask = ReplaceString(Mask,"%ss", RSet(Str(Seconds), 2, "0"))
    
  EndIf 
  
  If FindString(Mask, "%mss", 1)
    
    Mask = ReplaceString(Mask,"%mss", RSet(Str(MilliSeconds), 3, "0"))
    
  EndIf
  
  If FindString(Mask, "%ms", 1)
    
    Mask = ReplaceString(Mask,"%ms", RSet(Str(MilliSeconds), 2, "0"))
    
  EndIf 
  
  ProcedureReturn Mask
EndProcedure

; <<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< FIN DU FICHIER <<<<<
; <<<<<<<<<<<<<<<<<<<<<<<<<<
; IDE Options = PureBasic 4.60 RC 1 (Linux - x64)
; CursorPosition = 143
; FirstLine = 135
; Folding = -----
; EnableXP