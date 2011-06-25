;*****************************************************************************
;* PurePunch Contest 
;* http://www.purebasic.fr/english/viewtopic.php?p=256341#256341
;*
;* Author : djes
;* Date : Sun Aug 24, 2008
;* Link : http://www.purebasic.fr/english/viewtopic.php?p=256355#256355
;*
;*****************************************************************************
Procedure text_line(x1.f, y1.f, x2.f, y2.f)
  Repeat
    ConsoleColor(1 + u.f * 14,0) : ConsoleLocate(x1 + u * (x2 - x1), y1 + u * (y2 - y1))
;    Print(Mid("PUREBASIC", u * 9, 1))
    Print("PUREBASIC") : u + 0.05
  Until u >= 1
EndProcedure
If OpenConsole()
  EnableGraphicalConsole(1) : Repeat : ClearConsole() : text_line(40 + 30 * Sin(i.f), 10 + 10 * Cos(i), 40 - 30 * Sin(i), 10 - 10 * Cos(i)) : i + 0.1 : Delay(16) : ForEver : CloseConsole()
EndIf  
