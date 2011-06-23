; English forum: 
; Author: Berikco (updated for PB 4.00 by KeyPusher)
; Date: 22. September 2002 
; OS: Windows
; Demo: No


; Original code was reworked, so that it works with PB 4.0, but also download files which don't have
; a 'content-length' and possibly also no header.

; Original-Code wurde insoweit bearbeitet, dass es mit PB4.0 funktioniert, aber auch das Dateien 
; ge'download'ed werden können die kein 'content-length' und im extrem fall auch gar keinen header haben. 

; 
; HTTP file download 
; 09/22/2002 
; By Berikco 
; v1.1 
; 
Global filenaam$ 

; zum Beispiel: 
; http://mesh.dl.sourceforge.net/sourceforge/sevenzip/7z442.exe 
server$="mesh.dl.sourceforge.net" 
Port = 80 
url$="/sourceforge/sevenzip/" 
filenaam$="7z442.exe" 

If InitNetwork() = 0 
  MessageRequester("Error", "Can't initialize the network !", 0) 
  End 
EndIf 

#bufferlengte=10240 
Global Buffer 
Buffer = AllocateMemory(#bufferlengte) 
Global buf$ 
Global EOL$ 
EOL$ = Chr(13)+Chr(10) 

Global Size 
Global oldsize 
Global rate 
Global ratetel 
Global buf$ 
Global Header 
Global startReceive 
Global hwnd 
Global ConnectionID 
Global filesize 
Global timeout 
Global aniwin 
Global h 
Global einde 
; 
h=LoadLibrary_("Shell32.dll") 

Procedure incoming(result) 
  b.b=0 
  b$="" 
  rest=0 
  Select Header 
  Case 0 
    SendMessage_(aniwin,#ACM_OPEN,h,160) 
    i=0 
    
    Repeat 
      If PeekB(Buffer+i)=13 And PeekB(Buffer+i+1)=10 And PeekB(Buffer+i+2)=13 And PeekB(Buffer+i+3)=10 
        b$=Space(i+4) 
        CopyMemory(Buffer,@b$,i+4) 
        rest=i+4 
        Break 
      EndIf 
      i+1 
    Until i=result 
    If i=result 
        b$=EOL$ 
        startReceive=1 
    EndIf 
    ; 
    Repeat 
        ; 
        If Left(b$,2)=EOL$ 
            b$=Mid(b$,3,Len(b$)-3) 
            If startReceive=1 
                If CreateFile(1,filenaam$) 
                    WriteData(1,Buffer+rest, result-rest) 
                    Header=1 
                    Size=result-rest 
                    SetGadgetText(4,"Received "+Str(Size)+" of "+Str(filesize)+" bytes") 
                Else 
                    Header=2 
                EndIf      
                Break 
            EndIf 
        Else 
            search=FindString(b$, EOL$ , 1) 
            If search>0 
                l$=Left(b$,search-1) 
                b$=Mid(b$,search+2,Len(b$)) 
                pos=FindString(l$,"200 " , 1) 
                If pos 
                    startReceive=1  ; ok 
                Else 
                    pos=FindString(l$,"404 " , 1) 
                    If pos 
                        ;error 404 not founf 
                    Else 
                        pos=FindString(LCase(l$),"content-length:" , 1) 
                        If pos 
                            pos=FindString(l$," " , 1) 
                            filesize=Val(Mid(l$,pos+1,Len(l$))) 
                        EndIf 
                    EndIf 
                EndIf 
                Debug l$ 
            Else 
                l$="" 
                b$=EOL$ 
                search=1 
                startReceive=1 
            EndIf 
        EndIf ; 
    Until search=0 
  Case 1 
    timeout=0 
    WriteData(1,Buffer, result) 
    Size+result 
    If filesize 
        FileSize$=Str(filesize) 
        stap=100*Size/filesize 
    Else 
        FileSize$="??" 
        stap=0 
    EndIf 
    SetGadgetText(4,"Received "+Str(Size)+" of "+Str(filesize)+" bytes") 
    SetGadgetState(2, stap) 
    If filesize=Size 
      Debug "File Received" 
      Header=2 
      Debug Str(Size)+" of "+Str(filesize)+" bytes" 
    EndIf  
  Case 2 
    CloseFile(1) 
    CloseNetworkConnection(ConnectionID) 
    Debug "Connection Closed" 
    Header=3 
    DestroyWindow_(aniwin) 
    einde=1 
  EndSelect 
EndProcedure 
; 
Procedure MyWindowCallback(WindowID, message, wParam, lParam) 
  result = #PB_ProcessPureBasicEvents 
  Select WindowID 
  Case hwnd 
    Select message 
    Case #WM_TIMER 
      result=0 
      Select wParam 
      Case 1 ; timer 
        result=ReceiveNetworkData(ConnectionID, Buffer, #bufferlengte) 
        If result=0 
            filesize=Size 
        EndIf 
        incoming(result) 
      Case 2  ; timeout 
        timeout+1 
        If timeout>10 
          CloseFile(1) 
          Header=2 
          Debug "Timeout"      
        EndIf 
      Case 3 
        ratetel+500 
        If ratetel>0 
          rate=Size/ratetel 
        EndIf 
        SetGadgetText(3,"Download speed..."+Str(rate)+" KB/s.  Time "+Str(ratetel/1000)+" s.") 
      EndSelect 
    EndSelect 
  EndSelect 
  ProcedureReturn result 
EndProcedure 
; 
hwnd=OpenWindow(0,100,450,335,160,"Downloading "+filenaam$+" from "+server$,#PB_Window_SystemMenu) 
; 
If hwnd 
  If CreateGadgetList(WindowID(0)) 
    ButtonGadget(1, 250, 128,  72, 20, "Cancel") 
    ProgressBarGadget(2, 10, 100, 313, 20, 0, 100) 
    TextGadget(3, 20, 80,  280, 15, "") 
    TextGadget(4, 20, 65,  280, 15, "") 
    ; 
    aniwin=CreateWindowEx_(0,"SysAnimate32","",#ACS_AUTOPLAY|#ACS_CENTER|#ACS_TRANSPARENT|#WS_CHILD|#WS_VISIBLE|#WS_CLIPCHILDREN|#WS_CLIPSIBLINGS,25,10,280,50, hwnd,0,GetModuleHandle_(0),0) 
    ; 
    ConnectionID = OpenNetworkConnection(server$, Port) 
    ; 
    If ConnectionID 
      SendNetworkString(ConnectionID, "GET "+url$+filenaam$+" HTTP/1.0"+EOL$) 
      SendNetworkString(ConnectionID, "Host: "+server$+EOL$) 
      SendNetworkString(ConnectionID, "Accept: */*"+EOL$) 
      SendNetworkString(ConnectionID, EOL$) 
    ; 
    SetWindowCallback(@MyWindowCallback()) 
    ; -------------- timers ---------------- 
    SetTimer_(hwnd,1,20,0) ; 20 milisecond timer 
    SetTimer_(hwnd,2,1000,0) ; 1 sec timer 
    SetTimer_(hwnd,3,500,0) ; 500 msec timer    
    ; 
    Repeat 
      EventID=WaitWindowEvent() 
        Select EventGadget() 
        Case 1 
            Header=2 
        EndSelect 
    Until einde=1 
    EndIf 
  EndIf 
EndIf 
FreeLibrary_(h) 
Delay(4000) 
; 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -