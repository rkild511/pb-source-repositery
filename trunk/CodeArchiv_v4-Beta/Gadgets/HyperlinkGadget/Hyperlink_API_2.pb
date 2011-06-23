; English forum:
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 21. January 2003
; OS: Windows
; Demo: No

;Hyperlink lame test
normalcursor = LoadCursor_(0,#IDC_ARROW)
mousecursor  = LoadCursor_(0,#IDC_CROSS) ; 32649) ; #IDC_HAND
 
 
Procedure windowproc(hwnd,msg,wParam,lParam)
Shared htext,hparent, hfnormal, hfmouse, highlighted, normalcursor, mousecursor
returnvalue = #PB_ProcessPureBasicEvents
Select msg
   Case #WM_LBUTTONDOWN
        If ChildWindowFromPoint_(hparent,lParam & $FFFF,lParam >> 16) = htext
           ;Beep_(800,100)
           ShellExecute_(hparent,"open","http:\\www.purebasic.com","","",#SW_SHOWNORMAL)
           returnvalue = 0
        EndIf
   Case #WM_MOUSEMOVE
        If ChildWindowFromPoint_(hparent,lParam & $FFFF,lParam >> 16) = htext
           ;SetCursor_(mousecursor)
           If highlighted = 0
              SetClassLong_(hparent, #GCL_HCURSOR, mousecursor)

              SendMessage_(htext,#WM_SETFONT,hfmouse,#True)
              highlighted = 1
              returnvalue = 0
           EndIf
        Else
           If highlighted = 1
              SendMessage_(htext,#WM_SETFONT,hfnormal,#True)
              SetClassLong_(hparent, #GCL_HCURSOR, normalcursor)
              ;SetCursor_(normalcursor)
              highlighted = 0
              returnvalue = 0
           EndIf
        EndIf
EndSelect 
ProcedureReturn returnvalue 
EndProcedure
 
 
hparent=OpenWindow(1,100,100,500,100,"Hyperlink Test",#PB_Window_SystemMenu)
CreateGadgetList(hparent)
htext=TextGadget(2,10,10,100,15,"Visit PureBasic",#PB_Text_Center) 
 
; prepare TextGadget
hfnormal = CreateFont_(15,0,0,0,  0,0,#True,0,0,0,0,0,0,"Verdana")
hfmouse  = CreateFont_(15,0,0,0,700,0,#True,0,0,0,0,0,0,"Verdana")
SendMessage_(htext,#WM_SETFONT,hfnormal,#True)
;SetClassLong_(htext,#GCL_HCURSOR,0)
 
 
SetWindowCallback(@windowproc())
 
Repeat
Until WaitWindowEvent()=#PB_Event_CloseWindow

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -