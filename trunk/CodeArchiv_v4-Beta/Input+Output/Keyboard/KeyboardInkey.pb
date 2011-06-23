; German forum: http://www.purebasic.fr/german/viewtopic.php?t=493&highlight=
; Author: Lebostein (updated for PB 4.00 by Andre)
; Date: 19. October 2004
; OS: Windows
; Demo: Yes
 
; ****************************************************** 
; Tastaturabfrage bei OpenScreen (deutsche Tastatur) 
; 10. März 2004 by Lebostein 
; ****************************************************** 
; Mail: Lebostein@gmx.de 
; http://home.arcor.de/tomysoft/ 
; ****************************************************** 


; --- Folgender Abschnitt kann als Include ausgelagert werden --- 

Structure KeySet 
  keycode.l 
  combine.l[3] 
EndStructure 

Global NewList KeyList.KeySet() 

Procedure AddKey(code.l, none_combi.l, with_shift.l, with_altgr.l) 
  LastElement(KeyList()) 
  AddElement(KeyList()) 
  KeyList()\keycode = code 
  KeyList()\combine[0] = none_combi 
  KeyList()\combine[1] = with_shift 
  KeyList()\combine[2] = with_altgr 
EndProcedure 

; Leertaste (Space) 
AddKey(057, 032, 032, 000)    ; [ ] [ ] [ ] ... 057 = #PB_Key_Space 

; Tasten im Hauptblock (48) 
AddKey(002, 049, 033, 000)    ; [1] [!] [ ] ... 002 = #PB_Key_1 
AddKey(003, 050, 034, 178)    ; [2] ["] [²] ... 003 = #PB_Key_2 
AddKey(004, 051, 167, 179)    ; [3] [§] [³] ... 004 = #PB_Key_3 
AddKey(005, 052, 036, 000)    ; [4] [$] [ ] ... 005 = #PB_Key_4 
AddKey(006, 053, 037, 000)    ; [5] [%] [ ] ... 006 = #PB_Key_5 
AddKey(007, 054, 038, 000)    ; [6] [&] [ ] ... 007 = #PB_Key_6 
AddKey(008, 055, 047, 123)    ; [7] [/] [{] ... 008 = #PB_Key_7 
AddKey(009, 056, 040, 091)    ; [8] [(] [[] ... 009 = #PB_Key_8 
AddKey(010, 057, 041, 093)    ; [9] [)] []] ... 010 = #PB_Key_9 
AddKey(011, 048, 061, 125)    ; [0] [=] [}] ... 011 = #PB_Key_0 
AddKey(012, 223, 063, 092)    ; [ß] [?] [\] ... 012 = #PB_Key_Minus 
AddKey(013, 180, 096, 000)    ; [´] [`] [ ] ... 013 = #PB_Key_Equals 
AddKey(016, 113, 081, 064)    ; [q] [Q] [@] ... 016 = #PB_Key_Q 
AddKey(017, 119, 087, 000)    ; [w] [W] [ ] ... 017 = #PB_Key_W 
AddKey(018, 101, 069, 128)    ; [e] [E] [€] ... 018 = #PB_Key_E 
AddKey(019, 114, 082, 000)    ; [r] [R] [ ] ... 019 = #PB_Key_R 
AddKey(020, 116, 084, 000)    ; [t] [T] [ ] ... 020 = #PB_Key_T 
AddKey(021, 122, 090, 000)    ; [z] [Z] [ ] ... 021 = #PB_Key_Y 
AddKey(022, 117, 085, 000)    ; [u] [U] [ ] ... 022 = #PB_Key_U 
AddKey(023, 105, 073, 000)    ; [i] [I] [ ] ... 023 = #PB_Key_I 
AddKey(024, 111, 079, 000)    ; [o] [O] [ ] ... 024 = #PB_Key_O 
AddKey(025, 112, 080, 000)    ; [p] [P] [ ] ... 025 = #PB_Key_P 
AddKey(026, 252, 220, 000)    ; [ü] [Ü] [ ] ... 026 = #PB_Key_LeftBracket 
AddKey(027, 043, 042, 126)    ; [+] [*] [~] ... 027 = #PB_Key_RightBracket 
AddKey(030, 097, 065, 000)    ; [a] [A] [ ] ... 030 = #PB_Key_A 
AddKey(031, 115, 083, 000)    ; [s] [S] [ ] ... 031 = #PB_Key_S 
AddKey(032, 100, 068, 000)    ; [d] [D] [ ] ... 032 = #PB_Key_D 
AddKey(033, 102, 070, 000)    ; [f] [F] [ ] ... 033 = #PB_Key_F 
AddKey(034, 103, 071, 000)    ; [g] [G] [ ] ... 034 = #PB_Key_G 
AddKey(035, 104, 072, 000)    ; [h] [H] [ ] ... 035 = #PB_Key_H 
AddKey(036, 106, 074, 000)    ; [j] [J] [ ] ... 036 = #PB_Key_J 
AddKey(037, 107, 075, 000)    ; [k] [K] [ ] ... 037 = #PB_Key_K 
AddKey(038, 108, 076, 000)    ; [l] [L] [ ] ... 038 = #PB_Key_L 
AddKey(039, 246, 214, 000)    ; [ö] [Ö] [ ] ... 039 = #PB_Key_SemiColon 
AddKey(040, 228, 196, 000)    ; [ä] [Ä] [ ] ... 040 = #PB_Key_Apostrophe 
AddKey(041, 094, 176, 000)    ; [^] [°] [ ] ... 041 = #PB_Key_Grave 
AddKey(043, 035, 039, 000)    ; [#] ['] [ ] ... 043 = #PB_Key_BackSlash 
AddKey(044, 121, 089, 000)    ; [y] [Y] [ ] ... 044 = #PB_Key_Z 
AddKey(045, 120, 088, 000)    ; [x] [X] [ ] ... 045 = #PB_Key_X 
AddKey(046, 099, 067, 000)    ; [c] [C] [ ] ... 046 = #PB_Key_C 
AddKey(047, 118, 086, 000)    ; [v] [V] [ ] ... 047 = #PB_Key_V 
AddKey(048, 098, 066, 000)    ; [b] [B] [ ] ... 048 = #PB_Key_B 
AddKey(049, 110, 078, 000)    ; [n] [N] [ ] ... 049 = #PB_Key_N 
AddKey(050, 109, 077, 181)    ; [m] [M] [µ] ... 050 = #PB_Key_M 
AddKey(051, 044, 059, 000)    ; [,] [;] [ ] ... 051 = #PB_Key_Comma 
AddKey(052, 046, 058, 000)    ; [.] [:] [ ] ... 052 = #PB_Key_Period 
AddKey(053, 045, 095, 000)    ; [-] [_] [ ] ... 053 = #PB_Key_Slash 
AddKey(086, 060, 062, 124)    ; [<] [>] [|] ... 086 = keine PB-Konstante 

; Tasten auf dem Keypad (15) 
AddKey(055, 042, 000, 000)    ; [*] [ ] [ ] ... 055 = #PB_Key_Multiply 
AddKey(071, 055, 000, 000)    ; [7] [ ] [ ] ... 071 = #PB_Key_Pad7 
AddKey(072, 056, 000, 000)    ; [8] [ ] [ ] ... 072 = #PB_Key_Pad8 
AddKey(073, 057, 000, 000)    ; [9] [ ] [ ] ... 073 = #PB_Key_Pad9 
AddKey(074, 045, 000, 000)    ; [-] [ ] [ ] ... 074 = #PB_Key_Subtract 
AddKey(075, 052, 000, 000)    ; [4] [ ] [ ] ... 075 = #PB_Key_Pad4 
AddKey(076, 053, 000, 000)    ; [5] [ ] [ ] ... 076 = #PB_Key_Pad5 
AddKey(077, 054, 000, 000)    ; [6] [ ] [ ] ... 077 = #PB_Key_Pad6 
AddKey(078, 043, 000, 000)    ; [+] [ ] [ ] ... 078 = #PB_Key_Add 
AddKey(079, 049, 000, 000)    ; [1] [ ] [ ] ... 079 = #PB_Key_Pad1 
AddKey(080, 050, 000, 000)    ; [2] [ ] [ ] ... 080 = #PB_Key_Pad2 
AddKey(081, 051, 000, 000)    ; [3] [ ] [ ] ... 081 = #PB_Key_Pad3 
AddKey(082, 048, 000, 000)    ; [0] [ ] [ ] ... 082 = #PB_Key_Pad0 
AddKey(083, 044, 000, 000)    ; [,] [ ] [ ] ... 083 = #PB_Key_Decimal 
AddKey(181, 047, 000, 000)    ; [/] [ ] [ ] ... 181 = #PB_Key_Divide 


; --- Ende der Include-Datei ---- 


; ---------------------- 
; --- Hauptprogramm ---- 
; ---------------------- 

InitSprite() 
InitKeyboard() 
OpenScreen(800,600,16,"Eingabe") 

Repeat 

  ExamineKeyboard() 

  ; *********************************************************************** 
    
  ; Prüfen, ob die Shift-Taste gedrückt wird 
  combine = 0 
  If KeyboardPushed(#PB_Key_RightShift): combine = 1: EndIf 
  If KeyboardPushed(#PB_Key_LeftShift): combine = 1: EndIf 
  If KeyboardPushed(#PB_Key_RightAlt): combine = 2: EndIf 
  
  ; Alle oben deklarierten Tasten prüfen 
  ForEach KeyList() 
  code = KeyList()\keycode 
  wert = KeyList()\combine[combine] 
  If KeyboardPushed(code) And hold = 0: hold = code: text$ + Chr(wert): EndIf 
  Next 
  
  ; Wenn die Löschen-Taste gedrückt wird 
  code = #PB_Key_Back 
  If KeyboardPushed(code) And hold = 0: hold = code: text$ = Left(text$, Len(text$) - 1): EndIf 
  
  ; Wenn Entfernen-Taste gedrückt wird 
  code = #PB_Key_Delete 
  If KeyboardPushed(code) And hold = 0: hold = code: text$ = Space(0): EndIf 
  
  ; Prüfen, ob aktuelle Taste losgelassen wurde 
  If KeyboardReleased(hold): hold = 0: EndIf 
  
  ; *********************************************************************** 
  
  ; Text ausgeben 
  ClearScreen(RGB(0,0,0)) 
  StartDrawing(ScreenOutput()) 
  DrawingMode(1) 
  FrontColor(RGB(100,255,0)) 
  DrawText(10,100,text$ + "_") 
  StopDrawing() 
  FlipBuffers() 
  
Until KeyboardPushed(#PB_Key_Escape) 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -