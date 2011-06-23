; German forum:
; Author: Galaxy (updated for PB4.00 by blbltheworm)
; Date: 08. April 2003
; OS: Windows
; Demo: No

;purebasic WEB 
;Demo und Anwendungsprogramm für Pure-Basic 
;(C) 2003, by Galaxy 

; 08. April 2003 - German forum

Procedure.s Getdir() 
  datei$ = Space(255) 
  GetCurrentDirectory_(255,datei$) 
  ProcedureReturn Trim(datei$) + "\" 
EndProcedure 


#WebBrowser = 0 
#buttonBack = 1 
#buttonForw = 2 
#buttonStop = 3 
#ComboListe = 10 
#StatusInfo = 999 

#font_Button = 0 
#font_Liste  = 1 

OpenWindow(0, 0, 0, 800, 600, "Pure-Web", #PB_Window_MinimizeGadget) 
CreateGadgetList(WindowID(0)) 

CreateFile(0,"load.htm") 
WriteStringN(0,"<H2>Lade URL ... </H2>") 
CloseFile(0) 

FontID1 = LoadFont(#font_Button, "arial", 14 ,#PB_Font_Bold) 
FontID2 = LoadFont(#font_Liste,  "courier new", 10  ,#PB_Font_Bold) 

WebGadget(#WebBrowser, 5, 35, 790, 550, Getdir() + "load.htm") 
ButtonGadget(#buttonBack, 5, 4, 55, 25, "<<") 
ButtonGadget(#buttonForw, 60, 4, 55, 25, ">>") 
ButtonGadget(#buttonStop, 120, 4, 55, 25, "Stop") 

ComboBoxGadget(#ComboListe, 477, 4, 320, 525) 
AddGadgetItem(#ComboListe, 0,  " Homepage von Purebasic    (deutsch)    |http://www.purebasic.de") 
AddGadgetItem(#ComboListe, -1, " deutsches PureBoard       (deutsch)    |http://robsite.de/php/pureboard/index.php") 
AddGadgetItem(#ComboListe, -1, " Tutorials                 (deutsch)    |http://www.robsite.de/tutorials.php?tut=purebasic") 
AddGadgetItem(#ComboListe, -1, " internationales PureBoard (englisch)   |http://forums.purebasic.com/") 
AddGadgetItem(#ComboListe, -1, " Purebasic Resource Site   (englisch)   |http://www.reelmediaproductions.com/pb/") 
SetGadgetState(#ComboListe, 0) 

TextGadget(999, 5, 587, 790, 20, "") 

SetGadgetFont(#buttonBack, FontID1) 
SetGadgetFont(#buttonforw, FontID1) 
SetGadgetFont(#buttonStop, FontID1) 
SetGadgetFont(#ComboListe, FontID2) 

SetGadgetText(#WebBrowser, StringField(GetGadgetText(#ComboListe),2,"|")) 

Repeat 
  eventID.l = WaitWindowEvent() 
  SetGadgetText(#StatusInfo,"Adresse: " + GetGadgetText(#WebBrowser)) 
  
  Select eventID 
    Case #PB_Event_Gadget 
     If EventGadget() = #ButtonBack 
      SetGadgetState(#WebBrowser,#PB_Web_Back) 
     EndIf 
     If EventGadget() = #ButtonForw 
      SetGadgetState(#WebBrowser,#PB_Web_Forward) 
     EndIf 
     If EventGadget() = #ButtonStop 
      SetGadgetState(#WebBrowser,#PB_Web_Stop) 
     EndIf 
  
     If EventGadget() = #ComboListe 
      num = GetGadgetState(10) 
      If num <> -1 
       If sNum <> num 
        SetGadgetText(#WebBrowser,getdir() + "load.htm") 
        SetGadgetText(#WebBrowser, StringField(GetGadgetText(#ComboListe),2,"|")) 
        SetActiveGadget(#WebBrowser) 
        sNum = num 
       EndIf 
      Else 
       num = sNum 
      EndIf 
  
     EndIf 
  
  EndSelect 
  
Until EventID = #PB_Event_CloseWindow 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger