; German forum: http://www.purebasic.fr/german/viewtopic.php?t=830
; Author: MVXA
; Date: 17. May 2006
; OS: Windows
; Demo: No

Procedure CPrint(sText.s, bHead.b = #True) 
    Protected *pKonsoleInfo.CONSOLE_SCREEN_BUFFER_INFO 
    Protected *pText.BYTE, lColor.l, lBGColor 
    
    If GetStdHandle_(#STD_OUTPUT_HANDLE) 
        *pKonsoleInfo = AllocateMemory(SizeOf(CONSOLE_SCREEN_BUFFER_INFO)) 
        If *pKonsoleInfo 
            GetConsoleScreenBufferInfo_(GetStdHandle_(#STD_OUTPUT_HANDLE), *pKonsoleInfo) 
            lBGColor = (*pKonsoleInfo\wAttributes >> 4)&$FF 
            
            FreeMemory(*pKonsoleInfo) 
        EndIf 
                    
        If bHead = #True: CPrint("^8> ", #False): ConsoleColor(7, lBGColor): EndIf 
        *pText = @sText 
        
        While *pText\b&$FF 
            Select *pText\b&$FF 
                Case '^': *pText + 1 
                    If (*pText\b&$FF => '0') And (*pText\b&$FF <= 'F') 
                        If *pText\b&$FF > 64: lColor = *pText\b&$FF - 55 
                        Else                : lColor = *pText\b&$FF - '0' 
                        EndIf 
                        
                        ConsoleColor(lColor, lBGColor) 
                        
                    Else 
                        *pText - 1: Print(Chr(*pText\b&$FF)) 
                    EndIf 
                    
                Case 3 
                    PrintN("") 
                    
                Default 
                    Print(Chr(*pText\b&$FF)) 
            EndSelect 
                  
            *pText + 1 
        Wend 
        
        ConsoleColor(7, lBGColor) 
        ProcedureReturn #True 
        
    Else 
        ProcedureReturn #False 
    EndIf 
EndProcedure 


OpenConsole() 

ConsoleColor(7, 3) 
CPrint("^9h^Aa^Bl^Cl^Do" + #ETX$) 

ConsoleColor(7, 6) 
CPrint("^9h^Aa^Bl^Cl^Do" + #ETX$) 

Input()
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP