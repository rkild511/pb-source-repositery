; www.purearea.net (Sourcecode collection by cnesm)
; Author: Andreas (updated for PB4.00 by blbltheworm)
; Date: 22. November 2003
; OS: Windows
; Demo: No

;############################# 
;Author : Andreas 
;16.06.2003 
;############################# 

Global NewList Display.DEVMODE() 

#DM_PELSHEIGHT = $100000 
#DM_PELSWIDTH = $80000 
#DM_BITSPERPEL = $40000 
#DM_DISPLAYFLAGS = $200000 
#DM_DISPLAYFREQUENCY = $400000 
#DISP_CHANGE_RESTART = 1 
#CDS_UPDATEREGISTRY = 1 

Procedure.s ReadRegKey(OpenKey.l,SubKey.s,ValueName.s) 
    hKey.l=0 
    keyvalue.s=Space(255) 
    datasize.l=255 
    If RegOpenKeyEx_(OpenKey,SubKey,0,#KEY_READ,@hKey) 
        keyvalue="Fehler. Kann Registry nicht lesen" 
    Else 
        If RegQueryValueEx_(hKey,ValueName,0,0,@keyvalue,@datasize) 
            keyvalue="Fehler. Kann Schlüssel nicht lesen" 
        Else 
            keyvalue=Left(keyvalue,datasize-1) 
        EndIf 
        RegCloseKey_(hKey) 
    EndIf 
    ProcedureReturn keyvalue 
EndProcedure 


Procedure.s GetCurrentSettings() 
    c.s=ReadRegKey(#HKEY_LOCAL_MACHINE,"Config\0001\Display\Settings","BitsPerPixel") 
    wh.s=ReadRegKey(#HKEY_LOCAL_MACHINE,"Config\0001\Display\Settings","Resolution") 
    If c = "4" 
        co$ = "16 Farben" 
    ElseIf c = "8" 
        co$ = "256 Farben" 
    ElseIf c = "16" 
        co$ = "HightColor" 
    ElseIf c = "32" 
        co$ = "TrueColor" 
    EndIf 
    retstring.s = StringField(wh,1,",") + " * " + StringField(wh,2,",") + "  -  " + co$ 
    ProcedureReturn retstring 
EndProcedure 

If OpenWindow(0, 100, 200, 295, 80, "Change Display-Setting", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget) 
    
    If CreateGadgetList(WindowID(0)) 
        CB = CreateWindowEx_($200,"COMBOBOX","",#WS_CHILD|#WS_VISIBLE|#CBS_DROPDOWN|#WS_VSCROLL ,2,10,290,400,WindowID(0),100,GetModuleHandle_(0),0) 
        SendMessage_(CB,#WM_SETFONT,GetStockObject_(#DEFAULT_GUI_FONT),1) 
        ButtonGadget(1, 2, 44, 290,24,"Change Display") 
    EndIf 
    
    While EnumDisplaySettings_(0,x,dev.DEVMODE) 
        If dev\dmBitsPerPel = 4 
            f$ = "16 Farben" 
        ElseIf dev\dmBitsPerPel = 8 
            f$ = "256 Farben" 
        ElseIf dev\dmBitsPerPel = 16 
            f$ = "HightColor" 
        ElseIf dev\dmBitsPerPel = 32 
            f$ = "TrueColor" 
        EndIf 
        AddElement(Display()) 
        Display()\dmSize = SizeOf(DEVMODE) 
        Display()\dmFields = #DM_PELSHEIGHT|#DM_PELSWIDTH|#DM_BITSPERPEL|#DM_DISPLAYFLAGS|#DM_DISPLAYFREQUENCY 
        Display()\dmBitsPerPel = dev\dmBitsPerPel 
        Display()\dmPelsWidth = dev\dmPelsWidth 
        Display()\dmPelsHeight = dev\dmPelsHeight 
        Display()\dmDisplayFlags = dev\dmDisplayFlags 
        Display()\dmDisplayFrequency = dev\dmDisplayFrequency 
        dd$ = Str(dev\dmPelsWidth) + " * " + Str(dev\dmPelsHeight) + "  -  " + f$ 
        x + 1 
        SendMessage_(CB,#CB_ADDSTRING,0,dd$) 
    Wend 
    
    SendMessage_(CB,#CB_SETCURSEL,SendMessage_(CB,#CB_FINDSTRING,0,GetCurrentSettings()),0) 
    InvalidateRect_(WindowID(0),0,0) 
    
    Repeat 
        EventID.l = WaitWindowEvent() 
        If EventID = #PB_Event_CloseWindow 
            Quit = 1 
        EndIf 
        If EventID = #PB_Event_Gadget 
            Select EventGadget() 
            Case 1 
                SelectElement(Display(),SendMessage_(CB,#CB_GETCURSEL,0,0)) 
                If Display()\dmBitsPerPel = 4 
                    f$ = "16 Farben" 
                ElseIf Display()\dmBitsPerPel = 8 
                    f$ = "256 Farben" 
                ElseIf Display()\dmBitsPerPel = 16 
                    f$ = "HightColor" 
                ElseIf Display()\dmBitsPerPel = 32 
                    f$ = "TrueColor" 
                EndIf 
                d$ = Str(Display()\dmPelsWidth) + " * " + Str(Display()\dmPelsHeight) + "  -  " + f$ 
                If d$ <> GetCurrentSettings() 
                    If ChangeDisplaySettings_(Display(),#CDS_UPDATEREGISTRY) = #DISP_CHANGE_RESTART 
                        MessageRequester("Meldung","Neustart nötig",64) 
                    EndIf 
                Else 
                    MessageRequester("Meldung","Nichts zu ändern",64) 
                EndIf 
            EndSelect 
        EndIf 
    Until Quit = 1 
EndIf 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP