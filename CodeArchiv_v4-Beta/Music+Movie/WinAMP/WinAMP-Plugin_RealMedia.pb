; German forum: http://www.purebasic.fr/german/viewtopic.php?t=545&highlight=
; Author: Deeem2031 (updated for PB 4.00 by Andre)
; Date: 21. October 2004
; OS: Windows
; Demo: No
 

; PlugIn für Winamp, zum Abspielen von RealMedia-Dateien 
; ist noch nicht vollständig (Entpack-Routinen fehlen), aber Datei-Infos 
; können schon ausgelesen werden. 


; Winamp-InputPlugin by Deeém2031 

; Must be compiled as DLL !

#IN_VER = $100 
#OUT_VER = $10 

Structure Out_Module 
   Version.l ; module version (OUT_VER) 
   Description.s ; description of module, with version string 
   id.l ; module id. each input module gets its own. non-nullsoft modules should be >= 65536. 
  
   hMainWindow.l ; winamp's main window (filled in by winamp) 
   hDllInstance.l ; DLL instance handle (filled in by winamp) 
  
   Config.l ; configuration dialog 
   About.l ; about dialog 
  
   init.l ; called when loaded 
   quit.l ; called when unloaded 
  
   Open.l ; returns >=0 on success, <0 on failure 
  ; NOTENOTENOTE: bufferlenms And prebufferms are ignored in most If not all output plug-ins. 
  ; ... so don't expect the max latency returned to be what you asked for. 
  ; returns max latency in ms (0 For diskwriters, etc) 
  ; bufferlenms And prebufferms must be in ms. 0 To use defaults. 
  ; prebufferms must be <= bufferlenms 
  
  Close.l ; close the ol' output device. 
  
  Write.l ; 0 on success. len == bytes To write (<= 8192 always). buf is straight audio Data. 
  ; 1 returns not able To write (yet). Non-blocking, always. 
  
  CanWrite.l ; returns number of bytes possible to write at a given time. 
  ; Never will decrease unless you call write (Or Close, heh) 
  
  IsPlaying.l ; non0 if output is still going or if data in buffers waiting to be 
  ; written (i.e. closing While IsPlaying() returns 1 would truncate the song 
    
  pause.l ; returns previous pause state 
    
  setvolume.l ; volume is 0-255 
  setpan.l ; pan is -128 to 128 
    
  Flush.l ; flushes buffers and restarts output at time t (in ms) 
  ; (used For seeking) 
      
  getoutputtime.l ; returns played time in MS 
  GetWrittenTime.l ; returns time written in MS (used for synching up vis stuff) 
EndStructure 

Structure In_Module 
  Version.l ; #IN_VER 
  Description.s 
  
  hMainWindow.l 
  hDllInstance.l 
  
  FileExtensions.l 
  
  is_seekable.l 
  UseOutputPlug.l 
  
  Config.l ;Pointer zur Config-Proc 
  About.l 
  
  init.l 
  quit.l 
  getinfofile.l 
  infobox.l 
  isourfile.l 
  play.l 
  pause.l 
  unpause.l 
  ispaused.l 
  stop.l 
  
  getlength.l 
  getoutputtime.l 
  setoutputtime.l 
  
  setvolume.l 
  setpan.l 
  
  SAVSAInit.l 
   SAVSADeInit.l 
  
  SAAddPCMData.l 
  SAGetMode.l 
  SAAdd.l 
    
  VSAAddPCMData.l 
  VSAGetMode.l 
  VSAAdd.l 
      
  VSASetInfo.l 
      
  dsp_isactive.l 
  dsp_dosamples.l 
            
  EQSet.l 
            
  setinfo.l 
            
  outMod.Out_Module; filled in by winamp, optionally used :) 
  
EndStructure 

Structure eqData_struc 
  c.b[10] 
EndStructure 

Global mod.In_Module, paused, ReadBuffer 
Global FileID, MaxLatency 
Global RMFHeaderSize,RMFHeaderObjectVersion,RMFHeaderFileVersion,RMFHeaderNumHeaders 
Global MAXBitrate, AVGBitrate, duration, CurrentTitle.s 

Procedure BSwap(a.l) 
  !BSWAP Eax 
  ProcedureReturn 
EndProcedure 

Procedure BSWAPw(a.l) 
  !SHL Eax, 16 
  !BSWAP Eax 
  ProcedureReturn 
EndProcedure 

ProcedureCDLL config(hWndParent.l) 
  MessageBox_(hWndParent, "No configuration.", "Configuration",#MB_OK) 
EndProcedure 

ProcedureCDLL about(hWndParent.l) 
  MessageBox_(hWndParent,"RealMedia Player, by Deeém2031 (Dietmer Schölzel)","About RM Player",#MB_OK) 
EndProcedure 

ProcedureCDLL Init() 
  ProcedureReturn 0 
EndProcedure 

ProcedureCDLL quit() 
EndProcedure 

ProcedureCDLL.l isourfile(fn.s) 
  If LCase(GetExtensionPart(fn)) = "rm" Or LCase(GetExtensionPart(fn)) = "ra" Or LCase(GetExtensionPart(fn)) = "rma" 
    ProcedureReturn #True 
  Else 
    ProcedureReturn #False 
  EndIf 
EndProcedure 

ProcedureCDLL.l play(fn.s) 
  Protected rBuffer.l, HeaderObjVersion, HeaderBuff, HeaderBuffSize 
  
  ProcedureReturn 1 
  
  FileID = ReadFile(#PB_Any,fn) 
  If FileID = 0 
    ProcedureReturn 1 
  EndIf 
  
  
  ReadData(FileID, @rBuffer,4) 
  If PeekS(@rBuffer,4) <> ".RMF" 
    CloseFile(FileID) 
    ProcedureReturn 1 
  EndIf 
  
  RMFHeaderSize = BSwap(ReadLong(FileID)) 
  RMFHeaderObjectVersion = BSWAPw(ReadWord(FileID)) 
  If RMFHeaderObjectVersion = 0 
    RMFHeaderFileVersion = BSwap(ReadLong(FileID)) 
    RMFHeaderNumHeaders = BSwap(ReadLong(FileID)) 
  EndIf 
  
  Repeat 
    ReadData(FileID, @rBuffer,4) 
    If PeekS(@rBuffer,4) = "PROP" ;{ 
      ReadLong(FileID) 
      HeaderObjVersion = BSWAPw(ReadWord(FileID)) 
      If HeaderObjVersion = 0 
        MAXBitrate = BSwap(ReadLong(FileID)) 
        AVGBitrate = BSwap(ReadLong(FileID)) 
        ReadLong(FileID);msg + "MAX_Packet_Size: "+Str(BSwap(ReadLong()))+Chr(13)+Chr(10) 
        ReadLong(FileID);msg + "AVG_Packet_Size: "+Str(BSwap(ReadLong()))+Chr(13)+Chr(10) 
        ReadLong(FileID);msg + "NUM_Packets: "+Str(BSwap(ReadLong()))+Chr(13)+Chr(10) 
        duration = BSwap(ReadLong(FileID)) 
        ReadLong(FileID);msg + "Preroll: "+Str(BSwap(ReadLong()))+Chr(13)+Chr(10) 
        ReadLong(FileID);msg + "Index_Offset: "+Str(BSwap(ReadLong()))+Chr(13)+Chr(10) 
        ReadLong(FileID);msg + "Data_Offset: "+Str(BSwap(ReadLong()))+Chr(13)+Chr(10) 
        ReadWord(FileID);msg + "Num_Streams: "+Str(BSWAPw(ReadWord()))+Chr(13)+Chr(10) 
        ReadWord(FileID);msg + "Flags: "+Str(BSWAPw(ReadWord()))+Chr(13)+Chr(10) 
      EndIf ;} 
    ElseIf PeekS(@rBuffer,4) = "CONT" ;{ 
      ReadLong(FileID);msg + "CONTHeaderSize: "+Str(BSwap(ReadLong()))+Chr(13)+Chr(10) 
      HeaderObjVersion = BSWAPw(ReadWord(FileID)) 
      If HeaderObjVersion = 0 
        HeaderBuffSize = ReadByte(FileID) 
        If HeaderBuffSize 
          HeaderBuff = AllocateMemory(HeaderBuffSize) 
          ReadData(FileID, HeaderBuff,HeaderBuffSize) 
          CurrentTitle = PeekS(HeaderBuff,HeaderBuffSize) 
          FreeMemory(HeaderBuff) 
        Else 
          CurrentTitle = GetFilePart(fn) 
        EndIf 
        
        HeaderBuffSize = ReadByte(FileID) 
        HeaderBuff = AllocateMemory(HeaderBuffSize) 
        ReadData(FileID, HeaderBuff,HeaderBuffSize) 
        ;msg + "Author: "+PeekS(InfoHeaderBuff,InfoHeaderBuffSize)+Chr(13)+Chr(10) 
        FreeMemory(HeaderBuff) 
        
        HeaderBuffSize = ReadByte(FileID) 
        HeaderBuff = AllocateMemory(HeaderBuffSize) 
        ReadData(FileID, HeaderBuff,HeaderBuffSize) 
        ;msg + "Copyright: "+PeekS(InfoHeaderBuff,InfoHeaderBuffSize)+Chr(13)+Chr(10) 
        FreeMemory(HeaderBuff) 
        
        HeaderBuffSize = ReadByte(FileID) 
        HeaderBuff = AllocateMemory(HeaderBuffSize) 
        ReadData(FileID, HeaderBuff,HeaderBuffSize) 
        ;msg + "Comment: "+PeekS(InfoHeaderBuff,InfoHeaderBuffSize)+Chr(13)+Chr(10) 
        FreeMemory(HeaderBuff) 
      EndIf ;} 
    EndIf 
  Until Eof(FileID) 
  
  paused = 0 
  If mod\outMod\Open 
    ;CallCFunctionFast(mod\outMod\Open,) 
  EndIf 
  
  CloseFile(FileID); tmp 
  ProcedureReturn 0 
EndProcedure 

ProcedureCDLL pause() 
  paused = #True 
  If mod\outMod\pause 
    CallCFunctionFast(mod\outMod\pause,#True) 
  EndIf 
EndProcedure 

ProcedureCDLL unpause() 
  paused = #False 
  If mod\outMod\pause 
    CallCFunctionFast(mod\outMod\pause,#False) 
  EndIf 
EndProcedure 

ProcedureCDLL.l ispaused() 
  ProcedureReturn paused 
EndProcedure 

ProcedureCDLL stop() 
  ;- 
EndProcedure 

ProcedureCDLL.l getlength() 
  ProcedureReturn duration 
EndProcedure 

ProcedureCDLL.l getoutputtime() 
  If mod\outMod\getoutputtime 
    ProcedureReturn CallCFunctionFast(mod\outMod\getoutputtime) 
  EndIf 
EndProcedure 

ProcedureCDLL setoutputtime(time_in_ms.l) 
EndProcedure 

ProcedureCDLL setvolume(volume.l) 
  If mod\outMod\setvolume 
    CallCFunctionFast(mod\outMod\setvolume,volume) 
  EndIf 
EndProcedure 

ProcedureCDLL setpan(pan.l) 
  If mod\outMod\setpan 
    CallCFunctionFast(mod\outMod\setpan,pan) 
  EndIf 
EndProcedure 

ProcedureCDLL infoDlg(fn.s, hwnd) 
  Protected InfoFileID.l, rBuffer.l, msg.s 
  Protected InfoHeaderObjVersion, InfoHeaderStreamNameSize.l, InfoHeaderStreamName, InfoHeaderMimeType, InfoHeaderMimeTypeSize, InfoHeaderType, InfoHeaderTypeSize 
  Protected InfoHeaderBuff, InfoHeaderBuffSize, ChunkSize 

  InfoFileID = ReadFile(#PB_Any,fn) 
  If InfoFileID = 0 
    ProcedureReturn 
  EndIf 
  
  ReadData(InfoFileID, @rBuffer,4) 
  If PeekS(@rBuffer,4) <> ".RMF" 
    CloseFile(InfoFileID) 
    MessageBox_(hwnd,"None RM-File!","Info "+Chr(34)+GetFilePart(fn)+Chr(34),#MB_OK) 
    ProcedureReturn 
  EndIf 
  
  msg + "MAINHeaderSize: "+Str(BSwap(ReadLong(InfoFileID)))+Chr(13)+Chr(10) 
  InfoHeaderObjVersion = BSWAPw(ReadWord(InfoFileID)) 
  msg + "MAINHeaderObjectVersion: "+Str(InfoHeaderObjVersion)+Chr(13)+Chr(10) 
  If InfoHeaderObjVersion = 0 
    msg + "FileVersion: "+Str(BSwap(ReadLong(InfoFileID)))+Chr(13)+Chr(10) 
    msg + "NumHeaders: "+Str(BSwap(ReadLong(InfoFileID)))+Chr(13)+Chr(10) 
  EndIf 
  
  Repeat 
    ReadData(InfoFileID, @rBuffer,4) 
    If PeekS(@rBuffer,4) = "PROP" ;{ 
      msg + Chr(13)+Chr(10) 
      msg + "PROPHeaderSize: "+Str(BSWAP(ReadLong(InfoFileID)))+Chr(13)+Chr(10) 
      InfoHeaderObjVersion = BSWAPw(ReadWord(InfoFileID)) 
      msg + "PROPHeaderObjectVersion: "+Str(InfoHeaderObjVersion)+Chr(13)+Chr(10) 
      If InfoHeaderObjVersion = 0 
        msg + "MAX_Bitrate: "+Str(BSWAP(ReadLong(InfoFileID)))+Chr(13)+Chr(10) 
        msg + "AVG_Bitrate: "+Str(BSWAP(ReadLong(InfoFileID)))+Chr(13)+Chr(10) 
        msg + "MAX_Packet_Size: "+Str(BSWAP(ReadLong(InfoFileID)))+Chr(13)+Chr(10) 
        msg + "AVG_Packet_Size: "+Str(BSWAP(ReadLong(InfoFileID)))+Chr(13)+Chr(10) 
        msg + "NUM_Packets: "+Str(BSWAP(ReadLong(InfoFileID)))+Chr(13)+Chr(10) 
        msg + "Duration: "+Str(BSWAP(ReadLong(InfoFileID)))+Chr(13)+Chr(10) 
        msg + "Preroll: "+Str(BSWAP(ReadLong(InfoFileID)))+Chr(13)+Chr(10) 
        msg + "Index_Offset: "+Str(BSWAP(ReadLong(InfoFileID)))+Chr(13)+Chr(10) 
        msg + "Data_Offset: "+Str(BSWAP(ReadLong(InfoFileID)))+Chr(13)+Chr(10) 
        msg + "Num_Streams: "+Str(BSWAPw(ReadWord(InfoFileID)))+Chr(13)+Chr(10) 
        msg + "Flags: "+Str(BSWAPw(ReadWord(InfoFileID)))+Chr(13)+Chr(10) 
      EndIf ;} 
    ElseIf PeekS(@rBuffer,4) = "MDPR" ;{ 
      msg + Chr(13)+Chr(10) 
      msg + "MDRPHeaderSize: "+Str(BSwap(ReadLong(InfoFileID)))+Chr(13)+Chr(10) 
      InfoHeaderObjVersion = BSWAPw(ReadWord(InfoFileID)) 
      msg + "MDRPHeaderObjectVersion: "+Str(InfoHeaderObjVersion)+Chr(13)+Chr(10) 
      If InfoHeaderObjVersion = 0 
        msg + "Streamnumber: "+Str(BSWAPw(ReadWord(InfoFileID)))+Chr(13)+Chr(10) 
        msg + "MAX_Bitrate: "+Str(BSwap(ReadLong(InfoFileID)))+Chr(13)+Chr(10) 
        msg + "AVG_Bitrate: "+Str(BSwap(ReadLong(InfoFileID)))+Chr(13)+Chr(10) 
        msg + "MAX_Packet_Size: "+Str(BSwap(ReadLong(InfoFileID)))+Chr(13)+Chr(10) 
        msg + "AVG_Packet_Size: "+Str(BSwap(ReadLong(InfoFileID)))+Chr(13)+Chr(10) 
        msg + "StartTime: "+Str(BSwap(ReadLong(InfoFileID)))+Chr(13)+Chr(10) 
        msg + "Preroll: "+Str(BSwap(ReadLong(InfoFileID)))+Chr(13)+Chr(10) 
        msg + "Duration: "+Str(BSwap(ReadLong(InfoFileID)))+Chr(13)+Chr(10) 
        InfoHeaderStreamNameSize = ReadByte(InfoFileID) 
        InfoHeaderStreamName = AllocateMemory(InfoHeaderStreamNameSize) 
        ReadData(InfoFileID, InfoHeaderStreamName,InfoHeaderStreamNameSize) 
        msg + "StreamName: "+PeekS(InfoHeaderStreamName,InfoHeaderStreamNameSize)+Chr(13)+Chr(10) 
        FreeMemory(InfoHeaderStreamName) 
        InfoHeaderMimeTypeSize = ReadByte(InfoFileID) 
        InfoHeaderMimeType = AllocateMemory(InfoHeaderMimeTypeSize) 
        ReadData(InfoFileID, InfoHeaderMimeType,InfoHeaderMimeTypeSize) 
        msg + "MimeType: "+PeekS(InfoHeaderMimeType,InfoHeaderMimeTypeSize)+Chr(13)+Chr(10) 
        FreeMemory(InfoHeaderMimeType) 
        InfoHeaderTypeSize = BSwap(ReadLong(InfoFileID)) 
        If InfoHeaderTypeSize 
          InfoHeaderType = AllocateMemory(InfoHeaderTypeSize) 
          ReadData(InfoFileID, InfoHeaderType,InfoHeaderTypeSize) 
          msg + "TypeData: "+PeekS(InfoHeaderType,InfoHeaderTypeSize)+Chr(13)+Chr(10) 
          FreeMemory(InfoHeaderType) 
        EndIf 
      EndIf ;} 
    ElseIf PeekS(@rBuffer,4) = "CONT" ;{ 
      msg + Chr(13)+Chr(10) 
      msg + "CONTHeaderSize: "+Str(BSWAP(ReadLong(InfoFileID)))+Chr(13)+Chr(10) 
      InfoHeaderObjVersion = BSWAPw(ReadWord(InfoFileID)) 
      msg + "CONTHeaderObjectVersion: "+Str(InfoHeaderObjVersion)+Chr(13)+Chr(10) 
      If InfoHeaderObjVersion = 0 
        InfoHeaderBuffSize = ReadByte(InfoFileID) 
        InfoHeaderBuff = AllocateMemory(InfoHeaderBuffSize) 
        ReadData(InfoFileID, InfoHeaderBuff,InfoHeaderBuffSize) 
        msg + "Title: "+PeekS(InfoHeaderBuff,InfoHeaderBuffSize)+Chr(13)+Chr(10) 
        FreeMemory(InfoHeaderBuff) 
        
        InfoHeaderBuffSize = ReadByte(InfoFileID) 
        InfoHeaderBuff = AllocateMemory(InfoHeaderBuffSize) 
        ReadData(InfoFileID, InfoHeaderBuff,InfoHeaderBuffSize) 
        msg + "Author: "+PeekS(InfoHeaderBuff,InfoHeaderBuffSize)+Chr(13)+Chr(10) 
        FreeMemory(InfoHeaderBuff) 
        
        InfoHeaderBuffSize = ReadByte(InfoFileID) 
        InfoHeaderBuff = AllocateMemory(InfoHeaderBuffSize) 
        ReadData(InfoFileID, InfoHeaderBuff,InfoHeaderBuffSize) 
        msg + "Copyright: "+PeekS(InfoHeaderBuff,InfoHeaderBuffSize)+Chr(13)+Chr(10) 
        FreeMemory(InfoHeaderBuff) 
        
        InfoHeaderBuffSize = ReadByte(InfoFileID) 
        InfoHeaderBuff = AllocateMemory(InfoHeaderBuffSize) 
        ReadData(InfoFileID, InfoHeaderBuff,InfoHeaderBuffSize) 
        msg + "Comment: "+PeekS(InfoHeaderBuff,InfoHeaderBuffSize)+Chr(13)+Chr(10) 
        FreeMemory(InfoHeaderBuff) 
      EndIf ;} 
    ElseIf PeekS(@rBuffer,4) = "DATA" ;{ 
      msg + Chr(13)+Chr(10) 
      ChunkSize = BSwap(ReadLong(InfoFileID)) 
      msg + "DATAChunkSize: "+Str(ChunkSize)+Chr(13)+Chr(10) 
      InfoHeaderObjVersion = BSWAPw(ReadWord(InfoFileID)) 
      msg + "DATAHeaderObjectVersion: "+Str(InfoHeaderObjVersion)+Chr(13)+Chr(10) 
      If InfoHeaderObjVersion = 0 
        msg + "Num_Packets: "+Str(BSwap(ReadLong(InfoFileID)))+Chr(13)+Chr(10) 
        msg + "Next_Data_Header: "+Str(BSwap(ReadLong(InfoFileID)))+Chr(13)+Chr(10) 
      EndIf 
      FileSeek(InfoFileID, Loc(InfoFileID)+ChunkSize-(4+4+2+4+4));} 
    ElseIf PeekS(@rBuffer,4) = "INDX" ;{ 
      msg + Chr(13)+Chr(10) 
      msg + "INDXHeaderSize: "+Str(BSWAP(ReadLong(InfoFileID)))+Chr(13)+Chr(10) 
      InfoHeaderObjVersion = BSWAPw(ReadWord(InfoFileID)) 
      msg + "INDXHeaderObjectVersion: "+Str(InfoHeaderObjVersion)+Chr(13)+Chr(10) 
      If InfoHeaderObjVersion = 0 
        msg + "Num_Records: "+Str(BSWAP(ReadLong(InfoFileID)))+Chr(13)+Chr(10) 
        msg + "Streamnumber: "+Str(BSWAPw(ReadWord(InfoFileID)))+Chr(13)+Chr(10) 
        msg + "Next_INDX_Header: "+Str(BSWAP(ReadLong(InfoFileID)))+Chr(13)+Chr(10) 
      EndIf ;} 
    EndIf 
  Until Eof(InfoFileID) 
  
  CloseFile(InfoFileID); tmp 
  MessageBox_(hwnd,msg,"Info "+Chr(34)+GetFilePart(fn)+Chr(34),#MB_OK) 
EndProcedure 

ProcedureCDLL getfileinfo(filename.s, *title.STRING, *length_in_ms.LONG) 
  Protected InfoFileID, rBuffer, wlength, wtitle, InfoHeaderBuff, InfoHeaderBuffSize, InfoHeaderObjVersion, ChunkSize 
  InfoFileID = ReadFile(#PB_Any,filename) 
  If InfoFileID = 0 
    ProcedureReturn 
  EndIf 
  
  ReadData(InfoFileID, @rBuffer,4) 
  If PeekS(@rBuffer,4) <> ".RMF" 
    CloseFile(InfoFileID) 
    *title\s = "None RMF-File!" 
    *length_in_ms\l = 0 
    ProcedureReturn 
  EndIf 
  
  ReadLong(InfoFileID) 
  ReadWord(InfoFileID) 
  ReadLong(InfoFileID) 
  ReadLong(InfoFileID) 
  
  If *title = 0 
    wtitle = 1 
  Else 
    tmp.s = GetFilePart(filename) 
    CopyMemory(@tmp,*title,Len(tmp)) 
    wtitle = 0 
  EndIf 
  If *length_in_ms = 0 
    wlength = 1 
  Else 
    wlength = 0 
  EndIf 
  
  Repeat 
    ReadData(InfoFileID, @rBuffer,4) 
    If PeekS(@rBuffer,4) = "PROP" ;{ 
      ReadLong(InfoFileID) 
      InfoHeaderObjVersion = BSWAPw(ReadWord(InfoFileID)) 
      If InfoHeaderObjVersion = 0 
        ReadLong(InfoFileID) 
        ReadLong(InfoFileID) 
        ReadLong(InfoFileID) 
        ReadLong(InfoFileID) 
        ReadLong(InfoFileID) 
        If *length_in_ms 
          *length_in_ms\l = BSwap(ReadLong(InfoFileID)) 
        Else 
          ReadLong(InfoFileID) 
        EndIf 
        ReadLong(InfoFileID) 
        ReadLong(InfoFileID) 
        ReadLong(InfoFileID) 
        ReadLong(InfoFileID) 
        ReadLong(InfoFileID) 
        wlength = 1 
      EndIf ;} 
    ElseIf PeekS(@rBuffer,4) = "MDPR" 
      FileSeek(InfoFileID, Loc(InfoFileID)+BSwap(ReadLong(InfoFileID))-8) 
    ElseIf PeekS(@rBuffer,4) = "CONT" ;{ 
      ReadLong(InfoFileID) 
      InfoHeaderObjVersion = BSWAPw(ReadWord(InfoFileID)) 
      If InfoHeaderObjVersion = 0 
        InfoHeaderBuffSize = ReadByte(InfoFileID) 
        If InfoHeaderBuffSize 
          InfoHeaderBuff = AllocateMemory(InfoHeaderBuffSize) 
          ReadData(InfoFileID, InfoHeaderBuff,InfoHeaderBuffSize) 
          If *title 
            tmp.s = PeekS(InfoHeaderBuff,InfoHeaderBuffSize) 
            CopyMemory(@tmp,*title,Len(tmp)) 
          EndIf 
          FreeMemory(InfoHeaderBuff) 
        Else 
          If *title 
            tmp.s = GetFilePart(filename) 
            CopyMemory(@tmp,*title,Len(tmp)) 
          EndIf 
        EndIf 
        wtitle = 1 
        
        InfoHeaderBuffSize = ReadByte(InfoFileID) 
        InfoHeaderBuff = AllocateMemory(InfoHeaderBuffSize) 
        ReadData(InfoFileID, InfoHeaderBuff,InfoHeaderBuffSize) 
        FreeMemory(InfoHeaderBuff) 
        
        InfoHeaderBuffSize = ReadByte(InfoFileID) 
        InfoHeaderBuff = AllocateMemory(InfoHeaderBuffSize) 
        ReadData(InfoFileID, InfoHeaderBuff,InfoHeaderBuffSize) 
        FreeMemory(InfoHeaderBuff) 
        
        InfoHeaderBuffSize = ReadByte(InfoFileID) 
        InfoHeaderBuff = AllocateMemory(InfoHeaderBuffSize) 
        ReadData(InfoFileID, InfoHeaderBuff,InfoHeaderBuffSize) 
        FreeMemory(InfoHeaderBuff) 
      EndIf ;} 
    ElseIf PeekS(@rBuffer,4) = "DATA" ;{ 
      ChunkSize = BSwap(ReadLong(InfoFileID)) 
      InfoHeaderObjVersion = BSWAPw(ReadWord(InfoFileID)) 
      If InfoHeaderObjVersion = 0 
        ReadLong(InfoFileID) 
        ReadLong(InfoFileID) 
      EndIf 
      FileSeek(InfoFileID, Loc(InfoFileID)+ChunkSize-(4+4+2+4+4));} 
    ElseIf PeekS(@rBuffer,4) = "INDX" 
      FileSeek(InfoFileID, Loc(InfoFileID)+BSwap(ReadLong(InfoFileID))-8) 
    EndIf 
  Until Eof(InfoFileID) Or (wtitle And wlength) 
  
  CloseFile(InfoFileID) 
EndProcedure 

ProcedureCDLL eq_set(on.l, *eqData.eqData_struc, preamp.l) 
EndProcedure 

ProcedureDLL.l winampGetInModule2() 
  mod\Version = #IN_VER 
  mod\Description = "RM Player v0.0 (x86)" 
  mod\hMainWindow = 0 
  mod\hDllInstance = 0 
  mod\FileExtensions = ?FileExtensions 
  mod\is_seekable = 1 
  mod\UseOutputPlug = 1 
  mod\Config = @config() 
  mod\About = @about() 
  mod\init = @Init() 
  mod\quit = @quit() 
  mod\getinfofile = @getfileinfo() 
  mod\infobox = @infoDlg() 
  mod\isourfile = @isourfile() 
  mod\play = @play() 
  mod\pause = @pause() 
  mod\unpause = @unpause() 
  mod\ispaused = @ispaused() 
  mod\stop = @stop() 
  mod\getlength = @getlength() 
  mod\getoutputtime = @getoutputtime() 
  mod\setoutputtime = @setoutputtime() 
  mod\setvolume = @setvolume() 
  mod\setpan = @setpan() 
  mod\SAVSAInit = 0 
   mod\SAVSADeInit = 0 
  mod\SAAddPCMData = 0 
  mod\SAGetMode = 0 
  mod\SAAdd = 0 
  mod\VSAAddPCMData = 0 
  mod\VSAGetMode = 0 
  mod\VSAAdd = 0 
  mod\VSASetInfo = 0 
  mod\dsp_isactive = 0 
  mod\dsp_dosamples = 0 
  mod\EQSet = @eq_set() 
  mod\setinfo = #Null 
  
  ProcedureReturn @mod 
EndProcedure 

DataSection 
FileExtensions: 
Data.s "RM" 
Data.s "RM Audio File (*.rm)" 
Data.b 0 
EndDataSection

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = ------