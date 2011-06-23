; German forum: 
; Author: Unknown (improved + updated for PB 4.00 by Andre)
; Date: 21. December 2003
; OS: Windows
; Demo: Yes
;
; ------------------------------------------------------------
;
;   3D Balken Demo
;
;
; ------------------------------------------------------------
;

Procedure Balken(ImageID, titel$, spalte1.l, zeile1.l, wert.f)
  wert1.f
  spalte2.l
  spalte3.l
  zeile4.l
  swert1.s
  Fontid.l = LoadFont(1, "ARIAL", 20, #PB_Font_HighQuality)
  Fontid2.l = LoadFont(1, "ARIAL", 16, #PB_Font_HighQuality)
  StartDrawing(ImageOutput(ImageID))
    If wert = 0
      StopDrawing()
      ProcedureReturn
    EndIf
    Box(0,0,600,400,RGB(255,255,255))
    wert1 = wert
    wert = 370 - (wert * 25)
    spalte2 = spalte1 + 25
    spalte3 = spalte1 + 40
    zeile4  = wert - 18
    LineXY(spalte1, zeile1, spalte2, zeile1)
    LineXY(spalte2, zeile1, spalte3, zeile1 - 18)
    LineXY(spalte1, zeile1, spalte1, wert)
    LineXY(spalte2, zeile1, spalte2, wert)
    LineXY(spalte3, zeile1 - 18, spalte3, zeile4)
    LineXY(spalte1, wert, spalte2, wert)
    LineXY(spalte2, wert, spalte3, zeile4)
    LineXY(spalte3, zeile4, spalte2 - 7, zeile4)
    LineXY(spalte2 - 7, zeile4, spalte1, wert)
    FillArea(spalte1 + 2, zeile1 - 1, RGB(0, 0, 0), RGB(0,100,150))
    FillArea(spalte2 + 1, zeile1 - 2, RGB(0, 0, 0), RGB(0,150,250))
    FillArea(spalte1 + 5, wert - 1,   RGB(0, 0, 0), RGB(0,250,250))
    swert1 = StrF(wert1)
    FrontColor(RGB(200, 0, 0))
    DrawingFont(Fontid)
    If swert1 = "0.00"
      swert1 = " K.A."
    EndIf
    DrawText(spalte1 + 5, zeile4 - 20, swert1)
    FrontColor(RGB(0, 0, 0))
    DrawingFont(Fontid2)
    DrawText(spalte1, zeile1 + 2, titel$)
  StopDrawing()
EndProcedure

If OpenWindow(0, 100, 200, 600, 400, "2D Drawing Test", #PB_Window_SystemMenu)

  ; Create an offscreen image, with a green circle in it.
  ; It will be displayed later
  ;
  CreateImage(0,500,400)
  Balken(0, "Titel",100,310,12.65)
  StartDrawing(WindowOutput(0))
  DrawImage(ImageID(0),10,10)
  StopDrawing()

  Delay(1500)

  Repeat

    EventID.l = WaitWindowEvent()

    If EventID = #PB_Event_Repaint
      Balken(0, "2000",320,330,6.65)
      StartDrawing(WindowOutput(0))
      DrawImage(ImageID(0),10,10)
      StopDrawing()

    EndIf

  Until EventID = #PB_Event_CloseWindow

EndIf

End

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP