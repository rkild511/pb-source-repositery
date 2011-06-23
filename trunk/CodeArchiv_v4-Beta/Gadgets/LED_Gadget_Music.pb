; English forum: http://www.purebasic.fr/english/viewtopic.php?t=15056
; Author: localmotion34 (updated for PB 4.00 by Andre)
; Date: 11. May 2005
; OS: Windows, Linux
; Demo: Yes

; LED-Gadget
; Ok, this now has the different colours as it goes up, it also has the ability To get the current state of it
; Dance To the music!

Structure gauge
  imagegad.l
  imageid.l
  width.l
  height.l
  imagehwnd.l
  precision.l
  ticks.l
  frontcol.l
  backcol.l
  cpercent.l
EndStructure

Global NewList led.gauge()


ProcedureDLL setLEDfcol(led,col)
  SelectElement(led(),led)
  led()\frontcol = col
EndProcedure

ProcedureDLL setLEDbcol(led,col)
  SelectElement(led(),led)
  led()\backcol = col
EndProcedure


ProcedureDLL LEDgadget(number,x,y,width,height,display)
  AddElement(led())
  SelectElement(led(),number)
  led()\width=width
  led()\height=height
  led()\imageid=CreateImage(#PB_Any,led()\width,led()\height)
  StartDrawing(ImageOutput(led()\imageid))
  Box(0,0,led()\width,led()\height,#Black)
  ledheight=led()\height-20
  boxwidth=(led()\width-10-1)/2
  secondx= 6+boxwidth
  tickcount=0
  For a=0 To led()\height-20 Step 4
    tickcount=tickcount+1
    Box(5,a,boxwidth,3,led()\backcol)
    Box(secondx,a,boxwidth,3,led()\backcol)
  Next
  led()\ticks=tickcount
  BackColor(RGB(0,0,0))
  FrontColor(RGB(0, $FF, 0))
  DrawText((led()\width/2)-10, led()\height-15, "0%")
  StopDrawing()
  led()\imagegad=ImageGadget(#PB_Any,x,y,width,height,ImageID(led()\imageid),#PB_Image_Border)
  ProcedureReturn led()\imagegad
EndProcedure

ProcedureDLL setLEDstate(led,percent)
  SelectElement(led(),led)
  led()\cpercent = percent
  tickcount=led()\ticks
  perc.f=100/led()\ticks
  percents.f=(percent/100)
  finalpercent.f=percents*tickcount
  stringpercent.s=StrF(finalpercent)
  Result.f = Round(finalpercent, 1)
  finalresult=led()\ticks-Result
  ledheight=led()\height-20
  boxwidth=(led()\width-10-1)/2
  secondx=6+boxwidth
  StartDrawing(ImageOutput(led()\imageid))
  tickcount=0
  For a=0 To led()\height-20 Step 4
    tickcount=tickcount+1
    If tickcount>=finalresult
      Box(5,a,boxwidth,3,led()\frontcol)
      Box(secondx,a,boxwidth,3,led()\frontcol)
    Else
      Box(5,a,boxwidth,3,led()\backcol)
      Box(secondx,a,boxwidth,3,led()\backcol)
    EndIf
  Next
  Box(0,led()\height-15,led()\width,15,#Black)
  BackColor(RGB(0,0,0))
  FrontColor(RGB(0, $FF, 0))
  DrawText((led()\width/2)-10, led()\height-15, Str(percent)+"%")
  StopDrawing()
  SetGadgetState(led()\imagegad,ImageID(led()\imageid))
EndProcedure

ProcedureDLL getLEDstate(led)
  SelectElement(led(),led)
  ProcedureReturn led()\cpercent
EndProcedure

ProcedureDLL Beep(freq.l, time.l)
  n.f = (freq/1000)*100
  setLEDfcol(0, RGB(n.f*2.5, 250-(n.f*2.5), 0))
  setLEDstate(0, n.f)
  Beep_(freq, time)
EndProcedure

ProcedureDLL StartBeep(times)
  tempo=180
  For t=1 To times
    Beep(284,tempo)
    Beep(568,tempo)
    Beep(426,tempo)
    Beep(379,tempo)
    Beep(758,tempo)
    Beep(426,tempo)
    Beep(716,tempo)
    Beep(426,tempo)

    Beep(284,tempo)
    Beep(568,tempo)
    Beep(426,tempo)
    Beep(379,tempo)
    Beep(758,tempo)
    Beep(426,tempo)
    Beep(716,tempo)
    Beep(426,tempo)

    Beep(319,tempo)
    Beep(568,tempo)
    Beep(426,tempo)
    Beep(379,tempo)
    Beep(758,tempo)
    Beep(426,tempo)
    Beep(716,tempo)
    Beep(426,tempo)

    Beep(319,tempo)
    Beep(568,tempo)
    Beep(426,tempo)
    Beep(379,tempo)
    Beep(758,tempo)
    Beep(426,tempo)
    Beep(716,tempo)
    Beep(426,tempo)

    Beep(379,tempo)
    Beep(568,tempo)
    Beep(426,tempo)
  Next t
EndProcedure

#WindowWidth  = 390
#WindowHeight = 350
If OpenWindow(0, 100, 200, #WindowWidth, #WindowHeight, "", #PB_Window_MinimizeGadget)
  If CreateGadgetList(WindowID(0))
    led=LEDgadget(0,50,50,75,200,0)
    setLEDbcol(0, RGB(45,60,45))
    StartBeep(2)
  EndIf

  Repeat

    EventID = WaitWindowEvent()

    If EventID = #PB_Event_Gadget

      Select EventGadget()
        Case led

      EndSelect

    EndIf

  Until EventID = #PB_Event_CloseWindow

EndIf

End
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = --