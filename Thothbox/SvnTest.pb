Enumeration 
  #ButtonGetList
  #ButtonGetFiles
  #ListViewFiles
EndEnumeration

;Ne sert pas ici, mais ça peut servir plus tard ;)
Procedure.s GetStdOut(Prog.s, Arg.s)
  svn = RunProgram(Prog, Arg, "", #PB_Program_Read|#PB_Program_Hide|#PB_Program_Open )
  Output$ = ""
  If svn
    While ProgramRunning(svn)
      If AvailableProgramOutput(svn)
        Output$ + ReadProgramString(svn) + Chr(13)
      EndIf
    Wend   
    CloseProgram(svn) ; Close the connection to the program
  EndIf
  ProcedureReturn Output$
EndProcedure

Procedure Disabler()
  DisableGadget(#ButtonGetList, 1)
  DisableGadget(#ButtonGetFiles, 1)
  ClearGadgetItems(#ListViewFiles)
EndProcedure

Procedure Enabler()
  DisableGadget(#ButtonGetList, 0)
  DisableGadget(#ButtonGetFiles, 0)
EndProcedure

;Récupère la liste des fichiers sur le serveur google
Procedure GetFileList(nil)
  Disabler()
  txt.s = "Please Wait"
  Counter = 0
  svn = RunProgram("svn\bin\svn.exe", "list http://pb-source-repositery.googlecode.com/svn/trunk/ -R", "", #PB_Program_Read|#PB_Program_Hide|#PB_Program_Open )
  If svn
    While ProgramRunning(svn)     
      txt.s = "Please Wait" 
      Select Counter%400
        Case 1 To 100
          txt + "."
        Case 100 To 200
          txt + ".."
        Case 200 To 300
          txt + "..."
      EndSelect
      SetGadgetText(#ButtonGetList, txt)
      If AvailableProgramOutput(svn)
        AddGadgetItem (#ListViewFiles, -1, ReadProgramString(svn))
      EndIf
      Delay(10)
      Counter + 1
    Wend  
    CloseProgram(svn) ; Close the connection to the program
  EndIf
  SetGadgetText(#ButtonGetList, "Liste des fichiers sur le serveur")
  Enabler()  
EndProcedure


;Télécharge en local une version "lecture seule" sur le serveur
Procedure GetFiles(nil)
  Disabler()
  txt.s = "Please Wait"
  Counter = 0
  svn = RunProgram("svn\bin\svn.exe","checkout http://pb-source-repositery.googlecode.com/svn/trunk/ repositeries\pb-source-repositery-Read-only", "", #PB_Program_Read|#PB_Program_Hide|#PB_Program_Open)
  If svn
    While ProgramRunning(svn)     
      txt.s = "Please Wait" 
      Select Counter%400
        Case 1 To 100
          txt + "."
        Case 100 To 200
          txt + ".."
        Case 200 To 300
          txt + "..."
      EndSelect
      SetGadgetText(#ButtonGetFiles, txt)
      If AvailableProgramOutput(svn)
        AddGadgetItem (#ListViewFiles, -1, ReadProgramString(svn))
      EndIf
      Delay(10)
      Counter + 1
    Wend  
    CloseProgram(svn) ; Close the connection to the program
  EndIf
  SetGadgetText(#ButtonGetFiles, "Récupérer les fichiers")
  Enabler()
  RunProgram("explorer.exe", "repositeries\pb-source-repositery-Read-only", "")
EndProcedure

;- Début du code

If OpenWindow(0, 0, 0, 450, 350, "Google Code Subversion Test", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  
  ButtonGadget(#ButtonGetList, 10, 10, 430, 20, "Liste des fichiers sur le serveur")  
  ListViewGadget(#ListViewFiles, 10, 30, 430, 250)
  ButtonGadget(#ButtonGetFiles, 10, 280, 430, 20, "Récupérer les fichiers")  
  
  Repeat 
    Event = WaitWindowEvent()
    
    Select Event
        
      Case #PB_Event_Gadget
        
        Select EventGadget()
            
          Case #ButtonGetList
            CreateThread(@GetFileList(), nil)
            
          Case #ButtonGetFiles
            CreateThread(@GetFiles(), nil)
            
        EndSelect
        
    EndSelect
    
  Until Event = #PB_Event_CloseWindow
  
EndIf

End
; IDE Options = PureBasic 4.60 Beta 3 (Windows - x86)
; CursorPosition = 92
; FirstLine = 82
; Folding = -
; EnableThread