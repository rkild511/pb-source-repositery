; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7598&highlight=
; Author: Freak (updated for PB4.00 by blbltheworm)
; Date: 21. September 2003
; OS: Windows
; Demo: No

Procedure Editor_Select(Gadget, LineStart.l, CharStart.l, LineEnd.l, CharEnd.l)    
  sel.CHARRANGE 
  sel\cpMin = SendMessage_(GadgetID(Gadget), #EM_LINEINDEX, LineStart, 0) + CharStart - 1 
  
  If LineEnd = -1 
    LineEnd = SendMessage_(GadgetID(Gadget), #EM_GETLINECOUNT, 0, 0)-1 
  EndIf 
  sel\cpMax = SendMessage_(GadgetID(Gadget), #EM_LINEINDEX, LineEnd, 0) 
  
  If CharEnd = -1 
    sel\cpMax + SendMessage_(GadgetID(Gadget), #EM_LINELENGTH, sel\cpMax, 0) 
  Else 
    sel\cpMax + CharEnd - 1 
  EndIf 
  SendMessage_(GadgetID(Gadget), #EM_EXSETSEL, 0, @sel) 
EndProcedure 

; Set the Text color for the Selection 
; in RGB format 
Procedure Editor_Color(Gadget, Color.l) 
  format.CHARFORMAT 
  format\cbSize = SizeOf(CHARFORMAT) 
  format\dwMask = #CFM_COLOR 
  format\crTextColor = Color 
  SendMessage_(GadgetID(Gadget), #EM_SETCHARFORMAT, #SCF_SELECTION, @format) 
EndProcedure 

; Set Font Size for the Selection 
; in pt 
Procedure Editor_FontSize(Gadget, Fontsize.l) 
  format.CHARFORMAT 
  format\cbSize = SizeOf(CHARFORMAT) 
  format\dwMask = #CFM_SIZE 
  format\yHeight = Fontsize*20 
  SendMessage_(GadgetID(Gadget), #EM_SETCHARFORMAT, #SCF_SELECTION, @format) 
EndProcedure 

; Set Font for the Selection 
; You must specify a font name, the font doesn't need 
; to be loaded 
Procedure Editor_Font(Gadget, FontName.s) 
  format.CHARFORMAT 
  format\cbSize = SizeOf(CHARFORMAT) 
  format\dwMask = #CFM_FACE 
  PokeS(@format\szFaceName, FontName) 
  SendMessage_(GadgetID(Gadget), #EM_SETCHARFORMAT, #SCF_SELECTION, @format) 
EndProcedure 


If OpenWindow(1,300,250,400,200,"Window",#PB_Window_SystemMenu) 
  CreateGadgetList(WindowID(1)) 
  EditorGadget(1,10,10,300,150) 

  SetGadgetText(1, "Here comes a nice J Smiley.") 

  Editor_Select(1, 0, 19, 0, 20) 
  Editor_Font(1, "WingDings") 
  Editor_FontSize(1, 20)    
  Editor_Color(1, $0000FF) 
  
  Repeat : Until WaitWindowEvent()=#PB_Event_CloseWindow 
EndIf 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
