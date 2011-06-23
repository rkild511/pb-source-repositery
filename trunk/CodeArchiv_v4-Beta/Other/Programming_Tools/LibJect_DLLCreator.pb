; German forum: http://www.purebasic.fr/german/viewtopic.php?t=1153&highlight=
; Author: Hroudtwolf (updated for PB 4.00 by Andre)
; Date: 08. December 2004
; OS: Windows
; Demo: No


; Source von meinem Projekt LibJect, welches im Showcase ausgestellt wird.
; Vieleicht hat ja jemand Lust, es weiter zu entwickeln.
;
; Damit kann man Bilder und andere Ressourcen in DLL einfügen bzw welche
; damit erstellen.

Global myText$
Global hWnd.l
Global TextWidth.l
Global wnx
Global wnpar
Global dn$
Global cpf$

#ScrollSpeed_in_Milliseconds = 70
Breite.l = GetSystemMetrics_(#SM_CXSCREEN)
Hoehe.l= GetSystemMetrics_(#SM_CYSCREEN)
wnx=Int(breite/2)-200
wny=Int(hoehe/2)-200
wnpar=  #PB_Window_TitleBar |   #PB_Window_SystemMenu     |  #PB_Window_MinimizeGadget | #PB_Window_BorderLess
myText$ = "     -|-|-|-  LibJect von Marc-Sven Rudolf  ->Hroudtwolf<-  2004(r) zur Erstellung von BITMAP-DLLs. Getestet mit Pure-Basic PROFESIONELL    -|-|-|-"
TextWidth = Len(myText$)


Procedure compl()

  If OpenWindow(2,wnx,200,400,150,"Dateinamen.",wnpar)
    dn$="LibJect.Dll"
    If CreateGadgetList (WindowID(2))
      TextGadget (22,5,40,390,20,"Bitte einen Dateinamen (mit Endung z.B. BlaBla.Dll) eingeben.")
      StringGadget(20,5,90,390,20,"LibJect.Dll")
      ButtonGadget (21,5,120,80,25,"Fertig")
    EndIf
    Repeat
      SetActiveWindow(2)
      EventID.l = WindowEvent()

      If eventid= #PB_Event_Gadget
        Select EventGadget ()

          Case 21
            dn$=GetGadgetText(20)
            quit=1
        EndSelect

      EndIf
      If EventID = #PB_Event_CloseWindow
        Quit = 1
      EndIf
    Until Quit = 1
    CloseWindow(2)
    SetActiveWindow(1)

  EndIf




  If OpenWindow(2,wnx,200,400,80,"Fortschritt",wnpar)
    If CreateGadgetList (WindowID(2))
      ProgressBarGadget(31,5,40,390,20,1,5,#PB_ProgressBar_Smooth   )
    EndIf
    SetActiveWindow(2)
    If GetGadgetText(2)="dd:\Compilerpfad\"
      cpf$=PathRequester("PB Compiler-Pfad" , "c:\")
      SetGadgetText (2,cpf$)
    EndIf

    Delay (1000)
    SetGadgetState(31,1)
    If CreateFile (1,cpf$+"LibJect.pb")
      For x=0 To CountGadgetItems (1)
        WriteStringN(1,GetGadgetItemText (1,x,0))
      Next x
      Delay (1000)
      SetGadgetState(31,2)
      For x=0 To CountGadgetItems (3)
        WriteStringN(1,GetGadgetItemText (3,x,0))
      Next x
      CloseFile(1)
    Else
      MessageRequester ("Fehler","Die Datei konnte nicht gespeichert werden." ,0)
    EndIf
    SetGadgetState(31,3)
    If RunProgram (cpf$+"PBCompiler.exe","/dll "+cpf$+"LibJect.pb","",2):EndIf
    Delay (2000)
    SetGadgetState(31,4)
    RenameFile (cpf$+"purebasic.dll",cpf$+dn$)

    Delay (1000)
    SetGadgetState(31,5)
    Delay (1000)
    CloseWindow(2)
  EndIf

EndProcedure








Procedure Scroller()
  ;Shared Scroller_a
  Shared Scroller_Position
  Shared Scroller_Direction

  If Scroller_Position < TextWidth + 1 And Scroller_Direction = 0
    TEMP$ = Right(myText$,Scroller_Position)
    SetWindowText_(hWnd, TEMP$)
    Scroller_Position+1
  Else
    Scroller_Direction = 1
    TEMP$ = Right(myText$,Scroller_Position)
    SetWindowText_(hWnd, TEMP$)
    Scroller_Position-1
    If Scroller_Position = 0 : Scroller_Direction = 0 : EndIf
  EndIf
EndProcedure




If OpenWindow (1,wnx,wny,400,420,"LibJect von Marc-Sven Rudolf ->Hroudwolf<-  2004(r)",wnpar)
  hwnd=WindowID(1)


  If CreateGadgetList (WindowID(1))
    ListViewGadget (1,5,25,390,160,0)

    ListViewGadget (3,5,185,390,185,0)

    ButtonGadget (5,310,377,80,20,"Löschen")
    ButtonGadget (6,220,377,80,20,"Einfügen")

    ButtonGadget (7,5,5,100,20,"Setze Compilerpfad")
    TextGadget (2,110,5,285,20,"dd:\Compilerpfad\",  #PB_Text_Border )

    ButtonGadget (9,5,377,80,20,"Über LIBJECT")
    ButtonGadget (10,90,377,80,20,"Compiliere DLL")
    ButtonGadget (11,5,397,80,20,"Speichere .PB")
    ButtonGadget (12,90,397,80,20,"Neue DLL")
  EndIf

  AddGadgetItem (1,-1,"ProcedureDLL.l BmpInject_(num.l)")
  AddGadgetItem (1,-1,"Select num.l")
  AddGadgetItem (1,-1," ;Hier kommen die BMPs rein")
  ;AddGadgetItem (1,-1," Default:gib.l = 0")
  AddGadgetItem (1,-1,"EndSelect ")
  AddGadgetItem (1,-1,"ProcedureReturn gib.l  ")
  AddGadgetItem (3,-1,"; LibJect V1.04  von Marc-Sven Rudolf")
  AddGadgetItem (3,-1,"     DataSection")
  AddGadgetItem (3,-1,"     EndDataSection")
  AddGadgetItem (3,-1,"EndProcedure")
  Repeat
    EventID.l = WindowEvent()
    If soweit=0:soweit=1:nun=GetTickCount_()+45:EndIf
    If soweit=1 And nun<GetTickCount_():soweit=0:scroller():EndIf

    If  eventid= #PB_Event_Gadget
      Select EventGadget()
        Case 6
          datei$=OpenFileRequester ("BMP einfügen","*.bmp","BITMAP | *.bmp",0)
          If datei$<>""
            nn$=GetFilePart(Datei$)

            nn$=Trim(nn$)
            nn$=Left (nn$,Len(nn$)-4)
            anz=CountGadgetItems (1)-5
            AddGadgetItem (1,2,"Case "+Str(anz)+" :gib.l=?"+ nn$)
            AddGadgetItem (3 ,2,nn$+": IncludeBinary "+Chr(34)+datei$+Chr(34))
          EndIf
        Case 5
          gew= GetGadgetState (3)
          If gew>0
            RemoveGadgetItem (1,gew)
            RemoveGadgetItem (3,gew)
          EndIf

        Case 11
          datei$=SaveFileRequester ("PB-Source sichern","*.pb","BITMAP | *.pb",0)
          If Trim(GetExtensionPart(datei$))=".":datei$=datei$+".pb":EndIf
          If CreateFile (1,datei$)
            For x=0 To CountGadgetItems (1)
              WriteStringN(1,GetGadgetItemText (1,x,0))
            Next x
            For x=0 To CountGadgetItems (3)
              WriteStringN(1,GetGadgetItemText (3,x,0))
            Next x
            CloseFile(1)
            MessageRequester ("Zur Kenntnis.......","Die Datei wurde als >"+ datei$ +"< gespeichert." ,0)
          Else
            MessageRequester ("Fehler","Die Datei konnte nicht gespeichert werden." ,0)
          EndIf

        Case 7
          cpf$=PathRequester("PB Compiler-Pfad" , "c:\")
          SetGadgetText (2,cpf$)

        Case 10
          Compl()

        Case 12
          ClearGadgetItemList(1)
          ClearGadgetItemList(3)

        Case 9
          MessageRequester ("Über LibJect","LibJect Version 1.04g"+Chr (10)+"geschrieben von: Marc-Sven Rudolf (Hroudtwolf)"+Chr(10)+Chr(10)+"E-Post: Hroudt_Wolf@Web.de" ,0)


      EndSelect
    EndIf

    If EventID = #PB_Event_CloseWindow
      Quit = 1
    EndIf
    Delay (5)
  Until Quit = 1

EndIf

End

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger