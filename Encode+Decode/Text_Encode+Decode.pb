; German forum: http://robsite.de/php/pureboard/viewtopic.php?t=2097&highlight=
; Author: Smash
; Date: 25. August 2003


;========= 
; @ Smash 
;========= 
; 
;        Hier steht tatsächlich ein brauchbarer Text. 
; 
;################################################################ 
Titel.s= "Tƒ–t Vƒs†ŠüssƒŠ“Œ…" 
info.s= "" 
info01.s = "Dƒ P“ƒBs‡ E‚‡t •“‚ƒ „ü ‚‡ƒ P“ƒBs‡ P…‹‹‡ƒs†ƒ ƒŒt•‡‰ƒŠt" 
info02.s = "“Œ‚ †t ”‡ƒŠƒ sƒ˜‡ƒŠŠƒ Fƒt“ƒs, ‚‡ƒ ƒ–t ‚„ü …ƒs†„„ƒŒ •“‚ƒŒ." 
info03.s = "E •‡‚ ‡‹‹ƒ ‹ä†t‡…ƒ •ƒ‚ƒŒ “Œ‚ „t…ƒs†‡ttƒŒƒs E‚‡t‡ƒƒŒ," 
info04.s = "•‡ƒ Wtƒ…äŒ˜“Œ… ƒt. “Œtƒstüt˜ƒŒ. E‡Œ V‡s“ƒŠŠƒ Dƒs‡…Œƒ ‡st €ƒƒ‡ts ”ƒ„ü…€." 
info05.s = "UŒ‚ ˆƒt˜t “† Œ† ƒ‡Œƒ Tƒ–t Vƒs†ŠüssƒŠ“Œ…." 

info.s= Chr(13)+Chr(10)+ info01 + Chr(13)+Chr(10) 
info.s= info.s + info02 + Chr(13)+Chr(10) 
info.s= info.s + info03 + Chr(13)+Chr(10) 
info.s= info.s + info04 + Chr(13)+Chr(10)+ Chr(13)+Chr(10) 
info.s= info.s + info05 + Chr(13)+Chr(10) 

;################################################################ 
;-entschluesseln 
Procedure.s Maximum(code.s) 
              von.w = 127 
              zu.w  = 97 
              String$ = code.s              
              For a = 0 To 25 
                If a = 18 ; schließe diese beiden Zeichen aus (´=145) (´=146) 
                  a = a+2 ; siehe  Tools `ASCII Table´ 
                EndIf      
                von$ = Chr(von.w+a) 
                zu$ = Chr(zu.w+a) 
                String$ = ReplaceString (String$,von$,zu$ ) 
              Next a 
              Result.s = String$ 
              ProcedureReturn Result 
EndProcedure 

info.s = Maximum(info.s) 
Titel.s = Maximum(Titel.s) 

;################################################################ 

               If OpenWindow(1, 153, 164, 430, 314,   #PB_Window_ScreenCentered | #PB_Window_TitleBar , Titel.s) 
                  If CreateGadgetList(WindowID()) 
                     StringGadget(50,  10, 10, 410, 250,"", #PB_String_Multiline|#WS_VSCROLL |#PB_String_ReadOnly) 
                     ButtonGadget(21, 340, 270, 80, 35, "OK") 
                     SetGadgetText(50,info) 
                 EndIf 
              EndIf 

;################################################################ 
Repeat 
    Select WindowEvent() 
; ------------------ 
      Case #PB_EventCloseWindow   ; ALT+F4 
            End          

      Case #PB_EventGadget 
        Select EventGadgetID() 
           Case 21 
              CloseWindow(1) 
              End 
        EndSelect 
; ------------------ 
    EndSelect 
Delay (3) 
ForEver 
;################################################################
; ExecutableFormat=Windows
; FirstLine=1
; EnableXP
; EOF