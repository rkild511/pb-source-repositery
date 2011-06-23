; English forum: 
; Author: PB
; Date: 06. September 2002
; OS: Windows
; Demo: No


; Note:
; This code was created when there was no native PureBasic command for this.
; Now you can simply use the PureBasic command 'IsFilename()'


; IsNameValid procedure by PB -- do what you want with it.
; Checks if a file or folder name contains a valid DOS name.
; Useful for when a user supplies a name for a file operation.
; Usage: r=IsNameValid(name$,msg)
; Returns 0 for invalid or 1 for valid.
; If msg=1 then an error message is shown (if invalid).
; 06. Sep 2002

Procedure IsNameValid(name$,msg)
  name$=GetFilePart(name$)
  r=r+FindString(name$,Chr(34),1)
  r=r+FindString(name$,"\",1)
  r=r+FindString(name$,"/",1)
  r=r+FindString(name$,":",1)
  r=r+FindString(name$,"*",1)
  r=r+FindString(name$,"?",1)
  r=r+FindString(name$,"<",1)
  r=r+FindString(name$,">",1)
  r=r+FindString(name$,"|",1)
  If r=0
    ok=1
  Else
    If msg=1
      a$=   "A name cannot contain any of the following characters:"+Chr(13)
      a$=a$+"                 \ / : * ? "+Chr(34)+" < > |"
      MessageBox_(0,a$,"Error",#MB_ICONERROR)
    EndIf
  EndIf
  ProcedureReturn ok
EndProcedure
;
Debug "C:\AutoExec.bat = "+Str(IsNameValid("C:\AutoExec.bat",0))
Debug "C:\AutoExec.ba* = "+Str(IsNameValid("C:\AutoExec.ba*",0))
Debug "C:\AutoExec.ba* = "+Str(IsNameValid("C:\AutoExec.ba*",1))
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -