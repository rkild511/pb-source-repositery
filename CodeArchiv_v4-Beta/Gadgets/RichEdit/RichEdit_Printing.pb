; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6679&highlight=
; Author: LuckyLuke (updated to PB v4.00 by Andre)
; Date: 23. June 2003
; OS: Windows
; Demo: No


Global PrinterDC 

Procedure  StartPrint(Doc.s) 
    mDI.DOCINFO 
    mDI\cbSize = SizeOf(DOCINFO) 
    mDI\lpszDocName = @Doc 
    mDI\lpszOutput = 0 
    StartDoc_(PrinterDC,mDI) 
EndProcedure 

Procedure PrintRichText(hWnd, hInst, rtfEdit, LM, RM, TM, BM) 
   ; 
   ;  Purpose: 
   ;           Prints the contents of an RTF text box given it's handle, the 
   ;           calling program;s handle(s), And the page margins. 
   ; 
   ;  Parameters: 
   ;           hWnd     = Parent window (used for print common dlg) 
   ;           hInst    = Instance of calling program 
   ;           rtfEdit  = Handle of rich edit control 
   ;           LM       = Left Margin in inches 
   ;           RM       = Right Margin in inches 
   ;           TM       = Top Margin in inches 
   ;           BM       = Bottom Margin in inches 
   ; 
   fr.FORMATRANGE 
   pd.PRINTDLG
   ;- Setup the print common dialog 
   pd\lStructSize = SizeOf(PRINTDLG) 
   pd\hwndOwner = hWnd 
   pd\hDevMode = #Null 
   pd\hDevNames = #Null 
   pd\nFromPage = 0 
   pd\nToPage = 0 
   pd\nMinPage = 0 
   pd\nMaxPage = 0 
   pd\nCopies = 0 
   pd\hInstance = hInst 
   pd\Flags = #PD_RETURNDC | #PD_PRINTSETUP 
   pd\lpfnSetupHook = #Null 
   pd\lpPrintSetupTemplateName = #Null 
   pd\lpfnPrintHook = #Null 
   pd\lpPrintTemplateName = #Null 
    
   If PrintDlg_(pd) 
     b = GlobalLock_(pd\hDevNames)        
     drv.s  = PeekS(b + PeekW(b)) 
     name.s = PeekS(b + PeekW(b + 2)) 

     PrinterDC.l = CreateDC_(drv,name,0,GlobalLock_(pd\hDevMode)) 
        
     fr\hdc = PrinterDC 
     fr\hdcTarget = PrinterDC 
     fr\chrg\cpMin = 0 
     fr\chrg\cpMax = -1 
     fr\rc\top = TM*1440 
     fr\rcPage\top = fr\rc\top 
     fr\rc\left = LM*1440 
     fr\rcPage\left = fr\rc\left 
       ;- Get page dimensions in Twips 
     iWidthTwips = Int((GetDeviceCaps_(PrinterDC, #HORZRES)/GetDeviceCaps_(PrinterDC, #LOGPIXELSX))*1440) 
     iHeightTwips = Int((GetDeviceCaps_(PrinterDC, #VERTRES )/GetDeviceCaps_(PrinterDC, #LOGPIXELSY))*1440) 
     fr\rc\right = iWidthTwips-RM*1440 
     fr\rcPage\right = fr\rc\right 
     fr\rc\Bottom = iHeightTwips-BM*1440 
     fr\rcPage\Bottom = fr\rc\Bottom 
      
     StartPrint("RTF Printing") 
     StartPage_(PrinterDC) 

       ;- This does the printing. We send messages 
       ;  to the edit box telling it to format it;s 
       ;  text to fit the Printer;s DC. 
       ; 
     iTextOut = 0 
     iTextAmt = SendMessage_(rtfEdit, #WM_GETTEXTLENGTH, 0, 0) 
     While iTextOut<iTextAmt 
       iTextOut = SendMessage_(rtfEdit, #EM_FORMATRANGE, 1, fr) 
       If iTextOut<iTextAmt 
         iTextAmt = iTextAmt - iTextOut 
         EndPage_(PrinterDC) 
         StartPage_(PrinterDC) 
         fr\chrg\cpMin = iTextOut 
         fr\chrg\cpMax = -1 
       EndIf 
     Wend 
     SendMessage_(rtfEdit, #EM_FORMATRANGE, 1, #Null) 
     ;- Finish the printing. 
     EndPage_(PrinterDC) 
     EndDoc_(PrinterDC) 
     DeleteDC_(PrinterDC) 
  EndIf 
EndProcedure 

Procedure StreamFileInCallback(hFile, pbBuff, cb, pcb) 
  ProcedureReturn ReadFile_(hFile, pbBuff, cb, pcb, 0)!1 
EndProcedure 

Procedure loadFile(pFilePath.s) 
  If ReadFile(0, pFilePath) 
    If GetExtensionPart(pFilePath)="rtf" 
      uFormat = #SF_RTF 
    Else 
      uFormat = #SF_TEXT 
    EndIf 
    edstr.EDITSTREAM 
    edstr\dwCookie = FileID(0) 
    edstr\dwError = 0 
    edstr\pfnCallback = @StreamFileInCallback() 
    SendMessage_(GadgetID(0), #EM_STREAMIN, uFormat, edstr) 
    CloseFile(0) 
  Else 
    MessageRequester("Error", "Error Occured While Opening File", #PB_MessageRequester_Ok) 
  EndIf 
EndProcedure 

If OpenWindow(0, 200, 50, 640, 400,"RTF PRINTING", #PB_Window_SystemMenu)=0:End:EndIf 
If CreateMenu(0, WindowID(0))=0:End:EndIf 
  MenuTitle("&File") 
    MenuItem(0, "&Open") 
    MenuItem(1, "&Print") 
    MenuItem(2, "&Quit") 
If CreateGadgetList(WindowID(0))=0:End:EndIf 
EditorGadget(0, 0, 0, WindowWidth(0), WindowHeight(0)) 
AddKeyboardShortcut(0, #PB_Shortcut_Control|#PB_Shortcut_O, 0) 
AddKeyboardShortcut(0, #PB_Shortcut_Control|#PB_Shortcut_P, 1) 
AddKeyboardShortcut(0, #PB_Shortcut_Control|#PB_Shortcut_Q, 2) 
Repeat 
  EventID = WaitWindowEvent() 
  If EventID=#PB_Event_Menu 
    Select EventMenu() 
      Case 0 
        FileName$ = OpenFileRequester("", "", "All files|*.*", 0) 
        If FileName$ 
          loadFile(FileName$) 
        EndIf 
      Case 1 
        PrintRichText(WindowID(0), GetModuleHandle_(0), GadgetID(0), 0, 0, 0, 0) 
      Case 2 
        Quit = 1 
    EndSelect 
  ElseIf EventID=#PB_Event_CloseWindow 
    Quit = 1 
  EndIf 
Until Quit 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger
