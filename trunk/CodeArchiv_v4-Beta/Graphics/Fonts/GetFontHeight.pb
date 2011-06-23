; PureBasic IRC chat
; Author: DarkDragon (updated for PB 4.00 by Andre)
; Date: 24. March 2005
; OS: Windows, Linux
; Demo: Yes


; Multi-plattform code for a TextHeight() function, that checks the 'real' height of a font
; Multi-Plattform Code für eine TextHeight() Funktion, welcher die 'tatsächliche' Höhe eines Zeichensatzes ausgibt

Procedure ViewImage(Image)
  Win = OpenWindow(#PB_Any, 0, 0, ImageWidth(Image), ImageHeight(Image), "Image", #PB_Window_SystemMenu)
  CreateGadgetList(WindowID(Win))
  Gadget = ImageGadget(#PB_Any, 0, 0, ImageWidth(Image), ImageHeight(Image), ImageID(Image))
  Repeat
    Event = WindowEvent()
    If EventWindow() = Win And Event = #PB_Event_CloseWindow
      Quit = 1
    EndIf
    Delay(10)
  Until Quit = 1
  CloseWindow(Win)
EndProcedure
 
Procedure GetFontHeight(FontID, PtSize)
  PtSize * 1.5
  Img = CreateImage(#PB_Any, PtSize, PtSize)
  StartDrawing(ImageOutput(Img))
  DrawingFont(FontID)
  Box(0, 0, PtSize, PtSize, $FFFFFF)
  DrawText(0, 0, "M")
  For x=0 To PtSize-1
    For y=0 To PtSize-1
 
     Color = Point(x, y)
     If Color = $000000
       If y < MinY : MinY = y : EndIf
       If y > MaxY : MaxY = y : EndIf
     EndIf
 
    Next
  Next
  StopDrawing()
  ViewImage(Img)
  FreeImage(Img)
 
  ProcedureReturn MaxY-MinY
EndProcedure
 
LoadFont(0, "Staccato BT 222", 70)

MessageRequester("", "FontHeight = " + Str(GetFontHeight(FontID(0), 70)))
FreeFont(0)

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -