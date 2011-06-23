; English forum: http://www.purebasic.fr/english/viewtopic.php?t=13220
; Author: Randy Walker (updated for PB 4.00 by Andre)
; Date: 26. November 2004
; OS: Windows
; Demo: No

; Sample code to show a single button sharing mixed fonts at the same time.

HWND0 = OpenWindow(0,174,8,170,100,"Multi-Font Button",#PB_Window_SystemMenu|#PB_Window_ScreenCentered)
If HWND0
  If CreateGadgetList(WindowID(0))

    ; Setup font for main label.
    LoadFont(0,"Courier",8)
    SetGadgetFont(#PB_Default,FontID(0))
    TextGadget(0,10,10,150,25,"Click the button.",#PB_Text_Center)

    ; Setup main font for button.
    LoadFont(1,"Arial",10,#PB_Font_Bold)
    SetGadgetFont(#PB_Default,FontID(1))
    buttonMode = ButtonGadget(1,25,40,120,25,"Bright             ")

    ; Setup alternate font for button.
    LoadFont(2,"Arial",8)
    SetGadgetFont(#PB_Default,FontID(2))
    buttonAlt = TextGadget(2,54,6,50,15," >   Dim",#PB_Text_Center)

    ; Here's the trick...
    SetParent_(buttonAlt,buttonMode) ; attach alternate label to button
  EndIf

  ; Swap and show "current mode in bold" and "alternate mode as normal".
  Repeat
    EventID = WaitWindowEvent()
    Select EventID
      Case #PB_Event_Gadget
        Select EventGadget()
          Case 1
            If Mode.b ;
              hBrush0 = CreateSolidBrush_(RGB(200,200,200))
              SetClassLong_(HWND0, #GCL_HBRBACKGROUND, hBrush0)
              InvalidateRect_(HWND0, #Null, #True)
              SetGadgetText(1, "Bright             ")
              SetGadgetText(2, " >   Dim")
              Mode.b = 0
            Else
              Debug "off"
              hBrush0 = CreateSolidBrush_(RGB(120,120,120))
              SetClassLong_(HWND0, #GCL_HBRBACKGROUND, hBrush0)
              InvalidateRect_(HWND0, #Null, #True)
              SetGadgetText(1, "Dim             ")
              SetGadgetText(2, ">   Bright")
              Mode.b = -1
            EndIf
        EndSelect
    EndSelect
  Until EventID = #PB_Event_CloseWindow
EndIf

DeleteObject_(hBrush0)  ; Cleanup

End

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP