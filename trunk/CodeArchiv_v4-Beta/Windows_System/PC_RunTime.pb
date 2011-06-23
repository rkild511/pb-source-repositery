; German forum: http://www.purebasicforums.com/german/viewtopic.php?t=2810&highlight=
; Author: Pelagio (updated for PB 4.00 by Andre)
; Date: 04. April 2005
; OS: Windows
; Demo: No


; Check the PC runtime
; Place it in the AutoStart drawer of Windows, it will then be started 
; and put a icon in the systray. After a doubleclick it shows the in and out times.

; Ich habe schon vor einiger Zeit mir ein Programm geschrieben, das 
; die Zeit erfasst die ich am Rechner verbringe. Das Programm wird 
; mit "Dateiname.exe Start" im Autostart Ordner positioniert und 
; legt sich in die Tray. Beim DoppelKlick erscheint eine Tabelle 
; mit den Ein- und Ausgängen. 

; PCRun 
;~~~~~~~ 

;- Konstanten 
Enumeration ;Fenster 
#Window_0 
EndEnumeration 

Enumeration ;Gadget 
#LISTGRID 
#SYSTRAY 
#IMAGEVIEW 
EndEnumeration 

#False        = 0 
#True         = 1 
#Real         = -1 
#BASEFILENAME = "PCRun" 
#SEPERATOR    = ";" 
#DATAEXT      = ".dat" 

;- Variablen 
Global NewList DS.s() 
Global baseQuit.b 

;- Daten 
DataSection 
SetupData: 
Data.s "User", "Datum", "Zeit", "Art" 
EndDataSection 

;- Source 
                        
Declare DataWrite(Value.s) 
Declare.l WindowCallBack(WindowID, Message, wParam, lParam) 
Declare.l TrayCallBack(WindowID, Message, wParam, lParam) 
Declare Main(Value.b) 
Declare DataRead() 
Declare Open_Window_Base(Value.b) 
                                  

Procedure Main(Value.b) 
   Protected baseEvent.l 
   baseQuit = #False 

   Open_Window_Base(Value) 
   If (Value = #True) 
      DataWrite("ON") 
      SetWindowCallback(@TrayCallBack()) 
   Else 
      SetWindowCallback(@WindowCallBack()) 
      ;PureCOLOR_SetGadgetColorEx(#LISTGRID, $000000, $FFFFFF, $FFFF80, #PureCOLOR_LV_AlternateColors) 
      ;If (PureLVSORT_SelectGadgetToSort(#LISTGRID, #True) = #PureLVSORT_Ok) 
      ;   PureLVSORT_SetColumnType  (#LISTGRID, 0, #PureLVSORT_String) 
      ;   PureLVSORT_SetColumnType  (#LISTGRID, 1, #PureLVSORT_DateDDMMYYYY) 
      ;   PureLVSORT_SetColumnType  (#LISTGRID, 2, #PureLVSORT_NoSorting) 
      ;   PureLVSORT_SetColumnType  (#LISTGRID, 3, #PureLVSORT_String) 
      ;   PureLVSORT_SortListIconNow(#LISTGRID, 1, #Real) 
      ;EndIf 
   EndIf 
   Repeat 
      baseEvent = WaitWindowEvent() 
      Select baseEvent 
         Case #PB_Event_CloseWindow 
            baseQuit = #True 
         Case  #PB_Event_SysTray 
         If (EventType() = #PB_EventType_LeftDoubleClick) 
            RunProgram(#BASEFILENAME + ".exe", "", "") 
         EndIf 
      EndSelect 
   Until(baseQuit = #True) 
EndProcedure 

Procedure.l TrayCallBack(WindowID, Message, wParam, lParam) 
   If (Message = #WM_QUERYENDSESSION) 
      DataWrite("OFF") 
      baseQuit = #True 
      ProcedureReturn #True 
   Else 
      ProcedureReturn #PB_ProcessPureBasicEvents 
   EndIf 
EndProcedure 

Procedure.l WindowCallBack(WindowID, Message, wParam, lParam) 
      ReturnValue.l = #PB_ProcessPureBasicEvents 
      ;ReturnValue = PureLVSORT_CallBack(WindowID, Message, wParam, lParam, ReturnValue) 
      ;ReturnValue = PureCOLOR_CallBack (WindowID, Message, wParam, lParam, ReturnValue) 
      ProcedureReturn ReturnValue 
EndProcedure 

Procedure DataWrite(Value.s) 
   Protected Text.s, User.s 
   Buffer.s = Space(1024) 
   bufsize.l = 1024 

   GetUserName_(@Buffer, @bufsize) 
   User = PeekS(*Buffer,bufsize) 
   Text = User + #SEPERATOR + FormatDate("%dd.%mm.%yyyy", Date()) + #SEPERATOR + FormatDate("%hh:%ii", Date()) + #SEPERATOR + Value 
   If  OpenFile(0, #BASEFILENAME + #DATAEXT) 
      FileSeek(0, Lof(0)) 
      WriteStringN(0, Text) 
      CloseFile(0) 
   EndIf 
EndProcedure 
                            
Procedure Open_Window_Base(Value.b) 
   Protected Text.s 

   If Value 
      If OpenWindow(#Window_0, 0, 0, 0, 0, "Computerlaufzeit", #PB_Window_SystemMenu | #PB_Window_Invisible) 
         AddSysTrayIcon(#SYSTRAY, WindowID(#Window_0), LoadImage(#IMAGEVIEW, #BASEFILENAME + ".ico")) 
         SysTrayIconToolTip(#SYSTRAY, #BASEFILENAME) 
         HideWindow(#Window_0, #True) 
      EndIf 
   Else 
      If OpenWindow(#Window_0, 216, 0, 314, 300, "Computerlaufzeit", #PB_Window_SystemMenu | #PB_Window_ScreenCentered| #PB_Window_TitleBar) 
         If CreateGadgetList(WindowID(#Window_0)) 
            Restore SetupData: Read Text 
            ListIconGadget(#LISTGRID,  5, 5, (WindowWidth(#Window_0) - 10), (WindowHeight(#Window_0) - 10), Text, 100, #PB_ListIcon_GridLines) 
            Read Text: AddGadgetColumn(#LISTGRID, 1, Text, 100) 
            Read Text: AddGadgetColumn(#LISTGRID, 2, Text, 050) 
            Read Text: AddGadgetColumn(#LISTGRID, 3, Text, 050) 
            DataRead() 
         EndIf 
      EndIf 
   EndIf 
EndProcedure 

Procedure DataRead() 
   Protected Count.l, Zaehler.l, Result.s 

   If  ReadFile(0,#BASEFILENAME + #DATAEXT) 
      While (Eof(0) = #False) 
         AddElement(DS()) 
         DS() =ReadString(0) 
      Wend 
      CloseFile(0) 
      Count = (CountList(DS()) - 1) 
      LastElement(DS()) 
      For Zaehler = 0 To Count 
         Result = ReplaceString(DS(), #SEPERATOR, #LF$) 
         AddGadgetItem(#LISTGRID, -1, Result) 
         PreviousElement(DS()) 
      Next Zaehler 
      ClearList(DS()) 
   Else 
      MessageRequester("Infobox", "Keine Daten vorhanden.") 
   EndIf 
EndProcedure 

If (ProgramParameter() = Trim("")): Main(#False): Else: Main(#True): EndIf 

End 


; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = --
; EnableXP