; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2921&highlight=
; Author: NicTheQuick (updated for PB4.00 by blbltheworm)
; Date: 24. November 2003
; OS: Windows
; Demo: Yes

; ; Check the checksum of the original PB editor (v3.80)
; Global CRC32_Checksum.l 
; CRC32_OrigChecksum = $FA217AA1 
; CRC32_OrigChecksum_wDebug = $2B378058 

; Check the checksum of jaPBe V3 (PB v4.00)
Global CRC32_Checksum.l 
CRC32_OrigChecksum = $7A05E4BC 
CRC32_OrigChecksum_wDebug = $AC1013C5

;Hier beginnt das gesamte Programm, auch evtl. Includes müssen hier rein 
Program_Begin: 
Procedure CRC32_Program() 
  Protected CRC32.l 
  CRC32 = CRC32Fingerprint(?Program_Begin, ?Program_End - ?Program_Begin) 
  ProcedureReturn CRC32 
EndProcedure 

If OpenWindow(0, 0, 0, 400, 90, "Window", #PB_Window_ScreenCentered | #PB_Window_SystemMenu) 
  If CreateGadgetList(WindowID(0)) 
    TextGadget(0, 0, 0, 400, 18, "", #PB_Text_Center) 
    TextGadget(1, 0, 19, 400, 18, "", #PB_Text_Center) 
    TextGadget(2, 0, 37, 400, 18, "", #PB_Text_Center) 
    TextGadget(3, 0, 73, 400, 18, "", #PB_Text_Center) 
    
    CRC32.l = CRC32_Program() 
    SetGadgetText(0, "Soll-Wert: " + Str(CRC32_OrigChecksum) + " (Hex: $" + RSet(Hex(CRC32_OrigChecksum), 8, "0") + ")") 
    SetGadgetText(1, "Soll-Wert (Debug) " + Str(CRC32_OrigChecksum_wDebug) + " (Hex: $" + RSet(Hex(CRC32_OrigChecksum_wDebug), 8, "0") + ")") 
    SetGadgetText(2, "Ist-Wert: "  + Str(CRC32) + " (Hex: $" + RSet(Hex(CRC32), 8, "0") + ")") 
    
    If CRC32 = CRC32_OrigChecksum 
      SetGadgetText(3, "Das Programm ist unverändert und wurde ohne Debugger gestartet") 
    ElseIf CRC32 = CRC32_OrigChecksum_wDebug 
      SetGadgetText(3, "Das Programm ist unverändert und wurde mit Debugger gestartet") 
    Else 
      SetGadgetText(3, "Das Programm wurde verändert") 
    EndIf 
    
    Repeat 
    Until WaitWindowEvent() = #PB_Event_CloseWindow 
    End 
  EndIf 
EndIf 

;Nach dieser Sprungmarke darf nichts mehr stehen 
Program_End:

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
