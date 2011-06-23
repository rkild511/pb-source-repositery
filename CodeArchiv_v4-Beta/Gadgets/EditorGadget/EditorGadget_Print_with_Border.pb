; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1407
; Author: JoRo (updated for PB4.00 by blbltheworm)
; Date: 18. July 2003
; OS: Windows
; Demo: No


;############################################ 
;Inhalt vom 
;EditorGadget auf Standard-Drucker ausgeben 
; 
;Author : Andreas 
;Juni 2003 
;ergänzt von Wichtel und Joro 
; 
;sämtliche Formatierungen die im EditorGadget 
;vorgenommen werden (Farbe, Font usw.), 
;werden auf den Drucker übernommen. 
;############################################ 
Global GadgetNr,GadgetNr_hWnd 
#Seitenrandlinks=80 
#Seitenrandrechts=81 
#Seitenrandoben=82 
#Seitenrandunten=83 


;####################################################################### 
;die 2 Procedure basieren auf El_Choni's Beispiel 
Procedure StreamFileIn_Callback(hFile, pbBuff, cb, pcb) 
  ProcedureReturn ReadFile_(hFile, pbBuff, cb, pcb, 0)!1 
EndProcedure 

Procedure FileStreamIn(FileID.l, File.s, Gadget.l,Option.l) 

  Protected StreamData.EDITSTREAM 
  If ReadFile(FileID, File) 
    StreamData\dwCookie = FileID(FileID) 
    StreamData\dwError = #Null 
    StreamData\pfnCallback = @StreamFileIn_Callback() 
    SendMessage_(GadgetNr_hWnd, #EM_STREAMIN, Option, @StreamData) 
    CloseFile(FileID) 
  EndIf 
EndProcedure 
;####################################################################### 


Procedure PrintWindow() 
  WindowWidth = 200 
  WindowHeight = 40 
  If OpenWindow(10, 0, 0, WindowWidth, WindowHeight, "Printing", #PB_Window_WindowCentered) 
    SetWindowPos_(WindowID(10),#HWND_TOPMOST,0,0,0,0,#SWP_NOMOVE|#SWP_NOSIZE) 
    CreateGadgetList(WindowID(10)) 
    TextGadget(0, 10, 10, 180, 20,"Drucke Seite") 
  EndIf 
EndProcedure 


Procedure EditorPrint(Dokument.s) 
  Protected DC ,a 
  lppd.PRINTDLG; Struktur für die API Druckerauswahl 
  lppd\lStructsize=SizeOf(PRINTDLG) 
  lppd\Flags=#PD_ALLPAGES| #PD_HIDEPRINTTOFILE | #PD_NOSELECTION | #PD_RETURNDC |#PD_PRINTSETUP 
  PrintDlg_(lppd); API Druckerauswahl 
   DC=lppd\hDC; hier kommt der Device Context zurück 
  mydevmode.DEVMODE 
  *Pointer.DEVMODE 
  *Pointer=GlobalLock_(lppd\hdevmode) 
  Papierlaenge=*Pointer\dmPaperlength 
  Papierbreite=*Pointer\dmPaperwidth 
  ppmm.f=(*Pointer\dmYResolution/10)/2.54 
  GlobalFree_(hdevmode) 
  cRect.RECT 
  FormatRange.FORMATRANGE 
  Docinfo.DOCINFO
  Docinfo\cbSize = SizeOf(DOCINFO) 
  Docinfo\lpszDocName = @Dokument.s 
  Docinfo\lpszOutput = #Null 
  Docinfo\lpszDataType = #Null 
  Docinfo\fwType = 0 
  PrintWindow() 
  SetGadgetText(0, "Druckvorbereitung") 
  Result=StartDoc_(DC,Docinfo) 
  LastChar = 0 
  Randlinks=GetGadgetState(#Seitenrandlinks) 
  Randrechts=GetGadgetState(#Seitenrandrechts) 
  Randoben=GetGadgetState(#Seitenrandoben) 
  Randunten=GetGadgetState(#Seitenrandunten) 
  SetActiveGadget(GadgetNr); stürzt ohne Activate ab und zu ab 
  MaxLen = Len(GetGadgetText(GadgetNr))-SendMessage_(GadgetNr_hWnd,#EM_GETLINECOUNT,0,0) 
  OldMapMode = GetMapMode_(DC) 
  SetMapMode_(DC,#MM_TWIPS) 
  OffsetX = Randlinks*ppmm.f-GetDeviceCaps_(DC,#PHYSICALOFFSETX) 
  If OffsetX < GetDeviceCaps_(DC,#PHYSICALOFFSETX):OffsetX=GetDeviceCaps_(DC,#PHYSICALOFFSETX):EndIf 
  OffsetY=-Randoben*ppmm.f+GetDeviceCaps_(DC,#PHYSICALOFFSETY) 
  If OffsetY > -GetDeviceCaps_(DC,#PHYSICALOFFSETY): OffsetY = -GetDeviceCaps_(DC,#PHYSICALOFFSETY):EndIf 
  HorzRes=((Papierbreite/10-Randrechts))*ppmm.f 
  If HorzRes > GetDeviceCaps_(DC,#HORZRES) :HorzRes=GetDeviceCaps_(DC,#HORZRES):EndIf 
  VertRes=-(Papierlaenge/10)*ppmm.f+Randunten*ppmm.f 
  If VertRes < -GetDeviceCaps_(DC,#VERTRES):VertRes=-GetDeviceCaps_(DC,#VERTRES):EndIf 
  SetRect_(cRect,OffsetX,OffsetY,HorzRes,VertRes) 
  DPtoLP_(DC,cRect,2) 
  SetMapMode_(DC,OldMapMode) 
  FormatRange\hdc = DC 
  FormatRange\hdcTarget = DC 
  FormatRange\rc\left = cRect\left 
  FormatRange\rc\top = cRect\top 
  FormatRange\rc\right = cRect\right 
  FormatRange\rc\bottom = cRect\bottom 
  FormatRange\rcPage\left = cRect\left 
  FormatRange\rcPage\top = cRect\top 
  FormatRange\rcPage\right = cRect\right 
  FormatRange\rcPage\bottom = cRect\bottom 
  a = 1 
  Repeat 
    SetGadgetText(0, "Drucke Seite : "+ Str(a)) 
    Result=StartPage_(DC) 
    FormatRange\chrg\cpMax = -1 
    LastChar = SendMessage_(GadgetNr_hWnd,#EM_FORMATRANGE,#True,@FormatRange) 
    FormatRange\chrg\cpMin = LastChar 
    SendMessage_(GadgetNr_hWnd,#EM_DISPLAYBAND,0,cRect) 
    a + 1 
    EndPage_(DC) 
  Until LastChar >= MaxLen Or LastChar = -1 
  SetGadgetText(0, "Fertig") 
  CloseWindow(10) 
  EndDoc_(DC) 
  SendMessage_(GadgetNr_hWnd,#EM_FORMATRANGE,0,0) 
EndProcedure  

If OpenWindow(0, 10, 10, 640, 480, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget) 
  If CreateGadgetList(WindowID(0)) 
  GadgetNr_hWnd=EditorGadget(1, 0, 0, WindowWidth(0)-100,WindowHeight(0)) 
  GadgetNr=1 
  ButtonGadget(2, WindowWidth(0)-90,10,80,24,"Drucken") 
  ButtonGadget(3, WindowWidth(0)-90,40,80,24,"Laden") 
  TextGadget(10,WindowWidth(0)-100,95, 100, 20,"Seitenränder in mm") 

  SpinGadget(#Seitenrandlinks, WindowWidth(0)-90,150, 50, 20, 0, 100) 
  SetGadgetState(#Seitenrandlinks,20) 
  SetGadgetText(#Seitenrandlinks,Str(GetGadgetState(#Seitenrandlinks))) 
  TextGadget(11,WindowWidth(0)-90,125, 80, 20,"links") 

  SpinGadget(#Seitenrandrechts, WindowWidth(0)-90,200, 50, 20, 0, 100) 
  SetGadgetState(#Seitenrandrechts,20) 
  SetGadgetText(#Seitenrandrechts,Str(GetGadgetState(#Seitenrandrechts))) 
  TextGadget(12,WindowWidth(0)-90,175, 80, 20,"rechts") 

  SpinGadget(#Seitenrandoben, WindowWidth(0)-90,250, 50, 20, 0, 100) 
  SetGadgetState(#Seitenrandoben,20) 
  SetGadgetText(#Seitenrandoben,Str(GetGadgetState(#Seitenrandoben))) 
  TextGadget(13,WindowWidth(0)-90,225, 80, 20,"oben") 

  SpinGadget(#Seitenrandunten, WindowWidth(0)-90,300, 50, 20, 0, 100) 
  SetGadgetState(#Seitenrandunten,20) 
  SetGadgetText(#Seitenrandunten,Str(GetGadgetState(#Seitenrandunten))) 
  TextGadget(14,WindowWidth(0)-90,275, 80, 20,"unten") 
  EndIf 
  Repeat 
  EventID.l = WaitWindowEvent() 
    If EventID = #PB_Event_CloseWindow 
    Quit = 1 
    EndIf 
    If EventID = #PB_Event_Gadget 
    Select EventGadget() 
      Case 2 
      EditorPrint(DName$) 
      Case 3 
      DName$ = OpenFileRequester("Datei laden :","*.*", "Text-Dateien | *.txt | Rich Text Files | *.rtf", 0) 
      If UCase(GetExtensionPart(DName$)) = "RTF" 
      FileStreamIn(0,DName$, 1,#SF_RTF) 
      Else 
      FileStreamIn(0,DName$, 1,#SF_TEXT) 
      EndIf 
      Case #Seitenrandlinks 
          If spinc=2 
             spinc=0 
          Else 
            spin=GetGadgetState(#Seitenrandlinks) 
            spinc=spinc+1 
            SetGadgetText(#Seitenrandlinks,Str(spin)) 
            WindowEvent() 
          EndIf 
        Case #Seitenrandrechts 
          If spinc=2 
            spinc=0 
          Else 
            spin=GetGadgetState(#Seitenrandrechts) 
            spinc=spinc+1 
            SetGadgetText(#Seitenrandrechts,Str(spin)) 
            WindowEvent() 
          EndIf 
        Case #Seitenrandoben 
          If spinc=2 
            spinc=0 
          Else 
            spin=GetGadgetState(#Seitenrandoben) 
            spinc=spinc+1 
            SetGadgetText(#Seitenrandoben,Str(spin)) 
            WindowEvent() 
          EndIf 
        Case #Seitenrandunten 
          If spinc=2 
            spinc=0 
          Else 
            spin=GetGadgetState(#Seitenrandunten) 
            spinc=spinc+1 
            SetGadgetText(#Seitenrandunten,Str(spin)) 
            WindowEvent() 
          EndIf 
    EndSelect 
    EndIf 
  Until Quit = 1 
EndIf 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
