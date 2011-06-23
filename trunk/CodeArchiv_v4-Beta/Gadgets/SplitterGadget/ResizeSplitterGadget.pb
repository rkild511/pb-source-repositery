; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1334&highlight=
; Author: Andreas (updated for PB4.00 by blbltheworm)
; Date: 13. June 2003
; OS: Windows
; Demo: No


; Code example for automatic resizing window with SplitterGadget, PanelGadget etc.

#Window           = 1 
#Panel            = 2 
#Button1          = 3 
#List1            = 4 
#List2            = 5 
#Splitter1        = 6 
#Splitter2        = 7 

Procedure Resize() 
    ShowWindow_(WindowID(#Window), #SW_MAXIMIZE) 
EndProcedure 

Global Quit.l 
Event.l 

Procedure WCB(wnd, msg, wParam, lParam) 
    Result = #PB_ProcessPureBasicEvents 
    Select msg 
    Case #WM_SIZE 
        ResizeGadget(#Panel,#PB_Ignore,#PB_Ignore, WindowWidth(#Window), WindowHeight(#Window)) 
        ResizeGadget(#Splitter1,#PB_Ignore,#PB_Ignore, WindowWidth(#Window) / 2, WindowHeight(#Window) / 2) 
        ResizeGadget(#Splitter2,#PB_Ignore,#PB_Ignore, WindowWidth(#Window), WindowHeight(#Window) - 40) 
        SetGadgetState(#Splitter1, 100) 
        SetGadgetState(#Splitter2, 100) 
    EndSelect 
    ProcedureReturn Result 
EndProcedure 

OpenWindow(#Window,0,0,320,240,"Window#0",#PB_Window_MinimizeGadget|#PB_Window_MaximizeGadget|#PB_Window_SizeGadget) 
CreateGadgetList(WindowID(#Window)) 
PanelGadget(#Panel, 0, 0, WindowWidth(#Window), WindowHeight(#Window)) 
AddGadgetItem(#Panel, -1, "Test") 
ButtonGadget(#Button1, #Null, #Null, #Null, #Null, "Hello") 
ListIconGadget(#List1, #Null, #Null, #Null, #Null, "Hello2", 120) 
EditorGadget(#List2, #Null, #Null, #Null, #Null)
SetGadgetText(#List2,"Hello3")

SplitterGadget(#Splitter1, 40, 40, WindowWidth(#Window) / 2, WindowHeight(#Window) / 2, #List1, #List2) 
SplitterGadget(#Splitter2, 0, 40, WindowWidth(#Window), WindowHeight(#Window) - 40, #Button1, #Splitter1,#PB_Splitter_Vertical) 
CloseGadgetList() 

MessageRequester("Info", "Bitte einen Moment warten, nach dem OK!", #PB_MessageRequester_Ok) 

For i.l = 1 To 1230 
    AddGadgetItem(#List1, -1, "blb") 
Next i 

For i.l = 1 To 512 
    Temp.s = "" 
    For x.l = 1 To 512 
        Temp = Temp + Chr(Random(128)) 
    Next x 
    AddGadgetItem(#List2, -1, Temp) 
Next i 

MessageRequester("Info", "Zum Resizen bitte auf den Schalter Hello klicken!", #PB_MessageRequester_Ok) 
SetWindowCallback(@WCB()) 

Repeat 
    
    Event = WaitWindowEvent() 
    
    Select Event 
    Case #PB_Event_Gadget 
        
        Select EventGadget() 
        Case #Button1 
            Resize() 
            
        EndSelect 
        
    Case #PB_Event_CloseWindow 
        Quit = #True 
        
    EndSelect 
    
Until Quit 
End 


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
