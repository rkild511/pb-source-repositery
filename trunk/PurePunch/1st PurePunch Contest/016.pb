;*****************************************************************************
;* PurePunch Contest 
;* http://www.purebasic.fr/english/viewtopic.php?p=256341#256341
;*
;* Name   : First PurePunch ;)
;* Author : djes
;* Date   : Dim 24/Aoû/2008
;* Link   : http://www.purebasic.fr/french/viewtopic.php?p=86708#86708
;*
;*****************************************************************************
Procedure tcl(t1.s, t2.s, t3.s, t4.s, t5.s, t6.s, t7.s, t8.s, t9.s) : ConsoleColor(15, 0) : Print(t1) : ConsoleColor(14, 0) : Print(t2) : ConsoleColor(13, 0) : Print(t3) : ConsoleColor(12, 0) : Print(t4) : ConsoleColor(11, 0) : Print(t5) : ConsoleColor(10, 0) : Print(t6) : ConsoleColor(9, 0) : Print(t7) : ConsoleColor(8, 0) : Print(t8) : ConsoleColor(15, 0) : PrintN(t9) : EndProcedure
If OpenConsole()
tcl("PPPP    ","UU  UU  ","RRRR    ","EEEEE   ","BBBB    "," AAAA   "," SSSSS  ","IIII  "," CCCCC") 
tcl("PP  PP  ","UU  UU  ","RR  RR  ","EE      ","BB  B   ","AA  AA  ","SS      "," II   ","CC    ")
tcl("PP  PP  ","UU  UU  ","RR  RR  ","EE      ","BB  BB  ","AA  AA  ","SS      "," II   ","CC    ")
tcl("PP  PP  ","UU  UU  ","RR  RR  ","EE      ","BB  B   ","AA  AA  ","SS      "," II   ","CC    ")
tcl("PPPP    ","UU  UU  ","RRRR    ","EEEE    ","BBBB    ","AAAAAA  "," SSSS   "," II   ","CC    ")
tcl("PP      ","UU  UU  ","RR  RR  ","EE      ","BB  BB  ","AA  AA  ","    SS  "," II   ","CC    ")
tcl("PP      ","  UUUU  ","RR  RR  ","EEEEEE  ","BBBBB   ","AA  AA  ","SSSSS   ","IIII  "," CCCCC")
ConsoleColor(0,15) :PrintN("Press enter to quit") : Input() : CloseConsole() : EndIf
