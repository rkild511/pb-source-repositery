; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8591&highlight=
; Author: Berikco (updated for PB3.93 by ts-soft, updated for PB4.00 by blbltheworm)
; Date: 04. December 2003
; OS: Windows
; Demo: No


; HTTP file download 
; 
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
Global filenaam$ 
filenaam$="download/PureBasic_Demo.exe" 
server$="www.purebasic.com" 
url$="http://www.purebasic.com/" 

;http://www.purebasic.com/download/PureBasic_Demo.exe
; 
Port = 80 
Global size 
Global oldsize 
Global rate 
Global ratetel 
Global buf$ 
Global header 
Global startReceive 
Global hWnd 
Global ConnectionID 
Global filesize 
Global timeout 
Global aniwin 
Global h 
Global einde 
h=LoadLibrary_("Shell32.dll") 
; 
Procedure incoming(Result) 
  b.b=0 
  b$="" 
  rest=0 
  Select header 
  Case 0 
    SendMessage_(aniwin,#ACM_OPEN,h,160) 
    i=0 
    Repeat 
      If PeekB(Buffer+i)=13 And PeekB(Buffer+i+1)=10 And PeekB(Buffer+i+2)=13 And PeekB(Buffer+i+3)=10 
        b$=Space(i+4) 
        CopyMemory(Buffer,@b$,i+4) 
        rest=i 
        i=result-1 
      EndIf 
      i+1 
    Until i=result 
    ; 
    Repeat 
    ; 
      If Left(b$,2)=EOL$ 
        If startReceive=1 
          b$=Mid(b$,3,Len(b$)-3) 
          If CreateFile(1,filenaam$) 
            WriteData(1,Buffer+rest+4, result-rest-4) 
            header=1 
            size=result-rest-4 
            SetGadgetText(4,"Received "+Str(size)+" of "+Str(filesize)+" bytes") 
          Else 
            header=2 
          EndIf      
        EndIf 
      Else 
        search=FindString(b$, EOL$ , 1) 
        If search>0 
          l$=Left(b$,search-1) 
          b$=Mid(b$,search+2,Len(b$)) 
          pos=FindString(l$,"200 " , 1) 
          If pos 
            startreceive=1  ; ok 
          Else 
            pos=FindString(l$,"404 " , 1) 
            If pos 
              ;error 404 not founf 
            Else 
              pos=FindString(l$,"Content-Length:" , 1) 
              If pos 
                pos=FindString(l$," " , 1) 
                filesize=Val(Mid(l$,pos+1,Len(l$))) 
              EndIf 
            EndIf 
          EndIf 
        Debug l$ 
      Else 
        l$="" 
      EndIf 
    EndIf ; 
  Until search=0 
  Case 1 
    timeout=0 
    WriteData(1,buffer, result) 
    size+result 
    SetGadgetText(4,"Received "+Str(size)+" of "+Str(filesize)+" bytes") 
    stap=100*size/filesize 
    SetGadgetState(2, stap) 
    If filesize=size 
      Debug "File Received" 
      header=2 
      Debug Str(size)+" of "+Str(filesize)+" bytes" 
      KillTimer_(hWnd,1) ; 20 milisecond timer 
      KillTimer_(hWnd,2) ; 1 sec timer 
      KillTimer_(hWnd,3) ; 500 msec timer    
      CloseFile(1) 
      CloseNetworkConnection(ConnectionID) 
      Debug "Connection Closed" 
      DestroyWindow_(AniWin) 
      einde=1 
    EndIf 
  EndSelect 
EndProcedure 
; 
Procedure MyWindowCallback(WindowID, Message, wParam, lParam) 
  Result = #PB_ProcessPureBasicEvents 
  Select WindowID 
  Case hwnd 
    Select message 
    Case #WM_TIMER 
      result=1 
      Select wparam 
      Case 1 ; timer 
        If NetworkClientEvent(ConnectionID) 
          result=ReceiveNetworkData(ConnectionID, buffer, #bufferlengte) 
          incoming(result) 
        EndIf 
      Case 2  ; timeout 
        timeout+1 
        If timeout>10 
          If IsFile(1)
            CloseFile(1) 
          EndIf
          header=2 
          Debug "Timeout"      
        EndIf 
      Case 3 
        ratetel+500 
        If ratetel>0 
          rate=size/ratetel 
        EndIf 
        SetGadgetText(3,"Download speed..."+Str(rate)+" KB/s.  Time "+Str(ratetel/1000)+" s.") 
      EndSelect 
    EndSelect 
  EndSelect 
  ProcedureReturn Result 
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
    AniWin=CreateWindowEx_(0,"SysAnimate32","",#ACS_AUTOPLAY|#ACS_CENTER|#ACS_TRANSPARENT|#WS_CHILD|#WS_VISIBLE|#WS_CLIPCHILDREN|#WS_CLIPSIBLINGS,25,10,280,50, hwnd,0,GetModuleHandle_(0),0) 
    ; 
    ConnectionID = OpenNetworkConnection(server$, Port) 
    ; 
    If ConnectionID 
      SendNetworkString(ConnectionID, "GET "+URL$+filenaam$+" HTTP/1.0"+eol$) 
      SendNetworkString(ConnectionID, eol$) 
    ; 
    SetWindowCallback(@MyWindowCallback()) 
    ; -------------- timers ---------------- 
    SetTimer_(hWnd,1,1,0) ; 1 milisecond timer 
    SetTimer_(hWnd,2,1000,0) ; 1 sec timer 
    SetTimer_(hWnd,3,500,0) ; 500 msec timer    
    ; 
    Repeat 
      EventID=WaitWindowEvent() 
      If EventID = #PB_Event_Gadget 
        Select EventGadget() 
        Case 1 
          header=2
              
        EndSelect 
      EndIf 
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
; EnableXP
