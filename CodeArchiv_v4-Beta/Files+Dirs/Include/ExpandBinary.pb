; German forum: http://www.purebasicforums.com/german/archive/viewtopic.php?t=431
; Author: Rings (updated for PB4.00 by blbltheworm)
; Date: 08. April 2003
; OS: Windows
; Demo: Yes

;ExPandBinary (c) 2002 by Siegfried Rings (known as  'CodeGuru' ) 
;expand files which includes via IncludeBinary 

; Zu allem Überfluss (Als es das Catch-Commando noch nicht gab) habe ich mal mein ExpandBinary hier
; beigefügt. Anstatt das Bild kann man natürlich auch eine EXE nehmen und die dann starten. 


Procedure ExpandBinaryfile(Filename.s) 
  If CreateFile(1, Filename) ;Create File      
    ;Use File 1      
    L1= ?IB2-?IB1    ;get the size of it        
    WriteData(1,?IB1,L1) ;write it down to the file      
    CloseFile(1); Close Filepointer 
  EndIf 
  ProcedureReturn 
  IB1: 
  IncludeBinary "test.txt" ;The File To include with absolut path" 
  IB2: 
EndProcedure 

ExpandBinaryfile("test2.txt") 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -