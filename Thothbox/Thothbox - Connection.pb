; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; CODE GÉNÉRÉ AUTOMATIQUEMENT, NE PAS MODIFIER À
; MOINS D'AVOIR UNE RAISON TRÈS TRÈS VALABLE !!!
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; Code généré par : Dev-Type V3.18.3
; Nom du projet : Le nom du projet ici
; Nom du fichier : Nom du fichier
; Version du fichier : 0.0.0
; Programmation : À vérifier
; Programmé par : Votre Nom Ici
; Alias : Votre Pseudo Ici
; Courriel : adresse@quelquechose.com
; Date : 23-09-2011
; Mise à jour : 26-09-2011
; Codé pour PureBasic V4.60
; Plateforme : Windows, Linux, MacOS X
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; CODE GÉNÉRÉ AUTOMATIQUEMENT, NE PAS MODIFIER À
; MOINS D'AVOIR UNE RAISON TRÈS TRÈS VALABLE !!!
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; Code généré par : Dev-Type V3.18.3
; Nom du projet : Le nom du projet ici
; Nom du fichier : Nom du fichier
; Version du fichier : 0.0.0
; Programmation : À vérifier
; Programmé par : Votre Nom Ici
; Alias : Votre Pseudo Ici
; Courriel : adresse@quelquechose.com
; Date : 26-09-2011
; Mise à jour : 26-09-2011
; Codé pour PureBasic V4.60
; Plateforme : Windows, Linux, MacOS X
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Déclaration de la Structure <<<<<

Structure Connection

  Address.s
  Port.l
  ID.l
  UseAutoLogout.b
  AutoLogoutTime.l
  Proxy.Proxy
  Chronometer.Chronometer

EndStructure

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Les observateurs <<<<<

Macro GetConnectionAddress(ConnectionA)

  ConnectionA\Address

EndMacro

Macro GetConnectionPort(ConnectionA)

  ConnectionA\Port

EndMacro

Macro GetConnectionID(ConnectionA)

  ConnectionA\ID

EndMacro

Macro GetConnectionUseAutoLogout(ConnectionA)

  ConnectionA\UseAutoLogout

EndMacro

Macro GetConnectionAutoLogoutTime(ConnectionA)

  ConnectionA\AutoLogoutTime

EndMacro

Macro GetConnectionProxy(ConnectionA)

  ConnectionA\Proxy

EndMacro

Macro GetConnectionChronometer(ConnectionA)

  ConnectionA\Chronometer

EndMacro

; <<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Les mutateurs <<<<<

Macro SetConnectionAddress(ConnectionA, P_Address)

  GetConnectionAddress(ConnectionA) = P_Address

EndMacro

Macro SetConnectionPort(ConnectionA, P_Port)

  GetConnectionPort(ConnectionA) = P_Port

EndMacro

Macro SetConnectionID(ConnectionA, P_ID)

  GetConnectionID(ConnectionA) = P_ID

EndMacro

Macro SetConnectionUseAutoLogout(ConnectionA, P_UseAutoLogout)

  GetConnectionUseAutoLogout(ConnectionA) = P_UseAutoLogout

EndMacro

Macro SetConnectionAutoLogoutTime(ConnectionA, P_AutoLogoutTime)

  GetConnectionAutoLogoutTime(ConnectionA) = P_AutoLogoutTime

EndMacro

Macro SetConnectionProxy(ConnectionA, P_Proxy)

  GetConnectionProxy(ConnectionA) = P_Proxy

EndMacro

Macro SetConnectionChronometer(ConnectionA, P_Chronometer)

  GetConnectionChronometer(ConnectionA) = P_Chronometer

EndMacro

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< L'opérateur Reset <<<<<

Macro ResetConnection(ConnectionA)
  
  SetConnectionAddress(ConnectionA, "")
  SetConnectionPort(ConnectionA, 0)
  SetConnectionID(ConnectionA, 0)
  SetConnectionUseAutoLogout(ConnectionA, 0)
  SetConnectionAutoLogoutTime(ConnectionA, 0)
  ResetProxy(GetConnectionProxy(ConnectionA))
  ResetChronometer(GetConnectionChronometer(ConnectionA))

EndMacro

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Code généré en : 00.011 secondes (12727.27 lignes/seconde) <<<<<
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Lecture d'un groupe Préférences <<<<<

Procedure ReadPreferenceConnection(GroupName.s, *ConnectionA.Connection)

  PreferenceGroup(GroupName)
  
  SetConnectionAddress(*ConnectionA, ReadPreferenceString("Address", GetConnectionAddress(*ConnectionA)))
  SetConnectionUseAutoLogout(*ConnectionA, ReadPreferenceLong("UseAutoLogout", GetConnectionUseAutoLogout(*ConnectionA)))
  SetConnectionAutoLogoutTime(*ConnectionA, ReadPreferenceLong("AutoLogoutTime", GetConnectionAutoLogoutTime(*ConnectionA)))
  ReadPreferenceProxy("Proxy", GetConnectionProxy(*ConnectionA))

EndProcedure

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Écriture d'un groupe de Préférences <<<<<

Procedure WritePreferenceConnection(GroupName.s, *ConnectionA.Connection)

  PreferenceGroup(GroupName)
  
  WritePreferenceString("Address", GetConnectionAddress(*ConnectionA))
  WritePreferenceLong("UseAutoLogout", GetConnectionUseAutoLogout(*ConnectionA))
  WritePreferenceLong("AutoLogoutTime", GetConnectionAutoLogoutTime(*ConnectionA))
  WritePreferenceProxy("Proxy", GetConnectionProxy(*ConnectionA))

EndProcedure

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< L'opérateur Initialize <<<<<

Procedure InitializeConnection(*ConnectionA.Connection)

  InitializeProxy(GetConnectionProxy(*ConnectionA))
  SetConnectionAddress(*ConnectionA, "www.koakdesign.info")
  SetConnectionID(*ConnectionA, 0)
  SetConnectionPort(*ConnectionA, 80)
  SetConnectionUseAutoLogout(*ConnectionA, #False)
  SetConnectionAutoLogoutTime(*ConnectionA, CalculateMilliseconds(0, 0, 15))
  
EndProcedure

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< L'opérateur ToggleServerConnection <<<<<

Procedure.b ToggleServerConnection(*ConnectionA.Connection)
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; ATTENTION : 
  ;
  ; Le cas de connexion par l'intermédiaire n'est pas pris 
  ; en compte pour le moment. 
  ;
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
 
  If GetConnectionID(*ConnectionA) = 0
    
    SetConnectionID(*ConnectionA, OpenNetworkConnection(GetConnectionAddress(*ConnectionA), GetConnectionPort(*ConnectionA)))
    
    If GetConnectionID(*ConnectionA) = 0
      Success.b = #False
    Else
      
      Success = #True
      
      If GetConnectionUseAutoLogout(*ConnectionA) = #True
        StartChronometer(GetConnectionChronometer(*ConnectionA))
      EndIf
      
    EndIf
    
  Else
    
    ResetChronometer(GetConnectionChronometer(*ConnectionA))
    CloseNetworkConnection(GetConnectionID(*ConnectionA))
    SetConnectionID(*ConnectionA, 0)
    
    Success = #True
    
  EndIf
  
  ProcedureReturn Success
EndProcedure

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< L'opérateur GUI_To_Connection <<<<<

Procedure GUI_To_Connection(*ConnectionA.Connection)
  
  GUI_To_Proxy(GetConnectionProxy(*ConnectionA))
  SetConnectionAddress(*ConnectionA, GetGadgetText(#String_Prefs_Connection))
  
  If GetGadgetState(#CheckBox_UseAutoLogout) = #True
    SetConnectionUseAutoLogout(*ConnectionA, #True)
  Else
    SetConnectionUseAutoLogout(*ConnectionA, #False)
  EndIf
  
  SetConnectionAutoLogoutTime(*ConnectionA, MinutesToMilliseconds(GetGadgetState(#TrackBar_AutoLogout_Time)))
  
  DisableDependentGadget(#CheckBox_UseAutoLogout, #TrackBar_AutoLogout_Time)

EndProcedure

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< L'opérateur Connection_To_GUI <<<<<

Procedure Connection_To_GUI(*ConnectionA.Connection)
  
  Proxy_To_GUI(GetConnectionProxy(*ConnectionA))
  SetGadgetText(#String_Prefs_Connection, GetConnectionAddress(*ConnectionA))
  
  If GetConnectionUseAutoLogout(*ConnectionA) = #True
    SetGadgetState(#CheckBox_UseAutoLogout, #True)
  EndIf
  
  SetGadgetState(#TrackBar_AutoLogout_Time, MillisecondsToMinutes(GetConnectionAutoLogoutTime(*ConnectionA)))
  SetGadgetText(#Text_AutoLogout_Time_State, Str(GetGadgetState(#TrackBar_AutoLogout_Time)))
  DisableDependentGadget(#CheckBox_UseAutoLogout, #TrackBar_AutoLogout_Time)

EndProcedure

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< L'opérateur ConnectionAutoLogoutControl <<<<<

Procedure.b ConnectionAutoLogoutControl(*ConnectionA.Connection)
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; Pour couper la connexion après un certain nombre de minutes nous ne somme
  ; pas la seconde et encore moins à la millisecondes près. Même si la connexion
  ; reste ouverte 15 minutes et 6 secondes au lieu de 15 minutes pile ça change 
  ; rien. 
  
  If GetConnectionUseAutoLogout(*ConnectionA) = #True

    If ConsultChronometer(GetConnectionChronometer(*ConnectionA)) >= GetConnectionAutoLogoutTime(*ConnectionA)
      
      If GetConnectionID(*ConnectionA) <> 0
        
        ResetChronometer(GetConnectionChronometer(*ConnectionA))
        CloseNetworkConnection(GetConnectionID(*ConnectionA))
        SetConnectionID(*ConnectionA, 0)
        Automatic_Logout_Time_Reached.b = #True
        
      EndIf
      
    EndIf   
    
  EndIf
  
  ProcedureReturn Automatic_Logout_Time_Reached
EndProcedure 

; <<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< FIN DU FICHIER <<<<<
; <<<<<<<<<<<<<<<<<<<<<<<<<<
; IDE Options = PureBasic 4.60 RC 1 (Linux - x64)
; CursorPosition = 211
; FirstLine = 174
; Folding = --fu
; EnableXP