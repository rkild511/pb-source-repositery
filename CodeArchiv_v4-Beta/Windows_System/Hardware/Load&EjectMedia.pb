; German forum: http://www.purebasic.fr/german/viewtopic.php?t=7893
; Author: mk-soft
; Date: 15. April 2006
; OS: Windows
; Demo: No


; Open and close CD drive (also compatible with Windows 98)

;------------------------------------------------------------------------------ 

#VWIN32_DIOC_DOS_IOCTL     = 1 ; DOS IOCTL commands 
#VWIN32_DIOC_DOS_INT25     = 2 ; absolute disk Read 
#VWIN32_DIOC_DOS_INT26     = 3 ; absolute disk write 
#VWIN32_DIOC_DOS_INT13     = 4 ; INT 13 
#VWIN32_DIOC_DOS_DRIVEINFO = 6 ; Win95B Or later 

;#IOCTL_STORAGE_BASE               = %FILE_DEVICE_MASS_STORAGE 
#IOCTL_STORAGE_GET_MEDIA_TYPES    = $002D0C00 
#IOCTL_STORAGE_GET_MEDIA_TYPES_EX = $002D0C04 
#IOCTL_STORAGE_CHECK_VERIFY       = $002D4800 
#IOCTL_STORAGE_MEDIA_REMOVAL      = $002D4801 
#IOCTL_STORAGE_EJECT_MEDIA        = $002D4808 
#IOCTL_STORAGE_LOAD_MEDIA         = $002D480C 
#IOCTL_STORAGE_RESERVE            = $002D4810 
#IOCTL_STORAGE_RELEASE            = $002D4814 
#IOCTL_STORAGE_FIND_NEW_DEVICES   = $002D4818 
#IOCTL_STORAGE_RESET_BUS          = $002D5000 
#IOCTL_STORAGE_RESET_DEVICE       = $002D5004 



Structure DIOC_REGISTERS 
  regEBX.l 
  regEDX.l 
  regECX.l 
  regEAX.l 
  regEDI.l 
  regESI.l 
  regFlags.l 
EndStructure 

;------------------------------------------------------------------------------ 

Procedure.l LoadMedia(drive.s) 

  Protected hDisk.l 
  Protected fResult.l 
  Protected cb.l 
  Protected Regs.DIOC_REGISTERS 
  Protected bDisk.l 
  Protected *Pointer 
  
  *Pointer = 0 
  
  OS = OSVersion() 
  If OS = #PB_OS_Windows_95 Or OS = #PB_OS_Windows_98 Or OS = #PB_OS_Windows_ME 
    bDisk = (Asc(UCase(drive)) - 65) + 1 
    hDisk = CreateFile_("\\.\vwin32", 0, 0, *n1, 0, #FILE_FLAG_DELETE_ON_CLOSE, 0) 
    
    If hDisk = #INVALID_HANDLE_VALUE 
      Debug "WIN95 #INVALID_HANDLE_VALUE" 
      ProcedureReturn 0 
    EndIf 

    Regs\regEAX = $440D  ;eject media 
    Regs\regEBX = bDisk 
    Regs\regECX = $0849 

    fResult = DeviceIoControl_(hDisk, #VWIN32_DIOC_DOS_IOCTL, Regs, SizeOf(DIOC_REGISTERS), Regs, SizeOf(DIOC_REGISTERS), @cb, 0) 

    If (regs\regFlags And 1) = 1 
      fResult = 0 
    EndIf 
  Else 
    hDisk = CreateFile_("\\.\"+drive, #GENERIC_READ, 0, *n1, #OPEN_EXISTING, 0, @handle) 
    
    If hDisk = #INVALID_HANDLE_VALUE 
      Debug "WINNT #INVALID_HANDLE_VALUE" 
      ProcedureReturn 0 
    EndIf 
  
    fResult = DeviceIoControl_(hDisk, #IOCTL_STORAGE_LOAD_MEDIA, 0, 0, 0, 0, @cb, 0) 
  EndIf 

  CloseHandle_(hDisk) 

  ProcedureReturn fResult 
  
EndProcedure 

;------------------------------------------------------------------------------ 

Procedure.l EjectMedia(drive.s) 

  Protected hDisk.l 
  Protected fResult.l 
  Protected cb.l 
  Protected Regs.DIOC_REGISTERS 
  Protected bDisk.l 
  
  *Pointer = 0 
  
  OS = OSVersion() 
  If OS = #PB_OS_Windows_95 Or OS = #PB_OS_Windows_98 Or OS = #PB_OS_Windows_ME 
    bDisk = (Asc(UCase(drive)) - 65) + 1 
    hDisk = CreateFile_("\\.\vwin32", 0, 0, *n1, 0, #FILE_FLAG_DELETE_ON_CLOSE, 0) 
    
    If hDisk = #INVALID_HANDLE_VALUE 
      Debug "WIN95 #INVALID_HANDLE_VALUE" 
      ProcedureReturn 0 
    EndIf 

    Regs\regEAX = $440D  ;eject media 
    Regs\regEBX = bDisk 
    Regs\regECX = $0849 

    fResult = DeviceIoControl_(hDisk, #VWIN32_DIOC_DOS_IOCTL, Regs, SizeOf(DIOC_REGISTERS), Regs, SizeOf(DIOC_REGISTERS), @cb, 0) 

    If (regs\regFlags And 1) = 1 
      fResult = 0 
    EndIf 
  Else 
    hDisk = CreateFile_("\\.\"+drive, #GENERIC_READ, 0, *n1, #OPEN_EXISTING, 0, @handle) 
    
    If hDisk = #INVALID_HANDLE_VALUE 
      Debug "WINNT #INVALID_HANDLE_VALUE" 
      ProcedureReturn 0 
    EndIf 

    fResult = DeviceIoControl_(hDisk, #IOCTL_STORAGE_EJECT_MEDIA, 0, 0, 0, 0, @cb, 0) 
  EndIf 

  CloseHandle_(hDisk) 

  ProcedureReturn fResult 
  
EndProcedure 


Debug EjectMedia("F:") 

Delay(2000) 

Debug LoadMedia("F:") 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -