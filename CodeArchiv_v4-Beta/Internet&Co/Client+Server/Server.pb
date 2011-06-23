; English forum:  
; Author: freak (updated for PB4.00 by blbltheworm)
; Date: 21. January 2003 
; OS: Windows 
; Demo: No 
 

; ++++++++++++++++++++++++  Network Server Example +++++++++++++++++++++++++++++++

OpenWindow(0,0,0,300,80, "Network Server", #PB_Window_ScreenCentered | #PB_Window_SystemMenu)
;von freak
; ++++++++++++++++++++++++  Network Server Example +++++++++++++++++++++++++++++++


CreateGadgetList(WindowID(0))
StringGadget(0, 5, 5, 290, 25, "")
ButtonGadget(1, 5, 40, 80, 25, "Send")
DisableGadget(1,1)

If InitNetwork() = 0: End: EndIf                       ; Initialize Network Stuff
Socket.l = CreateNetworkServer(#PB_Any,6000) 
If Socket = 0: End: EndIf

; The following call will activate this Trick
;
; Socket      : Socket (or Connection ID) is returned by CreateNetworkServer()
; WindowID()  : ID of a Window, to send the Events to.
; #WM_NULL    : The Message to be Send, if a Network Event occurs.
;               #WM_NULL will be ignored, but still causes the WaitWindowEvent() to return,
;               and then the NetworkEvent to be called.
; #FD_ALL     : Event to be send to Callback Procedure, we request them all.

#FD_ALL = #FD_READ|#FD_WRITE|#FD_OOB|#FD_ACCEPT|#FD_CONNECT|#FD_CLOSE
WSAAsyncSelect_(Socket, WindowID(0), #WM_NULL, #FD_ALL) 


;Main Loop

Repeat
  Select WaitWindowEvent()
    Case #PB_Event_CloseWindow
      End
    Case #PB_Event_Gadget
      If EventGadget() = 1
        Text.s = GetGadgetText(0)
        SendNetworkData(EventClient(), @Text, Len(Text)+1)
      EndIf
  EndSelect
  
  Select NetworkServerEvent()
    Case 1
      DisableGadget(1,0)    ; user connected, enable sending.
    Case 4
      DisableGadget(1,1)    ; user disconnected, disable sending.
  EndSelect
ForEver


; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -