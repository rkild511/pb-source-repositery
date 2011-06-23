; German forum: http://www.purebasic.fr/german/viewtopic.php?t=145&postdays=0&postorder=asc&start=10
; Author: AndyMars (updated for PB 4.00 by Andre)
; Date: 17. September 2004
; OS: Windows
; Demo: Yes


; Zugriff auf INI Dateien nur mit PureBasic Befehlen, ohne Windows API und mit der 
; Möglichkeit nachträglich Einträge in schon erstellten INI Dateien zu ändern. 
; Ohne Windows API hätte es den Vorteil, dass es auch auf anderen Plattformen 
; funktionierte. 
; Die Idee war, einfach die ganze INI Datei in eine Linkliste zu laden, dort 
; Einträge zu ändern und dann wieder zurück zu schreiben... 
; Es fehlt jedoch noch eine (minimale) Fehlerbehandlungsroutine.

; Benutzung:
; - Mit _INIOpen() INI_Datei öffnen 
; - _INIWrite() schreibt eine Zeichenkette in die "INI-Liste" 
; - _INIRead() ... liest ein Zeichenkette...  
; - Mit _INIClose wird alles wieder in die INI-Datei geschrieben 


;This is an include file with functions to access preferences files (*.ini). Additional 
;to the standard PureBasic commands, it give the ability to write new entries 
;in already created INI-files. 

;For PureBasic 3.91 without any Windows API... 
;From Andy Marschner (Andy, AndyMars), Switzerland, 2004 

;- TODO 
;there lacks some checks: 
;Read, Write: only when first Open... 

;-Variables 
Structure i 
  key.s ;[ -> Group -> Value=GroupName 
  Value.s 
EndStructure 

Global NewList INI.i() 

Global CR.s 
CR=Chr(13)+Chr(10) 

;-Procedures 
Procedure _iM(Text.s) 
  MessageRequester("Preference message",Text) 
EndProcedure 

Procedure _INIClose() ;saves the content of the list into the file 
  Shared OldIniFile.s 
  FHndl = CreateFile(#PB_Any,OldIniFile) 
  If FHndl 
    ForEach INI() 
      If INI()\key="[" ;Group 
        WriteStringN(FHndl, "["+INI()\Value+"]") 
      ElseIf INI()\key ;Value 
        WriteStringN(FHndl, INI()\key + " = " + INI()\Value) 
      Else ;any other (empty lines, comments) 
        WriteStringN(FHndl, INI()\Value) 
      EndIf 
    Next 
    CloseFile(FHndl) 
  Else 
    _iM("Error: Cannot save "+ OldIniFile+"!") 
  EndIf 
EndProcedure 

Procedure _INIOpen(INIFilePath.s) ;open a preference file and read all content 
  Shared OldIniFile.s 
  If FirstElement(INI()) 
    _INIClose() 
  EndIf 
  FHndl=OpenFile(#PB_Any ,INIFilePath) 
  If FHndl 
    OldIniFile = INIFilePath 
    While Eof(FHndl)=0 
      AddElement(INI()) 
      r$=ReadString(FHndl) 
      If r$ ;if not -> ;empty line 
        If FindString(r$,"[",1) ;Group 
          r$=ReplaceString(r$,"[","") 
          r$=ReplaceString(r$,"]","") 
          r$=Trim(r$) 
          INI()\key="[" 
          INI()\Value=r$ 
        ElseIf FindString(r$,"=",1) ;Value 
          INI()\key=Trim(StringField(r$,1,"=")) 
          INI()\Value=Trim(StringField(r$,2,"=")) 
        Else ;any other content 
          INI()\key="" 
          INI()\Value=r$ 
        EndIf 
      EndIf 
    Wend 
    CloseFile(FHndl) 
  Else ;error opening file 
    _iM("Error: Cannot open "+ INIFilePath+"!") 
  EndIf 
EndProcedure 

Procedure _INIWrite(Group.s, key.s, Value.s) 
  If Group 
    NotFound=1 ; -------------------------- find Group 
    ForEach INI() 
      If (INI()\key="[") And (UCase(Group)=UCase(INI()\Value)) 
        NotFound=0 
        Break 
      EndIf 
    Next 
    If NotFound 
      If CountList(INI())>0 
        AddElement(INI()) ;empty line 
      EndIf 
      AddElement(INI()) 
      INI()\key="[" 
      INI()\Value=Group 
    EndIf 
  Else ;without Group 
    ResetList(INI()) ;Values without groups have to be at beginning 
  EndIf 
  NotFound=1 ; -------------------------- find Key 
  While NextElement(INI()) 
    If UCase(INI()\key)=UCase(key) 
      NotFound=0 
      Break 
    EndIf 
    If INI()\key="[" : Break : EndIf ;next Group... 
  Wend 
  If NotFound 
    If ListIndex(INI())=CountList(INI())-1 ;at the end of the list... 
      AddElement(INI()) 
    Else 
      InsertElement(INI()) 
    EndIf 
    INI()\key=key 
    INI()\Value=Value 
  Else 
    INI()\Value=Value 
  EndIf 
EndProcedure 

Procedure.s _INIRead(Group.s, key.s, DefaultValue.s) 
  If Group 
    NotFound=1 ; -------------------------- find Group 
    ForEach INI() 
      If (INI()\key="[") And (UCase(Group)=UCase(INI()\Value)) 
        NotFound=0 
        Break 
      EndIf 
    Next 
    If NotFound 
      ProcedureReturn DefaultValue 
    EndIf 
  Else ;without Group 
    ResetList(INI()) ;Values without groups have to be at beginning 
  EndIf 
  NotFound=1 ; -------------------------- find Key 
  While NextElement(INI()) 
    If UCase(INI()\key)=UCase(key) 
      NotFound=0 
      Break 
    EndIf 
    If INI()\key="[" : Break : EndIf ;next Group... 
  Wend 
  If NotFound 
    ProcedureReturn DefaultValue 
  EndIf 
  ProcedureReturn INI()\Value 
EndProcedure 

;-Main (only for testing purposes) 
_INIOpen("ini.ini") 
_INIWrite("COEXISTENCE","COEXIST","2") 
Debug _INIRead("INSTALL","DIRECTORY","NothingFound") 
_INIClose() 

End
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -