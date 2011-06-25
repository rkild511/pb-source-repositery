

; PPV v0.02 blueznl
;
; PurePunch Validator
;
title.s = "PurePunch Validator v0.03 by BluezNL"
;
category_1 = #True           ; set to false if it's more than 10 lines or a line has more than 256 chars
category_2 = #True           ; set to false if it's more than 100 lines or a line contains multiple statements
category_3 = #True           ; set to false if the total number of chars is more than 2560
category_4 = #True           ; set to false if it's more than 10 lines or a line has more than 80 chars
;
; note: all lines are trimmed, and empty lines and comment only lines are ignored
;
line_nr = 0
line_qualifying_nr = 0
line_l_max = 0
line_l_max_nr = 0
char_nr = 0
;
; f.s = ProgramParameter()
; f.s = "d:\purebasic\_projects\test.pb"
; f.s = "d:\purebasic\_projects\x_lib\x_lib.pb"
; f.s = "d:\purebasic\_projects\ppv.pb"
; f.s = "d:\purebasic\_projects\test.pb"
;
If f.s = ""
  f = OpenFileRequester(title,"","PureBasic|*.pb|All files|*.*",0)
EndIf
If FileSize(f) > 1
  ReadFile(1,f)
  While (category_1 Or category_2 Or category_3) And (Not Eof(1))
    y.s = Trim(ReadString(1,#PB_UTF8))
    line_nr = line_nr+1
    If y = ""
    ElseIf Left(y,1)=";"
    Else
      line_qualifying_nr = line_qualifying_nr+1
      line_l = Len(y)
      If line_l > line_max
        line_l_max = line_l
        line_l_max_nr = line_nr
      EndIf
      ;
      ; category no.1: 256 characters or less
      ;
      If line_l > 256
        category_1 = #False
      EndIf
      ;
      ; category no. 1: not too many lines? 10 or less
      ;
      If line_qualifying_nr > 10
        category_1 = #False
      EndIf
      ;
      ; category no.2: not too many lines? 100 or less
      ;
      If line_qualifying_nr > 100
        category_2 = false
      EndIf
      ;
      ; category no.2: single statement test
      ;
      p_n = CountString(y,#DQUOTE$)
      If p_n > 0
        x.s = ""
        p = 1
        While p <= p_n+1
          x = x+StringField(y,p,#DQUOTE$)
          p = p+2
        Wend
        y = x
      EndIf
      p_n = CountString(y,"'")
      If p_n > 0
        x = ""
        p = 1
        While p <= p_n+1
          x = x+StringField(y,p,"'")
          p = p+2
        Wend
        y = x
      EndIf
      p_n = CountString(y,";")
      If p_n > 0
        x = ""
        p = 1
        While p <= p_n+1
          x = x+StringField(y,p,";")
          p = p+2
        Wend
        y = x
      EndIf
      If CountString(y,":") > 0
        category_2 = #False
      EndIf
      ;
      ; category no.3: Not too large?
      ;
      char_nr = char_nr + line_l
      If char_nr > 2560
        category_3 = false
      EndIf
      ;
      ; category no.4: max. 10 lines of max. 80 characters
      ;
      If line_l > 80 Or line_qualifying_nr > 10
        category_4 = #False
      EndIf
      ;
    EndIf
  Wend
  CloseFile(1)
  ;
  y = "Lines: "+Str(line_nr)+Chr(13)
  y = y+"Qualifying lines: "+Str(line_qualifying_nr)+Chr(13)
  y = y+"Longest line: "+Str(line_l_max_nr)+" ("+Str(line_l_max)+" characters)"+Chr(13)
  y = y+"Length: "+Str(char_nr)+" characters"
  ;
  x = ""
  If category_1
    x = x+Chr(13)+"CATEGORY I - PASSED - max 10 lines of max 256 characters"
  Else
    x = x+Chr(13)+"CATEGORY I - FAILED"
  EndIf
  If category_2
    x = x+Chr(13)+"CATEGORY II - PASSED - max 100 qualifying lines with each one statement"
  Else
    x = x+Chr(13)+"CATEGORY II - FAILED"
  EndIf
  If category_3
    x = x+Chr(13)+"CATEGORY III - PASSED - max 2560 characters"
  EndIf
  x = x+Chr(13)
  If category_4
    x = x+Chr(13)+"JUNE 2009 - PASSED - max 10 qualifying lines of max 80 characters"
  Else
    x = x+Chr(13)+"JUNE 2009 - FAILED"
  EndIf
  MessageRequester(title,f+Chr(13)+Chr(13)+y+Chr(13)+x,#PB_MessageRequester_Ok)
  ;
EndIf

; IDE Options = PureBasic 4.31 (Windows - x86)
; CursorPosition = 3