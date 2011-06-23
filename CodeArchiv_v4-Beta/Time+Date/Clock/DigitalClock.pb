; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2470&highlight=
; Author: Falko (optimized by Mischa, updated for PB4.00 by Falko)
; Date: 06. October 2003
; OS: Windows
; Demo: No

Global _AutoPen_OldPen_
Global _AutoPen_NewPen_
Procedure  Init()
  Global Dim ziffer.l(9,7)
  Restore ziffern
  For i=0 To 9:Read a:ziffer(i,0)=a:For t=1 To a:Read b:ziffer(i,t)=b:Next t:Next i
  Global Dim linie.l(7,4)
  Restore linien
  For i=1 To 7:For t=1 To 4:Read a:linie(i,t)=a:Next t:Next i
EndProcedure

Procedure AutoPen(hDC,Style,width,Color)
  If _AutoPen_OldPen_=0
    _AutoPen_OldPen_=GetCurrentObject_(hDC,#OBJ_PEN)
  EndIf
  If _AutoPen_NewPen_
    DeleteObject_(_AutoPen_NewPen_)
  EndIf
  _AutoPen_NewPen_=CreatePen_(Style,width,Color)
  SelectObject_(hDC,_AutoPen_NewPen_)
EndProcedure

Procedure EndPen(hDC)
  If _AutoPen_NewPen_
    DeleteObject_(_AutoPen_NewPen_)
  EndIf
  SelectObject_(hDC,_AutoPen_OldPen_)
  _AutoPen_OldPen_=0
EndProcedure

Procedure Digital(Zahl.l)
  If CreateImage(0,65,110)
    hDC=StartDrawing(ImageOutput(0))
    AutoPen(hDC, #PS_SOLID, Random(15) ,RGB(Random(255),Random(255),Random(255)))   
    For i=1 To ziffer(Zahl,0)
      LineXY(linie(ziffer(Zahl,i),1), linie(ziffer(Zahl,i),2), linie(ziffer(Zahl,i),3), linie(ziffer(Zahl,i),4)) 
    Next i
    EndPen(hDC)   
    StopDrawing()
  EndIf
EndProcedure

Init()
If OpenWindow(1,0,0,65,110 ,"DIGITS",#PB_Window_ScreenCentered|#PB_Window_SystemMenu|#PB_Window_BorderLess)
  If CreateGadgetList(WindowID(1))
    While Event<>#PB_Event_CloseWindow
      If GetTickCount_()-time > 500
        i=(i+1) % 10      ; Modula Operator need PureBasic v3.80+
        Digital(i)
        ImageGadget(0,0,0,65,110,ImageID(0))
        time=GetTickCount_()
      EndIf
      Delay(5)
      Event = WindowEvent()
    Wend
    CloseWindow(1)
  EndIf
EndIf
FreeImage(0)

; in der Datasection werden die einzelnen Segmente für die digitale Ziffer vorgegeben.

DataSection 
ziffern:
Data.l 6,1,2,3,6,7,5
Data.l 2,3,6
Data.l 5,1,3,4,5,7
Data.l 5,1,3,4,6,7
Data.l 4,2,4,3,6
Data.l 5,1,2,4,6,7
Data.l 6,1,2,4,5,6,7
Data.l 3,1,3,6
Data.l 7,1,2,3,4,5,6,7
Data.l 5,1,2,3,4,6
linien:
Data.l 10,10,50,10
Data.l 10,10,10,55
Data.l 50,10,50,55
Data.l 10,55,50,55
Data.l 10,55,10,100
Data.l 50,55,50,100
Data.l 10,100,50,100
EndDataSection

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
