; http://www.purebasic-lounge.de
; Author: Hroudtwolf (example added by Andre)
; Date: 21. May 2006
; OS: Windows, Linux
; Demo: Yes

Procedure.s URLEncode (String.s)
  Protected Encoded.s,x.l,y.l,Char.s,AlphaNumeric.l,BufferIndex.l
  Protected Dim ASCBUFFER.s (64)
  For x=48 To 57
    ASCBUFFER (BufferIndex.l)=Chr(x)
    BufferIndex.l+1
  Next x
  For x=65 To 90
    ASCBUFFER (BufferIndex.l)=Chr(x)
    BufferIndex.l+1
  Next x
  For x=97 To 122
    ASCBUFFER (BufferIndex.l)=Chr(x)
    BufferIndex.l+1
  Next x
  ASCBUFFER (BufferIndex.l)="-":BufferIndex.l+1
  ASCBUFFER (BufferIndex.l)="_":BufferIndex.l+1
  ASCBUFFER (BufferIndex.l)="."
  For x=0 To Len (String.s)-1
    Char.s=PeekS(@String+x,1)
    AlphaNumeric.l=#False
    For y=1 To BufferIndex.l
      If Char.s=ASCBUFFER (y)
        AlphaNumeric.l=#True
      EndIf
    Next y
    If AlphaNumeric.l=#False
      If Char.s=Chr(32)
        Encoded.s+"+"
      Else
        Encoded.s+"%"+RSet(Hex(Asc(Char.s)),2,"0")
      EndIf
    Else
      Encoded.s+Char.s
    EndIf
  Next x
  ProcedureReturn Encoded.s
EndProcedure


Debug URLEncode(#DQUOTE$ + "This is a test string." + #DQUOTE$)

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -