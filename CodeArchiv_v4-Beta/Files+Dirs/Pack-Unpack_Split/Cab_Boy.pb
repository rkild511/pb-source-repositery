; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7896&highlight=
; Author: Fangbeast (updated for PB4.00 by blbltheworm)
; Date: 14. October 2003
; OS: Windows
; Demo: No

; Function: "Cab _boy. Make your own cabs ()"
; Requirements: cab10.dll (e.g. at: http://oregonstate.edu/~reeset/html/other/programs/cab10.dll)
;               

;=========================================================================================================================== 
; Copyright to Fangbeast(c) 2003 :):) The CAB procedures (function enumerations), DLL handling and examples were the product 
; of P.Leischow, everything else is mine, Mine, MIne, MINe, MINE I tell you!! (Okay, I'll take a pill and calm down) 
; 
; Okay, I just did this clean code to help anyone else who; like me; has been needing CAB decompression for the last year 
; and a half. I have been asking for ages and no-one seemed to take it seriously, even though the industry at large STILL 
; use CABinet compression and decompression in a great many products. And, until P Leischow came out with his initial CAB 
; decompression routine, I was totally lost. Then he kindly mailed me some even more useful routine to deCAB files as well. 
; 
; I must also seriously thank Rings for getting me started on this. In his limited amount of time, he gave me some trial 
; compression code to get me started on the idea. There are some really nice programmers in the forum and Rings is one of 
; them. 
; 
; This little program is a proof-of-concept for something I needed in my main software (that I had been writing and 
; re-writing for the better part of two years and I wanted everyone else to have it because by itself it is also terribly 
; useful Well, to some people anyway, 
; 
; Simply put, you can create your own ms format CABinet archives and add single files, multiple files or whole directories 
; to it. At this point however, there is no path information stored in the archive (I didn't need that feature initially) 
; but I am hoping for the sake of extended functionality that this will come. The way I lay out code, most experienced code 
; whackers will have no trouble working this out. It's neat, tidy and works. Some nice features like form and object 
; resizing, blinking progress mode, error messages, cute tooltip and single task locking etc. Have fun with it, do what you 
; Like with it but remember to thank the authors please. 
; 
; You will need cab10.dll and I'll find somewhere to post it or ask me to email it to you. 
; 
;=========================================================================================================================== 
; All program constants 
;=========================================================================================================================== 

#DLL                              = 0 ; CAB dll variable for library functions 

Enumeration                      ; Window Constants 
  #Window_cabboy 
EndEnumeration 

#WindowIndex                      = #PB_Compiler_EnumerationValue 

Enumeration                      ; Gadget Constants 
  #Gadget_cabboy_Main_Frame       ; Main window frame 
  #Gadget_cabboy_Cab_Name_Label   ; Label for cab file name 
  #Gadget_cabboy_Cab_Name         ; CAB file name box 
  #Gadget_cabboy_Set_Pack_Name    ; Button to get CAB file name 
  #Gadget_cabboy_List_Frame       ; List box frame 
  #Gadget_cabboy_List_Members     ; List of filenames to pack 
  #Gadget_cabboy_Control_Frame    ; Frame for control buttons 
  #Gadget_cabboy_Add_Files        ; Button to get files to pack 
  #Gadget_cabboy_Add_Directories  ; Add directories 
  #Gadget_cabboy_Make_Cab_File    ; Button to make the CAB file 
  #Gadget_cabboy_Exit_Program     ; Button to exit the program 
  #Gadget_cabboy_Status_Box       ; Status messages box 
EndEnumeration 

#GadgetIndex                      = #PB_Compiler_EnumerationValue 

;=========================================================================================================================== 
; Need a list to hold enumerated cab members in (for decompress functions) 
;=========================================================================================================================== 

Global NewList CabFileList.s() 
Global NewList DirEntries.s() 

;=========================================================================================================================== 
; Setup more readable and typable library functions 
;=========================================================================================================================== 

If OpenLibrary(#DLL,"cab10.dll") 
  CabAbout                  =GetFunction(#DLL,"CABABOUT") 
  CabCompressInitialize     =GetFunction(#DLL,"CABCOMPRESSINITIALIZE") 
  CabDecompressInitialize   =GetFunction(#DLL,"CABDECOMPRESSINITIALIZE") 
  CabCreate                 =GetFunction(#DLL,"CABCREATE") 
  CabAddFile                =GetFunction(#DLL,"CABADDFILE") 
  CabClose                  =GetFunction(#DLL,"CABCLOSE") 
  CabEnum                   =GetFunction(#DLL,"CABENUM") 
  CabExtract                =GetFunction(#DLL,"CABEXTRACT") 
  CabCompressTerminate      =GetFunction(#DLL,"CABCOMPRESSTERMINATE") 
  CabDecompressTerminate    =GetFunction(#DLL,"CABDECOMPRESSTERMINATE")  
  Else 
  MessageRequester("Error","Could Not Load DLL",#MB_ICONERROR) 
  End 
EndIf 

;=========================================================================================================================== 
; Get the current working directory for later functions (may or may not use it) 
;=========================================================================================================================== 

CurrentDirectory.s = Space(256) 

GetCurrentDirectory_(Len(CurrentDirectory.s), @CurrentDirectory) 

If Right(CurrentDirectory.s, 1) <> "\" 
  CurrentDirectory.s + "\" 
EndIf 

;=========================================================================================================================== 
; Set the global program version number 
;=========================================================================================================================== 

Global ProgramVersion.s =  "CAB Boy" 

;=========================================================================================================================== 
; Any global variables we need 
;=========================================================================================================================== 

Global OriginalWidth, OriginalHeight, ProcMutex, TimerTicks.l

;=========================================================================================================================== 
; Any needed procedural declarations (Hope I got them in the right order) 
;=========================================================================================================================== 

Declare.l Window_cabboy() 
Declare   Resize_Callback(WindowID, Message, wParam, lParam) 
Declare   Tool_Tip(Handle, Text.s)                                 ; Windows API routine for fancy bubble tooltip 
Declare   Blink_Message()                                          ; Timer working messae for any long event 
Declare   Reset_Title()                                            ; Blink a message on and off, one second apart 
Declare   Status_Message(Message.s)                                ; Shorten typing for message strings 

Declare.s CabAbout()                                               ; Paul Leischow's CABinet compress/decompress routines 
Declare.l CabDecompressInitialize() 
Declare.l CabEnum(Source.s) 
Declare.l CabExtract(Source.s, Destination.s) 
Declare.l CabDecompressTerminate() 
Declare.l CabCompressInitialize() 
Declare.l CabCreate(Destination.s) 
Declare.l CabAddFile(hCab, Source.s, Destination.s) 
Declare.l CabClose(hCab.l) 
Declare.l CabCompressTerminate() 

;=========================================================================================================================== 
; Main program event handler 
;=========================================================================================================================== 

If Window_cabboy()                                                      ; Main Loop 

  If CreateFile(0, CurrentDirectory.s + "cab10.dll")                    ; Write the cab dll to the current directory 
    WriteData(0,?CabDll, ?EndCab - ?CabDll) 
    CloseFile(0) 
  EndIf 

  SetWindowCallback(@Resize_Callback())                                 ; Screen and object resizing 

  QuitCabBoy = 0 
  Repeat 
    EventID = WaitWindowEvent() 
    Select EventID 
      Case #PB_Event_CloseWindow 
        If EventWindow() = #Window_cabboy 
          QuitCabBoy = 1 
        EndIf 
      Case #PB_Event_Gadget 
        Select EventGadget() 
          Case #Gadget_cabboy_Set_Pack_Name       : Gosub Set_Pack_Name ; Setup the name of the CABinet file and display it to the user 
          ;---------------------------------------------------------------------------------------- 
          Case #Gadget_cabboy_List_Members                              ; Select event happening on list gadget 
            Select EventType() 
              Case #PB_EventType_LeftDoubleClick  : Gosub Remove_File   ; Remove a file from the list 
              Case #PB_EventType_RightDoubleClick : Gosub Test_Clear 
              Case #PB_EventType_RightClick       : 
              Default 
            EndSelect 
            ;-------------------------------------------------------------------------------------- 
          Case #Gadget_cabboy_Add_Files           : Gosub Add_Pack_Files  ; Add files to the list that we pack from 
          Case #Gadget_cabboy_Add_Directories     : Gosub Add_Pack_Directories 
          Case #Gadget_cabboy_Make_Cab_File       : Gosub Compress_Files 
          Case #Gadget_cabboy_Exit_Program        : QuitCabBoy = 1 
        EndSelect 
    EndSelect 
  Until QuitCabBoy 
  CloseWindow(#Window_cabboy) 
EndIf 
CloseLibrary(#DLL)                                                          ; Free up library resource 
; If DeleteFile(CurrentDirectory.s + "cab10.dll")                             ; Delete the included cab dll 
; EndIf 
End 

;=========================================================================================================================== 
; Clear the list of members if no other process is running and user selected this option 
;=========================================================================================================================== 

Test_Clear: 

  If ProcMutex = 1 
    Return 
  Else 
    ProcMutex = 1 
    ClearGadgetItemList(#Gadget_cabboy_List_Members) 
  EndIf 
  
  ProcMutex = 0 
  
Return 

;=========================================================================================================================== 
; Remove a file from the list when it has been single clicked 
;=========================================================================================================================== 

Remove_File: 

  If ProcMutex = 1 
    Return 
  Else 
    ProcMutex = 1 
    Current_Line = GetGadgetState(#Gadget_cabboy_List_Members) 
    If Current_Line <> -1 
      RemoveGadgetItem(#Gadget_cabboy_List_Members, Current_Line) 
      Status_Message("Current item has been deleted!!") 
    EndIf 
  EndIf 
  
  ProcMutex = 0 
  
Return 

;=========================================================================================================================== 
; Add selected directories to the list for compression 
;=========================================================================================================================== 

Add_Pack_Directories: 

  If ProcMutex = 1 
    Return 
  Else 
    SetTimer_(WindowID(#Window_cabboy),0, 1000, @Blink_Message()) 
    ProcMutex = 1 
    ClearList(DirEntries.s()) 
    AddDirectoryName.s = PathRequester("Add DIRectories", "") 
    If AddDirectoryName.s 
      If Right(AddDirectoryName.s, 1) = "\" 
        AddDirectoryName.s = Left(AddDirectoryName.s, Len(AddDirectoryName.s) - 1) 
      EndIf 
      AddElement(DirEntries()) 
      DirEntries() = AddDirectoryName.s 
      Index = 0 
      Repeat 
        SelectElement(DirEntries(), Index) 
        If ExamineDirectory(0, DirEntries(), "*.*") 
          Path.s = DirEntries() + "\" 
          Quit = 0 
          Repeat 
            NextFile = NextDirectoryEntry(0) 
            FileName.s = DirectoryEntryName(0) 
            Select NextFile 
              Case 0 
                Quit = 1 
              Case 1 
                DiskFile.s = Path + FileName.s 
                AddGadgetItem(#Gadget_cabboy_List_Members, - 1, DiskFile.s) 
                While WindowEvent() 
                Wend 
              Case 2 
                FileName.s = DirectoryEntryName(0) 
                If FileName.s <> ".." And FileName.s <> "." 
                  AddElement(DirEntries()) 
                  DirEntries() = Path + FileName.s 
                EndIf 
            EndSelect  
          Until Quit = 1 
        EndIf 
        Index + 1 
      Until Index > CountList(DirEntries()) -1 
    Else 
      Status_Message("Cancelled by user, no DIRectories to add") 
    EndIf 
  EndIf 
  
  ProcMutex = 0 
  
  KillTimer_(WindowID(#Window_cabboy),0)  

  Reset_Title() 
    
Return 

;=========================================================================================================================== 
; Add selected files to the list for compression 
;=========================================================================================================================== 

Add_Pack_Files: 

  If ProcMutex = 1 
    Return 
  Else 
    SetTimer_(WindowID(#Window_cabboy),0, 1000, @Blink_Message())  
    ProcMutex = 1 
    AddFileName.s = OpenFileRequester("Add files", "", "All files | *.*", 0, #PB_Requester_MultiSelection) 
    If AddFileName.s 
      AddGadgetItem(#Gadget_cabboy_List_Members, -1, AddFileName.s) 
        Repeat 
        AddFileName.s = NextSelectedFileName() 
          If AddFileName.s 
            AddGadgetItem(#Gadget_cabboy_List_Members, -1, AddFileName.s) 
          EndIf 
        Until AddFileName.s = "" 
    Else 
      Status_Message("Cancelled by user, no files to add") 
    EndIf 
  EndIf 

  ProcMutex = 0 
  
  KillTimer_(WindowID(#Window_cabboy),0) 
  
  Reset_Title() 
  
Return 

;=========================================================================================================================== 
; Set the name of the cab file to create and give error if cancelled 
;=========================================================================================================================== 

Set_Pack_Name: 

  If ProcMutex = 1 
    Return 
  Else 
    ProcMutex = 1 
    CabFileName.s = SaveFileRequester("CABinet file name", "CABBoy.CAB", "*.cab", 0) 
    If CabFileName.s = "" 
      Status_Message("Cancelled by user, no output filename specified") 
    Else 
      SetGadgetText(#Gadget_cabboy_Cab_Name, CabFileName.s) 
    EndIf 
  EndIf 
  
  ProcMutex = 0 
  
Return 

;=========================================================================================================================== 
; Compress files into the selected CABinet file now 
;=========================================================================================================================== 

Compress_Files: 

  If ProcMutex = 1 
    Return 
  Else 
    SetTimer_(WindowID(#Window_cabboy),0, 1000, @Blink_Message())
    ProcMutex = 1 
    If CabCompressInitialize() 
      SetGadgetText(#Gadget_cabboy_Status_Box, "Creating " + CabFileName.s) 
      CabFileName.s = GetGadgetText(#Gadget_cabboy_Cab_Name) 
      FilesToPack   = CountGadgetItems(#Gadget_cabboy_List_Members) 
      hCabFile = CabCreate(CabFileName.s) 
      If hCabFile 
        Result = 0 
        For PackStart = 0 To FilesToPack - 1 
          CurrentFileName.s = GetGadgetItemText(#Gadget_cabboy_List_Members, PackStart, 0):Debug CurrentFileName.s 
          Result + CabAddFile(hCabFile, CurrentFileName.s, CurrentFileName.s) 
        Next PackStart 
        If Result 
          CabClose(hCabFile) 
        Else 
          Status_Message("Error, could not add files to CABinet!!") 
          ProcMutex = 0 
          Return 
        EndIf 
      Else 
        Status_Message("Error, no CABinet name specified!!") 
        ProcMutex = 0 
        Return 
      EndIf 
      CabCompressTerminate() 
    Else 
      Status_Message("Error, could not initialise compression") 
      ProcMutex = 0 
      Return 
    EndIf 
    Status_Message("CABinet file created successfully!!") 
    ClearGadgetItemList(#Gadget_cabboy_List_Members) 
  EndIf 
  
  ProcMutex = 0 
  
  KillTimer_(WindowID(#Window_cabboy),0) 
  
  Reset_Title() 
    
Return 

;=========================================================================================================================== 
; Decompress files from a CABinet file 
;=========================================================================================================================== 
; 
;DeCompress_Files: 
; 
;If CabDecompressInitialize() 
;  Found = CabEnum(CurrentDirectory + "MyCab.cab") 
;  ResetList(CabFileList()) 
;  For Tmp = 1 To Found 
;    NextElement(CabFileList()) 
;    ;CabExtract(CabFileList(),CabFileList()) 
;    Debug CabFileList() 
;  Next    
;  CabDecompressTerminate()  
;EndIf 
; 
;Return 
; 
;=========================================================================================================================== 
; Main program window 
;=========================================================================================================================== 

Procedure.l Window_cabboy() 
  If OpenWindow(#Window_cabboy,237,40,500,400, ProgramVersion.s,#PB_Window_SystemMenu|#PB_Window_MinimizeGadget|#PB_Window_MaximizeGadget|#PB_Window_SizeGadget|#PB_Window_Invisible) 
    OriginalWidth     = WindowWidth(#Window_cabboy)  ; Original non-client width. 
    OriginalHeight    = WindowHeight(#Window_cabboy) ; Original non-client height. 
    If CreateGadgetList(WindowID(#Window_cabboy)) 
      Frame3DGadget(#Gadget_cabboy_Main_Frame,5,0,490,40,"") 
      TextGadget(#Gadget_cabboy_Cab_Name_Label,15,15,75,15,"CAB file name",#PB_Text_Center) 
      TextGadget(#Gadget_cabboy_Cab_Name,95,15,360,15,"") 
      ButtonGadget(#Gadget_cabboy_Set_Pack_Name,460,15,25,15,"...") 
      Tool_Tip(GadgetID(#Gadget_cabboy_Set_Pack_Name), "Click this button to set the name of the CABinet file you will be adding to") 
      Frame3DGadget(#Gadget_cabboy_List_Frame,5,40,490,310,"") 
      ListIconGadget(#Gadget_cabboy_List_Members,15,55,470,285,"Filenames",500,#PB_ListIcon_MultiSelect|#PB_ListIcon_GridLines|#PB_ListIcon_FullRowSelect|#PB_ListIcon_AlwaysShowSelection) 
      Tool_Tip(GadgetID(#Gadget_cabboy_List_Members), "Double left clicking on any item in this list will remove it from the list and double right clicking on any item in the list will remove all items from the list") 
        SendMessage_(GadgetID(#Gadget_cabboy_List_Members),#LVM_SETBKCOLOR,0,9436387) 
        SendMessage_(GadgetID(#Gadget_cabboy_List_Members),#LVM_SETTEXTBKCOLOR,0,9436387) 
      Frame3DGadget(#Gadget_cabboy_Control_Frame,5,350,490,45,"") 
      ButtonGadget(#Gadget_cabboy_Add_Files,15,365,50,20,"Add files") 
      Tool_Tip(GadgetID(#Gadget_cabboy_Add_Files), "Click this button to addindividual files to the packing list") 
      ButtonGadget(#Gadget_cabboy_Make_Cab_File,115,365,50,20,"CAB it") 
      Tool_Tip(GadgetID(#Gadget_cabboy_Make_Cab_File), "Click this button to create the CABinet file from the list members") 
      ButtonGadget(#Gadget_cabboy_Exit_Program,165,365,50,20,"Exit") 
      Tool_Tip(GadgetID(#Gadget_cabboy_Exit_Program), "Click this button to exit this program immediately (If not sooner)") 
      TextGadget(#Gadget_cabboy_Status_Box,220,370,265,15,"") 
      Tool_Tip(GadgetID(#Gadget_cabboy_Status_Box), "Any error messages generated by the program will show up in here") 
      ButtonGadget(#Gadget_cabboy_Add_Directories,65,365,50,20,"Add dirs") 
      HideWindow(#Window_cabboy,0) 
      ProcedureReturn WindowID(#Window_cabboy) 
    EndIf 
  EndIf 
EndProcedure 

;=========================================================================================================================== 
; 
;=========================================================================================================================== 

Procedure.s CabAbout() 

  Shared CabAbout.l 
  
  ProcedureReturn PeekS(CallFunctionFast(CabAbout)) 
  
EndProcedure 

;=========================================================================================================================== 
; 
;=========================================================================================================================== 

Procedure.l CabDecompressInitialize() 

  Shared CabDecompressInitialize.l 
  
  ProcedureReturn CallFunctionFast(CabDecompressInitialize) 
  
EndProcedure 

;=========================================================================================================================== 
; 
;=========================================================================================================================== 

Procedure.l CabEnum(Source.s) 

  Shared CabEnum.l 
  
  Total = 0 
  
  Result$ = PeekS(CallFunctionFast(CabEnum, Source)) 
  
  If Result$ <> "" 
    ClearList(CabFileList()) 
    Repeat 
      Total + 1 
      file.s = StringField(Result$, Total, Chr(9)) 
      AddElement(CabFileList()) 
      CabFileList() = file 
    Until file = "" 
    Total - 1 
  EndIf 
  
  ProcedureReturn Total 
  
EndProcedure 

;=========================================================================================================================== 
; 
;=========================================================================================================================== 

Procedure.l CabExtract(Source.s, Destination.s) 

  Shared CabExtract.l 
  
  ProcedureReturn CallFunctionFast(CabExtract, Source, Destination) 
  
EndProcedure 

;=========================================================================================================================== 
; 
;=========================================================================================================================== 

Procedure.l CabDecompressTerminate() 

  Shared CabDecompressTerminate.l 
  
  ProcedureReturn CallFunctionFast(CabDecompressTerminate) 
    
EndProcedure 

;=========================================================================================================================== 
; 
;=========================================================================================================================== 

Procedure.l CabCompressInitialize() 

  Shared CabCompressInitialize.l 
  
  ProcedureReturn CallFunctionFast(CabCompressInitialize) 
  
EndProcedure 

;=========================================================================================================================== 
; 
;=========================================================================================================================== 

Procedure.l CabCreate(Destination.s) 

  Shared CabCreate.l 
  
  ProcedureReturn CallFunctionFast(CabCreate, Destination) 
  
EndProcedure 

;=========================================================================================================================== 
; 
;=========================================================================================================================== 

Procedure.l CabAddFile(hCab, Source.s, Destination.s) 

  Shared CabAddFile.l 
  
  ProcedureReturn CallFunctionFast(CabAddFile, hCab, Source, Destination) 
  
EndProcedure 

;=========================================================================================================================== 
; 
;=========================================================================================================================== 

Procedure.l CabClose(hCab.l) 

  Shared CabClose.l 
  
  ProcedureReturn CallFunctionFast(CabClose, hCab) 
  
EndProcedure 

;=========================================================================================================================== 
; 
;=========================================================================================================================== 

Procedure.l CabCompressTerminate() 

  Shared CabCompressTerminate.l 
  
  ProcedureReturn CallFunctionFast(CabCompressTerminate)  
  
EndProcedure 

;============================================================================================================================ 
; Form and object resizing 
;============================================================================================================================ 

Procedure Resize_Callback(WindowID, Message, wParam, lParam) 

  Result = #PB_ProcessPureBasicEvents 
  
  If WindowID = WindowID(#Window_cabboy)                                ; Only process events for this window 
    Select Message                                                      ; What sort of event did we get 
      Case #WM_GETMINMAXINFO                                            ; Restrict the minimum size to 500x(307 + MenuHeight()), borders included 
        Result = 0 
        *ptr.MINMAXINFO       = lParam 
        *ptr\ptMinTrackSize\x = 500 + 8 
        *ptr\ptMinTrackSize\y = 400 + 8 + MenuHeight() 
      Case #WM_SIZE                                                     ; Form's size has changed. 
        ; Use the right window 
        WinWidth.l  = WindowWidth(#Window_cabboy)                                     ; Get the new width of the window 
        WinHeight.l = WindowHeight(#Window_cabboy)                                    ; Get the new height of the window 
        WidthChange  = WinWidth  - OriginalWidth                        ; Get the width difference 
        HeightChange = WinHeight - OriginalHeight                       ; Get the height difference 108,0,587,400 
        ;----------------------------------------------------------------------------------------------------------------- 
        NewCollumn4Size.l = WinWidth                                    ; 0 is the total sizes of the other collumns 
        SendMessage_(GadgetID(#Gadget_cabboy_List_Members), #LVM_SETCOLUMNWIDTH , 0, NewCollumn4Size.l) ; Set the new collumn size 
        ;----------------------------------------------------------------------------------------------------------------- 
        ResizeGadget(#Gadget_cabboy_Main_Frame,      5              ,   0               , 490 + WidthChange ,  40) 
        ResizeGadget(#Gadget_cabboy_Cab_Name_Label, 15              ,  15               ,  75               ,  15) 
        ResizeGadget(#Gadget_cabboy_Cab_Name,       95              ,  15               , 360 + WidthChange ,  15) 
        ResizeGadget(#Gadget_cabboy_Set_Pack_Name, 460 + WidthChange,  15               ,  25               ,  15) 
        ResizeGadget(#Gadget_cabboy_List_Frame,      5              ,  40               , 490 + WidthChange , 310 + HeightChange) 
        ResizeGadget(#Gadget_cabboy_List_Members,   15              ,  55               , 470 + WidthChange , 285 + HeightChange) 
        ResizeGadget(#Gadget_cabboy_Control_Frame,   5              , 350 + HeightChange, 490 + WidthChange ,  45) 
        ResizeGadget(#Gadget_cabboy_Add_Files,      15              , 365 + HeightChange,  50               ,  20) 
        ResizeGadget(#Gadget_cabboy_Add_Directories,65              , 365 + HeightChange,  50               ,  20) 
        ResizeGadget(#Gadget_cabboy_Make_Cab_File, 115              , 365 + HeightChange,  50               ,  20) 
        ResizeGadget(#Gadget_cabboy_Exit_Program,  165              , 365 + HeightChange,  50               ,  20) 
        ResizeGadget(#Gadget_cabboy_Status_Box,    220              , 370 + HeightChange, 265 + WidthChange ,  15) 
        ;----------------------------------------------------------------------------------------------------------------- 
        RedrawWindow_(WindowID(#Window_cabboy), 0, 0, #RDW_INVALIDATE)  ; Make sure window gets redrawn properly 
    EndSelect 
  EndIf 
  
  ProcedureReturn Result 
  
EndProcedure 

;============================================================================================================================ 
; Custom routine to make cuter looking tool tips 
;============================================================================================================================ 

Procedure Tool_Tip(Handle, Text.s) 

  ToolTipControl = CreateWindowEx_(0, "tooltips_class32", "", $D0000000 | #TTS_BALLOON, 0, 0, 0, 0, WindowID(#Window_cabboy), 0, GetModuleHandle_(0), 0) 
  
  SendMessage_(ToolTipControl, 1044, 0 ,0)           ; ForeColor Tooltip 
  SendMessage_(ToolTipControl, 1043, $58F5D6, 0)     ; BackColor Tooltip 
  SendMessage_(ToolTipControl, 1048, 0, 180)         ; Maximum Width of tooltip 

  Button.TOOLINFO\cbSize  = SizeOf(TOOLINFO) 
  Button\uFlags           = $11 
  Button\hWnd             = Handle 
  Button\uId              = Handle 
  Button\lpszText         = @Text.s 
  
  SendMessage_(ToolTipControl, $0404, 0, Button) 

EndProcedure 

;=========================================================================================================================== 
; Flash a message to the status bar whenever there is action happening 
;=========================================================================================================================== 

Procedure Blink_Message() 

  SetWindowText_(WindowID(#Window_cabboy), ProgramVersion.s + "   --   Working..") 

  TimerTicks + 1 
  If TimerTicks = 2 
    TimerTicks = 0 
    Reset_Title() 
  EndIf 

EndProcedure 

;=========================================================================================================================== 
; Reset the windows title to the program version. Used by a couple of routines 
;=========================================================================================================================== 

Procedure Reset_Title() 

  SetWindowText_(WindowID(#Window_cabboy), ProgramVersion.s) 

EndProcedure 

;=========================================================================================================================== 
; Shorten the amount of typing we do for messages all to the same gadget 
;=========================================================================================================================== 

Procedure Status_Message(Message.s) 

  SetGadgetText(#Gadget_cabboy_Status_Box, Message.s) 
  
EndProcedure 

;=========================================================================================================================== 
; Data section for bundled files 
;=========================================================================================================================== 

DataSection 

  CabDll: IncludeBinary "cab10.dll" 
  EndCab: 
  
EndDataSection 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = ---
; EnableXP