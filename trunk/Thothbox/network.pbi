Procedure.b Create_Directory_old(directory.s)
  ;
  Define bindex.l
  Define bnumbs.l
  Define bsplit.s
  Define stemps.s
  Repeat
    bindex + 1
    bsplit = StringField(directory, bindex, "\")
    If bsplit <> ""
      If bindex = 1
        stemps + bsplit
      Else
        stemps + "\" + bsplit
      EndIf
      If FileSize(stemps) = -2
        bnumbs + 1
      Else
        If CreateDirectory(stemps) <> 0
          bnumbs + 1
        EndIf
      EndIf
    EndIf
  Until bsplit = ""
  bindex - 1
  If bindex = bnumbs
    ProcedureReturn #True
  EndIf
  ProcedureReturn #False
EndProcedure


Procedure.b DirectoryCreate(dossier$)
      ; Il est préférable de mettre le code ci-dessous parce que pour MakeSureDirectoryPathExists_
      ; Si l'on met : MakeSureDirectoryPathExists_(toto\titi\vovo\aze) cela ne créer pas le repertoire
      ; aze considérant certainement que c'est un fichier.
      If Right(dossier$, 1) <> "\"
            dossier$ + "\"
      EndIf
     
      CompilerSelect #PB_Compiler_OS 
                 
            CompilerCase #PB_OS_Windows
                  Debug "Windows Use:"+dossier$
                  ; Sous Windows autant utiliser une API existante.
                  ProcedureReturn MakeSureDirectoryPathExists_(dossier$)
                 
                 
            CompilerCase #PB_OS_Linux Or #PB_OS_MacOS
                  Debug "Linux Mac Use"
                  Protected indexDossierActuel.b
                  Protected nbDossiersExistants.b
                 
                  Protected nomDossier$
                  Protected nomCheminComplet$
                 
                  Repeat
                        indexDossierActuel + 1
                        Debug "indexDossierActuel DEBUT : "+ Str(indexDossierActuel)
                       
                        nomDossier$ = StringField(dossier$, indexDossierActuel, "\")
                        Debug "nomDossier$ : "+ nomDossier$
                       
                        If nomDossier$ <> ""
                              ; On a un dossier principal et pas de sous-dossier.
                              If indexDossierActuel = 1
                                    nomCheminComplet$ + nomDossier$
                                    Debug Str(indexDossierActuel) +" nomCheminComplet$ + nomDossier$ >>> " + nomCheminComplet$
                                   
                              Else
                                    nomCheminComplet$ + "\" + nomDossier$
                                    Debug Str(indexDossierActuel) +" nomCheminComplet$ + nomDossier$ >>> " + nomCheminComplet$
                                   
                              EndIf
                             
                              ; Si c'est un repertoire et qu'il existe alors on incremente nbDossiersExistants
                              If FileSize(nomCheminComplet$) = -2
                                    nbDossiersExistants + 1
                                   
                              Else
                                    ; Si le dossier n'existe pas, alors on le créer et si le dossier a bien été créé,
                                    ; alors on incremente nbDossiersExistants
                                    If CreateDirectory(nomCheminComplet$) <> 0
                                          nbDossiersExistants + 1
                                         
                                    EndIf
                              EndIf
                             
                        EndIf
                       
                  Until nomDossier$ = ""
                 
                  ; Pour avoir le vrai nombre de dossier créés, on enlève 1
                  indexDossierActuel - 1
                  Debug "indexDossierActuel FIN : "+ Str(indexDossierActuel)
                 
                  ; Si indexDossierActuel = nbDossiersExistants, alors c'est que tout les dossiers on bien été créés
                  ; et donc la procedure retourne 1
                  If indexDossierActuel = nbDossiersExistants
                        ProcedureReturn #True
                  EndIf
                  ProcedureReturn #False
      CompilerEndSelect
EndProcedure


Procedure myCallBack(l.i,max.i)
  SetGadgetState(#gdt_bar,Int(1000*gp\progressBarPointer/gp\progressBarMax))
 ;gp\progressBarPointer+l
EndProcedure
;http://www.koakdesign.info/thothbox/thothbox.php

Procedure OpenWaitWindow()
  OpenWindow(#win_Wait,0,0,320,200,"",#PB_Window_WindowCentered,WindowID(0))
  TextGadget(#gdt_waitTxt,20,20,320,20,"Please Wait...")
  StickyWindow(#win_Wait,1)
  DisableWindow(#win_Main,1)
EndProcedure

Procedure CloseWaitWindow()
  CloseWindow(#win_Wait)
  DisableWindow(#win_Main,0)
EndProcedure

Procedure checkServer()
  Protected http.HTTP_Query
  If gp\useProxy=#True
    HTTP_proxy(@http,gp\proxy\host,gp\proxy\port,gp\proxy\login,gp\proxy\password)
  EndIf
  HTTP_query(@http, #HTTP_METHOD_POST, gp\server)
  HTTP_addQueryHeader(@http, "User-Agent", "ThothBox")
  HTTP_addPostData(@http, "info", "")
  HTTP_sendQuery(@http)
  HTTP_receiveRawData(@http)
  Protected txt.s,nbline.l,z.l,line.s,sepa.l,key.s,value.s
  If http\data<>0
    ;MessageRequester("Server Info",PeekS(http\data,MemorySize(http\data),#PB_Ascii))
    ClearMap(gp\serverInfos())
    txt.s=PeekS(http\data,MemorySize(http\data),#PB_Ascii);
    nbline=CountString(txt,#LFCR$)
    Debug nbline
    For z=1 To nbline
      line=ReplaceString(line,#LFCR$,#CR$)
      line=StringField(txt, z, #CR$)
      sepa=FindString(line,":",0)
      If sepa>0
        key=Trim(Mid(line,0,sepa-1))
        Debug key
        Debug value
        value=Trim(Mid(line,sepa+1,Len(line)-sepa))
        gp\serverInfos(key)=value
      EndIf
    Next
    If FindMapElement(gp\serverInfos(), "version")
      ProcedureReturn #True
    Else
      ProcedureReturn #False
    EndIf
  Else
    ;Debug PeekS(http\header,MemorySize(http\header),#PB_Ascii);
    MessageRequester(t("Error"),t("Can't Connect with server"))
    ProcedureReturn #False
  EndIf

EndProcedure

Procedure threadCheckServer(n)
  If checkServer()
    SetMenuTitleText(#win_Main,1,t("Online"))
    SetGadgetState(#gdt_OffOnLine,ImageID(1))
    If n=#True
      MessageRequester(t("Server"),gp\serverInfos("message"))
    EndIf
  Else
    SetGadgetState(#gdt_OffOnLine,ImageID(2))
    SetMenuTitleText(#win_Main,1,t("Offline"))
  EndIf
  
EndProcedure

Procedure serverSearch(keywords.s)
  Protected http.HTTP_Query
  
  If gp\useProxy=#True
    HTTP_proxy(@http,gp\proxy\host,gp\proxy\port,gp\proxy\login,gp\proxy\password)
  EndIf
  HTTP_query(@http, #HTTP_METHOD_POST, gp\server)
  HTTP_addQueryHeader(@http, "User-Agent", "ThothBox")
  HTTP_addPostData(@http, "search", keywords)
  HTTP_sendQuery(@http)
  HTTP_receiveRawData(@http)
  ;Debug PeekS(http\header,MemorySize(http\header),#PB_Ascii);
  If http\data<>0
    ;Debug PeekS(http\data,MemorySize(http\data),#PB_Ascii);
    Protected txt.s,nbline.l,z.l,line.s,sepa.l,key.s,value.s,id.l
    ClearGadgetItems(#gdt_result)
    txt.s=PeekS(http\data,MemorySize(http\data),#PB_Ascii);
    nbline=CountString(txt,#LFCR$)
    For z=1 To nbline
      line=ReplaceString(StringField(txt, z, #LFCR$),Chr(13),"")
      
      ;first line header Data With name
      If z=1
        Debug line
        Protected d.i, Dim key2col.l(10)
        For d=0 To 5:
          key2col(d)=1
        Next
        For d=1 To CountString(line,";")+1
          Debug LCase(StringField(line, d, ";"))
          Select LCase(StringField(line, d, ";"))
            Case "id"
              key2col(0)=d
            Case "codename"
              key2col(1)=d
            Case "author"
              key2col(2)=d
            Case "date"
              key2col(3)=d
            Case "category"
              key2col(4)=d
            Case "compatibility"
              key2col(5)=d
          EndSelect
        Next
      Else
      AddGadgetItem(#gdt_result,z-2, StringField(line, key2col(1), ";")+Chr(10)+StringField(line, key2col(4), ";")+Chr(10)+StringField(line, key2col(2), ";")+Chr(10)+StringField(line, key2col(3), ";")+Chr(10)+StringField(line, key2col(5), ";"))
      id=Val(StringField(line, key2col(0), ";"))
      SetGadgetItemData(#gdt_result,z-2, id)
      EndIf
    Next
  Else
    MessageRequester("serverSearch()","Error")
  EndIf
  
EndProcedure 

Procedure threadServerSearch(v.i)
  ;OpenWaitWindow()
  DisableGadget(#gdt_result,1)
  DisableGadget(#gdt_search,1)
  serverSearch(GetGadgetText(#gdt_search))
  DisableGadget(#gdt_result,0)
  DisableGadget(#gdt_search,0)
  ;CloseWaitWindow()
EndProcedure

Procedure getFilesListFromServer(id.l)
  Protected http.HTTP_Query
  If gp\useProxy=#True
    HTTP_proxy(@http,gp\proxy\host,gp\proxy\port,gp\proxy\login,gp\proxy\password)
  EndIf
  HTTP_query(@http, #HTTP_METHOD_POST, gp\server)
  HTTP_addQueryHeader(@http, "User-Agent", "ThothBox")
  HTTP_addPostData(@http, "code", Str(id))
  HTTP_sendQuery(@http)
  HTTP_receiveRawData(@http)
  ;HTTP_DataProcessing(@http)
  ;Debug PeekS(http\header,MemorySize(http\header),#PB_Ascii);
  ClearList(gp\file())
  If http\data<>0
    ;MessageRequester("Files List",PeekS(http\data,MemorySize(http\data),#PB_Ascii))
    Protected txt.s,nbline.l,z.l,line.s,sepa.l,key.s,value.s,l.l,cara.l
    txt.s=PeekS(http\data,MemorySize(http\data),#PB_Ascii);
    ;MessageRequester("Files List",txt)
    nbline=CountString(txt,#LFCR$)
    For z=1 To nbline
      line=ReplaceString(StringField(txt, z, #LFCR$),Chr(13),"")
      
      ;first line header data with name
      If z=1
        Protected d.i, Dim key2col.l(10)
        For d=1 To CountString(line,";")+1
          Debug LCase(StringField(line, d, ";"))
          Select LCase(StringField(line, d, ";"))
            Case "id"
              key2col(0)=d
            Case "filename"
              key2col(1)=d
            Case "filesize"
              key2col(2)=d
            Case "md5"
              key2col(3)=d
          EndSelect
        Next
      Else
      AddElement(gp\file())
      gp\file()\id=Val(StringField(line, key2col(0), ";"))
      gp\file()\filename=StringField(line, key2col(1), ";")
      gp\file()\lenght=Val(StringField(line, key2col(2), ";"))
      gp\file()\md5=StringField(line, key2col(3), ";")
      Debug gp\file()\filename
      
      ;clean filename
      For l=1 To Len(gp\file()\filename)
        cara=Asc(Mid(gp\file()\filename,l,1)); get the ascii value
        Select cara
          Case 46,47, 48 To 57,65 To 90,92,95,97 To 122,128,150
          Case 232 To 235
            gp\file()\filename=Mid(gp\file()\filename,1,l-1)+"e"+Mid(gp\file()\filename,l+1,Len(gp\file()\filename)-l)
          Default 
            gp\file()\filename=Mid(gp\file()\filename,1,l-1)+"_"+Mid(gp\file()\filename,l+1,Len(gp\file()\filename)-l)
         EndSelect
       Next
       ;ready to sort
       If LCase(gp\file()\filename)="main.pb"
         gp\file()\sort=1
       Else
         Select GetExtensionPart(LCase(gp\file()\filename))
             Case "pb"
                gp\file()\sort=2
             Case "pbi"
                gp\file()\sort=3  
             Case "jpg","jpeg","gif","pcx","png"
               gp\file()\sort=4
             Case "txt"
               gp\file()\sort=5
             Default 
               gp\file()\sort=6
         EndSelect
       EndIf
       EndIf
    Next
    ;sort file list ! first main.pb>*.pb>*.pbi>*.jpg
    SortStructuredList(gp\file(), 0, OffsetOf(fileslist\sort), #PB_Sort_Byte)

  Else
    MessageRequester("getFilesListFromServer()","Error")
  EndIf
EndProcedure

Procedure downloadfile()
  Protected http.HTTP_Query,path.s
  
  If gp\useProxy=#True
    HTTP_proxy(@http,gp\proxy\host,gp\proxy\port,gp\proxy\login,gp\proxy\password)
  EndIf
  HTTP_query(@http, #HTTP_METHOD_POST, gp\server)
  http\downCallback=@myCallBack();
  HTTP_addQueryHeader(@http, "User-Agent", "ThothBox")
  ;juste pour tester les images
  ;gp\file()\filename="test.png"
  ;gp\file()\id=13
  ;id=7
  HTTP_addPostData(@http, "file", Str(gp\file()\id))
  HTTP_addPostData(@http, "code", Str(gp\codeid))
  Debug "file:"+Str(gp\file()\id)+" code:"+Str(gp\codeid)
  HTTP_sendQuery(@http)
  HTTP_receiveRawData(@http)
  

  If http\data>0
    path=gp\downloadDirectory+"\"+Str(gp\codeid)+"\"
    gp\file()\filename=ReplaceString(gp\file()\filename,"/","\")
    DirectoryCreate(GetPathPart(path))
    Debug path+gp\file()\filename
    If CreateFile(0,path+gp\file()\filename)
      WriteData(0,http\data,MemorySize(http\data))
      CloseFile(0)
      gp\progressBarPointer+MemorySize(http\data)
    Else 
      MessageRequester("Error downloadfiles()","Can't write file:"+path+gp\file()\filename)
    EndIf
    ;RunProgram("notepad.exe",GetTemporaryDirectory()+gp\file()\filename,GetCurrentDirectory())
    FreeMemory(http\data):http\data=0
  ElseIf http\header>0
    MessageRequester("",PeekS(http\header,MemorySize(http\header),#PB_Ascii))
  Else
    MessageRequester("","NO ANSWER")
  EndIf
EndProcedure

Procedure downloadfiles(id.l)
  
  Debug "__"
    ForEach gp\file()
      ;Bug if you loop directy !works if you run thru a procedure
      downloadfile()
    Next
  EndProcedure
  
  Procedure threadDownloadFiles(i.l)
    
    ;SetGadgetAttribute(#gdt_bar,#PB_ProgressBar_Maximum,gp\progressBarMax)
    getFilesListFromServer(GetGadgetItemData(#gdt_result,GetGadgetState(#gdt_result)))
    gp\progressBarMax=0
    ForEach gp\file()
      gp\progressBarMax=gp\progressBarMax+gp\file()\lenght
    Next
    Debug">>>>"+Str(gp\progressBarMax)
    gp\progressBarPointer=0
  downloadfiles(GetGadgetItemData(#gdt_result,GetGadgetState(#gdt_result)))
EndProcedure
  

; IDE Options = PureBasic 4.60 Beta 4 (Windows - x86)
; CursorPosition = 354
; FirstLine = 340
; Folding = ---
; EnableXP