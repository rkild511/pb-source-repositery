; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3061&highlight=
; Author: isidoro (improved by NicTheQuick, updated for PB4.00 by blbltheworm)
; Date: 08. December 2003
; OS: Windows
; Demo: No

;############################################ 
;#                                           # 
;#    MoveMessage Version 0,0009              # 
;#      Copyright     Auch                     # 
;#                                              # 
;################################################# 

Enumeration ;Windows 
  #InfoWin 
EndEnumeration 

Enumeration ;Gadgets 
  #InfoGadget = 0 
EndEnumeration 

; UsePNGImageDecoder() 
Message$ = "Hello World" 
Message$ + Chr(13) + Chr(10) + "Nichts ist, wie es scheint..." 

Procedure SinFunktion(Value.l, Divisor.l, Max.l) 
  Protected a.f 
  a = (Value * 3.1315926) / (Divisor * 2) 
  a = Sin(a) * Max 
  ProcedureReturn a 
EndProcedure 

Procedure WinDelay(MilliSecs.l) 
  Protected EndTime.l 
  EndTime = GetTickCount_() + MilliSecs 
  Repeat 
    While WindowEvent() : Wend 
    Delay(1) 
  Until EndTime < GetTickCount_() 
EndProcedure 

Procedure MoveMessage(text.s, Background.l, Zeit.l) 
  Protected Pause.l, lmaa.l, screenH.l, screenW.l 
  Protected InfoWinH.l, InfoWinW.l, InfoWinX.l, InfoWinY.l 
  Protected WinX.l, WinY.l, hwnd.l 
  
  Protected AufAbZeit.l, StartZeit.l, EndZeit.l 
  
  AufAbZeit = 1000 
  
  Pause = Zeit * 1000 
  
  lmaa = 27 ; Abfrage, ob Taskleiste auf oder nicht einfügen 
  
  screenW = GetSystemMetrics_(#SM_CXSCREEN) 
  screenH = GetSystemMetrics_(#SM_CYSCREEN) 
  
  InfoWinX = 0 
  InfoWinY = screenH 
  InfoWinW = 290
  InfoWinH = 155
  
  WinX = screenW - InfoWinW - 10 
  WinY = screenH 
  hwnd = OpenWindow(#InfoWin, InfoWinX, InfoWinY, InfoWinW, InfoWinH, "MoveMessage", #PB_Window_BorderLess) 
  If hwnd 
    SetWindowColor(#InfoWin, RGB($51,$AA,$AE)) 
    ;If Background : SetWinBackgroundImage(hwnd, Background) : EndIf 
    SetForegroundWindow_(hwnd) 
  
    CreateGadgetList(hwnd) 
    StringGadget(#InfoGadget, 2, 2, InfoWinW - 4, InfoWinH - 4, Text$ ,#PB_String_ReadOnly | #ES_MULTILINE) 
    SetGadgetText(#InfoGadget, text) 
    SetGadgetColor(#InfoGadget,#PB_Gadget_BackColor,RGB($51,$AA,$AE))
    SetActiveGadget(#InfoGadget) 
    
    AufAbZeit = 2000    ;Zeit, in der das Fenster auftauchen soll 
    StartZeit = GetTickCount_() 
    EndZeit = GetTickCount_() + AufAbZeit 
    Repeat 
      ResizeWindow(#InfoWin,WinX, screenH - SinFunktion(GetTickCount_() - StartZeit, AufAbZeit, InfoWinH),#PB_Ignore,#PB_Ignore) 
      While WindowEvent() : Wend 
    Until GetTickCount_() > EndZeit 
    
    WinDelay(Pause) ; loooos   schneller lesen 
    
    AufAbZeit = 1000     ;Zeit, in der das Fenster verschwinden soll 
    StartZeit = GetTickCount_() 
    EndZeit = GetTickCount_() + AufAbZeit 
    Repeat 
      ResizeWindow(#InfoWin,WinX, screenH - SinFunktion(AufAbZeit - GetTickCount_() + StartZeit, AufAbZeit, InfoWinH),#PB_Ignore,#PB_Ignore) 
      While WindowEvent() : Wend 
    Until GetTickCount_() > EndZeit 
    
  EndIf 
  CloseWindow(#InfoWin) 
EndProcedure 

MoveMessage(Message$, Background, 2) 

End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger
