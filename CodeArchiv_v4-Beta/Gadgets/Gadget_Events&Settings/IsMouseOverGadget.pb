; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7042&highlight=
; Author: GPI
; Date: 28. July 2003
; OS: Windows
; Demo: No

Procedure IsMouseOverGadget(Gadget) 
  GetWindowRect_(GadgetID(Gadget),GadgetRect.RECT) 
  GetCursorPos_(mouse.POINT) 
  If mouse\x>=GadgetRect\Left And mouse\x<=GadgetRect\right And mouse\y>=GadgetRect\Top And mouse\y<=GadgetRect\bottom 
    ProcedureReturn #True 
  Else 
    ProcedureReturn #False 
  EndIf 
EndProcedure 

; Some note: Windows send a #wm_mousemove, wenn the mouse is moved over one of
; your windows. (You can get this message with WaitWindowEvent())


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
