; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1468&highlight=
; Author: Rings (updated for PB4.00 by blbltheworm + Andre)
; Date: 24. June 2003
; OS: Windows
; Demo: No


; Extended Printer-Dialog and PageSetup Functions 
; 
;(C) 2002 by Siegfried Rings (-Codeguru-) 

;These structures are not needed 
; but i leave them to know how the Orignal are typed 
; 
Structure PRINTDLG_TYPE 
    lStructSize.l 
    hwndOwner.l 
    hDevMode.l 
    hDevNames.l 
    hdc.l 
    Flags.l 
    nFromPage.w 
    nToPage.w 
    nMinPage.w 
    nMaxPage.w 
    nCopies.w 
    hInstance.l 
    lCustData.l 
    lpfnPrintHook.l 
    lpfnSetupHook.l 
    lpPrintTemplateName.s 
    lpSetupTemplateName.s 
    hPrintTemplate.l 
    hSetupTemplate.l 
EndStructure 
Structure DEVNAMES_TYPE 
    wDriverOffset.w 
    wDeviceOffset.w 
    wOutputOffset.w 
    wDefault.w 
    extra.b[100] 
EndStructure 
Structure DEVMODE_TYPE 
    dmDeviceName.b[32] 
    dmSpecVersion.w 
    dmDriverVersion.w 
    dmSize.w 
    dmDriverExtra.w 
    dmFields.l 
    dmOrientation.w 
    dmPaperSize.w 
    dmPaperLength.w 
    dmPaperWidth.w 
    dmScale.w 
    dmCopies.w 
    dmDefaultSource.w 
    dmPrintQuality.w 
    dmColor.w 
    dmDuplex.w 
    dmYResolution.w 
    dmTTOption.w 
    dmCollate.w 
    dmFormName.b[32] 
    dmUnusedPadding.w 
    dmBitsPerPel.w 
    dmPelsWidth.l 
    dmPelsHeight.l 
    dmDisplayFlags.l 
    dmDisplayFrequency.l 
EndStructure 

;These are the constants For the PrinterDialog 

    #DM_DUPLEX = $1000 
    #DM_ORIENTATION = $1 

    #PD_ALLPAGES = $0 
    #PD_COLLATE = $10 
    #PD_DISABLEPRINTTOFILE = $80000 
    #PD_ENABLEPRINTHOOK = $1000 
    #PD_ENABLEPRINTTEMPLATE = $4000 
    #PD_ENABLEPRINTTEMPLATEHANDLE = $10000 
    #PD_ENABLESETUPHOOK = $2000 
    #PD_ENABLESETUPTEMPLATE = $8000 
    #PD_ENABLESETUPTEMPLATEHANDLE = $20000 
    #PD_HIDEPRINTTOFILE = $100000 
    #PD_NONETWORKBUTTON = $200000 
    #PD_NOPAGENUMS = $8 
    #PD_NOSELECTION = $4 
    #PD_NOWARNING = $80 
    #PD_PAGENUMS = $2 
    #PD_PRINTSETUP = $40 
    #PD_PRINTTOFILE = $20 
    #PD_RETURNDC = $100 
    #PD_RETURNDEFAULT = $400 
    #PD_RETURNIC = $200 
    #PD_SELECTION = $1 
    #PD_SHOWHELP = $800 
    #PD_USEDEVMODECOPIES = $40000 
    #PD_USEDEVMODECOPIESANDCOLLATE = $40000 



#PSD_DEFAULTMINMARGINS ;Sets the minimum values that the user can specify For the page margins To be the minimum ;margins allowed by the printer. This is the default. This flag is ignored If the #PSD_MARGINS And PSD_MINMARGINS flags are also specified. 
#PSD_DISABLEMARGINS ;Disables the margin controls, preventing the user from setting the margins. 
#PSD_DISABLEORIENTATION;Disables the orientation controls, preventing the user from setting the page orientation. 
#PSD_DISABLEPAGEPAINTING;Prevents the dialog box from drawing the contents of the sample page. If you enable a ;PagePaintHook hook procedure, you can still draw the contents of the sample page. 
#PSD_DISABLEPAPER ;Disables the paper controls, preventing the user from setting page parameters such as the ;Mpaper size And source. 
#PSD_DISABLEPRINTER;Disables the Printer button, preventing the user from invoking a dialog box that contains ;additional printer setup information. 
#PSD_ENABLEPAGEPAINTHOOK ;Enables the hook Procedure specified in the lpfnPagePaintHook member. 
#PSD_ENABLEPAGESETUPHOOK ;Enables the hook Procedure specified in the lpfnPageSetupHook member. 
#PSD_ENABLEPAGESETUPTEMPLATE;Indicates that the hInstance And lpPageSetupTemplateName members specify a dialog box ;template To use in place of the Default template. 
#PSD_ENABLEPAGESETUPTEMPLATEHANDLE ;Indicates that the hPageSetupTemplate member identifies a Data block that contains a ;preloaded dialog box template. The system ignores the lpPageSetupTemplateName member If ;this flag is specified. 
#PSD_INHUNDREDTHSOFMILLIMETERS ;Indicates that hundredths of millimeters are the unit of measurement For margins And ;paper size. The values in the rtMargin, rtMinMargin, And ptPaperSize members are in ;hundredths of millimeters. You can set this flag on input To override the Default unit of ;measurement For the user's locale. When the function returns, the dialog box sets this ;flag To indicate the units used. 
#PSD_INTHOUSANDTHSOFINCHES ;Indicates that thousandths of inches are the unit of measurement For margins And paper ;size. The values in the rtMargin, rtMinMargin, And ptPaperSize members are in thousandths ;of inches. You can set this flag on input To override the Default unit of measurement For ;the user's locale. When the function returns, the dialog box sets this flag To indicate ;the units used. 
#PSD_INWININIINTLMEASURE ;Not implemented. 
#PSD_MARGINS ;Causes the system To use the values specified in the rtMargin member as the initial widths ;For the left, top, right, And bottom margins. If PSD_MARGINS is Not set, the system sets ;the initial widths To one inch For all margins. 
#PSD_MINMARGINS;Causes the system To use the values specified in the rtMinMargin member as the minimum ;allowable widths For the left, top, right, And bottom margins. The system prevents the ;user from entering a width that is less than the specified minimum. If PSD_MINMARGINS is ;Not specified, the system sets the minimum allowable widths To those allowed by the ;printer. 
#PSD_NOWARNING ;Prevents the system from displaying a warning message when there is no Default printer. 
#PSD_RETURNDEFAULT;PageSetupDlg does Not display the dialog box. Instead, it sets the hDevNames And hDevMode ;members To handles To DEVMODE And DEVNAMES structures that are initialized For the system ;Default printer. PageSetupDlg returns an error If either hDevNames Or hDevMode is Not ;NULL. 
#PSD_SHOWHELP ;Causes the dialog box To display the Help button. The hwndOwner member must specify the ;window To receive the HELPMSGSTRING registered messages that the dialog box sends when ;the user clicks the Help button. 


#GMEM_MOVEABLE = $2 
#GMEM_ZEROINIT = $40 

Procedure PrintDialog_(hwnd,*pd.PRINTDLG,*DevModeCopy.DEVMODE) 
  flag=1 
  myDevNames.DEVNAMES 
  If flag=0 
    MyMemory=AllocateMemory(SizeOf(DEVMODE)) 
  Else 
    MyMemory=GlobalAlloc_(#GMEM_MOVEABLE|#GMEM_ZEROINIT, SizeOf(DEVMODE)) 
  EndIf 
  
  If MyMemory 
        
       *pd.PRINTDLG
       *pd\lStructSize = SizeOf(PRINTDLG) 
       *pd\hwndOwner = hwnd 
       *pd\hDevMode = MyMemory;Devmode;@Devmode;#NULL 
       *pd\hDevNames = #Null;@DevNames;#NULL 
       *pd\hInstance = 0;GetModuleHandle_(0);hInstance.l 
       *pd\lpfnSetupHook = #Null 
       *pd\lpPrintSetupTemplateName = #Null 
       *pd\lpfnPrintHook = #Null 
       *pd\lpPrintTemplateName = #Null 

       ;Setting up the special Printermode 
       ;*DevmodeCopy\dmSize=SizeOf(DEVMODE) 
       ;*DevModeCopy\dmFields = #DM_ORIENTATION | #DM_DUPLEX 
       ;MessageRequester("Info",Str(*DevModeCopy\dmCopies),0) 
       ;*DevModeCopy\dmCopies =2 
        
       If flag=1 
        lpDevMode=GlobalLock_(MyMemory) 
        If lpDevMode 
         Result=CopyMemory(*DevModeCopy.DEVMODE,MyMemory,SizeOf(DEVMODE)) 
         Result=CopyMemory(MyMemory,lpDevMode, SizeOf(DEVMODE)) 
         bReturn =GlobalUnlock_(MyMemory) 
        EndIf 
       Else 
        Result=CopyMemory(*DevModeCopy.DEVMODE,MyMemory,SizeOf(DEVMODE)) 
       EndIf 
       ResultDLG =PrintDlg_(*pd) 
        
       If flag=1 
        lpDevMode=GlobalLock_(MyMemory) 
        If lpDevMode 
         Result=CopyMemory(lpDevMode,MyMemory,  SizeOf(DEVMODE)) 
         Result=CopyMemory(MyMemory,*DevModeCopy.DEVMODE,SizeOf(DEVMODE)) 
         Result =GlobalUnlock_(MyMemory) 
        EndIf 
        Result = GlobalFree_(MyMemory) 
       Else 
        Result=CopyMemory(MyMemory,*DevModeCopy.DEVMODE,SizeOf(DEVMODE)) 
        FreeMemory(MyMemory) 
       EndIf 
        
       ProcedureReturn ResultDLG 
  EndIf 
EndProcedure 

Procedure PageSetupDialog_(*PGSDLG.PAGESETUPDLG) 
  flag=0 
  If flag 
    PGSMemory=GlobalAlloc_(#GMEM_MOVEABLE|#GMEM_ZEROINIT, SizeOf(PAGESETUPDLG)) 
  Else 
    PGSMemory=AllocateMemory(SizeOf(PAGESETUPDLG)) 
  EndIf 
  If PGSMemory 
    If flag=1 
  
     lpDevMode=GlobalLock_(PGSMemory) 
     Result=CopyMemory(*PGSDLG.PAGESETUPDLG,PGSMemory,SizeOf(PAGESETUPDLG))    
     Result=CopyMemory(PGSMemory,lpDevMode,SizeOf(PAGESETUPDLG)) 
     bReturn =GlobalUnlock_(PGSMemory) 
      
     Result=PageSetupDlg_(PGSMemory) 
      
     lpDevMode=GlobalLock_(PGSMemory) 
     Result=CopyMemory(lpDevMode,*PGSDLG.PAGESETUPDLG,SizeOf(PAGESETUPDLG)) 
     bReturn =GlobalUnlock_(PGSMemory) 
     bReturn = GlobalFree_(PGSMemory) 
    Else 
     Result=CopyMemory(*PGSDLG.PAGESETUPDLG,PGSMemory,SizeOf(PAGESETUPDLG))    
     Result=PageSetupDlg_(PGSMemory) 
     Result=CopyMemory(PGSMemory,*PGSDLG.PAGESETUPDLG,SizeOf(PAGESETUPDLG))    
     FreeMemory(PGSMemory) 
    EndIf 
  Else 
    MessageRequester("Info","cannot allocate memory",0) 
  EndIf 
  ProcedureReturn Result 
EndProcedure 

hwnd= OpenWindow(0, 10, 10, 100, 200, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget) 
If hwnd 
  
  pd.PRINTDLG
  pd\nFromPage = 3 
  pd\nToPage = 5 
  pd\nMinPage = 1 
  pd\nMaxPage = 100 
  pd\nCopies = 13 
                            ;If you set Flags=#PD_RETURNDEFAULT the Requester i snewer called 
  pd\Flags =  0;#PD_RETURNDC |#PD_HIDEPRINTTOFILE |#PD_PAGENUMS| #PD_USEDEVMODECOPIES ;    #PD_ALLPAGES ;#PD_RETURNDC ;| #PD_PRINTSETUP 
  DevModeCopy.DEVMODE 
  Result=PrintDialog_(hwnd,pd,DevModeCopy) 
  If Result 
    Info.s="" 
    Info.s=Info.s + "     Copies="+Str(DevModeCopy\dmCopies)+Chr(13) 
    Info.s=Info.s + "Orientation="+Str(DevModeCopy\dmOrientation)+Chr(13) 
    Info.s=Info.s + "   FromPage="+Str(pd\nFromPage  ) +Chr(13) 
    Info.s=Info.s + "     ToPage="+Str(pd\nToPage ) +Chr(13) 
    Info.s=Info.s + "    Quality="+Str(DevModeCopy\dmPrintQuality)+Chr(13) 
    Info.s=Info.s + "      Color="+Str(DevModeCopy\dmColor)+Chr(13) 
    MessageRequester("Info",Info,0) 
  Else 
    MessageRequester("Info","Aborted",0) 
  EndIf 
  
  PGSDLG.PAGESETUPDLG 
  PGSDLG\lStructSize=SizeOf(PAGESETUPDLG) 
  PGSDLG\hwndOwner=hwnd 
  PGSDLG\hDevMode=0;DevModeCopy 
  PGSDLG\rtMargin\left=3000 
  PGSDLG\hInstance=0 ;fails -> GetModuleHandle_(0) 
  
  PGSDLG\flags=#PSD_MARGINS|#PSD_DISABLEPRINTER 
  Result=PageSetupDialog_(PGSDLG) 
  
  Info.s=         "     Result="+Str(Result)+Chr(13) 
  Info.s=Info.s + "      Flags="+Str(PGSDLG\flags)+Chr(13) 
  Info.s=Info.s + " PapersizeX="+Str(PGSDLG\ptPaperSize\x)+" PapersizeY="+Str(PGSDLG\ptPaperSize\y)+Chr(13) 
  Info.s=Info.s + "  MinMargin="+Str(PGSDLG\rtMinMargin\left)+":"+Str(PGSDLG\rtMinMargin\top)+":"+Str(PGSDLG\rtMinMargin\right)+":"+Str(PGSDLG\rtMinMargin\bottom)+Chr(13) 
  Info.s=Info.s + "     Margin="+Str(PGSDLG\rtMargin\left)+":"+Str(PGSDLG\rtMargin\top)+":"+Str(PGSDLG\rtMargin\right)+":"+Str(PGSDLG\rtMargin\bottom)+Chr(13) 
  MessageRequester("Info",Info,0) 
EndIf 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -