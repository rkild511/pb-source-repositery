; English forum: http://www.purebasic.fr/english/viewtopic.php?t=9247&highlight=
; Author: Fangbeast (updated for PB 4.00 by Andre)
; Date: 21. January 2004
; OS: Windows
; Demo: No


; CAB Girly. UnCAB Microsoft CABinet files
; ----------------------------------------
; Ages ago, I did CAB Boy to make CABinet files recursively and I've just had time
; to fix bugs in this 'opposite' routine to unCAB files so here it is. And if you
; don't like it, I don't care. The CAB10.DLL referenced is available from a few
; places including me, search for CAB BOY for references. 
 

;=========================================================================================================================== 
; Copyright. 
;=========================================================================================================================== 
; All CAB routines Paul Leischow, including the UPX'ed microsoft cabinet dll. Sort of wrapper dll. 
; 
; All hard work writing this code (Yeah right!) PeriTek Visions 
; 
; For extensive testing and debuggerising, the legend that is LarsG!! 
; 
; Do what you like with it except it is not to be used in any commercial project as is. I may or may not add to it as 
; time permits, I may or may not fix things as time permits. As always, if you don't like it, don't use it! I also neither 
; want nor need comments about it, I simply don't care. It was something I needed for myself. 
;=========================================================================================================================== 
; All my program constants 
;=========================================================================================================================== 

#DLL                              = 1                     ; CAB dll variable for library functions 

Enumeration 
  #Window_CabGirly                                        ; Window Constants 
EndEnumeration 

#WindowIndex = #PB_Compiler_EnumerationValue 

Enumeration 
  #Gadget_CabGirly_Main_Frame                             ; Window_CabGirly 
  #Gadget_CabGirly_Directory_Tree 
  #Gadget_CabGirly_Cab_List 
  #Gadget_CabGirly_Cab_Member 
  #Gadget_CabGirly_Control_Frame 
  #Gadget_CabGirly_Extract_Files 
  #Gadget_CabGirly_Set_Directory 
  #Gadget_CabGirly_Extract_Directory 
  #Gadget_CabGirly_Clear 
  #Gadget_CabGirly_Exit 
EndEnumeration 

#GadgetIndex = #PB_Compiler_EnumerationValue 

;=========================================================================================================================== 
; Get the current working directory for later functions (may or may not use it) 
;=========================================================================================================================== 

CurrentDirectory.s = Space(256) 

GetCurrentDirectory_(Len(CurrentDirectory.s), @CurrentDirectory) 

If Right(CurrentDirectory.s, 1) <> "\" 
  CurrentDirectory.s + "\" 
EndIf 

;=========================================================================================================================== 
; Create the dll in the current directory and then enumerate the functions of you can load it 
;=========================================================================================================================== 

If CreateFile(0, CurrentDirectory.s + "Cab10.dll")                    ; Write the cab dll to the current directory 
  WriteData(0, ?CabDll, ?EndCab - ?CabDll) 
  CloseFile(0) 
  If OpenLibrary(#DLL,"Cab10.dll") 
    CabAbout                  = GetFunction(#DLL,"CABABOUT") 
    CabCompressInitialize     = GetFunction(#DLL,"CABCOMPRESSINITIALIZE") 
    CabDecompressInitialize   = GetFunction(#DLL,"CABDECOMPRESSINITIALIZE") 
    CabCreate                 = GetFunction(#DLL,"CABCREATE") 
    CabAddFile                = GetFunction(#DLL,"CABADDFILE") 
    CabClose                  = GetFunction(#DLL,"CABCLOSE") 
    CabEnum                   = GetFunction(#DLL,"CABENUM") 
    CabExtract                = GetFunction(#DLL,"CABEXTRACT") 
    CabCompressTerminate      = GetFunction(#DLL,"CABCOMPRESSTERMINATE") 
    CabDecompressTerminate    = GetFunction(#DLL,"CABDECOMPRESSTERMINATE")  
  Else 
    MessageRequester("Error","Could Not Load DLL",#MB_ICONERROR) 
    End 
  EndIf 
EndIf 

;=========================================================================================================================== 
; Declare any new lists based on structures or single dimensional elements 
;=========================================================================================================================== 

Global NewList CabFileList.s() 

;=========================================================================================================================== 
; Any global variables we need 
;=========================================================================================================================== 

Global OriginalWidth, OriginalHeight, TimerTicks.l, ProgramVersion.s 

;=========================================================================================================================== 
; Set the global program version number 
;=========================================================================================================================== 

ProgramVersion.s =  "CAB Girly" 

;=========================================================================================================================== 
; All my procedural declarations 
;=========================================================================================================================== 

Declare.l Window_CabGirly() 

Declare   WindowCallback(WindowID, Message, wParam, lParam) 

Declare   Blink_Message() 
Declare   BubbleTip(bWindow.l, bGadget.l, bText.s) 

Declare.s CabAbout() 
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
; Cute, round and colourful balloon tips (Note the correct spelling of the word 'colour' !!) 
;=========================================================================================================================== 

Procedure BubbleTip(bWindow.l, bGadget.l, bText.s) 

  ToolTipControl = CreateWindowEx_(0, "ToolTips_Class32", "", $D0000000|$40,0,0,0,0, WindowID(bWindow), 0, GetModuleHandle_(0), 0) 
  
  SendMessage_(ToolTipControl,1044,0,0) 
  SendMessage_(ToolTipControl,1043,$DFFFFF,0) 
  SendMessage_(ToolTipControl,1048,0,180) 

  Button.TOOLINFO\cbSize = SizeOf(TOOLINFO) 
  Button\uFlags = $11 
  Button\hWnd = GadgetID(bGadget) 
  Button\uId = GadgetID(bGadget) 
  Button\lpszText = @bText 

  SendMessage_(ToolTipControl, $0404, 0, Button) 
  
EndProcedure 

;=========================================================================================================================== 
; Main window code 
;=========================================================================================================================== 

Procedure.l Window_CabGirly() 

  If OpenWindow(#Window_CabGirly,175,0,614,405,"Cab Girly",#PB_Window_SystemMenu|#PB_Window_MinimizeGadget|#PB_Window_MaximizeGadget|#PB_Window_SizeGadget|#PB_Window_Invisible) 
    OriginalWidth     = WindowWidth(#Window_CabGirly)  ; Original non-client width. 
    OriginalHeight    = WindowHeight(#Window_CabGirly) ; Original non-client height. 
    If CreateGadgetList(WindowID(#Window_CabGirly)) 
      Frame3DGadget(#Gadget_CabGirly_Main_Frame,5,0,605,355,"") 
      ExplorerTreeGadget(#Gadget_CabGirly_Directory_Tree,15,15,200,330,"",#PB_Explorer_NoFiles|#PB_Explorer_NoDriveRequester) 
      ExplorerListGadget(#Gadget_CabGirly_Cab_List,220,15,380,185,"",#PB_Explorer_AlwaysShowSelection|#PB_Explorer_GridLines|#PB_Explorer_FullRowSelect|#PB_Explorer_NoFolders|#PB_Explorer_NoParentFolder|#PB_Explorer_NoDriveRequester|#PB_Explorer_AutoSort) 
      ListIconGadget(#Gadget_CabGirly_Cab_Member,220,205,380,140,"FileNames",400,#PB_ListIcon_GridLines|#PB_ListIcon_FullRowSelect|#PB_ListIcon_AlwaysShowSelection) 
        SendMessage_(GadgetID(#Gadget_CabGirly_Cab_Member),#LVM_SETBKCOLOR,0,16710085) 
        SendMessage_(GadgetID(#Gadget_CabGirly_Cab_Member),#LVM_SETTEXTBKCOLOR,0,16710085) 
      Frame3DGadget(#Gadget_CabGirly_Control_Frame,5,355,605,45,"") 
      ButtonGadget(#Gadget_CabGirly_Extract_Files,15,370,45,20,"Extract") 
      ButtonGadget(#Gadget_CabGirly_Set_Directory,60,370,45,20,"Set Dir") 
      TextGadget(#Gadget_CabGirly_Extract_Directory,155,370,390,20,"",#PB_Text_Center|#PB_Text_Border) 
      ButtonGadget(#Gadget_CabGirly_Clear,105,370,45,20,"Clear") 
      ButtonGadget(#Gadget_CabGirly_Exit,550,370,50,20,"Exit") 
      HideWindow(#Window_CabGirly,0) 
      ProcedureReturn WindowID(#Window_CabGirly) 
    EndIf 
  EndIf 
  
EndProcedure 

;=========================================================================================================================== 
; Callback to actually handle the resize tracking 
;=========================================================================================================================== 

Procedure WindowCallback(WindowID, Message, wParam, lParam) 

  Result = #PB_ProcessPureBasicEvents 
  
  If WindowID = WindowID(#Window_CabGirly)                               ; Only process events for this window 
    Select Message                                                      ; What sort of event did we get 
      Case #WM_GETMINMAXINFO                                            ; Restrict the minimum size to 500x(307 + MenuHeight()), borders included 
        Result = 0 
        *ptr.MINMAXINFO       = lParam 
        *ptr\ptMinTrackSize\x = 500 + 8 
        *ptr\ptMinTrackSize\y = 400 + 8 + MenuHeight() 
      Case #WM_SIZE                                                     ; Form's size has changed. 
        WinWidth.l  = WindowWidth(#Window_CabGirly)                     ; Get the new width of the window 
        WinHeight.l = WindowHeight(#Window_CabGirly)                    ; Get the new height of the window 
        WidthChange  = WinWidth  - OriginalWidth                        ; Get the width difference 
        HeightChange = WinHeight - OriginalHeight                       ; Get the height difference 108,0,587,400 
        ;----------------------------------------------------------------------------------------------------------------- 
;        SendMessage_(GadgetID(#Gadget_CabGirly_Cab_List), #LVM_SETCOLUMNWIDTH , 0, WinWidth - 300) ; Set the new collumn size 
;        SendMessage_(GadgetID(#Gadget_CabGirly_Cab_Member), #LVM_SETCOLUMNWIDTH , 0, WinWidth) ; Set the new collumn size 
        ;----------------------------------------------------------------------------------------------------------------- 
        ResizeGadget(#Gadget_CabGirly_Main_Frame,          5              ,   0               , 605 + WidthChange, 355 + HeightChange) 
        ResizeGadget(#Gadget_CabGirly_Directory_Tree,     15              ,  15               , 200              , 330 + HeightChange) 
        ResizeGadget(#Gadget_CabGirly_Cab_List,          220              ,  15               , 380 + WidthChange, 185 + HeightChange) 
        ResizeGadget(#Gadget_CabGirly_Cab_Member,        220              , 205 + HeightChange, 380 + WidthChange, 140) 
        ResizeGadget(#Gadget_CabGirly_Control_Frame,       5              , 355 + HeightChange, 605 + WidthChange,  45) 
        ResizeGadget(#Gadget_CabGirly_Extract_Files,      15              , 370 + HeightChange,  45              ,  20) 
        ResizeGadget(#Gadget_CabGirly_Set_Directory,      60              , 370 + HeightChange,  45              ,  20) 
        ResizeGadget(#Gadget_CabGirly_Extract_Directory, 155              , 370 + HeightChange, 390 + WidthChange,  20) 
        ResizeGadget(#Gadget_CabGirly_Clear,             105              , 370 + HeightChange,  45              ,  20) 
        ResizeGadget(#Gadget_CabGirly_Exit,              550 + WidthChange, 370 + HeightChange,  50              ,  20) 
        ;----------------------------------------------------------------------------------------------------------------- 
        RedrawWindow_(WindowID(#Window_CabGirly), 0, 0, #RDW_INVALIDATE)  ; Make sure window gets redrawn properly 
    EndSelect 
  EndIf 
  
  ProcedureReturn Result 
  
EndProcedure 

;=========================================================================================================================== 
; CAB10 compression/decompression code 
;=========================================================================================================================== 

Procedure.s CabAbout() 

  Shared CabAbout.l 
  
  ProcedureReturn PeekS(CallFunctionFast(CabAbout)) 
  
EndProcedure 

;=========================================================================================================================== 
; CAB10 compression/decompression code 
;=========================================================================================================================== 

Procedure.l CabDecompressInitialize() 

  Shared CabDecompressInitialize.l 
  
  ProcedureReturn CallFunctionFast(CabDecompressInitialize) 
  
EndProcedure 

;=========================================================================================================================== 
; CAB10 compression/decompression code 
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
; CAB10 compression/decompression code 
;=========================================================================================================================== 

Procedure.l CabExtract(Source.s, Destination.s) 

  Shared CabExtract.l 
  
  ProcedureReturn CallFunctionFast(CabExtract, Source, Destination) 
  
EndProcedure 

;=========================================================================================================================== 
; CAB10 compression/decompression code 
;=========================================================================================================================== 

Procedure.l CabDecompressTerminate() 

  Shared CabDecompressTerminate.l 
  
  ProcedureReturn CallFunctionFast(CabDecompressTerminate) 
    
EndProcedure 

;=========================================================================================================================== 
; CAB10 compression/decompression code 
;=========================================================================================================================== 

Procedure.l CabCompressInitialize() 

  Shared CabCompressInitialize.l 
  
  ProcedureReturn CallFunctionFast(CabCompressInitialize) 
  
EndProcedure 

;=========================================================================================================================== 
; CAB10 compression/decompression code 
;=========================================================================================================================== 

Procedure.l CabCreate(Destination.s) 

  Shared CabCreate.l 
  
  ProcedureReturn CallFunctionFast(CabCreate, Destination) 
  
EndProcedure 

;=========================================================================================================================== 
; CAB10 compression/decompression code 
;=========================================================================================================================== 

Procedure.l CabAddFile(hCab, Source.s, Destination.s) 

  Shared CabAddFile.l 
  
  ProcedureReturn CallFunctionFast(CabAddFile, hCab, Source, Destination) 
  
EndProcedure 

;=========================================================================================================================== 
; CAB10 compression/decompression code 
;=========================================================================================================================== 

Procedure.l CabClose(hCab.l) 

  Shared CabClose.l 
  
  ProcedureReturn CallFunctionFast(CabClose, hCab) 
  
EndProcedure 

;=========================================================================================================================== 
; CAB10 compression/decompression code 
;=========================================================================================================================== 

Procedure.l CabCompressTerminate() 

  Shared CabCompressTerminate.l 
  
  ProcedureReturn CallFunctionFast(CabCompressTerminate)  
  
EndProcedure 

;=========================================================================================================================== 
; Flash a message to the status bar whenever there is action happening 
;=========================================================================================================================== 

Procedure Blink_Message() 

  SetWindowText_(WindowID(#Window_CabGirly), ProgramVersion.s + "   --   Working..") 

  TimerTicks + 1 
  If TimerTicks = 2 
    TimerTicks = 0 
    SetWindowText_(WindowID(#Window_CabGirly), ProgramVersion.s) 
  EndIf 

EndProcedure 

;=========================================================================================================================== 
; Main program event handler 
;=========================================================================================================================== 

If Window_CabGirly() 

  SetGadgetText(#Gadget_CabGirly_Extract_Directory, CurrentDirectory.s) 
  
  Extract_Dir.s = CurrentDirectory.s 
  
  SetWindowCallback(@WindowCallback()) 

  QuitCabGirly = 0 

  Repeat 
    EventID = WaitWindowEvent() 
    Select EventID 
      Case #PB_Event_CloseWindow 
        If EventWindow() = #Window_CabGirly 
          QuitCabGirly = 1 
        EndIf 
      Case #PB_Event_Gadget 
        Select EventGadget() 
          Case #Gadget_CabGirly_Directory_Tree      : Gosub Tree_Actions 
          ;------------------------------------------------------------------------------ 
          Case #Gadget_CabGirly_Cab_List 
            Select EventType() 
              Case #PB_EventType_LeftClick          : Gosub List_Actions 
            EndSelect 
            ;---------------------------------------------------------------------------- 
          Case #Gadget_CabGirly_Extract_Files       : Gosub Extract_Cab_Members 
          Case #Gadget_CabGirly_Set_Directory       : Gosub Set_Directory 
          Case #Gadget_CabGirly_Clear               : Gosub Set_Current_Dir 
          Case #Gadget_CabGirly_Exit                : QuitCabGirly = 1 
        EndSelect 
    EndSelect 
  Until QuitCabGirly 
  CloseWindow(#Window_CabGirly) 
  CloseLibrary(#DLL)                                                          ; Free up library resource 
;   If DeleteFile(CurrentDirectory.s + "Cab10.dll")                             ; Delete the included cab dll 
;   EndIf 
EndIf 

End 

;=========================================================================================================================== 
; Proces any actions happening on the tree 
;=========================================================================================================================== 

Tree_Actions: 

  SetGadgetText(#Gadget_CabGirly_Cab_List, GetGadgetText(#Gadget_CabGirly_Directory_Tree)) 

Return 

;=========================================================================================================================== 
; Process any actions happening on the file list 
;=========================================================================================================================== 

List_Actions: 

    ClearGadgetItemList(#Gadget_CabGirly_Cab_Member) 
    FileType.s = UCase(Right(GetGadgetItemText(#Gadget_CabGirly_Cab_List, GetGadgetState(#Gadget_CabGirly_Cab_List), 0), 4)) 
    DiskFile.s = GetGadgetText(#Gadget_CabGirly_Cab_List) + GetGadgetItemText(#Gadget_CabGirly_Cab_List, GetGadgetState(#Gadget_CabGirly_Cab_List), 0) 
    Select FileType.s 
      Case ".IMF" : Gosub Get_Cab_Members   ; Incredimail Letter file, CAB format compression 
      Case ".CAB" : Gosub Get_Cab_Members   ; Standard Microshifty CABinet format file 
    EndSelect 

Return 

;=========================================================================================================================== 
; Get the member files of a CABinet file and display them 
;=========================================================================================================================== 

Get_Cab_Members: 

  StartTimer(0, 1000, @Blink_Message()) 

  If CabDecompressInitialize() 
    Found = CabEnum(DiskFile.s) 
    ResetList(CabFileList()) 
    For Tmp = 1 To Found 
      NextElement(CabFileList()) 
      ;CabExtract(CabFileList(),CabFileList()) 
      While WindowEvent() : Wend 
      AddGadgetItem(#Gadget_CabGirly_Cab_Member, -1, CabFileList()) 
    Next    
    CabDecompressTerminate() 
  EndIf 
  
  EndTimer(0) 

Return 

;=========================================================================================================================== 
; Get the member files of a CABinet file and extract them 
;=========================================================================================================================== 

Extract_Cab_Members: 

  Target_Dir.s = Left(Extract_Dir.s, Len(Extract_Dir.s) -1) ; (DLL is coded with a leading backslash during the extract damnit) 
  
  If CabDecompressInitialize() 
    CabExtract(DiskFile.s, Target_Dir.s) 
    CabDecompressTerminate() 
  EndIf 

Return 

;=========================================================================================================================== 
; Set the directory for the extraction process 
;=========================================================================================================================== 

Set_Directory: 

  Extract_Dir.s = PathRequester("Extract To:", "") 
  
  If Extract_Dir.s = "" 
    SetGadgetText(#Gadget_CabGirly_Extract_Directory, CurrentDirectory.s) 
  Else 
    SetGadgetText(#Gadget_CabGirly_Extract_Directory, Extract_Dir.s) 
  EndIf 
  
Return 


;=========================================================================================================================== 
; Set the current dir as extract target, clearing previous user set dir 
;=========================================================================================================================== 

Set_Current_Dir: 

  SetGadgetText(#Gadget_CabGirly_Extract_Directory, CurrentDirectory.s) 

Return 

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