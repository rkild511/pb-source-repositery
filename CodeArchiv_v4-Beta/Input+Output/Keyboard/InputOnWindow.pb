; English forum: http://www.purebasic.fr/english/viewtopic.php?t=9170&highlight=
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 16. January 2004
; OS: Windows
; Demo: No


; Input text in the window (here using an ImageGadget):
; If its for windows only...

; Dont draw on the window directly, use an ImageGadget instead. 
; The ImageGadget is automatically updated, so no need to repaint 
; it 100 times a second or when the window was moved out of screen. 
; Just update/redraw your image and refresh the ImageGadget 
; with SetGadgetState(#ImageGadget,UseImage(#Image)).

Global InputString$ 

#InputString_Length = 20 

Procedure UpdateString(char) 
  If char > 31 And char < 128 
    InputString$ + Chr(char) 
  ElseIf char = 8  ; BACKSPACE 
    If InputString$ 
      InputString$ = Left(InputString$,Len(InputString$)-1) 
    EndIf 
  ElseIf char = 13 ; Return 
    MessageRequester("INFO","Input String:"+Chr(13)+InputString$) 
    ProcedureReturn 0 
  EndIf 
  InputString$ = Left(InputString$,#InputString_Length) ; limit length 
  StartDrawing( ImageOutput(1) ) 
    Box(0,0,300,300,GetSysColor_(#COLOR_BTNFACE));RGB($13,$66,$D3)) 
    TextColor = GetSysColor_(#COLOR_BTNTEXT) 
    FrontColor(RGB(Red(TextColor),Green(TextColor),Blue(TextColor))) 
    DrawingMode(1) 
    SetCaretPos_(10+TextWidth(InputString$),10) 
    DrawText(10,10,InputString$) 
  StopDrawing() 
  SetGadgetState(0,ImageID(1)) 
EndProcedure 

Procedure WinProc(hWnd,Msg,wParam,lParam) 
  result = #PB_ProcessPureBasicEvents 
  Select Msg 
    Case #WM_CHAR 
      UpdateString(wParam) 
  EndSelect 
  ProcedureReturn result 
EndProcedure 

CreateImage(1,300,300) 

OpenWindow(0,0,0,300,300,"Input",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) 
  CreateGadgetList(WindowID(0)) 
  ImageGadget(0,0,0,300,300,ImageID(1)) 
  SetWindowCallback(@WinProc()) 
  
  ; optional caret 
  CreateCaret_(WindowID(0),0,2,16):ShowCaret_(WindowID(0)) 

  ; draw it 
  UpdateString(0) 

Repeat:Until WaitWindowEvent()=#PB_Event_CloseWindow

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
