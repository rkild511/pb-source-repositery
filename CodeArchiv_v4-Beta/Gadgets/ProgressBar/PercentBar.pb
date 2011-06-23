; German forum: http://www.purebasic.fr/german/viewtopic.php?t=2126&highlight=
; Author: sverson (updated for PB 4.00 by Andre)
; Date: 19. February 2005
; OS: Windows
; Demo: No


; A slightly other progressbar with percent display
; Eine etwas andere Progressbar mit einer Prozentanzeige über dem Balken.

;PercentBar
;2005 by Hroudtwolf
;Progressbar with percentdisplay
;
Declare Setpercents (gadget.l,position.l,gadgetreturn$)
Declare.s PercentbarGadget (gadget.l,x.l,y.l,pcwidth.l,pcheigth.l,max.l)

hWnd.l = OpenWindow(0, 100, 100, 300, 60, "PercentBar", #PB_Window_SystemMenu|#PB_Window_TitleBar|#PB_Window_ScreenCentered)
If hwnd.l
  If CreateGadgetList (hwnd.l)
    info$=PercentbarGadget (1,10,20,280,20,40); PercentGadget erstellen
  EndIf
  Repeat
    EventID.l = WindowEvent()
    Setpercents (1,xx,info$); Das PercentGadget aktualisieren
    xx=xx+1
    If xx>40:xx=0:EndIf
    Delay(100)
  Until EventID = #PB_Event_CloseWindow

EndIf
End


Procedure.s PercentbarGadget (gadget.l,x.l,y.l,pcwidth.l,pcheight.l,max.l)
  gadgetreturn$=Str(pcwidth.l)+"|"+Str(pcheight.l)+"|"+Str(max.l)
  Setpercents (gadget.l,0,gadgetreturn$)
  ImageGadget (gadget.l,x.l,y.l,pcwidth.l,pcheigth.l, ImageID (800+gadget.l))
  ProcedureReturn gadgetreturn$
EndProcedure


Procedure Setpercents (gadget.l,position.l,gadgetreturn$)
  pcwidth.l=Val(StringField(gadgetreturn$, 1, "|"))
  pcheight.l=Val(StringField(gadgetreturn$, 2, "|"))
  max.l=Val(StringField(gadgetreturn$, 3, "|"))
  ;Prozentberechnung
  onepercent.f=max/100
  If onepercent.f=0:onepercent.f=1:EndIf
  percent.l=position.l/onepercent.f

  ;Systemfarben ermitteln
  HFarbe.l=GetSysColor_(#COLOR_BTNFACE )
  RFarbe1.l=GetSysColor_(#COLOR_3DHIGHLIGHT)
  RFarbe2.l=GetSysColor_(#COLOR_3DSHADOW)
  TFarbe.l=GetSysColor_(#COLOR_BTNTEXT )
  ;Gadgetstyle erstellen
  If IsImage (800+gadget.l)=0:CreateImage (800+gadget.l,pcwidth.l,pcheight.l):EndIf
  If StartDrawing (ImageOutput (800+gadget))
    DrawingMode(0)
    Box (0,0,pcwidth.l,pcheight.l,HFarbe.l)
    Line (0,0,0,pcheight.l,RFarbe2.l)
    Line (0,0,pcwidth.l,0,RFarbe2.l)
    Line (0,pcheight.l-1,pcwidth.l,0,RFarbe1.l)
    Line (pcwidth.l-1,0,0,pcheight.l,RFarbe1.l)
    Box (1,1,((pcwidth.l*position)/max)-2,pcheight.l-2,RGB(100,100,250))
    For x=10 To pcwidth.l-10 Step 10
      Line (x,1,0,pcheight.l-2,HFarbe.l)
    Next x
    DrawingMode(1)
    rot.l=Red(TFarbe.l)
    gruen.l=Green(TFarbe.l)
    blau.l=Blue(TFarbe.l)
    FrontColor (RGB(rot.l,gruen.l,blau.l))
    text$=Str(percent.l)+ " %"
    DrawText (Int(pcwidth.l/2)-20, 2, text$)
    StopDrawing ()
  EndIf
  If IsGadget (gadget.l):SetGadgetState (gadget.l, ImageID (800+gadget.l)):EndIf
EndProcedure


; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; DisableDebugger