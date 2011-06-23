; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3038&highlight=
; Author: AndyMars  (some slightly modifications by Andre for the CodeArchiv, updated for PB3.93 by ts-soft, updated for PB 4.00 by Andre)
; Date: 06. December 2003
; OS: Windows
; Demo: No


; Part 2/2 of the ReadmePacker - includes the packed readme file,
; formerly created with the ReadmePacker_CreatePak source


;Andy Marschner - Switzerland 
;RPacks entpacken 
;erstellt mit/für PureBasic 3.8 

#Window_FormInfo=1 
#Gadget_FormInfo_ButtonOK=1 
#Gadget_FormInfo_EditorInfo=2 
  
Procedure.l Window_FormInfo() 
  If OpenWindow(#Window_FormInfo,100,100,367,218,"Info",#PB_Window_ScreenCentered) 
    If CreateGadgetList(WindowID(#Window_FormInfo)) 
      ButtonGadget(#Gadget_FormInfo_ButtonOK,145,195,60,20,"OK") 
      EditorGadget(#Gadget_FormInfo_EditorInfo,0,0,365,190) 
      HideWindow(#Window_FormInfo,0) 
      ProcedureReturn WindowID(#Window_FormInfo) 
    EndIf 
  EndIf 
EndProcedure 

;-ASM Prozeduren ---------------------------------------------------------------------------- 
Procedure _M(Text.s) 
  MessageRequester(" Meldung", Text, #PB_MessageRequester_Ok);$ 
EndProcedure 

Procedure _Info() 
  If Window_FormInfo() 
    laenge = ?ReadMePakEnd - ?ReadMePak 
    MHndl1 = AllocateMemory(laenge*3) 
    If MHndl1 
      UnPackErg = UnpackMemory(?ReadMePak, MHndl1) ;gibt die Länge zurück 
      If UnPackErg 
        SendMessage_(GadgetID(#Gadget_FormInfo_EditorInfo),#EM_SETREADONLY , 1, 0) 
        SendMessage_(GadgetID(#Gadget_FormInfo_EditorInfo),#EM_SETTARGETDEVICE, #Null, 0);Wordwrap 
        SendMessage_(GadgetID(#Gadget_FormInfo_EditorInfo), #EM_LIMITTEXT, -1, 0) 
        SetGadgetText(#Gadget_FormInfo_EditorInfo,PeekS(MHndl1,UnPackErg)) 
      Else 
        _M("Fehler in _Info() beim Entpacken der Infodaten!") 
      EndIf 
      FreeMemory(MHndl1) 
    Else 
      _M("Fehler in _Info(): Konnte Speicher nicht anfordern!") 
    EndIf 
    While InfoEnde=0 
      EventID = WaitWindowEvent() 
      If EventWindow()=#Window_FormInfo 
        If EventID = #PB_Event_CloseWindow 
          InfoEnde=1 
        ElseIf EventID = #PB_Event_Gadget 
          Gadget = EventGadget() 
          If Gadget = #Gadget_FormInfo_ButtonOK 
            InfoEnde=1 
          EndIf 
        EndIf 
      Else 
        SetForegroundWindow_(WindowID(#Window_FormInfo)) 
      EndIf 
    Wend 
    CloseWindow(#Window_FormInfo) 
  Else 
    _M("Fehler in _Info(): Konnte Fenster Window_FormInfo() nicht öffnen!") 
  EndIf 
EndProcedure 

;-MAIN -------------------------------------------------------------------------------------- 
_Info() 

End 

ReadMePak: 
IncludeBinary "ReadmePacker_Liesmich.pak" 
ReadMePakEnd:

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
; Executable = C:\Programming\Examples.exe
