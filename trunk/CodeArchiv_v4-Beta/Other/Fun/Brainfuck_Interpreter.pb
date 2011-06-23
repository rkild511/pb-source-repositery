; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1477&highlight=
; Author: Danilo
; Date: 24. June 2003
; OS: Windows
; Demo: Yes


; KnowHow Computer: http://www.wdrcc.de/khc.phtml 
; 
; Brainfuck: 
;   http://www.muppetlabs.com/~breadbox/bf/ 
;   http://esoteric.sange.fi/brainfuck/ 
;    
;> 
;>- 
;>--- 
;>--------------------------------------- 
;>--                                    - 
;>-- Brainfuck Interpreter BETA v0.1    - 
;>--                                    - 
;>--     by Danilo, 20.04.2003          - 
;>--                                    - 
;>--------------------------------------- 
;>--- 
;>- 
;> 
; 
; 
; 
;- BF Codes - Start 


;Program$ = ">+++++++++++++++++++++++++++++++++++." 
;Program$ = ">++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++.-------.+++++++++++..+++.>++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" 
;Program$ = ">+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++.>++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++.>+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++." 

;- Displays the ASCII character set, Jeffry Johnston 2001 
Program$ = ".+[.+]" 

;- Traditional "Hello you" programming example in BrainFuck 
;Program$ = ">+++++++++++[<++++++++>-]<-.>++++[<++++>-]<+.-------.>+++++[<++++>-]<-.[-]>++++++++[<++++>-]<.>+++++++++[<++++++++>-]<+.++++++++++.[-]>++++++++[<++++>-]<.>+++++++++++[<++++++++>-]<+.----------.++++++.---.[-]>++++++++[<++++>-]<.>+++++++++++++[<++++++>-]<.-------------.++++++++++++.--------.>++++++[<------>-]<--.[-]+++++++++++++.---.[-]+[>,-------------]>+++++++++[<++++++++>-]<.>+++++++[<++++>-]<+.+++++++..+++.[-]>++++++++[<++++>-]<.[-]<-[<-]>[++++++++++++++.>]++++++++++." 

;- Echos whatever is typed Until Alt 255 reached 
;Program$ = ",+[-.,+]" 

;- Hello World 
;Program$ = ">+++++++++[<++++++++>-]<.>+++++++[<++++>-]<+.+++++++..+++.[-]>++++++++[<++++>-]<.#>+++++++++++[<+++++>-]<.>++++++++[<+++>-]<.+++.------.--------.[-]>++++++++[<++++>-]<+.[-]++++++++++." 


;- BF Codes - End 
; 
; 
; 
;- Brainfuck Interpreter Start 

Mem = AllocateMemory(30000) 
Pointer  = 0 
*IP.BYTE = @Program$ 

OpenConsole() 

Repeat 
  x = (*IP\b & $FF) 
  Select x 
    Case '>' : Pointer + 1 : *IP + 1 
    Case '<' : Pointer - 1 : *IP + 1 
    Case '+' : 
      wert = PeekB(Mem+Pointer)&$FF 
      wert + 1 
      If wert = 256 : wert = 0 : EndIf 
      PokeB(Mem+Pointer,wert) 
      *IP + 1 
    Case '-' 
      wert = PeekB(Mem+Pointer)&$FF 
      wert - 1 
      If wert < 0 : wert = 255 : EndIf 
      PokeB(Mem+Pointer,wert) 
      *IP + 1 
    Case '.' : wert = PeekB(Mem+Pointer)&$FF : Print(Chr(wert))                 : *IP + 1 
    Case ',' : 
      x$ = "" 
      x$ = Inkey() 
      While x$ = "" 
        x$ = Inkey() 
      Wend 
      PokeB(Mem+Pointer,Asc(x$)&$FF) 
      *IP + 1 
    Case '[' : 
      FoundStack = 0 
      If PeekB(Mem+Pointer)&$FF = 0 
        *SEARCH.BYTE = *IP 
       NextTry: 
        x = (*SEARCH\b & $FF) 
        Repeat 
          *SEARCH + 1 
          x = (*SEARCH\b & $FF) 
        Until x = Asc("[") Or x = Asc("]") 

        If x = Asc("]") And FoundStack = 0 
          *IP = *SEARCH + 1 
        ElseIf x = Asc("]") And FoundStack > 0 
          FoundStack - 1 
          *SEARCH + 1 
          Goto NextTry 
        ElseIf x = Asc("[") 
          FoundStack + 1 
          *SEARCH + 1 
          Goto NextTry 
        Else 
          MessageRequester("ERROR"," Else im '[' !!",0) 
        EndIf 
      Else 
        *IP + 1 
      EndIf 
    Case ']' 
      FoundStack = 0 
      *SEARCH.BYTE = *IP 
     NextTry2: 
      Repeat 
        *SEARCH - 1 
        x = (*SEARCH\b & $FF) 
      Until x = Asc("[") Or x = Asc("]") 
      If x = Asc("[") And FoundStack = 0 
         *IP = *SEARCH 
      ElseIf x = Asc("[") And FoundStack > 0 
          FoundStack - 1 
          *SEARCH - 1 
          Goto NextTry2 
      ElseIf x = Asc("]") 
        FoundStack + 1 
        *SEARCH - 1 
        Goto NextTry2 
      Else 
        MessageRequester("ERROR"," Else im '[' !!",0) 
      EndIf 
    Default 
      *IP+1 
  EndSelect 
Until *IP => @Program$+Len(Program$) 

PrintN(""):PrintN(""):Print(">> PROGRAM HAS ENDED, press <Return> ") 
Input() 
;- Brainfuck Interpreter End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
