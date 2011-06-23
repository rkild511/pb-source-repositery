; English forum: http://www.purebasic.fr/english/viewtopic.php?t=9412&highlight=
; Author: Rings
; Date: 06. February 2004
; OS: Windows
; Demo: No

Enumeration 
  #USER_PRIV_GUEST 
  #USER_PRIV_USER 
  #USER_PRIV_ADMIN 
EndEnumeration 

*ui3.USER_INFO_3 
usr.s = Space(256) 
nsize = Len(usr.s) 
GetUserName_(@usr.s, @nsize) 
usrW.s = Space(512) 
Result=MultiByteToWideChar_(#CP_ACP, #MB_PRECOMPOSED, @usr.s, -1, @usrW.s, 512) 
lpBuf.l=0 
res.l = NetUserGetInfo_(0, @usrW.s, 3, @lpBuf) 
If res = 0 And lpBuf<>0 ;#nerr_success 
*ui3=lpBuf 
If *ui3\uName<>0 
  Buffer.s=Space(512) 
  Result=WideCharToMultiByte_(#CP_ACP ,0,*ui3\uName,255,@Buffer.s,512,0,0) 
  Debug Buffer.s 
EndIf 

Debug *ui3\privilege 
  ;If (ui3\privilege = #USER_PRIV_ADMIN) 
Debug *ui3\LastLogon 
If *ui3\HomeDir<>0 
  Buffer.s=Space(512) 
  Result=WideCharToMultiByte_(#CP_ACP ,0,*ui3\HomeDir,255,@Buffer.s,512,0,0) 
  Debug Buffer.s 
EndIf 
If *ui3\HomeDirDrive<>0 
  Buffer.s=Space(512) 
  Result=WideCharToMultiByte_(#CP_ACP ,0,*ui3\HomeDirDrive,255,@Buffer.s,512,0,0) 
  Debug Buffer.s 
EndIf 
If *ui3\FullName<>0 
  Buffer.s=Space(512) 
  Result=WideCharToMultiByte_(#CP_ACP ,0,*ui3\FullName,255,@Buffer.s,512,0,0) 
  Debug Buffer.s 
EndIf 
If *ui3\UserComment<>0 
  Buffer.s=Space(512) 
  Result=WideCharToMultiByte_(#CP_ACP ,0,*ui3\UserComment,255,@Buffer.s,512,0,0) 
  Debug Buffer.s 
EndIf 

Debug *ui3\PasswordAge 
Debug *ui3\CodePage 
Debug *ui3\LogonHours 

NetApiBufferFree_(lpBuf) 
EndIf 
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -