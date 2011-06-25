;*****************************************************************************
;* PurePunch Contest 
;* http://www.purebasic.fr/english/viewtopic.php?p=256341#256341
;*
;* Name   : 
;* Author : comtois
;* Date   : Dim 24/Aoû/2008
;* Link   : http://www.purebasic.fr/french/viewtopic.php?p=86745#86745
;*
;*****************************************************************************
Procedure cercle(x,y,R,c) :  xx = 0 : yy = R : d = 1 - R
  ConsoleColor(c,0) : p.s="x"
  ConsoleLocate(x+xx,y+yy):Print("o"): ConsoleLocate(x-xx,y+yy):Print(p): ConsoleLocate(x+xx,y-yy):Print(p): ConsoleLocate(x-xx,y-yy):Print(p)
  ConsoleLocate(x+yy,y+xx):Print("o"): ConsoleLocate(x-yy,y+xx):Print(p): ConsoleLocate(x+yy,y-xx):Print(p): ConsoleLocate(x-yy,y-xx):Print(p)
  While  yy > xx: If  d < 0:d + (2 * xx + 3):Else:d + (2 * (xx - yy) + 5):yy - 1:EndIf :xx + 1
    ConsoleLocate(x+yy,y+xx):Print(p): ConsoleLocate(x-yy,y+xx):Print(p): ConsoleLocate(x+yy,y-xx):Print(p): ConsoleLocate(x-yy,y-xx):Print(p)
    ConsoleLocate(x+xx,y+yy):Print(p): ConsoleLocate(x+xx,y-yy):Print(p): ConsoleLocate(x-xx,y+yy):Print(p): ConsoleLocate(x-xx,y-yy):Print(p)
 Wend 
EndProcedure
OpenConsole() : EnableGraphicalConsole(1): For x=1 To 10 :cercle(40,11,x,x):Next x: Input() : CloseConsole()
