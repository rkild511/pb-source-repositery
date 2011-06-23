; English forum: http://www.purebasicforums.com/english/viewtopic.php?t=14603&highlight=
; Author: Hroudtwolf (updated for PB 4.00 by Andre)
; Date: 30. March 2005
; OS: Windows
; Demo: No


; A little tool for converting vanity-phonenumbers to decimalnumbers and
; also the reversed way.


;Vanity-Calculator
;2005 Hroudtwolf
;-----------------------------------------------------
Declare FensterCallBack(WindowID.l, Message.l, wParam.l, lParam.l)
Declare String2Numbers()
Declare Numbers2String()


Global Dim nummern$(10)
Global ColorBrush.l, hString.l

ColorBrush.l = CreateSolidBrush_($ECFADE)



nummern$(1)=" "
nummern$(2)="ABC"
nummern$(3)="DEF"
nummern$(4)="GHI"
nummern$(5)="JKL"
nummern$(6)="MNO"
nummern$(7)="PQRS"
nummern$(8)="TUV"
nummern$(9)="WXYZ"
nummern$(0)="+"

flags.l=#PB_Window_ScreenCentered|#PB_Window_SystemMenu



If CreateImage (1,10,10)
  If StartDrawing (ImageOutput (1))
    DrawingMode(0)
    Box(0,0,10,10,RGB(50,50,250))
    
    For x=0 To 10 Step 2
      Line (0,x,10,0,RGB(0,0,100))
    Next x
    StopDrawing()
  EndIf
EndIf

font1.l=LoadFont(1,"ARIAL",10,#PB_Font_Bold)
font2.l=LoadFont(2,"MSFIXEDSYS",8,#PB_Font_Bold)

If OpenWindow (1,0,0,300,230,"VANITY-CALC",flags.l)
  HideWindow(1,1)
  hBrush.l = CreatePatternBrush_(ImageID (1))
  SetClassLong_(WindowID(1), #GCL_HBRBACKGROUND, hBrush.l)
  InvalidateRect_(WindowID(1), #Null, #True)
  
  
  If CreateGadgetList(WindowID(1))
    If font2.l
      SetGadgetFont(#PB_Default,Font2.l)
    EndIf
    Frame3DGadget(1,10,10,280,30,"", #PB_Frame3D_Double )
    hString.l=StringGadget(2,15,15,270,20,"",#PB_Text_Right)
    If font1.l:SetGadgetFont(2,font1.l):EndIf
    Frame3DGadget(15,160,50,5,170,"", #PB_Frame3D_Single )
    Frame3DGadget(16,10,215,150,5,"", #PB_Frame3D_Single )
    ButtonGadget (3,10,50,45,35,"1")
    ButtonGadget (4,60,50,45,35,"2"+Chr(10)+"ABC",#PB_Button_MultiLine)
    ButtonGadget (5,110,50,45,35,"3"+Chr(10)+"DEF",#PB_Button_MultiLine)
    ButtonGadget (6,10,90,45,35,"4"+Chr(10)+"GHI",#PB_Button_MultiLine)
    ButtonGadget (7,60,90,45,35,"5"+Chr(10)+"JKL",#PB_Button_MultiLine)
    ButtonGadget (8,110,90,45,35,"6"+Chr(10)+"MNO",#PB_Button_MultiLine)
    ButtonGadget (9,10,130,45,35,"7"+Chr(10)+"PQRS",#PB_Button_MultiLine)
    ButtonGadget (10,60,130,45,35,"8"+Chr(10)+"TUV",#PB_Button_MultiLine)
    ButtonGadget (11,110,130,45,35,"9"+Chr(10)+"WXYZ",#PB_Button_MultiLine)
    ButtonGadget (12,10,170,45,35,"*")
    ButtonGadget (13,60,170,45,35,"0"+Chr(10)+"+",#PB_Button_MultiLine)
    ButtonGadget (14,110,170,45,35,"#")
    ButtonGadget (17,180,50,110,25,"String2Numbers")
    ButtonGadget (18,180,80,110,25,"Numbers2String")
    ButtonGadget (19,180,110,110,25,"Clear Display")
    ButtonGadget (20,180,140,110,25,"Info")
    ButtonGadget (21,180,190,110,25,"End")
  EndIf
  
  HideWindow(1,0)
  
  SetWindowCallback(@FensterCallBack())
  
  Repeat
    eventid.l=WaitWindowEvent()
    Select eventid.l
    Case #PB_Event_CloseWindow
      fertig=1
    Case #PB_Event_Gadget
      Select EventGadget()
      Case 3
        SetGadgetText(2,GetGadgetText(2)+"1")
      Case 4
        SetGadgetText(2,GetGadgetText(2)+"2")
      Case 5
        SetGadgetText(2,GetGadgetText(2)+"3")
      Case 6
        SetGadgetText(2,GetGadgetText(2)+"4")
      Case 7
        SetGadgetText(2,GetGadgetText(2)+"5")
      Case 8
        SetGadgetText(2,GetGadgetText(2)+"6")
      Case 9
        SetGadgetText(2,GetGadgetText(2)+"7")
      Case 10
        SetGadgetText(2,GetGadgetText(2)+"8")
      Case 11
        SetGadgetText(2,GetGadgetText(2)+"9")
      Case 12
        SetGadgetText(2,GetGadgetText(2)+"*")
      Case 13
        SetGadgetText(2,GetGadgetText(2)+"0")
      Case 14
        SetGadgetText(2,GetGadgetText(2)+"#")
      Case 19
        SetGadgetText(2,"")
      Case 20
        MessageRequester ("Info","This source was written by Hroudtwolf 2005(c)",0)
      Case 21
        fertig=1
      Case 17
        string2Numbers()
      Case 18
        Numbers2String()
      EndSelect
    EndSelect
    
    
  Until fertig=1
  DeleteObject_(hBrush.l)
  CloseWindow(1)
  End
EndIf



Procedure FensterCallBack(WindowID.l, Message.l, wParam.l, lParam.l)
  Result.l = #PB_ProcessPureBasicEvents
  Select Message
  Case #WM_CTLCOLOREDIT
    Select lParam
    Case GadgetID(2)
      SetTextColor_(wParam, $5C5C5C)
      SetBkMode_(wParam, #TRANSPARENT)
      Result.l = ColorBrush.l
    EndSelect
  EndSelect
  ProcedureReturn Result.l
EndProcedure




Procedure String2Numbers()
  text.s=UCase(GetGadgetText(2))
  
  For x=1 To Len(text.s)
    For y=0 To 9
      If FindString (nummern$(y),Mid(text.s,x,1),1)
        SetGadgetText(2,GetGadgetText(2)+Str(y))
      EndIf
    Next y
  Next x
EndProcedure


Procedure Numbers2String()
  text.s=GetGadgetText(2)
  SetGadgetText(2,"")
  For x=1 To Len(text.s)
    zahl.l=Val(Mid(text.s,x,1))
    vinlang.l=Len(nummern$(zahl.l))
    SetGadgetText(2,GetGadgetText(2)+Mid(nummern$(zahl.l),1+Random(vinlang.l),1))
  Next x
EndProcedure

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger