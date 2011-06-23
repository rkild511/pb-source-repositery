; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2851&highlight=
; Author: Danilo (posted by Rings)
; Date: 18. November 2003
; OS: Windows
; Demo: No

; Please note, that the window name "PureBasic - Debug Output" must be updated to 
; its real name, else the saving of debug output will not work!

Procedure SaveDebugTextCallback(hWnd,Value) 
  ClassName$ = Space(100) 
  GetClassName_(hWnd,@ClassName$,100) 
  If ClassName$ = "ListBox" 
     Count = SendMessage_(hWnd,#LB_GETCOUNT,0,0) 
     If Count = 0 
        MessageRequester("DEBUG SAVE","No Data in Debug Output",#MB_ICONINFORMATION) 
     Else 
        If OpenFile(1,PeekS(Value)) 
           FileSeek(1,Lof(1)) 
           WriteStringN(1,";---[ New Entry ]-------") 
           GetLocalTime_(time.SYSTEMTIME) 
           WriteStringN(1,"; - Date: "+StrU(time\wDay,1)+"."+StrU(time\wMonth,1)+"."+StrU(time\wYear,1)) 
           WriteStringN(1,"; - Time: "+StrU(time\wHour,1)+":"+StrU(time\wMinute,1)) 
            For a = 0 To Count - 1 
                Length = SendMessage_(hWnd,#LB_GETTEXTLEN,a,0) 
                Text$   = Space(Length) 
                SendMessage_(hWnd,#LB_GETTEXT,a,@Text$) 
                WriteStringN(1,"  | "+Text$) 
            Next a 
           WriteStringN(1,";---[ End Entry ]-------") 
           WriteStringN(1,"") 
           CloseFile(1) 
           MessageRequester("DEBUG SAVE","Saved Debugger Output to:"+Chr(13)+PeekS(Value),#MB_ICONINFORMATION) 
        Else 
           MessageRequester("DEBUG SAVE","Couldnt save Debug Output",#MB_ICONERROR) 
        EndIf 
     EndIf 
  EndIf 
ProcedureReturn 1 
EndProcedure 


Procedure SaveDebugOutput(File$) 
hDebug = FindWindow_(0,"PureBasic - Debug Output") 
If hDebug 
   EnumChildWindows_(hDebug,@SaveDebugTextCallback(),@File$) 
Else 
   MessageRequester("DEBUG SAVE","Debugger Disabled or different Window name!",#MB_ICONERROR) 
EndIf 
EndProcedure 
  
  
; Code Start 

SaveDebugOutput("c:\PB_DEBUG.TXT") 
Debug "TEST" 
Debug Str(12)+" PureBasic Debug" 
Debug "testing..." 
Debug 123456 
SaveDebugOutput("c:\PB_DEBUG.TXT") 



; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
