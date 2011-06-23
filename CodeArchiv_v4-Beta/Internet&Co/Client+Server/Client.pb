; English forum: 
; Author: freak (updated for PB4.00 by blbltheworm)
; Date: 21. January 2003
; OS: Windows
; Demo: No


; ++++++++++++++++++++++++  Network Client Example +++++++++++++++++++++++++++++++

OpenWindow(0, 0, 0, 300, 400, "Network Client", #PB_Window_SystemMenu|#PB_Window_ScreenCentered)
CreateGadgetList(WindowID(0))
ListViewGadget(1, 5, 5, 290, 390)

If InitNetwork()=0: End: EndIf                       ; Initialize Network Stuff
ConnID.l = OpenNetworkConnection("127.0.0.1",6000)
If ConnID = 0: End: EndIf

; The following call will activate this Trick
;
; ConnID      : connection ID (from OpenNetworkConnection)
; WindowID()  : ID of a Window, to send the Events to.
; #WM_NULL    : The Message to be Send, if a Network Event occurs.
;               #WM_NULL will be ignored, but still causes the WaitWindowEvent() to return,
;               and then the NetworkEvent to be called.
; #FD_ALL     : Event to be send to Callback Procedure, we request them all.

#FD_ALL = #FD_READ|#FD_WRITE|#FD_OOB|#FD_ACCEPT|#FD_CONNECT|#FD_CLOSE
WSAAsyncSelect_(ConnID, WindowID(0), #WM_NULL, #FD_ALL) 


; Main Loop

Repeat
  If WaitWindowEvent() = #PB_Event_CloseWindow
    End
  EndIf
  If NetworkClientEvent(ConnID) = 2
    Text.s = Space(500)
    ReceiveNetworkData(ConnID, @Text, 500)
    AddGadgetItem(1,-1,Text)  
  EndIf
ForEver



; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -