; English forum: http://www.purebasic.fr/english/viewtopic.php?t=13330&highlight=
; Author: Leo (updated for PB 4.00 by Andre)
; Date: 09. December 2004
; OS: Windows
; Demo: No


; OpenFileRequester and SaveFileRequester with ZIP integration
; ************************************************************

; NOTE: The ZLIBWAPI.DLL is needed for running with full features!

; Inspired by the OpenFileRequester_with_Preview from the CodeArchiv,
; I wrote a customized OpenFileRequester (and SaveFileRequester) with
; ZIP compression support. For the handling of the zipfiles I use the
; ZLIBWAPI.dll that can be downloaded from the www.zlib.org website.

; The following customizations are implemented :

; OpenFileRequester :
; - A TextGadget and a ListviewGadget are added to the Dialog
; - Internally the pattern is extended with zipfiles. Thus if the
;   Pattern is *.txt then txt and zip files are shown.
; - Selecting a txt file means the normal Procedure
; - Selecting a zip file causes the ListViewGadget to be filled with
;   txt files.
; If there are any present in the zip file.
; - Pressing Open Or doubleclicking a txt file in the ListViewGadget results
;   in a Return of the selected zipfile + "#"+the selected txt file in the
;   ListViewGadget.

; SaveFileRequester :
; - A TextGadget, a ListviewGadget and a StringGadget are added to the
;   Dialog
; - Internally the pattern is extended with zipfiles. Thus if the
;   Pattern is *.txt then txt and zip files are shown.
; - Selecting a txt file means the normal Procedure
; - Selecting a zip file causes the ListViewGadget to be filled with txt files
;   if there are any present in the zip file.
; - Clicking a txt file in the ListViewGadget result in copying the entry
;   into the StringGadget.
; - The StringGadget may be modified manually.
; - Pressing Save Or doubleclicking a txt file in the ListViewGadget results
;   in a Return of the selected zipfile + "#"+the contents of the
;   StringGadget.

; To avoid OS version problems, depending on the OS OPENFILENAME Or OPENFILENAMEEX
; structure is used. In principle compiling on Win98 and running on XP is possible.

;##################################
;OpenFileRequester with Zip
; uses ZLIBWAPI.dll
;##################################
;Leo * December 2004
;##################################

;##################################
; ZLIPWAPI.dll Declarations
;##################################

#UNZ_OK                           = 0
#UNZ_END_OF_LIST_OF_FILE          = -100
#UNZ_EOF                          = 0
#UNZ_PARAMERROR                   = -102
#UNZ_BADZIPFILE                   = -103
#UNZ_INTERNALERROR                = -104
#UNZ_CRCERROR                     = -105

#Z_DEFLATED                       = 8

#Z_NO_COMPRESSION                 = 0
#Z_BEST_SPEED                     = 1
#Z_BEST_COMPRESSION               = 9
#Z_DEFAULT_COMPRESSION            = -1

#APPEND_STATUS_CREATE             = 0
#APPEND_STATUS_CREATEAFTER        = 1
#APPEND_STATUS_ADDINZIP           = 2
;/* tm_unz contain date/time info */

Structure tm_date
  tm_sec.l;            /* seconds after the minute - [0,59] */
  tm_min.l;            /* minutes after the hour - [0,59] */
  tm_hour.l;           /* hours since midnight - [0,23] */
  tm_mday.l;           /* day of the month - [1,31] */
  tm_mon.l;            /* months since January - [0,11] */
  tm_year.l;           /* years - [1980..2044] */
EndStructure

;/* unz_global_info structure contain global data about the ZIPfile
;   These data comes from the end of central dir */
Structure unz_global_info
  number_entry.l      ;         /* total number of entries in
  size_comment.l      ;         /* size of the global comment of the zipfile */
EndStructure

Structure unz_file_info
  version.l;              /* version made by                 2 bytes */
  version_needed.l;       /* version needed to extract       2 bytes */
  flag.l;                 /* general purpose bit flag        2 bytes */
  compression_method.l;   /* compression method              2 bytes */
  dosDate.l;              /* last mod file date in Dos fmt   4 bytes */
  crc.l;                  /* crc-32                          4 bytes */
  compressed_size.l;      /* compressed size                 4 bytes */
  uncompressed_size.l;    /* uncompressed size               4 bytes */
  size_filename.l;        /* filename length                 2 bytes */
  size_file_extra.l;      /* extra field length              2 bytes */
  size_file_comment.l;    /* file comment length             2 bytes */
  disk_num_start.l;       /* disk number start               2 bytes */
  internal_fa.l;          /* internal file attributes        2 bytes */
  external_fa.l;          /* external file attributes        4 bytes */
  tmu_date.tm_date ;
EndStructure

Structure zip_file_info
  tm_zip.tm_date
  dosDate.l
  internal_fa.l
  external_fa.l
EndStructure

Global GlobalInfo.unz_global_info
Global FileInfo.unz_file_info

;##################################
; OpenFile Hook Declarations
;##################################

Global *FileBuffer.l
*FileBuffer = AllocateMemory(2*#MAX_PATH)

#OpenFileButtonGadget = 1
#QuitButtonGadget = 2
#OpenFileButtonGadget2 = 3
#SaveFileButtonGadget = 4

#ZipFileStringGadget = 30
#ZipFileListViewGadget = 31
#ZipFileStringGadget2 = 32

#ZLIBWAPI_LIB = 11

#CDN_FIRST              = (-601)
#CDN_LAST               = (-699)
#CDN_INITDONE           = #CDN_FIRST
#CDN_SELCHANGE          = (#CDN_FIRST-1)
#CDN_FOLDERCHANGE       = (#CDN_FIRST-2)
#CDN_SHAREVIOLATION     = (#CDN_FIRST-3)
#CDN_HELP               = (#CDN_FIRST-4)
#CDN_FILEOK             = (#CDN_FIRST-5)
#CDN_TYPECHANGE         = (#CDN_FIRST-6)

; Structure OSVERSIONINFOEX Extends OSVERSIONINFO
;   wServicePackMajor.w
;   wServicePackMinor.w
;   wSuiteMask.w
;   wProductType.b
;   wReserved.b
; EndStructure

Structure OPENFILENAMEXP Extends OPENFILENAME
  pvReserved.l
  dwReserved.l
  FlagsEx.l
EndStructure

Structure OFNOTIFY
  hdr.NMHDR
  lpOFN.OPENFILENAME
  pszFile.l
EndStructure

Global OldCallback, hOK


Procedure ListViewCallbackOpen(hwnd, msg, wparam, lparam)
  result = CallWindowProc_(OldCallback, hwnd, msg, wparam, lparam)
  Select msg
    Case #WM_LBUTTONDBLCLK
      SendMessage_(hOK,#BM_CLICK,0,0)
  EndSelect
  ProcedureReturn result
EndProcedure

Procedure ListViewCallbackSave(hwnd, msg, wparam, lparam)
  result = CallWindowProc_(OldCallback, hwnd, msg, wparam, lparam)
  Select msg
    Case #WM_LBUTTONDBLCLK
      SendMessage_(hOK,#BM_CLICK,0,0)
    Case #WM_LBUTTONDOWN
      SetGadgetText(#ZipFileStringGadget2, GetGadgetText(#ZipFileListViewGadget))
  EndSelect
  ProcedureReturn result
EndProcedure

Procedure OFHookProc(hdlg,uiMsg,wParam,lParam)
  Shared hLV, lCustData
  ZipFile$ = Space(#MAX_PATH)
  Result = #False
  Select uiMsg
    Case #WM_NOTIFY
      *of.OFNOTIFY = lParam
      Select *of\hdr\code
        Case  #CDN_FILEOK
          SendMessage_(GetParent_(hdlg),#CDM_GETFILEPATH,#MAX_PATH,ZipFile$)
          If lCustData = 0
            InternalFile$=Trim(GetGadgetText(#ZipFileListViewGadget))
          Else
            InternalFile$=Trim(GetGadgetText(#ZipFileStringGadget2))
          EndIf
          If InternalFile$="" And UCase(Right(ZipFile$,4))=".ZIP"
            If lCustData=0
              MessageRequester("!! Attention !!","Please select file to be extracted.",0)
            Else
              MessageRequester("!! Attention !!","No filename specified.",0)
            EndIf
            SetWindowLong_(hdlg,#DWL_MSGRESULT,1)
            ZipSelect=1
          Else
            *OFN.OPENFILENAME=*of\lpOFN
            If InternalFile$
              PokeS(*FileBuffer,ZipFile$+"#"+InternalFile$)
            Else
              PokeS(*FileBuffer,ZipFile$)
            EndIf
          EndIf
        Case  #CDN_FOLDERCHANGE
        Case  #CDN_HELP
        Case  #CDN_INITDONE
        Case  #CDN_SELCHANGE
          ClearGadgetItemList(#ZipFileListViewGadget)
          SetGadgetText(#ZipFileStringGadget,"No ZIP File selected")
          GlobalInfo.unz_global_info
          FileInfo.unz_file_info
          SendMessage_(GetParent_(hdlg),#CDM_GETFILEPATH,#MAX_PATH,ZipFile$)
          If UCase(Right(ZipFile$,4))=".ZIP"
            If ReadFile(1, ZipFile$)
              CloseFile(1)
              *OFN.OPENFILENAME=PeekL(*of\lpOFN)
              FilterIndex=*OFN\nFilterIndex
              FilterAddress=*OFN\lpstrFilter
              For i=1 To 2*FilterIndex-1
                FilterAddress+Len(PeekS(FilterAddress))+1
              Next
              ZipCaption.s=ReplaceString(PeekS(FilterAddress),";*.zip","")
              If ZipCaption="*.*" Or ZipCaption=""
                SetGadgetText(#ZipFileStringGadget, "All Files")
              Else
                SetGadgetText(#ZipFileStringGadget, "Only "+ZipCaption+" Files")
              EndIf
              If OpenLibrary(#ZLIBWAPI_LIB,"zlibwapi.dll")
                FileName=AllocateMemory(500)
                Comment=AllocateMemory(500)
                ExtraField=AllocateMemory(500)
                Handle.l=CallFunction(#ZLIBWAPI_LIB,"unzOpen",ZipFile$)
                Result.l=CallFunction(#ZLIBWAPI_LIB,"unzGetGlobalInfo",Handle,@GlobalInfo)
                NrOfCompressed.l=GlobalInfo\number_entry
                Result.l=CallFunction(#ZLIBWAPI_LIB,"unzGoToFirstFile",Handle)
                MaxLen=0
                MaxStr.s=""
                For i=1 To NrOfCompressed
                  Result.l=CallFunction(#ZLIBWAPI_LIB,"unzGetCurrentFileInfo",Handle,@FileInfo,FileName,100,ExtraField,100,Comment,100)
                  Extension.s=UCase(Right(PeekS(FileName),4))
                  Pos.l=FindString(Extension,".",1)
                  If Pos=0
                    Extension="No Filter"
                  ElseIf Pos>1
                    Extension=Mid(Extension,Pos,4)
                  EndIf
                  If (FindString(ZipCaption,"*.*",1) Or FindString(UCase(ZipCaption),Extension,1) Or FilterIndex=0) And Right(PeekS(FileName),1)<>"/"
                    If Len(PeekS(FileName))>MaxLen
                      MaxLen=Len(PeekS(FileName))
                      MaxStr=PeekS(FileName)
                      hDC.l=GetDC_(GadgetID(#ZipFileListViewGadget))
                    EndIf
                    hDC.l=GetDC_(GadgetID(#ZipFileListViewGadget))
                    GetTextExtentPoint32_(hDC,MaxStr,MaxLen,@Size)
                    SendMessage_(GadgetID(#ZipFileListViewGadget),#LB_SETHORIZONTALEXTENT,Size,0)
                    AddGadgetItem(#ZipFileListViewGadget, -1, PeekS(FileName))
                  EndIf
                  Result.l=CallFunction(#ZLIBWAPI_LIB,"unzGoToNextFile",Handle)
                Next
                CloseLibrary(#ZLIBWAPI_LIB)
              Else
                Debug "Warning: opening of the zlibwapi.dll failed!"
              EndIf
            EndIf
          EndIf
        Case  #CDN_SHAREVIOLATION
        Case  #CDN_TYPECHANGE
        Default
          ClearGadgetItemList(#ZipFileListViewGadget)
      EndSelect
      Result = #True
    Case #WM_INITDIALOG
      *OFN.OPENFILENAME = lParam
      lCustData = *OFN\lCustData
      GetWindowRect_(GetParent_(hdlg),wr.RECT)
      GetWindowRect_(GetDesktopWindow_(),wr1.RECT)
      MoveWindow_(GetParent_(hdlg),wr1\right/2-(wr\right+210)/2,wr1\bottom/2-(wr\bottom)/2,wr\right+210,wr\bottom,#True)
      CreateGadgetList(GetParent_(hdlg))
      TextGadget(#ZipFileStringGadget,wr\right-5,6,200,20,"No ZIP File selected",#PB_Text_Border)
      If lCustData = 0
        hLV=ListViewGadget(#ZipFileListViewGadget, wr\right-5,33,200,wr\bottom-63 )
        OldCallback = SetWindowLong_(GadgetID(#ZipFileListViewGadget), #GWL_WNDPROC, @ListViewCallbackOpen())
      Else
        hLV=ListViewGadget(#ZipFileListViewGadget, wr\right-5,33,200,wr\bottom-93 )
        StringGadget(#ZipFileStringGadget2,wr\right-5,wr\bottom-50,200,20,"")
        OldCallback = SetWindowLong_(GadgetID(#ZipFileListViewGadget), #GWL_WNDPROC, @ListViewCallbackSave())
      EndIf
      Styles.l = GetWindowLong_(GadgetID(#ZipFileListViewGadget), #GWL_STYLE)
      Styles = Styles | #WS_HSCROLL | #WS_VSCROLL | #WS_CHILD
      SetWindowLong_(GadgetID(#ZipFileListViewGadget), #GWL_STYLE, Styles)
      hOK=GetDlgItem_(GetParent_(hdlg),#IDOK)
      Result = #True
    Default
  EndSelect
  ProcedureReturn Result
EndProcedure

Procedure.s ZipFileRequester(Title$, DefaultFile$, Pattern$, PatternPosition, OpenYesNo )
  PokeS(*FileBuffer,DefaultFile$)
  i=1
  PatField$=StringField(Pattern$,i,"|")
  NewPattern$=""
  While PatField$
    If i % 2 = 1
      NewPattern$+PatField$+"|"
    Else
      NewPattern$+PatField$+";*.zip|"
    EndIf
    i+1
    PatField$=StringField(Pattern$,i,"|")
  Wend
  NewPattern$=ReplaceString(NewPattern$,"*.*;*.zip","*.*")
  NewPattern$+"|"
  AddrPattern=AllocateMemory(Len(NewPattern$))
  PokeS(AddrPattern,NewPattern$)
  For i=0 To Len(NewPattern$)-1
    If PeekB(AddrPattern+i)='|'
      PokeB(AddrPattern+i,0)
    EndIf
  Next
  NewPattern$=ReplaceString(NewPattern$,"|",Chr(0))
  Result.s = ""
  of.OPENFILENAMEXP
  of\lpstrTitle = @Title$
  of\lStructSize = SizeOf(OPENFILENAME)
  OS.OSVERSIONINFOEX
  OS\dwOSVersionInfoSize=SizeOf(OSVERSIONINFOEX)
  If GetVersionEx_(@OS)
    If OS\dwMajorVersion>4
      of\lStructSize = SizeOf(OPENFILENAMEXP)
    EndIf
  EndIf
  ;  If OSVersion()>49
  ;    of\lStructSize = SizeOf(OPENFILENAMEXP)
  ;  Else
  ;    of\lStructSize = SizeOf(OPENFILENAME)
  ;  EndIf
  of\flags = #OFN_EXPLORER|#OFN_ENABLEHOOK
  of\lpstrFilter = AddrPattern
  of\nFilterIndex = PatternPosition
  of\nMaxFile = 2*#MAX_PATH
  of\lpstrFile = *FileBuffer
  of\lpfnHook = @OFHookProc()
  of\lCustData = OpenYesNo
  If OpenYesNo=0
    If GetOpenFileName_(of)
      Result = PeekS(*FileBuffer)
    EndIf
  Else
    If GetSaveFileName_(of)
      Result = PeekS(*FileBuffer)
    EndIf
  EndIf
  ProcedureReturn Result
EndProcedure

Procedure.s OpenZipFileRequester(Title$, DefaultFile$, Pattern$, PatternPosition )
  ProcedureReturn ZipFileRequester(Title$, DefaultFile$, Pattern$, PatternPosition, 0 )
EndProcedure

Procedure.s SaveZipFileRequester(Title$, DefaultFile$, Pattern$, PatternPosition )
  ProcedureReturn ZipFileRequester(Title$, DefaultFile$, Pattern$, PatternPosition, 1 )
EndProcedure


If OpenWindow(0,0,0,270,220,"OpenFileDialog with Zip",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) And CreateGadgetList(WindowID(0))
  ButtonGadget(#OpenFileButtonGadget, 10, 10,120,20,"OpenFile with Pattern")
  ButtonGadget(#OpenFileButtonGadget2, 10, 40,140,20,"OpenFile without Pattern")
  ButtonGadget(#SaveFileButtonGadget, 10, 70,140,20,"SaveFile with Pattern")
  ButtonGadget(#QuitButtonGadget, 10, 100,80,20,"Quit")
  Repeat
    EventID.l = WaitWindowEvent()
    If EventID = #PB_Event_Gadget
      Select EventGadget()
        Case #OpenFileButtonGadget
          pathname.s = Space(#MAX_PATH)
          GetCurrentDirectory_(#MAX_PATH, @pathname)
          If Right(pathname,1)="\"
            pathname=Left(pathname,Len(pathname)-1)
          EndIf
          StandardFile$ = pathname+"\leo.txt"
          Pattern$ = "Text (*.txt or *.bat)|*.txt;*.bat|PureBasic (*.pb)|*.pb|All files (*.*)|*.*"
          Pattern = 0
          opf.s = OpenZipFileRequester("OpenZipFileRequester",StandardFile$,Pattern$,Pattern)
          MessageRequester("File :",opf,0)
          ZipFile$=StringField(opf,1,"#")
          InternalFile$=StringField(opf,2,"#")
          If InternalFile$
            If OpenLibrary(#ZLIBWAPI_LIB,"zlibwapi.dll")
              FileName=AllocateMemory(500)
              Comment=AllocateMemory(500)
              ExtraField=AllocateMemory(500)
              Handle.l=CallFunction(#ZLIBWAPI_LIB,"unzOpen",ZipFile$)
              Result.l=CallFunction(#ZLIBWAPI_LIB,"unzLocateFile",Handle,InternalFile$)
              Result.l=CallFunction(#ZLIBWAPI_LIB,"unzGetCurrentFileInfo",Handle,@FileInfo,FileName,100,ExtraField,100,Comment,100)
              Debug FileInfo\external_fa
              Result.l=CallFunction(#ZLIBWAPI_LIB,"unzOpenCurrentFile",Handle)
              Text.s=Space(FileInfo\uncompressed_size)
              Result.l=CallFunction(#ZLIBWAPI_LIB,"unzReadCurrentFile",Handle,@Text,FileInfo\uncompressed_size)
              Text=Left(Text,FileInfo\uncompressed_size)
              MessageRequester(Str(Len(Text)),Text,0)
              CloseLibrary(#ZLIBWAPI_LIB)
            EndIf
          Else
            If ReadFile(3, ZipFile$)
              FLen=Lof(3)
              AddrFile=AllocateMemory(FLen+1)
              ReadData(3,AddrFile,Flen)
              MessageRequester(Str(FLen),Left(PeekS(AddrFile),FLen),0)
              CloseFile(3)
            EndIf
          EndIf
        Case #OpenFileButtonGadget2
          ;          opf.s = PB_OpenFile()
          pathname.s = Space(#MAX_PATH)
          GetCurrentDirectory_(#MAX_PATH, @pathname)
          If Right(pathname,1)="\"
            pathname=Left(pathname,Len(pathname)-1)
          EndIf
          StandardFile$ = pathname+"\leo.txt"
          Pattern$=""
          Pattern = 0

          opf.s = OpenZipFileRequester("OpenZipFileRequester",StandardFile$,Pattern$,Pattern)
          MessageRequester("File :",opf,0)
          ZipFile$=StringField(opf,1,"#")
          InternalFile$=StringField(opf,2,"#")
          If InternalFile$
            If OpenLibrary(#ZLIBWAPI_LIB,"zlibwapi.dll")
              FileName=AllocateMemory(500)
              Comment=AllocateMemory(500)
              ExtraField=AllocateMemory(500)
              Handle.l=CallFunction(#ZLIBWAPI_LIB,"unzOpen",ZipFile$)
              Result.l=CallFunction(#ZLIBWAPI_LIB,"unzLocateFile",Handle,InternalFile$)
              Result.l=CallFunction(#ZLIBWAPI_LIB,"unzGetCurrentFileInfo",Handle,@FileInfo,FileName,100,ExtraField,100,Comment,100)
              Result.l=CallFunction(#ZLIBWAPI_LIB,"unzOpenCurrentFile",Handle)
              Text.s=Space(FileInfo\uncompressed_size)
              Result.l=CallFunction(#ZLIBWAPI_LIB,"unzReadCurrentFile",Handle,@Text,FileInfo\uncompressed_size)
              Text=Left(Text,FileInfo\uncompressed_size)
              MessageRequester(Str(Len(Text)),Text,0)
              CloseLibrary(#ZLIBWAPI_LIB)
            EndIf
          Else
            If ReadFile(3, ZipFile$)
              FLen=Lof(3)
              AddrFile=AllocateMemory(FLen+1)
              ReadData(3,AddrFile,Flen)
              MessageRequester(Str(FLen),Left(PeekS(AddrFile),FLen),0)
              CloseFile(3)
            EndIf
          EndIf
        Case #SaveFileButtonGadget
          pathname.s = Space(#MAX_PATH)
          GetCurrentDirectory_(#MAX_PATH, @pathname)
          If Right(pathname,1)="\"
            pathname=Left(pathname,Len(pathname)-1)
          EndIf
          StandardFile$ = pathname+"\leo.txt"
          Pattern$ = "Text (*.txt or *.bat)|*.txt;*.bat|PureBasic (*.pb)|*.pb|All files (*.*)|*.*"
          Pattern = 0
          opf.s = SaveZipFileRequester("SaveZipFileRequester",StandardFile$,Pattern$,Pattern)
          MessageRequester("File :",opf,0)
          ZipFile$=StringField(opf,1,"#")
          InternalFile$=StringField(opf,2,"#")
          If InternalFile$
            If OpenLibrary(#ZLIBWAPI_LIB,"zlibwapi.dll")
              Handle.l=CallFunction(#ZLIBWAPI_LIB,"zipOpen",ZipFile$,#APPEND_STATUS_ADDINZIP)
              zfi.zip_file_info
              zfi\tm_zip\tm_sec=11
              zfi\tm_zip\tm_min=6
              zfi\tm_zip\tm_hour=18
              zfi\tm_zip\tm_mday=9
              zfi\tm_zip\tm_mon=0
              zfi\tm_zip\tm_year=2003
              zfi\dosDate=0
              zfi\internal_fa=0
              zfi\external_fa=0
              Result=CallFunction(#ZLIBWAPI_LIB,"zipOpenNewFileInZip",Handle,@InternalFile$,@zfi,#Null,0,#Null,0,#Null,#Z_DEFLATED,5)
              Content.s="Leo Mijnders"+Chr(13)
              For i=1 To 5
                Content+Content
              Next
              Result=CallFunction(#ZLIBWAPI_LIB,"zipWriteInFileInZip",Handle,@Content,Len(Content))
              Result=CallFunction(#ZLIBWAPI_LIB,"zipCloseFileInZip",Handle)
              Result=CallFunction(#ZLIBWAPI_LIB,"zipClose",Handle,0)
              CloseLibrary(#ZLIBWAPI_LIB)
            EndIf
          Else
            If OpenFile(3, ZipFile$)
              WriteStringN(3,"This is a testfile used in the SAVEZIPFILEREQUESTER !!")
              CloseFile(3)
            EndIf
          EndIf
        Case #QuitButtonGadget
          SendMessage_(WindowID(0),#WM_CLOSE,0,0)
      EndSelect
    EndIf
  Until EventID = #PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = --
; EnableXP