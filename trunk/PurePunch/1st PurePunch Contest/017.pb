;*****************************************************************************
;* PurePunch Contest 
;* http://www.purebasic.fr/english/viewtopic.php?p=256341#256341
;*
;* Name   : 
;* Author : Ar-S
;* Date   : Dim 24/Aoû/2008
;* Link   : http://www.purebasic.fr/french/viewtopic.php?p=86728#86728
;*
;*****************************************************************************
Procedure tcl(t1.s, t2.s, t3.s, t4.s, t5.s, t6.s, t7.s, t8.s, t9.s) :  For i=1 To 3 : ConsoleColor(7, 0) : Print(t1) : ConsoleColor(10, 0) : Print(t2) : ConsoleColor(9, 0) : Print(t3) : ConsoleColor(12, 0) : Print(t4) : ConsoleColor(11, 0) : Print(t5) : ConsoleColor(13, 0) : Print(t6) : ConsoleColor(6, 0) : Print(t7) : ConsoleColor(7, 0) : Print(t8) : ConsoleColor(11, 0) : PrintN(t9) : Delay (50) : Next i : EndProcedure
If OpenConsole()
  tcl("PPPP    ","UU  UU  ","RRRR    ","EEEEE   ","BBBB    "," AAAA   "," SSSSS  ","IIII  "," CCCCC")
  tcl("PP  PP  ","UU  UU  ","RR  RR  ","EE      ","BB  B   ","AA  AA  ","SS      "," II   ","CC    ")
  tcl("PP  PP  ","UU  UU  ","RR  RR  ","EE      ","BB  BB  ","AA  AA  ","SS      "," II   ","CC    ")
  tcl("PP  PP  ","UU  UU  ","RR  RR  ","EE      ","BB  B   ","AA  AA  ","SS      "," II   ","CC    ")
  tcl("PPPP    ","UU  UU  ","RRRR    ","EEEE    ","BBBB    ","AAAAAA  "," SSSS   "," II   ","CC    ")
  tcl("PP      ","UU  UU  ","RR  RR  ","EE      ","BB  BB  ","AA  AA  ","    SS  "," II   ","CC    ")
  tcl("PP      ","  UUUU  ","RR  RR  ","EEEEEE  ","BBBBB   ","AA  AA  ","SSSSS   ","IIII  "," CCCCC")
ConsoleColor(0,15) : Delay (500) :  PrintN("Press enter to quit") : Input() :  CloseConsole() : EndIf
