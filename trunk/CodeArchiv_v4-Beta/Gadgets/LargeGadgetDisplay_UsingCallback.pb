; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8678&highlight=
; Author: Fangbeast (small bug-fix by Danilo, changed including of image to creating a new one by Andre, updated for PB4.00 by blbltheworm)
; Date: 10. December 2003
; OS: Windows
; Demo: No


;================================================================================================== 
; Common variables, structures, globals and arrays 
;================================================================================================== 
Structure ColorGadgets 
  Gadget.l 
  FGColor.l 
  BGColor.l 
EndStructure 
;================================================================================================== 
; Date presentation structures 
;================================================================================================== 
Structure dateStructure 
  Year.w 
  Month.w 
  DayOfWeek.w 
  Day.w 
  Hour.w 
  Minute.w 
  Second.w 
  Milliseconds.w 
EndStructure 
;================================================================================================== 
; 
;================================================================================================== 
Global NewList Dir.s() 
Global NewList Files.s()                                            ; Linked List to hold RecentFiles 
Global NewList CG.ColorGadgets() 
;================================================================================================== 
; Setup names for numerical calendar 
;================================================================================================== 
Global Dim nameOfDay.s(7)                                          ; fill an array with the names of the days 
  nameOfDay(0) = "Sunday"     : nameOfDay(1) = "Monday"   : nameOfDay(2) = "Tuesday" 
  nameOfDay(3) = "Wednesday"  : nameOfDay(4) = "Thursday" : nameOfDay(5) = "Friday" 
  nameOfDay(6) = "Saturday" 
Global Dim daysPerMonth(12)                                       ; fill an array on how many days per month there are 
For x = 0 To 11      
  daysPerMonth(x) = 31 
Next 
  daysPerMonth(1)  = 28 : daysPerMonth(3)  = 30 : daysPerMonth(5)  = 30 : daysPerMonth(8)  = 30 
  daysPerMonth(10) = 30 
Global Dim nameOfMonth.s(12)                                    ; fill an array with the names of the months 
  nameOfMonth(0)  = "January"  :  nameOfMonth(1)  = "February"   :  nameOfMonth(2)  = "March" 
  nameOfMonth(3)  = "April"    :  nameOfMonth(4)  = "May"        :  nameOfMonth(5)  = "June" 
  nameOfMonth(6)  = "July"     :  nameOfMonth(7)  = "August"     :  nameOfMonth(8)  = "September" 
  nameOfMonth(9)  = "October"  :  nameOfMonth(10) = "November"   :  nameOfMonth(11) = "December" 
Global Dim years.s(7)                                           ; fill an array with the years 
  years(0) = "2002" : years(1) = "2003" : years(2) = "2004"  :  years(3) = "2005" 
  years(4) = "2006" : years(5) = "2007" : years(6) = "2008" 
;================================================================================================== 
; Dimension the number of fields in the status bar that we are going to resize in the callback 
;================================================================================================== 
Global Dim StatusBarFieldsBrowse.l(1) 
Global Dim StatusBarFieldsCollect.l(0) 
;================================================================================================== 
; Global variables 
;================================================================================================== 
Global ProgramVersion.s                                                             ; Program version 
Global MaxRangeBrowse.l, MaxDBrowse.l                                               ; Trackbar 
Global eHwndBrowse.l                                                                ; Editor gadget 
Global OriginalWidthBrowse.l, OriginalHeightBrowse.l                                ; Window dimensions 
Global OldStatusBarWidthBrowse.l, NewStatusBarWidthBrowse.l, hStatusBarBrowse.l     ; Status bar 
Global OriginalWidthCollect.l, OriginalHeightCollect.l                              ; Window dimensions 
Global OldStatusBarWidthCollect.l, NewStatusBarWidthCollect.l, hStatusBarCollect.l  ; Status bar 
Global ListGadgetCollect.l                                                          ; ListIconGadget 
Global FontRegCollect.l, FontBoldCollect.l                                          ; Fonts to use 
;================================================================================================== 
; String constants for program version and directory 
;================================================================================================== 
ProgramVersion                         = "FlashLogs v0.01 " 
;================================================================================================== 
FontRegCollect.l  = LoadFont(1, "Tahoma", 9) 
FontBoldCollect.l = LoadFont(2, "Tahoma", 9, #PB_Font_Bold) 
;================================================================================================== 
; All program constants 
;================================================================================================== 
#NM_CUSTOMDRAW          = #NM_FIRST - 12 
#CDDS_ITEM              = $10000 
#CDDS_SUBITEM           = $20000 
#CDDS_PREPAINT          = $1 
#CDDS_ITEMPREPAINT      = #CDDS_ITEM | #CDDS_PREPAINT 
#CDDS_SUBITEMPREPAINT   = #CDDS_SUBITEM | #CDDS_ITEMPREPAINT 
#CDRF_DODEFAULT         = $0 
#CDRF_NEWFONT           = $2 
#CDRF_NOTIFYITEMDRAW    = $20 
#CDRF_NOTIFYSUBITEMDRAW = $20 
;================================================================================================== 
Enumeration 
  #Window_browselogs 
  #Window_compilelogs 
  #Window_findlogs 
  #Window_editlog 
EndEnumeration 

#WindowIndex = #PB_Compiler_EnumerationValue 
;================================================================================================== 
Enumeration 
  #MenuBar_browselogs_copy          ; Window_browselogs 
  #MenuBar_browselogs_delete 
  #MenuBar_browselogs_edit 
  #MenuBar_browselogs_find 
  #MenuBar_browselogs_run 
  #MenuBar_browselogs_exit 
  #MenuBar_browselogs_collect 
  #MenuBar_browselogs_showhelp 
  #Gadget_browselogs_Mainframe 
  #Gadget_browselogs_Dirtree 
  #Gadget_browselogs_Filetree 
  #Gadget_browselogs_Filedescribe 
  #Gadget_browselogs_Fontlabel 
  #Gadget_browselogs_Describesize 
  #Gadget_browselogs_Splitter1      ; Splitter bars 
  #Gadget_browselogs_Splitter2 
  #Gadget_compilelogs_mainframe     ; Window_compilelogs 
  #Gadget_compilelogs_logbox 
  #Gadget_compilelogs_controlframe 
  #Gadget_compilelogs_setdir 
  #Gadget_compilelogs_dirbox 
  #Gadget_compilelogs_setfile 
  #Gadget_compilelogs_setbox 
  #Gadget_compilelogs_collect 
  #Gadget_compilelogs_save 
  #Gadget_findlogs_mainframe        ; Window_findlogs 
  #Gadget_findlogs_findlist 
  #Gadget_findlogs_controlframe 
  #Gadget_findlogs_searchbox 
  #Gadget_editlog_mainframe         ; Window_editlog 
  #Gadget_editlog_filename 
  #Gadget_editlog_status 
  #Gadget_editlog_category 
  #Gadget_editlog_filesize 
  #Gadget_editlog_description 
  #Gadget_editlog_filenamebox 
  #Gadget_editlog_statusbox 
  #Gadget_editlog_categorybox 
  #Gadget_editlog_filesizebox 
  #Gadget_editlog_descriptionbox 
  #Gadget_editlog_controlframe 
  #Gadget_editlog_clear 
  #Gadget_editlog_cancel 
  #Gadget_editlog_save 
EndEnumeration 

#GadgetIndex = #PB_Compiler_EnumerationValue 
;================================================================================================== 
Enumeration 
  #MenuBar_browselogs 
EndEnumeration 

#MenuBarIndex = #PB_Compiler_EnumerationValue 
;================================================================================================== 
Enumeration 
  #StatusBar_browselogs 
  #StatusBar_browselogs_info      = 0 
  #StatusBar_browselogs_files     = 1 
  #StatusBar_compilelogs 
  #StatusBar_compilelogs_messages = 0 
  #StatusBar_compilelogs_count    = 1 
EndEnumeration 

#StatusBarIndex = #PB_Compiler_EnumerationValue 
;================================================================================================== 
Enumeration 
  #Image_browselogs_Messageicon 
EndEnumeration 

#ImageIndex = #PB_Compiler_EnumerationValue 
;================================================================================================== 
; Most commonly used procedures 
;================================================================================================== 
Procedure ColorGadgets_Add(GadgetID.l, FGColor.l, BGColor.l) 
  ForEach CG() 
    If CG()\Gadget = GadgetID 
      DeleteElement(CG()) 
      Break 
    EndIf 
  Next 
  AddElement(CG()) 
  CG()\Gadget  = GadgetID 
  CG()\FGColor = FGColor 
  CG()\BGColor = BGColor 
EndProcedure 
;================================================================================================== 
Procedure BubbleTip2(bWindow.l, bGadget.l, bText.s) 
  ToolTipControl = CreateWindowEx_(0, "ToolTips_Class32", "", $D0000000|$40, 0, 0, 0, 0, WindowID(bWindow), 0, GetModuleHandle_(0), 0) 
  SendMessage_(ToolTipControl, 1044, 0, 0) 
  SendMessage_(ToolTipControl, 1043, $DFFFFF, 0) 
  SendMessage_(ToolTipControl, 1048, 0, 180) 
  Button.TOOLINFO\cbSize = SizeOf(TOOLINFO) 
  Button\uFlags   = $11 
  Button\hWnd     = GadgetID(bGadget) 
  Button\uId      = GadgetID(bGadget) 
  Button\lpszText = @bText 
  SendMessage_(ToolTipControl, $0404, 0, Button) 
EndProcedure 
;================================================================================================== 
; Shorten the amount of typing I have to do to the status bar 
;================================================================================================== 
Procedure Stat(gadget.l, field.l, message.s) 
  StatusBarText(gadget.l, field.l, message.s, 0) 
EndProcedure 
;================================================================================================== 
; Adds a suffix To the End of a <= 31 numeral 'date' 
;================================================================================================== 
Procedure.s AddDateSuffix(date.s) 
  If date = "1" Or date = "21" Or date = "31" 
    date = date + "st" 
  ElseIf date = "2" Or date = "22" 
    date = date + "nd" 
  ElseIf date = "3" Or date = "23" 
    date = date + "rd" 
  Else 
    date = date + "th" 
  EndIf 
  ProcedureReturn date 
EndProcedure 
;================================================================================================== 
; Sort out the date and display it to the called module 
;================================================================================================== 
Procedure SetDate(GadgetNumber.l, Module.s) 
  newDate.dateStructure 
  GetSystemTime_(@newDate) 
  weekDay.b = newDate\DayOfWeek 
  Day.b     = newDate\Day 
  Month.b   = newDate\Month 
  Year.w    = newDate\Year 
  currentdate.s = nameOfDay(weekDay) + ", " + AddDateSuffix(Str(Day)) + ", " + nameOfMonth(Month - 1) + ", " + Str(Year) 
  SetWindowText_(WindowID(GadgetNumber.l), Module.s + " -  " + currentdate.s) 
EndProcedure 
;================================================================================================== 
; We cant use threads with string for mostcases but this flushes events so forms respond properly 
;================================================================================================== 
Procedure FlushEvents() 
  While WindowEvent() 
  Wend 
EndProcedure 
;================================================================================================== 
Procedure WindowCallback(WindowID, message, wParam, lParam) 
  ReturnValue = #PB_ProcessPureBasicEvents 
  If message = #WM_CTLCOLORSTATIC Or message = #WM_CTLCOLOREDIT Or message = #WM_CTLCOLORLISTBOX 
    ForEach CG() 
      If GadgetID(CG()\Gadget) = lParam 
        SetTextColor_(wParam, CG()\FGColor) 
        SetBkMode_(wParam, #TRANSPARENT) 
        If CG()\BGColor = 0 
          SetBkColor_(wParam, GetSysColor_(#COLOR_BTNFACE)) 
          ReturnValue = CreateSolidBrush_(GetSysColor_(#COLOR_BTNFACE)) 
          Else 
          SetBkColor_(wParam, CG()\BGColor) 
          ReturnValue = CreateSolidBrush_(CG()\BGColor) 
        EndIf 
      EndIf 
    Next 
  EndIf 
  If WindowID = WindowID(#Window_browselogs) 
    ; Use the right window 
    If message = #WM_GETMINMAXINFO 
      result = 0 
      *ptr.MINMAXINFO       = lParam 
      *ptr\ptMinTrackSize\x = 640 + 8 
      *ptr\ptMinTrackSize\y = 480 + 14 + MenuHeight() 
    EndIf 
    If message = #WM_SIZE                                               ; Form's size has changed. 
      winwidth.l   = WindowWidth(#Window_browselogs)                                      ; Get the new width of the window 
      winheight.l  = WindowHeight(#Window_browselogs)                                     ; Get the new height of the window 
      widthchange  = winwidth  - OriginalWidthBrowse.l                  ; Get the width difference 
      heightchange = winheight - OriginalHeightBrowse.l                 ; Get the height difference 108,0,587,400 
      ResizeGadget(#Gadget_browselogs_Splitter1,#PB_Ignore,#PB_Ignore, 630 + widthchange, 391 + heightchange) 
      SetGadgetState(#Gadget_browselogs_Splitter1,   104) 
      ResizeGadget(#Gadget_browselogs_Mainframe,      0,    0               , 640 + widthchange, 435 + heightchange) 
      ResizeGadget(#Gadget_browselogs_Fontlabel,      10, 415 + heightchange,  50              ,  15               ) 
      ResizeGadget(#Gadget_browselogs_Describesize,  110, 410 + heightchange, 528 + widthchange,  20               ) 
      ; UpdateStatusBar(#StatusBar_browselogs) 
      NewStatusBarWidthBrowse.l = WindowWidth(#Window_browselogs)                                     ; Get new width 
      SendMessage_(hStatusBarBrowse.l, #SB_GETPARTS, 2, @StatusBarFieldsBrowse())   ; 2 is the number of Fields in the StatusBar 
      StatusBarFieldsBrowse(0) = StatusBarFieldsBrowse(0) + (NewStatusBarWidthBrowse.l - OldStatusBarWidthBrowse.l) 
      StatusBarFieldsBrowse(1) = NewStatusBarWidthBrowse.l-18  ; ADDED BY DANILO 
      SendMessage_(hStatusBarBrowse.l, #SB_SETPARTS, 2, @StatusBarFieldsBrowse())      
      OldStatusBarWidthBrowse.l = NewStatusBarWidthBrowse.l                           ; New Width will be old next time 
      RedrawWindow_(WindowID(#Window_browselogs), 0, 0, #RDW_INVALIDATE) 
    EndIf 
  EndIf 
  ProcedureReturn  ReturnValue 
EndProcedure 
;================================================================================================== 
; All program windows 
;================================================================================================== 
Procedure.l Window_browselogs() 
  If OpenWindow(#Window_browselogs,38,4,640,480,"Explore files",#PB_Window_SystemMenu|#PB_Window_MinimizeGadget|#PB_Window_MaximizeGadget|#PB_Window_SizeGadget|#PB_Window_ScreenCentered|#PB_Window_Invisible) 
    OriginalWidthBrowse.l     = WindowWidth(#Window_browselogs)  ; Original non-client width. 
    OriginalHeightBrowse.l    = WindowHeight(#Window_browselogs) ; Original non-client height. 
    OldStatusBarWidthBrowse.l = WindowWidth(#Window_browselogs)  ; Needed for resizing 
    CreateMenu(#MenuBar_browselogs,WindowID(#Window_browselogs)) 
      MenuTitle("Files") 
      MenuItem(#MenuBar_browselogs_copy,"Copy file") 
      MenuItem(#MenuBar_browselogs_delete,"Delete file") 
      MenuItem(#MenuBar_browselogs_edit,"Edit log") 
      MenuItem(#MenuBar_browselogs_find,"Find files") 
      MenuItem(#MenuBar_browselogs_run,"Run file") 
      MenuBar() 
      MenuItem(#MenuBar_browselogs_exit,"Exit") 
      MenuTitle("Jobs") 
      MenuItem(#MenuBar_browselogs_collect,"Collect log files") 
      MenuTitle("Help") 
      MenuItem(#MenuBar_browselogs_showhelp,"Help") 
    If CreateGadgetList(WindowID(#Window_browselogs)) 
      Frame3DGadget(#Gadget_browselogs_Mainframe,0,0,640,435,"") 
      ExplorerTreeGadget(#Gadget_browselogs_Dirtree,5,10,145,420,"",#PB_Explorer_AlwaysShowSelection|#PB_Explorer_NoFiles|#PB_Explorer_NoDriveRequester) 
        SendMessage_(GadgetID(#Gadget_browselogs_Dirtree),$111D,0,11927021) 
        BubbleTip2(#Window_browselogs,#Gadget_browselogs_Dirtree,"This is where all drives and directories present on your entire system will be displayed") 
      ExplorerListGadget(#Gadget_browselogs_Filetree,155,10,480,185,"*.log",#PB_Explorer_AlwaysShowSelection|#PB_Explorer_GridLines|#PB_Explorer_FullRowSelect|#PB_Explorer_NoFolders|#PB_Explorer_NoParentFolder|#PB_Explorer_NoDirectoryChange|#PB_Explorer_NoDriveRequester|#PB_Explorer_NoMyDocuments) 
        SendMessage_(GadgetID(#Gadget_browselogs_Filetree),#LVM_SETBKCOLOR,0,16439038) 
        SendMessage_(GadgetID(#Gadget_browselogs_Filetree),#LVM_SETTEXTBKCOLOR,0,16439038) 
        BubbleTip2(#Window_browselogs,#Gadget_browselogs_Filetree,"When you click a drive or directory, all or any files in there will be displayed here") 
      eHwndBrowse.l = EditorGadget(#Gadget_browselogs_Filedescribe,155,200,480,205) 
        SendMessage_(GadgetID(#Gadget_browselogs_Filedescribe), #EM_SETTARGETDEVICE, #Null, 0) 
        SendMessage_(GadgetID(#Gadget_browselogs_Filedescribe),#EM_SETBKGNDCOLOR,0,16698567) 
        ;SendMessage_(GadgetID(#Gadget_browselogs_Filedescribe), #EM_SETTARGETDEVICE, #NULL, $FFFFFF) ; Reset the wrapping 
        SendMessage_(GadgetID(#Gadget_browselogs_Filedescribe),#EM_SETBKGNDCOLOR,0,16710859) 
      TextGadget(#Gadget_browselogs_Fontlabel,10,415,50,15,"Font size") 
        MaxRangeBrowse.l = 100 
        MaxDBrowse.l     = MaxRangeBrowse.l / 64 + 1 
      TrackBarGadget(#Gadget_browselogs_Describesize,110,410,528,20,0,MaxRangeBrowse.l,#PB_TrackBar_Ticks) 
        BubbleTip2(#Window_browselogs,#Gadget_browselogs_Describesize,"To change the size of the font in the description box, move this slider bar left or right") 
      hStatusBarBrowse.l = CreateStatusBar(#StatusBar_browselogs,WindowID(#Window_browselogs)) 
        AddStatusBarField(502) 
        AddStatusBarField(120) 
        StatusBarIcon(#StatusBar_browselogs, 0, CreateImage(#Image_browselogs_Messageicon,16,16)) ; CatchImage(#Image_browselogs_Messageicon,?Messageicon)) 
      SplitterGadget(#Gadget_browselogs_Splitter2, 155,0,162,400, #Gadget_browselogs_Filetree,#Gadget_browselogs_Filedescribe, #PB_Splitter_Separator) 
      SetGadgetState(#Gadget_browselogs_Splitter2, 178) 
      SplitterGadget(#Gadget_browselogs_Splitter1, 4, 11,630,391, #Gadget_browselogs_Dirtree, #Gadget_browselogs_Splitter2, #PB_Splitter_Vertical|#PB_Splitter_Separator) 
      SetGadgetState(#Gadget_browselogs_Splitter1, 104) 
      FlushEvents() 
      HideWindow(#Window_browselogs,0) 
      ProcedureReturn WindowID(#Window_browselogs) 
    EndIf 
  EndIf 
EndProcedure 
;================================================================================================== 
Procedure.l Window_compilelogs() 
  If OpenWindow(#Window_compilelogs,0,0,750,480,"Collect logs",#PB_Window_SystemMenu|#PB_Window_MinimizeGadget|#PB_Window_MaximizeGadget|#PB_Window_ScreenCentered|#PB_Window_Invisible) 
    OriginalWidthCollect.l     = WindowWidth(#Window_compilelogs)  ; Original non-client width. 
    OriginalHeightCollect.l    = WindowHeight(#Window_compilelogs) ; Original non-client height. 
    OldStatusBarWidthCollect.l = WindowWidth(#Window_compilelogs)  ; Needed for resizing 
    If CreateGadgetList(WindowID(#Window_compilelogs)) 
      Frame3DGadget(#Gadget_compilelogs_mainframe,0,0,750,385,"") 
      ListGadgetCollect.l = ListIconGadget(#Gadget_compilelogs_logbox,5,10,740,370,"Filename",100,#PB_ListIcon_GridLines|#PB_ListIcon_FullRowSelect|#PB_ListIcon_AlwaysShowSelection) 
        SendMessage_(GadgetID(#Gadget_compilelogs_logbox),#LVM_SETBKCOLOR,0,16770764) 
        SendMessage_(GadgetID(#Gadget_compilelogs_logbox),#LVM_SETTEXTBKCOLOR,0,16770764) 
        AddGadgetColumn(#Gadget_compilelogs_logbox,1,"Status",70) 
        AddGadgetColumn(#Gadget_compilelogs_logbox,2,"Category",100) 
        AddGadgetColumn(#Gadget_compilelogs_logbox,3,"Size",60) 
        AddGadgetColumn(#Gadget_compilelogs_logbox,4,"Description",600) 
        BubbleTip2(#Window_compilelogs,#Gadget_compilelogs_logbox,"This is where all the collected log files will be displayed with all extracted details about them") 
      Frame3DGadget(#Gadget_compilelogs_controlframe,0,385,750,70,"") 
      ButtonGadget(#Gadget_compilelogs_setdir,5,400,100,20,"Directory") 
        BubbleTip2(#Window_compilelogs,#Gadget_compilelogs_setdir,"Press this button to set the directory where you will start the log collection process") 
      TextGadget(#Gadget_compilelogs_dirbox,110,405,570,15,"",#PB_Text_Border) 
        ColorGadgets_Add(#Gadget_compilelogs_dirbox,0,13041308) 
      ButtonGadget(#Gadget_compilelogs_setfile,5,425,100,20,"Save to") 
        BubbleTip2(#Window_compilelogs,#Gadget_compilelogs_setfile,"Press this button to set the name and directory of the file you are going to save to") 
      TextGadget(#Gadget_compilelogs_setbox,110,430,570,15,"",#PB_Text_Border) 
        ColorGadgets_Add(#Gadget_compilelogs_setbox,0,13041308) 
      ButtonGadget(#Gadget_compilelogs_collect,685,400,60,20,"Collect!") 
        BubbleTip2(#Window_compilelogs,#Gadget_compilelogs_collect,"Press this button to start collecting the log files and displaying them in the window") 
      ButtonGadget(#Gadget_compilelogs_save,685,425,60,20,"Save") 
        BubbleTip2(#Window_compilelogs,#Gadget_compilelogs_save,"Press this button to save the contents of the window to a file") 
      hStatusBarCollect.l = CreateStatusBar(#StatusBar_compilelogs,WindowID(#Window_compilelogs)) 
        AddStatusBarField(630) 
        AddStatusBarField(120) 
      HideWindow(#Window_compilelogs,0) 
      ProcedureReturn WindowID(#Window_compilelogs) 
    EndIf 
  EndIf 
EndProcedure 
;================================================================================================== 
Procedure.l Window_findlogs() 
  If OpenWindow(#Window_findlogs,0,0,640,480,"Find files",#PB_Window_SystemMenu|#PB_Window_MinimizeGadget|#PB_Window_MaximizeGadget|#PB_Window_SizeGadget|#PB_Window_ScreenCentered|#PB_Window_Invisible) 
    If CreateGadgetList(WindowID(#Window_findlogs)) 
      Frame3DGadget(#Gadget_findlogs_mainframe,0,0,640,435,"") 
      ListIconGadget(#Gadget_findlogs_findlist,5,10,630,420,"Filename",100,#PB_ListIcon_GridLines|#PB_ListIcon_FullRowSelect|#PB_ListIcon_AlwaysShowSelection) 
        SendMessage_(GadgetID(#Gadget_findlogs_findlist),#LVM_SETBKCOLOR,0,16694196) 
        SendMessage_(GadgetID(#Gadget_findlogs_findlist),#LVM_SETTEXTBKCOLOR,0,16694196) 
        AddGadgetColumn(#Gadget_findlogs_findlist,1,"Status",70) 
        AddGadgetColumn(#Gadget_findlogs_findlist,2,"Category",100) 
        AddGadgetColumn(#Gadget_findlogs_findlist,3,"Size",60) 
        AddGadgetColumn(#Gadget_findlogs_findlist,4,"Description",600) 
        BubbleTip2(#Window_findlogs,#Gadget_findlogs_findlist,"This is where all files matching the search string will be displayed") 
      Frame3DGadget(#Gadget_findlogs_controlframe,0,435,640,45,"Search text") 
      StringGadget(#Gadget_findlogs_searchbox,5,450,630,20,"") 
        ColorGadgets_Add(#Gadget_findlogs_searchbox,0,33023) 
        BubbleTip2(#Window_findlogs,#Gadget_findlogs_searchbox,"Type in the search string the you are looking for and then press your Enter / Return button") 
      HideWindow(#Window_findlogs,0) 
      ProcedureReturn WindowID(#Window_findlogs) 
    EndIf 
  EndIf 
EndProcedure 
;================================================================================================== 
Procedure.l Window_editlog() 
  If OpenWindow(#Window_editlog,182,39,480,350,"Edit logs",#PB_Window_SystemMenu|#PB_Window_MinimizeGadget|#PB_Window_MaximizeGadget|#PB_Window_SizeGadget|#PB_Window_ScreenCentered|#PB_Window_Invisible) 
    Brush.LOGBRUSH\lbColor=9167612 
    SetClassLong_(WindowID(#Window_editlog),#GCL_HBRBACKGROUND,CreateBrushIndirect_(Brush)) 
    If CreateGadgetList(WindowID(#Window_editlog)) 
      Frame3DGadget(#Gadget_editlog_mainframe,0,0,480,305,"") 
      TextGadget(#Gadget_editlog_filename,10,15,60,15,"Filename") 
        ColorGadgets_Add(#Gadget_editlog_filename,0,9167612) 
      TextGadget(#Gadget_editlog_status,10,40,60,15,"Status") 
        ColorGadgets_Add(#Gadget_editlog_status,0,9167612) 
      TextGadget(#Gadget_editlog_category,10,65,60,15,"Category") 
        ColorGadgets_Add(#Gadget_editlog_category,0,9167612) 
      TextGadget(#Gadget_editlog_filesize,10,90,60,15,"Size") 
        ColorGadgets_Add(#Gadget_editlog_filesize,0,9167612) 
      TextGadget(#Gadget_editlog_description,10,115,60,15,"Description") 
        ColorGadgets_Add(#Gadget_editlog_description,0,9167612) 
      StringGadget(#Gadget_editlog_filenamebox,70,10,405,20,"",#PB_String_ReadOnly) 
        ColorGadgets_Add(#Gadget_editlog_filenamebox,0,16627362) 
      StringGadget(#Gadget_editlog_statusbox,70,35,405,20,"",#PB_String_ReadOnly) 
        ColorGadgets_Add(#Gadget_editlog_statusbox,0,16627362) 
      StringGadget(#Gadget_editlog_categorybox,70,60,405,20,"",#PB_String_ReadOnly) 
        ColorGadgets_Add(#Gadget_editlog_categorybox,0,16627362) 
      StringGadget(#Gadget_editlog_filesizebox,70,85,405,20,"",#PB_String_ReadOnly) 
        ColorGadgets_Add(#Gadget_editlog_filesizebox,0,16627362) 
      EditorGadget(#Gadget_editlog_descriptionbox,70,110,405,190) 
        SendMessage_(GadgetID(#Gadget_editlog_descriptionbox),#EM_SETBKGNDCOLOR,0,10418379) 
      Frame3DGadget(#Gadget_editlog_controlframe,0,305,480,45,"") 
      ButtonGadget(#Gadget_editlog_clear,5,320,60,20,"Clear") 
      ButtonGadget(#Gadget_editlog_cancel,65,320,60,20,"Cancel") 
      ButtonGadget(#Gadget_editlog_save,125,320,60,20,"Save") 
      HideWindow(#Window_editlog,0) 
      ProcedureReturn WindowID(#Window_editlog) 
    EndIf 
  EndIf 
EndProcedure 
;================================================================================================== 
; Start of the program code, event handling 
;================================================================================================== 
If Window_browselogs() 
  SetActiveWindow(#Window_browselogs)                                           ; Make sure window is in the foreground and ready 
  SetDate(#Window_browselogs, ProgramVersion)                ; Set the date and program version to the main window 
  SetWindowCallback(@WindowCallback()) 
  Quitbrowselogs = 0 
  Repeat 
    EventID = WaitWindowEvent() 
    Select EventID 
      Case #PB_Event_CloseWindow 
        If EventWindow() = #Window_browselogs 
          Quitbrowselogs = 1 
        EndIf 
      Case #PB_Event_Menu 
        Select EventMenu() 
          Case #MenuBar_browselogs_copy         : 
          Case #MenuBar_browselogs_delete       : 
          Case #MenuBar_browselogs_edit         : 
          Case #MenuBar_browselogs_find         : 
          Case #MenuBar_browselogs_run          : 
          Case #MenuBar_browselogs_exit         : 
          Case #MenuBar_browselogs_collect      : 
          Case #MenuBar_browselogs_showhelp     : 
        EndSelect 
      Case #PB_Event_Gadget 
        Select EventGadget() 
          Case #Gadget_browselogs_Dirtree       : Gosub setfiletree 
          Case #Gadget_browselogs_Filetree      : Gosub openfile 
          Case #Gadget_browselogs_Filedescribe 
          Case #Gadget_browselogs_Describesize  : MessageFlag = 1 :  Gosub setfontsize 
        EndSelect 
    EndSelect 
  Until Quitbrowselogs 
  CloseWindow(#Window_browselogs) 
EndIf 
End 
;================================================================================================== 
; Set the log file window from tree item clicked 
;================================================================================================== 
setfiletree: 
  Stat(#StatusBar_browselogs, #StatusBar_browselogs_info, "Setting log files into log file window") 
  FlushEvents()                                                                                 ; Flush window events before loading gadget, makes 'grey time' shorter 
  SetGadgetText(#Gadget_browselogs_Filedescribe, "")                                            ; Zero the decription box 
  SetGadgetText(#Gadget_browselogs_Filetree, GetGadgetText(#Gadget_browselogs_Dirtree))         ; Set files from dir tree 
  SendMessage_(GadgetID(#Gadget_browselogs_Filetree), #LVM_SETCOLUMNWIDTH, 0, #LVSCW_AUTOSIZE)  ; Autosize filename field 
Return 
;================================================================================================== 
; Open a FlashGet .log file 
;================================================================================================== 
openfile: 
  If EventType() = #PB_EventType_Change 
    Stat(#StatusBar_browselogs, #StatusBar_browselogs_info, "Processing file description") 
    LogFile.s = GetGadgetText(#Gadget_browselogs_Filetree) + GetGadgetItemText(#Gadget_browselogs_Filetree, GetGadgetState(#Gadget_browselogs_Filetree), 0) 
    LogDir.s  = GetPathPart(LogFile.s) 
    If ReadFile(0, LogFile)                 ; Can log file be opened 
      If Lof(0) > 0                          ; Is log file larger than 0 
        DiskFile.s  = ReadString(0)  : DiskFile.s  = Right(DiskFile.s, Len(DiskFile.s) - 5) :  Gosub checkdiskfile 
        Url.s       = ReadString(0)  : Url.s       = Right(Url.s,      Len(Url.s)      - 4) 
        Size.s      = ReadString(0)  : Size.s      = Right(Size.s,     Len(Size.s)     - 5) 
        Time.s      = ReadString(0)  : Time.s      = Right(Time.s,     Len(Time.s)     - 14) 
        Refer.s     = ReadString(0)  : Refer.s     = Right(Refer.s,    Len(Refer.s)    - 8) 
        Cmt.s       = ReadString(0)  : Cmt.s       = Right(Cmt.s,      Len(Cmt.s)      - 8) 
        SetGadgetText(#Gadget_browselogs_Filedescribe, Cmt.s) 
        While Eof(0) = 0                   ; Process till the end of the file 
          AddGadgetItem(#Gadget_browselogs_Filedescribe, -1, ReadString(0)) 
        Wend 
        Gosub setfontsize 
      Else 
        Return 
      EndIf 
    Else 
      Return 
    EndIf 
  EndIf    
Return 
;================================================================================================== 
; Check if the disk file exists 
;================================================================================================== 
checkdiskfile: 
  DiskFileSize.l = FileSize(LogDir.s + DiskFile.s) 
  Stat(#StatusBar_browselogs, #StatusBar_browselogs_info, "Checking to see if physical disk file exists and is okay") 
  Select DiskFileSize 
    Case -1 
      Stat(#StatusBar_browselogs, #StatusBar_browselogs_info, "Disk File [ " + DiskFile.s + " ]" + " seems To be missing") 
    Case 0 
      Stat(#StatusBar_browselogs, #StatusBar_browselogs_info, "Disk File [ " + DiskFile.s + " ]" + " seems to be truncated") 
    Default 
      Stat(#StatusBar_browselogs, #StatusBar_browselogs_info, "Disk File [ " + DiskFile.s + " ]" + " seems to be okay") 
  EndSelect 
Return 
;================================================================================================== 
; Set the font size in the description box 
;================================================================================================== 
setfontsize: 
  If MessageFlag = 1 
    Stat(#StatusBar_browselogs, #StatusBar_browselogs_info, "Setting description box font size") 
    MessageFlag = 0 
  EndIf 
  Value = GetGadgetState(#Gadget_browselogs_Describesize) ; Get the current value of the slider 
  lRet  = SendMessage_(eHwndBrowse, #EM_SETZOOM, Value, MaxDBrowse)   ; Set the zoom size in the text window 
Return 
;================================================================================================== 
; All reusable data 
;================================================================================================== 
DataSection 
  HelpStart: 
  Data.s "                 Program Elements" 
  Data.s "=====================================================" 
  Data.s "" 
  Data.s "Top Left window.         Drive and DIRectory tree" 
  Data.s "Top Right Window:        Log file list" 
  Data.s "Bottom Right Window:     File description box" 
  Data.s "" 
  Data.s "Slider Bar:              Change the size of the font" 
  Data.s "                         Shown in the description box" 
  Data.s "" 
  Data.s "" 
  Data.s "" 
  Data.s "" 
  Data.s "" 
  Data.s "" 
  Data.s "" 
  Data.s "" 
  Data.s "" 
  Data.s "" 
  Data.s "" 
  Data.s "" 
  Data.s "" 
  Data.s "" 
  Data.s "" 
  Data.s "" 
  Data.s "" 
  Data.s "" 
  Data.s "" 
  Data.s "" 
  Data.s "" 
  Data.s "" 
  Data.s "" 
  Data.s "" 
  Data.s "" 
  Data.s "" 
  Data.s "" 
  Data.s "" 
  Data.s "" 
  Data.s "" 
  HelpEnd: 
;  Messageicon:  IncludeBinary "C:\Development\My Code\Browselogs\Messages.ico" 
EndDataSection 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = --
; EnableXP
