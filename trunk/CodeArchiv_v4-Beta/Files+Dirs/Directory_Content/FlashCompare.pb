; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7267&highlight=
; Author: Fangbeast (updated for PB4.00 by blbltheworm)
; Date: 19. August 2003
; OS: Windows
; Demo: No

; Copyright, PeriTek Visions, 2003. 
; Free, do what you wish with it. 
; 
;=========================================================================================================================================== 
; Init Constants 
;=========================================================================================================================================== 

;---------- 
#ProgramVersion                         = "FlashCompare, v1.0" 
;---------- 

; Window Constants 

#Window_FlashGetCompare                 = 1 

; Window_FlashGetCompare 

#MenuBar_FlashGetCompare                = 1 

Enumeration
  #MenuBar_FlashGetCompare_loaddirlist
  #MenuBar_FlashGetCompare_savedirlist
  #MenuBar_FlashGetCompare_loadfilelist
  #MenuBar_FlashGetCompare_savefilelist
  #MenuBar_FlashGetCompare_catfiles
  #MenuBar_FlashGetCompare_parselist
  #MenuBar_FlashGetCompare_runcompare
  #MenuBar_FlashGetCompare_movefiles
  #MenuBar_FlashGetCompare_exitnow
  
  #Gadget_FlashGetCompare_Frame
  
  #Gadget_FlashGetCompare_filelist
  #Gadget_FlashGetCompare_htmllist
  
  #Gadget_FlashGetCompare_toolbar
  
  #Gadget_SplitterGadget
EndEnumeration

#StatusBar_FlashGetCompare              = 1 
#StatusBar_FlashGetCompare_messages     = 0 
#StatusBar_FlashGetCompare_filenames    = 1 
#StatusBar_FlashGetCompare_filerefs     = 2 

;- Setup names for numerical calendar --------------------------------------------------------------------------------------- 

Global Dim nameOfDay.s(7)                                          ; fill an array with the names of the days 

nameOfDay(0) = "Sunday"     : nameOfDay(1) = "Monday"   : nameOfDay(2) = "Tuesday"  : nameOfDay(3) = "Wednesday"  
nameOfDay(4) = "Thursday"   : nameOfDay(5) = "Friday"   : nameOfDay(6) = "Saturday" 

Global Dim daysPerMonth(12)                                       ; fill an array on how many days per month there are 

For x = 0 To 11      
  daysPerMonth(x) = 31 
Next 

daysPerMonth(1)  = 28   : daysPerMonth(3)  = 30   : daysPerMonth(5)  = 30 : daysPerMonth(8)  = 30 
daysPerMonth(10) = 30 

Global Dim nameOfMonth.s(12)                                    ; fill an array with the names of the months 

nameOfMonth(0)  = "January"   : nameOfMonth(1)  = "February"   :  nameOfMonth(2)  = "March"     : nameOfMonth(3)  = "April"    
nameOfMonth(4)  = "May"       : nameOfMonth(5)  = "June"       :  nameOfMonth(6)  = "July"      : nameOfMonth(7)  = "August"      
nameOfMonth(8)  = "September" : nameOfMonth(9)  = "October"    :  nameOfMonth(10) = "November"  : nameOfMonth(11) = "December" 

Global Dim years.s(7)                                           ; fill an array with the years 

years(0) = "2002" : years(1) = "2003" : years(2) = "2004" : years(3) = "2005" : years(4) = "2006"   : years(5) = "2007" 
years(6) = "2008" 

;=========================================================================================================================================== 
; Declare any needed lists 
;=========================================================================================================================================== 

Global NewList dir.s()                                              ; Recursion routine uses this to find all files 

;=========================================================================================================================================== 
; Any global values needed 
;=========================================================================================================================================== 

Global hStatusBar, OriginalWidth, OriginalHeight, OldStatusBarWidth, NewStatusBarWidth, hStatusBar, currentdate.s 

