; German forum: http://www.purebasic.fr/german/viewtopic.php?t=35&highlight=
; Author: DarkDragon (updated for PB 4.00 by Andre)
; Date: 30. August 2004
; OS: Windows
; Demo: Yes

; Daten eingeben, die unmittelbar in einem WebGadget angezeigt (reingestreamt) werden.

#WindowWidth  = 500 
#WindowHeight = 400 
#WindowFlags  = #PB_Window_MinimizeGadget | #PB_Window_TitleBar | #PB_Window_ScreenCentered | #PB_Window_SystemMenu 

hWnd = OpenWindow(0, 0, 0, #WindowWidth, #WindowHeight, "", #WindowFlags) 

CreateGadgetList(hWnd) 
EditorGadget(0, 0, 0, #WindowWidth, #WindowHeight/2) 
WebGadget(1, 0, (#WindowHeight/2)+5, #WindowWidth, (#WindowHeight/2)-5, "about:") 

Repeat 
  Event = WindowEvent() 
  Select Event 
    Case #PB_Event_Gadget 
      Select EventGadget() 
        Case 0 
          SetGadgetText(1, "about:"+GetGadgetText(0)) 
      EndSelect 
  EndSelect 
  Delay(5) 
Until Event = #PB_Event_CloseWindow 
End
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -