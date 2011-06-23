; http://www.purebasic-lounge.de
; Author: Hroudtwolf (updated for PB 4.00 by Andre)
; Date: 24. November 2005
; OS: Windows
; Demo: No


Declare CreateKuchenSprite()

If InitSprite() = 0 Or InitKeyboard() = 0
  MessageRequester("Fehler", "Kann DirectX 7 oder höher nicht finden.", 0)
  End
EndIf

ExamineDesktops()
If OpenScreen(DesktopWidth(0), DesktopHeight(0), DesktopDepth(0), "Kuchen")
  CreateKuchenSprite()
  Repeat
    FlipBuffers()
    ClearScreen(RGB(0,0,0))
    DisplaySprite (1,100,100)
    ExamineKeyboard()
  Until KeyboardPushed(#PB_Key_Escape)
EndIf
End


Procedure CreateKuchenSprite()
  CreateSprite (1,600,600)
  hdc.l=StartDrawing (SpriteOutput (1))
  If hdc.l
    pen.l=CreatePen_(#PS_SOLID,2,RGB(255,255,255)); Pinsel erzeugen
    hPenOld.l=SelectObject_(hdc.l,pen.l); Dem Pinsel einen Devicekontext zuweisen
    Pie_(hdc.l,0,0,600,600,300,200,100,100); Kuchendiagramm
    Pie_(hdc.l,0,0,600,600,100,300,400,200); Kuchendiagramm
    DeleteObject_(pen.l); Pinselobjekt löschen
    DeleteObject_(hPenOld.l); "-"
    hBrush.l=CreateHatchBrush_(#HS_BDIAGONAL,RGB(200,0,150)); Eine Füllung erzeugen die mit  FillArea angewendet werden soll
    hFill.l=SelectObject_(hdc.l,hBrush.l)
    FillArea(220,100, RGB(255,255,255))
    DeleteObject_(hBrush.l)
    DeleteObject_(hFill.l)
    hBrush.l=CreateHatchBrush_(#HS_CROSS,RGB(0,200,0))
    hFill.l=SelectObject_(hdc.l,hBrush.l)
    FillArea(300,400, RGB(255,255,255))
    DeleteObject_(hBrush.l)
    DeleteObject_(hFill.l)
    StopDrawing ()
  EndIf
EndProcedure

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -