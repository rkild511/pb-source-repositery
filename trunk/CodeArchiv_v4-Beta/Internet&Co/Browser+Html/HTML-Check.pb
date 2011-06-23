; German forum:
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 21. June 2003
; OS: Windows
; Demo: No

PrgName.s="HTML-Check"

Global Dim Tag.s(500,1) : Tags = -1
Repeat
  Tags = Tags + 1
  Read Tag.s(Tags,0) : Read Tag.s(Tags,1)
Until Tag.s(Tags,0) = "<xmp>"


Declare LeseDatei(DateiName.s) : Datei.s = ""
Declare DirectoryParameter(FileList.s) : DirectoryParameter(FileList.s)
Declare.b DateiTyp(Datei.s)
Declare SchreibeDatei()
Declare HTMLCheck()
Declare.b CreateAndCenterWindow(WindowNr.l,SizeW.l,SizeH.l)


If CreateAndCenterWindow(0, 1024, 768)

  If CreateGadgetList(WindowID(0))
    TextGadget(1, 3, 3, 1011, 14, "StatusInfo") 
    ButtonGadget(2,974,20,40,24,"PgUp") 
    ButtonGadget(3,974,50,40,24,"PgDn") 
    ButtonGadget(4,5,50,40,24,"Load")
    ButtonGadget(5,52,50,40,24,"Save")
    ButtonGadget(6,170,50,80,24,"HTML-Check")
    Frame3DGadget(7, 5, 16, 960, 28, "", 0) 
    TextGadget(8, 9, 26, 950, 16, "Check:") 
    
    Debug "1"
    
    FontID.l = LoadFont(0, "Courier", 12)
    If FontID.l
      SetGadgetFont(8,FontID.l)
    EndIf
    TextBox=StringGadget(0, 3, 80, 1014, 634,"", #ES_MULTILINE | #ES_AUTOVSCROLL | #WS_VSCROLL | #WS_HSCROLL) 

    Quit = #False
    Repeat
      EventID.l = WaitWindowEvent()      
      
      result=SendMessage_(TextBox,#EM_GETSEL,@Anfang,@Ende) 
      AChar=Anfang : SChars=Ende
      ALine=SendMessage_(TextBox,#EM_LINEFROMCHAR,AChar,0) 
      TLines=SendMessage_(TextBox,#EM_GETLINECOUNT,0,0)
      Bytes=SendMessage_(TextBox,#WM_GETTEXTLENGTH,0,0)
      CPos=SendMessage_(TextBox,#EM_LINEINDEX,ALine,0)      
       
      If AChar < SChars
        CPosE.s = " (bis " + Str(SChars-CPos) + ")"
      Else
        CPosE.s = ""
      EndIf      
      
      StatusInfo.s = "Zeichen " + Str(AChar-CPos) + CPosE.s + " in Zeile " + Str(ALine+1) + " (von " + Str(TLines) + ")"
      StatusInfo.s = StatusInfo.s + "  [absolut: " + Str(AChar) + "/" + Str(Bytes)+"]  ƒ  Datei '" + Datei.s + "'"
      SetGadgetText(1,StatusInfo.s)
      If EventID = #PB_Event_CloseWindow
        Quit = #True
      ElseIf EventID = #PB_Event_Gadget 
        Select EventGadget() 
        Case 2 
          Zeile=SendMessage_(TextBox,#EM_SCROLL,#SB_PAGEUP,0) 
        Case 3 
          Zeile=SendMessage_(TextBox,#EM_SCROLL,#SB_PAGEDOWN,0) 
        Case 4
          DateiName.s = OpenFileRequester(PrgName.s + ": Datei öffnen", Datei.s, FileList.s, DateiTyp(Datei.s))
          If DateiName.s+DateiName.s
            LeseDatei(DateiName.s)
          EndIf
        Case 5
          SchreibeDatei()
        Case 6
          If Datei.s <> ""
            HTMLCheck()
          EndIf
        EndSelect
      EndIf 
    Until Quit
  Else
    MessageRequester(PrgName.s, "Allgemeiner Programmfehler !", #MB_ICONSTOP)
  EndIf

CloseWindow(0) : FreeFont(0)
EndIf


Procedure.b CreateAndCenterWindow(WindowNr.l, SizeW.l, SizeH.l)
Shared PrgName.s
  ok.b = #False

  ExamineDesktops()
  If DesktopWidth(0) < SizeW.l Or DesktopHeight(0) < SizeH.l
    MessageRequester(PrgName.s, "Min. Auflösung " + Str(SizeW.l) + " * " + Str(SizeH.l) + " erforderlich !", #MB_ICONASTERISK)
  Else
    OffsetW.l = 5 : OffsetH.l = 52 ; Border (+ Title + ToolBar)
    w.l = SizeW.l - OffsetW.l : h.l = SizeH.l - OffsetH.l
    If OpenWindow(WindowNr.l, 0, 0, w.l, h.l, PrgName.s, #PB_Window_MinimizeGadget | #PB_Window_TitleBar) 
      xPos = (DesktopWidth(0) - SizeW.l) / 2
      yPos = (DesktopHeight(0) - SizeH.l) / 2
      If xPos > 0 Or yPos > 0
        ResizeWindow(WindowNr.l,xPos, yPos,#PB_Ignore,#PB_Ignore)
      EndIf
      ok.b = #True
    Else
      MessageRequester(PrgName.s, "Fehler beim Öffnen des Fensters !", #MB_ICONSTOP)
    EndIf
  EndIf
  ProcedureReturn ok.b
EndProcedure


Procedure DirectoryParameter(FileList.s)
  FileList.s = "HyperTextMarkedLanguage, CSS, JS|*.html;*.htm;*.css;*.js"
  FileList.s = FileList.s + "|HyperTextMarkedLanguage (*.html)|*.html"
  FileList.s = FileList.s + "|HyperTextMarkedLanguage (*.HTM)|*.htm"
  FileList.s = FileList.s + "|CascadingStyleSheets (*.css)|*.css"
  FileList.s = FileList.s + "|JavaScript (*.js)|*.js"
  FileList.s = FileList.s + "|PureBasic Source (*.pb)|*.pb"
  FileList.s = FileList.s + "|Text (*.txt)|*.txt"
  FileList.s = FileList.s + "|ASCII-Datei? (*.asc *.bas *.bat *.dat *.ini *.log)|*.asc;*.bas;*.bat;*.dat;*.ini;*.log"
  FileList.s = FileList.s + "|Alle Dateien (*.*)|*.*"
EndProcedure


Procedure.b DateiTyp(Datei.s)
If Datei.s = ""
  DateiTypNr.b = 0
ElseIf Right(LCase(Datei.s),5) = ".html"
  DateiTypNr.b = 1
ElseIf Right(LCase(Datei.s),4) = ".htm"
  DateiTypNr.b = 1
ElseIf Right(LCase(Datei.s),4) = ".css"
  DateiTypNr.b = 4
ElseIf Right(LCase(Datei.s),3) = ".js"
  DateiTypNr.b = 5
ElseIf Right(LCase(Datei.s),3) = ".pb"
  DateiTypNr.b = 6
ElseIf Right(LCase(Datei.s),4) = ".txt"
  DateiTypNr.b = 7
ElseIf Right(LCase(Datei.s),4) = ".asc" Or Right(LCase(Datei.s),4) = ".bas" Or Right(LCase(Datei.s),4) = ".bat"
  DateiTypNr.b = 8
ElseIf Right(LCase(Datei.s),4) = ".dat" Or Right(LCase(Datei.s),4) = ".ini" Or Right(LCase(Datei.s),4) = ".log"
  DateiTypNr.b = 8
Else
  DateiTypNr.b = 9
EndIf
  ProcedureReturn DateiTypNr.b
EndProcedure


Procedure LeseDatei(DateiName.s)
Shared Datei.s, PrgName.s, Textzeile.s, Zeilen, Text.s
  If ReadFile(0, DateiName.s)
    If Lof(0)<60000
      Datei.s = DateiName.s
      Text.s=""
      Global Dim Textzeile.s(10000)
      Zeilen = -1
      While Eof(0) = #False
        Zeilen = Zeilen + 1
        Textzeile.s(Zeilen) = ReadString(0)
        Text.s = Text.s + Textzeile.s(Zeilen) + Chr(13)+Chr(10)
      Wend
      CloseFile(0)
      SetGadgetText(0, Text.s)
    Else
      MessageRequester(PrgName.s, "Datei kann aufgrund Ihrer Länge nicht gelesen werden !", #MB_ICONINFORMATION)
    EndIf
  Else
    MessageRequester(PrgName.s, "Datei '" + DateiName.s + "' kann nicht gelesen werden !", #MB_ICONASTERISK)
  EndIf
EndProcedure


Procedure SchreibeDatei()
Shared PrgName.s, Datei.s, FileList.s, Text.s
  Quit = #False : speichern = #False
  Repeat
    DateiName.s = SaveFileRequester(PrgName.s + ": Datei speichern", Datei.s, FileList.s, DateiTyp(Datei.s))
    If DateiName.s
      If ReadFile(0, DateiName.s)
        CloseFile(0)
        Result = MessageRequester(PrgName.s, "Die bereits bestehende Datei überschreiben ?", #MB_ICONQUESTION | #PB_MessageRequester_YesNoCancel | #MB_DEFBUTTON2)
        If Result = #IDYES ; Ja = 6
          Quit = #True : speichern = #True
        ElseIf Result = #IDNO ; Nein = 7
          ; -> neue Auswahl
        ElseIf Result = #IDCANCEL ; Abbruch (Abort) = 2
          Quit = #True
        Else
          MessageRequester(PrgName.s, "Unerwarteter AntwortCode: " + Str(Result), #MB_ICONHAND)
          Quit = #True
        EndIf
      Else
        Quit = #True : speichern = #True
      EndIf
    Else
      Quit = #True
    EndIf
  Until Quit
  If speichern
    Text.s = GetGadgetText(0)
    If Len(Text.s) >= 4999
      MessageRequester(PrgName.s, "Datei kann aufgrund Ihrer Länge nicht gespeichert werden !", #MB_ICONINFORMATION)
    Else
      If CreateFile(0, DateiName.s)
        WriteString(0,Text.s)
        Datei.s = DateiName.s
        CloseFile(0)
      Else
        MessageRequester(PrgName.s, "Datei konnte nicht angelegt werden !", #MB_ICONEXCLAMATION)
      EndIf
    EndIf
  EndIf
EndProcedure


Procedure HTMLCheck()
Shared Tag.s, Tags, Text.s, Textzeile.s, Zeilen, PrgName.s
  Kommentar = #False : Scripte = #False
  tgsF = 0 : tgsC = 0 : tgsA = 0 : tgsB = 0 : komC = 0 : scrC = 0 : styC = 0 : nix$=""
  For z = 0 To Zeilen
    t$ = LCase(Textzeile.s(z)) : l = Len(t$)
    For i = 1 To l
      If Mid(t$,i,1) = "<"
        If Mid(t$,i,4) = "<!--"
          Kommentar = #True : komC = komC + 1
        ElseIf Mid(t$,i,7) = "<script"
          Scripte = #True : scrC = scrC + 1
        EndIf
        ok = #False : ii = i
        Repeat
          ii = ii + 1
          If Mid(t$,ii,1) = ">"
            ok = #True
          EndIf
        Until ok Or ii = l
        If ok
          tgsC = tgsC + 1
          If Kommentar
            Kommentar = #False : tgsA = tgsA + 1
          Else
            x$ = Mid(t$,i,ii-i+1)
            ok = #False : ii = -1
            If Mid(x$,2,1) = "/"
              Repeat
                ii = ii + 1
                If (Tag.s(ii,1) <> "" And Tag.s(ii,1) = x$) Or (x$ = "</"+Mid(Tag.s(ii,0),2,Len(x$)-3)+">")
                  ok = #True : tgsB = tgsB + 1
                  If x$ = "</script>"
                    Scripte = #False
                  EndIf
                EndIf
              Until ok Or ii = Tags
            Else
              Repeat
                ii = ii + 1
                If Right(Tag.s(ii,0),1) = "~"
                  If Left(Tag.s(ii,0),Len(Tag.s(ii,0))-2) = Left(x$,Len(Tag.s(ii,0))-2)
                    ok = #True : tgsA = tgsA + 1
                  EndIf
                Else
                  If Tag.s(ii,0) = x$
                    ok = #True : tgsA = tgsA + 1
                  EndIf
                EndIf
              Until ok Or ii = Tags
            EndIf
          EndIf
          If ok = #False
            If nix$ = ""
              nix$ = "NICHT ERKANNTE TAGS" + Chr(13)+Chr(10) + "-------------------"+Chr(13)+Chr(10) + Chr(13)+Chr(10)
            EndIf
            nix$ = nix$ + x$ + Chr(13)+Chr(10) + Chr(13)+Chr(10)
          EndIf
        Else
          If Kommentar = #False
            tgsF = tgsF +1
          EndIf
        EndIf
      EndIf
    Next
  Next
  c$ = "Tags: " + Str(tgsC) + "   <..> = " + Str(tgsA) + "   </..> = " + Str(tgsB)
  If tgsA + tgsB <> tgsC
    c$ = c$ + "   <?> = " + Str(tgsC - tgsB - tgsA)
  EndIf
  If tgsF
    c$ = c$ + "   <..? = " + Str(tgsF)
  EndIf
  If komC
    c$ = c$ + "   <!-- = " + Str(komC)
  EndIf
  If scrC
    c$ = c$ + "   <script..> = " + Str(scrC)
  EndIf
  SetGadgetText(8, c$)
  If nix$ <> ""
    SetGadgetText(0, nix$)
  EndIf
EndProcedure


DataSection
HTMLTags:
Data.s "<!--~// -->", ""
Data.s "<!doctype~", ""
Data.s "<a href~", "</a>"
Data.s "<a name~", "</a>"
Data.s "<acronym>", "</acronym>"
Data.s "<address>", "</address>"
Data.s "<app~", ""
Data.s "<applet~", ""
Data.s "<area shape~", ""
Data.s "<b>", "</b>"
Data.s "<base~", ""
Data.s "<basefont~", ""
Data.s "<bdo dir~", "</bdo>"
Data.s "<bgsound~", ""
Data.s "<big>", "</big>"
Data.s "<blink>", "</blink>"
Data.s "<blockquote>", "</blockquote>"
Data.s "<body~", "</body>"
Data.s "<br~", "</br>"
Data.s "<button~", "</button>"
Data.s "<caption~", "</caption>"
Data.s "<center>", "</center>"
Data.s "<cite>", "</cite>"
Data.s "<code>", "</code>"
Data.s "<col~", ""
Data.s "<colgroup~", "</colgroup>"
Data.s "<dd>", "</dd>"
Data.s "<del~", "</del>"
Data.s "<dfn>", "</dfn>"
Data.s "<dir>", "</dir>"
Data.s "<div~", "</div>"
Data.s "<dl>", "</dl>"
Data.s "<dt>", "</dt>"
Data.s "<em>", "</em>"
Data.s "<embed src~", ""
Data.s "<fieldset>", "</fieldset>"
Data.s "<font~", "</font>"
Data.s "<form~", "</form>"
Data.s "<frame src~", ""
Data.s "<frameset~", "</frameset>"
Data.s "<h1>", "</h1>"
Data.s "<h2>", "</h2>"
Data.s "<h3>", "</h3>"
Data.s "<h4>", "</h4>"
Data.s "<h5>", "</h5>"
Data.s "<h6>", "</h6>"
Data.s "<head~", "</head>"
Data.s "<hr~", "</hr>"
Data.s "<html~", "</html>"
Data.s "<i>", "</i>"
Data.s "<iframe~", "</iframe>"
Data.s "<ilayer~", "</ilayer>"
Data.s "<img~", ""
Data.s "<input~", ""
Data.s "<ins~", "</ins>"
Data.s "<isindex~", ""
Data.s "<kbd>", "</kbd>"
Data.s "<label~", "</label>"
Data.s "<layer~", "</layer>"
Data.s "<legend~", "</legend>"
Data.s "<li~", "</li>"
Data.s "<link~", ""
Data.s "<listing>", "</listing>"
Data.s "<map name~", "</map>"
Data.s "<marquee~", "</marquee>"
Data.s "<menu>", "</menu>"
Data.s "<meta~", ""
Data.s "<multicol~", "</multicol>"
Data.s "<nobr>", "</nobr>"
Data.s "<noembed>", "</noembed>"
Data.s "<noframes>", "</noframes>"
Data.s "<noscript>", "</noscript>"
Data.s "<object~", ""
Data.s "<ol~", "</ol>"
Data.s "<optgroup~", "</optgroup>"
Data.s "<option~", ""
Data.s "<p~", "</p>"
Data.s "<param~", ""
Data.s "<plaintext>", "</plaintext>"
Data.s "<pre~", "</pre>"
Data.s "<q cite~", "</q>"
Data.s "<s>", "</s>"
Data.s "<script~", "</script>"
Data.s "<select~", "</select>"
Data.s "<small>", "</small>"
Data.s "<spacer~", ""
Data.s "<span style~", "</span>"
Data.s "<strike>", "</strike>"
Data.s "<strong>", "</strong>"
Data.s "<sub>", "</sub>"
Data.s "<sup>", "</sup>"
Data.s "<style type~", "</style>"
Data.s "<table~", "</table>"
Data.s "<tbody>", "</tbody>"
Data.s "<td~", "</td>"
Data.s "<textarea~", "</textarea>"
Data.s "<tfoot>", "</tfoot>"
Data.s "<th~", "</th>"
Data.s "<thead>", "</thead>"
Data.s "<title>", "</title>"
Data.s "<tr~", "</tr>"
Data.s "<tt>", "</tt>"
Data.s "<u>", "</u>"
Data.s "<ul~", "</ul>"
Data.s "<var>", "</var>"
Data.s "<wbr>", ""
Data.s "<xmp>", "</xmp>"
EndDataSection


End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = --
; EnableXP
; Executable = C:\Programme\PureBASIC\Examples\HTML-Check.exe
; DisableDebugger