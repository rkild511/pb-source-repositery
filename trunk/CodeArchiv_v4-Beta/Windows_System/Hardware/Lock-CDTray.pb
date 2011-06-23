; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2789&highlight=
; Author: Andreas  (updated for PB4.00 by blbltheworm + Andre)
; Date: 10. November 2003
; OS: Windows
; Demo: No

;############################# 
;Lock & Unlock CDRom-Trays 
;Open & Close CDRom-Trays 
;############################# 
;Lock & Unlock only 
;NT4, XP and Win2000 
;############################# 
;Author : Andreas 
;November 2003 
;############################# 

  #IOCTL_STORAGE_MEDIA_REMOVAL = $2D4804 
  #IOCTL_STORAGE_EJECT_MEDIA  = $2D4808 
  #IOCTL_STORAGE_LOAD_MEDIA   = $2D480C 
  
  #ListViewGadget = 100 
  #Lock = 101 
  #UnLock = 102 
  #Eject = 104 
  #Load = 105 
  #Quit = 106 
  
  Global WaitCur.l,ArrowCur.l 
  WaitCur = LoadCursor_(0,#IDC_WAIT) 
  ArrowCur = LoadCursor_(0,#IDC_ARROW) 

  Structure PREVENT_MEDIA_REMOVAL 
    P1.b 
  EndStructure 

  Structure LWInfo 
    Drive.s 
    IsLock.b 
  EndStructure  
  
  Global NewList LW.LWInfo() 

  Procedure GetCDLW() 
    Protected a.l,Buffer.s 
    ListViewGadget(#ListViewGadget,10,10,200,200) 
    *Buffer = AllocateMemory(255) 
    GetLogicalDriveStrings_(255,*Buffer) 
    Repeat 
      If PeekS(*Buffer + b) = "" 
        Break 
      EndIf  
      Buffer = PeekS(*Buffer + b) 
      SHGetFileInfo_(Buffer,0,SHF.SHFILEINFO,270,769) 
      If GetDriveType_(Buffer) = #DRIVE_CDROM 
        AddGadgetItem(#ListViewGadget,-1, PeekS(SHF+12)) 
        AddElement(LW()) 
        LW()\Drive = Mid(PeekS(SHF+12),FindString(PeekS(SHF+12),":",0)-1,2) 
        LW()\IsLock = 0 
      EndIf 
      b = b + 4 
    ForEver 
    FreeMemory(*Buffer) 
  EndProcedure 
  
  Procedure EjectCD(LW.s) 
    SetCursor_(WaitCur) 
    Protected hLwStatus.l 
    hLwStatus = CreateFile_("\\.\"+LW,#GENERIC_READ|#GENERIC_WRITE, 0, 0, #OPEN_EXISTING, 0, 0) 
    If hLwStatus 
      DeviceIoControl_(hLwStatus,#IOCTL_STORAGE_EJECT_MEDIA,0,0,0,0,@Ret,0) 
      CloseHandle_(hLwStatus) 
    EndIf 
    SetCursor_(ArrowCur) 
  EndProcedure  
  
  Procedure LoadCD(LW.s) 
    SetCursor_(WaitCur) 
    Protected hLwStatus.l 
    hLwStatus = CreateFile_("\\.\"+LW,#GENERIC_READ|#GENERIC_WRITE, 0, 0, #OPEN_EXISTING, 0, 0) 
    If hLwStatus 
      DeviceIoControl_(hLwStatus,#IOCTL_STORAGE_LOAD_MEDIA,0,0,0,0,@Ret,0) 
      CloseHandle_(hLwStatus) 
    EndIf 
    SetCursor_(ArrowCur) 
  EndProcedure  
  
  Procedure.l LockCD(Lock.b,LW.s) 
    Protected LW$,RetBuffer.l,hLwStatus.l 
    Global Dim p.PREVENT_MEDIA_REMOVAL(0) 
    p(0)\P1 = Lock 
    hLwStatus = CreateFile_("\\.\"+LW,#GENERIC_READ|#GENERIC_WRITE, 0, 0, #OPEN_EXISTING, 0, 0) 
    If hLwStatus 
      ;LOCK or UNLOCK CD-TRAY 
      Retval.l = DeviceIoControl_(hLwStatus, #IOCTL_STORAGE_MEDIA_REMOVAL,p(0),SizeOf(BYTE),@p(0),SizeOf(BYTE),@RetBuffer,0) 
      CloseHandle_(hLwStatus) 
    EndIf 
    ProcedureReturn Retval 
  EndProcedure  

  Procedure Repair() 
    ResetList(LW()) 
    While NextElement(LW()) 
    ; alle Locks rückgängig machen 
        LockCD(0,LW()\Drive) 
    Wend 
    DeleteObject_(WaitCur) 
    DeleteObject_(ArrowCur) 
    End 
  EndProcedure  

  Procedure ErrorMessage() 
    MessageRequester("Info","Kein Laufwerk gewählt",#MB_OK|#MB_ICONINFORMATION) 
  EndProcedure 
  
  If OpenWindow(0,0,0,320,230,"Lock-CDTray",#PB_Window_ScreenCentered|#PB_Window_SystemMenu) And CreateGadgetList(WindowID(0)) 
    GetCDLW() 
    ButtonGadget(#Lock, 220, 10, 80,20,"Lock") 
    ButtonGadget(#UnLock, 220, 40, 80,20,"UnLock") 
    ButtonGadget(#Eject, 220, 70, 80,20,"Eject") 
    ButtonGadget(#Load, 220, 100, 80,20,"Load") 
    ButtonGadget(#Quit, 220, 190, 80,20,"Quit") 
    
    Repeat 
      Select WaitWindowEvent() 
        Case #PB_Event_Gadget 
          Select EventGadget() 
            Case #Quit 
              Repair() 
            Case #Eject 
              If GetGadgetState(#ListViewGadget) > -1 
                SelectElement(LW(),GetGadgetState(#ListViewGadget)) 
                EjectCD(LW()\Drive) 
              Else 
                ErrorMessage()    
              EndIf  
            Case #Load 
              If GetGadgetState(#ListViewGadget) > -1 
                SelectElement(LW(),GetGadgetState(#ListViewGadget)) 
                LoadCD(LW()\Drive)  
              Else 
                ErrorMessage()    
              EndIf  
            Case #Lock 
              If GetGadgetState(#ListViewGadget) > -1 
                 SelectElement(LW(),GetGadgetState(#ListViewGadget)) 
                 If LW()\IsLock = 0 
                 If LockCD(1,LW()\Drive) 
                    LW()\IsLock = 1 
                 EndIf 
                 EndIf 
              Else 
                ErrorMessage()    
              EndIf  
            Case #UnLock 
              If GetGadgetState(#ListViewGadget) > -1 
                 SelectElement(LW(),GetGadgetState(#ListViewGadget)) 
                LockCD(0,LW()\Drive) 
              Else 
                ErrorMessage()    
              EndIf  
          EndSelect            
        Case #PB_Event_CloseWindow 
          Repair() 
      EndSelect 
    ForEver 
  EndIf 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = --
; EnableXP