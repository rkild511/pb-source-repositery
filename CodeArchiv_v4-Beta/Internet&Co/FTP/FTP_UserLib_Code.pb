; German forum: http://www.purebasic.fr/german/viewtopic.php?t=1354&highlight=
; Author: Num3 (posted by DarkDragon, updated for PB 4.00 by Andre)
; Date: 16. February 2005
; OS: Windows
; Demo: Yes
 

InitNetwork() 

Enumeration   ; set values to your own gadget numbers, when using in your program
  #PROGRESS_INFO 
  #PROGRESS
EndEnumeration


Global EOL.s 
EOL.s = Chr(13)+Chr(10) 

Procedure.s PassiveIP(Text.s) 
  s = FindString(Text, "(", 1)+1 
  l = FindString(Text, ")", s)-s 
  Host.s = Mid(Text, s, l) 
  IP.s = StringField(Host, 1, ",")+"."+StringField(Host, 2, ",")+"."+StringField(Host, 3, ",")+"."+StringField(Host, 4, ",") 
  ProcedureReturn IP.s 
EndProcedure 

Procedure.l PassivePort(Text.s) 
  s = FindString(Text, "(", 1)+1 
  l = FindString(Text, ")", s)-s 
  Host.s = Mid(Text, s, l) 
  Port = Val(StringField(Host, 5, ","))*256+Val(StringField(Host, 6, ",")) 
  ProcedureReturn Port 
EndProcedure 

