;**
; RS_ResizeGadgets.pb
;* Automatically Resize PureBasic Gadgets _
;* Author: USCode _
;* February 19, 2006 - Updated for PureBasic 4.0. _
;* April 15, 2004 - Original version for 3.9x. _
;* _
;* To use: _
;* - Include this source file. _
;* - Call RS_Register ONCE for EACH Gadget to be resized, specifying side locks. _
;* - Call RS_Resize in the event loop, specifying Event ID and Event Window ID. _
;

;DECLARATIONS

Structure RS_gadget_struct
  Window.l     
  Gadget.l     
  Left.l   
  Top.l         
  Right.l       
  Bottom.l     
  Lock_left.b
  Lock_top.b
  Lock_right.b
  Lock_bottom.b 
EndStructure     

Global NewList RS_Gadgets.RS_gadget_struct()


;PROCEDURES
;** RS_Register
;* - Register gadget To be resized And how To resize. _
;* Specify #TRUE for each side of the gadget you want to LOCK, else #FALSE. _
;* Parameters:  WindowID (long), GadgetID (long), Left (boolean), Top (boolean), Right (boolean), Bottom (boolean). _
Procedure RS_Register(RS_window.l, RS_gadget.l, RS_left.b, RS_top.b, RS_right.b, RS_bottom.b)

  AddElement(RS_Gadgets())

  RS_Gadgets()\Gadget = RS_gadget
  RS_Gadgets()\Window = RS_window
  RS_Gadgets()\Lock_left = RS_left
  RS_Gadgets()\Lock_top = RS_top
  RS_Gadgets()\Lock_right = RS_right
  RS_Gadgets()\Lock_bottom = RS_bottom

  If RS_left = #False
    RS_Gadgets()\Left = WindowWidth(RS_window) - GadgetX(RS_gadget)
  EndIf
 
  If RS_top = #False
    RS_Gadgets()\Top = WindowHeight(RS_window) - GadgetY(RS_gadget)
  EndIf
 
  If RS_right = #True
    RS_Gadgets()\Right = WindowWidth(RS_window) - (GadgetX(RS_gadget) + GadgetWidth(RS_gadget))
  EndIf
 
  If RS_bottom = #True
    RS_Gadgets()\Bottom = WindowHeight(RS_window) - (GadgetY(RS_gadget) + GadgetHeight(RS_gadget))
  EndIf

EndProcedure


;** RS_Unregister
;* - Unregister gadget from resizing
Procedure RS_Unregister(RS_window.l, RS_gadget.l)

  ForEach RS_Gadgets()

    If (RS_Gadgets()\Window = RS_window) And (RS_Gadgets()\Gadget = RS_gadget)
      DeleteElement(RS_Gadgets())
    EndIf

  Next 

EndProcedure


;** RS_Resize
;* - Resize all registered gadgets For the resizing window. _
;* Parameters: Event ID (long), Event Window ID (long). _
Procedure RS_Resize(RS_Event.l, RS_window.l)
 
  If RS_Event = #PB_Event_SizeWindow And CountList(RS_Gadgets()) > 0
 
    Protected RS_gadget.l, RS_size.l, RS_x.l, RS_y.l, RS_w.l, RS_h.l
   
    ForEach RS_Gadgets()
    
      If RS_Gadgets()\Window = RS_window
     
        RS_gadget = RS_Gadgets()\Gadget
       
        RS_x = GadgetX(RS_gadget)
        RS_y = GadgetY(RS_gadget)
        RS_w = #PB_Ignore : RS_h = #PB_Ignore
       
        If RS_Gadgets()\Lock_left = #False   
          RS_x = (WindowWidth(RS_window) - RS_Gadgets()\Left)
        EndIf
           
        If RS_Gadgets()\Lock_top = #False
          RS_y = (WindowHeight(RS_window) - RS_Gadgets()\Top)
        EndIf       
               
        If RS_Gadgets()\Lock_right = #True
          RS_w = (WindowWidth(RS_window) - RS_x) - RS_Gadgets()\Right
        EndIf
     
        If RS_Gadgets()\Lock_bottom = #True
          RS_h = (WindowHeight(RS_window) - RS_y) - RS_Gadgets()\Bottom
        EndIf       
       
        ResizeGadget(RS_gadget, RS_x, RS_y, RS_w, RS_h)
       
      EndIf
    Next

  EndIf

EndProcedure

; IDE Options = PureBasic v4.00 (Windows - x86)
; CursorPosition = 33
; FirstLine = 24
; Folding = -
; EnableXP
; HideErrorLog