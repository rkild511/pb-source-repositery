;*****************************************************************************
;* PurePunch Contest 
;* http://www.purebasic.fr/english/viewtopic.php?p=256341#256341
;*
;* Name   : 
;* Author : djes
;* Date   : Dim 24/Aoû/2008
;* Link   : http://www.purebasic.fr/french/viewtopic.php?p=86733#86733
;*
;*****************************************************************************
Procedure tcl(t1.s, t2.s, t3.s, t4.s, t5.s, t6.s, t7.s, t8.s, t9.s) : Static c : c+1 : ConsoleColor((c+15)%16, 0) : Print(t1) : ConsoleColor((c+14)%16, 0) : Print(t2) : ConsoleColor((c+13)%16, 0) : Print(t3) : ConsoleColor((c+12)%16, 0) : Print(t4) : ConsoleColor((c+11)%16, 0) : Print(t5) : ConsoleColor((c+10)%16, 0) : Print(t6) : ConsoleColor((c+9)%16, 0) : Print(t7) : ConsoleColor((c+8)%16, 0) : Print(t8) : ConsoleColor((c+15)%16, 0) : PrintN(t9) : EndProcedure
If OpenConsole() : EnableGraphicalConsole(1) : Repeat : ClearConsole() : ConsoleLocate(0, 0)
tcl("PPPP    ","UU  UU  ","RRRR    ","EEEEE   ","BBBB    "," AAAA   "," SSSSS  ","IIII  "," CCCCC") 
tcl("PP  PP  ","UU  UU  ","RR  RR  ","EE      ","BB  B   ","AA  AA  ","SS      "," II   ","CC    ")
tcl("PP  PP  ","UU  UU  ","RR  RR  ","EE      ","BB  BB  ","AA  AA  ","SS      "," II   ","CC    ")
tcl("PP  PP  ","UU  UU  ","RR  RR  ","EE      ","BB  B   ","AA  AA  ","SS      "," II   ","CC    ")
tcl("PPPP    ","UU  UU  ","RRRR    ","EEEE    ","BBBB    ","AAAAAA  "," SSSS   "," II   ","CC    ")
tcl("PP      ","UU  UU  ","RR  RR  ","EE      ","BB  BB  ","AA  AA  ","    SS  "," II   ","CC    ")
tcl("PP      ","  UUUU  ","RR  RR  ","EEEEEE  ","BBBBB   ","AA  AA  ","SSSSS   ","IIII  "," CCCCC")
Delay(125) : ForEver : CloseConsole() : EndIf

