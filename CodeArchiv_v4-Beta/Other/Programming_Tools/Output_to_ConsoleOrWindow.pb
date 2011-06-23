; www.purearea.net (Sourcecode collection by cnesm)
; Author: Danilo (updated for PB 4.00 by Andre)
; Date: 22. November 2003
; OS: Windows
; Demo: No

; 
; by Danilo, 17.07.2003 - german forum 
; 
; compile to CONSOLE !! 
; 
; run           : opens the window 
; run with '/C' : writes to console 
; 
If UCase(ProgramParameter())="/C" 
  hCon = GetStdHandle_(#STD_OUTPUT_HANDLE) 
  If hCon 
    EOL.s  = Chr(13)+Chr(10) ; end of line 
    Line1$ = "Hello World!"+EOL 
    Line2$ = "Testing..."  +EOL 
    WriteConsole_(hCon,@Line1$,Len(Line1$),@retval,0) 
    WriteConsole_(hCon,@Line2$,Len(Line2$),@retval,0) 
    Delay(3000) 
  EndIf 
Else 
  OpenWindow(0,150,150,500,500,"Test",#PB_Window_SystemMenu) 
    FreeConsole_() 
    While WindowEvent():Wend 
    CreateGadgetList(WindowID(0)) 
    ListViewGadget(0,2,2,296,296) 
    AddGadgetItem(0,-1,"Hello World!") 
    AddGadgetItem(0,-1,"Testing...") 
  Repeat 
  Until WaitWindowEvent()=#PB_Event_CloseWindow 
EndIf 

; IDE Options = PureBasic v4.00 (Windows - x86)
; ExecutableFormat = Console
; Folding = -
; EnableXP