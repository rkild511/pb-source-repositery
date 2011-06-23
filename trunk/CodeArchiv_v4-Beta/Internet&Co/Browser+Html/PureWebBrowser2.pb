; German forum:
; Author: galaxy and NicTheQuick (updated for PB4.00 by blbltheworm)
; Date: 08. April 2003
; OS: Windows
; Demo: No

;purebasic WEB 
;Demo und Anwendungsprogramm für Pure-Basic 
;(C) 2003, by galaxy and NicTheQuick 

#WebBrowser  = 0 
#buttonBack  = 1 
#buttonForw  = 2 
#buttonStop  = 3 
#ComboListe  = 4 
#StatusInfo  = 5 

Procedure.s Getdir() 
  Dir.s  = Space(255) 
  Length.l = GetCurrentDirectory_(255, @Dir) 
  ProcedureReturn Left(Dir, Length) + "\" 
EndProcedure 

Structure Site 
  Name.s 
  Zusatz.s 
  Url.s 
EndStructure 
Global NewList Site.Site() 

Procedure AddSite(Name.s, Zusatz.s, Url.s) 
  LastElement(Site()) 
  AddElement(Site()) 
  Site()\Name = Name 
  Site()\Url = Url 
  Site()\Zusatz = Zusatz 
  AddGadgetItem(#ComboListe, -1, " " + Name + " " + Zusatz) 
EndProcedure 

Procedure OpenMainWindow(Width.l, Height.l) 
  If OpenWindow(0, 0, 0, Width, Height, "Pure-Web", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_SizeGadget | #PB_Window_MaximizeGadget) 
    If CreateGadgetList(WindowID(0)) 
      ButtonGadget(#buttonBack, 5, 5, 45, 20, "<<") 
      ButtonGadget(#buttonForw, 50, 5, 45, 20, ">>") 
      ButtonGadget(#buttonStop, 100, 5, 45, 20, "Stop") 
      ComboBoxGadget(#ComboListe, Width - 325, 5, 320, 600) 
      WebGadget(#WebBrowser, 0, 30, Width, Height - 48, Getdir() + "load.htm") 
      TextGadget(#StatusInfo, 0, Height - 18, Width, 18, "", #PB_Text_Border) 
    Else 
      ProcedureReturn #False 
    EndIf 
  Else 
    ProcedureReturn #False 
  EndIf 
  ProcedureReturn #True 
EndProcedure 

Procedure RefreshMainWindow(Width.l, Height.l) 
  Protected CLWidth.l 
  ;Überprüfung auf Breite der ComboBox 
  CLWidth = 320 
  MinClWidth = 100 
  If Width - 325 < 150 : CLWidth = Width - 155 : EndIf 
  If CLWidth < MinClWidth : Width = MinClWidth + 155 : EndIf 
  ;Überprüfung auf Höhe des WebGadgets 
  MinWGHeight = 40 
  If Height - 48 < MinWGHeight : Height = MinWGHeight + 48 : EndIf 
  ResizeWindow(0,#PB_Ignore,#PB_Ignore,Width, Height) 
  ResizeGadget(#ComboListe, Width - CLWidth - 5,#PB_Ignore, CLWidth,#PB_Ignore) 
  ResizeGadget(#WebBrowser,#PB_Ignore,#PB_Ignore, Width, Height - 48) 
  ResizeGadget(#StatusInfo,#PB_Ignore, Height - 18, Width,#PB_Ignore) 
EndProcedure 

Procedure CreateLoadSite(Text.s) 
  CreateFile(0, Getdir() + "load.htm") 
    WriteStringN(0,"<H2>" + Text + "</H2>") 
  CloseFile(0) 
EndProcedure 

Width.l = 800 
Height.l = 600 
OpenMainWindow(Width, Height) 

;- Sites hinzufügen 
AddSite("Homepage von PureBasic", "(deutsch)", "http://www.purebasic.de") 
AddSite("Deutsches PureBoard", "(deutsch)", "http://robsite.de/php/pureboard/index.php") 
AddSite("Tutorials", "(deutsch)", "http://www.robsite.de/tutorials.php?tut=purebasic") 
AddSite("Internationales PureBoard", "(englisch)", "http://forums.purebasic.com/") 
AddSite("Purebasic Resource Site", "(englisch)", "http://www.reelmediaproductions.com/pb/") 

SetGadgetState(#ComboListe,  0) 

CreateLoadSite("Wählen sie oben rechts eine Seite aus.") 
SetGadgetText(#WebBrowser, Getdir() + "load.htm") 

sNum.l = -1 
Repeat 
  EventID.l = WaitWindowEvent() 
  
  If WindowHeight(0) <> Height Or WindowWidth(0) <> Width 
    Width = WindowWidth(0) 
    Height = WindowHeight(0) 
    RefreshMainWindow(Width, Height) 
  EndIf 
  
  SetGadgetText(#StatusInfo, "Adresse: "  + GetGadgetText(#WebBrowser)) 
  
  Select EventID 
    Case #PB_Event_Gadget 
      Select EventGadget() 
        Case #buttonBack 
          SetGadgetState(#WebBrowser, #PB_Web_Back) 
        Case #buttonForw 
          SetGadgetState(#WebBrowser, #PB_Web_Forward)        
        Case #buttonStop 
          SetGadgetState(#WebBrowser, #PB_Web_Stop)          
        Case #ComboListe 
          num = GetGadgetState(#ComboListe) 
          If num >= 0 
            If sNum <> num 
              SelectElement(Site(), num) 
              CreateLoadSite("Lade " + Site()\Name + "...") 
              
              SetGadgetText(#WebBrowser, Getdir()  + "load.htm") 
              SetGadgetText(#WebBrowser,  Site()\Url) 
              SetActiveGadget(#WebBrowser) 
              sNum  = num 
            EndIf 
          Else 
            num  = sNum 
          EndIf 
      EndSelect 
EndSelect 
Until EventID = #PB_Event_CloseWindow

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -