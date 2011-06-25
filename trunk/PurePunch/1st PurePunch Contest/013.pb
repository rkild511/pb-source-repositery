;*****************************************************************************
;* PurePunch Contest 
;* http://www.purebasic.fr/english/viewtopic.php?p=256341#256341
;*
;* Author : blueznl
;* Date : Mon Dec 15, 2008
;* Link : http://www.purebasic.fr/english/viewtopic.php?p=270791#270791
;*
;*****************************************************************************
; PPV v0.01 blueznl
;
; PurePunch Validator
;
title.s = "PurePunch Validator v0.01 by BluezNL"
;
category_1 = #True           ; set to false if it is more than 10 lines or a line has more than 256 chars
category_2 = #True           ; set to false if it's more than 100 lines or a line contains multiple statements
category_3 = #True           ; set to false if the total number of chars is more than 2560
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
    EndIf
  Wend
  CloseFile(1)
  ;
  x = f+Chr(13)+Chr(13)
  y = Chr(13)+Chr(13)+"Lines: "+Str(line_nr)+Chr(13)
  y = y+"Qualifying lines: "+Str(line_qualifying_nr)+Chr(13)
  y = y+"Longest line: "+Str(line_l_max_nr)+" ("+Str(line_l_max)+" characters)"+Chr(13)
  y = y+"Length: "+Str(char_nr)+" characters"+Chr(13)+Chr(13)
  ;
  If category_1
    MessageRequester(title,x+"PASSED - CATEGORY I."+y+"Max 10 lines of max 256 characters.",#PB_MessageRequester_Ok)
  ElseIf category_2
    MessageRequester(title,x+"PASSED - CATEGORY II."+y+"Max 100 qualifying lines with each one statement.",#PB_MessageRequester_Ok)
  ElseIf category_3
    MessageRequester(title,x+"PASSED - CATEGORY III."+y+"Max 2560 characters.",#PB_MessageRequester_Ok)
  Else
    MessageRequester(title,x+"FAILED ALL CATEGORIES."+y+"File did Not pass PurePunch validation.",#PB_MessageRequester_Ok|#MB_ICONHAND)
  EndIf
  ;
EndIf

