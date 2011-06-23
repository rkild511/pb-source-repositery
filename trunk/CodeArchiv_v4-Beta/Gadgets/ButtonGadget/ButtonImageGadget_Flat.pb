; German forum: http://www.purebasic.fr/german/viewtopic.php?t=514&highlight=
; Author: bobobo (updated for PB 4.00 by Andre)
; Date: 20. October 2004
; OS: Windows
; Demo: No


; www.purearea.net (Sourcecode collection by cnesm) 
; Author: 
; Date: 22. November 2003 
; erweitert durch nen platten Knopf 

Procedure.l MyImage(ImageNumber.l, Width.l, Height.l, Color.l) 
  ImageID.l = CreateImage(ImageNumber, Width, Height) 
  StartDrawing(ImageOutput(ImageNumber)) 
    Box(0, 0, Width, Height, Color) 
  StopDrawing() 
  ProcedureReturn ImageID 
EndProcedure 

#BS_FLAT=$8000 
; 
; Main starts here 
; 
If OpenWindow(0, 200, 200, 150, 100, "zZzzzZzZzZzzzZzzz", #PB_Window_SystemMenu) 

  If CreateGadgetList(WindowID(0)) 
    ButtonImageGadget(105, 10, 10, 40, 20, MyImage(1,40,20,$0000FF)) 
    ButtonImageGadget(106, 60, 10, 40, 20, MyImage(2,40,20,$FF00BB)) 
    s.l=GetWindowLong_(GadgetID(106), #GWL_STYLE) 
    SetWindowLong_(GadgetID(106), #GWL_STYLE, #BS_FLAT | s) 
  EndIf 

  Repeat 
    Select WaitWindowEvent() 
      Case #PB_Event_CloseWindow : End 
      Case #PB_Event_Gadget 
        Select EventGadget() 
          Case 105 ; Button 1 
            SetGadgetState(106,MyImage(2,40,20,Random($FFFFFF))) 
          Case 106 ; Button 2 
        EndSelect 
    EndSelect 
  ForEver 

EndIf 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -