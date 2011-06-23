; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2097&highlight=
; Author: Smash (updated for PB 4.00 by Andre)
; Date: 25. August 2003
; OS: Windows
; Demo: Yes


;========= 
; @ Smash 
;========= 
; 
;     Texte blitzschnell verschlüsseln und entschlüsseln 
; 
;################################################################ 
  If OpenWindow(0, 50, 200, 555, 110, "asc", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_TitleBar) 
    If CreateGadgetList(WindowID(0)) 
      StringGadget(1, 20, 10, 510, 20, "Nach dem drücken eines Buttons, steht der Text auch in der Zwischenablage.") 
      ButtonGadget(2, 20, 50, 90, 30, "verschlüsseln") 
      ButtonGadget(3, 120, 50, 90, 30, "entschlüsseln") 
    EndIf 
  EndIf 
  
  
  ;################################################################ 
Repeat 
    Select WindowEvent() 

      Case #PB_Event_CloseWindow   ; ALT+F4 
            End          

      Case #PB_Event_Gadget 
        Select EventGadget() 
          Case 2 
;-Text verschlüsseln 
              von.w = 97 
              zu.w  = 127 
              String$ = GetGadgetText(1)              
              For a = 0 To 25 
                If a = 18 ; schließe diese beiden Zeichen aus (´=145) (´=146)  (s t) 
                   a = a+2 ; siehe  Tools `ASCII Table´ 
                EndIf 
                von$ = Chr(von.w+a) 
                zu$ = Chr(zu.w+a) 
                String$ = ReplaceString (String$,von$,zu$ ) 
              Next a 
              SetGadgetText(1,String$) 
              SetClipboardText(String$) 

          Case 3 
;-Text entschlüsseln 
              von.w = 127 
              zu.w  = 97 
              String$ = GetGadgetText(1)              
              For a = 0 To 25 
                If a = 18 
                   a = a+2 
                EndIf 
                von$ = Chr(von.w+a) 
                zu$ = Chr(zu.w+a) 
                String$ = ReplaceString (String$,von$,zu$ ) 
              Next a 
              SetGadgetText(1,String$) 
              SetClipboardText(String$) 
        EndSelect 
    EndSelect 

Delay (3)      ;(CPU Power) 
ForEver 
;################################################################
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
