; www.purearea.net (Sourcecode collection by cnesm)
; Author: Christoffer Anselm
; Date: 22. November 2003
; OS: Windows
; Demo: Yes


; Need the UnRAR.dll for working, use Google... ;)

; The unrar.pb sourcecode file is freeware. This means: 
;    1. All copyrights to the unrar.pb are exclusively 
;      owned by the author - Christoffer Anselm. 
;    2. The unrar.pd file may be used in any software to handle RAR 
;      archives without limitations free of charge. 
;    3. THE UNRAR.PB FILE IS DISTRIBUTED "AS IS". 
;      NO WARRANTY OF ANY KIND IS EXPRESSED OR IMPLIED.  YOU USE AT 
;      YOUR OWN RISK. THE AUTHOR WILL NOT BE LIABLE FOR DATA LOSS, 
;      DAMAGES, LOSS OF PROFITS OR ANY OTHER KIND OF LOSS WHILE USING 
;      OR MISUSING THIS SOFTWARE. 
;      Thank you for your interest in unrar.pb. 
;                                             Christoffer Anselm 

; 
;-Libs 
#UnRAR = 0 

;-UnRAR Constants 
#ERAR_END_ARCHIVE = 10 
#ERAR_NO_MEMORY = 11 
#ERAR_BAD_DATA = 12 
#ERAR_BAD_ARCHIVE = 13 
#ERAR_UNKNOWN_FORMAT = 14 
#ERAR_EOPEN = 15 
#ERAR_ECREATE = 16 
#ERAR_ECLOSE = 17 
#ERAR_EREAD = 18 
#ERAR_EWRITE = 19 
#ERAR_SMALL_BUF = 20 
#ERAR_UNKNOWN = 21 

#RAR_OM_LIST =  0 
#RAR_OM_EXTRACT =  1 

#RAR_SKIP =  0 
#RAR_TEST =  1 
#RAR_EXTRACT =  2 

#RAR_VOL_ASK =  0 
#RAR_VOL_NOTIFY =  1 

#RAR_DLL_VERSION =  3 

Structure RAROpenArchiveData 
   *ArcName.l 
   OpenMode.l 
   OpenResult.l 
   *CmtBuf.l 
   CmtBufSize.l 
   CmtSize.l 
   CmtState.l 
EndStructure 

Structure RARHeaderData 
   ArcNameB.b[260] 
   FileNameB.b[260] 
   Flags.l 
   PackSize.l 
   UnpSize.l 
   HostOS.l 
   FileCRC.l 
   FileTime.l 
   UnpVer.l 
   Method.l 
   FileAttr.l 
   *CmtBuf.l 
   CmtBufSize.l 
   CmtSize.l 
   CmtState.l 
   ArcName.s 
   FileName.s 
EndStructure 

Procedure.l RAR_Init() 
   If OpenLibrary(#UnRAR, "UnRAR.dll") 
      Global ArchiveData.RAROpenArchiveData, HeaderData.RARHeaderData 
      If CallFunction(#UnRAR, "RARGetDllVersion") = #RAR_DLL_VERSION 
         ProcedureReturn 1 
      Else 
         CloseLibrary(#UnRAR) 
         ProcedureReturn 0 
      EndIf 
      Else 
    ProcedureReturn 0 
  EndIf 
EndProcedure 

Procedure.l RAR_OpenArchive(File.s, OpenMode.l) 
    Cmt.s                  = "" 
    ArchiveData\ArcName    = @File 
    ArchiveData\OpenMode   = OpenMode 
    ArchiveData\CmtBuf     = @Cmt 
    ArchiveData\CmtBufSize = 0 
    *ArchiveDataP.l        = @ArchiveData\ArcName 

    ProcedureReturn CallFunction(#UnRAR, "RAROpenArchive", *ArchiveDataP) 
EndProcedure 

Procedure.l RAR_CloseArchive(hArcData.l) 
  ProcedureReturn CallFunction(#UnRAR, "RARCloseArchive", hArcData) 
EndProcedure 

Procedure.l RAR_ReadHeader(hArcData.l) 
    HeaderData\CmtBuf     = @Cmt 
    HeaderData\CmtBufSize = 0 
    *HeaderDataP.l        = @HeaderData\ArcNameB[0] 
    
    ProcedureReturn CallFunction(#UnRAR, "RARReadHeader", hArcData, *HeaderDataP) 
    
    HeaderData\ArcName = "" 
    HeaderData\FileName = "" 
    For i = 0 To 259 
      j = Val(StrU(HeaderData\FileNameB[i],0)) 
      If j 
        HeaderData\FileName + Chr(j) 
      EndIf 
      j = Val(StrU(HeaderData\ArcNameB[i],0)) 
      If j 
        HeaderData\ArcName  + Chr(j) 
      EndIf 
    Next i 
EndProcedure 

Procedure.l RAR_ProcessFile(hArcData.l,Operation.l,DestPath.s,DestName.s) 
  ;*DestPathP = @DestPath 
  ;*DestNameP = @DestName 
  ProcedureReturn CallFunction(#UnRAR, "RARProcessFile", hArcData, Operation, DestPath, DestName) 
EndProcedure 

Procedure RAR_SetCallback(hArcDate.l, *CallbackProc.l, UserData.l) 
   CallFunction(#UnRAR, "RARSetCallback", hArcData, *CallbackProc, UserData) 
EndProcedure 

Procedure RAR_SetPassword(hArcData.l, Password.s) 
   CallFunction(#UnRAR, "RARSetPassword", hArcData, Password) 
EndProcedure 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = --