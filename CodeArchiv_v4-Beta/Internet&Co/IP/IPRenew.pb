; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7338
; Author: Unknown (improved by oldefoxx, updated for PB4.00 by blbltheworm)
; Date: 26. August 2003
; OS: Windows
; Demo: Yes

;IPRenew 
;by Donald R. Darden 

;Creates a batch file and runs it to refresh IP 
;links and copy the results into a temporary file 
;that can then be processed:  C:\IP_Info.tmp. 

;Attempts to use RunProgram() and make these calls 
;directly worked, but the efforts to redirect the 
;output using ">" and ">>" to the c:\IP_Info.tmp 
;file were not as consistent as they should of been, 
;especially with the ARP command.  By creating and 
;running a batch file instead, these problems were 
;overcome.and good results obtained.  
Dim txt$(100) 
Dim ip$(100) 
Dim ofs.l(100) 
Global idx.l 

OpenConsole() 
ConsoleColor(15,1) 
ClearConsole() 
PrintN("Please wait a few moments while connections are refreshed...") 
CreateFile(1,"c:\IPRenew.bat") 
WriteStringN(1,"@echo off") 
WriteStringN(1,"arp -d") 
WriteStringN(1,"ipconfig /flushdns") 
WriteStringN(1,"ipconfig /release") 
WriteStringN(1,"ipconfig /renew") 
WriteStringN(1,"ipconfig .all") 
WriteStringN(1,"ipconfig /all > c:\IP_Info.tmp") 
WriteStringN(1,"arp -a >> c:\IP_Info.tmp") 
WriteStringN(1,"ping -a 127.0.0.1 >> c:\IP_Info.tmp") 
CloseFile(1) 
CloseConsole()
If RunProgram("c:\IPRenew.bat","","c:\",#PB_Program_Wait) 
  If ReadFile(1,"c:\IP_Info.tmp") 
    OpenConsole() 
    ConsoleColor(15,1) 
    ClearConsole() 
    bb$="" 
    While Eof(1)=0 
      a$=ReadString(1) 
      b$="" 
      a.l=FindString(a$,"Reply from",1) 
      If a 
        bb$=Mid(a$,a,Len(b$)-a) 
        a$=Left(a$,a-1) 
      EndIf 
      If Trim(a$)>"" 
        b.l=0 
        While b<Len(a$) 
          c.l=FindString(a$,Chr(9),b+1) 
          If c=0:c=Len(a$)+1:EndIf 
          b$=b$+Mid(a$,b+1,c-b-1)+" " 
          b=c 
        Wend 
        b$=RTrim(b$) 
        PrintN(b$) 
        a=0 
        Repeat 
          e.l=FindString(b$,".",a+1) 
          a=e 
          b.l=FindString(b$,".",a+1) 
          c.l=FindString(b$,".",b+1) 
          If c>a 
            If FindString(Mid(b$,a,c-a)," ",2) 
              Goto BadIP 
            EndIf 
            e=a-3 
            If e<1:e=1:EndIf 
            d.l=0 
            For b=e To c+3 
              c$=Mid(b$,b,1) 
              Select c$ 
              Case "" 
                Goto GoodIP 
              Case " " 
spaced:              
                If d>0 
                  If b>c:Goto GoodIP:EndIf 
                EndIf  
                d=-1 
              Case Chr(9) 
                Goto spaced 
              Case "0" 
                If d<1:d=b:EndIf 
              Case "1" 
                If d<1:d=b:EndIf 
              Case "2" 
                If d<1:d=b:EndIf 
              Case "3" 
                If d<1:d=b:EndIf 
              Case "4" 
                If d<1:d=b:EndIf 
              Case "5" 
                If d<1:d=b:EndIf 
              Case "6" 
                If d<1:d=b:EndIf 
              Case "7" 
                If d<1:d=b:EndIf 
              Case "8" 
                If d<1:d=b:EndIf 
              Case "9" 
                If d<1:d=b:EndIf 
              Case "." 
                If d=0:Goto BadIP:EndIf 
              Case "[" 
                Goto spaced 
              Case "]" 
                Goto spaced 
              Case "(" 
                Goto spaced 
              Case ")" 
                Goto spaced 
              Case Chr(34) 
                Goto spaced 
              Case "'" 
                Goto spaced 
              Default 
                If d:Goto BadIP:EndIf 
              EndSelect 
            Next 
          Else 
            Goto BadIP    
          EndIf 
GoodIP: 
          If d>0 
            idx=idx+1 
            txt$(idx)=b$ 
            ip$(idx)=Mid(b$,d,b-d) 
            ofs(idx)=d 
            a=FindString(b$,".",c+1)-1 
          EndIf 
BadIP: 
        Until a<=0          
      EndIf 
    Wend 
    CloseFile(1) 
    Print("Press any key To continue...") 
    Repeat:Until Inkey()>"" 
  EndIf 
EndIf 
DeleteFile("c:\IPRenew.bat") 
DeleteFile("c:\IP_Info.tmpt") 
ClearConsole() 
PrintN("Extracted IP Addresses:") 
For a=1 To idx 
  ConsoleLocate(1,a+1) 
  ConsoleColor(15,1) 
  Print(Left(txt$(a),ofs(a)-1)) 
  ConsoleLocate(ofs(a),a+1) 
  ConsoleColor(15,4) 
  Print(ip$(a)) 
  ConsoleLocate(ofs(a)+Len(ip$(a)),a+1) 
  ConsoleColor(15,1) 
  a$=Mid(txt$(a),ofs(a)+Len(ip$(a)),Len(txt$(a))) 
  PrintN(a$) 
Next 
PrintN("") 
Print("Press any key to end...") 
Repeat:Until Inkey()>"" 
CloseConsole() 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
