; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8165&highlight=
; Author: Num3 (updated for PB 4.00 by Andre)
; Date: 03. November 2003
; OS: Windows
; Demo: Yes

; Implementation of BARCODE 39 
; 
; by Num3 


; Some comments:
; You can increase the width of each bar, that increases the readability in bad surfaces
; (cardboxes etc...) 
; I guess PaintCodeBar39(40,1,"*bla bla bla*",1) is good for laser printers and
; PaintCodeBar39(40,3 Or 4,"*bla bla bla*",1) should print out ok on inkjects ... 
;
; You can also edit Line (xpos, ypos, 0, ypos + h,RGB(0,0,0)) to less black:
; Line (xpos, ypos, 0, ypos + h,RGB(20,20,20))

Structure C39 
    Char.s 
    bar.b [6] 
    spe.b [6] 
EndStructure 

Global Dim CODE39.C39 (43) 

; Yes, i know it's a mess, and i could make it much simpler, 
; but i can't test it, so this is more readable for errors ;) 

CODE39(0)\Char = "0" 
CODE39(0)\bar[1] = 0 
CODE39(0)\spe[1] = 0 
CODE39(0)\bar[2] = 0 
CODE39(0)\spe[2] = 1 
CODE39(0)\bar[3] = 1 
CODE39(0)\spe[3] = 0 
CODE39(0)\bar[4] = 1 
CODE39(0)\spe[4] = 0 
CODE39(0)\bar[5] = 0 
CODE39(0)\spe[5] = 0 

CODE39(1)\Char = "1" 
CODE39(1)\bar[1] = 1 
CODE39(1)\spe[1] = 0 
CODE39(1)\bar[2] = 0 
CODE39(1)\spe[2] = 1 
CODE39(1)\bar[3] = 0 
CODE39(1)\spe[3] = 0 
CODE39(1)\bar[4] = 0 
CODE39(1)\spe[4] = 0 
CODE39(1)\bar[5] = 1 
CODE39(1)\spe[5] = 0 

CODE39(2)\Char = "2" 
CODE39(2)\bar[1] = 0 
CODE39(2)\spe[1] = 0 
CODE39(2)\bar[2] = 1 
CODE39(2)\spe[2] = 1 
CODE39(2)\bar[3] = 0 
CODE39(2)\spe[3] = 0 
CODE39(2)\bar[4] = 0 
CODE39(2)\spe[4] = 0 
CODE39(2)\bar[5] = 1 
CODE39(2)\spe[5] = 0 

CODE39(3)\Char = "3" 
CODE39(3)\bar[1] = 1 
CODE39(3)\spe[1] = 0 
CODE39(3)\bar[2] = 1 
CODE39(3)\spe[2] = 1 
CODE39(3)\bar[3] = 0 
CODE39(3)\spe[3] = 0 
CODE39(3)\bar[4] = 0 
CODE39(3)\spe[4] = 0 
CODE39(3)\bar[5] = 0 
CODE39(3)\spe[5] = 0 

CODE39(4)\Char = "4" 
CODE39(4)\bar[1] = 0 
CODE39(4)\spe[1] = 0 
CODE39(4)\bar[2] = 0 
CODE39(4)\spe[2] = 1 
CODE39(4)\bar[3] = 1 
CODE39(4)\spe[3] = 0 
CODE39(4)\bar[4] = 0 
CODE39(4)\spe[4] = 0 
CODE39(4)\bar[5] = 1 
CODE39(4)\spe[5] = 0 

CODE39(5)\Char = "5" 
CODE39(5)\bar[1] = 1 
CODE39(5)\spe[1] = 0 
CODE39(5)\bar[2] = 0 
CODE39(5)\spe[2] = 1 
CODE39(5)\bar[3] = 1 
CODE39(5)\spe[3] = 0 
CODE39(5)\bar[4] = 0 
CODE39(5)\spe[4] = 0 
CODE39(5)\bar[5] = 0 
CODE39(5)\spe[5] = 0 

CODE39(6)\Char = "6" 
CODE39(6)\bar[1] = 0 
CODE39(6)\spe[1] = 0 
CODE39(6)\bar[2] = 1 
CODE39(6)\spe[2] = 1 
CODE39(6)\bar[3] = 1 
CODE39(6)\spe[3] = 0 
CODE39(6)\bar[4] = 0 
CODE39(6)\spe[4] = 0 
CODE39(6)\bar[5] = 0 
CODE39(6)\spe[5] = 0 

CODE39(7)\Char = "7" 
CODE39(7)\bar[1] = 0 
CODE39(7)\spe[1] = 0 
CODE39(7)\bar[2] = 0 
CODE39(7)\spe[2] = 1 
CODE39(7)\bar[3] = 0 
CODE39(7)\spe[3] = 0 
CODE39(7)\bar[4] = 1 
CODE39(7)\spe[4] = 0 
CODE39(7)\bar[5] = 1 
CODE39(7)\spe[5] = 0 

CODE39(8)\Char = "8" 
CODE39(8)\bar[1] = 1 
CODE39(8)\spe[1] = 0 
CODE39(8)\bar[2] = 0 
CODE39(8)\spe[2] = 1 
CODE39(8)\bar[3] = 0 
CODE39(8)\spe[3] = 0 
CODE39(8)\bar[4] = 1 
CODE39(8)\spe[4] = 0 
CODE39(8)\bar[5] = 0 
CODE39(8)\spe[5] = 0 
CODE39(9)\Char = "9" 
CODE39(9)\bar[1] = 0 
CODE39(9)\spe[1] = 0 
CODE39(9)\bar[2] = 1 
CODE39(9)\spe[2] = 1 
CODE39(9)\bar[3] = 0 
CODE39(9)\spe[3] = 0 
CODE39(9)\bar[4] = 1 
CODE39(9)\spe[4] = 0 
CODE39(9)\bar[5] = 0 
CODE39(9)\spe[5] = 0 

CODE39(10)\Char = "A" 
CODE39(10)\bar[1] = 1 
CODE39(10)\spe[1] = 0 
CODE39(10)\bar[2] = 0 
CODE39(10)\spe[2] = 0 
CODE39(10)\bar[3] = 0 
CODE39(10)\spe[3] = 1 
CODE39(10)\bar[4] = 0 
CODE39(10)\spe[4] = 0 
CODE39(10)\bar[5] = 1 
CODE39(10)\spe[5] = 0 

CODE39(11)\Char = "B" 
CODE39(11)\bar[1] = 0 
CODE39(11)\spe[1] = 0 
CODE39(11)\bar[2] = 1 
CODE39(11)\spe[2] = 0 
CODE39(11)\bar[3] = 0 
CODE39(11)\spe[3] = 1 
CODE39(11)\bar[4] = 0 
CODE39(11)\spe[4] = 0 
CODE39(11)\bar[5] = 1 
CODE39(11)\spe[5] = 0 

CODE39(12)\Char = "C" 
CODE39(12)\bar[1] = 1 
CODE39(12)\spe[1] = 0 
CODE39(12)\bar[2] = 1 
CODE39(12)\spe[2] = 0 
CODE39(12)\bar[3] = 0 
CODE39(12)\spe[3] = 1 
CODE39(12)\bar[4] = 0 
CODE39(12)\spe[4] = 0 
CODE39(12)\bar[5] = 0 
CODE39(12)\spe[5] = 0 

CODE39(13)\Char = "D" 
CODE39(13)\bar[1] = 0 
CODE39(13)\spe[1] = 0 
CODE39(13)\bar[2] = 0 
CODE39(13)\spe[2] = 0 
CODE39(13)\bar[3] = 1 
CODE39(13)\spe[3] = 1 
CODE39(13)\bar[4] = 0 
CODE39(13)\spe[4] = 0 
CODE39(13)\bar[5] = 1 
CODE39(13)\spe[5] = 0 

CODE39(14)\Char = "E" 
CODE39(14)\bar[1] = 1 
CODE39(14)\spe[1] = 0 
CODE39(14)\bar[2] = 0 
CODE39(14)\spe[2] = 0 
CODE39(14)\bar[3] = 1 
CODE39(14)\spe[3] = 1 
CODE39(14)\bar[4] = 0 
CODE39(14)\spe[4] = 0 
CODE39(14)\bar[5] = 0 
CODE39(14)\spe[5] = 0 

CODE39(15)\Char = "F" 
CODE39(15)\bar[1] = 0 
CODE39(15)\spe[1] = 0 
CODE39(15)\bar[2] = 1 
CODE39(15)\spe[2] = 0 
CODE39(15)\bar[3] = 1 
CODE39(15)\spe[3] = 1 
CODE39(15)\bar[4] = 0 
CODE39(15)\spe[4] = 0 
CODE39(15)\bar[5] = 0 
CODE39(15)\spe[5] = 0 

CODE39(16)\Char = "G" 
CODE39(16)\bar[1] = 0 
CODE39(16)\spe[1] = 0 
CODE39(16)\bar[2] = 0 
CODE39(16)\spe[2] = 0 
CODE39(16)\bar[3] = 0 
CODE39(16)\spe[3] = 1 
CODE39(16)\bar[4] = 1 
CODE39(16)\spe[4] = 0 
CODE39(16)\bar[5] = 1 
CODE39(16)\spe[5] = 0 

CODE39(17)\Char = "H" 
CODE39(17)\bar[1] = 1 
CODE39(17)\spe[1] = 0 
CODE39(17)\bar[2] = 0 
CODE39(17)\spe[2] = 0 
CODE39(17)\bar[3] = 0 
CODE39(17)\spe[3] = 1 
CODE39(17)\bar[4] = 1 
CODE39(17)\spe[4] = 0 
CODE39(17)\bar[5] = 0 
CODE39(17)\spe[5] = 0 

CODE39(18)\Char = "I" 
CODE39(18)\bar[1] = 0 
CODE39(18)\spe[1] = 0 
CODE39(18)\bar[2] = 1 
CODE39(18)\spe[2] = 0 
CODE39(18)\bar[3] = 0 
CODE39(18)\spe[3] = 1 
CODE39(18)\bar[4] = 1 
CODE39(18)\spe[4] = 0 
CODE39(18)\bar[5] = 0 
CODE39(18)\spe[5] = 0 

CODE39(19)\Char = "J" 
CODE39(19)\bar[1] = 0 
CODE39(19)\spe[1] = 0 
CODE39(19)\bar[2] = 0 
CODE39(19)\spe[2] = 0 
CODE39(19)\bar[3] = 1 
CODE39(19)\spe[3] = 1 
CODE39(19)\bar[4] = 1 
CODE39(19)\spe[4] = 0 
CODE39(19)\bar[5] = 0 
CODE39(19)\spe[5] = 0 

CODE39(20)\Char = "K" 
CODE39(20)\bar[1] = 1 
CODE39(20)\spe[1] = 0 
CODE39(20)\bar[2] = 0 
CODE39(20)\spe[2] = 0 
CODE39(20)\bar[3] = 0 
CODE39(20)\spe[3] = 0 
CODE39(20)\bar[4] = 0 
CODE39(20)\spe[4] = 1 
CODE39(20)\bar[5] = 1 
CODE39(20)\spe[5] = 0 

CODE39(21)\Char = "L" 
CODE39(21)\bar[1] = 0 
CODE39(21)\spe[1] = 0 
CODE39(21)\bar[2] = 1 
CODE39(21)\spe[2] = 0 
CODE39(21)\bar[3] = 0 
CODE39(21)\spe[3] = 0 
CODE39(21)\bar[4] = 0 
CODE39(21)\spe[4] = 1 
CODE39(21)\bar[5] = 1 
CODE39(21)\spe[5] = 0 

CODE39(22)\Char = "M" 
CODE39(22)\bar[1] = 1 
CODE39(22)\spe[1] = 0 
CODE39(22)\bar[2] = 1 
CODE39(22)\spe[2] = 0 
CODE39(22)\bar[3] = 0 
CODE39(22)\spe[3] = 0 
CODE39(22)\bar[4] = 0 
CODE39(22)\spe[4] = 1 
CODE39(22)\bar[5] = 0 
CODE39(22)\spe[5] = 0 

CODE39(23)\Char = "N" 
CODE39(23)\bar[1] = 0 
CODE39(23)\spe[1] = 0 
CODE39(23)\bar[2] = 0 
CODE39(23)\spe[2] = 0 
CODE39(23)\bar[3] = 1 
CODE39(23)\spe[3] = 0 
CODE39(23)\bar[4] = 0 
CODE39(23)\spe[4] = 1 
CODE39(23)\bar[5] = 1 
CODE39(23)\spe[5] = 0 

CODE39(24)\Char = "O" 
CODE39(24)\bar[1] = 1 
CODE39(24)\spe[1] = 0 
CODE39(24)\bar[2] = 0 
CODE39(24)\spe[2] = 0 
CODE39(24)\bar[3] = 1 
CODE39(24)\spe[3] = 0 
CODE39(24)\bar[4] = 0 
CODE39(24)\spe[4] = 1 
CODE39(24)\bar[5] = 0 
CODE39(24)\spe[5] = 0 

CODE39(25)\Char = "P" 
CODE39(25)\bar[1] = 0 
CODE39(25)\spe[1] = 0 
CODE39(25)\bar[2] = 1 
CODE39(25)\spe[2] = 0 
CODE39(25)\bar[3] = 1 
CODE39(25)\spe[3] = 0 
CODE39(25)\bar[4] = 0 
CODE39(25)\spe[4] = 1 
CODE39(25)\bar[5] = 0 
CODE39(25)\spe[5] = 0 

CODE39(26)\Char = "Q" 
CODE39(26)\bar[1] = 0 
CODE39(26)\spe[1] = 0 
CODE39(26)\bar[2] = 0 
CODE39(26)\spe[2] = 0 
CODE39(26)\bar[3] = 0 
CODE39(26)\spe[3] = 0 
CODE39(26)\bar[4] = 1 
CODE39(26)\spe[4] = 1 
CODE39(26)\bar[5] = 1 
CODE39(26)\spe[5] = 0 

CODE39(27)\Char = "R" 
CODE39(27)\bar[1] = 1 
CODE39(27)\spe[1] = 0 
CODE39(27)\bar[2] = 0 
CODE39(27)\spe[2] = 0 
CODE39(27)\bar[3] = 0 
CODE39(27)\spe[3] = 0 
CODE39(27)\bar[4] = 1 
CODE39(27)\spe[4] = 1 
CODE39(27)\bar[5] = 0 
CODE39(27)\spe[5] = 0 

CODE39(28)\Char = "S" 
CODE39(28)\bar[1] = 0 
CODE39(28)\spe[1] = 0 
CODE39(28)\bar[2] = 1 
CODE39(28)\spe[2] = 0 
CODE39(28)\bar[3] = 0 
CODE39(28)\spe[3] = 0 
CODE39(28)\bar[4] = 1 
CODE39(28)\spe[4] = 1 
CODE39(28)\bar[5] = 0 
CODE39(28)\spe[5] = 0 

CODE39(29)\Char = "T" 
CODE39(29)\bar[1] = 0 
CODE39(29)\spe[1] = 0 
CODE39(29)\bar[2] = 0 
CODE39(29)\spe[2] = 0 
CODE39(29)\bar[3] = 1 
CODE39(29)\spe[3] = 0 
CODE39(29)\bar[4] = 1 
CODE39(29)\spe[4] = 1 
CODE39(29)\bar[5] = 0 
CODE39(29)\spe[5] = 0 

CODE39(30)\Char = "U" 
CODE39(30)\bar[1] = 1 
CODE39(30)\spe[1] = 1 
CODE39(30)\bar[2] = 0 
CODE39(30)\spe[2] = 0 
CODE39(30)\bar[3] = 0 
CODE39(30)\spe[3] = 0 
CODE39(30)\bar[4] = 0 
CODE39(30)\spe[4] = 0 
CODE39(30)\bar[5] = 1 
CODE39(30)\spe[5] = 0 

CODE39(31)\Char = "V" 
CODE39(31)\bar[1] = 0 
CODE39(31)\spe[1] = 1 
CODE39(31)\bar[2] = 1 
CODE39(31)\spe[2] = 0 
CODE39(31)\bar[3] = 0 
CODE39(31)\spe[3] = 0 
CODE39(31)\bar[4] = 0 
CODE39(31)\spe[4] = 0 
CODE39(31)\bar[5] = 1 
CODE39(31)\spe[5] = 0 

CODE39(32)\Char = "W" 
CODE39(32)\bar[1] = 1 
CODE39(32)\spe[1] = 1 
CODE39(32)\bar[2] = 1 
CODE39(32)\spe[2] = 0 
CODE39(32)\bar[3] = 0 
CODE39(32)\spe[3] = 0 
CODE39(32)\bar[4] = 0 
CODE39(32)\spe[4] = 0 
CODE39(32)\bar[5] = 0 
CODE39(32)\spe[5] = 0 

CODE39(33)\Char = "X" 
CODE39(33)\bar[1] = 0 
CODE39(33)\spe[1] = 1 
CODE39(33)\bar[2] = 0 
CODE39(33)\spe[2] = 0 
CODE39(33)\bar[3] = 1 
CODE39(33)\spe[3] = 0 
CODE39(33)\bar[4] = 0 
CODE39(33)\spe[4] = 0 
CODE39(33)\bar[5] = 1 
CODE39(33)\spe[5] = 0 

CODE39(34)\Char = "Y" 
CODE39(34)\bar[1] = 1 
CODE39(34)\spe[1] = 1 
CODE39(34)\bar[2] = 0 
CODE39(34)\spe[2] = 0 
CODE39(34)\bar[3] = 1 
CODE39(34)\spe[3] = 0 
CODE39(34)\bar[4] = 0 
CODE39(34)\spe[4] = 0 
CODE39(34)\bar[5] = 0 
CODE39(34)\spe[5] = 0 

CODE39(35)\Char = "Z" 
CODE39(35)\bar[1] = 0 
CODE39(35)\spe[1] = 1 
CODE39(35)\bar[2] = 1 
CODE39(35)\spe[2] = 0 
CODE39(35)\bar[3] = 1 
CODE39(35)\spe[3] = 0 
CODE39(35)\bar[4] = 0 
CODE39(35)\spe[4] = 0 
CODE39(35)\bar[5] = 0 
CODE39(35)\spe[5] = 0 

CODE39(36)\Char = "-" 
CODE39(36)\bar[1] = 0 
CODE39(36)\spe[1] = 1 
CODE39(36)\bar[2] = 0 
CODE39(36)\spe[2] = 0 
CODE39(36)\bar[3] = 0 
CODE39(36)\spe[3] = 0 
CODE39(36)\bar[4] = 1 
CODE39(36)\spe[4] = 0 
CODE39(36)\bar[5] = 1 
CODE39(36)\spe[5] = 0 

CODE39(37)\Char = "." 
CODE39(37)\bar[1] = 1 
CODE39(37)\spe[1] = 1 
CODE39(37)\bar[2] = 0 
CODE39(37)\spe[2] = 0 
CODE39(37)\bar[3] = 0 
CODE39(37)\spe[3] = 0 
CODE39(37)\bar[4] = 1 
CODE39(37)\spe[4] = 0 
CODE39(37)\bar[5] = 0 
CODE39(37)\spe[5] = 0 

CODE39(38)\Char = " " 
CODE39(38)\bar[1] = 0 
CODE39(38)\spe[1] = 1 
CODE39(38)\bar[2] = 1 
CODE39(38)\spe[2] = 0 
CODE39(38)\bar[3] = 0 
CODE39(38)\spe[3] = 0 
CODE39(38)\bar[4] = 1 
CODE39(38)\spe[4] = 0 
CODE39(38)\bar[5] = 0 
CODE39(38)\spe[5] = 0 

CODE39(39)\Char = "$" 
CODE39(39)\bar[1] = 0 
CODE39(39)\spe[1] = 1 
CODE39(39)\bar[2] = 0 
CODE39(39)\spe[2] = 1 
CODE39(39)\bar[3] = 0 
CODE39(39)\spe[3] = 1 
CODE39(39)\bar[4] = 0 
CODE39(39)\spe[4] = 0 
CODE39(39)\bar[5] = 0 
CODE39(39)\spe[5] = 0 

CODE39(40)\Char = "/" 
CODE39(40)\bar[1] = 0 
CODE39(40)\spe[1] = 1 
CODE39(40)\bar[2] = 0 
CODE39(40)\spe[2] = 1 
CODE39(40)\bar[3] = 0 
CODE39(40)\spe[3] = 0 
CODE39(40)\bar[4] = 0 
CODE39(40)\spe[4] = 1 
CODE39(40)\bar[5] = 0 
CODE39(40)\spe[5] = 0 

CODE39(41)\Char = "+" 
CODE39(41)\bar[1] = 0 
CODE39(41)\spe[1] = 1 
CODE39(41)\bar[2] = 0 
CODE39(41)\spe[2] = 0 
CODE39(41)\bar[3] = 0 
CODE39(41)\spe[3] = 1 
CODE39(41)\bar[4] = 0 
CODE39(41)\spe[4] = 1 
CODE39(41)\bar[5] = 0 
CODE39(41)\spe[5] = 0 

CODE39(42)\Char = "%" 
CODE39(42)\bar[1] = 0 
CODE39(42)\spe[1] = 0 
CODE39(42)\bar[2] = 0 
CODE39(42)\spe[2] = 1 
CODE39(42)\bar[3] = 0 
CODE39(42)\spe[3] = 1 
CODE39(42)\bar[4] = 0 
CODE39(42)\spe[4] = 1 
CODE39(42)\bar[5] = 0 
CODE39(42)\spe[5] = 0 

CODE39(43)\Char = "*" 
CODE39(43)\bar[1] = 0 
CODE39(43)\spe[1] = 1 
CODE39(43)\bar[2] = 0 
CODE39(43)\spe[2] = 0 
CODE39(43)\bar[3] = 1 
CODE39(43)\spe[3] = 0 
CODE39(43)\bar[4] = 1 
CODE39(43)\spe[4] = 0 
CODE39(43)\bar[5] = 0 
CODE39(43)\spe[5] = 0 


Procedure AscTo39(c.s) 
    AscTo39 = -1 
    If c >= "0" And c <= "9" 
        AscTo39 = Val(c) 
    Else 
        c = UCase(c) 
        If c >= "A" And c <= "Z" 
            AscTo39 = Asc(c) - 55 
        Else 
            Select c 
            Case "-" 
                AscTo39 = 36 
            Case "." 
                AscTo39 = 37 
            Case " " 
                AscTo39 = 38 
            Case "*" 
                AscTo39 = 43 
            Case "$" 
                AscTo39 = 39 
            Case "/" 
                AscTo39 = 40 
            Case "+" 
                AscTo39 = 41 
            Case "%" 
                AscTo39 = 42 
            EndSelect 
        EndIf 
    EndIf 
    ProcedureReturn AscTo39 
EndProcedure 


Procedure PaintCodeBar39(h.l, wf.l, text.s, tf.b) 

    xpos = 0 ; To make an off set on both sides of the bar change the value 
    ypos = 0 ; To make an off set on both sides of the bar change the value 
    
    width=Len(text)*wf*16 + xpos ; 1 bar unit = 16 pixels * barwidth !! 
    height=h + ypos 
    
    If tf 
     height + 16 ; Make sure we have more space for the text 
    EndIf 
    
    CreateImage(0,width,height) 


    text = Trim(text) 

    StartDrawing(ImageOutput(0)) 
    
    Box(0,0,width,height,RGB(255,255,255)) 


    chrspace=(width-16)/Len(text) 

    
    For j = 1 To Len(text) 
        d.s = Mid(text, j, 1) 
        N39 = AscTo39(d) 
        
        For bs = 1 To 5 
            
            ;Bar 
            If CODE39(N39)\bar[bs] 
                w = 3 ;Wide 
            Else 
                w = 1 ;Narrow 
            EndIf 
            ;Draw line for bar 
            For i = 1 To w * wf 
                Line (xpos, ypos, 0, ypos + h,RGB(0,0,0)) 
                xpos  + 1 
            Next 
            
            ;Space 
            If CODE39(N39)\spe[bs] 
                xpos = xpos + 3 * wf ;Wide 
            Else 
                xpos = xpos + 1 * wf ;Narrow 
            EndIf 
        Next 
        
        ; Human Readable 
        
         If tf 
             DrawText(chrspace*(j-1)+chrspace, y + h, UCase(d)) 
         EndIf 

    Next 
        StopDrawing() 
SaveImage(0,"teste.bmp") 


EndProcedure 


; 
;Usage: 
;PaintCodeBar39(h.l, wf.l, text.s, tf.b) 
; 
;h.l= height of picture 
;wf.l= width of one bar 
;text.s= DUH 
;tf.b= 0/1 to print human readable code 


PaintCodeBar39(40,1,"*made by num3 - 2003*",1)

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
