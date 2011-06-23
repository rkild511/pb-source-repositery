; German forum: http://www.purebasic.fr/german/viewtopic.php?t=1256
; Author: GPI (updated for PB 4.00 by Andre)
; Date: 30. December 2004
; OS: Windows
; Demo: No


; Http-Dateien downloaden mit umfangreichen Zusatzfunktionen:
; * In eine Datei und in Speicher (Dateiname dann bitte "")
; * Nur einen Teil der Datei Downloaden (sofern von Server unterstützt).
; * Funktioniert auch bei unbekannter Dateigröße. (sowohl HTTP 1.0 als auch chunked für HTTP1.1)
; * Erkennen von Server-Disconnect.
; * Paßwortgeschützer bereich (nur BASE-Authorization. Mehr kann bsw. Opera auch nicht)
; * Über Proxy.
; * Eine Progressbar ist möglich
; * Abbruch während des downloads


;-Create and Read file with API 

;part of API_Filehandle
Structure API_FileHandle
  FHandle.l
  Buffer.l
  BufferLen.l
  ReadPos.l
  DataInBuffer.l
  readed.l
EndStructure

Procedure API_CloseFile(*File.API_FileHandle)
  If *File\FHandle<>#INVALID_HANDLE_VALUE
    CloseHandle_(*File\FHandle)
  EndIf
  If *File\Buffer
    FreeMemory(*File\Buffer):*File\Buffer=0
  EndIf
EndProcedure
Procedure API_FileCreate(*File.API_FileHandle,File$)
  *File\FHandle=CreateFile_(File$,#GENERIC_WRITE   ,0,0,#CREATE_ALWAYS   ,#FILE_ATTRIBUTE_NORMAL,0)
  If *File\FHandle=#INVALID_HANDLE_VALUE
    ProcedureReturn #False
  Else
    ProcedureReturn #True
  EndIf
EndProcedure
Procedure API_WriteData(*File.API_FileHandle,*Buffer,len)
  If WriteFile_(*File\FHandle,*Buffer,len,@written,0)
    ProcedureReturn written
  Else
    ProcedureReturn 0
  EndIf
EndProcedure

;Part of "new" math and string

Procedure HexVal(a$); - Convert a String in hexdecimal-format in numeric value
  a$=Trim(UCase(a$))
  If Asc(a$)='$'
    a$=Trim(Mid(a$,2,Len(a$)-1))
  EndIf
  Result=0
  *adr.BYTE=@a$
  For i=1 To Len(a$)
    Result<<4
    Select *adr\b
      Case '0'
      Case '1':Result+1
      Case '2':Result+2
      Case '3':Result+3
      Case '4':Result+4
      Case '5':Result+5
      Case '6':Result+6
      Case '7':Result+7
      Case '8':Result+8
      Case '9':Result+9
      Case 'A':Result+10
      Case 'B':Result+11
      Case 'C':Result+12
      Case 'D':Result+13
      Case 'E':Result+14
      Case 'F':Result+15
        Default:i=Len(a$)
    EndSelect
    *adr+1
  Next
  ProcedureReturn Result
EndProcedure

; HTTP

Structure HTTPGetId
  url$
  server$
  File$
  FileName$
  Port.l
  wenc$
  ProxyServer$
  ProxyPort.l
  penc$
  cookie$
  location$
  ConnectionID.l
  ErrorMessage$
  FileSize.l
  Date.l
  URLError.l
  Buffer.l
  BufferLength.l
  Realm$

  InHeader.l
  InChunk.l
  DoChunk.l
  ChunkRead.l

  FirstLine.l
  currentline$
  lastchar.l
  eol.l
  Received.l
  Typ$

  OutBuffer.l
  OutBufferLength.l

  StartPart.l
  EndPart.l

  HTTPVer.l

  FileHandle.API_FileHandle
  ; used for detect disconnect
  wc.WNDCLASS
  WindowName.s
  WindowHandle.l
  Disconnect.l
EndStructure
#URLError_OK=200
#URLError_CantCreateFile=1
#URLError_OutOfMemory=2
#URLError_CantGetPartial=3
#URLError_WrongPartialSize=4


;-URL-Commands
;{Day,Month
Global Dim wkday$(6)
Global Dim weekday$(6)
Global Dim Month$(12)
wkday$(1)="MON"
wkday$(2)="TUE"
wkday$(3)="WED"
wkday$(4)="THU"
wkday$(5)="FRI"
wkday$(6)="SAT"
wkday$(0)="SUN"
weekday$(1)="MONDAY"
weekday$(2)="TUESDAY"
weekday$(3)="WEDNESDAY"
weekday$(4)="THURSDAY"
weekday$(5)="FRIDAY"
weekday$(6)="SATURDAY"
weekday$(0)="SUNDAY"
Month$(1)="JAN"
Month$(2)="FEB"
Month$(3)="MAR"
Month$(4)="APR"
Month$(5)="MAY"
Month$(6)="JUN"
Month$(7)="JUL"
Month$(8)="AUG"
Month$(9)="SEP"
Month$(10)="OCT"
Month$(11)="NOV"
Month$(12)="DEC"
;}
Procedure.s HTTP_CreateDate(Date); - Create a HTTP-String of the date
  ProcedureReturn FormatDate(wkday$(DayOfWeek(Date))+" %dd "+Month$(Month(Date))+" %yyyy %hh:%ii:%ss GMT",Date)
EndProcedure
Procedure HTTP_AnalyseDate(TestTime$); - Convert the HTTP-String to date
  TestTime$=ReplaceString(Trim(UCase(TestTime$)),"  "," ")
  Day=0:Month$="":Year=0:Time$=""
  For i=0 To 6
    If Left(TestTime$,4)=wkday$(i)+","                        ;{"rfc1123-Date"
      Day=Val(StringField(TestTime$,2," "))
      Month$=StringField(TestTime$,3," ")
      Year=Val(StringField(TestTime$,4," "))
      Time$=StringField(TestTime$,5," ")
      Break
      ;}
    ElseIf Left(TestTime$,Len(weekday$(i))+1)=weekday$(i)+"," ;{"rfc850-Date"
      SubTime$=StringField(TestTime$,2," ")
      Day=Val(StringField(SubTime$,1,"-"))
      Month$=StringField(SubTime$,2,"-")
      Year=Val(StringField(SubTime$,3,"-"))
      If Year>80:Year+1900:Else:Year+2000:EndIf
      Time$=StringField(TestTime$,3," ")
      Break
      ;}
    ElseIf Left(TestTime$,4)=wkday$(i)+" "                    ;{"asctime-Date"
      Day=Val(StringField(TestTime$,3," "))
      Month$=StringField(TestTime$,2," ")
      Year=Val(StringField(TestTime$,5," "))
      Time$=StringField(TestTime$,4," ")
      Break
      ;}
    EndIf
  Next
  For i=1 To 12
    If Month$(i)=Month$ : Month=i:Break : EndIf
  Next
  Date=ParseDate("%hh:%ii:%ss",Time$)
  Hour=Hour(Date)
  Min=Minute(Date)
  Sec=Second(Date)
  ProcedureReturn Date(Year,Month,Day,Hour,Min,Sec)
EndProcedure
Procedure.s HTTP_CryptedUserPass(user$,pass$); - Create the authorization string
  If user$
    conc$=user$+":"+pass$
    OutputBuffer = AllocateMemory(Len(conc$)*2)
    Base64Encoder(@conc$,Len(conc$),OutputBuffer,Len(conc$)*2)
    penc$=PeekS(OutputBuffer)
    FreeMemory(OutputBuffer)
  Else
    penc$=""
  EndIf
  ProcedureReturn penc$
EndProcedure

Declare HTTP_ReConnect(*Handle.HTTPGetId)
Declare HTTP_ChangeURL(*Handle.HTTPGetId,url$)
Declare HTTP_CloseURL(*Handle.HTTPGetId)

;internal
Procedure.s HTTP_CreateRequestString(*Handle.HTTPGetId); - internal use
  If *Handle\ProxyServer$
    com$=UCase(*Handle\Typ$)+" "+*Handle\url$+" HTTP/1.1"+#CRLF$
  Else
    com$=UCase(*Handle\Typ$)+" "+*Handle\File$+" HTTP/1.1"+#CRLF$
  EndIf
  com$+"Host: "+*Handle\server$+#CRLF$
  com$+"Accept: */*"+#CRLF$

  com$+"User-Agent: PBGPIHTTPs"+#CRLF$
  If *Handle\ProxyServer$<>"" And *Handle\penc$
    com$+"Proxy-Authorization: Basic "+*Handle\penc$+#CRLF$
  EndIf
  If *Handle\wenc$<>""
    com$+"Authorization: Basic "+*Handle\wenc$+#CRLF$
  EndIf
  If *Handle\cookie$<>""
    com$+"Cookie: "+*Handle\cookie$+#CRLF$
  EndIf
  ; If *Handle\location$<>""
  ; com$+"Location: "+*Handle\location$+#CRLF$
  ; EndIf
  If *Handle\StartPart Or *Handle\EndPart
    com$+"Range: bytes="+Str(*Handle\StartPart)+"-"+Str(*Handle\EndPart)+#CRLF$
  EndIf
  ;com$+"Transfer-Encoding: chunked"+#crlf$
  ;com$+"Accept-Encoding: chunked"+#crlf$
  com$+#CRLF$
  ProcedureReturn com$
EndProcedure
Procedure HTTP_WindowCallback_(hwnd,msg,wParam,lParam); - internal use
  *Handle.HTTPGetId=GetWindowLong_(hwnd,#GWL_USERDATA)
  If *Handle
    If msg=#WM_LBUTTONDBLCLK
      *Handle\Disconnect=#True
      ProcedureReturn #False
    EndIf
  EndIf
  If msg=#WM_CLOSE Or msg=#WM_DESTROY
    UnregisterClass_(*Handle\WindowName,*Handle\wc\hInstance)
  EndIf
  ProcedureReturn DefWindowProc_(hwnd, msg, wParam, lParam)
EndProcedure
Procedure HTTP_NetworkConnect_(*Handle.HTTPGetId,ServerName.s,Port); - internal use
  Result=#False
  ConnectionID=OpenNetworkConnection(ServerName,Port)
  If ConnectionID

    *Handle\WindowName="httpGPI"+Str(ConnectionID)
    *Handle\wc\lpfnWndProc    =  @HTTP_WindowCallback_()
    *Handle\wc\hInstance      =  GetModuleHandle_(0)
    *Handle\wc\lpszClassName  =  @*Handle\WindowName
    If RegisterClass_(*Handle\wc)
      *Handle\WindowHandle=CreateWindowEx_(0,*Handle\WindowName,"",0,#CW_USEDEFAULT,0,#CW_USEDEFAULT,0,0,0,*Handle\wc\hInstance ,0)
      If *Handle\WindowHandle
        SetWindowLong_(*Handle\WindowHandle,#GWL_USERDATA,*Handle)
        *Handle\Disconnect=#False
        If WSAAsyncSelect_(ConnectionID, *Handle\WindowHandle, #WM_LBUTTONDBLCLK, #FD_CLOSE) = #SOCKET_ERROR ; If this happened we'll now know when an server unexpectedly die on us
          err.l = WSAGetLastError_() ; This line should be here even if we don't act on the result.
        EndIf
        Result=#True
      Else
        UnregisterClass_(*Handle\WindowName,*Handle\wc\hInstance)
      EndIf
    EndIf

    If Result=#False
      CloseNetworkConnection(ConnectionID)
      ConnectionID=#False
    EndIf
  EndIf
  ProcedureReturn ConnectionID
EndProcedure
Procedure HTTP_Disconnect_(*Handle.HTTPGetId,ConnectionID); - internal use
  CloseNetworkConnection(ConnectionID)
  DestroyWindow_(*Handle\WindowHandle)
EndProcedure
;Get Information
Procedure HTTP_IsHeaderReceived(*Handle.HTTPGetId); - Return is #true, when the header is complete received
  ProcedureReturn #True-*Handle\InHeader
EndProcedure
Procedure HTTP_GetProgress(*Handle.HTTPGetId); Header must be received! And the download size must be known.
  If *Handle\FileSize
    ProcedureReturn *Handle\Received*100/*Handle\FileSize
  EndIf
EndProcedure
Procedure HTTP_GetError(*Handle.HTTPGetId); Header must be received!
  ProcedureReturn *Handle\URLError
EndProcedure
Procedure.s HTTP_GetErrorMessage(*Handle.HTTPGetId); Header must be received!
  ProcedureReturn *Handle\ErrorMessage$
EndProcedure
Procedure.s HTTP_GetNewLocation(*Handle.HTTPGetId); Header must be received!
  ProcedureReturn *Handle\location$
EndProcedure
Procedure.s HTTP_GetAuthenticateRealm(*Handle.HTTPGetId); Header must be received!
  ProcedureReturn *Handle\Realm$
EndProcedure
Procedure HTTP_GetFileSize(*Handle.HTTPGetId); Header must be received! And the download size must be known.
  ProcedureReturn *Handle\FileSize
EndProcedure
Procedure HTTP_GetFileReceived(*Handle.HTTPGetId); Return the current (and when ready: final) size of the download
  ProcedureReturn *Handle\Received
EndProcedure
Procedure HTTP_GetFileDate(*Handle.HTTPGetId); Header must be received!
  ProcedureReturn *Handle\Date
EndProcedure
Procedure HTTP_GetOutBuffer(*Handle.HTTPGetId); File must be downloaded with localfile$="". Please free the memory with FreeMemory(outbuffer)
  ProcedureReturn *Handle\OutBuffer
EndProcedure

;Change Settings
Procedure HTTP_ChangeURL(*Handle.HTTPGetId,url$); Change only the URL (for 3xx-Errors)
  ;Port finden
  s_start=FindString(url$,":",7)
  s_end=FindString(url$,"/",s_start)
  If s_start And s_end
    port$=Mid(url$,s_start+1,s_end-(s_start+1))
  EndIf
  ;Servername finden
  For a=1 To Len(url$)
    s_start=FindString(url$,"//",1)
    s_end=FindString(url$,"/",s_start+2)
    server$=Mid(url$,s_start+2,s_end-(s_start+2))
    If port$<>""
      server$=ReplaceString(server$,":"+port$,"",1)
    EndIf
  Next
  ;standard-Name
  If Port=0: Port=80 :EndIf
  ;Dateiname
  File$=ReplaceString(url$,"http://"+server$,"",1)

  *Handle\url$=url$
  *Handle\Port=Port
  *Handle\server$=server$
  *Handle\File$=File$
EndProcedure
Procedure HTTP_ChangeWWWAuthenticate(*Handle.HTTPGetId,wenc$); Change WWWAuthenticate for 401-error
  *Handle\wenc$=wenc$
EndProcedure
Procedure HTTP_ChangeProxyAuthenticate(*Handle.HTTPGetId,penc$); Change ProxyAuthenticate for 407-error
  *Handle\penc$=penc$
EndProcedure
;Commands
Procedure HTTP_Connect_(*Handle.HTTPGetId,LocalFile$,url$,wenc$,StartPart,EndPart,ProxyServer$,ProxyPort,penc$,BufferLength,Typ$); internal
  If BufferLength<=0: BufferLength=10240 :EndIf

  HTTP_ChangeURL(*Handle.HTTPGetId,url$)

  If ProxyPort=0: ProxyPort=3196 :EndIf

  If *Handle\OutBuffer
    FreeMemory(*Handle\OutBuffer)
    *Handle\OutBuffer=0
  EndIf

  ;{ Infos speichern
  *Handle\FileName$=LocalFile$
  *Handle\wenc$=wenc$
  *Handle\ProxyServer$=ProxyServer$
  *Handle\ProxyPort=ProxyPort
  *Handle\penc$=penc$
  *Handle\cookie$=""
  *Handle\Buffer=0
  *Handle\BufferLength=BufferLength
  *Handle\Typ$=Typ$
  *Handle\StartPart=StartPart
  *Handle\EndPart=EndPart
  ;}

  ProcedureReturn HTTP_ReConnect(*Handle)
EndProcedure
Procedure HTTP_OpenURLPartial(*Handle.HTTPGetId,LocalFile$,url$,wenc$,StartPart,EndPart,ProxyServer$,ProxyPort,penc$,BufferLength); same as HTTP_OpenUrl(), but download only a part (not supported by all servers!)
  ProcedureReturn HTTP_Connect_(*Handle.HTTPGetId,LocalFile$,url$,wenc$,StartPart,EndPart,ProxyServer$,ProxyPort,penc$,BufferLength,"GET")
EndProcedure
Procedure HTTP_OpenUrl(*Handle.HTTPGetId,LocalFile$,url$,wenc$,ProxyServer$,ProxyPort,penc$,BufferLength);LocalFile$="" -> load in memory
  ProcedureReturn HTTP_Connect_(*Handle.HTTPGetId,LocalFile$,url$,wenc$,0,0,ProxyServer$,ProxyPort,penc$,BufferLength,"GET")
EndProcedure
Procedure HTTP_UrlInfo(*Handle.HTTPGetId,url$,wenc$,ProxyServer$,ProxyPort,penc$,BufferLength); read only the FileInformation (date and size)
  ProcedureReturn HTTP_Connect_(*Handle.HTTPGetId,"",url$,wenc$,0,0,ProxyServer$,ProxyPort,penc$,BufferLength,"HEAD")
EndProcedure
Procedure HTTP_ReConnect(*Handle.HTTPGetId); Usefull, when url is moved or authenticate is needed, reconnect
  HTTP_CloseURL(*Handle)
  If *Handle\OutBuffer
    FreeMemory(*Handle\OutBuffer)
    *Handle\OutBuffer=0
  EndIf
  *Handle\location$=""
  *Handle\FileSize=0
  *Handle\Date=0
  *Handle\ErrorMessage$=""
  *Handle\InHeader=#True
  *Handle\FirstLine=#True
  *Handle\currentline$=""
  *Handle\lastchar=0
  *Handle\eol=0
  *Handle\URLError=0
  *Handle\HTTPVer=0
  *Handle\Realm$=""
  *Handle\Received=0
  *Handle\InChunk=0
  *Handle\DoChunk=0
  If *Handle\ProxyServer$<>""
    *Handle\ConnectionID = HTTP_NetworkConnect_(*Handle,*Handle\ProxyServer$, *Handle\ProxyPort)
  Else
    *Handle\ConnectionID = HTTP_NetworkConnect_(*Handle,*Handle\server$, *Handle\Port)
  EndIf

  If *Handle\ConnectionID
    com$=HTTP_CreateRequestString(*Handle)
    SendNetworkData(*Handle\ConnectionID,@com$,Len(com$))
    ProcedureReturn #True
  Else
    ProcedureReturn #False
  EndIf
EndProcedure
Procedure HTTP_CloseURL(*Handle.HTTPGetId); finish/cancel download. little note: this don't earse file-info (HTTP_GET*) and outbuffer!
  If *Handle\ConnectionID
    HTTP_Disconnect_(*Handle,*Handle\ConnectionID)
    *Handle\ConnectionID=#False
  EndIf
  If *Handle\Buffer
    FreeMemory(*Handle\Buffer)
    *Handle\Buffer=0
  EndIf
  API_CloseFile(*Handle\FileHandle)
EndProcedure
Procedure HTTP_ReceiveData(*Handle.HTTPGetId) ; #True=Not ready  #False=AllDatasRecived/Disconnect
  Result=#True
  NCEvent = NetworkClientEvent(*Handle\ConnectionID)
  If PeekMessage_(m.MSG, *Handle\WindowHandle, 0, 0,#PM_REMOVE)
    TranslateMessage_(m)
    DispatchMessage_(m)
  EndIf

  If NCEvent=2 ; Raw-data
    If *Handle\Buffer=0
      *Handle\Buffer=AllocateMemory(*Handle\BufferLength)
      If *Handle\Buffer=0
        *Handle\URLError=#URLError_OutOfMemory
        ProcedureReturn #False
      EndIf
    EndIf
    InBuffer=ReceiveNetworkData(*Handle\ConnectionID,*Handle\Buffer,*Handle\BufferLength)
    *start.BYTE=*Handle\Buffer
    Repeat

      If *Handle\InHeader ;{ Header analysieren
        While InBuffer
          char=(*start\b & $FF):InBuffer-1:*start+1
          Select char
            Case #CR;: #crlf$
            Case #LF
              If *Handle\lastchar=#CR; Ende der Zeile entdeckt!
                If *Handle\eol; zum zweiten mal -> nun daten
                  *Handle\InHeader=#False
                  ;{-Header eingelesen ->Auswerten
                  If *Handle\URLError=200
                    If *Handle\StartPart<>0 Or *Handle\EndPart<>0
                      *Handle\URLError=#URLError_CantGetPartial
                      Result=#False
                      ;else ->Datei öffnen/Speicher reservieren
                    EndIf
                  ElseIf *Handle\URLError=206
                    If *Handle\FileSize=*Handle\EndPart-*Handle\StartPart+1
                      *Handle\URLError=200
                      ; ->Datei öffnen/Speicher reservieren
                    Else
                      *Handle\URLError=#URLError_WrongPartialSize
                      Result=#False
                    EndIf
                  Else
                    Result=#False
                  EndIf

                  ;Datei öffnen/Speicher reservieren
                  If *Handle\URLError=200
                    If ((*Handle\FileSize Or *Handle\DoChunk) Or (*Handle\HTTPVer=10 And *Handle\FileSize=0)) And *Handle\Typ$="GET"
                      If *Handle\DoChunk
                        *Handle\InChunk=1
                        *Handle\currentline$=""
                      EndIf
                      If *Handle\FileName$
                        ;{Datei
                        If API_FileCreate(*Handle\FileHandle,*Handle\FileName$)=#False
                          *Handle\URLError=#URLError_CantCreateFile
                          Result=#False
                        EndIf
                        ;}
                      Else
                        ;{Speicher
                        If *Handle\FileSize
                          *Handle\OutBufferLength=*Handle\FileSize
                        Else
                          *Handle\OutBufferLength=*Handle\Buffer*10
                        EndIf
                        *Handle\OutBuffer=AllocateMemory(*Handle\OutBufferLength)
                        If *Handle\OutBuffer=0
                          *Handle\URLError=#URLError_OutOfMemory
                          Result=#False
                        EndIf
                        ;}
                      EndIf
                    Else
                      Result=#False
                    EndIf
                  EndIf

                  ;*Handle\FileSize+1000000;------

                  ;}
                  Break
                Else
                  *Handle\eol=#True
                  If *Handle\FirstLine;{-Status-code auslesen
                    *Handle\FirstLine=#False
                    a1=FindString(*Handle\currentline$," ",0)
                    a2=FindString(*Handle\currentline$," ",a1+1):If a2=0:a2=Len(*Handle\currentline$)+1:EndIf
                    ;HTTP/1.0
                    *Handle\HTTPVer=Val(ReplaceString(Mid(*Handle\currentline$,a1-3,3),".",""))
                    *Handle\URLError=Val(Mid(*Handle\currentline$,a1+1,a2-a1-1))
                    *Handle\ErrorMessage$=Right(*Handle\currentline$,Len(*Handle\currentline$)-a2)
                    ;}
                    Else;{-Header-Zeile analysieren
                    a=FindString(*Handle\currentline$,":",1)
                    Variable$=Trim(Left(*Handle\currentline$,a-1))
                    Set$=Trim(Right(*Handle\currentline$,Len(*Handle\currentline$)-a))
                    Select UCase(Variable$)
                      Case "PROXY-AUTHENTICATE";{  Realm auslesen
                        a=FindString(Set$,"realm=",0)
                        b=FindString(Set$,#DQUOTE$,a+7)
                        If a And b
                          *Handle\Realm$=Mid(Set$,a+7,b-a-7)
                        EndIf
                        ;}
                      Case "WWW-AUTHENTICATE";{    Realm auslesen
                        a=FindString(Set$,"realm=",0)
                        b=FindString(Set$,#DQUOTE$,a+7)
                        If a And b
                          *Handle\Realm$=Mid(Set$,a+7,b-a-7)
                        EndIf
                        ;}
                      Case "LOCATION":            *Handle\location$=Set$
                      Case "SET-COOKIE";{          Cookie suchen
                        a=FindString(Set$,";",0):If a=0: a=Len(Set$)+1 :EndIf
                        *Handle\cookie$=Left(Set$,a-1)
                        ;}
                      Case "CONTENT-LENGTH":      *Handle\FileSize=Val(Set$)
                      Case "LAST-MODIFIED":       *Handle\Date=HTTP_AnalyseDate(Set$)
                      Case "TRANSFER-ENCODING";{   Chunked
                        If UCase(Set$)="CHUNKED"
                          *Handle\DoChunk=#True
                        EndIf
                        ;}
                    EndSelect
                    ;}
                  EndIf
                  *Handle\currentline$=""
                EndIf
              EndIf
            Default
              *Handle\eol=#False
              *Handle\currentline$+Chr(char)
          EndSelect
          *Handle\lastchar=char
        Wend
        ;}
      EndIf
      If *Handle\InChunk>0 And *Handle\InHeader=#False And InBuffer
        While InBuffer
          char=(*start\b & $FF):InBuffer-1:*start+1
          Select char
            Case #CR;: #crlf$
            Case #LF
              If *Handle\lastchar=#CR; Ende der Zeile entdeckt!
                *Handle\InChunk-1
                If *Handle\InChunk=0
                  a=FindString(*Handle\currentline$,";",0)
                  If a
                    *Handle\currentline$=Left(*Handle\currentline$,a-1)
                  EndIf
                  *Handle\ChunkRead=HexVal(Trim(*Handle\currentline$))
                  *Handle\FileSize+*Handle\ChunkRead

                  If *Handle\ChunkRead=0
                    InBuffer=0
                    If *Handle\FileName$
                      API_CloseFile(*Handle\FileHandle)
                    EndIf
                    Result=#False
                  EndIf
                  Break
                EndIf
                *Handle\currentline$=""
              EndIf
            Default
              *Handle\eol=#False
              *Handle\currentline$+Chr(char)
          EndSelect
          *Handle\lastchar=char
        Wend
      EndIf
      If *Handle\InChunk=0 And *Handle\InHeader=#False And InBuffer;{
        CopyData=InBuffer
        If *Handle\DoChunk
          If CopyData>*Handle\ChunkRead
            CopyData=*Handle\ChunkRead
          EndIf
          *Handle\ChunkRead-CopyData
          If *Handle\ChunkRead=0
            ;*Handle\ChunkRead=10000
            *Handle\InChunk=2
          EndIf
        EndIf
        InBuffer-CopyData
        If *Handle\FileName$
          *Handle\Received+CopyData
          API_WriteData(*Handle\FileHandle,*start,CopyData)
          *start+CopyData
          If *Handle\Received=*Handle\FileSize And *Handle\DoChunk=#False; And *Handle\HTTPVer=11
            Result=#False;fertig
            API_CloseFile(*Handle\FileHandle)
          EndIf
          ;}
        Else
          ;{Speicher
          need=*Handle\Received+CopyData
          If need>OutBufferLength
            If *Handle\FileSize>=need
              *Handle\OutBufferLength=*Handle\FileSize
            Else
              *Handle\OutBufferLength=need+*Handle\Buffer*10
            EndIf
            *Handle\OutBuffer=ReAllocateMemory(*Handle\OutBuffer,*Handle\OutBufferLength)
            If *Handle\OutBuffer=0
              Result=#False
              URLError=#URLError_OutOfMemory
            EndIf
          EndIf
          If *Handle\OutBuffer
            CopyMemory(*start,*Handle\OutBuffer+*Handle\Received,CopyData)
            *Handle\Received+CopyData
            *start+CopyData
            If *Handle\Received=*Handle\FileSize And *Handle\DoChunk=#False; And *Handle\HTTPVer=11
              Result=#False;fertig
            EndIf
          EndIf
          ;}
        EndIf


      EndIf
    Until InBuffer=0
  Else
    If *Handle\Disconnect
      If *Handle\FileName$
        API_CloseFile(*Handle\FileHandle)
      EndIf

      Result=#False
    EndIf
  EndIf

  ProcedureReturn Result
EndProcedure

CompilerIf #True
;- example

;url.s="http://shinji.chaosnet.org/phpinfo.php"
;url.s="http://shinji.chaosnet.org/phpinfo.php?=PHPE9568F35-D428-11d2-A769-00AA001ACF42"
;url.s="http://192.168.1.1/Crillion2/UniversalInternetUpdater.pack"
;url.s="http://192.168.1.1/"
url.s="http://www.purearea.net/index.htm" 
;url.s="http://www.sedtech.com/isedquickpdf/downloads/4.35/iSQP0435DLL.zip"
;url.s="http://gpihome.de/Crillion/English_asdfdafs_.txt"

;File$="C:\test.txt"
File$="c:\test.zip"

; ;Proxy required?
; ProxyServer$="192.168.1.1"
; ProxyPort=8080
; ProxyServer$="195.140.251.142"
; ProxyPort=8080
;ProxyPass$=CreateCryptedPass("user","pass")

; ;user and password required?
; WebPass$=CreateCryptedPass(user$,pass$)



If InitNetwork()

  OpenConsole()
  ; PrintN("***Getting file information***")
  ; If HTTP_UrlInfo(Info.HTTPGetId,url,WebPass$,ProxyServer$,ProxyPort,ProxyPass$,0)
  ; PrintN("connect...")
  ; While HTTP_ReceiveData(Info); wait for header
  ; Delay(100)
  ; Wend
  ; HTTP_CloseURL(Info)
  ; Select HTTP_GetError(Info)
  ; Case #URLError_OK
  ; PrintN("FileSize:"+Str(HTTP_GetFileSize(Info)))
  ; PrintN("FileDate:"+FormatDate("%dd.%mm.%yyyy %hh:%ii:%ss",HTTP_GetFileDate(Info)))
  ; Case #URLError_OutOfMemory:PrintN("Out of memory")
  ; Case #URLError_CantCreateFile:PrintN("Can't create file")
  ; ;for all other errors: See download
  ; Default
  ; PrintN(Str(HTTP_GetError(Info))+" "+HTTP_GetErrorMessage(Info))
  ; EndSelect
  ; EndIf


  PrintN("")
  PrintN("***Getting file***")
  If HTTP_OpenUrl(Get.HTTPGetId,File$,url,WebPass$,ProxyServer$,ProxyPort,ProxyPass$,0)
    Repeat
      PrintN("Connect...")
      ReTry=#False:Progress=0
      While HTTP_ReceiveData(Get)
        ;WindowEvent()
        a=HTTP_GetProgress(Get)
        If a<>Progress
          PrintN("Progress: "+Str(a)+"%")
          Progress=a
        EndIf
        ;if want abort
        ;  http_closeurl(get$)
        ;  printn("Abort")
        ;  break 2
        ;endif
        Delay(100)
      Wend
      HTTP_CloseURL(Get)

      Select HTTP_GetError(Get)
        Case #URLError_OK:PrintN("Download complete")
          ;{for memorydownload
          ; OutBuffer=HTTP_GetOutBuffer(Get)
          ; Size=HTTP_GetFileSize(Get)
          ; Print("save to "+File$+".mem."+GetExtensionPart(File$))
          ; API_FileCreate(out.API_FileHandle,File$+".mem."+GetExtensionPart(File$))
          ; API_WriteData(out,OutBuffer,Size)
          ; API_CloseFile(out)
          ; FreeMemory(outbuffer)
          ;}
          PrintN(" done")
        Case #URLError_OutOfMemory:PrintN("Out of memory")
        Case #URLError_CantCreateFile:PrintN("Can't create file")
        Case 301;Moved permanently
          PrintN("Moved permanently:"+HTTP_GetNewLocation(Get))
          HTTP_ChangeURL(Get,HTTP_GetNewLocation(Get))
          If HTTP_ReConnect(Get); neu anfordern
            ReTry=#True
          Else
            PrintN("Can't connect")
          EndIf
        Case 302;Moved temporarily
          PrintN("Moved temporarily:"+HTTP_GetNewLocation(Get))
          HTTP_ChangeURL(Get,HTTP_GetNewLocation(Get))
          If HTTP_ReConnect(Get); neu anfordern
            ReTry=#True
          Else
            PrintN("Can't connect")
          EndIf
        Case 305;Use Proxy
          PrintN("Use Proxy:"+HTTP_GetNewLocation(Get))
        Case 401;unauthorized
          PrintN("Unauthorized:"+HTTP_GetAuthenticateRealm(Get))
          Print("  UserName:"):user$=Input():PrintN("")
          Print("  Password:"):pass$=Input():PrintN("")
          If user$
            WebPass$=HTTP_CryptedUserPass(user$,pass$)
            HTTP_ChangeWWWAuthenticate(Get,WebPass$)
            If HTTP_ReConnect(Get); neu anfordern
              ReTry=#True
            Else
              PrintN("Can't connect")
            EndIf
          Else
            PrintN("  abort")
          EndIf
        Case 407;Proxy Authentication Required
          PrintN("Proxy Authentication Required:"+HTTP_GetAuthenticateRealm(Get))
          Print("  UserName:"):user$=Input():PrintN("")
          Print("  Password:"):pass$=Input():PrintN("")
          If user$
            ProxyPass$=HTTP_CryptedUserPass(user$,pass$)
            HTTP_ChangeProxyAuthenticate(Get,ProxyPass$)
            If HTTP_ReConnect(Get); neu anfordern
              ReTry=#True
            Else
              PrintN("Can't connect")
            EndIf
          Else
            PrintN("  abort")
          EndIf
        Default
          PrintN("ServerError:")
          PrintN(Str(HTTP_GetError(Get))+" "+HTTP_GetErrorMessage(Get))
      EndSelect
    Until ReTry=#False

    PrintN("")
    PrintN("FileSize:"+Str(HTTP_GetFileSize(Get)))
    PrintN("FileReceived:"+Str(Get\Received))
    PrintN("FileDate:"+FormatDate("%dd.%mm.%yyyy %hh:%ii:%ss",HTTP_GetFileDate(Get)))

  Else
    PrintN("Cann't connect")
  EndIf

  PrintN("")
  PrintN("Press any key")
  Input()
  CloseConsole()
EndIf

End
CompilerEndIf

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -------