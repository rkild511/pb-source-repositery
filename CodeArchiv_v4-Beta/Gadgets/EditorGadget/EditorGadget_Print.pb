; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1407&highlight=
; Author: Andreas (updated to PB4 by ste123)
; Date: 19. June 2003
; OS: Windows
; Demo: No

; +++ updated 03/2005 by Team100 for use with PB 3.93


;############################################ 
;Inhalt vom 
;EditorGadget auf Standard-Drucker ausgeben 
; 
;Author : Andreas 
;Juni 2003 
; 
;sämtliche Formatierungen die im EditorGadget 
;vorgenommen werden (Farbe, Font usw.), 
;werden auf den Drucker übernommen. 
;############################################ 



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
        SendMessage_(GadgetID(Gadget), #EM_STREAMIN, Option, @StreamData) 
        CloseFile(FileID) 
    EndIf 
EndProcedure 
;####################################################################### 

Procedure PrintWindow() 
    WindowWidth  = 200 
    WindowHeight =  40 
    If OpenWindow(10, 0, 0, WindowWidth, WindowHeight, "Printing", #PB_Window_WindowCentered) 
        SetWindowPos_(WindowID(10),#HWND_TOPMOST,0,0,0,0,#SWP_NOMOVE|#SWP_NOSIZE) 
        CreateGadgetList(WindowID(10)) 
        TextGadget(20, 10, 10, 180, 20,"Drucke Seite") 
    EndIf 
EndProcedure 



Procedure EditorPrint(Gadget.l,docname.s) 
    Protected DC 
    
    DC = DefaultPrinter() 

; +++ uncomment next lines for API print requester. Do not use PrintRequester()    
    
;    lppd.PRINTDLGAPI; Struktur für die API Druckerauswahl 
;    lppd\lStructsize=SizeOf(PRINTDLGAPI) 
;    lppd\Flags=#PD_ALLPAGES| #PD_HIDEPRINTTOFILE | #PD_NOSELECTION | #PD_RETURNDC 
;    PrintDlg_(lppd); API Druckerauswahl (printrequester geht nicht) 
;    DC=lppd\hDC; hier kommt der Device Context zurück 

   
    cRect.RECT 
    FormatRange.FORMATRANGE 
    
    Docinfo.Docinfo
    DocInfo\cbSize = SizeOf(Docinfo)
    DocInfo\lpszDocName = @Docname 
    DocInfo\lpszOutput = #Null 

    PrintWindow() 
    SetGadgetText(20, "Druckvorbereitung") 
    StartDoc_(DC,Docinfo) 
    
    LastChar = 0 
    MaxLen = Len(GetGadgetText(Gadget)) - SendMessage_(GadgetID(Gadget),#EM_GETLINECOUNT,0,0) 
    OldMapMode = GetMapMode_(DC) 
    SetMapMode_(DC,#MM_TWIPS) 
    OffsetX = GetDeviceCaps_(DC,#PHYSICALOFFSETX) 
    OffsetY = -GetDeviceCaps_(DC,#PHYSICALOFFSETY) 
    HorzRes = GetDeviceCaps_(DC,#HORZRES) 
    VertRes = -GetDeviceCaps_(DC,#VERTRES) 
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
        SetGadgetText(20, "Drucke Seite : "+ Str(a)) 
        StartPage_(DC) 
        FormatRange\chrg\cpMax = -1 
        LastChar = SendMessage_(GadgetID(Gadget),#EM_FORMATRANGE,#True,@FormatRange) 
        FormatRange\chrg\cpMin = LastChar 
        SendMessage_(GadgetID(Gadget),#EM_DISPLAYBAND,0,cRect) 
        a + 1 
        EndPage_(DC) 
    Until LastChar >= MaxLen Or LastChar = -1 
    SetGadgetText(20, "Fertig") 
    CloseWindow(10) 
    EndDoc_(DC) 
    SendMessage_(GadgetID(Gadget),#EM_FORMATRANGE,0,0) 
EndProcedure 

If OpenWindow(0, 10, 10, 640, 480,"PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget) 
    If CreateGadgetList(WindowID(0)) 
        EditorGadget(1, 0, 0, WindowWidth(0)-100,WindowHeight(0)) 
        ButtonGadget(2, WindowWidth(0)-90,10,80,24,"Drucken") 
        ButtonGadget(3, WindowWidth(0)-90,40,80,24,"Laden") 
    EndIf 
    Repeat 
        EventID.l = WaitWindowEvent() 
        If EventID = #PB_Event_CloseWindow 
            Quit = 1 
        EndIf 
        If EventID = #PB_Event_Gadget 
            Select EventGadget() 
            Case 2 
                EditorPrint(1,"Docname") 
            Case 3 
                DName$ = OpenFileRequester("Datei laden :","*.*", "Text-Dateien|*.txt|Rich Text Files|*.rtf|Alle Dateien|*.*", 0) 
                If UCase(GetExtensionPart(DName$)) = "RTF" 
                    FileStreamIn(0,DName$, 1,#SF_RTF) 
                Else 
                    FileStreamIn(0,DName$, 1,#SF_TEXT) 
                EndIf 
            EndSelect 
        EndIf 
    Until Quit = 1 
EndIf 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger
