; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1278&start=10
; Author: Froggerprogger  (updated for PB3.92+ by Andre)
; Date: 07. September 2003
; OS: Windows
; Demo: No


; 07.09.03 by Froggerprogger 
; 
; live-updating the scrollbarinfos 

Declare.l WindowCallback(WindowID, message, wParam, lParam) 

#Window_Title = "scrollbar-test" 
#Gadget_PBScroll = 1 
#Gadget_PBText = 2 

Global hPBSB.l 
Global hWindow.l 
Global actSB.SCROLLINFO 

hWindow = OpenWindow(0,0,0,800,80,#Window_Title,#PB_Window_SystemMenu|#PB_Window_ScreenCentered) 
  CreateGadgetList(hWindow) 
    TextGadget(#Gadget_PBText, 10, 10, 780, 20, "") 
    hPBSB = ScrollBarGadget(#Gadget_PBScroll, 10, 30 , 780, 20, 0, 0, 0) 
      actSB\cbSize = SizeOf(SCROLLINFO) 
      actSB\fMask = #SIF_ALL 
      actSB\nMin = 0 
      actSB\nMax = 1000 
      actSB\nPage = 100 
      actSB\nPos = 450 
      actSB\nTrackPos = 0 ; ignored by SetScrollInfo_() 
      SetScrollInfo_(hPBSB, #SB_CTL, @actSB, #True) 
      
SetWindowCallback(@WindowCallback()) 
SetGadgetText(#Gadget_PBText, "PB-Scrollbar: "+Str(GetGadgetState(#Gadget_PBScroll))) 

Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow 
End 

;- Window-Callback-Procedure 
Procedure.l WindowCallback(WindowID, message, wParam, lParam) 
  Protected result.l : result = #PB_ProcessPureBasicEvents 

    Select message 

      Case #WM_COMMAND 
        If wParam = #Gadget_PBScroll And lParam = hPBSB 
          ; process all scrollbar-actions here. 
          SetGadgetText(#Gadget_PBText, "PB-Scrollbar: "+Str(GetGadgetState(#Gadget_PBScroll))) 
          result = 0 
        EndIf 
        
      Case #WM_CTLCOLORSCROLLBAR 
        ; MessageRequester("","#WM_CTLCOLORSCROLLBAR !",0) 
        result = CreateSolidBrush_($000066) 
        
    EndSelect 

  ProcedureReturn result 
EndProcedure 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
