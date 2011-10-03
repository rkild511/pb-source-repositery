; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; CODE GÉNÉRÉ AUTOMATIQUEMENT, NE PAS MODIFIER À
; MOINS D'AVOIR UNE RAISON TRÈS TRÈS VALABLE !!!
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; Code généré par : Dev-Type V1.4.1
; Nom du projet : Thothbox
; Nom du fichier : Thothbox - TwinState.pb
; Version du fichier : 1.4.0
; Programmation : OK
; Programmé par : Guillaume
; Alias : Guimauve
; Courriel : gsaumure79@videotron.ca
; Date : 28-04-2008
; Mise à jour : 30-01-2009
; Codé pour PureBasic V4.30
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Déclaration de la Structure <<<<<

Structure TwinState
  
  Status.l
  ButtonID.l
  ImageID.l[2]
  
EndStructure

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Les observateurs <<<<<

Macro GetTwinStateStatus(TwinStateA)
  
  TwinStateA\Status
  
EndMacro

Macro GetTwinStateButtonID(TwinStateA)
  
  TwinStateA\ButtonID
  
EndMacro

Macro GetTwinStateImageID(TwinStateA, Index)
  
  TwinStateA\ImageID[Index]
  
EndMacro

; <<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Les mutateurs <<<<<

Macro SetTwinStateStatus(TwinStateA, P_Status)
  
  GetTwinStateStatus(TwinStateA) = P_Status
  
EndMacro

Macro SetTwinStateButtonID(TwinStateA, P_ButtonID)
  
  GetTwinStateButtonID(TwinStateA) = P_ButtonID
  
EndMacro

Macro SetTwinStateImageID(TwinStateA, Index, P_ImageID)
  
  GetTwinStateImageID(TwinStateA, Index) = P_ImageID
  
EndMacro


; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< L'opérateur Reset <<<<<

Macro ResetTwinState(TwinStateA)
  
  SetTwinStateStatus(TwinStateA, 0)
  SetTwinStateButtonID(TwinStateA, 0)
  
  For Index = 0 To 1
    SetTwinStateImageID(TwinStateA, Index, 0)
  Next
  
EndMacro

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Lecture d'un groupe Préférences <<<<<

Procedure ReadPreferenceTwinState(GroupName.s, *TwinStateA.TwinState)
  
  PreferenceGroup(GroupName)
  
  SetTwinStateStatus(*TwinStateA, ReadPreferenceLong("Status", GetTwinStateStatus(*TwinStateA)))
  
EndProcedure

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Écriture d'un groupe de Préférences <<<<<

Procedure WritePreferenceTwinState(GroupName.s, *TwinStateA.TwinState)
  
  PreferenceGroup(GroupName)
  
  WritePreferenceLong("Status", GetTwinStateStatus(*TwinStateA))
  
EndProcedure

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Macro de déboguage <<<<<

Macro DebugTwinState(TwinStateA)
  
  Debug GetTwinStateStatus(TwinStateA)
  Debug GetTwinStateButtonID(TwinStateA)
  
  For Index = 0 To 1
    Debug GetTwinStateImageID(TwinStateA, Index)
  Next
  
EndMacro

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Code généré en : 00.016 secondes <<<<<
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Initialisation des valeurs par défaut <<<<<

Procedure InitializeTwinState(*TwinStateA.TwinState, P_ButtonID.l, P_ImageID_0.s, P_ImageID_1.s, P_Status.l = 0)
  
  SetTwinStateStatus(*TwinStateA, P_Status)
  SetTwinStateButtonID(*TwinStateA, P_ButtonID)
  SetTwinStateImageID(*TwinStateA, 0, LoadImage(#PB_Any, P_ImageID_0))
  SetTwinStateImageID(*TwinStateA, 1, LoadImage(#PB_Any, P_ImageID_1))
  
EndProcedure

Procedure InitializeTwinStateEx(*TwinStateA.TwinState, P_ButtonID.l, P_ImageLabel_0.i, P_ImageLabel_1.i, P_Status.l = 0)
  
  SetTwinStateStatus(*TwinStateA, P_Status)
  SetTwinStateButtonID(*TwinStateA, P_ButtonID)
  SetTwinStateImageID(*TwinStateA, 0, CatchImage(#PB_Any, P_ImageLabel_0))
  SetTwinStateImageID(*TwinStateA, 1, CatchImage(#PB_Any, P_ImageLabel_1))
  
EndProcedure

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Bascule entre le Status 0 ou 1 <<<<<

Procedure.b TwinStateToggleStatus(*TwinStateA.TwinState, OneShot = #False)
  
  If OneShot = #False
    
    If GetTwinStateStatus(*TwinStateA) = 0
      SetTwinStateStatus(*TwinStateA, 1)
    ElseIf GetTwinStateStatus(*TwinStateA) = 1
      SetTwinStateStatus(*TwinStateA, 0)
    EndIf
    
  EndIf
  
  SetGadgetAttribute(GetTwinStateButtonID(*TwinStateA), #PB_Button_Image, ImageID(GetTwinStateImageID(*TwinStateA, GetTwinStateStatus(*TwinStateA))))
  
  ProcedureReturn GetTwinStateStatus(*TwinStateA)
EndProcedure

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Forcer le Status à 0 ou à 1 <<<<<

Procedure TwinStateForceStatus(*TwinStateA.TwinState, P_Status.b)
  
  SetTwinStateStatus(*TwinStateA, P_Status)
  SetGadgetAttribute(GetTwinStateButtonID(*TwinStateA), #PB_Button_Image, ImageID(GetTwinStateImageID(*TwinStateA, GetTwinStateStatus(*TwinStateA))))

EndProcedure

; <<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< FIN DU FICHIER <<<<<
; <<<<<<<<<<<<<<<<<<<<<<<<<< 
; IDE Options = PureBasic 4.60 RC 1 (Linux - x64)
; CursorPosition = 169
; FirstLine = 131
; Folding = ---
; EnableXP