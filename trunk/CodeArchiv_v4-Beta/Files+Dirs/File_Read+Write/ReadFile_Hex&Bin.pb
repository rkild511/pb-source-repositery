; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8664&highlight=
; Author: darklordz (updated for PB4.00 by blbltheworm)
; Date: 09. December 2003
; OS: Windows
; Demo: Yes


#File=0

; Read a File in Hex Code.....(Hex Edit Style....)
Procedure.s _ReadHEX(Filename.s) 
    If OpenFile(#File,Filename.s) 
        Repeat 
            CurPos.l = FileSeek(#File,Loc(#File)) 
            RetVal.s = RetVal.s+Hex(ReadByte(#File))+" " 
        Until Eof(0) 
        CloseFile(0) 
    EndIf 
    ProcedureReturn RetVal.s 
EndProcedure 

Debug _ReadHEX("c:\test2.bck") 


; Same for Unsigned Binary.. 
Procedure.s _ReadBIN(Filename.s) 
    If OpenFile(#File,Filename.s) 
        Repeat 
            CurPos.l = FileSeek(#File,Loc(#File)) 
            RetVal.s = RetVal.s+Str(ReadByte(#File))+" " 
        Until Eof(0) 
        CloseFile(0) 
    EndIf 
    ProcedureReturn RetVal.s 
EndProcedure 

Debug _ReadBIN("c:\test2.bck") 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
