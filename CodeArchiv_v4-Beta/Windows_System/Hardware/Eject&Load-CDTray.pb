; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2789&highlight=
; Author: Andreas
; Date: 10. November 2003
; OS: Windows
; Demo: No

  ;Eject & Load CDTray 
  ;################### 
  ;NT, XP & W2K 
  ;################### 
  
  #IOCTL_STORAGE_EJECT_MEDIA  = $2D4808 
  #IOCTL_STORAGE_LOAD_MEDIA   = $2D480C 


  Procedure EjectCD(LW.s) 
    Protected hLwStatus.l 
    hLwStatus = CreateFile_("\\.\"+LW,#GENERIC_READ|#GENERIC_WRITE, 0, 0, #OPEN_EXISTING, 0, 0) 
    If hLwStatus 
      DeviceIoControl_(hLwStatus,#IOCTL_STORAGE_EJECT_MEDIA,0,0,0,0,@Ret,0) 
      CloseHandle_(hLwStatus) 
    EndIf 
  EndProcedure  

  Procedure LoadCD(LW.s) 
    Protected hLwStatus.l 
    hLwStatus = CreateFile_("\\.\"+LW,#GENERIC_READ|#GENERIC_WRITE, 0, 0, #OPEN_EXISTING, 0, 0) 
    If hLwStatus 
      DeviceIoControl_(hLwStatus,#IOCTL_STORAGE_LOAD_MEDIA,0,0,0,0,@Ret,0) 
      CloseHandle_(hLwStatus) 
    EndIf 
  EndProcedure  
  
  EjectCD("G:") 
  LoadCD("G:")
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
