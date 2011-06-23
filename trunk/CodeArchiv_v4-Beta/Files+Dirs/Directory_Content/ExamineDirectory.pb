; German forum:
; Author: Unknown  (updated for PB4.00 by blbltheworm)
; Date: 23. February 2003
; OS: Windows
; Demo: Yes

;C:\Test\a\b <- muss existieren sonst aua 
Verzeichnisname.s = "C:\Test" 
Repeat 
  Result.w = ExamineDirectory(0, Verzeichnisname.s, "*.*") 
  If Result.w <> 0    
    For Zaehler.w = 0 To 4 
      Result.w = NextDirectoryEntry(0)        
      If Result.w = 2 And Zaehler.w > 1 
        Verzeichnis.s = DirectoryEntryName(0) 
        Verzeichnisname.s = Verzeichnisname.s + "\" + Verzeichnis.s                        
        MessageRequester("Verzeichnisstammbaum", Verzeichnisname.s, #PB_MessageRequester_Ok)          
      EndIf      
    Next  
  EndIf 
Until Verzeichnisname.s = "C:\Test\a\b" 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -