; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7779&highlight=
; Author: TerryHough (updated for PB3.93 by ts-soft, updated for PB4.00 by blbltheworm)
; Date: 06. October 2003
; OS: Windows
; Demo: No


; HDAvail - updated 10/07/2003 by TerryHough 

; based on code samples from the PB Forum 
; from PB forums by fweil 
; post http://purebasic.myforums.net/viewtopic.php?t=3770 

; GetFreeDiskSpace - 09/24/2003 Updated by TerryHough 
; from PB forums by GPI 
; post http://purebasic.myforums.net/viewtopic.php?t=7541 

; ------------- Procedures to get Total and Free Disk Space -------------- 
Global Free$ 
Global Total$ 

Structure HiLow 
  lowlow.w 
  lowhi.w 
  hilow.w 
  hihi.w 
EndStructure 

; ----------------- Get the Free Disk Space ---------------- 
Procedure.s GetFreeSpace(p$) 
  #div=10 
  #mask=(1<<#div)-1 
  #mul=16-#div 
  If Left(p$,2)="\\" 
    a=FindString(p$,"\",3) 
  Else 
    a=FindString(p$,"\",1) 
  EndIf 
  If a=0 : a=Len(p$) : EndIf 
  p$=Left(p$,a) 
  If GetDiskFreeSpaceEx_(@p$,@free.HiLow,@Total.HiLow,@TotalFree.HiLow) 
    hilow=free\hilow&$FFFF 
    hihi=free\hihi&$FFFF 
    lowlow=free\lowlow&$FFFF 
    lowhi=free\lowhi&$FFFF 
    
    p=1 
    While hihi>0 Or hilow>0 Or lowhi>0 
      lowlow=(lowlow>>#div)+((lowhi&#mask)<<#mul) 
      lowhi =(lowhi >>#div)+((hilow&#mask)<<#mul) 
      hilow =(hilow >>#div)+((hihi&#mask)<<#mul) 
      hihi  =(hihi>>#div) 
      p+1 
    Wend 
    
    If lowlow>1024 
      Free$= StrF(lowlow/1024,2)+" "+StringField("Byte,Kb,Mb,Gb,Tb",p+1,",") 
    Else 
      Free$= StrF(lowlow,2)+" "+StringField("Byte,Kb,Mb,Gb,Tb",p,",") 
    EndIf 
  Else 
    Free$="---" 
  EndIf 
  ProcedureReturn Free$ 
  
EndProcedure 

; ----------------- Get the Total Disk Space ---------------- 
; created from GetFreeSpace by GPI shown above. Could be in one procedure. 
Procedure.s GetTotalSpace(p$) 
  #div=10 
  #mask=(1<<#div)-1 
  #mul=16-#div 
  If Left(p$,2)="\\" 
    a=FindString(p$,"\",3) 
  Else 
    a=FindString(p$,"\",1) 
  EndIf 
  If a=0 : a=Len(p$) : EndIf 
  p$=Left(p$,a) 
  If GetDiskFreeSpaceEx_(@p$,@free.HiLow,@Total.HiLow,@TotalFree.HiLow) 
    hilow=Total\hilow&$FFFF 
    hihi=Total\hihi&$FFFF 
    lowlow=Total\lowlow&$FFFF 
    lowhi=Total\lowhi&$FFFF 
    
    p=1 
    While hihi>0 Or hilow>0 Or lowhi>0 
      lowlow=(lowlow>>#div)+((lowhi&#mask)<<#mul) 
      lowhi =(lowhi >>#div)+((hilow&#mask)<<#mul) 
      hilow =(hilow >>#div)+((hihi&#mask)<<#mul) 
      hihi  =(hihi>>#div) 
      p+1 
    Wend 
    
    If lowlow>1024 
      Total$= StrF(lowlow/1024,2)+" "+StringField("Byte,Kb,Mb,Gb,Tb",p+1,",") 
    Else 
      Total$= StrF(lowlow,2)+" "+StringField("Byte,Kb,Mb,Gb,Tb",p,",") 
    EndIf 
  Else 
    Total$="---" 
  EndIf 
  ProcedureReturn Total$ 
  
EndProcedure 


; ----------------- Procedures used by HDAvail program code -------------- 
Procedure DisplayHelp() 
  Help$ = "" 
  Help$ + "Checks the list of available drives and reports some information about them." + Chr(10) 
  Help$ + "This includes:" + Chr(10) 
  Help$ + Chr(9) + "Drive letter (ID)" + Chr(10) 
  Help$ + Chr(9) + "Drive label" + Chr(10) 
  Help$ + Chr(9) + "Drive serial number" + Chr(10) 
  Help$ + Chr(9) + "File system used" + Chr(10) 
  Help$ + Chr(9) + "Drive type" + Chr(10) 
  Help$ + Chr(9) + "Drive status" + Chr(10) 
  Help$ + Chr(9) + "Total drive space" + Chr(10) 
  Help$ + Chr(9) + "Free space available" + Chr(10) 
  Help$ + Chr(10) 
  Help$ + "Pressing F1 displays this information." + Chr(10) 
  Help$ + "Pressing F10 repeats the drive analysis." + Chr(10) + Chr(10) 
  Help$ + "Closing the program by pressing the ESCape key." + Chr(10) 
  MessageRequester("Available Drives",Help$,#MB_ICONINFORMATION) 
EndProcedure 

Procedure.s sGetDriveType(Parameter.s) 
  Result.s 
  Select GetDriveType_(Parameter) 
  Case 2 
    Result = "Removable Drive" 
  Case 3 
    Result = "Fixed Drive" 
  Case 4 
    Result = "Remote (Network)" 
  Case 5 
    Result = "CDRom Drive" 
  Case 6 
    Result = "RAM Drive" 
    Default 
    Result = "Unknown" 
  EndSelect 
  ProcedureReturn Result 
EndProcedure 

; ----------------- UpdateDrives identifies/analyzes available drives -------- 
Procedure UpdateDrives(Delay.l) 
  *Buffer = AllocateMemory(255) 
  ipt.l 
  C.l 
  Serial.l 
  LogicalDriveType.s 
  VName.s 
  FSName.s 
  Text.s 
  EOL.s 
  VName  = Space(255) 
  FSName = Space(255) 
  Global Dim LogicalDrives.s(16)   ; Allow room for up to 16 drives 
;  ClearGadgetItemList(10)   ; Erase the list of items 
  LogicalDrives(1) = ""     ; Set the first table entry to null 
  ipt = 1                   ; Initialize the items counter to 1 
  ; Get the drives names in *Buffer and split it into a table 
  ; 
  ; GetLogicalDriveStrings writes the list of drives names 
  ; in a buffer, each name being Chr(0) separated. 
  ; The end of the buffer contains a double Chr(0). 
  For i = 0 To GetLogicalDriveStrings_(255, *Buffer) 
    C = PeekB(*Buffer + i) 
    If C <> 0 
      LogicalDrives(ipt) = UCase(LogicalDrives(ipt) + Chr(C)) 
    Else 
      ipt = ipt + 1 
      LogicalDrives(ipt) = "" 
    EndIf 
  Next 
  
  ; Decrease the last entry number until no null item is found 
  While LogicalDrives(ipt) = "" 
    ipt = ipt - 1 
  Wend 
  
  ; Loop to give further information about found drives 
  ; Values I found in different documents are not so clear. This has to be checked. 
  For i = 1 To ipt 
    LogicalDriveType = sGetDriveType(LogicalDrives(i)) 
    
    ; Items are displayed using found parameters or filling status for not available drives 
    If GetVolumeInformation_(LogicalDrives(i), VName, 255, Serial, 0, 0, FSName, 255) 
      GetFreeSpace(LogicalDrives(i)) 
      GetTotalSpace(LogicalDrives(i)) 
      Text = LogicalDrives(i) + Chr(10) + VName + Chr(10) + Str(Serial) + Chr(10) + FSName + Chr(10) + LogicalDriveType + Chr(10) + " " + Chr(10) + Total$ + Chr(10) + Free$ 
      
    Else 
      Text = LogicalDrives(i) + Chr(10) + Chr(10) + Chr(10) + Chr(10) + LogicalDriveType 
      If GetLastError_() = 21 
        Text = Text + Chr(10) + "Device not ready" 
      Else 
        Text = Text + Chr(10) + "LastError: " + Str(GetLastError_()) 
      EndIf 
    EndIf 
    AddGadgetItem(10, -1, Text) 
  Next 
EndProcedure 

; ----------------- Main program starts here ---------------- 
Quit.l 
WEvent.l 
EventMenu.l 
Serial.l 
Delay.l 
Parameter.s 
LogicalDriveType.s 
VName.s 
FSName.s 
Text.s 

Quit = #False 

errmode = SetErrorMode_(#SEM_FAILCRITICALERRORS) 
If OpenWindow(0, 0, 0, 624, 315, "Available Drives", #PB_Window_ScreenCentered | #PB_Window_SystemMenu | #PB_Window_TitleBar) 
  AddKeyboardShortcut(0, #PB_Shortcut_F1, 20) 
  AddKeyboardShortcut(0, #PB_Shortcut_F10, 30) 
  AddKeyboardShortcut(0, #PB_Shortcut_Escape, 99) 
  If CreateGadgetList(WindowID(0)) 
    ListIconGadget(10, 10, 30, 604, 246, "Drive", 50, #PB_ListIcon_GridLines) 
    AddGadgetColumn(10, 1, "Label", 80) 
    AddGadgetColumn(10, 2, "Serial", 50) 
    AddGadgetColumn(10, 3, "FS", 50) 
    AddGadgetColumn(10, 4, "Type", 110) 
    AddGadgetColumn(10, 5, "Status", 120) 
    AddGadgetColumn(10, 6, "Size", 70) 
    AddGadgetColumn(10, 7, "Free space", 70) 
    HideGadget(10,1) 
    TextGadget(20, 1, 280, 603, 15, "It will take a moment to do the analysis, please wait.", #PB_Text_Center) 
  EndIf 
  
  If CreateStatusBar(0, WindowID(0)) 
    StatusBarText(0, 0, "F1 - Help | F10 - Repeat | Esc - Quit", 0) 
  EndIf 
  
  If CreateToolBar(0, WindowID(0)) 
    ToolBarStandardButton(30, #PB_ToolBarIcon_Redo) 
    ToolBarToolTip(0,30, "Refresh the Drive List") 
    ToolBarSeparator() 
    ToolBarStandardButton(20, #PB_ToolBarIcon_Help) 
    ToolBarToolTip(0,20, "Display a Help screen") 
    ToolBarSeparator() 
  EndIf 

  While WindowEvent():Wend  ; Give the window a chance to display 
  UpdateDrives(0) 
  SetGadgetText(20,"Drive analysis completed.") 
  HideGadget(10,0) 
  Repeat 
    WEvent = WaitWindowEvent() 
    Select WEvent 
    Case #PB_Event_CloseWindow 
      Quit = #True 
    Case #PB_Event_Menu 
      EventMenu = EventMenu() 
      Select EventMenu 
      Case 20 
        DisplayHelp() 
      Case 30 
        HideGadget(10,1) 
        ClearGadgetItemList(10)   ; Clear the previous list 
        SetGadgetText(20,"It will take a moment to do the analysis, please wait.") 
        UpdateDrives(0) 
        SetGadgetText(20,"Drive analysis completed.") 
        HideGadget(10,0) 
      Case 99 
        Quit = #True 
      EndSelect 
      Default 
    EndSelect 
  Until Quit 
EndIf 
End 
; ---------------------------- End of Program Code --------------- 


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
