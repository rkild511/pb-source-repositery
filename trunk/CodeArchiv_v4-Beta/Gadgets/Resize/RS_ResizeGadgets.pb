; English forum: http://www.purebasic.fr/english/viewtopic.php?t=10218&highlight=
; Author: USCode (RS_Unregister procedure added by FloHimself, updated for PB 4.00 by Andre)
; Date: 18. April 2004
; OS: Windows
; Demo: Yes


; - RS_ResizeGadgets - 
; One of the things I really like about Borland Delphi is the "anchor" feature 
; which allows you to "lock" one side of a widget to that side of a resizable 
; window. So in essence, when the window was resized by either the user or 
; programmatically, you could get your widgets to react accordingly. Your 
; widgets could stay in place, move, stretch, whatever you wanted the behavior 
; to be. I missed having this automatic behavior in PureBasic... 

; I haven't been able to find any user or PB routines out there which gave me 
; this functionality, so I wrote a couple of simple routines to take care of it 
; for me and I'd like to share them with you here. I'm very new to PureBasic so 
; I'm sure lots of you wizards out there could improve upon this or offer some 
; helpful suggestions. Any feedback is appreciated. 

; Essentially, all you have to do is 3 simple changes: IncludeFile my 
; RS_ResizeGadgets.pb source file, RS_Register your gadgets specifying which 
; side(s) you want to lock and call RS_Resize in the Event Loop. See the example 
; below for how to use the 2 resize procedures, the required parameters and 
; various combinations of "locking" you can do. 

; When you run the example, grab the lower right corner of the window and move 
; that corner around, resizing the window in all various directions. You'll see 
; how you can get the gadgets to behave. FYI - Resizing is real-time in 3.90, 
; but is only done once in 3.81 when the mouse is released. Resizing works best 
; in 3.90. 

; Be sure you have also saved the RS_ResizeGadgets.pb source file listed below 
; as well. 

; This was written only in PureBasic code (3.90) so it should run on Linux as 
; well ... though I haven't tested there yet. 
; I've run a test case with 100 gadgets on 1 window and it ran acceptably fast. 


; 
; 
; RS_ResizeGadgets.pb 
; Automatically Resize PureBasic Gadgets 
; Author: USCode 
; Date: April 15, 2004 
; 
; To use: 
; - Include this source file. 
; - Call RS_Register ONCE for EACH Gadget to be resized, specifiying side locks. 
; - Call RS_Resize in the event loop, specifying EventID and EventWindowID. 
; 

;DECLARATIONS 

Structure RS_gadget_struct 
  Window.l      
  Gadget.l      
  Left.w        
  Top.w          
  Right.w        
  Bottom.w      
  Lock_left.b 
  Lock_top.b 
  Lock_right.b 
  Lock_bottom.b  
EndStructure 

Global NewList RS_Gadgets.RS_gadget_struct() 


;PROCEDURES 

; RS_Register - Register gadget to be resized and how to resize. 
; Specify #TRUE for each side of the gadget you want to LOCK, else #FALSE. 
; Parameters:  WindowID (long), GadgetID (long), Left (boolean), Top (boolean), Right (boolean), Bottom (boolean). 
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


Procedure RS_Unregister(RS_window.l, RS_gadget.l) 
  ResetList(RS_Gadgets()) 
  While NextElement(RS_Gadgets()) 
    If (RS_Gadgets()\Window = RS_window) And (RS_Gadgets()\Gadget = RS_gadget) 
      DeleteElement(RS_Gadgets()) 
    EndIf 
  Wend 
EndProcedure 


; RS_Resize - Resize all registered gadgets for the resizing window. 
; Parameters: Event ID (long), Event Window ID (long). 
Procedure RS_Resize(RS_Event.l, RS_window.l) 
  
  If RS_Event = #PB_Event_SizeWindow And CountList(RS_Gadgets()) > 0 

    RS_gadget.l:RS_size.w:RS_x.w:RS_y.w:RS_w.l:RS_h.w 
    
    ResetList(RS_Gadgets()) 
    While NextElement(RS_Gadgets()) 
      If RS_Gadgets()\Window = RS_window 
      
        RS_gadget = RS_Gadgets()\Gadget 
        
        RS_x = GadgetX(RS_gadget) 
        RS_y = GadgetY(RS_gadget) 
        RS_w = -1:RS_h = -1 
        
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
    Wend  

  EndIf 

EndProcedure 

; RS_ResizeGadgets.pb 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; DisableDebugger