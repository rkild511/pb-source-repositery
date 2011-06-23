; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3528&highlight=
; Author: Danilo (updated for PB 4.00 by Andre)
; Date: 23. January 2004
; OS: Windows
; Demo: No


Procedure.f DSin(angle_in_degree.f)
  ; returns Sinus of 'angle in degree
  ProcedureReturn Sin(angle_in_degree*0.01745329)
EndProcedure

Procedure.f DCos(angle_in_degree.f)
  ; returns CoSinus of 'angle in degree
  ProcedureReturn Cos(angle_in_degree*0.01745329)
EndProcedure

Procedure Lin(hDC,x,y,x1,y1,width,Color)
  ; by einander, english forum
  pen=CreatePen_(#PS_SOLID,width,Color)  ; You can also change the style with #Ps_dash, #Ps_dot, #Ps_dashdotdot, but only when the pen width equals 1.
  hPenOld=SelectObject_(hDC,pen)
  MoveToEx_(hDC,x,y,0):LineTo_(hDC,x1,y1)
  DeleteObject_(SelectObject_(hDC,hPenOld))
EndProcedure


Procedure UpdateDisplay()
  date   = Date()
  second = Second(date)
  minute = Minute(date)
  sec.f  = (180-second*6)
  min.f  = (180-minute*6);-second/10
  std.f  = (180-Hour(date)*30)-minute/2

  hDC = StartDrawing(ImageOutput(1))
  If hDC
    Circle(125,125,95,$999999)
    Lin(hDC,125,125,125+DSin(std)*70,125+DCos(std)*70,10,0) ; hours
    Lin(hDC,125,125,125+DSin(min)*80,125+DCos(min)*80, 4,0) ; minutes
    LineXY( 125,125,125+DSin(sec)*90,125+DCos(sec)*90,   0) ; seconds
    StopDrawing()
  EndIf

  SetGadgetState(1,ImageID(1))

EndProcedure


Procedure InitImage()
  img = CreateImage(1,250,250)
  If img = 0
    MessageRequester("ERROR","Cant create image!",#MB_ICONERROR):End
  EndIf

  LoadFont(1,"Arial",14)
  If StartDrawing(ImageOutput(1))
    Box(0,0,250,250,GetSysColor_(#COLOR_BTNFACE))
    Circle(125,125,100,$999999)
    ForeGround = GetSysColor_(#COLOR_BTNTEXT)
    FrontColor(RGB(Red(ForeGround),Green(ForeGround),Blue(ForeGround)))
    DrawingMode(1)
    DrawingFont(FontID(1))
    DrawText(125-TextWidth("12")/2,4,"12")
    DrawText(10,115,"9")
    DrawText(230,115,"3")
    DrawText(125-TextWidth("6")/2,225,"6")
    For a = 0 To 360 Step 6
      sin.f = DSin(a)
      cos.f = DCos(a)
      Plot(125+sin*99,125+cos*99,0)
      If a % 10 = 0
        For b = 2 To 0 Step -1
          Plot(125+sin*(98-b),125+cos*(98-b),0)
        Next b
      EndIf
    Next a
    StopDrawing()
  EndIf

  ProcedureReturn img
EndProcedure



If OpenWindow(1,400,400,270,270,"Uhr",#PB_Window_SystemMenu)
  CreateGadgetList(WindowID(1))
  ImageGadget(1,10,10,250,250,InitImage())

  UpdateDisplay()

  SetTimer_(WindowID(1),0,1000,0) ; LowRes Timer with 1000 milliseconds (1s)

  Repeat
    Select WaitWindowEvent()
      Case #PB_Event_CloseWindow
        Quit = #True
      Case #WM_TIMER
        UpdateDisplay()
    EndSelect
  Until Quit

  KillTimer_(WindowID(1),0)

EndIf

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -