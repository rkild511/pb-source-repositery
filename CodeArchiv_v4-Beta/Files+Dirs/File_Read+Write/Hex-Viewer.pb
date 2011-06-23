; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3479&highlight=
; Author: pcfreak (updated + changed for PB v4 by blbltheworm)
; Date: 18. January 2004
; OS: Windows
; Demo: No


; Anmerkung: Mit dem Update auf PB 4.00 sind die PureTools nicht mehr nötig
; Addition: Since the update to PB 4.00 the PureTools are no longer needed

; Small program to display the contents of a file in hexadecimal system (need the PureTools lib).
; Kleines Programm um die Daten einer Datei im HexaDezimalSystem anzuzeigen. (Benötigt die PureTools Library)

Structure HexFile
  size.l
  pos.l
  pieces.l
  file.s
EndStructure

Structure OCB
  hWnd.l
  ocb.l
EndStructure

Global hexfile.HexFile,file.s,showmax.l,rowsize.l,OldED1.OCB,OldED2.OCB

Global Dim colors.l(1)
colors(0)=$A58F5A
colors(1)=$4DD4B2

Enumeration 3
  #mnuNew
  #mnuOpen
  #mnuSaveAs
  #mnuClose

  #mnuBack
  #mnuForward
  #mnuCut
  #mnuCopy
  #mnuPaste
  
  #mnuAbout
EndEnumeration

#ST_DEFAULT   = 0
#ST_KEEPUNDO  = 1
#ST_SELECTION = 2
#ST_NEWCHARS  = 4

#SCF_DEFAULT   = 0
#SCF_SELECTION = 1
#SCF_WORD      = 2
#SCF_ALL       = 4

#version="v. 1.05"

Declare   CloseHex()
Declare.l EditStreamCallback(dwCookie.l,pbBuff.l,cb.l,*pcb.LONG)
Declare.l LoadHexFile(open.s)
Declare   SetRowIndex(gadget.l)
Declare.l ShowPiece(change.l)

Declare.s GetAppPath()

Declare.l DropFiles()
Declare   GetNumDropFiles(*dropFiles)
Declare.s GetDropFile(*dropFiles,index)
Declare   FreeDropFiles(*dropFiles)

Declare   AddTextED(gadget.l,text.s)
Declare.s CopySel(gadget.l)
Declare   HideSelectionED(gadget.l,hide.l)
Declare   SelectAllED(gadget.l,flag.l)
Declare   SetBkColorED(gadget.l,color.l)
Declare   SetColorED(gadget.l,color.l)
Declare   SetReadOnlyED(gadget.l,flag.l)

If OpenLibrary(1,"RICHED20.DLL")=0
  MessageRequester("Error","Couldn't load RICHED20.DLL",#MB_ICONERROR)
  End
EndIf

OpenWindow(0,0,0,640,480,"HEX-Viewer "+#version+Space(55)+"coded by pcfreak",#PB_Window_SystemMenu|#PB_Window_MinimizeGadget|#PB_Window_ScreenCentered)

If CreateGadgetList(WindowID(0))
  ListViewGadget(1,5,30,75,430,1)
  OldED1\hWnd=CreateWindowEx_($200,"RichEdit20A","",#WS_CHILD|#ES_NOHIDESEL|#ES_MULTILINE, 82,30,395,430,WindowID(0),0,GetModuleHandle_(0),0)
  OldED2\hWnd=CreateWindowEx_($200,"RichEdit20A","",#WS_CHILD|#ES_NOHIDESEL|#ES_MULTILINE,480,30,155,430,WindowID(0),0,GetModuleHandle_(0),0)
  TextGadget(4,400,13,230,14,"Page: 0/0"+Chr(9)+"Position: 0")
EndIf

SetGadgetFont(1,LoadFont(1,"Fixedsys",8))
FreeFont(1)
SetReadOnlyED(OldED1\hWnd,1)
SetBkColorED(OldED1\hWnd,$FFFFFF)
SetReadOnlyED(OldED2\hWnd,1)
SetBkColorED(OldED2\hWnd,$FFFFFF)

style.CHARFORMAT
style\cbSize = SizeOf(CHARFORMAT)
style\dwMask = #CFM_FACE|#CFM_BOLD
PokeS(@style\szFaceName[0],"Fixedsys")
SendMessage_(OldED2\hWnd,#EM_SETCHARFORMAT,#SCF_ALL,@style)

If CreateToolBar(0,WindowID(0))
  ToolBarStandardButton(#mnuNew,#PB_ToolBarIcon_New)
  ToolBarToolTip(0,#mnuNew,"New")
  ToolBarStandardButton(#mnuOpen,#PB_ToolBarIcon_Open)
  ToolBarToolTip(0,#mnuOpen,"Open")
  ToolBarStandardButton(#mnuSaveAs,#PB_ToolBarIcon_Save)
  ToolBarToolTip(0,#mnuSaveAs,"Save as...")
  DisableToolBarButton(0,#mnuSaveAs,1)
  ToolBarStandardButton(#mnuClose,#PB_ToolBarIcon_Delete)
  ToolBarToolTip(0,#mnuClose,"Close")
  
  ToolBarSeparator()
  
  ToolBarStandardButton(#mnuBack,#PB_ToolBarIcon_Undo)
  ToolBarToolTip(0,#mnuBack,"Back")
  ToolBarStandardButton(#mnuForward,#PB_ToolBarIcon_Redo)
  ToolBarToolTip(0,#mnuForward,"Forward")
  
  ToolBarSeparator()
  
  ToolBarStandardButton(#mnuCut,#PB_ToolBarIcon_Cut)
  ToolBarToolTip(0,#mnuCut,"Cut")
  DisableToolBarButton(0,#mnuCut,1)
  ToolBarStandardButton(#mnuCopy,#PB_ToolBarIcon_Copy)
  ToolBarToolTip(0,#mnuCopy,"Copy")
  ToolBarStandardButton(#mnuPaste,#PB_ToolBarIcon_Paste)
  ToolBarToolTip(0,#mnuPaste,"Paste")
  DisableToolBarButton(0,#mnuPaste,1)
  
  ToolBarSeparator()
  
  ToolBarStandardButton(#mnuAbout,#PB_ToolBarIcon_Properties)
  ToolBarToolTip(0,#mnuAbout,"About")
EndIf

CreateStatusBar(1,WindowID(0))

Procedure.l EDCallback(WindowID, Message, wParam, lParam)
  Shared OldED1.OCB,OldED2.OCB
  Result = #PB_ProcessPureBasicEvents
  If Message=#WM_NCLBUTTONUP Or Message=#WM_NCRBUTTONUP Or Message=#WM_KEYUP Or Message=#WM_KEYDOWN Or Message=514
    Select WindowID
    Case OldED1\hWnd
      SetRowIndex(OldED1\hWnd)
    Case OldED2\hWnd
      SetRowIndex(OldED2\hWnd)
    EndSelect
  EndIf
  Select WindowID
  Case OldED1\hWnd
    Result = CallWindowProc_(OldED1\ocb,WindowID,Message,wParam,lParam)
  Case OldED2\hWnd
    Result = CallWindowProc_(OldED2\ocb,WindowID,Message,wParam,lParam)
  EndSelect
  ProcedureReturn Result
EndProcedure

OldED1\ocb=GetWindowLong_(OldED1\hWnd,#GWL_WNDPROC)
SetWindowLong_(OldED1\hWnd,#GWL_WNDPROC,@EDCallback())
ShowWindow_(OldED1\hWnd,#SW_SHOW)
OldED2\ocb=GetWindowLong_(OldED2\hWnd,#GWL_WNDPROC)
SetWindowLong_(OldED2\hWnd,#GWL_WNDPROC,@EDCallback())
ShowWindow_(OldED2\hWnd,#SW_SHOW)

SetFocus_(GadgetID(1))
lastfocus.l=GadgetID(1)

showmax=$1C0
rowsize=$10

file=ProgramParameter()
If FileSize(file)>-1
  CloseHex()
  LoadHexFile(file)
  StatusBarText(1,0,file)
Else
  file=GetAppPath()
EndIf

DragAcceptFiles_(WindowID(0),1)

Repeat
  
  Select WaitWindowEvent()
    Case #PB_Event_Menu
    Select EventMenu()
    Case #mnuOpen
      file=OpenFileRequester("Open",file,"Any File|*.*",0)
      If FileSize(file)>-1
        CloseHex()
        LoadHexFile(file)
        StatusBarText(1,0,file)
      EndIf
    Case #mnuNew
      file=GetAppPath()
      hexfile\size=0
      hexfile\pos=0
      hexfile\pieces=0
      hexfile\file=file
      CloseHex()
      StatusBarText(1,0,"")
    Case #mnuBack
      ShowPiece(-1)
      SetRowIndex(lastfocus)
    Case #mnuForward
      ShowPiece(1)
      SetRowIndex(lastfocus)
    Case #mnuCopy
      Select lastfocus
      Case OldED1\hWnd
        SendMessage_(OldED1\hWnd,#WM_COPY,0,0)
      Case OldED2\hWnd
        SendMessage_(OldED2\hWnd,#WM_COPY,0,0)
      EndSelect
    Case #mnuClose
      DestroyWindow_(OldED1\hWnd)
      DestroyWindow_(OldED2\hWnd)
      While WindowEvent() : Wend
      CloseLibrary(1)
      End
    Case #mnuAbout
      MessageRequester("About","HEX-Viewer "+#version+Chr(10)+"©Copyright 2004"+Chr(10)+"coded by pcfreak"+Chr(10)+"Written in PureBasic."+Space(10)+Chr(10)+Chr(10)+"www.PureBasic.com",#MB_ICONINFORMATION)
    EndSelect
  Case #WM_DROPFILES
    *dropped=DropFiles()
    num.l=DragQueryFile_(*dropped,$FFFFFFFF,temp$,0)
    file.s=GetDropFile(*dropped,0)
    If FileSize(file)>-1
      CloseHex()
      LoadHexFile(file)
      StatusBarText(1,0,file)
    EndIf
    FreeDropFiles(*dropped)
  Case #PB_Event_CloseWindow
    DestroyWindow_(OldED1\hWnd)
    DestroyWindow_(OldED2\hWnd)
    While WindowEvent() : Wend
    CloseLibrary(1)
    End
  EndSelect
  
  Select GetFocus_()
  Case OldED1\hWnd : lastfocus=OldED1\hWnd
  Case OldED2\hWnd : lastfocus=OldED2\hWnd
  EndSelect
  
ForEver

Procedure CloseHex()
  ClearGadgetItemList(1)
  SendMessage_(OldED1\hWnd,#WM_SETTEXT,0,"")
  SendMessage_(OldED2\hWnd,#WM_SETTEXT,0,"")
EndProcedure

Procedure.l EditStreamCallback(dwCookie.l,pbBuff.l,cb.l,*pcb.LONG)
  Shared bufferpos.l,bufferend.l
  If bufferpos+cb>bufferend : cb=bufferend-bufferpos : EndIf
  CopyMemory(bufferpos,pbBuff,cb)
  bufferpos+cb
  *pcb\l=cb
  ProcedureReturn 0
EndProcedure

Procedure.l LoadHexFile(open.s)
  If ReadFile(0,open)
    hexfile\size=Lof(0)
    hexfile\pos=0
    hexfile\pieces=Round(Lof(0)/showmax,0)
    hexfile\file=open
    CloseFile(0)
    ShowPiece(0)
    ProcedureReturn 1
  Else
    ProcedureReturn 0
  EndIf
EndProcedure

Procedure SetRowIndex(gadget.l)
  SendMessage_(gadget,#EM_GETSEL,@start,@ende)
  sline.l=SendMessage_(gadget,#EM_LINEFROMCHAR,start,0)
  line.l =SendMessage_(gadget,#EM_LINEFROMCHAR,ende,0)
  SetGadgetState(1,line)
  If gadget=OldED1\hWnd
    x.l=(start-sline)/3+sline
    y.l=(ende-line)/3+line
    SendMessage_(OldED2\hWnd,#EM_SETSEL,x,y)
    SetGadgetText(4,"Page: "+Str(hexfile\pos)+"/"+Str(hexfile\pieces)+Chr(9)+"Position: "+Str(((ende-line)/3)+(hexfile\pos*showmax)))
  Else
    x.l=(start-sline)*3+sline
    y.l=(ende-line)*3+line
    SendMessage_(OldED1\hWnd,#EM_SETSEL,x,y)
    SetGadgetText(4,"Page: "+Str(hexfile\pos)+"/"+Str(hexfile\pieces)+Chr(9)+"Position: "+Str(ende-line+(hexfile\pos*showmax)))
  EndIf
EndProcedure

Procedure.l ShowPiece(change.l)
  Shared bufferpos.l,bufferend.l
  hexfile\pos+change
  If hexfile\pos>hexfile\pieces : hexfile\pos=0 : EndIf
  If hexfile\pos<0 : hexfile\pos=hexfile\pieces : EndIf
  If ReadFile(0,hexfile\file)
    FileSeek(0,hexfile\pos*showmax)
    CloseHex()
    *mem=GlobalAlloc_(#GMEM_ZEROINIT,showmax)
    ReadData(0,*mem,showmax)
    CloseFile(0)
    rtfbuffer.s="{\rtf1\ansi\ansicpg1252\deff0\deflang1031{\fonttbl{\f0\fnil\fcharset0 Fixedsys;}{\f1\fnil\fcharset0 MS Shell Dlg;}}"+Chr(13)+Chr(10)
    rtfbuffer+"{\colortbl ;\red"+Str(Red(colors(0)))+"\green"+Str(Green(colors(0)))+"\blue"+Str(Blue(colors(0)))+";\red"+Str(Red(colors(1)))+"\green"+Str(Green(colors(1)))+"\blue"+Str(Blue(colors(1)))+";}"+Chr(13)+Chr(10)
    rtfbuffer+"\viewkind4\uc1\pard\f0\fs20"
    rtfbuffer2.s="{\rtf1\ansi\ansicpg1252\deff0\deflang1031{\fonttbl{\f0\fnil\fcharset0 Fixedsys;}{\f1\fnil\fcharset0 MS Shell Dlg;}}"+Chr(13)+Chr(10)
    rtfbuffer2+"\viewkind4\uc1\pard\f0\fs20"
    For a=0 To (showmax/rowsize)-1
      address.l=(a*rowsize)+(hexfile\pos*showmax)
      AddGadgetItem(1,-1,RSet(Hex(address),8,"0"))
      i.l=0
      For b=0 To rowsize-1
        i!1
        *value.BYTE=*mem+(a*rowsize)+b
        rtfbuffer+"\cf"+Str(i+1)+" "+RSet(Hex(*value\b),2,"0")+" "
        Select *value\b
        Case 0
          *value\b=1
        Case 9
          *value\b=1
        Case 10
          *value\b=1
        Case 11
          *value\b=1
        Case 12
          *value\b=1
        Case 13
          *value\b=1
        Case 127
          *value\b=1
        EndSelect
        rtfbuffer2+"\'"+RSet(Hex(*value\b),2,"0")
        If (a*rowsize)+b=showmax Or (((a*rowsize)+b)+(hexfile\pos*showmax)+1)>=hexfile\size : Break 2 : EndIf
      Next
      rtfbuffer+"\par"+Chr(13)+Chr(10)
      rtfbuffer2+"\par"+Chr(13)+Chr(10)
    Next
    rtfbuffer+"}"
    rtfbuffer2+"}"
    *rtfmem=GlobalAlloc_(#GMEM_ZEROINIT,Len(rtfbuffer))
    CopyMemory(@rtfbuffer,*rtfmem,Len(rtfbuffer))
    bufferpos=*rtfmem : bufferend=*rtfmem+Len(rtfbuffer)
    stream.EDITSTREAM\pfnCallback=@EditStreamCallback()
    SendMessage_(OldED1\hWnd,#EM_STREAMIN,#SF_RTF,@stream)
    GlobalFree_(*rtfmem)
    *rtfmem=GlobalAlloc_(#GMEM_ZEROINIT,Len(rtfbuffer2))
    CopyMemory(@rtfbuffer2,*rtfmem,Len(rtfbuffer2))
    bufferpos=*rtfmem : bufferend=*rtfmem+Len(rtfbuffer2)
    stream.EDITSTREAM\pfnCallback=@EditStreamCallback()
    SendMessage_(OldED2\hWnd,#EM_STREAMIN,#SF_RTF,@stream)
    GlobalFree_(*rtfmem)
    GlobalFree_(*mem)
    ProcedureReturn 1
  Else
    ProcedureReturn 0
  EndIf
EndProcedure

Procedure.s GetAppPath()
  hMod = GetModuleHandle_(0)
  tmp$ = Space(255)
  GetModuleFileName_(hMod,@tmp$,255)
  filename$ = GetPathPart(tmp$)
  ProcedureReturn filename$
EndProcedure

Procedure.l DropFiles()
  ProcedureReturn EventwParam()
EndProcedure

Procedure GetNumDropFiles(*dropFiles)
  ProcedureReturn DragQueryFile_(*dropFiles,$FFFFFFFF,temp$, 0)
EndProcedure

Procedure.s GetDropFile(*dropFiles,index)
  bufferNeeded=DragQueryFile_(*dropFiles, index,0,0)
  For a = 1 To bufferNeeded : buffer$+" ": Next ; Short by one character!
  DragQueryFile_(*dropFiles,index,buffer$,bufferNeeded+1)
  ProcedureReturn buffer$
EndProcedure

Procedure FreeDropFiles(*dropFiles)
  DragFinish_(*dropFiles)
EndProcedure

Procedure AddTextED(gadget.l,text.s)
  SendMessage_(gadget,#EM_LINEINDEX,-1,0)
  len.l=SendMessage_(gadget,#WM_GETTEXTLENGTH,0,0)
  SendMessage_(gadget,#EM_SETSEL,len,len)
  SendMessage_(gadget,#EM_REPLACESEL,1,@text)
  SendMessage_(gadget,#EM_SETSEL,SendMessage_(gadget,#WM_GETTEXTLENGTH,0,0),SendMessage_(gadget,#WM_GETTEXTLENGTH,0,0))
EndProcedure

Procedure.s CopySel(gadget.l)
  SendMessage_(gadget,#WM_COPY,0,0)
  ProcedureReturn GetClipboardText()
EndProcedure

Procedure HideSelectionED(gadget.l,hide.l)
  SendMessage_(gadget,#EM_HIDESELECTION,hide!1,0)
  If hide=0
    SendMessage_(gadget,#EM_SETOPTIONS,#ECOOP_SET,#ECO_NOHIDESEL)
  EndIf
EndProcedure

Procedure SelectAllED(gadget.l,flag.l)
  If flag=1
    SendMessage_(gadget,#EM_SETSEL,0,-1)
  Else
    SendMessage_(gadget,#EM_SETSEL,-1,-1)
  EndIf
EndProcedure

Procedure SetBkColorED(gadget.l,color.l)
  col.LONG
  col\l=color
  SendMessage_(gadget,#EM_SETBKGNDCOLOR,0,color)
EndProcedure

Procedure SetColorED(gadget.l,color.l)
  styleformat.CHARFORMAT
  styleformat\cbSize=SizeOf(CHARFORMAT)
  styleformat\dwMask=#CFM_COLOR
  styleformat\crTextColor=color
  SendMessage_(gadget,#EM_SETCHARFORMAT,#SCF_SELECTION,@styleformat)
EndProcedure

Procedure SetReadOnlyED(gadget.l,flag.l)
  SendMessage_(gadget,#EM_SETREADONLY,flag,0)
EndProcedure

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = ----
; EnableXP
; DisableDebugger
