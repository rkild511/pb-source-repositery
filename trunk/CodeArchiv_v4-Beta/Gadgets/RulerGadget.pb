; English forum: http://www.purebasic.fr/english/viewtopic.php?t=13347&highlight=
; Author: localmotion34 (updated for PB 4.00 by Andre)
; Date: 10. December 2004
; OS: Windows
; Demo: Yes


; Here is a gadget i am working on that will extend the functionality of PB drawing
; image and graphics. not much right now, but i am planning a rulered canvas and
; rulered imagegadget. this is just a preliminary release to get some input on
; methods and functionality as well as suggestions.

#pb_rulerH=$33333333
#pb_rulerV=$33333334
#Pb_rulerL=$33333335

Procedure rulergadget(number,x,y,width,flags)
  If flags=#Pb_rulerL
    LoadFont(2, "test", 7)
    ruler=CreateImage(#PB_Any,width,33)
    StartDrawing(ImageOutput(ruler))
    Box(0,0,width,33,#White)
    DrawingMode(4)
    Box(0,0,width,33,0)
    For c=b+10 To b+90 Step 10
      LineXY(c,0,c,6,0)
      LineXY(c,33,c,27,0)
    Next
    For a=100 To width Step 100
      LineXY(a,0,a,10,0)
      DrawingFont(FontID(2))
      DrawText(a-7, 11, Str(a))
      LineXY(a,33,a,23,0)
      b=a
      For c=b+10 To b+90 Step 10
        LineXY(c,0,c,6,0)
        LineXY(c,33,c,27,0)
      Next
    Next
    StopDrawing()
    temp=ImageGadget(#PB_Any,x,y,width,33,ImageID(ruler))
    ruler1=CreateImage(#PB_Any,33,width)
    StartDrawing(ImageOutput(ruler1))
    Box(0,0,33,width,#White)
    DrawingMode(4)
    Box(0,0,33,width,0)
    For a=100 To width Step 100
      LineXY(0,a,7,a)
      DrawingFont(FontID(2))
      DrawText(11, a-4, Str(a))
      LineXY(33,a,27,a)
      For c=0 To 90 Step 10
        LineXY(0,c,6,c)
        LineXY(33,c,27,c)
      Next
      b=a
      For c=b+10 To b+90 Step 10
        LineXY(0,c,6,c)
        LineXY(33,c,27,c)
      Next
    Next
    StopDrawing()
    temp1=ImageGadget(#PB_Any,x-33,y+33,33,width,ImageID(ruler1))
    toggleb=ButtonGadget(#PB_Any,x-33,y,33,33,"",#PB_Button_Toggle)
    ProcedureReturn toggleb
  ElseIf flags=#pb_rulerH
    LoadFont(2, "test", 7)
    ruler=CreateImage(#PB_Any,width,33)
    StartDrawing(ImageOutput(ruler))
    Box(0,0,width,33,#White)
    DrawingMode(4)
    Box(0,0,width,33,0)
    For c=b+10 To b+90 Step 10
      LineXY(c,0,c,6,0)
      LineXY(c,33,c,27,0)
    Next
    For a=100 To width Step 100
      LineXY(a,0,a,10,0)
      DrawingFont(FontID(2))
      DrawText(a-7, 11, Str(a))
      LineXY(a,33,a,23,0)
      b=a
      For c=b+10 To b+90 Step 10
        LineXY(c,0,c,6,0)
        LineXY(c,33,c,27,0)
      Next
    Next
    StopDrawing()
    temp=ImageGadget(#PB_Any,x,y,width,33,ImageID(ruler))
  ElseIf flags=#pb_rulerV
    LoadFont(2, "test", 7)
    ruler1=CreateImage(#PB_Any,33,width)
    StartDrawing(ImageOutput(ruler1))
    Box(0,0,33,width,#White)
    DrawingMode(4)
    Box(0,0,33,width,0)
    For a=100 To width Step 100
      LineXY(0,a,7,a)
      DrawingFont(FontID(2))
      DrawText(11, a-4, Str(a))
      LineXY(33,a,27,a)
      For c=0 To 90 Step 10
        LineXY(0,c,6,c)
        LineXY(33,c,27,c)
      Next
      b=a
      For c=b+10 To b+90 Step 10
        LineXY(0,c,6,c)
        LineXY(33,c,27,c)
      Next
    Next
    StopDrawing()
    temp1=ImageGadget(#PB_Any,x,y,33,width,ImageID(ruler1))
  EndIf
EndProcedure

If OpenWindow(0,0,0,645,605,"RulerGadget",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) And CreateGadgetList(WindowID(0))
  test=rulergadget(1,60,20,550,#Pb_rulerL)


EndIf
Repeat
  event=WaitWindowEvent()
  Select event
    Case #PB_Event_Gadget
      Select EventGadget()

    EndSelect
    Case #PB_Event_CloseWindow
      End
  EndSelect
ForEver

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -