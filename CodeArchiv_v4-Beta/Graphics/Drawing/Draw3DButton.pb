; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6485&highlight=
; Author: ricardo (updated for PB4.00 by blbltheworm)
; Date: 11. June 2003
; OS: Windows
; Demo: Yes

Procedure CreateButton()
  MyImage = CreateImage(0, 255,255) ; create a new empty bitmap, retrieve handle
  StartDrawing(ImageOutput(0)) ; start drawing to the bitmap we created
  
  For H = 0 To 255
    For w = 0 To 255
      Blue1 = 255-H
      color = RGB(255,H,Blue1)
      color = RGB(0,60,60)
      Plot(w,H,color)
    Next w
  Next H
  
  ; change the value on the Variable named Valor to make the sphere smaller
  Valor = 60
  Dividendo = (255/Valor)
  For w = 0 To Valor
    Render  = (w*Dividendo)+50
    If Render > 255
      Render = 255
    ElseIf Render < 20
      Render = 20
    EndIf
    color = RGB(0,Render,Render)
    Radio = Valor - w
    Circle(125, 125, Radio, color)
  Next
  
  
  StopDrawing()
  SaveImage(0,"boton4.bmp",#PB_ImagePlugin_BMP)
  SetGadgetState(1,ImageID(0))
  ProcedureReturn 1
  
EndProcedure

If OpenWindow(0,100,150,450,300,"Test",#PB_Window_SystemMenu)
  CreateGadgetList(WindowID(0))
  ImageGadget(1,10,10,255,255,0)
  ButtonGadget(2,300,100,50,25,"Test")
  Repeat
    EventID=WaitWindowEvent()
    
    Select EventID
      
    Case #PB_Event_Gadget
      Select EventGadget()
      Case 2
        CreateButton()
      EndSelect
      
    EndSelect
    
  Until EventID=#PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
