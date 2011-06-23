; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6860&highlight=
; Author: Num3 (updated for PB3.93 by Andre, updated for PB 4.00 by Andre)
; Date: 09. July 2003
; OS: Windows
; Demo: No


; Source code to the Tools Installer Program Posted on this thread: 
; http://purebasic.myforums.net/viewtopic.php?t=6691 

; Needs the "Installer.exe", created with the also provided source "Installer.pb"


; ******** TOOLS INSTALLER ******** 
; 
;           Num3 - 2003 
; 
; Please feel free to use this code 
; 
; ********************************* 

Declare PackerProgress(SourcePosition, DestinationPosition) 
Declare create() 
Declare Open_Window_0() 
Declare BalloonTip(WindowID, Gadget, Text$ , Title$, Icon) 


#Window_0  = 0 
#Gadget_0  = 0 
#Gadget_18  = 1 
#Gadget_5  = 2 
#Gadget_1  = 3 
#Gadget_6  = 4 
#Gadget_2  = 5 
#Gadget_8  = 6 
#Gadget_3  = 7 
#Gadget_9  = 8 
#Gadget_12  = 9 
#Gadget_13  = 10 
#Gadget_14  = 11 
#Gadget_15  = 12 
#Gadget_16  = 13 
#Gadget_17  = 14 
#Gadget_4  = 15 
#Gadget_10  = 16 
#Gadget_7  = 17 
#Gadget_11  = 18 
#Gadget_23  = 19 
#Gadget_20  = 20 
#Gadget_22  = 21 

#BS_FLAT  = $8000 
#PBM_SETBARCOLOR  = $409 
#PBM_SETBKCOLOR  = $2001 

Global Dim Language$(33) 

;- Image Plugins 
UsePNGImageDecoder() 

;- Image Globals 
Global Image0 

;- Catch Images 
Image0  = CatchImage(0, ?Image0) 

;- Images 
DataSection 
  Image0: 
  IncludeBinary "..\..\Graphics\Gfx\PureBasic.bmp" ; The purebasic PNG that is found on examples\data 
EndDataSection 

; BalloonTip Constants 
#TOOLTIP_NO_ICON  = 0 
#TOOLTIP_INFO_ICON  = 1 
#TOOLTIP_WARNING_ICON  = 2 
#TOOLTIP_ERROR_ICON  = 3 

Procedure BalloonTip(WindowID, Gadget, Text$ , Title$, Icon) 
  
  ToolTip  = CreateWindowEx_(0, "ToolTips_Class32", "", #WS_POPUP  | #TTS_NOPREFIX  | #TTS_BALLOON, 0, 0, 0, 0, WindowID, 0, GetModuleHandle_(0), 0) 
  SendMessage_(ToolTip,  #TTM_SETTIPTEXTCOLOR, GetSysColor_(#COLOR_INFOTEXT), 0) 
  SendMessage_(ToolTip,  #TTM_SETTIPBKCOLOR, GetSysColor_(#COLOR_INFOBK), 0) 
  SendMessage_(ToolTip,  #TTM_SETMAXTIPWIDTH, 0, 180) 
  Balloon.TOOLINFO\cbSize  = SizeOf(TOOLINFO) 
  Balloon\uFlags  = #TTF_IDISHWND  | #TTF_SUBCLASS 
  Balloon\hWnd  = GadgetID(Gadget) 
  Balloon\uId  = GadgetID(Gadget) 
  Balloon\lpszText  = @Text$ 
  SendMessage_(ToolTip,  #TTM_ADDTOOL, 0, Balloon) 
  If Title$  > "" 
    SendMessage_(ToolTip,  #TTM_SETTITLE, Icon, @Title$) 
  EndIf 
  
EndProcedure 

Procedure Open_Window_0() 
  If OpenWindow(#Window_0, 359, 170, 302, 392, "PureBasic Tool Installer", #PB_Window_SystemMenu  | #PB_Window_MinimizeGadget  | #PB_Window_TitleBar  | #PB_Window_ScreenCentered) 
    If CreateGadgetList(WindowID(#Window_0)) 
      
      TextGadget(#Gadget_0,  15, 70, 105, 15, Language$(0)) 
      BalloonTip(WindowID(#Window_0),  #Gadget_0, Language$(1), Language$(2), #TOOLTIP_NO_ICON) 
      
      TextGadget(#Gadget_1,  15, 97, 105, 15, Language$(5)) 
      BalloonTip(WindowID(#Window_0),  #Gadget_1, Language$(6), Language$(7), #TOOLTIP_NO_ICON) 
      
      TextGadget(#Gadget_2,  15, 124, 105, 15, Language$(10)) 
      BalloonTip(WindowID(#Window_0),  #Gadget_2, Language$(11), Language$(12), #TOOLTIP_NO_ICON) 
      
      TextGadget(#Gadget_4,  17, 179, 105, 15, Language$(26)) 
      BalloonTip(WindowID(#Window_0),  #Gadget_4, Language$(27), Language$(28), #TOOLTIP_NO_ICON) 
      
      StringGadget(#Gadget_5,  120, 65, 140, 20, "") 
      BalloonTip(WindowID(#Window_0),  #Gadget_5, Language$(3), Language$(4), #TOOLTIP_INFO_ICON) 
      
      StringGadget(#Gadget_6,  120, 92, 140, 20, "") 
      BalloonTip(WindowID(#Window_0),  #Gadget_6, Language$(8), Language$(9), #TOOLTIP_INFO_ICON) 
      
      ButtonGadget(#Gadget_7,  265, 92, 15, 20, Language$(31), #BS_FLAT) 
      
      
      StringGadget(#Gadget_8,  120, 120, 140, 20, "") 
      BalloonTip(WindowID(#Window_0),  #Gadget_8, Language$(13), Language$(14), #TOOLTIP_INFO_ICON) 
      
      TextGadget(#Gadget_3,  17, 151, 105, 15, Language$(15)) 
      BalloonTip(WindowID(#Window_0),  #Gadget_3, Language$(16), Language$(17), #TOOLTIP_NO_ICON) 
      
      StringGadget(#Gadget_9,  120, 147, 140, 20, "") 
      BalloonTip(WindowID(#Window_0),  #Gadget_9, Language$(18), Language$(19), #TOOLTIP_INFO_ICON) 
      
      StringGadget(#Gadget_10,  120, 174, 140, 20, "") 
      BalloonTip(WindowID(#Window_0),  #Gadget_10, Language$(29), Language$(30), #TOOLTIP_INFO_ICON) 
      ButtonGadget(#Gadget_11,  265, 174, 15, 20, Language$(32), #BS_FLAT) 
      
      CheckBoxGadget(#Gadget_12,  25, 205, 250, 15, Language$(20)) 
      CheckBoxGadget(#Gadget_13,  25, 230, 248, 15, Language$(21)) 
      CheckBoxGadget(#Gadget_14,  25, 255, 253, 15, Language$(22)) 
      CheckBoxGadget(#Gadget_15,  25, 280, 253, 15, Language$(23)) 
      
      OptionGadget(#Gadget_16,  60, 300, 130, 15, Language$(24)) 
      OptionGadget(#Gadget_17,  60, 320, 130, 15, Language$(25)) 
      
      ImageGadget(#Gadget_18,  60, 10, 168, 35, Image0) 
      
      Frame3DGadget(#Gadget_23,  5, 50, 285, 300, "") 
      ButtonGadget(#Gadget_20,  200, 360, 90, 20, Language$(33), #BS_FLAT) 
      
      ProgressBarGadget(#Gadget_22,  10, 365, 185, 10, 0, 100, #PB_ProgressBar_Smooth) 
      PostMessage_(GadgetID(#Gadget_22),  #PBM_SETBARCOLOR, 0, RGB(255, 204, 51)) 
      PostMessage_(GadgetID(#Gadget_22),  #PBM_SETBKCOLOR, 0, RGB(51, 102, 153)) 
      
      
    EndIf 
  EndIf 
EndProcedure 

; *********  For future language catalog ************ 
; 
; Procedure ReadCatalog(Filename$) 
; 
;   If ReadFile(0, Filename$) 
;     If ReadString() = "Catalog" 
;       For k=0 To 33 
;         Language$(k) = ReadString() 
;       Next 
;     EndIf 
;     CloseFile(0) 
;   EndIf 
; 
; EndProcedure 
; 
Restore BaseLanguage 
For k = 0 To 33 
  Read Language$(k) 
Next 

DataSection 
BaseLanguage  : 
Data$ "Directory Name:" 
Data$ "" 
Data$ "Name for the directory that is created for you tool" 
Data$ "Name for the directory that is created in the Purebasic Folder for your tool" 
Data$ "Directory Name" 
Data$ "Tool Executable:" 
Data$ "" 
Data$ "Name for the directory that is created for you tool" 
Data$ "Filename of your tool" 
Data$ "Executable" 
Data$ "Arguments:" 
Data$ "" 
Data$ "Name for the directory that is created for you tool" 
Data$ "(%PATH, %FILE, %TEMPFILE)" 
Data$ "Command Line Arguments" 
Data$ "Menu Item Name:" 
Data$ "" 
Data$ "Name for the directory that is created for you tool" 
Data$ "The name that will appear on the Tools Menu" 
Data$ "Menu Name" 
Data$ "Run Hiden" 
Data$ "Wait Until Tool Quits" 
Data$ "Hide Editor" 
Data$ "Reload Source after tool ends" 
Data$ "Into a new source" 
Data$ "Into current source" 
Data$ "Tool Help File:" 
Data$ "" 
Data$ "Name for the directory that is created for you tool" 
Data$ "If you want to include a help or credit file, select it here" 
Data$ "Tool Help File" 
Data$ ">" 
Data$ ">" 
Data$ "Create" 
EndDataSection 

Open_Window_0() 

SetActiveGadget(#Gadget_5) 
DisableGadget(#gadget_16,  1) 
DisableGadget(#gadget_17,  1) 
DisableGadget(#gadget_14,  1) 

; * Get windows temp path * 
Global windir.s
windir.s  = Space(255) 
If GetTempPath_(255, windir) 
Else 
  windir  = "c:\" 
EndIf 

Structure stuff 
  dir.s 
  file.s 
  args.s 
  name.s 
  help.s 
  run.b 
  wait.b 
  hide.b 
  reload.b 
EndStructure 

Global save.stuff, FileLength 

Repeat 
  
  
  Event  = WaitWindowEvent() 
  
  If Event  = #PB_Event_Gadget 
    
    GadgetID  = EventGadget() 
    
    If GadgetID  = #Gadget_7 
      ;- Tool Exe 
      x.s  = OpenFileRequester("Select File", "*.exe", "*.exe", 0 ) 
      If x  <  > "" 
        SetGadgetText(#Gadget_6,  x) 
      EndIf 
      
    ElseIf GadgetID  = #Gadget_13 
      If GetGadgetState(#gadget_13) 
        DisableGadget(#gadget_14,  0) 
      Else 
        DisableGadget(#gadget_14,  1) 
        SetGadgetState(#gadget_14,  0) 
      EndIf 
      
    ElseIf GadgetID  = #Gadget_11 
      ;- Help File 
      x.s  = OpenFileRequester("Select File", "*.*", "*.*", 0 ) 
      If x  <  > "" 
        SetGadgetText(#Gadget_10,  x) 
      EndIf 
      
    ElseIf GadgetID  = #Gadget_15 
      ;- Reload Source 
      If GetGadgetState(#Gadget_15)=1 
        DisableGadget(#gadget_16,  0) 
        DisableGadget(#gadget_17,  0) 
      Else 
        DisableGadget(#gadget_16,  1) 
        DisableGadget(#gadget_17,  1) 
        SetGadgetState(#Gadget_16,  0) 
        SetGadgetState(#Gadget_17,  0) 
      EndIf 
      
    ElseIf GadgetID  = #Gadget_16 
      ;- New Source 
      If GetGadgetState(#Gadget_16)=1 
        SetGadgetState(#Gadget_17,  0) 
      EndIf 
      
    ElseIf GadgetID  = #Gadget_17 
      ;- Current Source 
      If GetGadgetState(#Gadget_17)=1 
        SetGadgetState(#Gadget_16,  0) 
      EndIf 
      
      
    ElseIf GadgetID  = #Gadget_20 
      
      ;- Preparation 
      save\dir  = GetGadgetText(#gadget_5) 
      save\file  = GetGadgetText(#gadget_6) 
      save\help  = GetGadgetText(#gadget_10) 
      save\args  = GetGadgetText(#gadget_8) 
      
      save\name  = GetGadgetText(#gadget_9) 
      save\run  = GetGadgetState(#Gadget_12) 
      save\wait  = GetGadgetState(#Gadget_13) 
      save\hide  = GetGadgetState(#Gadget_14) 
      create() 
      
    ElseIf GadgetID  = #Gadget_22 
      
      
    EndIf 
    
  EndIf 
  
  
  
Until Event  = #PB_Event_CloseWindow 

Procedure create() 
  
  If save\dir  = "" 
    MessageRequester("Error",  "You need to name a directory to be created", #MB_ICONERROR ) 
    SetActiveGadget(#Gadget_5) 
    ProcedureReturn 
  EndIf 
  
  If save\file  = "" 
    MessageRequester("Error",  "No tool executable selected", #MB_ICONERROR ) 
    SetActiveGadget(#Gadget_6) 
    ProcedureReturn 
  EndIf 
  
  If GetGadgetState(#gadget_16)=1 
    save\reload  = 1 
  EndIf 
  
  If GetGadgetState(#gadget_17)=1 
    save\reload  = 2 
  EndIf 
  
  
  If CreatePreferences(windir  + "\pbti.txt") 
    
    WritePreferenceString("Dir",  save\dir) 
    WritePreferenceString("File",  GetFilePart(save\file)) 
    WritePreferenceString("Args",  save\args) 
    WritePreferenceString("Name",  save\name) 
    WritePreferenceString("Help",  GetFilePart(save\help)) 
    WritePreferenceString("Run",  Str(save\run)) 
    WritePreferenceString("Wait",  Str(save\wait)) 
    WritePreferenceString("Hide",  Str(save\hide)) 
    WritePreferenceString("Reload",  Str(save\reload)) 
    
    ClosePreferences() 
  Else 
    ProcedureReturn 
    
  EndIf 
  
  
  filename.s  = SaveFileRequester("Save", save\name  + ".exe", "*.exe", 0) 
  If filename  = "" 
    filename  = save\name  + ".exe" 
  EndIf 
  
  
  If CreatePack(windir  + "\test.bulk") 
    ; pnti.txt file 
    
    FileLength  = FileSize(windir  + "\pbti.txt") 
    
    If FileLength  > 0 
      Debug "Adding:"  + windir  + "\pbti.txt" 
      PackerCallback(@PackerProgress()) 
      If AddPackFile(windir  + "\pbti.txt", 9) 
      EndIf 
    EndIf 
    
    ; Our exec file 
    
    FileLength  = FileSize(save\file) 
    
    If FileLength  > 0 
      Debug "Adding:"  + save\file 
      PackerCallback(@PackerProgress()) 
      If AddPackFile(save\file, 9) 
      EndIf 
    EndIf 
    
    ; Our help file 
    
    FileLength  = FileSize(save\help) 
    
    If FileLength  > 0 
      Debug "Adding:"  + save\help 
      PackerCallback(@PackerProgress()) 
      If AddPackFile(save\help, 9) 
      EndIf 
    EndIf 
    
    
    ClosePack() 
    Delay(100) 
    
    
    
    If ReadFile(0, windir  + "\test.bulk") 
      len  = Lof(0) 
      *mem = AllocateMemory(len) 
      ReadData(0, *mem,  len) 
      CloseFile(0) 
    EndIf 
    
    
    
    If CreateFile(0, filename) 
      WriteData(0, ?filestart,  ?fileend  - ?filestart) 
      WriteData(0, *mem,  len) 
      WriteLong(0, len) 
      CloseFile(0) 
    EndIf 
    DeleteFile(windir  + "\test.bulk") 
    DeleteFile(windir  + "\pbti.txt") 
    End 
    
    SetGadgetState(#Gadget_22,  0) 
    
  EndIf 
  
  
  
EndProcedure 

Procedure PackerProgress(SourcePosition, DestinationPosition) 
  
  Result.f  = (SourcePosition  / FileLength)*100 
  SetGadgetState(#Gadget_22,  Round(Result, 0)) 
  
  While (WindowEvent()) 
  Wend 
  
  ProcedureReturn 1 
EndProcedure 


End 


;Include the SFX program !!! 
filestart  : 
IncludeBinary "Installer.exe" ;Change this line to match the SFX exe name 
fileend  : 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
