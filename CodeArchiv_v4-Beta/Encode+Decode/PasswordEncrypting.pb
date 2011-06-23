; German forum: http://www.purebasic.fr/german/viewtopic.php?t=2068&highlight=
; Author: Bamsagla (updated for PB 4.00 by Andre)
; Date: 16. February 2005
; OS: Windows
; Demo: Yes


; Password encrypting - on the fly...
; Passwortverschlüsselung - in Echtzeit...

Passwort$="" 
Saltsalt$="HW" 
If OpenWindow(100,0,0,400,220,"Passwortverschlüsselung - Harry Wessner - 2005",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) 
  If CreateGadgetList(WindowID(100)) 
    Frame3DGadget(100,10,10,380,50,"Bitte geben Sie Ihr Passwort ein") 
    StringGadget(110,20,30,270,20,Passwort$) 
    ButtonGadget(115,300,30,80,20,"Klartext") 
    Frame3DGadget(120,10,70,380,50,"MD5-Fingerabdruck") 
    StringGadget(130,20,90,270,20,MD5Fingerprint(@Passwort$,Len(Passwort$)),#PB_String_ReadOnly) 
    ButtonGadget(135,300,90,80,20,"Kopieren") 
    Frame3DGadget(140,10,130,380,80,"DES-Fingerabdruck") 
    TextGadget(150,20,150,250,20,"Verwendeter Schlüssel:",512) 
    StringGadget(160,300,150,80,20,Saltsalt$) 
    StringGadget(170,20,180,270,20,DESFingerprint(Passwort$,Saltsalt$),#PB_String_ReadOnly) 
    ButtonGadget(175,300,180,80,20,"Kopieren") 
    SendMessage_(GadgetID(160),#EM_LIMITTEXT,2,0) 
    SendMessage_(GadgetID(110),#EM_SETPASSWORDCHAR,43,0) 
  EndIf 
  Repeat 
    ; Wenn sich an den Eingabefeldern was tut, hier Aktualisieren 
    Neuerpass$=GetGadgetText(110) 
    Neuersalt$=GetGadgetText(160) 
    If Neuersalt$<>Saltsalt$ Or Neuerpass$<>Passwort$ 
      Saltsalt$=Neuersalt$ 
      SetGadgetText(170,DESFingerprint(Neuerpass$,Neuersalt$)) 
    EndIf 
    If Neuerpass$<>Passwort$ 
      Passwort$=Neuerpass$ 
      SetGadgetText(130,MD5Fingerprint(@Passwort$,Len(Passwort$))) 
    EndIf 
    ; Ereignisverfolgung 
    Select WindowEvent() 
      Case #PB_Event_Gadget 
        Select EventGadget() 
          Case 115 
            If GetGadgetText(115)="Klartext" 
              SetGadgetText(115,"Verbergen") 
              SendMessage_(GadgetID(110),#EM_SETPASSWORDCHAR,0,0) 
              SetFocus_(GadgetID(110)) 
            ElseIf GetGadgetText(115)="Verbergen" 
              SetGadgetText(115,"Klartext") 
              SendMessage_(GadgetID(110),#EM_SETPASSWORDCHAR,43,0) 
              SetFocus_(GadgetID(110)) 
            EndIf 
          Case 135 
            SetClipboardText(GetGadgetText(130)) 
          Case 175 
            SetClipboardText(GetGadgetText(170)) 
        EndSelect 
      Case #PB_Event_CloseWindow 
        Ende=1 
      Case 0 
        Delay(1) 
    EndSelect 
  Until Ende=1 
EndIf

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger