; German forum:
; Author: Unknown  (updated for PB3.92+ by Lars, updated for PB4.00 by blbltheworm + Andre)
; Date: 21. February 2003
; OS: Windows
; Demo: Yes

Global File$

Procedure Split()
  SetGadgetText(13,"Stop")
  HideGadget(11,0)
  HideGadget(12,0)
  File$=GetGadgetText(5)
  ReadPos=0
  PartNr=1
  PartSize=Len(GetFilePart(File$))+Len(Str(FileSize(File$)))+2
  SplitSize=Val(GetGadgetText(8))
  CreateFile(1,GetPathPart(File$)+"1")
  WriteString(1,Chr(Len(GetFilePart(File$)))+GetFilePart(File$)+Chr(Len(Str(FileSize(File$))))+Str(FileSize(File$)))
  ReadFile(0,File$)
  *mem = AllocateMemory(32000)
  
  While ReadPos<FileSize(File$)
    Select WindowEvent()
      Case #PB_Event_Gadget
      Select EventGadget()
      Case 13
        ReadPos=FileSize(File$)
      EndSelect
    EndSelect
    NewState=Int(100/FileSize(File$)*ReadPos)
    If NewState<>GetGadgetState(11)
      SetGadgetState(11,NewState)
      SetGadgetText(12,Str(NewState)+"%")
    EndIf
    If ReadPos>FileSize(File$)-32000
      ReadLength=FileSize(File$)-ReadPos
    Else
      ReadLength=32000
    EndIf
    If ReadLength>SplitSize-PartSize
      ReadLength=SplitSize-PartSize
    EndIf
    ReadData(0,*mem,ReadLength)
    ReadPos=ReadPos+ReadLength
    WriteData(1,*mem,ReadLength)
    PartSize=PartSize+ReadLength
    If PartSize=SplitSize
      PartSize=0
      PartNr=PartNr+1
      CloseFile(1)
      CreateFile(1,GetPathPart(File$)+Str(PartNr))
    EndIf
  Wend
  FreeMemory(*mem)
  CloseFile(0)
  CloseFile(1)
  SetGadgetText(13,"Start")
  HideGadget(11,1)
  HideGadget(12,1)
EndProcedure

Procedure Combine()
  SetGadgetText(13,"Stop")
  HideGadget(11,0)
  HideGadget(12,0)
  File$=GetGadgetText(5)
  ReadFile(0,File$)
  n=ReadByte(0)
  Filename$=""
  For a=1 To n
    Byte=ReadByte(0)
    Filename$=Filename$+Chr(Byte)
  Next
  n=ReadByte(0)
  SizeOfFile$=""
  For a=1 To n
    Byte=ReadByte(0)
    SizeOfFile$=SizeOfFile$+Chr(Byte)
  Next
  CreateFile(1,GetPathPart(File$)+Filename$)
  PartNr=1
  PartSize=FileSize(File$)
  ReadPos=Len(Filename$)+Len(SizeOfFile$)+2
  WritePos=0
  *mem = AllocateMemory(32000)
  While WritePos<Val(SizeOfFile$)
    Select WindowEvent()
      Case #PB_Event_Gadget
      Select EventGadget()
      Case 13
        WritePos=Val(SizeOfFile$)
      EndSelect
    EndSelect
    NewState=Int(100/Val(SizeOfFile$)*WritePos)
    If NewState<>GetGadgetState(11)
      SetGadgetState(11,NewState)
      SetGadgetText(12,Str(NewState)+"%")
    EndIf
    If ReadPos=PartSize
      ReadPos=0
      PartNr=PartNr+1
      CloseFile(0)
      ReadFile(0,GetPathPart(File$)+Str(PartNr))
      PartSize=FileSize(GetPathPart(File$)+Str(PartNr))
    EndIf
    If ReadPos>PartSize-32000
      ReadLength=PartSize-ReadPos
    Else
      ReadLength=32000
    EndIf
    ReadData(0,*mem,ReadLength)
    ReadPos=ReadPos+ReadLength
    WriteData(1,*mem,ReadLength)
    WritePos=WritePos+ReadLength
  Wend
  FreeMemory(*mem)
  CloseFile(0)
  CloseFile(1)
  Result=MessageRequester("Frage","Datei wurde Zusammengefügt. Sollen die Dateiteile gelöscht werden?",#MB_ICONQUESTION|#PB_MessageRequester_YesNo)
  If Result=6
    For n=1 To PartNr
      DeleteFile(GetPathPart(File$)+Str(n))
    Next
  EndIf
  SetGadgetText(13,"Start")
  HideGadget(11,1)
  HideGadget(12,1)
EndProcedure

Procedure InputControl()
  If Len(GetGadgetText(8))>10
    SetGadgetText(8,Mid(GetGadgetText(8),1,10))
  EndIf
  If Val(GetGadgetText(8))=1 And GetGadgetText(9)="Bytes"
    SetGadgetText(9,"Byte")
  EndIf
  If Val(GetGadgetText(8))<>1 And GetGadgetText(9)="Byte"
    SetGadgetText(9,"Bytes")
  EndIf
EndProcedure

Procedure ButtonControl()
  Select WindowEvent()
  Case #PB_Event_CloseWindow
    End
  Case #PB_Event_Gadget
    Select EventGadget()
    Case 1
      DisableGadget(7,0)
      DisableGadget(8,0)
      DisableGadget(9,0)
    Case 2
      DisableGadget(7,1)
      DisableGadget(8,1)
      DisableGadget(9,1)
    Case 6
      If GetGadgetState(1)=1
         Title$="Datei suchen"
         Pattern$="Alle Dateien | *"
      Else
        Title$="1. Dateiteil suchen"
        Pattern$="Dateiteile | 1"
      EndIf
      If FileSize(GetGadgetText(5))<>-1
        File$=OpenFileRequester(Title$,GetPathPart(GetGadgetText(5)),Pattern$,0)
      Else
        File$=OpenFileRequester(Title$,"",Pattern$,0)
      EndIf
      If File$<>""  
        SetGadgetText(5,File$)
        If GetGadgetState(1)=1
          SetGadgetText(8,Str(FileSize(File$)))
        EndIf
      EndIf
    Case 13
      If FileSize(GetGadgetText(5))>-1
        If GetGadgetState(1)=1
          Split()
        Else
          Combine()
        EndIf
      EndIf
    EndSelect
  EndSelect
EndProcedure

OpenWindow(0,0,0,320,240,"Datei Teiler",#PB_Window_SystemMenu|#PB_Window_ScreenCentered)
CreateGadgetList(WindowID(0))
Frame3DGadget(0,10,10,300,50,"Aktion",0)
OptionGadget(1,60,30,50,15,"Teilen")
OptionGadget(2,160,30,100,15,"Zusammenfügen")
Frame3DGadget(3,10,70,300,80,"",0)
TextGadget(4,20,90,50,15,"Datei:")
StringGadget(5,60,87,160,20,"")
ButtonGadget(6,235,87,60,20,"Suchen...")
TextGadget(7,20,121,50,15,"Teilgröße:")
StringGadget(8,80,118,68,20,"",#PB_String_Numeric)
TextGadget(9,152,121,30,20,"Bytes")
ProgressBarGadget(11,30,170,250,15,0,100,#PB_ProgressBar_Smooth)
TextGadget(12,285,170,30,15,"")
ButtonGadget(13,120,200,80,25,"Start",#PB_Button_Default)

SetGadgetState(1,1)
HideGadget(11,1)
HideGadget(12,1)

Repeat
  InputControl()
  ButtonControl()
ForEver

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP
; UseIcon = C:\Programme\Blitz Basic\Programmers Tools\Microangelo\Split.ico
; Executable = C:\Programme\PureBasic\Datei Teiler.exe
; DisableDebugger