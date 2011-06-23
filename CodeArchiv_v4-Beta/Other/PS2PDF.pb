; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=5187&highlight=
; Author: schic (updated for PB 4.00 by Andre)
; Date: 28. July 2004
; OS: Windows
; Demo: No


; ps2pdf mit Ghostscript

;converting PostScript to PDF  with Ghostscript 
;based on examples from http://www.cs.wisc.edu/~ghost/doc/gsapi.htm 
;for parameters see http://www.cs.wisc.edu/~ghost/doc/AFPL/8.00/Ps2pdf.htm#Overview 
; 
;saving a link to the prog in the SendTo folder, ps-file(s)  
;can be converted by right click and send to. 

;-PDF -Parameters 
Structure presettings 
  nam.s 
  parameter.s 
EndStructure 

Global Dim pdfsettings.presettings(4) 
pdfsettings(0)\nam="Bildschirm" 
pdfsettings(0)\parameter="screen" 
pdfsettings(1)\nam="eBook" 
pdfsettings(1)\parameter="eBook" 
pdfsettings(2)\nam="Drucker" 
pdfsettings(2)\parameter="printer" 
pdfsettings(3)\nam="Druckvorstufe" 
pdfsettings(3)\parameter="prepress" 
pdfsettings(4)\nam="Allgemein" 
pdfsettings(4)\parameter="default" 

Global GetValue.s 
Global n.l 
Global ProCall.b 
Global Listevoll.b 

Global Dim astrArgs.s(18) 
Global Dim PSFile$(1) 
Global Dim PDFFiles$(1) 


;- Window Constants 
Enumeration 
  #Window_0 
EndEnumeration 

;- Gadget Constants 
Enumeration 
  #Panel_0 
  #Gadget_0 
  #Text_0 
  #Combo_0 
  #Text_2 
  #Combo_1 
  #Text_4 
  #String_1 
  #Text_5 
  #CheckBox_0 
  #CheckBox_1 
  #CheckBox_2 
  #CheckBox_3 
  #Combo_2 
  #Text_8 
  #Combo_3 
  #Text_9 
EndEnumeration 


Procedure Open_Window_0() 
  If OpenWindow(#Window_0, 289, 68, 360, 344, "Postscript to PDF", #PB_Window_SystemMenu | #PB_Window_TitleBar) 
    SendMessage_(cb,#WM_SETFONT,GetStockObject_(#DEFAULT_GUI_FONT),1) 
    SetGadgetFont(#PB_Default , GetStockObject_(#DEFAULT_GUI_FONT)) 
    If CreateGadgetList(WindowID(#Window_0)) 
      PanelGadget(#Panel_0, 0, 0, 360, 344) 
      AddGadgetItem(#Panel_0, -1, "Dateien") 
      ListViewGadget(#Gadget_0, 0, 0, 360, 320) 
      AddGadgetItem (#Gadget_0, -1, ">Doppelklick<") 
      
      AddGadgetItem(#Panel_0, -1, "Einstellungen") 
      TextGadget(#Text_0, 10, 10, 76, 16, "Papierformat") 
      ComboBoxGadget(#Combo_0, 114, 10, 115, 24) 
      For i = 0 To 6 
        AddGadgetItem(#Combo_0,-1,"DIN A" + Str(i)) 
        Debug  astrArgs(5) 
        If astrArgs(5) = "-sPAPERSIZE=a" + Str(i) 
          SetGadgetState(#Combo_0,i) 
        EndIf 
      Next 
      AddGadgetItem(#Combo_0,-1,"Voreinstellung (A4)") 
      If astrArgs(5) = "-d" 
        SetGadgetState(#Combo_0,i) 
      EndIf 
      TextGadget(#Text_2, 10, 46, 80, 20, "Qualitätsstufen") 
      ComboBoxGadget(#Combo_1, 118, 46, 190, 20) 
      For i = 0 To 4 
        AddGadgetItem(#Combo_1,-1,pdfsettings(i)\nam) 
      Next 
      SetGadgetState(#Combo_1,4) 
      TextGadget(#Text_4, 10, 78, 80, 16, "Auflösung") 
      StringGadget(#String_1, 118, 78, 76, 20, Right(astrArgs(12),Len(astrArgs(12))-2)) 
      TextGadget(#Text_5, 202, 80, 24, 16, "dpi") 
      CheckBoxGadget(#CheckBox_0, 240, 10, 80, 20, "erzwingen") 
      If astrArgs(4) = "-dFIXEDMEDIA" 
        SetGadgetState(#CheckBox_0, 1) 
      Else 
        SetGadgetState(#CheckBox_0, 0) 
      EndIf 
      CheckBoxGadget(#CheckBox_1, 10, 118, 104, 20, "Kompression ein") 
      If astrArgs(7) = "-dCompressPages=true" 
        SetGadgetState(#CheckBox_1,1) 
      Else 
        SetGadgetState(#CheckBox_1,0) 
      EndIf 
      GadgetToolTip(#CheckBox_1, "erzeugt kleinere Dateien") 
      CheckBoxGadget(#CheckBox_2, 10, 162, 176, 20, "CMYK Bilder in RGB umwandeln") 
      If astrArgs(9) = "-dConvertCMYKImagesToRGB=true" 
        SetGadgetState(#CheckBox_2,1) 
      Else 
        SetGadgetState(#CheckBox_2,0) 
      EndIf 
      CheckBoxGadget(#CheckBox_3, 162, 118, 132, 20, "Schriften einbetten") 
      If astrArgs(8) = "-dEmbedAllFonts=true" 
        SetGadgetState(#CheckBox_3,1) 
      Else 
        SetGadgetState(#CheckBox_3,0) 
      EndIf 
      ComboBoxGadget(#Combo_2, 10, 190, 44, 20) 
      merke=3 
      For i = 1 To 4 
        AddGadgetItem(#Combo_2,-1,Str(i)) 
        If i = Val(Right(astrArgs(10),1)):merke=i:EndIf 
      Next 
      SetGadgetState(#Combo_2,merke-1) 
      TextGadget(#Text_8, 62, 194, 92, 16, "Schrift Antialiasing") 
      ComboBoxGadget(#Combo_3, 174, 190, 40, 20) 
      merke=3 
      For i = 1 To 4 
        AddGadgetItem(#Combo_3,-1,Str(i)) 
        If i = Val(Right(astrArgs(11),1)):merke=i:EndIf 
      Next 
      SetGadgetState(#Combo_3,merke-1) 
      TextGadget(#Text_9, 226, 194, 80, 16, "Bild Antialiasing")      
      CloseGadgetList() 
    EndIf 
  EndIf 
EndProcedure 

Structure StringStruct 
  Text$ 
EndStructure 

Procedure setParams() 
  
  
  astrArgs(0) = "ps2pdf" ;The First Parameter is Ignored 
  astrArgs(1) = "-dNOPAUSE" 
  astrArgs(2) = "-dBATCH";,-dColorImageFilter=/FlateEncode, -dAutoFilterColorImages=false" 
  astrArgs(3) = "-dSAFER" 
  If GetGadgetState(#CheckBox_0) 
    astrArgs(4) = "-dFIXEDMEDIA" 
  Else 
    astrArgs(4) = "-d" 
  EndIf 
  If GetGadgetState(#Combo_0) <> 7 
    astrArgs(5) = "-sPAPERSIZE=a" + Str(GetGadgetState(#Combo_0)); -dCompressPages=false"; -dFIXEDMEDIA" 
  Else 
    astrArgs(5) = "-d" 
  EndIf 
  astrArgs(6) = "-dPDFSETTINGS=/" + pdfsettings(GetGadgetState(#Combo_1))\parameter; -dPDFSETTINGS=/ebook" 
  If GetGadgetState(#CheckBox_1) 
    astrArgs(7) = "-dCompressPages=true" 
  Else 
    astrArgs(7) = "-dCompressPages=false" 
  EndIf 
  If GetGadgetState(#CheckBox_3) 
    astrArgs(8) = "-dEmbedAllFonts=true" 
  Else 
    astrArgs(8) = "-dEmbedAllFonts=false" 
  EndIf 
  If GetGadgetState(#CheckBox_2) 
    astrArgs(9) = "-dConvertCMYKImagesToRGB=true" 
  Else 
    astrArgs(9) = "-dConvertCMYKImagesToRGB=false" 
  EndIf 
  astrArgs(10) = "-dTextAlphaBits=" + GetGadgetItemText(#Combo_2, GetGadgetState(#Combo_2), 0) 
  astrArgs(11) = "-dGraphicsAlphaBits=" + GetGadgetItemText(#Combo_3, GetGadgetState(#Combo_3), 0) 
  astrArgs(12) = "-r" + Trim(GetGadgetText(#String_1));"-r300" 
  astrArgs(13) = "-sDEVICE=pdfwrite";mswinpr2 ;Windows Drucker 
  ;astrArgs(14) = "" 
  astrArgs(15) = "-c" 
  astrArgs(16) = "";.setpdfwrite" 
  astrArgs(17) = "-f" 
  ;astrArgs(18) = "" ;input File 
EndProcedure 

Procedure writePrefs() 
    If CreatePreferences("ps2pdf.prefs") 
      PreferenceGroup("aktSettings") 
      For i = 0 To 18 
        WritePreferenceString("astrArg" + Str(i), astrArgs(i)) 
      Next 
    EndIf 
EndProcedure 

Procedure readPrefs() 
  For i = 1 To 18 
    OpenPreferences("ps2pdf.prefs") 
    PreferenceGroup("aktSettings") 
    astrArgs(i)=ReadPreferenceString("astrArg" + Str(i), "") 
  Next 
EndProcedure 

Procedure AddListItem(GadgNo, Text$) 
  AddGadgetItem(GadgNo, -1, Text$) 
  SetGadgetState(GadgNo,GetGadgetState(GadgNo)+1) 
EndProcedure 

Procedure.s sichersav(savenam$) 
  Protected LenEnd.l 
  Endung$ = GetExtensionPart(savenam$) 
  LenEnd = Len(Endung$) 
  If ReadFile(1, savenam$) 
    CloseFile(1) 
    neuerNam.b = 0 
    j = 1 
    While neuerNam = 0 
      If Mid(savenam$, Len(savenam$) - LenEnd - 2, 2) = "_" + Str(j - 1) 
        savenam$ = ReplaceString(savenam$, "_" + Str(j - 1) + ".", "_" + Str(j) + ".") 
      Else 
        savenam$ = Left(savenam$, Len(savenam$) - LenEnd - 1) + "_" + Str(j) + "." + Endung$ 
      EndIf 
      If ReadFile(1, savenam$) 
        j = j + 1 
        CloseFile(1) 
      Else 
        neuerNam = 1 
      EndIf 
    Wend 
  EndIf 
  ProcedureReturn savenam$ 
EndProcedure 

Procedure.l gsdll_stdin(intGSInstanceHandle.l, strz.l, intBytes.l) 
  ;We don't have a console, so just Return EOF 
  ProcedureReturn 0 
EndProcedure 

Procedure.l gsdll_stdout(intGSInstanceHandle.l, strz.l, intBytes.l) 
  stri.s 
  i.l 
  For i = 0 To intBytes - 1 
    ;Debug Chr(PeekL(strz+i)) + " " + Str(Asc(Chr(PeekL(strz+i)))) 
    If Asc(Chr(PeekL(strz+i))) = 10 
      AddListItem(#Gadget_0, Trim(stri)) 
      stri="" 
     Else 
      stri = stri + Chr(PeekL(strz+i)) 
    EndIf 
  Next 
  AddListItem(#Gadget_0, Trim(stri)) 
  ProcedureReturn intBytes 
EndProcedure 

Procedure.l gsdll_stderr(intGSInstanceHandle.l, strz.l, intBytes.l) 
  Ergebnis = gsdll_stdout(intGSInstanceHandle, strz, intBytes) 
  ProcedureReturn Ergebnis 
EndProcedure 

Procedure.b CallGS() 
  intReturn.l 
  intGSInstanceHandle.l 
  intCounter.l 
  intElementCount.l 
  iTemp.l 
  callerHandle.l 
  ptrArgs.l  
  Debug GetValue 
  If OpenLibrary(0, GetValue) 
    intReturn = CallFunction(0, "gsapi_new_instance",@intGSInstanceHandle,callerHandle) 
    If (intReturn < 0) 
      ProcedureReturn #False 
    EndIf 
    
    For i = 0 To n-1 
      astrArgs(18) = PSFile$(i) 
      If ProCall=#True 
        astrArgs(14) = "-sOutputFile=" + PDFFiles$(i) 
      Else 
        astrArgs(14) = "-sOutputFile=" + sichersav(Left(PSFile$(i),Len(PSFile$(i))-2) + "pdf") 
      EndIf 
      For zaehl=0 To 18 
        Debug astrArgs(zaehl) 
      Next 
      AddListItem(#Gadget_0, GetFilePart(astrArgs(18)) + " --> " + GetFilePart(astrArgs(14))) 
      
      intReturn = CallFunction(0, "gsapi_set_stdio",intGSInstanceHandle,@gsdll_stdin(), @gsdll_stdout(), @gsdll_stderr()) 
      
      intElementCount = 18 
      Dim xPtrArgs.l(intElementCount) 
      For intCounter = 0 To intElementCount 
        xPtrArgs(intCounter) = @astrArgs(intCounter) 
      Next 
      ptrArgs = @xPtrArgs();@aPtrArgs() 
      
      intReturn = CallFunction(0, "gsapi_init_with_args",intGSInstanceHandle, intElementCount + 1, ptrArgs) 
      
      CallFunction(0, "gsapi_exit",intGSInstanceHandle) 
      
      CallFunction(0, "gsapi_delete_instance", intGSInstanceHandle) 
    Next i 
    
    CloseLibrary(0) 
    ProcedureReturn #True 
  Else 
    MessageRequester("Fehler!","GhostScript konnte nicht geladen werden.",0) 
    ProcedureReturn #False 
  EndIf 
EndProcedure 

Procedure.b ConvertFile() 
  setParams() 
  writePrefs() 
  ConvertFile = CallGS() 
  ProcedureReturn ConvertFile 
EndProcedure 

Procedure.l GetRegValue(topKey, sKeyName.s, sValueName.s, ComputerName.s) 
  GetHandle.l 
  hKey.l 
  lpData.s 
  lpDataDWORD.l 
  lpcbData.l 
  lType.l 
  lReturnCode.l 
  lhRemoteRegistry.l 
  
  If Left(sKeyName, 1) = "\" 
    sKeyName = Right(sKeyName, Len(sKeyName) - 1) 
  EndIf 
  
  If ComputerName = "" 
    GetHandle = RegOpenKeyEx_(topKey, sKeyName, 0, #KEY_ALL_ACCESS, @hKey) 
  Else 
    lReturnCode = RegConnectRegistry_(ComputerName, topKey, @lhRemoteRegistry) 
    GetHandle = RegOpenKeyEx_(lhRemoteRegistry, sKeyName, 0, #KEY_ALL_ACCESS, @hKey) 
  EndIf 
  
  If GetHandle = #ERROR_SUCCESS 
    lpcbData = 255 
    lpData = Space(255) 
    
    GetHandle = RegQueryValueEx_(hKey, sValueName, 0, @lType, @lpData, @lpcbData) 
    If GetHandle = #ERROR_SUCCESS 
      Select lType 
        Case #REG_SZ 
          GetHandle = RegQueryValueEx_(hKey, sValueName, 0, @lType, @lpData, @lpcbData) 
          If GetHandle = 0 
            GetValue = Left(lpData, lpcbData - 1) 
          Else 
            GetValue = "" 
          EndIf 
          
        Case #REG_DWORD 
          GetHandle = RegQueryValueEx_(hKey, ValueName, 0, @lpType, @lpDataDWORD, @lpcbData) 
          If GetHandle = 0 
            GetValue = Str(lpDataDWORD) 
          Else 
            GetValue = "0" 
          EndIf 
      EndSelect 
    EndIf 
  EndIf 
  RegCloseKey_(hKey) 
  ProcedureReturn GetHandle 
EndProcedure 

Procedure.s getGSPath() 
  sKeyNameGS.s = "SOFTWARE\AFPL Ghostscript\8.00";change for an other version 
                                                 ;ToDo: use any installed version 
  sTopKeyGS.l = #HKEY_LOCAL_MACHINE 
  If GetRegValue(sTopKeyGS,sKeyNameGS,"GS_DLL","") 
    MessageRequester("Fehler!","GhostScript 8.00 nicht installiert.",0) 
    End 
  EndIf 
EndProcedure 

Procedure getDateiNames() 
  pfad.s 
  pfad = ReplaceString(astrArgs(14),"-sOutputFile=","") 
  If pfad 
    pfad=GetPathPart(pfad) 
  Else 
    pfad="C:\" 
  EndIf 
  Dateien$ = OpenFileRequester("Wählen Sie die Dateien aus", pfad, "PostScript (*.ps)|*.ps", 1,#PB_Requester_MultiSelection) 
  If Dateien$ 
    NewList DateiNames.StringStruct() 
    Repeat 
      If Dateien$ 
        AddElement(DateiNames()) 
        DateiNames()\Text$=Dateien$ 
      EndIf 
      Dateien$ = NextSelectedFileName() 
    Until Dateien$ = "" 
    
    n = CountList(DateiNames()) 
    ResetList(DateiNames()) 
    Dim PSFile$(n) 
    For i = 0 To n-1 
      NextElement(DateiNames()) 
      PSFile$(i) = DateiNames()\Text$ 
    Next i  
    
    ClearList(DateiNames());LinkedList für nächsten Gebrauch leeren 
    SortArray(PSFile$(), 2,0,n-1) 
    ClearGadgetItemList(#Gadget_0) 
    For i = 0 To n -1 
      If Trim(PSFile$(i)) <> "" 
        AddListItem(#Gadget_0, PSFile$(i)) 
      EndIf 
    Next i 
    AddListItem(#Gadget_0, "") 
    ListGadgN=i 
    Listevoll=#True 
  Else 
    Listevoll=#False 
  EndIf 
EndProcedure 

Procedure String2DatNam(cmds$) 
  ApostFlag.b = 0 
  neutxt$="" 
  n=0 
  While Len(cmds$) > 0 
    posLeer = FindString(cmds$, " ",1) 
    posApost = FindString(cmds$, Chr(34),1) 
    If posLeer > posApost And posApost <> 0 
      If ApostFlag = 0:ApostFlag =1:Else:ApostFlag =0:EndIf 
    EndIf 
    If posLeer = 0 
      neutxt$ = neutxt$ + cmds$ 
      cmds$ = "" 
    ElseIf ApostFlag 
      aa.l=Len(cmds$)-posLeer ; - 1 
      tmp$=Left(cmds$, posLeer) 
      neutxt$ = neutxt$ + tmp$ 
      cmds$=Right(cmds$,aa) 
    Else 
      aa.l=posLeer - 1 
      bb.l=Len(cmds$)-aa-1 
      tmp$=Left(cmds$, aa) 
      neutxt$ = neutxt$ + tmp$ + ";" 
      n + 1 
      cmds$ = Right(cmds$,bb) 
    EndIf 
  Wend 
  Dim PSFile$(n) 
  For i = 0 To n 
    PSFile$(i) = StringField(neutxt$, i+1, ";") 
    aa=FindString(PSFile$(i),Chr(34),1) 
    bb=FindString(PSFile$(i),Chr(34),aa+1) 
    If aa And bb 
      PSFile$(i)=Mid(PSFile$(i),aa+1,bb-2) 
    EndIf 
  Next i 
  SortArray(PSFile$(), 0) 
  For i = 0 To n 
    AddListItem(#Gadget_0, PSFile$(i)) 
  Next i 
  AddListItem(#Gadget_0, "") 
  n + 1 
EndProcedure 

;-Main 
lpCmdLine = GetCommandLine_() 
Namen$ = PeekS(lpCmdLine) 
If FindString(Namen$,"|",1) 
  ProCall=#True 
Else 
  ProCall=#False 
EndIf 
ProgNam$ = Left(Namen$,FindString(Namen$,Chr(34) + " ",1)) 
If ProgNam$ = "":ProgNam$=Namen$:EndIf 
Namen$ = RemoveString(Namen$,ProgNam$) 
Namen$ = Trim(RemoveString(Namen$,Chr(34)+ Chr(34))) 

readPrefs() 
Open_Window_0() 
getGSPath() 
If Namen$ <> "" And ProCall=#False 
  String2DatNam(Namen$) 
  Listevoll=#True 
EndIf 
If ProCall=#True 
  n=Val(Left(Namen$,FindString(Namen$,"|",1))) 
  Namen$=RemoveString(Namen$,Left(Namen$,FindString(Namen$,"|",1))) 
  AddListItem(#Gadget_0,"! " + Namen$) 
  Dim PSFile$(n) 
  Dim PDFFiles$(n) 
  For i = 0 To n-1 
    splitCount=i*2+1 
    PSFile$(i)=StringField(Namen$, splitCount, "|") 
    PDFFiles$(i)=StringField(Namen$, splitCount+1, "|") 
    AddListItem(#Gadget_0,PSFile$(i) + " -> " + PDFFiles$(i)) 
  Next 
  AddListItem(#Gadget_0,"") 
  Listevoll=#True 
EndIf 

Repeat 
  Event = WaitWindowEvent() 
    
  If Event = #PB_Event_Gadget 
    GadgetID = EventGadget() 
    GadgetEvent = EventType() 
    If GadgetID = #Gadget_0 
      If GadgetEvent = #PB_EventType_LeftDoubleClick 
        ;ClearGadgetItemList(#Gadget_0) ;EDITED 
        getDateiNames() 
      EndIf 
    EndIf 
  EndIf 
  If Listevoll=#True 
    pdfOK=ConvertFile() 
    If pdfOK 
      If ProCall=#True 
        Event = #PB_Event_CloseWindow 
      EndIf 
      AddListItem(#Gadget_0, "fertig!") 
      Listevoll=#False 
    Else 
      AddListItem(#Gadget_0, "Fehler in Funktionsaufruf!") 
    EndIf 
    Listevoll=#False 
  EndIf 
Until Event = #PB_Event_CloseWindow 
setParams() 
writePrefs() 
End 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = ---
; EnableXP
; DisableDebugger