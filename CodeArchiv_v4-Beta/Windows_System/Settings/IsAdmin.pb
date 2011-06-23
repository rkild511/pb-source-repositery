; English forum: http://www.purebasic.fr/english/viewtopic.php?t=9412&highlight=
; Author: Anden
; Date: 06. February 2004
; OS: Windows
; Demo: No

#NERR_SUCCESS = 0 
#USER_PRIV_ADMIN = 2 

Procedure IsAdmin() 
  Result.l = #False 
  ui3.USER_INFO_3 
  usr$ = Space(256) 
  nsize = Len(usr$) 
  GetUserName_(@usr$, @nsize) 
  usrW$ = Space(512) 
  MultiByteToWideChar_(#CP_ACP, #MB_PRECOMPOSED, @usr$, -1, @usrW$, Len(usrW$)) 
  If (NetUserGetInfo_(#Null, @usrW$, 3, @lpBuf.l) = #NERR_SUCCESS) 
    CopyMemory(lpBuf, @ui3, SizeOf(ui3)) 
    If (ui3\privilege = #USER_PRIV_ADMIN) : Result = #True : EndIf 
    NetApiBufferFree_(lpBuf) 
  EndIf 
  ProcedureReturn Result 
EndProcedure 

Debug IsAdmin()

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -