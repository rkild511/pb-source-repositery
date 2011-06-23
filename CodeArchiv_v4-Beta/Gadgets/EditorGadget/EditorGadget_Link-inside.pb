; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6405&start=30
; Author: El_Choni (updated for PB4.00 by blbltheworm)
; Date: 19. June 2003
; OS: Windows
; Demo: No

Declare WndProc(hWnd, uMsg, wParam, lParam) 


#EN_LINK = $70B 
#ENM_LINK = $4000000 
#CFM_LINK = $20 
#CFE_LINK = $20 

Procedure WndProc(hWnd, uMsg, wParam, lParam) 
  result = #PB_ProcessPureBasicEvents 
  Select uMsg 
    Case #WM_NOTIFY 
      *el.ENLINK = lParam 
      If *el\nmhdr\code=#EN_LINK 
        If *el\msg=#WM_LBUTTONDOWN 
          StringBuffer = AllocateMemory(512) 
          txt.TEXTRANGE 
          txt\chrg\cpMin = *el\chrg\cpMin 
          txt\chrg\cpMax = *el\chrg\cpMax 
          txt\lpstrText = StringBuffer 
          SendMessage_(GadgetID(0), #EM_GETTEXTRANGE, 0, txt) 
          Debug PeekS(StringBuffer) 
          FreeMemory(StringBuffer) 
        EndIf 
      EndIf 
  EndSelect 
  ProcedureReturn result 
EndProcedure 

If OpenWindow(0, 100, 200, 195, 260, "PureBasic Window", #PB_Window_SystemMenu|#PB_Window_MinimizeGadget|#PB_Window_MaximizeGadget)=0:End:EndIf 
If CreateGadgetList(WindowID(0))=0:End:EndIf 
EditorGadget(0, 0, 0, WindowWidth(0), WindowHeight(0)) 
SendMessage_(GadgetID(0), #EM_SETEVENTMASK, 0, #ENM_LINK|SendMessage_(GadgetID(0), #EM_GETEVENTMASK, 0, 0)) 
EditorText$ = "I don't wanna be a link,"+Chr(10)+"but I am a link,"+Chr(10)+"what do you think?" 
Link$ = "I am a link" 
SetGadgetText(0, EditorText$) 
Start = FindString(EditorText$, Link$, 1) 
SendMessage_(GadgetID(0), #EM_EXGETSEL, 0, chr.CHARRANGE) 
SendMessage_(GadgetID(0), #EM_HIDESELECTION, #True, 0) 
SendMessage_(GadgetID(0), #EM_SETSEL, Start-1, Start+Len(Link$)-1) 
cf.CHARFORMAT2 
cf\cbSize = SizeOf(CHARFORMAT2) 
SendMessage_(GadgetID(0), #EM_GETCHARFORMAT, #SCF_SELECTION, cf) 
cf\cbSize = SizeOf(CHARFORMAT2) 
cf\dwMask|#CFM_LINK 
cf\dwEffects|#CFE_LINK 
SendMessage_(GadgetID(0), #EM_SETCHARFORMAT, #SCF_SELECTION, cf) 
SendMessage_(GadgetID(0), #EM_EXSETSEL, 0, chr) 
SendMessage_(GadgetID(0), #EM_HIDESELECTION, #False, 0) 
SetWindowCallback(@WndProc()) 
Repeat:Until WaitWindowEvent()=#PB_Event_CloseWindow 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
