; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7427
; Author: clipper
; Date: 03. September 2003
; OS: Windows
; Demo: No


; GPS How to receive NMEA Data over a serial-port with MVCom
; ----------------------------------------------------------
; Simple Example to receive NMEA-Sentences over Com1 with PureBasic and the
; MVCom Library of Marc Vitry http://www.purearea.net/pb/download/userlibs/MVCOM_LIBRARY.zip
; by Thomas Ott - tom@medi-a.de
; Information about the NMEA-Protocoll http://www.nmea.de/nmea0183datensaetze.html


#FRAME_1 = 0
#TEXT_1 = 1
#TEXT_2 = 2
#FRAME_2 = 3
#BUTTON_1 = 4
#BUTTON_2 = 5
#LISTVIEW_1=6
#Window_0=0

Global HCom.l
Global NMEA.s
ComPortSettings.s="COM1:4800,N,8,1"

Procedure TimerProc(WindowID.l, nIDEvent.l, uElapse.l, lpTimerFunc.l)
  If HCom > 0
    Car.s = "."
    While ComInputBufferCount(HCom) > 0
      If ComInput(HCom,Car)
        If Car=Chr(10)
          AddGadgetItem(#LISTVIEW_1, -1,NMEA)
          If Left(NMEA,6)= "$GPGLL"
            SetGadgetText(#TEXT_1,StringField(NMEA,2,",")+StringField(NMEA,3,","))
            SetGadgetText(#TEXT_2,StringField(NMEA,4,",")+StringField(NMEA,5,","))
          EndIf
          NMEA=""
        Else
          NMEA=NMEA+Car
        EndIf
      EndIf
    Wend
  EndIf
EndProcedure

Procedure Open_Window_0()
  If OpenWindow(#Window_0, 435, 369, 300,130, "NMEA",#PB_Window_SystemMenu | #PB_Window_TitleBar )
    If CreateGadgetList(WindowID(#Window_0))
      Frame3DGadget(#FRAME_1, 0, 0, 100, 20, "", #PB_Frame3D_Single)
      TextGadget(#TEXT_1, 3, 3, 90, 15, "", #PB_Text_Center)
      TextGadget(#TEXT_2, 103, 3, 90, 15, "", #PB_Text_Center)
      Frame3DGadget(#FRAME_2, 101, 0, 100, 20, "", #PB_Frame3D_Single)
      ButtonGadget(#BUTTON_1, 201, 0, 50, 20, "Start")
      ButtonGadget(#BUTTON_2, 250, 0, 50, 20, "Clear")
      ListViewGadget(#LISTVIEW_1, 0, 20, 300, 110)
      
    EndIf
  EndIf
EndProcedure

Open_Window_0()
SetTimer_(WindowID(#Window_0),1,100,@TimerProc())
Repeat
  Event = WaitWindowEvent()
  If Event = #PB_Event_Gadget
    GadgetID = EventGadget()
    Select GadgetID
    Case #BUTTON_1
      If HCom > 0
        ComClose(HCom)
        HCom=0
        SetGadgetText(#BUTTON_1,"Start")
      Else
        HCom=ComOpen(ComPortSettings,0,256,0)
        If HCom=-1
          MessageRequester("NMEA","Error opening the ComPort",0)
        Else
          SetGadgetText(#BUTTON_1,"Stop")
        EndIf
      EndIf
    Case #BUTTON_2
      ClearGadgetItemList(#LISTVIEW_1)
    EndSelect
  EndIf
Until Event = #PB_Event_CloseWindow

KillTimer_(WindowID(#Window_0),1)
If HCom > 0
  ComClose(HCom)
EndIf
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
