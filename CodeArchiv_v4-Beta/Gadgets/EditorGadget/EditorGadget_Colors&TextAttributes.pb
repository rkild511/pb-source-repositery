; German forum: http://www.purebasic.fr/german/viewtopic.php?t=460&highlight=
; Author: Falko (updated for PB 4.00 by Andre)
; Date: 15. October 2004
; OS: Windows
; Demo: No

;Richedit Farben und Textattribute. written by Falko 
If OpenWindow(0,0,0,500,400,"EditorGadget colors and attribute",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) And CreateGadgetList(WindowID(0)) 
    hdc.l=EditorGadget (0,8,8,485,385,#PB_Container_Raised) 
    
    ;Textcolor Grün und Fett 
    
     mychar.CHARFORMAT 
     mychar\cbSize=SizeOf(CHARFORMAT) 
     mychar\dwMask=#CFM_BOLD|#CFM_COLOR  
     mychar\dwEffects=1 
     mychar\crTextColor=$00FF00 
    
    SendMessage_(hdc,#EM_SETCHARFORMAT,#SCF_SELECTION,mychar) 
     AddGadgetItem(0,0,"Hier in der ersten Zeile Grün und Fett") 
    
    ;Textcolor Rot und Wahlweise Fett bzw. normaltext(default) 
    
     mychar\cbSize=SizeOf(CHARFORMAT) 
     mychar\dwMask=#CFM_COLOR|#CFM_BOLD 
     mychar\dwEffects=0 ; bei #CFE_BOLD wirds auch Fett 
     mychar\crTextColor=$0000FF 
  
      
     For i= 1 To 5 
      SendMessage_(hdc,#EM_SETCHARFORMAT,#SCF_SELECTION,mychar) 
      AddGadgetItem(0,i,"Und hier in der Zweiten Zeile der Rest Rot"+Str(i)) 
     Next i 
      
     ;Textcolor Blau,kursiv,Fett,Zeilenabstand und Texthöhe 
      
     mychar\cbSize=SizeOf(CHARFORMAT) 
     mychar\dwMask=#CFM_COLOR|#CFM_ITALIC|#CFM_BOLD|#CFM_OFFSET|#CFM_SIZE  
     mychar\dwEffects=#CFE_ITALIC|#CFE_BOLD ; bei 1 wirds auch Fett 
     mychar\yOffset=30 
     mychar\yHeight=300 
     mychar\crTextColor=$FF0000 
      
    
     For i= 1 To 5 
      SendMessage_(hdc,#EM_SETCHARFORMAT,#SCF_SELECTION,mychar) 
      AddGadgetItem(0,i+5,"Und hier ab der zwölften Zeile der Rest Blau"+Str(i+5)) 
     Next i 
    
  
     SendMessage_(hdc,#EM_SETBKGNDCOLOR,0,$FFCC99); Hintergrund gesetzt 
    
    Repeat : Until WaitWindowEvent()=#PB_Event_CloseWindow 
  EndIf 
  
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -