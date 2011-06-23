; English forum: http://www.purebasic.fr/english/viewtopic.php?t=13220
; Author: Randy Walker (updated for PB 4.00 by Andre)
; Date: 26. November 2004
; OS: Windows
; Demo: No

; Sample code to show single button using mixed fonts.

HWND0 = OpenWindow(0,174,8,170,100,"Multi-Font Button",#PB_Window_SystemMenu|#PB_Window_ScreenCentered)
If HWND0
  If CreateGadgetList(WindowID(0))

    ; Setup font for main label.
    LoadFont(0,"Courier",8)
    SetGadgetFont(#PB_Default,FontID(0))
    TextGadget(0,10,10,150,25,"Click the button.",#PB_Text_Center)

    ; Setup main font for button.
    LoadFont(1,"Arial",12)
    SetGadgetFont(#PB_Default,FontID(1))
    buttonMode = ButtonGadget(1,25,40,120,25,"Main")

    ; Setup alternate font for button.
    LoadFont(2,"Roman",12,#PB_Font_Bold)
    SetGadgetFont(#PB_Default,FontID(2))
    buttonAlt = TextGadget(2,5,4,110,15,"Alternate",#PB_Text_Center)

    ; Here's the trick...
    SetParent_(buttonAlt,buttonMode) ; attach alternate label to button
    HideGadget(2,1)                 ; hide alternate label
    Mode.b = -1                    ; set mode flag to "normal"
  EndIf

  ; Swap and show "current mode in bold" and "alternate mode as normal".
  Repeat
    EventID = WaitWindowEvent()
    Select EventID
      Case #PB_Event_Gadget
        Select EventGadget()
          Case 1
            If Mode.b ;
              HideGadget(2,0)
              Mode.b = 0
            Else
              Debug "off"
              HideGadget(2,1)
              Mode.b = -1
            EndIf
        EndSelect
    EndSelect
  Until EventID = #PB_Event_CloseWindow
EndIf

End

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP