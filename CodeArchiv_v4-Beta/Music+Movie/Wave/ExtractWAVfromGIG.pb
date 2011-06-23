; English forum: http://www.purebasic.fr/english/viewtopic.php?t=9168&highlight=
; Author: Psychophanta (updated for PB4.00 by blbltheworm + Andre)
; Date: 16. January 2004
; OS: Windows
; Demo: No

; GigaSampler (.GIG) files to .WAV extraction.
; A fast made program to simply just extract PCM .WAV from .GIG files.

Global len.l 

Procedure.b CheckChunk(a.s) 
  loc.l=Loc(0) 
  For t.l=0 To Len(a.s)-1 
    If ReadByte(0)<>PeekB(@a.s+t):FileSeek(0,loc.l):ProcedureReturn 0:EndIf 
  Next 
  len.l=ReadLong(0) 
  ProcedureReturn 1 
EndProcedure 

Procedure.b CheckChunkandGotoNextChunk(a.s) 
  If CheckChunk(a.s):FileSeek(0,Loc(0)+len):ProcedureReturn 1:EndIf 
  ProcedureReturn 0 
EndProcedure 

Procedure.s parse(n.l) 
  While n.l>0 
    Read t$ 
    If CheckChunkandGotoNextChunk(t$)=0:ProcedureReturn t$+" not matched":EndIf 
    n.l-1 
  Wend 
  ProcedureReturn "OK" 
EndProcedure 

Procedure.b MyIsFilename(a.s) 
  If CheckFilename(a.s) 
    For t.l=0 To Len(a.s)-1 
      b.w=PeekB(@a.s+t) 
      If b.w<=$1E Or b.w>=$7F:ProcedureReturn 0:EndIf 
    Next 
    ProcedureReturn 1 
  EndIf 
  ProcedureReturn 0 
EndProcedure 

;-INITS: 
hWnd.l=OpenWindow(0,GetSystemMetrics_(#SM_CYSCREEN)/3,GetSystemMetrics_(#SM_CXSCREEN)/6,300,450,".GIG to .WAV",#PB_Window_SystemMenu) 
If hWnd.l=0 
  MessageBox_(hWnd,"Something fails: i can't open window","Error",#MB_ICONSTOP) 
  End 
EndIf 

;CreateGadgetList: 
If CreateGadgetList(hWnd)=0 
  MessageBox_(hWnd,"Something fails: i can't create gadgetlist","Error",#MB_ICONSTOP) 
  End 
EndIf 

ButtonGadget(1,1,8,298,40,"Drag .GIG file") 
TreeGadget(2,1,50,298,400) 
DragAcceptFiles_(GadgetID(2),#True)  ;<-- this makes accept drag'n'drop on it 

Structure PCMsample 
  name.s 
  fmt_chunk.l;<-location to "fmt " chunk inside .gig file 
  datachunk.l;<-location to "data" chunk inside .gig file 
EndStructure 

Structure gigsample 
  group.s 
  name.s 
  comment.s[4] 
EndStructure 

Global NewList s.PCMsample() 

;-MAIN: 
Repeat 
  EventID.l=WaitWindowEvent() 
  Gosub Interact 
Until EventID=#PB_Event_CloseWindow 
End 

;-Interacting: 
Interact: 
  If EventID.l=#WM_DROPFILES ;<---- When some file or folder was dropped to main window 
    dropped.l=EventwParam()  ;<--retrieves the handle to structure for dropped file. 
    GetCursorPos_(@coord.POINT) 
    bufferNeeded=DragQueryFile_(dropped.l,0,0,0)  ;bufferNeeded = space in bytes in mem for to store first dropped complete filename (with path) 
    buffer$=Space(bufferNeeded) ;fill space characters. 
    DragQueryFile_(dropped.l,0,buffer$,bufferNeeded+1) ;now we have the string of file including complete path (in buffer$). 
    DragFinish_(dropped.l) 
    path$=GetPathPart(buffer$) 
    nombre$=GetFilePart(buffer$) 
    If buffer$<>"" 
      If ReadFile(0,buffer$)=0 
        SetGadgetText(1,"can't open file "+nombre$):Return 
      EndIf 
      o.gigsample 
      ClearList(s.PCMsample()) 
      Gosub parse 
      CloseFile(0) 
    EndIf 
  ElseIf EventID=#PB_Event_Gadget 
    If EventGadget()=1 And CountList(s.PCMsample());<-button pressed 
      If ReadFile(0,buffer$)=0 
        SetGadgetText(1,"can't open file"+Chr(10)+nombre$):Return 
      EndIf 
      While MyIsFilename(o.gigsample\name)=0 
        o.gigsample\name=InputRequester("Not a valid name","Input new name:",o.gigsample\name) 
      Wend 
      If FileSize(path$+o.gigsample\name)<>-1;<-if already exists 
        If MessageRequester("this directory already exists","add here?",#PB_MessageRequester_YesNo)=#IDNO:CloseFile(0):Return:EndIf 
      ElseIf CreateDirectory(path$+o.gigsample\name)=0 
        MessageRequester("can't create folder","can't create folder"):CloseFile(0):Return 
      EndIf 
      ForEach s.PCMsample() 
        While MyIsFilename(s.PCMsample()\name)=0 
          s.PCMsample()\name=InputRequester("Not a valid name","Input new name:",s.PCMsample()\name) 
        Wend 
        If FileSize(path$+o.gigsample\name+"\"+s.PCMsample()\name+".wav")<>-1;<-if already exists 
          s.PCMsample()\name+"_" 
        EndIf 
        If CreateFile(1,path$+o.gigsample\name+"\"+s.PCMsample()\name+".wav")=0 
          MessageRequester("can't create file","can't create file"):CloseFile(0):Return 
        EndIf 
        WriteLong(1,$46464952);<-"RIFF" 
        WriteLong(1,$00000000);<-file lenght-8 
        WriteLong(1,$45564157);<-"WAVE" 
        FileSeek(0,s.PCMsample()\fmt_chunk+4):fmt_len.l=ReadLong(0)+8 
        FileSeek(0,s.PCMsample()\datachunk+4):datalen.l=ReadLong(0)+8 
        *b0=ReAllocateMemory(0,fmt_len.l) 
        *b1=ReAllocateMemory(1,datalen.l) 
        If *b0=0 Or *b1=0:CloseFile(1):CloseFile(0):Return:EndIf 
        FileSeek(0,s.PCMsample()\fmt_chunk):ReadData(0,*b0,fmt_len.l) 
        FileSeek(1,12):WriteData(1,*b0,fmt_len.l) 
        FileSeek(0,s.PCMsample()\datachunk):ReadData(0,*b1,datalen.l) 
        WriteData(1,*b1,datalen.l) 
        FileSeek(1,4):WriteLong(1,Lof(1)-8) 
        CloseFile(1) 
      Next 
      CloseFile(0) 
    EndIf 
  EndIf 
Return 

;-SUBROUTINES: 
parse: 
  Restore inicio 
  Read test$;<-"RIFF" 
  If CheckChunkandGotoNextChunk(test$)=0:SetGadgetText(1,test$+" not matched"):Return:EndIf 
  If Eof(0)=0:SetGadgetText(1,"wrong chunk lengh: "+test$):Return:EndIf 
  FileSeek(1,8) 
  Read test$;<-"DLS LIST" 
  If CheckChunkandGotoNextChunk(test$)=0:FileSeek(1,8):Goto parsecolh:EndIf 
  p.s=parse(3):If p.s<>"OK":SetGadgetText(1,p.s):Return:EndIf;<-parse "vers","cohl","dlid" 
  Read test$;<-"LIST" 
  If CheckChunk(test$)=0:SetGadgetText(1,test$+" not matched"):Return:EndIf 
  pos.l=Loc(1)+len.l;<-guardar esta posición, que apunta a "LIST" 
  Read test$;<-"linsLIST" 
  If CheckChunk(test$)=0:SetGadgetText(1,test$+" not matched"):Return:EndIf;<-ignore "linsLIST" 
  Read test$;<-"ins LIST" 
  If CheckChunk(test$)=0:SetGadgetText(1,test$+" not matched"):Return:EndIf;<-ignore "ins LIST" 
  Read test$;<-"INFOINAM" 
  If CheckChunk(test$)=0:SetGadgetText(1,test$+" not matched"):Return:EndIf 
  o.gigsample\name=RTrim(ReadString(1)) 
  FileSeek(1,pos.l);<- go to "LIST" chunk 
  Read test$;<-"LIST" 
  If CheckChunk(test$)=0:SetGadgetText(1,test$+" not matched"):Return:EndIf 
  pos.l=Loc(1)+len.l;<-guardar esta posición que apunta a "ptbl" 
  Read test$;<-"3griLIST" 
  If CheckChunk(test$)=0:SetGadgetText(1,test$+" not matched"):Return:EndIf;<-ignore "3griLIST" 
  Read test$;<-"3gnl3gnm" 
  If CheckChunk(test$)=0:SetGadgetText(1,test$+" not matched"):Return:EndIf 
  o.gigsample\group=RTrim(ReadString(1)) 
  FileSeek(1,pos.l);<-go to "ptbl" chunk 
  Read test$;<-"ptbl" 
  While ReadByte(1)=0:Wend:FileSeek(1,Loc(1)-1) 
  If CheckChunkandGotoNextChunk(test$)=0:SetGadgetText(1,test$+" not matched"):Return:EndIf 
  Read test$;<-"LIST" <- contains the size of entire samples chunk 
  If CheckChunk(test$)=0:SetGadgetText(1,test$+" not matched"):Return:EndIf;<-ignore it 
  Read test$;<-"wvplLIST" <- size of .gig formatted sample 
  If CheckChunk(test$)=0:SetGadgetText(1,test$+" not matched"):Return:EndIf 
  Repeat 
    Restore buc 
    pos.l=Loc(1)+len.l;<-guardar esta posición, que apunta a "LIST" 
    Read test$;<-"wavefmt " <- standard .wav "fmt " chunk format. 
    If CheckChunkandGotoNextChunk(test$)=0:SetGadgetText(1,test$+" not matched"):Return:EndIf 
    AddElement(s.PCMsample()) 
    s.PCMsample()\fmt_chunk=Loc(1)-len.l-8;<-guardar esta posición, que apunta al "fmt " del pcm (20 bytes normalmente) 
    Read test$;<- "LIST" 
    If CheckChunkandGotoNextChunk(test$)=0:SetGadgetText(1,test$+" not matched"):Return:EndIf 
    FileSeek(1,Loc(1)-len.l);<-ignore "LIST" 
    Read test$;<-"INFOINAM" 
    If CheckChunk(test$)=0:SetGadgetText(1,test$+" not matched"):Return:EndIf 
    pos1.l=Loc(1)+len.l 
    s.PCMsample()\name=RTrim(ReadString(1)) 
    FileSeek(1,pos1.l) 
    Read test$;<-"data" 
    If CheckChunkandGotoNextChunk(test$)=0:SetGadgetText(1,test$+" not matched"):Return:EndIf 
    s.PCMsample()\datachunk=Loc(1)-len.l-8;<-guardar esta posición, que apunta al "data" del pcm 
    FileSeek(1,pos.l):If Eof(0):Break:EndIf 
    Read test$;<-"LIST" 
    If CheckChunk(test$)=0 
      If CheckChunk("einf")=0:SetGadgetText(1,"einf or "+test$+" not matched"):Return:EndIf 
      Break 
    EndIf 
  ForEver 
  ClearGadgetItemList(2) 
  SetGadgetText(1,Str(CountList(s.PCMsample()))+" samples found. PUSH here to EXTRACT") 
  AddGadgetItem(2,-1,o.gigsample\name,0,0) 
  AddGadgetItem(2,-1,o.gigsample\group,0,1) 
  ForEach s.PCMsample() 
    AddGadgetItem(2,-1,s.PCMsample()\name,0,2) 
  Next 
  For n.l=0 To CountGadgetItems(2)-1 
    SetGadgetItemState(2,n,#PB_Tree_Expanded) 
  Next 
Return 

parsecolh:Restore colhdata 
  Read test$;<-"DLS colh" 
  If CheckChunkandGotoNextChunk(test$)=0:SetGadgetText(1,test$+" not matched"):Return:EndIf 
  Read test$;<-"LIST" 
  If CheckChunk(test$)=0:SetGadgetText(1,test$+" not matched"):Return:EndIf 
  pos.l=Loc(1)+len.l;<-guardar esta posición, que apunta a "ptbl" 
  Read test$;<- "linsLIST" 
  If CheckChunk(test$)=0:SetGadgetText(1,test$+" not matched"):Return:EndIf;<-ignore "linsLIST" 
  p.s=parse(4):If p.s<>"OK":SetGadgetText(1,p.s):Return:EndIf;<-parse "ins insh","LIST","LIST","LIST" 
  FileSeek(1,Loc(1)-len.l);<-ignore "LIST" 
  Read test$;<-"INFOINAM" 
  If CheckChunk(test$)=0:SetGadgetText(1,test$+" not matched"):Return:EndIf 
  o.gigsample\name=RTrim(ReadString(1)) 
  FileSeek(1,pos.l) 
  Read test$;<-"ptbl" 
  If CheckChunkandGotoNextChunk(test$)=0:SetGadgetText(1,test$+" not matched"):Return:EndIf 
  Read test$;<-"LIST" <- contains the size of entire samples chunk 
  If CheckChunk(test$)=0:SetGadgetText(1,test$+" not matched"):Return:EndIf;<-ignore it 
  Read test$;<-"wvplLIST" <- size of .gig formatted sample 
  If CheckChunk(test$)=0:SetGadgetText(1,test$+" not matched"):Return:EndIf 
  Repeat:Restore buc2 
    Read test$;<-"wavefmt " <- .wav "fmt " chunk format. 
    If CheckChunk(test$)=0 
      If CheckChunk("INFOICMT")=0:SetGadgetText(1,"INFOICMT not matched"):Return:EndIf 
      pos1.l=Loc(1)+len.l 
      o.gigsample\comment[0]=RTrim(ReadString(1)) 
      FileSeek(1,pos1.l) 
      If CheckChunk("ICOP")=0:SetGadgetText(1,"ICOP not matched"):Return:EndIf 
      pos1.l=Loc(1)+len.l 
      o.gigsample\comment[1]=RTrim(ReadString(1)) 
      FileSeek(1,pos1.l) 
      If CheckChunk("INAM")=0:SetGadgetText(1,"INAM not matched"):Return:EndIf 
      pos1.l=Loc(1)+len.l 
      o.gigsample\comment[2]=RTrim(ReadString(1)) 
      FileSeek(1,pos1.l) 
      If CheckChunk("ISFT")=0:SetGadgetText(1,"ISFT not matched"):Return:EndIf 
      o.gigsample\comment[3]=RTrim(ReadString(1)) 
      Break 
    EndIf 
    AddElement(s.PCMsample()) 
    s.PCMsample()\fmt_chunk=Loc(1)-8;<-guardar esta posición, que apunta al "fmt " del pcm (20 bytes normalmente) 
    FileSeek(1,Loc(1)+len.l) 
    Read test$;<-"wsmp" 
    If CheckChunkandGotoNextChunk(test$)=0:SetGadgetText(1,test$+" not matched"):Return:EndIf 
    Read test$;<-"data" 
    If CheckChunkandGotoNextChunk(test$)=0:SetGadgetText(1,test$+" not matched"):Return:EndIf 
    s.PCMsample()\datachunk=Loc(1)-len.l-8;<-guardar esta posición, que apunta al "data" del pcm 
    Read test$;<- "LIST" 
    If CheckChunk(test$)=0:SetGadgetText(1,test$+" not matched"):Return:EndIf;<-ignore "LIST" 
    Read test$;<-"INFOINAM" 
    If CheckChunk(test$)=0:SetGadgetText(1,test$+" not matched"):Return:EndIf 
    pos1.l=Loc(1)+len.l 
    s.PCMsample()\name=RTrim(ReadString(1)) 
    FileSeek(1,pos1.l) 
    Read test$;<- "LIST" (size of sample) 
    If CheckChunk(test$)=0:SetGadgetText(1,test$+" not matched"):Return:EndIf 
  ForEver;Until Eof(0) 
  ClearGadgetItemList(2) 
  SetGadgetText(1,Str(CountList(s.PCMsample()))+" samples found. PUSH here to EXTRACT") 
  AddGadgetItem(2,-1,o.gigsample\name,0,0) 
  ForEach s.PCMsample() 
    AddGadgetItem(2,-1,s.PCMsample()\name,0,1) 
  Next 
  For n.l=0 To 3:AddGadgetItem(2,-1,o.gigsample\comment[n.l],0,0):Next 
  For n.l=0 To CountGadgetItems(2)-1 
    SetGadgetItemState(2,n,#PB_Tree_Expanded) 
  Next 
Return 

DataSection 
  inicio: 
  Data.s "RIFF","DLS LIST","vers","colh","dlid" 
  Data.s "LIST","linsLIST","ins LIST","INFOINAM" 
  Data.s "LIST","3griLIST","3gnl3gnm" 
  Data.s "ptbl","LIST" 
  Data.s "wvplLIST" 
  buc: 
  Data.s "wavefmt ","LIST","INFOINAM","data" 
  Data.s "LIST" 
  colhdata: 
  Data.s "DLS colh","LIST","linsLIST","ins insh","LIST","LIST","LIST","INFOINAM" 
  Data.s "ptbl","LIST","wvplLIST" 
  buc2: 
  Data.s "wavefmt ","wsmp","data","LIST","INFOINAM","LIST" 
EndDataSection 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger
