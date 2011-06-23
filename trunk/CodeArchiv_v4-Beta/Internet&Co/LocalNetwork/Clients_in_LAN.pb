; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=669&highlight=
; Author: Manne
; Date: 19. April 2003
; OS: Windows
; Demo: No

; Beispiel wie man Clients im LAN remote herunterfahren oder neustarten kann. 
; Optional kann auch eine Nachricht gesendet werden. 
; Logischerweise muß der Initiator auf dem Client Adminrechte haben

#ERROR_SUCCESS = 0 
#MAX_PATH = 260 
#CSIDL_NETWORK = $12 
#BIF_BROWSEFORCOMPUTER = $1000 

Structure BROWSEINFOS 
   hwndOwner.l 
   pidlRoot.l 
   pszDisplayName.s 
   lpszTitle.s 
   ulFlags.l 
   lpfn.l 
   lParam.l 
   iImage.l 
EndStructure 

Procedure.l ShutDownComputer(CompName.s, MessageToUser.s, SecondsUntilShutdown.l, ForceAppsClosed.l, RebootAfter.l) 
  ShutDown = InitiateSystemShutdown_(CompName, MessageToUser, SecondsUntilShutdown, ForceAppsClosed, RebootAfter) 
  ProcedureReturn ShutDown 
EndProcedure 

Procedure.l AbortShutdown(CompName.s) 
     AbortShutDown = AbortSystemShutdown_(CompName) 
     ProcedureReturn AbortShutDown 
EndProcedure 


; PureBasic Visual Designer v3.62 


;- Window Constants 
; 
#Window_0 = 0 

;- Gadget Constants 
; 
#Gadget_0 = 0 
#Gadget_1 = 1 
#Gadget_2 = 2 
#Gadget_3 = 3 
#Gadget_4 = 4 
#Gadget_5 = 5 
#Gadget_6 = 6 
#Gadget_7 = 7 
#Gadget_8 = 8 
#Gadget_9 = 9 
#Gadget_10 = 10 
#Gadget_11 = 11 
#Gadget_12 = 12 

Procedure.s GetBrowseNetworkWorkstation() 
    BI.BROWSEINFOS 
    pidl.l 
    sPath.s 
    pos.l 
    hwnd = WindowID(#Window_0) 
    
    If SHGetSpecialFolderLocation_(hwnd, #CSIDL_NETWORK, @pidl) = #ERROR_SUCCESS 
        BI\hwndOwner = hwnd 
        BI\pidlRoot = pidl 
        BI\pszDisplayName = Space(256) 
        BI\lpszTitle = "Select a network computer." 
        BI\ulFlags = #BIF_BROWSEFORCOMPUTER 
        
        If SHBrowseForFolder_(BI) <> 0 
            Name.s = "\\"+ BI\pszDisplayName 
            ProcedureReturn Name 
        EndIf 
        CoTaskMemFree_(@pidl) 
    EndIf 
EndProcedure 


Procedure Open_Window_0() 
  If OpenWindow(#Window_0, 216, 0, 302, 365, "ShutGUI",  #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_TitleBar ) 
    If CreateGadgetList(WindowID(#Window_0)) 
      TextGadget(#Gadget_0, 20, 20, 80, 20, "ComputerName:") 
      StringGadget(#Gadget_1, 110, 20, 120, 20, "") 
      ButtonGadget(#Gadget_2, 250, 20, 30, 20, "...") 
      Frame3DGadget(#Gadget_3, 30, 60, 250, 80, "Optionen") 
      CheckBoxGadget(#Gadget_4, 60, 80, 190, 20, "Anwendungen forciert beenden") 
      CheckBoxGadget(#Gadget_5, 60, 110, 190, 20, "Neustart nach Herunterfahren") 
      TextGadget(#Gadget_6, 30, 160, 220, 20, "zu sendende Nachricht (127 Zeichen max)") 
      StringGadget(#Gadget_7, 30, 190, 250, 80, "", #ES_MULTILINE|#ES_AUTOVSCROLL) 
      TextGadget(#Gadget_8, 60, 280, 80, 20, "Delay (Sek.):") 
      StringGadget(#Gadget_9, 150, 277, 30, 20, "30") 
      ButtonGadget(#Gadget_10, 20, 310, 80, 30, "Herunterfahren") 
      ButtonGadget(#Gadget_11, 120, 310, 80, 30, "Abbrechen") 
      ButtonGadget(#Gadget_12, 210, 310, 80, 30, "Beenden") 
      
    EndIf 
  EndIf 
EndProcedure 


Open_Window_0() 

SetGadgetState(#Gadget_5, 1) 

Repeat 
  Event = WaitWindowEvent() 
  If Event = #PB_Event_CloseWindow 
    quit = 1 
  ElseIf Event = #PB_Event_Gadget 
    Select EventGadget() 
      Case 2 
        SetGadgetText(#Gadget_1, GetBrowseNetworkWorkstation()) 
      Case 10 
        Name.s = GetGadgetText(#Gadget_1) 
        message.s = GetGadgetText(#Gadget_7) 
        pause.s = GetGadgetText(#Gadget_9) 
        chkKillApps.l = GetGadgetState(#Gadget_4) 
        chkReboot.l = GetGadgetState(#Gadget_5) 
        If Name = "" 
          MessageRequester("Client wählen", "Es wurde kein Client ausgewählt.  ", #MB_ICONEXCLAMATION) 
        Else 
          goShutdown = ShutDownComputer(Name, message, Val(pause), chkKillApps, chkReboot) 
        If goShutdown = 1 
          MessageRequester("Kommando erfolgreich", "Herunterfahren erfolgreich eingeleitet für  " + Name + ".  " + Chr(13) + "Der Client wird heruntergefahren in " + pause + " Sekunden.  ", #MB_ICONINFORMATION) 
        ElseIf goShutdown = 0 
            MessageRequester("Fehler", "Herunterfahren nicht möglich für  " + Name + ".  Mögliche Ursachen:  " + Chr(13) + Chr(13) + "1. ClientName falsch geschrieben." + Chr(13) + "2. Der Computer ist kein Window NT-Client." + Chr(13) + "3. Sie haben nicht die erforderlichen Rechte." + Chr(13) + "4. Der Client kann im Netz nicht gefunden werden.", #MB_ICONEXCLAMATION) 
        EndIf 
    EndIf 
      Case 11 
        Name.s = GetGadgetText(#Gadget_1) 
        If Name = "" 
          MessageRequester("Client wählen", "Es wurde kein Client ausgewählt", #MB_ICONSTOP) 
        Else 
          cancelShutdown = AbortShutdown(Name) 
          If cancelShutdown = 1 
            MessageRequester("Abbruch erfolgreich", "Herunterfahren erfolgreich abgebrochen für  " + Name + ".", #MB_ICONINFORMATION) 
          ElseIf cancelShutdown = 0 
            MessageRequester("Abbruch unmöglich", "Abbruch nicht möglich für  " + Name + ".  Mögliche Ursachen:  " + Chr(13) + Chr(13) + "1. ClientName falsch geschrieben." + Chr(13) + "2. Der Computer ist kein Window NT-Client." + Chr(13) + "3. Sie haben nicht die erforderlichen Rechte." + Chr(13) + "4. Der Client kann im Netz nicht gefunden werden." + Chr(13) + "5. Zu spät.", #MB_ICONEXCLAMATION) 
          EndIf 
       EndIf 
      Case 12 
        quit = 1 
    EndSelect 
  EndIf 
Until quit 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
