; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2922&highlight=
; Author: [m]Inferno  (improved by ChaOsKid, updated for PB4.00 by blbltheworm)
; Date: 24. November 2003
; OS: Windows
; Demo: Yes

;********************** Variablendeklaration ********************* 
#CurrentVersion = "0.4.3b" 

Global WindowSize.RECT, Quit.l 

;********************** Bekanntmachen der Funktionen ********************** 

Declare.b OpenImage(ImagePath.s) 
Declare CloseImage() 
Declare.b SaveImageAs(NewImagePath.s, FormatFlag.s, Compression.b) 
Declare.b GetColorDepth() 
Declare.l GetImageHeight() 
Declare.l GetImageWidth() 
Declare.s GetVersion() 

OpenImage(OpenFileRequester("","","(jpeg)|*.jpg",1)) 
  
;**************************** Funktionen ********************************* 
Procedure Events(Event.l) 
  Select Event 
    Case #PB_Event_CloseWindow 
      ;Programm beenden 
      Quit = 1 
    Case #WM_KEYDOWN 
      ;Eine Taste wurde gedrückt 
      Select EventwParam() 
        ;Escape (27) 
        Case 27 
          Quit = 1 
      EndSelect 
  EndSelect 
EndProcedure 
; 
Procedure WinCallback(hwnd,msg,wParam,lParam) 
  Select msg 
    Case #WM_SIZE 
      Debug "WM_SIZE" 
    Case #WM_MOVE 
      Debug "WM_MOVE" 
    Case #PB_Event_Repaint 
      StartDrawing(WindowOutput(105)) 
      DrawImage(ImageID(0), 0, 0) 
      StopDrawing() 
      Debug "PB_Event_Repaint" 
  EndSelect 
  ProcedureReturn #PB_ProcessPureBasicEvents 
EndProcedure 
; 
Procedure.b OpenImage(ImagePath.s) 
  UseJPEGImageDecoder() 
  If LoadImage(0, ImagePath) <> 0 
    Handle.l = OpenWindow(105, 0, 0, ImageWidth(0), ImageHeight(0), ImagePath + " (" + Str(ImageWidth(0)) + "x" + Str(ImageHeight(0)) + "x" + Str(ImageDepth(0)) + " Bit)", #PB_Window_TitleBar | #PB_Window_SizeGadget | #PB_Window_MaximizeGadget | #PB_Window_MinimizeGadget) 
    SetWindowCallback(@WinCallback()) 
    StartDrawing(WindowOutput(105)) 
    DrawImage(ImageID(0), 0, 0) 
    StopDrawing() 
    Repeat 
      Events(WaitWindowEvent()) 
    Until Quit 
    ProcedureReturn 1 
  Else 
    ProcedureReturn -1 
  EndIf 
EndProcedure 

Procedure CloseImage() 
  FreeImage(0) 
  CloseWindow(105) 
EndProcedure 

Procedure.b SaveImageAs(NewImagePath.s, FormatFlag.s, Compression.b) 
  If FormatFlag = "bmp" 
    If SaveImage(0, NewImagePath, #PB_ImagePlugin_BMP) <> 0 
      ProcedureReturn 1 
    Else 
      ProcedureReturn -1 
    EndIf 
  ElseIf FormatFlag = "jpg" 
    UseJPEGImageEncoder() 
    If SaveImage(0, NewImagePath, #PB_ImagePlugin_JPEG, Compression) <> 0 
      ProcedureReturn 1 
    Else 
      ProcedureReturn -1 
    EndIf 
  ElseIf FormatFlag = "png" 
    UsePNGImageEncoder() 
    If SaveImage(0, NewImagePath, #PB_ImagePlugin_PNG) 
      ProcedureReturn 1 
    Else 
      ProcedureReturn -1 
    EndIf 
  EndIf 
  ProcedureReturn -1 
EndProcedure 

Procedure.b GetColorDepth() 
  ProcedureReturn ImageDepth(0) 
EndProcedure 

Procedure.l GetImageHeight() 
  ProcedureReturn ImageHeight(0) 
EndProcedure 

Procedure.l GetImageWidth() 
  ProcedureReturn ImageWidth(0) 
EndProcedure 

Procedure.s GetVersion() 
  ProcedureReturn #CurrentVersion 
EndProcedure

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = --
; EnableXP
