; German forum: http://www.purebasic.fr/german/viewtopic.php?t=561
; Author: tinman (updated for PB 4.00 by Andre)
; Date: 22. October 2004
; OS: Windows
; Demo: No


;Original by "tinman"

Global hSplitterGadget.l
Global old_func.l

#Button1  = 0
#Button2  = 1
#Splitter = 2

Procedure.l foo(WindowID, Message, wParam, lParam)
  Static state

  result.l = CallWindowProc_(old_func, WindowID, Message, wParam, lParam)
  Select Message
    Case #WM_LBUTTONDOWN
      state = 1
      Debug "pressed"

    Case #WM_MOUSEMOVE
      If state = 1
        Debug "resizing"
      EndIf

    Case #WM_LBUTTONUP
      state = 0
      Debug "released"
  EndSelect
  ProcedureReturn result
EndProcedure


If OpenWindow(0, 0, 0, 230, 180, "SplitterGadget", #PB_Window_SystemMenu|#PB_Window_ScreenCentered)
  If CreateGadgetList(WindowID(0))
    hButtonGadget1 = ButtonGadget(#Button1,0, 0, 0, 0, "Button 1") ; No need to specify size or coordiantes
    hButtonGadget2 = ButtonGadget(#Button2,0, 0, 0, 0, "Button 2") ; as they will be sized automatically
    hSplitterGadget = SplitterGadget(#Splitter, 5, 5, 220, 120, #Button1, #Button2, #PB_Splitter_Separator)
    hSplitterGadget = GadgetID(#Splitter)

    old_func.l = GetWindowLong_(hSplitterGadget, #GWL_WNDPROC)
    If old_func = 0
      old_func = GetClassLong_(hSplitterGadget, #GCL_WNDPROC)
    EndIf
    SetWindowLong_(hSplitterGadget, #GWL_WNDPROC, @foo())


    SetGadgetAttribute(#Splitter, #PB_Splitter_FirstMinimumSize, 20)
    SetGadgetAttribute(#Splitter, #PB_Splitter_SecondMinimumSize, 20)
    hTextGadget = TextGadget(3, 10, 135, 210, 40, "Above GUI part shows two automatically resizing buttons inside the 230x130 SplitterGadget area.",#PB_Text_Center )

    Repeat
      ev = WaitWindowEvent()
      Select ev
        Case #PB_Event_CloseWindow : quit =1
        Case #PB_Event_Gadget
          EventGadget = EventGadget()
          Debug "Gadget# = " + Str(EventGadget) + " Gadget handle = " + Str(GadgetID(EventGadget))
      EndSelect
    Until quit=1
  EndIf
EndIf

SetWindowLong_(hSplitterGadget, #GWL_WNDPROC, old_func)
End

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP