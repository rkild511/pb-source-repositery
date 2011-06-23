; http://www.purearea.net
; Author: Andre Beer / PureBasic Team
; Date: 16. August 2003
; OS: Windows
; Demo: Yes

  If OpenWindow(0, 0, 0, 230, 195, "SplitterGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    If CreateGadgetList(WindowID(0))
      
      #Button1  = 0 
      #Button2  = 1
      #Splitter = 2
      
      ButtonGadget(#Button1,0, 0, 0, 0, "Button 1") ; es besteht keine Notwendigkeit, die Größe oder Position
      ButtonGadget(#Button2,0, 0, 0, 0, "Button 2") ; festzulegen, da sie automatisch in der Größe angepasst werden
      SplitterGadget(#Splitter, 5, 5, 220, 120, #Button1, #Button2, #PB_Splitter_Separator)
      
      TextGadget(3, 10, 135, 210, 55, "Obiger GUI-Abschnitt zeigt zwei sich - innerhalb des 220x120 SplitterGadget Bereichs - automatisch in der Größe anpassende Schalter.",#PB_Text_Center )
      
      Repeat 
      Until WaitWindowEvent() = #PB_Event_CloseWindow
    EndIf
  EndIf


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP