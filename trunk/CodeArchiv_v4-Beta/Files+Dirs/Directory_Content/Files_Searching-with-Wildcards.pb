; German forum: http://www.purebasic.fr/german/viewtopic.php?t=11673&highlight=
; Author: CNESM (updated by Andre)
; Date: 18. January 2007
; OS: Windows
; Demo: Yes


; Searching with wildcards, following wildcards are supported:
; Suchen mit Wildcards, folgende Wildcards werden unterstützt:

; *ureBasic 
; PureBasi* 
; *ureBasi* 
; *ur*Basi* 


Global Such$, Verz$, l , Modus
Verz$ = "C:\"

Declare SearchAllPath(Path$,Rek,File$)
Declare SearchOnePath(Path$,Rek,File$)

If OpenWindow(0, 0, 0, 400, 480,"Suche", #PB_Window_ScreenCentered) = 0 : End : EndIf
If CreateGadgetList(WindowID(0)) = 0 : End : EndIf

ButtonGadget        (6, 290, 10,   100, 18,"Nur Hauptpfad")
ButtonGadget        (8, 290, 40,   100, 18,"Alle Unterordner")
ButtonGadget      (10, 290, 70,   100, 18,"End")


StringGadget(11,8, 10,206,20,"*est.exe")
StringGadget(13,8, 40,206,20,"C:\")

x =  #PB_ListIcon_GridLines | #PB_ListIcon_AlwaysShowSelection | #PB_ListIcon_FullRowSelect
ListIconGadget (12, 10, 125, 380, 345,"Ergebnisse", 800, x)

Repeat
  Event = WaitWindowEvent()
  If  Event = #PB_Event_Gadget Or Event =  #PB_Event_Menu
    Select EventGadget()

      Case 6   ;----------------------------------------------------------- Button VerzeichnisWahl

        ClearGadgetItemList(12) : SearchOnePath(GetGadgetText(13), 0, GetGadgetText(11))


      Case 8   ;----------------------------------------------------------- Button Suchen

        ClearGadgetItemList(12) : SearchAllPath(GetGadgetText(13),0,GetGadgetText(11))

      Case 10

        End



    EndSelect
  EndIf
Until Event = #PB_Event_CloseWindow
End


Procedure SearchAllPath(Path$,Rek,File$)
  If ExamineDirectory(Rek,Path$,"")=0
    MessageRequester("Error!","Path checking failed!",0)
  Else
    Repeat
      Typ=NextDirectoryEntry(Rek):Name$=DirectoryEntryName(Rek)
      If Typ=1
        If CountString(File$,"*")=0
          If Typ=1 And Name$=File$
            If ReadFile(0,Path$+Name$)
              AddGadgetItem(12,-1,Path$+Name$)
            Else
              MessageRequester("Error!","No file(s) found!",0)
            EndIf
          EndIf
        ElseIf CountString(File$,"*")=3 And Left(File$,1)="*" And Right(File$,1)="*"
          NewPos=1
          StarPosition=1
          Found=1
          NewFile$=RemoveString(File$,"*")
          For A=1 To Len(NewFile$)
            If Found=0
              Break
            ElseIf Found=1
              NewNewFile$=Mid(NewFile$,StarPosition,1)
              Pos=FindString(Name$,NewNewFile$,NewPos)

              If Pos=0
                NewPos=NewPos+1
                Found=0
              Else
                NewPos=Pos+1
                StarPosition=StarPosition+1
                Found=1
              EndIf
            EndIf
          Next
          If Found=1
            AddGadgetItem(12,-1,Path$+Name$+" ?")
          EndIf
        ElseIf Left(File$,1)="*" And Right(File$,1)="*"
          NewFile$=RemoveString(File$,"*")
          If FindString(Name$,NewFile$,1)=0
          ElseIf FindString(Name$,NewFile$,1)<>0
            AddGadgetItem(12,-1,Path$+Name$)
          EndIf
        ElseIf Left(File$,1)="*"
          NewFile$=RemoveString(File$,"*")
          If FindString(Name$,NewFile$,1)=0
          ElseIf FindString(Name$,NewFile$,1)<>0
            AddGadgetItem(12,-1,Path$+Name$)
          EndIf
        ElseIf Right(File$,1)="*"
          NewFile$=RemoveString(File$,"*")
          If FindString(Name$,NewFile$,1)=0
          ElseIf FindString(Name$,NewFile$,1)<>0
            AddGadgetItem(12,-1,Path$+Name$)
          EndIf
        ElseIf FindString(File$,"*",1)<>0
          Pos=FindString(File$,"*",1)
          If Left(File$,Pos-1)=Left(Name$,Pos-1)
            Length=Len(File$)-Pos
            If Right(File$,Length)=Right(Name$,Length)
              AddGadgetItem(12,-1,Path$+Name$)
            EndIf

          EndIf
        EndIf
      ElseIf Typ=2 And Name$<>"."And Name$<>".."
        SearchAllPath(Path$+Name$+"\",Rek+1,File$)
      EndIf
    Until Typ=0
  EndIf
EndProcedure


Procedure SearchOnePath(Path$,Rek,File$)
  If ExamineDirectory(Rek,Path$,"")=0
    MessageRequester("Error!","Path checking failed!",0)
  Else
    Repeat
      Typ=NextDirectoryEntry(Rek):Name$=DirectoryEntryName(Rek)
      If Typ=1
        If CountString(File$,"*")=0
          If Typ=1 And Name$=File$
            If ReadFile(0,Path$+Name$)
              AddGadgetItem(12,-1,Path$+Name$)
            Else
              MessageRequester("Error!","No file(s) found!",0)
            EndIf
          EndIf
        ElseIf CountString(File$,"*")=3 And Left(File$,1)="*" And Right(File$,1)="*"
          NewPos=1
          StarPosition=1
          Found=1
          NewFile$=RemoveString(File$,"*")
          For A=1 To Len(NewFile$)
            If Found=0
              Break
            ElseIf Found=1
              NewNewFile$=Mid(NewFile$,StarPosition,1)
              Pos=FindString(Name$,NewNewFile$,NewPos)

              If Pos=0
                NewPos=NewPos+1
                Found=0
              Else
                NewPos=Pos+1
                StarPosition=StarPosition+1
                Found=1
              EndIf
            EndIf
          Next
          If Found=1
            AddGadgetItem(12,-1,Path$+Name$+" ?")
          EndIf
        ElseIf Left(File$,1)="*" And Right(File$,1)="*"
          NewFile$=RemoveString(File$,"*")
          If FindString(Name$,NewFile$,1)=0
          ElseIf FindString(Name$,NewFile$,1)<>0
            AddGadgetItem(12,-1,Path$+Name$)
          EndIf
        ElseIf Left(File$,1)="*"
          NewFile$=RemoveString(File$,"*")
          If FindString(Name$,NewFile$,1)=0
          ElseIf FindString(Name$,NewFile$,1)<>0
            AddGadgetItem(12,-1,Path$+Name$)
          EndIf
        ElseIf Right(File$,1)="*"
          NewFile$=RemoveString(File$,"*")
          If FindString(Name$,NewFile$,1)=0
          ElseIf FindString(Name$,NewFile$,1)<>0
            AddGadgetItem(12,-1,Path$+Name$)
          EndIf
        ElseIf FindString(File$,"*",1)<>0
          Pos=FindString(File$,"*",1)
          If Left(File$,Pos-1)=Left(Name$,Pos-1)
            Length=Len(File$)-Pos
            If Right(File$,Length)=Right(Name$,Length)
              AddGadgetItem(12,-1,Path$+Name$)
            EndIf

          EndIf
        EndIf
      EndIf
    Until Typ=0
  EndIf
EndProcedure

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP