; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7545&highlight=
; Author: Fred
; Date: 15. September 2003
; OS: Windows
; Demo: No

; 
; Recursive registry delete routine, to be compatible with all windows versions 
; (Deletes a registry key recursive, with all its childs...)

Procedure RegDeleteKeysRecursive(StartKey, pKeyName$) 

  Result = ~#ERROR_SUCCESS 
  
  If pKeyName$ 
  
    Result = RegOpenKeyEx_(StartKey, pKeyName$, 0, #KEY_ENUMERATE_SUB_KEYS | #DELETE, @Key ) 
    If Result = #ERROR_SUCCESS 
    
      SubKeyName$ = Space(512) 
    
      While Result = #ERROR_SUCCESS And Quit = 0 
        SubKeyLength = 512 
        Result = RegEnumKeyEx_(Key, SubKeyIndex, SubKeyName$, @SubKeyLength, 0, 0, 0, 0) 
        SubKeyIndex+1 
        
        If Result = #ERROR_NO_MORE_ITEMS 
          Result = RegDeleteKey_(StartKey, pKeyName$) 
          Quit = 1 
          
        ElseIf Result = #ERROR_SUCCESS 
                  
          SubKeyIndex-1 
          If RegDeleteKeysRecursive(Key, SubKeyName$) 
            Result = #ERROR_SUCCESS; 
          EndIf 
        EndIf 
      Wend 
      
      RegCloseKey_(Key) 
    EndIf 
  EndIf 
    
  If Result = #ERROR_SUCCESS 
    ProcedureReturn 1 
  Else 
    ProcedureReturn 0 
  EndIf 

EndProcedure 


; Test here... WARNING, it could be dangerous ! 
; 
RegDeleteKeysRecursive(#HKEY_CURRENT_USER, "Software\YourFavoriteSoftwareHere") 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
