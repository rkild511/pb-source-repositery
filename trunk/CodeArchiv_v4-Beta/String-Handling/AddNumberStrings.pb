; www.purearea.net
; Author: pupil
; Date: 23. September 2002
; OS: Windows
; Demo: Yes

; "StringAdd.pb" Created for PureBasic 3.30 on 23/9-2002 by Pupil
;
; StringAdd is a Procedure that enables you to add numbers that have a decimal
; precision of 64k digits (for now restricted by PureBasic 3.30 64k string limit
; and possible by the stack size used inside procedures).
;
; Feel free to use and modify source code as you please.
;
; GENERAL INFO ABOUT USAGE:
;
; * The Procedure is usable only with strings containing decimal values, non numerical
;   characters except "." SHOULD not be passed to Procedure.
;
; * The returned value is a string containing the result of the addition, this result
;   may or may not be usable by the built in Val() command depending on it's length.

; DISCLAIMER
; The author can not be held responsible For ANY damage directly Or indirecly caused by
; this source code. Every user uses this source code at his/her own risk.
;
; /Pupil (Jörgen J.)


; Procedure that adds two numbers as strings which
; makes it possible to have a 64k precision if wanted.
; Simple hand calculating algorithm used i.e. mimics the
; procedure when adding two numbers by hand on paper.
;
; Example:
; AddString("1.123456789", "2.111111111") will return 3.234567900
;
; By Pupil (Jörgen J.)
; Created for PureBasic 3.30 on 23/9-2002
;
; Feel free to use or change, no strings attached -only added ;)
; Read README.txt for more info.
;

Structure CharType
  Char.b
EndStructure

Procedure.s AddString(arg1.s, arg2.s)
  Define.CharType *p1, *p2, *pend1, *pend2
  sum.s = "" : carry.l = 0
  arg1 = "0" + arg1 : arg2 = "0" + arg2
  a1 = FindString(arg1, ".", 1)
  a2 = FindString(arg2, ".", 1)
  If a1 Or a2
    If a1 : l1 = Len(arg1) - a1 : Else : arg1 + "." : EndIf
    If a2 : l2 = Len(arg2) - a2 : Else : arg2 + "." : EndIf
    If l1 <> l2
      If l1 > l2
        diff = l1 - l2
        sum = Right(arg1, diff)
        arg1 = Left(arg1, Len(arg1)-diff)
      ElseIf l2 > l1
        diff = l2 - l1
        sum = Right(arg2, diff)
        arg2 = Left(arg2, Len(arg2)-diff)
      EndIf
    EndIf
  EndIf
  *pend1 = @arg1 : *p1 = *pend1 + Len(arg1) - 1
  *pend2 = @arg2 : *p2 = *pend2 + Len(arg2) - 1
  Repeat
    If *p1\Char = '.'
      sum = "." + sum
    Else
      tmp = *p1\Char - '0' + *p2\Char - '0' + carry
      If tmp >= 10
        carry = 1
        tmp - 10
      Else
        carry = 0
      EndIf
      sum = Chr(tmp + '0') + sum
    EndIf
    If *p1 > *pend1 : *p1 - 1 : EndIf
    If *p2 > *pend2 : *p2 - 1 : EndIf
  Until *p1 = *pend1 And *p2=*pend2
  If carry
    sum = Chr(carry + '0') + sum
  EndIf
  ProcedureReturn sum
EndProcedure

; Example 1
b1.s = "1.123456789"
b2.s = "2.111111111"

sum.s = AddString(b1, b2)
Debug b1+" + "+b2+" = "+sum

; Example 2
b1.s = "999999999"
b2.s = "1"

sum.s = AddString(b1, b2)
Debug b1+" + "+b2+" = "+sum

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -