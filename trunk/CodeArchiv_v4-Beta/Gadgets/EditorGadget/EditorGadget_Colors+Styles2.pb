; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6872&highlight=
; Author: PWS32 (updated for PB4.00 by blbltheworm)
; Date: 11. July 2003
; OS: Windows
; Demo: No

; Selects Text inside an EditorGadget 
; Line numbers range from 0 to CountGadgetItems(#Gadget)-1 
; Char numbers range from 1 to the length of a line 
; Set Line numbers to -1 to indicate the last line, and Char 
; numbers to -1 to indicate the end of a line 
; selecting from 0,1 to -1, -1 selects all. 


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
  format\yHeight = FontSize*20 
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

; Set Format of the Selection. This can be a combination of 
; the following values: 
; #CFM_BOLD 
; #CFM_ITALIC 
; #CFM_UNDERLINE 
; #CFM_STRIKEOUT 
Procedure Editor_Format(Gadget, Flags.l) 
  format.CHARFORMAT 
  format\cbSize = SizeOf(CHARFORMAT) 
  format\dwMask = #CFM_ITALIC|#CFM_BOLD|#CFM_STRIKEOUT|#CFM_UNDERLINE 
  format\dwEffects = Flags 
  SendMessage_(GadgetID(Gadget), #EM_SETCHARFORMAT, #SCF_SELECTION, @format) 
EndProcedure 


; ------------------------------------------------------------- 
; Source Example: 


#Editor = 1 

If OpenWindow(0, 0, 0, 500, 500, "EditorGadget", #PB_Window_SystemMenu|#PB_Window_ScreenCentered) 
  If CreateGadgetList(WindowID(0)) 
    
    EditorGadget(#Editor, 10, 10, 480, 480) 
    
    AddGadgetItem(#Editor, 0, "Line 1")      
    AddGadgetItem(#Editor, 1, "Line 2")    
    AddGadgetItem(#Editor, 2, "Line 3") 
    AddGadgetItem(#Editor, 3, "Line 4") 
       
    SendMessage_(GadgetID(#EDITOR),#EM_SETBKGNDCOLOR,0,RGB($FF,$FF,$BF)) 
    
      Editor_Select(#Editor, 0, 1, 0, -1)  ; select line 1 
      Editor_Color(#Editor, RGB(0,0,255)) 
      Editor_FontSize(#Editor, 18) 
      Editor_Format(#Editor, #CFM_UNDERLINE) 
      
    Editor_Select(#Editor, 1, 0, 1, -1)  ; select line 2 
      Editor_Color(#Editor, RGB(255,0,0)) 
      Editor_Font(#Editor, "Times New Roman") 
      Editor_Format(#Editor, #CFM_ITALIC|#CFM_STRIKEOUT) 

    Editor_Select(#Editor, 2, 0, 2, -1)  ; select line 3 
      Editor_Color(#Editor, RGB(255,0,0)) 
      Editor_Font(#Editor, "Times New Roman") 
      Editor_FontSize(#Editor, 18) 
      Editor_Format(#Editor, #CFM_BOLD) 

    Editor_Select(#Editor, 3, 0, 3, -1)  ; select line 4 
      ;Editor_Color(#Editor, RGB(255,0,0)) 
      Editor_Font(#Editor, "Times New Roman") 
      Editor_FontSize(#Editor, 10) 
      Editor_Format(#Editor, #CFM_BOLD) 

    Editor_Select(#Editor, 0, 0, 0, 0)   ; select nothing again 

    
    Repeat 
    Until WaitWindowEvent() = #PB_Event_CloseWindow 
  EndIf 
EndIf 

End 


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
