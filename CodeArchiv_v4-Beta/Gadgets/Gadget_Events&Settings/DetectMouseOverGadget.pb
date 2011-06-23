; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8477&highlight=
; Author: Hi-Toro (updated for PB4.00 by blbltheworm)
; Date: 25. November 2003
; OS: Windows
; Demo: No

window = OpenWindow (0, 320, 200, 320, 200, "", #PB_Window_SystemMenu) 
CreateGadgetList (WindowID (0)) 

gad1 = ButtonGadget (0, 0, 0, WindowWidth (0) / 2, WindowHeight (0), "Gadget 1") 
gad2 = ButtonGadget (1, WindowWidth (0) / 2, 0, WindowWidth (0) / 2, WindowHeight (0), "Gadget 2") 

Repeat 

    GetCursorPos_ (@p.POINT) 
    ScreenToClient_ (window, @p) 
    
    Select ChildWindowFromPoint_ (window, p\x, p\y) 
        Case gad1 
            SetWindowText_ (window, "Over gadget 1") 
        Case gad2 
            SetWindowText_ (window, "Over gadget 2") 
    EndSelect 
    
Until WaitWindowEvent () = #PB_Event_CloseWindow 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