;============================================================================================================================ 
; Dimension the number of fields in the status bar that we are going to resize in the callback 
;============================================================================================================================ 

Global Dim StatusBarFields.l(2) ; <- needed for resize, must be the number of Fields -1 (since it begins at 0) 

;=========================================================================================================================================== 
; Program declarations 
;=========================================================================================================================================== 

Declare.l Window_FlashGetCompare() 
Declare   Messages(Heading.s, message.s) 
Declare   WindowCallback(WindowID,message,wParam,lParam) 
Declare   StatMess(Field.l, message.s) 
Declare   FlushEvents() 
Declare   SetDate() 
Declare.s addDateSuffix(date.s) 

;=========================================================================================================================================== 
; Any needed structures 
;=========================================================================================================================================== 

Structure dateStructure 
  Year.w 
  Month.w 
  DayOfWeek.w 
  Day.w 
  hour.w 
  minute.w 
  Second.w 
  Milliseconds.w 
EndStructure 

;=========================================================================================================================================== 
; Main Event Loop 
;=========================================================================================================================================== 

If Window_FlashGetCompare() 
  
  SetWindowCallback(@WindowCallback()) 
  
  SetDate()                                              ; Set the current date for the user 
  
  quitFlashGetCompare = 0 
  
  StatMess(0, "Ready") 
  StatMess(1, "File(s) ") 
  StatMess(2, "Ref(s) ") 
  
  Repeat 
    EventID = WaitWindowEvent() 
    Select EventID 
      Case #PB_Event_CloseWindow 
        If EventWindow() = #Window_FlashGetCompare 
          quitFlashGetCompare = 1 
        EndIf 
        
      Case #PB_Event_Menu 
        Select EventMenu() 
          Case #MenuBar_FlashGetCompare_loaddirlist 
          Case #MenuBar_FlashGetCompare_savedirlist   : Gosub SaveDirectoryList 
          Case #MenuBar_FlashGetCompare_loadfilelist 
          Case #MenuBar_FlashGetCompare_savefilelist 
          Case #MenuBar_FlashGetCompare_catfiles      : Gosub MakeCatalogue 
          Case #MenuBar_FlashGetCompare_parselist     : Gosub ParseHtml 
          Case #MenuBar_FlashGetCompare_runcompare    : Gosub CompareFiles 
          Case #MenuBar_FlashGetCompare_movefiles     : Gosub MoveFiles 
          Case #MenuBar_FlashGetCompare_exitnow 
        EndSelect 
        
      Case #PB_Event_Gadget 
        Select EventGadget() 
          Case #Gadget_FlashGetCompare_filelist 
            Select EventType() 
              Case #PB_EventType_LeftDoubleClick 
              Case #PB_EventType_RightDoubleClick 
              Case #PB_EventType_RightClick 
              Default 
            EndSelect 
          Case #Gadget_FlashGetCompare_htmllist 
            Select EventType() 
              Case #PB_EventType_LeftDoubleClick 
              Case #PB_EventType_RightDoubleClick 
              Case #PB_EventType_RightClick 
              Default 
            EndSelect 
        EndSelect 
        
    EndSelect 
  Until quitFlashGetCompare 
  CloseWindow(#Window_FlashGetCompare) 
EndIf 
End 

;=========================================================================================================================================== 
; Program window 
;=========================================================================================================================================== 

Procedure.l Window_FlashGetCompare() 
  If OpenWindow(#Window_FlashGetCompare,189,0,840,600,#ProgramVersion,#PB_Window_SystemMenu|#PB_Window_Invisible|#PB_Window_MinimizeGadget|#PB_Window_MaximizeGadget|#PB_Window_SizeGadget) 
    Brush.LOGBRUSH\lbColor=16695498 
    SetClassLong_(WindowID(#Window_FlashGetCompare),#GCL_HBRBACKGROUND,CreateBrushIndirect_(Brush)) 
    OriginalWidth  = WindowWidth(#Window_FlashGetCompare)  ; Original non-client width. 
    OriginalHeight = WindowHeight(#Window_FlashGetCompare) ; Original non-client height. 
    OldStatusBarWidth = WindowWidth(#Window_FlashGetCompare)  ; <- needed for resizing 
    CreateMenu(#MenuBar_FlashGetCompare,WindowID(#Window_FlashGetCompare)) 
    MenuTitle("Files") 
    MenuItem(#MenuBar_FlashGetCompare_loaddirlist,"Load Directory List") 
    MenuItem(#MenuBar_FlashGetCompare_savedirlist,"Save Directory List") 
    MenuItem(#MenuBar_FlashGetCompare_loadfilelist,"Load File List") 
    MenuItem(#MenuBar_FlashGetCompare_savefilelist,"Save File List") 
    MenuTitle("Jobs") 
    MenuItem(#MenuBar_FlashGetCompare_catfiles,"Catalogue Files") 
    MenuItem(#MenuBar_FlashGetCompare_parselist,"Parse HTML List") 
    MenuItem(#MenuBar_FlashGetCompare_runcompare,"Run Comparison") 
    MenuItem(#MenuBar_FlashGetCompare_movefiles,"Move UnReferenced Files") 
    MenuTitle("Exit menu") 
    MenuItem(#MenuBar_FlashGetCompare_exitnow,"Exit Now") 
    If CreateGadgetList(WindowID(#Window_FlashGetCompare)) 
      Frame3DGadget(#Gadget_FlashGetCompare_Frame,5,0,830,555,"") 
      ListIconGadget(#Gadget_FlashGetCompare_filelist,15,15,400,530,"Files on disk and not in database",600,#PB_ListIcon_MultiSelect|#PB_ListIcon_FullRowSelect|#PB_ListIcon_AlwaysShowSelection) 
      SendMessage_(GadgetID(#Gadget_FlashGetCompare_filelist),#LVM_SETBKCOLOR,0,16695498) 
      SendMessage_(GadgetID(#Gadget_FlashGetCompare_filelist),#LVM_SETTEXTBKCOLOR,0,16695498) 
      ListIconGadget(#Gadget_FlashGetCompare_htmllist,425,15,400,530,"Files in database but not on disk",600,#PB_ListIcon_MultiSelect|#PB_ListIcon_FullRowSelect|#PB_ListIcon_AlwaysShowSelection) 
      SendMessage_(GadgetID(#Gadget_FlashGetCompare_htmllist),#LVM_SETBKCOLOR,0,16695498) 
      SendMessage_(GadgetID(#Gadget_FlashGetCompare_htmllist),#LVM_SETTEXTBKCOLOR,0,16695498) 
      hStatusBar = CreateStatusBar(#StatusBar_FlashGetCompare,WindowID(#Window_FlashGetCompare)) 
      AddStatusBarField(600) 
      AddStatusBarField(120) 
      AddStatusBarField(120) 
      SplitterGadget(#Gadget_SplitterGadget, 15, 15, 810, 530, #Gadget_FlashGetCompare_filelist, #Gadget_FlashGetCompare_htmllist, #PB_Splitter_Vertical|#PB_Splitter_Separator) 
      HideWindow(#Window_FlashGetCompare,0) 
      ProcedureReturn WindowID(#Window_FlashGetCompare) 
    EndIf 
  EndIf 
EndProcedure 

;=========================================================================================================================================== 
; Custom error messages to cut down on the amount of typing 
;=========================================================================================================================================== 

Procedure Messages(Heading.s, message.s) 
  
  MessageRequester(Heading.s, message.s, #PB_MessageRequester_Ok) 
  
EndProcedure 

;=========================================================================================================================================== 
; Window and object resizing 
;=========================================================================================================================================== 

Procedure WindowCallback(WindowID,message,wParam,lParam) 
  
  ReturnValue = #PB_ProcessPureBasicEvents 
  
  Select message 
    Case #WM_GETMINMAXINFO                                            ; Restrict the minimum size to 500x(307 + MenuHeight()), borders included 
      Result = 0 
      *ptr.MINMAXINFO       = lParam 
      *ptr\ptMinTrackSize\x = 640 + 8 
      *ptr\ptMinTrackSize\y = 480 + 14 + MenuHeight() 
    Case #WM_SIZE 
      winwidth.l  = WindowWidth(#Window_FlashGetCompare)                                     ; Get the new width of the window 
      winheight.l = WindowHeight(#Window_FlashGetCompare)                                    ; Get the new height of the window 
      widthchange  = winwidth  - OriginalWidth                        ; Get the width difference 
      heightchange = winheight - OriginalHeight                       ; Get the height difference 108,0,587,400 
      ;----------------------------------------------------------------------------------------------------------------- 
      ResizeGadget(#Gadget_FlashGetCompare_Frame, 5, 0, 830 + widthchange, 555 + heightchange) 
      
      ResizeGadget(#Gadget_SplitterGadget,#PB_Ignore,#PB_Ignore, 810 + widthchange, 530 + heightchange) 
      ;      SetGadgetState(#Gadget_SplitterGadget, 104) 
      NewStatusBarWidth = WindowWidth(#Window_FlashGetCompare)                               ; Get new width 
      SendMessage_(hStatusBar, #SB_GETPARTS, 3, @StatusBarFields())   ; 4 is the number of Fields in the StatusBar 
      For i = 0 To 2                                                  ; 3 is number of Fields-1, because Array goes from 0 to 3 
        StatusBarFields(i) = StatusBarFields(i) + (NewStatusBarWidth - OldStatusBarWidth) 
      Next i 
      SendMessage_(hStatusBar, #SB_SETPARTS, 3, @StatusBarFields())      
      OldStatusBarWidth = NewStatusBarWidth                           ; New Width will be old next time 
      RedrawWindow_(WindowID(#Window_FlashGetCompare), 0, 0, #RDW_INVALIDATE) 
      ReturnValue = 1 
  EndSelect 
  
  ProcedureReturn  ReturnValue 
  
EndProcedure 

;=========================================================================================================================================== 
; Custom routine to set statusbar messages to save typing 
;=========================================================================================================================================== 

Procedure StatMess(Field.l, message.s) 
  
  StatusBarText(#StatusBar_FlashGetCompare, Field.l, message.s) 
  
EndProcedure 

;=========================================================================================================================================== 
; Flush window events to prevent hanging and greying out of objects 
;=========================================================================================================================================== 

Procedure FlushEvents() 
  
  While WindowEvent() : Wend 
  
EndProcedure 

;=========================================================================================================================================== 
; Set the current day and date to the window title area 
;=========================================================================================================================================== 

Procedure SetDate() 
  
  newDate.dateStructure 
  GetSystemTime_(@newDate) 
  weekDay.b = newDate\DayOfWeek 
  Day.b     = newDate\Day 
  Month.b   = newDate\Month 
  Year.w    = newDate\Year 
  
  currentdate.s = nameOfDay(weekDay) + ", " + addDateSuffix(Str(Day)) + ", " + nameOfMonth(Month - 1) + ", " + Str(Year) 
  
  SetWindowText_(WindowID(#Window_FlashGetCompare), #ProgramVersion + " - " + currentdate.s) 
  
EndProcedure 

;=========================================================================================================================================== 
; Add date suffix to date figure 
;=========================================================================================================================================== 

Procedure.s addDateSuffix(date.s) 
  
  If date = "1" Or date = "21" Or date = "31" 
    date = date+"st" 
  ElseIf date = "2" Or date = "22" 
    date = date+"nd" 
  ElseIf date = "3" Or date = "23" 
    date = date+"rd" 
  Else 
    date = date+"th" 
  EndIf 
  
  ProcedureReturn date 
  
EndProcedure 

;=========================================================================================================================================== 
; Cataloge files and populate the display 
;=========================================================================================================================================== 

MakeCatalogue: 

CompareFlag = 0 
  
ClearList(dir.s()) 

drive.s   = PathRequester("Please select the drive and directory to catalogue", "") 
  
If drive.s = "" 
  Return 
EndIf 
    
If Right(drive.s, 1) = "\" 
  drive.s = Left(drive.s, Len(drive.s) - 1) 
EndIf 

ClearGadgetItemList(#Gadget_FlashGetCompare_filelist) 
  
AddElement(dir()) 
    
dir() = drive.s                                                ; (Paul Leischow) 
    
idx = 0 
    
Repeat 
  SelectElement(dir(), idx) 
  If ExamineDirectory(0, dir(), "*.*") 
    Path.s = dir() + "\" 
    Quit = 0 
    Repeat 
      nextfile = NextDirectoryEntry(0) 
      FileName.s = DirectoryEntryName(0) 
      Select nextfile 
        Case 0 
          Quit = 1 
        Case 1 
          diskfile.s = Path + FileName.s 
          AddGadgetItem(#Gadget_FlashGetCompare_filelist, - 1, diskfile.s) 
          FlushEvents() 
          StatMess(1, "File(s) " + Str(count)) 
          SendMessage_(GadgetID(#Gadget_FlashGetCompare_filelist), #LVM_ENSUREVISIBLE, count , 0) 
          count + 1 
        Case 2 
          FileName.s = DirectoryEntryName(0) 
          If FileName.s <> ".." And FileName.s <> "." 
            AddElement(dir()) 
            dir() = Path + FileName.s 
          EndIf 
      EndSelect  
    Until Quit = 1 
  EndIf 
  idx + 1 
Until idx > CountList(dir()) - 1 

ClearList(dir.s()) 

Return 

;=========================================================================================================================================== 
; Parse html catalogue file 
;=========================================================================================================================================== 

ParseHtml: 

CompareFlag = 0 
  
numfound = 0 
  
file.s   = OpenFileRequester("Please Select the directory And file To parse", "", "*.*",0) 

If file.s = "" 
  Return 
EndIf 
    
ClearGadgetItemList(#Gadget_FlashGetCompare_htmllist) 
  
If OpenFile(0, file.s) <> 0 
  While Eof(0) = 0 
    ;------------------------------------------------------------------------------------------------------- 
    Temp.s = ReadString(0) 
    Pos    = FindString(Temp.s, "file://", 0) 
    
    If Pos <> 0 
      FilePos     = FindString(Temp.s, ">", Pos) 
      SubString.s = Mid(Temp.s, Pos + 7, FilePos - Pos - 8) 
      AddGadgetItem(#Gadget_FlashGetCompare_htmllist, - 1, SubString.s) 
      FlushEvents() 
      StatMess(2, "Ref(s) " + Str(numfound)) 
      SendMessage_(GadgetID(#Gadget_FlashGetCompare_htmllist), #LVM_ENSUREVISIBLE, numfound , 0) 
      numfound + 1 
    EndIf 
    ;------------------------------------------------------------------------------------------------------- 
  Wend 
Else 
  Return 
EndIf 
      
CloseFile(0) 
      
Return 

;=========================================================================================================================================== 
; Compare actual files with database entries, delete matching pairs from the lists 
;=========================================================================================================================================== 

CompareFiles: 

CompareFlag = 0 
  
Files = CountGadgetItems(#Gadget_FlashGetCompare_filelist) 
Lists = CountGadgetItems(#Gadget_FlashGetCompare_htmllist) 
  ;----------------------------------------------------------------------------------------------- 
If Files = 0 Or Lists = 0 
  Messages("Error", "No files in one or more lists to compare") 
  Return 
EndIf 
  ;----------------------------------------------------------------------------------------------- 
For ListLoop = 0 To Lists - 1 
  ListFile.s = GetGadgetItemText(#Gadget_FlashGetCompare_htmllist, ListLoop, 0) 
  SendMessage_(GadgetID(#Gadget_FlashGetCompare_htmllist), #LVM_ENSUREVISIBLE, ListLoop , 0) 
  Gosub LoopDiskFiles 
Next ListLoop 
  
CompareFlag = 1 
  
Return 

;=========================================================================================================================================== 
; Loop through disk filenames and delete matches from both lists 
;=========================================================================================================================================== 

LoopDiskFiles: 

For FilesLoop = 0 To Files - 1 
  diskfile.s = GetGadgetItemText(#Gadget_FlashGetCompare_filelist, FilesLoop, 0) 
  If diskfile.s = ListFile.s 
    RemoveGadgetItem(#Gadget_FlashGetCompare_htmllist, ListLoop) 
    FlushEvents() 
    StatMess(2, "Ref(s) " + Str(Lists)) 
    RemoveGadgetItem(#Gadget_FlashGetCompare_filelist, FilesLoop) 
    FlushEvents() 
    StatMess(1, "File(s) " + Str(Files)) 
    Files - 1 : FilesLoop - 1: Lists - 1 : ListLoop - 1 
  EndIf 
Next FilesLoop 
  
Return 

;=========================================================================================================================================== 
; Save the list of files in the catalogue pane to hard disk 
;=========================================================================================================================================== 

SaveDirectoryList: 

Files = CountGadgetItems(#Gadget_FlashGetCompare_filelist) 

If Files = 0 
  Messages("Error", "No files in the list to save!!") 
  Return 
EndIf 

DirFileName.s = SaveFileRequester("Directory Listing", "", "Text | *.txt", 0) 
  
If DirFileName.s = "" 
  Return 
EndIf 
  
If OpenFile(0, DirFileName.s) <> 0 
  For DirLoop = 0 To Files - 1 
    DirFile.s = GetGadgetItemText(#Gadget_FlashGetCompare_filelist, DirLoop, 0) 
    WriteStringN(0,DirFile.s) 
    SendMessage_(GadgetID(#Gadget_FlashGetCompare_htmllist), #LVM_ENSUREVISIBLE, DirLoop , 0) 
  Next DirLoop 
  WriteStringN(0,"End of listing") 
EndIf 

CloseFile(0) 

Messages("Finished", "Directory listing written to disk!!") 

Return 

;=========================================================================================================================================== 
; Move files that were unreferenced To somewhere Else 
;=========================================================================================================================================== 

MoveFiles: 

If CompareFlag = 0 
  Messages("Error", "No comparison done, cannot move entire filebase!!") 
  Return 
EndIf 
  
Files = CountGadgetItems(#Gadget_FlashGetCompare_filelist) 

If Files = 0 
  Messages("Error", "No files in the directory list to move!!") 
  Return 
EndIf 

MovePath.s = PathRequester("Move Un-Reference files to:", "") 
  
If MovePath.s = "" 
  Return 
EndIf 

For MoveLoop = 0 To Files -1 
  OriginalFile.s = GetGadgetItemText(#Gadget_FlashGetCompare_filelist, MoveLoop, 0) 
  OldFileName.s  = GetFilePart(OriginalFile.s) 
  NewPath.s = MovePath.s + OldFileName.s 
  StatMess(0, "Moving File: " + OriginalFile.s)    
  CopyFile(OriginalFile.s, NewPath.s) 
  DeleteFile(OriginalFile.s) 
  RemoveGadgetItem(#Gadget_FlashGetCompare_filelist, MoveLoop) 
  FlushEvents() 
  MoveLoop - 1  : Files - 1 
  NewPath.s = "" 
Next MoveLoop 
  
CompareFlag = 0 
  
Return 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = --
; EnableXP
