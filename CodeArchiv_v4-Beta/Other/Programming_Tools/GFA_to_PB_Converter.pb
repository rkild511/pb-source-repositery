; English forum: http://www.purebasic.fr/english/viewtopic.php?t=20481
; Author: Michael Vogel (adapted by Andre)
; Date: 18. March 2006
; OS: Windows
; Demo: Yes

;- Some notes:
; a project which translates GFA listings (*.lst) to PureBasic source code (*.pb)... 
; Of course it's not that easy, because GFA is able to do some things, PureBasic
;  forgot to implement, like... 

; Code: 
; DO [While ...] 
;    : 
; LOOP [Until ...] 
; 
; MID$(string,from,[To]) 
; INSTR(string,what,[fromwhere]) And RINSTR(string,what,[fromwhere]) 
; 
; Procedure test(VAR test) 
;    : 
; Return 
; 
; Abs(a), SGN(a),... 
; PRED(a), SUCC(a), a++, a-- 
; MUL(a,b), DIV(a,b), SCALE(a,b,c),... 
; MIN(a,b), MAX(a,b), IMIN(a,b),... 
; SINQ(a), COSQ(a),... 
; 
; ARRAYFILL numericarray(),TRUE 
; ARRAYFILL stringcarray(),"n/a" 


; However, everyone who did GFA-16 maybe has some old code waiting to be converted. Ok, it will not 
; run after being "translated" with my program, but a lot of hand work will be handled with this 
; tool (and maybe I've time to add more features)... 


;- Converter Code

; Define (V0.30)

; What works already...
; -------------------------
;   Procedure/Return
;   Function/Endfunc
;   If ... Then ...
;   Variable Types
;   Remarks (', //)
;   Local variables, Variable address pointer (V:)
;   Do/Loop, Repeat/Until, While/Wend
;   Graphic commands (OpenW/CloseW, Dialog, Cls, Line, Color,...)
;   Constants (True/False, WM_, WS_,...)

; What should be done...
; --------------------------
;   Pred, Succ, Inc, Dec
;   Mid(a$,1)
;   Abs()  no idea, how to get it to an integer...
;   --, ++, +=, -=, *=, /=
;   Byte{}, Byte(), Word{}, Word(), Char{},...

; (Some) Further issues...
; ----------------------------
;   Case "x"   (Fred, com'on)
;   Case n To
;   Case To n
;   Otherwise
;   CosQ, SinQ,...
;   Curve (Bezier)
;   KeyGet

EnableExplicit

#InputExtension=".lst"
#OutputExtension=".pb"
#MaxVal=#MAXSHORT-1

Global Dateiname.s="GFA_Testcode"
Global InputFile
Global OutputFile
Global Zeile.s
Global Klein.s
Global LoopStack.s=""

Enumeration
  #Bemerkung
  #Strichpunkt
  #LetztesZeichen
  #Prozedur
  #SuchErgebnis
  #Gefunden
  #LinkesZeichen
  #RechtesZeichen
  #LastFlag
EndEnumeration

Global Dim Flags.w(#LastFlag)

; EndDefine

Procedure.s Ersetze(von.w,len.w,mit.s)
  ; Werte anpassen (von ist immer kleiner Strichpunkt und LetztesZeichen)
  Flags(#LetztesZeichen)-len+Len(mit)
  Flags(#Strichpunkt)-len+Len(mit)
  Zeile=Left(Zeile,von-1)+mit+Mid(Zeile,von+len,#MaxVal)
EndProcedure

Procedure ErsetzePlus(von.w,len.w,mit.s)
  Ersetze(von.w,len.w,mit.s)
  Ersetze(Flags(#LetztesZeichen)+1,0,")")
EndProcedure
Procedure Bemerkungen()

  ; Vorselektion (Bemerkungen)
  Flags(#Bemerkung)=#False

  Select Left(Zeile,2)
    Case "//"
      Zeile="; "+Zeile
      Flags(#Bemerkung)=#True

    Case "> "
      Zeile=Mid(Zeile,3,#MaxVal)
  EndSelect

  Select Left(Zeile,1)
    Case "'"
      PokeB(@Zeile,Asc(";"))
      Flags(#Bemerkung)=#True
    Case "$"
      Zeile="; (x) "+Zeile
      Flags(#Bemerkung)=#True
  EndSelect

  Flags(#Strichpunkt)=0
  Flags(#LetztesZeichen)=Len(Zeile)

  If Flags(#Bemerkung)=#False
    Protected i.w=0
    Protected q.w=0
    Protected s.w=0

    While i<Flags(#LetztesZeichen)

      Select PeekB(@Zeile+i)
        Case 34; #DOUBLEQUOTE$
          q.w=1-q.w
        Case $27; "'"
          If Flags(#Strichpunkt)=0
            Ersetze(i+1,1,";")
            Flags(#Strichpunkt)=i+1
            Flags(#LetztesZeichen)=Len(Trim(Left(Zeile,i)))
          EndIf
        Case 47; "/"
          If Flags(#Strichpunkt)=0
            If s.w=0
              s.w=i
            ElseIf s.w=i-1
              Ersetze(i,2,";")
              Flags(#Strichpunkt)=i
              Flags(#LetztesZeichen)=Len(Trim(Left(Zeile,i-1)))
            EndIf
          EndIf
      EndSelect
      i+1
    Wend
  EndIf
  If Flags(#Strichpunkt)=0
    Flags(#Strichpunkt)=Len(Zeile)+1
  EndIf
EndProcedure

Procedure.w Suche(Suche.s)

  Protected i.w=0
  Protected q.w=0
  Protected s.w=Len(suche)

  Protected m.w=Flags(#Strichpunkt)-s

  While i<m

    If PeekB(@Zeile+i)=34; #DOUBLEQUOTE$
      q.w=1-q.w
    EndIf

    i+1
    If q=0
      If Mid(Klein,i,s)=Suche
        Flags(#SuchErgebnis)=i
        ProcedureReturn i
      EndIf
    EndIf
  Wend

  ProcedureReturn 0
EndProcedure

Procedure.s Typ(n.w)
  ProcedureReturn Mid("bwslf",n,1)
EndProcedure

Procedure.w FindeMin(text.s,such.s)
  ProcedureReturn FindString(text,such,1)
EndProcedure

Procedure.w FindeMax(text.s,such.s)
  Protected dummy.w
  dummy=FindString(text,such,1)
  If dummy=0
    dummy=Flags(#LetztesZeichen)
  EndIf
  ProcedureReturn dummy
EndProcedure

Procedure VarTypen()
  Protected i.w=0
  Protected q.w=0
  Protected s.w=1
  Protected k.w=#False

  While i<Flags(#LetztesZeichen)

    ;Debug Left(Zeile,i)+"_"+Mid(zeile,i+1,#MaxVal)+" --- "+Str(k)

    If q
      If PeekB(@Zeile+i)=34
        q=0
      EndIf
    Else
      Select PeekB(@Zeile+i)

        Case 9, 32, 59, 96; Trennzeichen (Tab, Leer, ; , ')
          If k
            Ersetze(i+1,0,"()")
            i+2
            k=#False
          EndIf
          s=i+1; zur Unterscheidung '$' bei Variablennamen und Befehlen

        Case 44, 43, 45, 42, 47; Trennzeichen (Komma, +, -, *, /)
          s=i+1; zur Unterscheidung '$' bei Variablennamen (a$), Befehlen (MID$) und Konstanten ($10)

        Case 40; () nach Prozedur und Funktion vorhanden
          If k
            k=#False
          EndIf
          s=i+1;

        Case 34; #DOUBLEQUOTE$
          q.w=1

        Case 36; $   String
          If k Or FindString("~MID$~LEFT$~RIGHT$~CHR$~SPACE$~STRING$~STR$~WIN$~DIR$~","~"+Mid(zeile,s+1,i-s+1),1)
            ;Debug Str(k)+": "+Zeile
            Ersetze(i+1,1,"");   Befehl (e.g. Left$ wird Left)
            i-1
          ElseIf i>s+1
            Ersetze(i+1,1,".s"); Variable (e.g. Dummy$ wird Dummy.s)
            i+1
          EndIf

        Case 33; !    Bit
          Ersetze(i+1,1,".b")

          ;Case 124; |    Byte
          ;Ersetze(i+1,1,".b")

        Case 38; &   Word
          Ersetze(i+1,1,".w")

          ;Case 37; %   Long
          ;Ersetze(i+1,1,".l")

          ;Case 35; #   Double
          ;Ersetze(i+1,1,".d")

        Case 64; @   Procedure/Function
          Ersetze(i+1,1,"")
          i-1
          k=#True; () ist anzufügen...

        Case 58; :      Address of Variable
          If i>0
            If PeekB(@Zeile+i-1)=86; "V"
              Ersetze(i,2,"@")
              i-1
            EndIf
          EndIf

      EndSelect

    EndIf

    i+1
  Wend

  If k; Klammern fehlen noch...
    Ersetze(Flags(#LetztesZeichen)+1,0,"()")
  EndIf
EndProcedure

Procedure Klammern(i.w)
  Protected q.w=0
  Protected k.w=#True

  While i<Flags(#LetztesZeichen)

    Select PeekB(@Zeile+i)

      Case 9, 32, 43, 59, 96; Trennzeichen (Tab, Leer, +, ; , ')
        If q=0
          Ersetze(i+1,0,"()")
          k=#False
          i=#MaxVal
        EndIf

      Case 34
        q=1-q

      Case 40; () nach Prozedur und Funktion vorhanden
        k=#False
        i=#MaxVal
    EndSelect

    i+1
  Wend

  If k; Klammern fehlen noch...
    Ersetze(Flags(#LetztesZeichen)+1,0,"()")
  EndIf

EndProcedure

Procedure Analyse(s.s)
  Protected l.w=Len(s)

  If Left(Klein,l)=s
    If Len(Trim(Mid(Klein,l+1,Flags(#LetztesZeichen)-1))); da steht hinter dem gesuchten Text noch ein Ausdruck...
      Flags(#SuchErgebnis)=#True
    Else
      Flags(#SuchErgebnis)=#False
    EndIf
    ProcedureReturn #True
  EndIf

  ProcedureReturn #False
EndProcedure

Procedure KommaSuche(i.w,n.w)
  Protected k.w=0
  While i<Flags(#LetztesZeichen)
    Select PeekB(@Zeile+i)
      Case 40; (
        k+1
      Case 41; )
        k-1
      Case 44; ,
        If k=0
          n-1
          If n=0
            ProcedureReturn i+1
          EndIf
        EndIf
    EndSelect
    i+1
  Wend
  ProcedureReturn 0
EndProcedure

Procedure Austausch(was.s,womit.s,postfix.s)
  Protected n.w=1
  Flags(#Gefunden)=0

  Repeat
    Protected i.l=FindString(Zeile,was,n)
    If i
      n=i+Len(womit)
      Ersetze(i,Len(was),womit)
      If Len(postfix)
        Ersetze(Flags(#LetztesZeichen)+1,0,postfix)
        Flags(#Gefunden)+1
      EndIf
    EndIf
  Until i=0
EndProcedure

Procedure Feld(nr.w,i.w=0)
  Protected q.w=0
  Protected k.w=0

  Flags(#LinkesZeichen)=i+1

  While i<Flags(#LetztesZeichen)
    Select PeekB(@Zeile+i)

      Case 34; "
        q=1-q

      Case 40; (
        If q=0
          k+1
        EndIf

      Case 41; )
        If q=0
          k-1
          If k<0 And nr=1; abschließende Klammer
            Flags(#RechtesZeichen)=i-Flags(#LinkesZeichen)+1
            ProcedureReturn #True
          EndIf
        EndIf

      Case 44; ,
        If q=0 And k=0
          nr-1
          If nr=1
            Flags(#LinkesZeichen)=i+2
          ElseIf nr=0
            Flags(#RechtesZeichen)=i-Flags(#LinkesZeichen)+1
            ProcedureReturn #True
          EndIf
        EndIf

    EndSelect

    i+1
    ;Debug Mid(Zeile,i,1)+" - "+Str(k)+", "+Str(q)+", "+Str(nr)

  Wend
  ProcedureReturn #False
EndProcedure

Procedure Spezialtausch(was.s,womit.s,postfix.s,i.w,extra.s)
  Protected n.w=0
  Protected h1.w,h2.w
  Protected s.s

  If Left(Zeile,Len(was))=was

    ;Austausch(was.s,womit.s,postfix.s)
    Ersetze(1,Len(was),womit)
    If Len(postfix)
      Ersetze(Flags(#LetztesZeichen)+1,0,postfix)
    EndIf

    If i ;And Flags(#Gefunden)
      If i=-1
        i=Len(womit)+1; Suchbeginn nach "Funktion(" setzen...
      EndIf

      Repeat
        h1=PeekB(@extra+n)-48                                                ; Parameter 1

        If Feld(h1,i-1)                                                            ; Test(a,b,c)
          s=Mid(Zeile,Flags(#LinkesZeichen),Flags(#RechtesZeichen))         ; Parameter "a" oder "b" oder "c"

          If PeekB(@Zeile+Flags(#RechtesZeichen))=41                        ; Parameter "c" in Test(a,b,c)
            Ersetze(Flags(#LinkesZeichen)-1,Flags(#RechtesZeichen)+1,"")   ; Test(a,b)
          Else                                                                     ; Parameter "a" oder "b" in Test(a,b,c)
            Ersetze(Flags(#LinkesZeichen),Flags(#RechtesZeichen)+1,"")   ; Test(b,c) oder Test(a,c)
          EndIf

          h2=PeekB(@extra+n+1)-48                                          ; Parameter 2
          If h2>h1
            h2-1
          EndIf

          If h2                                                                     ; 0-> Parameter löschen
            If Feld(h2,i-1)                                                      ; Test(x,y)
              h1=Flags(#LinkesZeichen)+Flags(#RechtesZeichen)
              If PeekB(@Zeile+h1-1)=41                                       ; Test(x,y) -> Test(x,y|,z|)
                s=","+s
              Else                                                               ; Test(x,y) -> Test(x,|z,|y)
                s=s+","
                h1+1
              EndIf
              Ersetze(h1,0,s)                                                   ; Parameter einfügen
            EndIf
          EndIf

        EndIf
        extra=Mid(extra,3,#MaxVal)

      Until Len(extra)=0
    EndIf
  EndIf
EndProcedure

Procedure Befehle()
  Protected i.w

  ; Window / Dialog
  If Left(Zeile,7)="OPENW #"
    Ersetze(1,7,"OpenWindow(")
    i=KommaSuche(12,5)
    If i
      ErsetzePlus(i,0,","+#DOUBLEQUOTE$+#DOUBLEQUOTE$)
    Else
      Ersetze(Flags(#LetztesZeichen),0,"; (xxx)")
    EndIf

  ElseIf Left(Zeile,8)="DIALOG #"
    Ersetze(1,8,"OpenWindow(")
    i=KommaSuche(12,7)
    If i
      Ersetze(i,1,"); (x) ")
    Else
      Ersetze(Flags(#LetztesZeichen)+1,0,")")
    EndIf
    i=KommaSuche(12,1)
    If i
      Zeile=zeile+#CR$+#LF$+"CreateGadgetList(WindowID("+Mid(Zeile,12,i-12)+")); (x)"
    EndIf

  ElseIf Left(Zeile,8)="CLOSEW #"
    ErsetzePlus(1,8,"CloseWindow(")

  ElseIf Left(Zeile,13)="CLOSEDIALOG #"
    ErsetzePlus(1,13,"CloseWindow(")

  ElseIf Left(Zeile,9)="ENDDIALOG"
    Ersetze(1,9,"; (x) EndDialog")

  ElseIf Left(Zeile,10)="SHOWDIALOG"
    Ersetze(1,10,"; (x) ShowDialog")


    ; Graphik
  ElseIf Left(Zeile,4)="CLS "
    ErsetzePlus(1,4,"ClearScreen(")

  ElseIf Left(Zeile,6)="COLOR "
    i=KommaSuche(7,1)
    If i
      Ersetze(i,1,") : BackColor(")
    EndIf
    ErsetzePlus(1,6,"FrontColor(")

  ElseIf Left(Zeile,8)="DEFFILL "
    ErsetzePlus(1,8,"; (xxx) DefFill(")

  ElseIf Left(Zeile,5)="FILL "
    Ersetze(1,5,"FillArea(")
    Ersetze(Flags(#LetztesZeichen)+1,0,",-1); (x Color)")

  ElseIf Left(Zeile,5)="LINE "
    ErsetzePlus(1,5,"LineXY(")

  ElseIf Left(Zeile,6)="CURVE "
    ErsetzePlus(1,6,"; (xxx) Curve(")


    ; Events
  ElseIf Left(Zeile,8)="GETEVENT"
    ErsetzePlus(1,8,"Global _Mess=WaitWindowEvent(")

  ElseIf Left(Zeile,9)="PEEKEVENT"
    ErsetzePlus(1,9,"Global _Mess=WindowEvent(")

  ElseIf Left(Zeile,7)="KEYGET "
    ErsetzePlus(1,7,"; (xxx) KeyGet(")


    ; Sonstiges
  ElseIf Left(Zeile,6)="PRINT "
    Ersetze(1,6,"Debug ")

  EndIf

  ; Mathematik
  Austausch("SUCC(","(1+",""); schön ist anders...
  Austausch("PRED(","(-1+",""); noch grauslicher...

  ; Zeit
  Austausch("DELAY ","Delay(1000*",")")
  Austausch("DATE$","FormatDate("+#DOUBLEQUOTE$+"%dd%mm%yy"+#DOUBLEQUOTE$+",Date())","")

  ; Windows-API
  Austausch("GETNEAREST(","GetNearestColor_(WindowID(#win), RGB(","); (xxx #win)")
  Austausch("GetModuleHandle(","GetModuleHandle_(","")
  Austausch("_wParam","EventwParam()","")
  Austausch("_lParam","EventlParam()","")

  ; Konstante
  Austausch("TRUE","#True","");   Achtung! in GFA=-1, evtl. ist eine globale Variable TRUE=-1 besser
  Austausch("FALSE","#False","")
  Austausch("BS_","#BS_","")
  Austausch("DS_","#DS_","")
  Austausch("SS_","#SS_","")
  Austausch("WM_","#WM_","")
  Austausch("WS_","#WS_","")

  ; Dialog
  Spezialtausch("BUTTON ","ButtonGadget(",")",-1,"16")
  Spezialtausch("PUSHBUTTON ","ButtonGadget(",")",-1,"16")
  Spezialtausch("CHECKBOX ","CheckBoxGadget(",")",-1,"16")
  Spezialtausch("RADIOBUTTON ","OptionGadget(",")",-1,"16")
  Spezialtausch("EDITTEXT ","TextGadget(",")",-1,"16")

  If Left(Zeile,8)="CONTROL "
    If Feld(3,8)
      Select LCase(Mid(zeile,Flags(#LinkesZeichen)+1,Flags(#RechtesZeichen)-2))
        Case "static"
          Spezialtausch("CONTROL ","TextGadget(",")",-1,"182027")
        Case "button"
          Spezialtausch("CONTROL ","ButtonGadget(",")",-1,"182027")
      EndSelect
    EndIf
  EndIf
  ;CONTROL text.s,902,"static",#SS_CENTER,280,50,140,25
  ;TextGadget(902, 280,50,140,25, "TextGadget Sta",#SS_CENTER)

  ;CONTROL "&Ok",1,"button",$10010001,305,105,90,28
  ;ButtonGadget(1,35,105,90,28,"&Ok");,$10010001)


EndProcedure


Procedure Main()
  Define dummy.w
  Define dommy.w

  If FileSize(DateiName+#InputExtension)
    InputFile=ReadFile(#PB_Any,DateiName+#InputExtension)
    If InputFile

      OutputFile=CreateFile(#PB_Any,Dateiname+#OutputExtension)

      While Not(Eof(InputFile))

        Flags(#Bemerkung)=#False
        Zeile=Trim(ReadString(InputFile))

        Bemerkungen()

        ; Hauptarbeit
        If Flags(#Bemerkung)=#False
          Klein=LCase(Zeile)

          If Left(Klein,10)="procedure "
            Flags(#Prozedur)=#True
            Klammern(11)

          ElseIf Left(Klein,9)="function "
            dummy=FindeMin(Klein,"$")
            If dummy And dummy<FindeMax(Klein,"(")
              Ersetze(dummy,1,"")
              Ersetze(1,8,"Procedure."+Typ(3)) ; .s
            Else
              Ersetze(1,8,"Procedure."+Typ(2)) ; .w
            EndIf
            Klammern(13)

          ElseIf Left(Klein,7)="endfunc"
            Ersetze(1,7,"EndProcedure")

          ElseIf Left(klein,6)="local "
            Ersetze(1,5,"Protected")

          ElseIf Left(Klein,6)="return"
            If Flags(#Prozedur)
              Ersetze(1,6,"EndProcedure")
            Else
              Ersetze(1,6,"ProcedureReturn")
            EndIf

          ElseIf Left(Klein,9)="otherwise"
            Ersetze(1,9,"Default")

          ElseIf Left(Klein,1)="~"
            Ersetze(1,1,"")

          ElseIf Suche(" then ")
            Ersetze(Flags(#SuchErgebnis)+1,4,":")
            ;zeile=zeile+Str(Flags(#Strichpunkt))+"/"+Str(Len(Zeile))+"/"+Str(Flags(#LetztesZeichen))
            Ersetze(Flags(#LetztesZeichen)+1,0," : EndIf")  ; "then" wird zu ":", dehalb -2 (+1-3)

          ElseIf Analyse("do")
            If Flags(#SuchErgebnis)
              Ersetze(1,3,""); da steht wohl "Do While..."
              LoopStack+"W"
            Else
              Ersetze(1,2,"Repeat")
              LoopStack+"R"
            EndIf

          ElseIf Analyse("loop")
            If Flags(#SuchErgebnis)
              If Right(LoopStack,1)="R"
                Ersetze(1,5,""); da steht wohl "Loop Until..."
              Else
                dummy=Suche("until"); schon jetzt suchen, da nun ein Bemerkung eingefügt wird...
                dommy=Flags(#LetztesZeichen); detto
                Ersetze(1,4,"Wend ; (x)")
                If dummy; war's also "Do While... Loop Until..."
                  Ersetze(Flags(#SuchErgebnis)+6,5,"If")
                  Ersetze(dommy+4,0," : Break : EndIf")
                EndIf
              EndIf
              LoopStack=Left(LoopStack,Len(LoopStack)-1)
            Else
              If Right(LoopStack,1)="R"
                Ersetze(1,4,"Forever; (x)")
              Else
                Ersetze(1,4,"Wend")
              EndIf
              LoopStack=Left(LoopStack,Len(LoopStack)-1)
            EndIf
          EndIf

          Befehle()
          VarTypen()

        EndIf

        WriteStringN(OutputFile,Zeile)

      Wend

      CloseFile(InputFile)
      CloseFile(OutputFile)
    EndIf
  EndIf
EndProcedure

Main()

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = ---
; EnableXP