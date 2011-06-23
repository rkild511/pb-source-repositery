; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7146&highlight=
; Author: oldefoxx
; Date: 06. August 2003
; OS: Windows
; Demo: Yes


; * Positioning output on the Console *

; It isn't immediately apparent, but you can do more than just write text to the console when it
; is open -- you can position it as well. But when positioning text, you either want to go to a
; certain place (x,y coordinates), return to a certain place (remember last x,y coordinates),
; extend an existing line, or end a line so that you can begin a new one. 

; The code that follows is a shell for adding some of these behaviors to the PureBASIC concole.
; It combines the Print() And PrintN() procedures with the ConsoleLocate() procedure, allows you
; to embed carrage Return codes (Chr(13)) into your strings to determine where lines should end
; and others start, And remembers Global values for the row and column, so that you can continue
; printing from your last location if you so desire. 

; The main program just displays how some of these features can be used to enhance your ability
; to write to the opened console window. 

Declare WriteConsole(a.l,b.l,d.s) 
Declare.s pad(str.s,size.l) 
OpenConsole() 
Global scnwidth,scnheight,row,col 
scnwidth=80 
scnheight=25 
t$="This is a test." 
u$="And so is" 
v$="this test" 
ofs=0 
For cnt=1 To 25 
  WriteConsole(cnt-1,0,pad(Str(cnt),2)+" "+t$) 
  WriteConsole(25-cnt,40,pad(Str(cnt),2)+" "+t$) 
  If cnt-Int(cnt/3)*3 = 1 
    writeconsole(25-cnt,scnwidth-cnt/3-10,Mid(v$,Len(v$)-ofs,1)) 
    ofs=ofs+1 
    writeconsole(25-cnt,cnt/3+24,Mid(u$,ofs,1)) 
  EndIf 
Next 
Repeat 
Until Inkey()>"" 
CloseConsole() 
End 

Procedure.s pad(str.s,size.l) 
  tmp$=Str.s 
  If Len(tmp$)<size 
    tmp$=Space(size-Len(tmp$))+tmp$ 
  EndIf 
  ProcedureReturn tmp$ 
EndProcedure 

Procedure WriteConsole(rw,cl,txt$) 
  tt$=txt$ 
  If rw>=0 
    row=rw 
  EndIf 
  If cl>=0 
    col=cl 
  EndIf 
  ;frontcolor(cr/65536,cr/256 And 255,cr And 255) 
  ConsoleLocate(col,row) 
  Repeat 
    c=FindString(tt$,Chr(13),1) 
    If c 
      PrintN(Left(tt$,c-1)) 
      tt$=Mid(tt$,c+1,Len(tt$)-c) 
      If Left(tt$,1)=Chr(10) 
        tt$=Mid(tt$,2,Len(tt$)-2) 
      EndIf 
      row=row+1 
      col=1 
    EndIf 
  Until c=0 
  Print(tt$) 
  col=col+Len(tt$) 
  While col>scnwidth 
    row=row+1 
    col=col-scnwidth 
  Wend 
  While row>scnheight 
    row=scnheight-1 
  Wend 
EndProcedure 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