Procedure.s Wait(ConnectionID, Timeout) 
  Delay(10) 
  *Buffer = AllocateMemory(60000) 
  t = ElapsedMilliseconds() 
  While NetworkClientEvent(ConnectionID) <> 2 And ElapsedMilliseconds()-t < Timeout : Delay(1) : Wend 
  If ElapsedMilliseconds()-t < Timeout 
  Size = ReceiveNetworkData(ConnectionID, *Buffer, 60000) 
  Text.s = PeekS(*Buffer) 
  FreeMemory(*Buffer) 
  SetGadgetText(#PROGRESS_INFO, Text) 
  ProcedureReturn Text 
  EndIf 
EndProcedure 

Procedure Wait2(ConnectionID, *Buffer, Size, Timeout) 
  Delay(50) 
  t = ElapsedMilliseconds() 
  While NetworkClientEvent(ConnectionID) = 0 And ElapsedMilliseconds()-t < Timeout : Delay(1) : Wend 
  If ElapsedMilliseconds()-t < Timeout 
  CurSize = ReceiveNetworkData(ConnectionID, *Buffer, Size) 
  While CurSize < Size 
    If NetworkClientEvent(ConnectionID) = 2 
    CurSize + ReceiveNetworkData(ConnectionID, *Buffer+CurSize, Size-CurSize) 
    EndIf 
  Wend 
  ProcedureReturn CurSize-1 
  EndIf 
EndProcedure 

Procedure SendNetworkString2(ConnectionID, String.s) 
  SetGadgetText(#PROGRESS_INFO, String.s) 
  SendNetworkString(ConnectionID, String.s) 
EndProcedure 

Procedure FTP_Connect(Server.s, Port, Name.s, Pass.s) 
  ConnectionID = OpenNetworkConnection(Server, Port) 
  If ConnectionID 
    Text.s = Wait(ConnectionID, 5000) 
    If Left(Text, 3) = "220" 
      SendNetworkString2(ConnectionID, "USER "+Name.s+EOL) 
      Text.s = Wait(ConnectionID, 5000) 
      If Left(Text, 3) = "331" 
        SendNetworkString2(ConnectionID, "PASS "+Pass.s+EOL) 
        Text.s = Wait(ConnectionID, 5000) 
        If Left(Text, 3) = "230" 
          SendNetworkString2(ConnectionID, "TYPE A"+EOL) 
          WAIT(ConnectionID, 5000) 
          ProcedureReturn ConnectionID 
        EndIf 
      EndIf 
    EndIf 
    CloseNetworkConnection(ConnectionID) 
  EndIf 
EndProcedure 

Procedure FTP_SetCurrentDirectory(ConnectionID, Path.s) 
  If ConnectionID 
    SendNetworkString2(ConnectionID, "CWD "+Path.s+EOL) 
    Text.s = Wait(ConnectionID, 5000) 
    If Left(Text, 3) = "250" 
      SendNetworkString2(ConnectionID, "PWD"+EOL) 
      Text.s = Wait(ConnectionID, 5000) 
      If Left(Text, 3) = "257" 
        ProcedureReturn 1 
      EndIf 
    EndIf 
  EndIf 
EndProcedure 

Procedure.s FTP_List(ConnectionID) 
  If ConnectionID 
    SendNetworkString2(ConnectionID, "TYPE A"+EOL) 
    Text.s = Wait(ConnectionID, 5000) 
    If Left(Text, 3) = "200" 
    SendNetworkString2(ConnectionID, "PASV"+EOL) 
    Text.s = Wait(ConnectionID, 5000) 
    If Left(Text, 3) = "227" 
      Passive = OpenNetworkConnection(PassiveIP(Text.s), PassivePort(Text.s)) 
      If Passive 
        SendNetworkString2(ConnectionID, "LIST"+EOL) 
        Text.s = Wait(ConnectionID, 5000) 
        If Left(Text, 3) = "150" 
          Text.s = Wait(ConnectionID, 5000) 
          Delay(10) 
          Result.s = Wait(Passive, 5000) 
          CloseNetworkConnection(Passive) 
          Text.s = Wait(ConnectionID, 5000) 
          ProcedureReturn Result 
        EndIf 
        CloseNetworkConnection(Passive) 
      Else 
      EndIf 
    EndIf 
    EndIf 
  EndIf 
EndProcedure 

Procedure.s FTP_NameList(ConnectionID) 
  If ConnectionID 
    SendNetworkString2(ConnectionID, "TYPE A"+EOL) 
    Text.s = Wait(ConnectionID, 5000) 
    If Left(Text, 3) = "200" 
    SendNetworkString2(ConnectionID, "PASV"+EOL) 
    Text.s = Wait(ConnectionID, 5000) 
    If Left(Text, 3) = "227" 
      Passive = OpenNetworkConnection(PassiveIP(Text.s), PassivePort(Text.s)) 
      If Passive 
        SendNetworkString2(ConnectionID, "NLST"+EOL) 
        Delay(100) 
        Text.s = Wait(ConnectionID, 5000) 
        If Left(Text, 3) = "150" 
          Text.s = Wait(ConnectionID, 5000) 
          Delay(100) 
          Result.s = Wait(Passive, 5000) 
          CloseNetworkConnection(Passive) 
          Text.s = Wait(ConnectionID, 5000) 
          ProcedureReturn Result 
        EndIf 
        CloseNetworkConnection(Passive) 
      EndIf 
    EndIf 
    EndIf 
  EndIf 
EndProcedure 

Procedure.l FTP_DownloadFile(ConnectionID, SFile.s, DFile.s) 
  If ConnectionID 
    SendNetworkString2(ConnectionID, "TYPE I"+EOL) 
    Text.s = Wait(ConnectionID, 5000) 
    If Left(Text, 3) = "200" 
    SendNetworkString2(ConnectionID, "PASV"+EOL) 
    Text.s = Wait(ConnectionID, 5000) 
    If Left(Text, 3) = "227" 
      Passive = OpenNetworkConnection(PassiveIP(Text.s), PassivePort(Text.s)) 
      If Passive 
        SendNetworkString2(ConnectionID, "RETR "+SFile+EOL) 
        Delay(100) 
        Text.s = Wait(ConnectionID, 5000) 
        s = FindString(Text, "(", 1)+1 
        l = FindString(Text, " ", s)-s 
        Size = Val(Mid(Text, s, l)) 
        If Left(Text, 3) = "150" 
          *Buffer = AllocateMemory(1024) 
          Text = "" 
          s = 0 
          If CreateFile(0, DFile) 
            While s < Size 
              Size2 = ReceiveNetworkData(Passive, *Buffer, 1024) 
              If Size2 > 0 
                s + Size2 
                WriteData(0, *Buffer, Size2) 
                SetGadgetState(#PROGRESS, Int((100/Size)*s)) 
                WindowEvent() 
              EndIf 
            Wend 
            CloseFile(0) 
          EndIf 
          FreeMemory(*Buffer) 
          CloseNetworkConnection(Passive) 
          Text.s = Wait(ConnectionID, 5000) 
          WindowEvent() 
          ProcedureReturn 1 
        EndIf 
        CloseNetworkConnection(Passive) 
      EndIf 
    EndIf 
    EndIf 
  EndIf 
EndProcedure 

Procedure.l FTP_UploadFile(ConnectionID, SFile.s, DFile.s) 
  If ConnectionID 
    SendNetworkString2(ConnectionID, "TYPE I"+EOL) 
    Text.s = Wait(ConnectionID, 5000) 
    If Left(Text, 3) = "200" 
    SendNetworkString2(ConnectionID, "PASV"+EOL) 
    Text.s = Wait(ConnectionID, 5000) 
    If Left(Text, 3) = "227" 
      Passive = OpenNetworkConnection(PassiveIP(Text.s), PassivePort(Text.s)) 
      If Passive 
        SendNetworkString2(ConnectionID, "STOR "+DFile+EOL) 
        Delay(100) 
        Text.s = Wait(ConnectionID, 5000) 
        If Left(Text, 3) = "150" 
          *Buffer = AllocateMemory(FileSize(SFile)) 
          SetGadgetState(#PROGRESS, 25) 
          WindowEvent() 
          If ReadFile(0, SFile) 
            ReadData(0, *Buffer, FileSize(SFile)) 
            CloseFile(0) 
            SetGadgetState(#PROGRESS, 50) 
            WindowEvent() 
          EndIf 
          SendNetworkData(Passive, *Buffer, FileSize(SFile)) 
          SetGadgetState(#PROGRESS, 75) 
          WindowEvent() 
          FreeMemory(*Buffer) 
          CloseNetworkConnection(Passive) 
          SetGadgetState(#PROGRESS, 100) 
          WindowEvent() 
          Text.s = Wait(ConnectionID, 5000) 
          WindowEvent() 
          ProcedureReturn 1 
        EndIf 
        CloseNetworkConnection(Passive) 
      EndIf 
    EndIf 
    EndIf 
  EndIf 
EndProcedure 

Procedure FTP_DeleteDirectory(ConnectionID, Dir.s) 
  If ConnectionID 
    SendNetworkString2(ConnectionID, "RMD "+Dir+EOL) 
    Text.s = Wait(ConnectionID, 5000) 
    If Left(Text, 3) = "250" 
      ProcedureReturn 1 
    EndIf 
  EndIf 
EndProcedure 

Procedure FTP_RenameFile(ConnectionID, FromName.s, ToName.s) 
  If ConnectionID 
    SendNetworkString2(ConnectionID, "RNFR "+FromName+EOL) 
    Text.s = Wait(ConnectionID, 5000) 
    If Left(Text, 3) = "350" 
      SendNetworkString2(ConnectionID, "RNTO "+ToName+EOL) 
      Text.s = Wait(ConnectionID, 5000) 
      If Left(Text, 3) = "250" 
        ProcedureReturn 1 
      EndIf 
    EndIf 
  EndIf 
EndProcedure 

Procedure FTP_DeleteFile(ConnectionID, File.s) 
  If ConnectionID 
    SendNetworkString2(ConnectionID, "DELE "+File+EOL) 
    Text.s = Wait(ConnectionID, 5000) 
    If Left(Text, 3) = "250" 
      ProcedureReturn 1 
    EndIf 
  EndIf 
EndProcedure 

Procedure FTP_CreateDirectory(ConnectionID, Dir.s) 
  If ConnectionID 
    SendNetworkString2(ConnectionID, "MKD "+Dir+EOL) 
    Text.s = Wait(ConnectionID, 5000) 
    If Left(Text, 3) = "257" 
      ProcedureReturn 1 
    EndIf 
  EndIf 
EndProcedure 

Procedure FTP_DirectoryUp(ConnectionID) 
  If ConnectionID 
    SendNetworkString2(ConnectionID, "CDUP"+EOL) 
    Text.s = Wait(ConnectionID, 5000) 
    If Left(Text, 3) = "250" 
      ProcedureReturn 1 
    EndIf 
  EndIf 
EndProcedure 

Procedure FTP_NoEvent(ConnectionID) 
  If ConnectionID 
    SendNetworkString2(ConnectionID, "NOOP"+EOL) 
    Text.s = Wait(ConnectionID, 5000) 
  EndIf 
EndProcedure 

Procedure FTP_Quit(ConnectionID) 
  If ConnectionID 
    SendNetworkString2(ConnectionID, "PASV"+EOL) 
    Text.s = Wait(ConnectionID, 5000) 
    If Left(Text, 3) = "221" 
      ProcedureReturn 1 
    EndIf 
  EndIf 
EndProcedure 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = ----
; EnableAsm
; EnableXP