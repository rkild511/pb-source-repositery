; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8300&highlight=
; Author: blueznl (updated for PB 4.00 by Andre)
; Date: 12. November 2003
; OS: Windows
; Demo: No


; purebasic survival guide
; messages_1 - 10.11.2003 ejn (blueznl)
; http://www.xs4all.nl/~bluez/datatalk/pure1.htm
;
; - opening a window, and processing messages using WaitWindowEvent()
; - how to use TrackMouseEvent_()
; - retrieve cursor (mouse) coordinates from a windows WM_MOUSEMOVE event
;
;
screen_w.l = GetSystemMetrics_(#SM_CXSCREEN)
screen_h.l = GetSystemMetrics_(#SM_CYSCREEN)
;
;main_nr.l = x_nr()
main_whnd.l = OpenWindow(0,300,350,400,200,"Test",#PB_Window_SystemMenu|#PB_Window_MinimizeGadget|#PB_Window_MaximizeGadget|#PB_Window_SizeGadget)
;
; wanna' have a message to notify the mouse leaving the window? use the trackmouseevent_() function
; here's the structure and the constants we might need later (uncomment when needed)
;
;   Structure tagTRACKMOUSEEVENT
;     cbSize.l
;     dwFlags.l
;     hwndTrack.l
;     dwHoverTime.l
;   EndStructure
;   #TME_LEAVE = 2
;
#WM_MOUSELEAVE = $2A3
;
;
mouselmb.l = #False
done.l = #False
Repeat
  ;
  ; processing windows messages using waitevent() instead of callback
  ;
  event.l = WaitWindowEvent()                   ; wait for an event
  window.l = EventWindow()                    ; on which window?
  ;
  Select event
    Case #WM_KEYDOWN
      Debug "256 #WM_KEYDOWN key pressed"
      event_parameter.l = EventwParam()         ; undocumented / deprecated / windows only
      Select event_parameter                    ; eventwparam() gets additional info on event
        Case #VK_ESCAPE
          done=#True
      EndSelect
    Case #PB_Event_Menu
      Debug "13101 #PB_Event_Menu menu"
    Case #PB_Event_CloseWindow
      ; Debug "16 #PB_Event_CloseWindow close window"
      done = #True
    Case 5
      ; Debug "5 ? resize"
    Case #PB_Event_Repaint
      ; Debug "15 #PB_Event_Repaint repaint #WM_SYSCOLORCHANGE"
    Case 160
      ; Debug "160 mouse over dragbar"
    Case 161
      ; Debug "161 window move"
    Case 275
      ; Debug "275 ? focus / activation"
    Case #WM_MOUSEMOVE
      ; Debug "512 $200 #WM_MOUSEMOVE mouse moved over window"
      ;
      ; EventwParam() contains info on variuos virtual keys
      ; EventlParam() contains the cursor coords
      ;
      ; the implementation of mousecoordinates is somewhat fuzzy in purebasic, they are
      ; reported in relation to the upper left corner of the window, not of the client area
      ; using the EventlParam() field an accurate position can be retrieved
      ;
      mousex.l = EventlParam() % 65536
      mousey.l = EventlParam() / 65536
      ;
      ; if you want to use the build in commands, you have to compensate for the size
      ; of window borders etc.
      ;
      ;   mousex.l = WindowMouseX()-GetSystemMetrics_(#SM_CYSIZEFRAME)
      ;   mousey.l = WindowMouseY()-GetSystemMetrics_(#SM_CYCAPTION)-GetSystemMetrics_(#SM_CYSIZEFRAME)
      ;
      ; if you want To detect when the mouse leaves the window, you could set a TrackMouseEvent_()
      ;
      ;   mouseleave.tagTRACKMOUSEEVENT
      ;   mouseleave\cbSize = SizeOf(tagTRACKMOUSEEVENT)
      ;   mouseleave\dwFlags = #TME_LEAVE
      ;   mouseleave\hwndTrack = main_whnd
      ;   TrackMouseEvent_(@mouseleave)
      ;
      ; when using SetCapture_() windows 'prefilters' messages, that is you won't receive
      ; messages unless another condition is met (virtual keys, mousebuttons, etc.)
      ; so you can't use SetCapture() to see if the cursor left the area with no button
      ; pressed
      ;
      ;
    Case #WM_LBUTTONDOWN
      ;
      ; Debug "513 $201 #WM_LBUTTONDOWN lmb down"
      ;
      mouselmb = #True
      ;
      ; if a mousebutton is pressed, and the cursor is moved outside the window client area
      ; no more messages will be received, including the WM_LBUTTONUP message
      ; to make sure such a message is received grab all messages until we got what we
      ; want
      ;
      SetCapture_(main_whnd)
      ;
    Case #WM_LBUTTONUP
      ;
      ; Debug "514 $202 #WM_LBUTTONUP lmb up"
      ;
      mouselmb = #False
      ;
      ReleaseCapture_()
      ;
    Case 516
      ; rmb down
    Case 517
      ; rmb up
    Case 519
      ; mmb down
    Case 520
      ; mmb up
    Case 522
      event_parameter.l = EventwParam()
      If event_parameter>0
        Debug "522 $20A eventwparam>0 scrollwheel up"
      Else
        Debug "522 $20A eventwparam<0 scrollwheel down"
      EndIf
    Case 674
      Debug "674 ?"
    Case #WM_MOUSELEAVE
      ;
      Debug "675 $2A3WM_MOUSELEAVE mouse left window (after a trackmouseevent was used)"
      ;
      ; only generated after calling TrackMouseEvent_(), see #WM_MOUSEMOVE above
      ;
    Default
      Debug event
  EndSelect
  ;
  If mouselmb = #True
    StartDrawing(WindowOutput(0))
    Line(mousex,mousey,1,1,RGB(0,0,0))
    StopDrawing()
  EndIf
  ;
Until done = #True

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -