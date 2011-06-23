; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6860&highlight=
; Author: Num3 (updated for PB3.93 by Andre, updated for PB 4.00 by Andre)
; Date: 09. July 2003
; OS: Windows
; Demo: No


; Installer.exe code, which is thought for including in the Installer-Tool.pb code later
; Need a "Pback.png" image a 480 x 50 pixels png image 


; The SFX Module code (compile it has installer.exe)

; *********** SFX MODULE ********** 
; 
;           Num3 - 2003 
; 
; Please feel free to use this code 
; 
; ********************************* 

Declare install() 
Declare unpack() 
Declare Open_Window_0() 

#Window_0  = 0 
#Gadget_0  = 0 
#Gadget_2  = 1 
#Gadget_3  = 2 
#Gadget_4  = 3 
#Gadget_5  = 4 
#Gadget_6  = 5 
#Gadget_9  = 6 

#BS_FLAT  = $8000 
#PBM_SETBARCOLOR  = $409 
#PBM_SETBKCOLOR  = $2001 

;- Image Plugins 
UsePNGImageDecoder() 

;- Image Globals 
Global Image0 

;- Catch Images 
Image0  = CatchImage(0, ?Image0) 

;- Images 

DataSection 
Image0 : 
IncludeBinary "Pback.png" ; ***** 480 x 50 pixels png image 
EndDataSection 

Procedure Open_Window_0() 
  If OpenWindow(#Window_0, 263, 244, 458, 187, "PureBasic Tools Installer", #PB_Window_SystemMenu  | #PB_Window_TitleBar) 
    If CreateGadgetList(WindowID(#Window_0)) 
      Frame3DGadget(#Gadget_0,   - 5, 135, 470, 105, "") 
      TextGadget(#Gadget_2,  15, 70, 225, 20, "Please select a directory to install") 
      StringGadget(#Gadget_3,  15, 90, 365, 20, "") 
      ButtonGadget(#Gadget_4,  385, 90, 60, 20, "Browse", #BS_FLAT) 
      ButtonGadget(#Gadget_5,  360, 155, 75, 20, "Install", #BS_FLAT) 
      ImageGadget(#Gadget_9,   - 15,  - 5, 480, 50, Image0) 
      
    EndIf 
  EndIf 
EndProcedure 

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


Global path.s, windir.s, save.stuff, filename.s 

filename.s  = Space(1000) 
GetModuleFileName_(0,  filename.s, 1000) 
filename  = GetFilePart(filename) 

; **** Get PureBasic Default Dir **** 

path  = "Applications\PureBasic.exe\shell\open\command" 
If RegOpenKeyEx_(#HKEY_CLASSES_ROOT, path, 0, #KEY_ALL_ACCESS, @Key) = #ERROR_SUCCESS 
  indir.s  = Space(500) 
  insize  = 500 
  If RegQueryValueEx_(Key, "", 0, 0, @indir.s, @insize) = #ERROR_SUCCESS 
    RegCloseKey_(Key) 
    indir  = RemoveString(indir, "%1", 1) 
    indir  = RemoveString(indir, Chr(34), 1) 
    indir  = RTrim(indir) 
    path  = GetPathPart(indir) 
  Else 
    MessageRequester("Installer Error!",  "Hum... Seems i can't find Purebasic", #MB_ICONERROR) 
    RegCloseKey_(Key) 
    path  = "C:\purebasic" 
  EndIf 
EndIf 


; **** Get windows temp Dir **** 

windir.s  = Space(255) 
If GetTempPath_(255, windir) 
Else 
  windir  = "c:\" 
EndIf 


Open_Window_0() 
unpack() 

Repeat 
  
  Event  = WaitWindowEvent() 
  
  If Event  = #PB_Event_Gadget 
    
    GadgetID  = EventGadget() 
    
    If GadgetID  = #Gadget_5 
      ;- Unpack 
      install() 
    ElseIf GadgetID  = #Gadget_4 
      x.s  = PathRequester("Please Select Destination", path) 
      If x  <  > "" 
        x  = ReplaceString(x, "\", "" , 0, Len(x)-2) 
        SetGadgetText(#gadget_3,  x) 
      EndIf 
    EndIf 
    
  EndIf 
  
Until Event  = #PB_Event_CloseWindow 

DeleteFile(windir  + "\"  + save\file) 
DeleteFile(windir  + "\"  + save\help) 
DeleteFile(windir  + "\pbti.txt") 

Procedure unpack() 
  
  If ReadFile(0, filename) 
    
    
    FileSeek(0, Lof(0)-4) 
    filelen.l  = ReadLong(0) 
    
    
    *mem = AllocateMemory(filelen) 
    FileSeek(0, Lof(0)-4  - filelen) 
    ReadData(0, *mem,  filelen) 
    
    
    CreateFile(1,  windir  + "\tmp.pak") 
    WriteData(1, *mem,  filelen) 
    CloseFile(1) 
    CloseFile(0) 
  Else 
    MessageRequester("Installer Error!",  "Hum... Seems there is no package to deliver !", #MB_ICONERROR) 
    
  EndIf 
  
  
  If OpenPack(windir  + "\tmp.pak") 
    *file  = NextPackFile() 
    size.l  = PackFileSize() 
    CreateFile(0,  windir  + "\pbti.txt") 
    WriteData(0, *file , size) 
    CloseFile(0) 
    
    If OpenPreferences(windir  + "\pbti.txt") 
      
      save\dir  = ReadPreferenceString("Dir", "") 
      save\file  = ReadPreferenceString("File", "") 
      save\args  = ReadPreferenceString("Args", "") 
      save\name  = ReadPreferenceString("Name", "") 
      save\help  = ReadPreferenceString("Help", "") 
      save\run  = Val(ReadPreferenceString("Run", "")) 
      save\wait  = Val(ReadPreferenceString("Wait", "")) 
      save\hide  = Val(ReadPreferenceString("Hide", "")) 
      save\reload  = Val(ReadPreferenceString("Reload", "")) 
      
      ClosePreferences() 
      
    EndIf 
    
    SetGadgetText(#gadget_3,  path  + save\dir) 
    
    *file  = NextPackFile() 
    size.l  = PackFileSize() 
    CreateFile(0,  windir  + "\"  + save\file) 
    WriteData(0, *file , size) 
    CloseFile(0) 
    
    If save\help  <  > "" 
      *file  = NextPackFile() 
      size.l  = PackFileSize() 
      CreateFile(0,  windir  + "\"  + save\help) 
      WriteData(0, *file , size) 
      CloseFile(0) 
    EndIf 
    
    ClosePack() 
    
    DeleteFile(windir  + "\tmp.pak") 
  EndIf 
  
  
EndProcedure 

Procedure install() 
  
  CreateDirectory(GetGadgetText(#gadget_3)) 
  
  in.s  = windir  + "\"  + save\file 
  out.s  = GetGadgetText(#gadget_3)+"\"  + save\file 
  If CopyFile(in, out) 
  EndIf 
  
  If save\help  <  > "" 
    in.s  = windir  + "\"  + save\help 
    out.s  = GetGadgetText(#gadget_3)+"\"  + save\help 
    If CopyFile(in, out) 
    EndIf 
  EndIf 
  
  
  If OpenFile(0, path  + "tools.prefs") 
    
    While Eof(0)=0 
      x.s  = ReadString(0) 
      w  = FindString(x, "ToolCount = ", 1) 
      
      If w 
        
        count  = Val(Mid(x, 12 , Len(x))) 
        count  + 1 
        FileSeek(0, Loc(0)-Len(x)-2) 
        WriteStringN(0, "ToolCount = "  + Str(count)) 
        
      EndIf 
    Wend 
    FileSeek(0, Lof(0)) 
    WriteStringN(0, ";") 
    WriteStringN(0, ";") 
    WriteStringN(0, "[Tool_"  + Str(count)+"]") 
    WriteStringN(0, "Command = "  + GetGadgetText(#gadget_3)+"\"  + save\file) 
    WriteStringN(0, "Arguments = "  + save\args) 
    WriteStringN(0, "WorkingDir = ") 
    WriteStringN(0, "MenuItemName = "  + save\name) 
    WriteStringN(0, "Shortcut = " ) 
    WriteStringN(0, "Flags = "  + Str(save\wait)) 
    WriteStringN(0, "ReloadSource = "  + Str(save\reload)) 
    WriteStringN(0, "HideEditor = "  + Str(save\hide)) 
    
    CloseFile(0) 
    
  EndIf 
  
  
  DeleteFile(windir  + "\"  + save\file) 
  DeleteFile(windir  + "\"  + save\help) 
  DeleteFile(windir  + "\pbti.txt") 
  
  MessageRequester("Installer",  "Installation Complete!", #MB_ICONINFORMATION ) 
  End 
  
EndProcedure 


End 
 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
