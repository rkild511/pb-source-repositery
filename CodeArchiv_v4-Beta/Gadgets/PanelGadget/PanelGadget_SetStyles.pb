; English forum: http://www.purebasic.fr/english/viewtopic.php?t=13337&highlight=
; Author: Flype (updated for PB 4.00 by Andre)
; Date: 10. December 2004
; OS: Windows
; Demo: No


; Question: Is it possible to change the orientation of a panelgadget ?

; Answer: 
; Some infos here ( go to the 'tab styles' lines ) : http://www.autohotkey.com/docs/misc/Styles.htm 
; And here how to set styles... 

#TCS_SCROLLOPPOSITE = $1 
#TCS_BOTTOM         = $2 
#TCS_RIGHT          = $2 
#TCS_MULTISELECT    = $4 
#TCS_FLATBUTTONS    = $8 
#TCS_FORCEICONLEFT  = $10 
#TCS_FORCELABELLEFT = $20 
#TCS_HOTTRACK       = $40 
#TCS_VERTICAL       = $80 
#TCS_MULTILINE      = $200 

Procedure SetStyle(Handle, style.l) 
  SetWindowLong_(Handle, #GWL_STYLE, GetWindowLong_(Handle, #GWL_STYLE) | style) 
EndProcedure 

OpenWindow(0, 300, 300, 300, 300, "Tab test", #PB_Window_SystemMenu, 0) 
CreateGadgetList(WindowID(0)) 
PanelGadget(0, 0, 0, 300, 300) 
For i = 1 To 9 
  AddGadgetItem(0, i - 1, "Onglet " + Str(i)) 
Next 
CloseGadgetList() 
  
SetStyle(GadgetID(0),#TCS_MULTILINE) 
SetGadgetState(0,0) 
  
Repeat : Until WaitWindowEvent()=#WM_CLOSE 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP