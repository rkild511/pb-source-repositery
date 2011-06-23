; English forum: 
; Author: Unknown (updated for PB 4.00 by Andre)
; Date: 31. December 2002
; OS: Windows
; Demo: No

msg.MSG
wc.WNDCLASSEX

hinst=GetModuleHandle_(0)
classname$="mywndpbclass003"

Procedure ExecuteTest()
  Shared hwed,hwst
  SendMessage_(hwst,#WM_SETTEXT,0,"Please Wait .")
    
  StartTimer.l = GetTickCount_()
    
  For LoopFor1.l = 1 To 10000000
    Result1.f=((100000 * 100) / 1000) + Sqr(4)
    Result2.f=((100000 * 100) / 1000) + Sqr(4)
    Result3.f=((100000 * 100) / 1000) + Sqr(4)
    Result4.f=((100000 * 100) / 1000) + Sqr(4)
  
    Result1=((100000 * 100) / 1000) + Sqr(4)
    Result2=((100000 * 100) / 1000) + Sqr(4)
    Result3=((100000 * 100) / 1000) + Sqr(4)
    Result4=((100000 * 100) / 1000) + Sqr(4)
  
    If LoopFor1 = 100000
      SendMessage_(hwst,#WM_SETTEXT,0,"Please Wait .")
    ElseIf LoopFor1 = 1000000
      SendMessage_(hwst,#WM_SETTEXT,0,"Please Wait .")
    ElseIf LoopFor1 = 10000000
      SendMessage_(hwst,#WM_SETTEXT,0,"Please Wait .")
    EndIf
  Next LoopFor1
  
  SendMessage_(hwed,#WM_SETTEXT,0,"Result:" + Str(Result1 + Result2))
   
  ElapsedTime.l = GetTickCount_()-StartTimer

  SendMessage_(hwst,#WM_SETTEXT,0,"Elapsed: " + Str(ElapsedTime) +  " ms")
EndProcedure

Procedure windowproc(hwnd,msg,wparam,lparam)
Select msg
  Case #WM_COMMAND
    Select wparam
      Case 2
        ExecuteTest()
        
      Case 4
        PostQuitMessage_(0)
    EndSelect
    retval=0

  Case #WM_CLOSE
    PostQuitMessage_(0)
    retval=0

  Default
    FakeEndSelect : ProcedureReturn DefWindowProc_(hwnd,msg,wparam,lparam)
EndSelect
ProcedureReturn retval
EndProcedure

wc\cbSize=SizeOf(WNDCLASSEX)
wc\style=#CS_HREDRAW|#CS_VREDRAW
wc\lpfnWndProc=@windowproc()
wc\cbClsExtra=0
wc\cbWndExtra=0
wc\hInstance=hinst
wc\hIcon=0
wc\hCursor=LoadCursor_(#Null,#IDC_ARROW)
wc\hbrBackground=GetSysColorBrush_(#COLOR_MENU)
wc\lpszMenuName=#Null
wc\lpszClassName=@classname$
wc\hIconSm=0

RegisterClassEx_(@wc)

hwmain=CreateWindowEx_(0,classname$,"Test Speed PureBasic",#WS_SYSMENU,224,172,205,90,0,#Null,hinst,0)
hwed=CreateWindowEx_(#WS_EX_CLIENTEDGE,"Edit","",#WS_CHILD|#WS_VISIBLE,4,4,128,20,hwmain,1,hinst,0)
hwbt1=CreateWindowEx_(0,"Button","Begin",#WS_CHILD|#WS_VISIBLE|#BS_PUSHBUTTON,136,4,60,20,hwmain,2,hinst,0)
hwst=CreateWindowEx_(0,"Static","Elapsed: 0",#WS_CHILD|#WS_VISIBLE,4,28,128,16,hwmain,3,hinst,0)
hwbt2=CreateWindowEx_(0,"Button","Exit",#WS_CHILD|#WS_VISIBLE|#BS_PUSHBUTTON,136,28,60,20,hwmain,4,hinst,0)

ShowWindow_(hwmain,#SW_SHOWNORMAL)
UpdateWindow_(hwmain)

While GetMessage_(@msg,#Null,0,0)
  TranslateMessage_(@msg)
  DispatchMessage_(@msg)
Wend

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger