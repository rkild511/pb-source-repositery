; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3187&highlight=
; Author: NicTheQuick (changed FileExists to FileSize by Danilo, updated for PB 4.00 by Andre)
; Date: 19. December 2003
; OS: Windows
; Demo: Yes

; Vorwort:
; Dieser Optimizer ist speziell für Declares und lästige Leerzeichen am Ende einer Zeile.
; Zwar kann jaPBe Declare-Dateien automatisch erzeugen, aber leider werden Procedurenamen
; aus Includedatei nicht erkannt und somit auch nicht in der Statusbar mit Kurzbeschreibung
; angezeigt. 
; Aber auch für den Standard-PB-Editor sollte es eine kleine komfortable Hilfe sein. 

; Die Backup-Funktion des Programms funktioniert wunderbar. Ihr könnt also reichlich nach
; Fehlern Ausschau halten. An euren Testquellcodes geht also nichts kaputt.  

; ---------------------------- 
; | Source-Optimizer V2.0    | 
; |           by NicTheQuick | 
; ---------------------------- 
; 
; Mögliche Parameter für die Tool-Konfiguration im Editor: 
; ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯ 
; "%FILE"           : Der zu optimierende Quellcode 
; /ReadIncludes     : Alle Includes werden mit einbezogen 
; 
; /DeleteSpaces     : Löscht alle folgenden Leerzeichen aller Zeilen 
; /DeleteSpacesInc  : Das selbe wie oben, allerdings werden die Includedateien berücksichtigt 
; 
; /SetDeclares      : Setzt im Hauptcode die Declares von allen Procedures 
; /SetDeclaresInc   : Setzt auch in den Includes die Declares 
; /TakeDescription  : Nimmt den Kommentar hinter jeder Procedure auch hinter die Declares (speziell für jaPBe) 
; 
; /SetjaPBeBookmark : Setzt die Declares in eine Falte 
; /jaPBeCompatible  : Berücksichtigt die Zeilenverschiebung für gefaltete Falten 
; /UnBackUp         : Legt kein Backup für die zu optimierende Datei an 
; /Undo             : Macht die letzte Veränderung der Datei rückgängig (geht nicht, wenn vorher /UnBackUp gesetzt war) 
; 
; (Beim Verändern von Includes muss darauf geachtet werden, dass sie danach neugeladen werden müssen oder vorher noch 
;  nicht im Editor geöffnet sein sollten) 
; 
; Optionen: [x] Tool-Ende abwarten 
; ¯¯¯¯¯¯¯¯¯ [x] Datei nach Tool-Ende neuladen 
;           [o] alte Datei überschreiben 


Global Modus.l 

Structure Files 
  Name.s 
  State.l 
EndStructure 

Global NewList Lines.s() 
Global NewList Declares.s() 
Global NewList Files.Files() 
Global NewList FoldLines.Point() 

#File = 0 

Procedure.s MidU(String.s, Pos.l) 
  ProcedureReturn Mid(String, Pos, Len(String) - Pos + 1) 
EndProcedure 

Procedure.l Hex2Dec(Hex.s) 
  Protected a.l, d.l, z.s 
  Hex = UCase(Hex) 
  For a = 1 To Len(Hex) 
    d << 4 
    z = Mid(Hex, a, 1) 
    If Asc(z) > 60 
      d + Asc(z) - 55 
    Else 
      d + Asc(z) - 48 
    EndIf 
  Next 
  ProcedureReturn d 
EndProcedure 

Procedure ReadLines(File.s) 
  Protected Tmp.s, a.l 
  If ReadFile(#File, File) 
    ClearList(Lines()) 
    ClearList(FoldLines()) 
    While Eof(#File) = 0 
      AddElement(Lines()) 
      Lines() = ReadString(#File) 
      If Modus & 128 
        If Left(Lines(), 12) = "; FoldLines=" 
          Tmp = MidU(Lines(), 13) 
          For a = 0 To Len(Tmp) / 8 - 1 
            AddElement(FoldLines()) 
            FoldLines()\x = Hex2Dec(Mid(Tmp, a * 8 + 1, 4)) 
            FoldLines()\y = Hex2Dec(Mid(Tmp, a * 8 + 5, 4)) 
          Next 
          DeleteElement(Lines()) 
        EndIf 
      EndIf 
    Wend 
    CloseFile(#File) 
    ProcedureReturn #True 
  EndIf 
  ProcedureReturn #False 
EndProcedure 

Procedure WriteLines(File.s) 
  Protected a.l 
  If CreateFile(#File, File) 
    a = CountList(Lines()) 
    ForEach Lines() 
      a - 1 
      If a 
        WriteStringN(#File,Lines()) 
      Else 
        WriteString(#File,Lines()) 
      EndIf 
    Next 
    ProcedureReturn #True 
  EndIf 
  ProcedureReturn #False 
EndProcedure 

Procedure FindDeclares() 
  Protected Line.s, LDeclare.s, Tmp.s 
  ForEach Lines() 
    Line = Trim(Lines()) 
    Tmp = LCase(Left(Line, 10)) 
    If Tmp = "procedure " Or Tmp = "procedure." 
      If Modus & 16 
        LDeclare = MidU(Line, 10) 
      Else 
        LDeclare = StringField(MidU(Line, 10), 1, ";") 
      EndIf 
      ForEach Declares() 
        If Trim(LCase(StringField(Declares(), 1, ";"))) = Trim(LCase(StringField(LDeclare, 1, ";"))) 
          LDeclare = "" 
          Break 
        EndIf 
      Next 
      If LDeclare 
        AddElement(Declares()) 
        Declares() = LDeclare 
      EndIf 
    EndIf 
  Next 
EndProcedure 

Procedure FindIncludes(Path.s) 
  Protected Line.s, Tmp.s 
  If Right(Path, 1) <> "\" : Path = Path + "\" : EndIf 
  ForEach Lines() 
    Line = Trim(Lines()) 
    Tmp = LCase(Left(Line, 12)) 
    If Tmp = "includefile " Or Tmp = "xincludefile" 
      Tmp = Trim(StringField(Line, 2, Chr('"'))) 
      If Mid(Tmp, 2, 1) <> ":" 
        Tmp = Path + Tmp 
      EndIf 
      ForEach Files() 
        If LCase(Files()\Name) = LCase(Tmp) 
          Tmp = "" 
          Break 
        EndIf 
      Next 
      If Tmp 
        AddElement(Files()) 
        Files()\Name = Tmp 
        Files()\State = 0 
      EndIf 
    EndIf 
  Next 
EndProcedure 

Procedure CountDoubleDeclares() 
  Protected Count.l, Line.s 
  
  Count = 0 
  ForEach Lines() 
    Line = Trim(Lines()) 
    If LCase(Left(Line, 7)) = "declare" 
      Line = MidU(Line, 8) 
      ForEach Declares() 
        If Trim(LCase(StringField(Declares(), 1, ";"))) = Trim(LCase(StringField(Line, 1, ";"))) 
          Declares() = "@" + Declares() 
          Count + 1 
        EndIf 
      Next 
    EndIf 
  Next 
  ProcedureReturn Count 
EndProcedure 

Procedure Opt(File.s) 
  Protected FoldLinesOffset.l, a.l, Tmp.s, DoubleCount.l 

  AddElement(Files()) 
  Files()\Name = File 
  Files()\State = 0 

  ResetList(Files())      ;Find Includes and Declares 
  Repeat 
    If NextElement(Files()) 
      If Files()\State = 0 
        Files()\State = 1 
        ReadLines(Files()\Name) 

        If Modus & 2 
          FindDeclares() 
        EndIf 

        If Modus & 4 
          FindIncludes(GetPathPart(Files()\Name)) 
        EndIf 
        ResetList(Files()) 
      EndIf 
    Else 
      Break 
    EndIf 
  ForEver 
  
  If Modus & 512 
    ForEach Files() 
      ;If FileExists(Files()\Name + ".so.bak")   ; FileExists doesn't exist as normal PB command, so
      If FileSize( Files()\Name + ".so.bak" ) >= 0    ; we use FileSize instead... ;-)
        ReadLines(Files()\Name) 
        DeleteFile(Files()\Name) 
        RenameFile(Files()\Name + ".so.bak", Files()\Name) 
        WriteLines(Files()\Name + ".so.bak") 
      Else 
        MessageRequester("Fehler...", "Die Datei '" + Files()\Name + "'" + Chr(13) + Chr(10) + "konnte nicht wiederhergestellt werden.") 
      EndIf 
    Next 
    ProcedureReturn 
  EndIf 

                          ;Calculate the FoldLinesOffset 
  ForEach Files() 
    If Modus & 256 
      CopyFile(Files()\Name, Files()\Name + ".so.bak") 
    EndIf 
    ReadLines(Files()\Name) 

    If Modus & 1    ;Delete Spaces 
      If Modus & 32 Or Files()\Name = File 
        ForEach Lines() 
          Lines() = RTrim(Lines()) 
        Next 
      EndIf 
    EndIf 
    
    If Modus & 128 
      FoldLinesOffset = CountList(Declares()) + 2 
      If Modus & 64 : FoldLinesOffset + 1 : EndIf 
    EndIf 
    
    If Modus & 2    ;Set Declares 
      If Modus & 8 Or Files()\Name = File 
        
        DoubleCount = CountDoubleDeclares() 
        If DoubleCount < CountList(Declares()) 
          FoldLinesOffset - DoubleCount 
          
          If Modus & 64 
            a = #True 
            ForEach Lines() 
              If Lines() = ";{- Declares" Or Lines() = "; Declares" 
                a = #False 
                Break 
              EndIf 
            Next 
            If a 
              ResetList(Lines()) 
            Else 
              FoldLinesOffset - 2 
              If Modus & 64 
                FoldLinesOffset - 1 
              EndIf 
            EndIf 
          EndIf 
          
          If a 
            AddElement(Lines()) 
            If Modus & 64 
              Lines() = ";{- Declares" 
            Else 
              Lines() = "; Declares" 
            EndIf 
          EndIf 
  
          ForEach Declares() 
            If Left(Declares(), 1) <> "@" 
              If AddElement(Lines()) 
                Lines() = "Declare" + Declares() 
              EndIf 
            Else 
              Declares() = MidU(Declares(), 2) 
            EndIf 
          Next 
  
          If a 
            If Modus & 64 
              AddElement(Lines()) 
              Lines() = ";}" 
            EndIf 
            
            AddElement(Lines()) 
          EndIf 
        Else 
          FoldLinesOffset = 0 
        EndIf 
      EndIf 
    EndIf 

    If Modus & 128 
      ResetList(Lines()) 
      While NextElement(Lines()) 
        If Left(Lines(), 8) = "; jaPBe " 
          ResetList(FoldLines()) 
          Tmp = "" 
          While NextElement(FoldLines()) 
            Tmp = Tmp + RSet(Hex(FoldLines()\x + FoldLinesOffset), 4, "0") + RSet(Hex(FoldLines()\y + FoldLinesOffset), 4, "0") 
            If Len(Tmp) = 64 
              AddElement(Lines()) 
              Lines() = "; FoldLines=" + Tmp 
            EndIf 
          Wend 
          If Len(Tmp) < 64 
            AddElement(Lines()) 
            Lines() = "; FoldLines=" + Tmp 
          EndIf 
        EndIf 
      Wend 
    EndIf 

    If WriteLines(Files()\Name) 
      Debug "OK: " + Files()\Name 
    EndIf 
  Next 

EndProcedure 

File.s = "" 
Modus = 256 
Repeat 
  Para.s = ProgramParameter() 
  If LCase(Para) = "/deletespaces" 
    Modus | 1 
  ElseIf LCase(Para) = "/setdeclares" 
    Modus | 2 
  ElseIf LCase(Para) = "/readincludes" 
    Modus | 4 
  ElseIf LCase(Para) = "/setdeclaresinc" 
    Modus | 8 | 2 
  ElseIf LCase(Para) = "/takedescription" 
    Modus | 16 
  ElseIf LCase(Para) = "/deletespacesinc" 
    Modus | 1 | 32 
  ElseIf LCase(Para) = "/setjapbebookmark" 
    Modus | 64 
  ElseIf LCase(Para) = "/japbecompatible" 
    Modus | 128 
  ElseIf LCase(Para) = "/unbackup" 
    Modus ! 256 
  ElseIf LCase(Para) = "/undo" 
    Modus | 512 
  ElseIf Para <> "" 
    File = Para 
  EndIf 
Until Para = "" 

If File = "" 
  Pattern.s = "PureBasic (*.pb; *.pbi)|*.pb;*.pbi|Alle Dateien (*.*)|*.*" 
  File.s = OpenFileRequester("Zu optimierende Datei wählen...", "C:\Programme\PureBasic\Programme\Projekte\MP3-Player\", Pattern, 0) 
  If File = "" : End : EndIf 
  Modus | 64 | 128 | 256 
  Modus | 4 
  Modus | 16 

  Modus | 1 | 32 
  Modus | 2 | 8 
EndIf 

Opt(File) 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = --
