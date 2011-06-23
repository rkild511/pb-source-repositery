; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=5709#5709
; Author: CyberRun8 (updated for PB4.00 by blbltheworm)
; Date: 06. May 2003
; OS: Windows
; Demo: No

;-Konstanten setzen 
#Window = 0 
#Gadget = 0 

;-Variablen bestimmen 
SystemPath.s = Space(255) 
Result = GetSystemDirectory_(SystemPath.s, 255) 

;-Fenster darstellen 
If OpenWindow(#Window, 200, 200, 200, 210, "", #PB_Window_MinimizeGadget) 
  If CreateGadgetList(WindowID(#Window)) 
    ListIconGadget(#Gadget, 5, 5, 190, 190, "Einträge", 80) 
    For a = 0 To 237 
      AddGadgetItem(#Gadget, -1, "Eintrag " + Str(a), ExtractIcon_(0, SystemPath + "\Shell32.dll", a)) 
    Next        
  EndIf 
EndIf 

Repeat 
  EventID.l = WaitWindowEvent() 
Until EventID = #PB_Event_CloseWindow 
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
