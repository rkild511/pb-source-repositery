; English forum:
; Author: Fweil (updated for PB4.00 by blbltheworm)
; Date: 21. June 2003
; OS: Windows
; Demo: Yes

Procedure.l MyImage(ImageNumber.l, Width.l, Height.l, Color.l)
  ImageID.l = CreateImage(ImageNumber, Width, Height)
  StartDrawing(ImageOutput(ImageNumber))
    Box(0, 0, Width, Height, Color)
  StopDrawing()
  ProcedureReturn ImageID
EndProcedure
#False=0:#True=1
;
; Main starts here
;
  Quit.l = #False

  If OpenWindow(0, 200, 200, 320, 200, "F.Weil - Colored buttons", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget | #PB_Window_SizeGadget | #PB_Window_TitleBar)
      AddKeyboardShortcut(0, #PB_Shortcut_Escape, 99)
      If CreateGadgetList(WindowID(0))
          Frame3DGadget(205, 100, 80, 80, 60, "Color1", 0)
          ButtonImageGadget(105, 120, 100, 40, 20, MyImage(1, 40, 20, $996600))
          Frame3DGadget(206, 180, 80, 80, 60, "Color2", 0)
          ButtonImageGadget(106, 200, 100, 40, 20, MyImage(2, 40, 20, $999933))
      EndIf
      Repeat
        Select WaitWindowEvent()
          Case #PB_Event_CloseWindow
            Quit = #True
          Case #PB_Event_Menu
            Select EventMenu()
              Case 99
                Quit = #True
            EndSelect
          Case #PB_Event_Gadget
            Select EventGadget()
              Case 105                                                         ; Select first color
                FreeGadget(105)
                ButtonImageGadget(105, 120, 100, 40, 20, MyImage(1, 40, 20, ColorRequester()))
              Case 106                                                         ; Select second color
                FreeGadget(106)
                ButtonImageGadget(106, 200, 100, 40, 20, MyImage(2, 40, 20, ColorRequester()))
            EndSelect
        EndSelect
      Until Quit
  EndIf
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP