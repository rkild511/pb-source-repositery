; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6042&highlight=
; Author: aszid (fixed + updated for PB4.00 by blbltheworm)
; Date: 03. May 2003
; OS: Windows
; Demo: Yes

; Aszid's Packer v 0.9 
; 
;- Constants 
; 
#Main = 0 
#Status = 0 
#Pack = 1 
#Quit = 2 
#UnPack = 3 
#Progressbar = 4 
#Packfn = 5 
#Gadget_6 = 6 
#Pfname = 7 
#gadget_8 = 8 
#Comp = 9 

;- Arrays 
; 
Global Dim Dirlist$(10000) 
Global Dim Filelist$(10000) 
Global Dim Filecnt(10000) 

;- Global Variables 
; 
Global curfile$ 
Global prog.f 
Global Stepnum 
Global filenum 
Global gesFiles.l
Global dirnum 
Global fsz.f 
Global comp 
Global runone 
Global rootlen 

Procedure Open_Main() 
  If OpenWindow(#Main, 216, 0, 270, 225, "Packer", #PB_Window_TitleBar ) 
    If CreateGadgetList(WindowID(#Main)) 
      ListViewGadget(#Status, 10, 10, 230, 110) 
      ButtonGadget(#Pack, 10, 150, 70, 20, "Pack") 
      ButtonGadget(#Quit, 180, 150, 60, 20, "Quit") 
      ButtonGadget(#UnPack, 90, 150, 80, 20, "UnPack") 
      ProgressBarGadget(#Progressbar, 10, 125, 230, 15, 0, 100, #PB_ProgressBar_Smooth) 
      StringGadget(#Packfn, 100, 175, 140, 20, "") 
      TextGadget(#Gadget_6, 10, 175, 85, 15, "Pack Filename:") 
      StringGadget(#Pfname, 100, 200, 140, 20, "") 
      TextGadget(#gadget_8, 10, 200, 80, 15, "Pack Folder:") 
      TrackBarGadget(#Comp, 245, 10, 20, 210, 0, 9, #PB_TrackBar_Ticks | #PB_TrackBar_Vertical) 
    EndIf 
  EndIf 
EndProcedure 

Procedure AddStep(StepText$) 
  AddGadgetItem(#Status, -1, StepText$) 
  SetGadgetState(#Status, Stepnum) 
  Stepnum = Stepnum + 1 
EndProcedure 

Procedure GetList(root$, Start) 
If runone = 0 
  filenum = 0 
  dirnum = 0 
  rootlen = Len(root$) 
  runone = 1 
EndIf 
If Right(root$,1)<>"\" : root$+"\" : EndIf
  If ExamineDirectory(Start, root$, "") 
    While NextDirectoryEntry(Start) 
      Type=FileSize(root$+ DirectoryEntryName(Start))
        If Type = -2  ;Directory
          If DirectoryEntryName(Start) <> "." And DirectoryEntryName(Start) <> ".." 
            dirnum = dirnum + 1 
            If root$ = "" 
              Dirlist$(dirnum) = DirectoryEntryName(Start) + "\" 
              GetList(Dirlist$(dirnum), Start+1) 
            Else 
              Dirlist$(dirnum) = root$ + DirectoryEntryName(Start) + "\" 
              GetList(Dirlist$(dirnum), Start+1) 
            EndIf 
          EndIf 
        ElseIf Type >0 ;File 
            Filecnt(Start) = Filecnt(Start) + 1 
            gesFiles + 1 
            Filelist$(gesFiles) = root$ + DirectoryEntryName(Start) 
        EndIf 
      Wend
  EndIf 
EndProcedure 

Procedure stbar(spos, dpos) 
  prog = spos*100/fsz 
  SetGadgetState(#Progressbar, prog) 
  EventID=WindowEvent() 
  If EventID = #PB_Event_Gadget 
    Select EventGadget() 
    Case #Quit 
      a = ClosePack() 
      AddStep("Cancelling: " + curfile$) 
      a = DeleteFile(curfile$) 
      End 
    EndSelect 
  EndIf 
    ProcedureReturn 1 
EndProcedure 

Procedure makepack(packname$, folder$) 
  Compl = GetGadgetState(#Comp) 
  curfile$ = packname$ 

  If Right(folder$, 1) <> "\" 
    folder$ = folder$ + "\" 
  EndIf 

  GetList(folder$, 1) 
  b = CreateFile(1,"index.dir") 
  WriteStringN(1,Str(dirnum)) 

  For a = 1 To dirnum 
    WriteStringN(1,Right(Dirlist$(a),Len(Dirlist$(a)) - rootlen)) 
    WriteStringN(1,Str(Filecnt(a))) 
  Next

  CloseFile(1) 
  b = CreateFile(1,"index.fil") 
  WriteStringN(1,Str(gesFiles)) 

  For a = 1 To gesFiles
    WriteStringN(1,Right(Filelist$(a),Len(Filelist$(a)) - rootlen)) 
  Next

  CloseFile(1) 
  PackerCallback(@stbar()) 

  b = CreatePack(packname$) 
  AddStep("adding: index.dir") 
  b = AddPackFile("index.dir", Compl) 
  AddStep("adding: index.fil") 
  b = AddPackFile("index.fil", Compl) 

  b = DeleteFile("index.dir") 
  b = DeleteFile("index.fil") 

  For filenum  = 1 To gesFiles
    fsz = FileSize(Filelist$(filenum )) 
    AddStep("adding: " + Filelist$(filenum )) 
    b = AddPackFile(Filelist$(filenum ),Compl) 
  Next
  
  AddStep("Done!") 
  b = ClosePack() 
EndProcedure 

Procedure UnPack(packname$, dest$) 
  If Right(dest$,1) <> "\" 
    dest$ = dest$ + "\" 
  EndIf 
  If dest$ = "\" 
    dest$ = "" 
  EndIf 

  c = OpenPack(packname$) 

  memloca = NextPackFile() 
  FileLength = PackFileSize() 
  b = CreateFile(1,"index.dir") 
  WriteData(1,memloca,FileLength) 
  CloseFile(1) 

  memloca = NextPackFile() 
  FileLength = PackFileSize() 
  b = CreateFile(1,"index.fil") 
  WriteData(1,memloca,FileLength) 
  CloseFile(1) 

  b = OpenFile(1,"index.dir") 
  dirnum = Val(ReadString(1)) 

  For a = 1 To dirnum 
    Dirlist$(a) = ReadString(1) 
    Filecnt(a) = Val(ReadString(1)) 
  Next a 

  CloseFile(1) 
  b = DeleteFile("index.dir") 

  b = OpenFile(1,"index.fil") 
  filenum = Val(ReadString(1)) 
  
  For a = 1 To filenum 
    Filelist$(a) = ReadString(1) 
  Next a 

  CloseFile(1) 
  b = DeleteFile("index.fil") 

; make dirs 

  b = CreateDirectory(dest$) 
  For a = 1 To dirnum 
    b = CreateDirectory(dest$ + Dirlist$(a)) 
  Next a 
  
; decompress files to the proper dirs 
  Debug filenum
  For a = 1 To filenum 
    AddStep("Decompressing: " + Filelist$(a)) 
    memloca = NextPackFile() 
    FileLength = PackFileSize() 
    b = CreateFile(1,dest$ + Filelist$(a)) 
    WriteData(1,memloca,FileLength) 
    CloseFile(1) 
  Next a 
  b = ClosePack() 

EndProcedure 

;- Main Program 
; 

Open_Main() 

SetGadgetState(#Comp,9) 

Repeat 
  Event = WaitWindowEvent() 
  If Event = #PB_Event_Menu 
    Select EventMenu() 
    EndSelect 
  EndIf 
  If Event = #PB_Event_Gadget 
    Select EventGadget() 
      Case #Pack 
        packfil$ = GetGadgetText(#Packfn) 
        If UCase(Left(packfil$,5)) <> ".PACK" 
          packfil$ = packfil$ + ".pack" 
        EndIf 
        pfolder$ = GetGadgetText(#Pfname) 
        makepack(packfil$,pfolder$) 
        runone = 0 
      Case #UnPack 
        packfil$ = GetGadgetText(#Packfn) 
        If UCase(Left(packfil$,5)) <> ".PACK" 
          packfil$ = packfil$ + ".pack" 
        EndIf 
        pfolder$ = GetGadgetText(#Pfname) 
        UnPack(packfil$,pfolder$) 
        AddStep("Done!") 
      Case #Quit 
        CloseWindow(#Main) 
        End 
    EndSelect 
  EndIf 
Until Event = #PB_Event_CloseWindow 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = --
