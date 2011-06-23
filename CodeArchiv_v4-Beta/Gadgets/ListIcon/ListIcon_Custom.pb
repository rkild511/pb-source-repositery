; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8461&highlight=
; Author: Hi-Toro (updated for PB4.00 by blbltheworm)
; Date: 23. November 2003
; OS: Windows
; Demo: No


; Custom listview example... 

; The messages and constants used are found at the URL below. If a constant's value isn't defined in PB, just hit 
; Google with (eg.) "const LVM_SETICONSPACING" (minus the quotes)... nearly always works :) 

; http://msdn.microsoft.com/library/default.asp?url=/library/en-us/shellcc/platform/commctls/listview/listview.asp 




; This is just used to resize the listview gadget with the window, in realtime... 

Procedure WindowHook (WindowID, Message, wParam, lParam) 
    result = #PB_ProcessPureBasicEvents 
    Select Message 
        Case #WM_SIZE 
            ResizeGadget (0, 0, 0, WindowWidth (0), WindowHeight (0)) 
    EndSelect 
    ProcedureReturn result 
EndProcedure 

; Missing listview message definition... 

#LVM_SETICONSPACING = #LVM_FIRST + 53 

If OpenWindow (0, 0, 0, 400, 300, "Test gadget", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget | #PB_Window_SizeGadget | #PB_Window_ScreenCentered) 

    SetWindowCallback (@WindowHook ()) 
    
    CreateGadgetList (WindowID (0)) 

    ; Create list icon gadget and store its Windows handle in 'lv'... 
        
    lv = ListIconGadget (0, 0, 0, WindowWidth (0), WindowHeight (0), "Test", WindowWidth (0), #PB_ListIcon_MultiSelect | #LVS_AUTOARRANGE | #LVS_NOSCROLL) 
    ChangeListIconGadgetDisplay (0, 0) 

    ; Set spacing of icons to 64 x 64 (has to be combined into a .l variable)... 
    
    PokeW (@size, 64) 
    PokeW (@size + 2, 64) 
    SendMessage_ (lv, #LVM_SETICONSPACING, 0, size) 
    
    ; Get an icon (may need to change .exe used). Haven't yet figured out how to make the background transparent... 
    
    icon = ExtractIcon_ (GetModuleHandle_ (#Null), "mspaint.exe", 0) 

    ; Stick the icon into a PB image... 
        
    image = CreateImage (0, 32, 32) 
    dc = StartDrawing (ImageOutput (0)) 
    DrawIcon_ (dc, 0, 0, icon) 
    StopDrawing () 

    ; Add some test items... 
        
    For a = 1 To 10 
        AddGadgetItem (0, -1, "Test", ImageID (0)) 
    Next 
        
    Repeat 
        ; Wait until window is closed... 
    Until WaitWindowEvent () = #PB_Event_CloseWindow 
    
EndIf 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP