; English forum: http://www.purebasic.fr/english/viewtopic.php?t=13910&highlight=
; Author: sverson
; Date: 03. February 2005
; OS: Windows
; Demo: No



; GetFileVersionInfo exe/dll any language 

;/ gfvi.pb - GetFileVersionInfo for PureBasic 
;/ 2005-02-03 sverson 
;/ 
;/ more info on this topic: 
;/ http://msdn.microsoft.com/library/default.asp?url=/library/en-us/winui/winui/windowsuserinterface/resources/versioninformation.asp 

Enumeration;- element name keys 
  #GFVI_FileVersion      = $0001 
  #GFVI_FileDescription  = $0002 
  #GFVI_LegalCopyright   = $0004 
  #GFVI_InternalName     = $0008 
  #GFVI_OriginalFilename = $0010 
  #GFVI_ProductName      = $0020 
  #GFVI_ProductVersion   = $0040 
  #GFVI_CompanyName      = $0080 
  #GFVI_LegalTrademarks  = $0100 
  #GFVI_SpecialBuild     = $0200 
  #GFVI_PrivateBuild     = $0400 
  #GFVI_Comments         = $0800 
  #GFVI_Language         = $1000 
  #GFVI_All              = $1FFF 
EndEnumeration 

Procedure.s GFVI_GetElementName(elementKey.l);- get element name from key [gfvi] 
  If     elementKey = #GFVI_FileVersion      : ProcedureReturn "FileVersion" 
  ElseIf elementKey = #GFVI_FileDescription  : ProcedureReturn "FileDescription" 
  ElseIf elementKey = #GFVI_LegalCopyright   : ProcedureReturn "LegalCopyright" 
  ElseIf elementKey = #GFVI_InternalName     : ProcedureReturn "InternalName" 
  ElseIf elementKey = #GFVI_OriginalFilename : ProcedureReturn "OriginalFilename" 
  ElseIf elementKey = #GFVI_ProductName      : ProcedureReturn "ProductName" 
  ElseIf elementKey = #GFVI_ProductVersion   : ProcedureReturn "ProductVersion" 
  ElseIf elementKey = #GFVI_CompanyName      : ProcedureReturn "CompanyName" 
  ElseIf elementKey = #GFVI_LegalTrademarks  : ProcedureReturn "LegalTrademarks" 
  ElseIf elementKey = #GFVI_SpecialBuild     : ProcedureReturn "SpecialBuild" 
  ElseIf elementKey = #GFVI_PrivateBuild     : ProcedureReturn "PrivateBuild" 
  ElseIf elementKey = #GFVI_Comments         : ProcedureReturn "Comments" 
  ElseIf elementKey = #GFVI_Language         : ProcedureReturn "Language" 
  EndIf 
EndProcedure 

Procedure.s GFVI_GetInfo(lptstrFilename$,lekFlags,bFieldName);- get exe/dll file information [gfvi] 
  Protected lpdwHandle.l, dwLen.w, lpData.l, lplpBuffer.l, puLen.l, *pBlock, lpSubBlock$ 
  Protected nSize.w, szLang$, bBit.b, lekFlag.l, sElement$, sGFVI$ 
  
  lplpBuffer = 0 : puLen = 0 : sGFVI$ = "" : nSize = 128 : szLang$ = Space(nSize) 
  
  If FileSize(lptstrFilename$)>0 
    If OpenLibrary(1,"Version.dll") 
      dwLen = CallFunction(1,"GetFileVersionInfoSizeA",lptstrFilename$,@lpdwHandle) 
      If dwLen>0 
        *pBlock=AllocateMemory(dwLen) 
        If *pBlock>0 
          Result = CallFunction(1,"GetFileVersionInfoA",lptstrFilename$,0,dwLen,*pBlock) 
          If Result 
            lpSubBlock$ = "\\VarFileInfo\\Translation" 
            Result      = CallFunction(1,"VerQueryValueA",*pBlock,lpSubBlock$,@lplpBuffer,@puLen) 
            If Result 
              CPLI$  = RSet(Hex(PeekW(lplpBuffer)),4,"0")+RSet(Hex(PeekW(lplpBuffer+2)),4,"0") 
              Result = CallFunction(1,"VerLanguageNameA",PeekW(lplpBuffer),@szLang$,nSize) 
            EndIf 
            lekFlag = 1 
            For bBit = 1 To 12 
              If lekFlag & lekFlags 
                sElement$   = GFVI_GetElementName(lekFlag) 
                lpSubBlock$ = "\\StringFileInfo\\"+CPLI$+"\\"+sElement$ 
                Result      = CallFunction(1,"VerQueryValueA",*pBlock,lpSubBlock$,@lplpBuffer,@puLen) 
                If Result 
                  If sGFVI$<>"" : sGFVI$+Chr(10) : EndIf 
                  If bFieldName 
                    sGFVI$=sGFVI$+sElement$+":"+Chr(9)+PeekS(lplpBuffer) 
                  Else 
                    sGFVI$=sGFVI$+PeekS(lplpBuffer) 
                  EndIf 
                  
                EndIf 
              EndIf 
              lekFlag << 1 
            Next 
            If lekFlag & lekFlags 
              If sGFVI$<>"" : sGFVI$+Chr(10) : EndIf 
              If bFieldName 
                sElement$ = GFVI_GetElementName(lekFlag) 
                sGFVI$    = sGFVI$+sElement$+":"+Chr(9)+szLang$ 
              Else 
                sGFVI$    = sGFVI$+szLang$ 
              EndIf 
            EndIf 
          EndIf 
          FreeMemory(*pBlock) 
        EndIf 
      EndIf 
      CloseLibrary(1) 
    EndIf 
  EndIf 
  ProcedureReturn sGFVI$ 
EndProcedure 

;- test GFVI-functions 

File$  = OpenFileRequester("Open File", "gfvi.exe", "GFVI |*.exe;*.dll|all files (*.*)|*.*", 0) 
VInfo$ = GFVI_GetInfo(File$,#GFVI_FileVersion|#GFVI_CompanyName,#False) 
MessageRequester("Fileinfo for "+GetFilePart(File$),VInfo$,#MB_OK|#MB_ICONINFORMATION) 
VInfo$ = GFVI_GetInfo(File$,#GFVI_All,#True) 
MessageRequester("Fileinfo for "+GetFilePart(File$),VInfo$,#MB_OK|#MB_ICONINFORMATION) 

End 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -