; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1058&highlight=
; Author: Andreas (updated for PB4.00 by blbltheworm)
; Date: 19. May 2003
; OS: Windows
; Demo: No

Global hTooltip.l 
InitCommonControls_() 
#TTS_BUBBLE = $40 ; Sprechblase 
;#TTM_GETTIPTEXTCOLOR = $414   ; both in PB3.8 already declared
;#TTM_GETTIPBKCOLOR = $413 
#TTM_SETMAXTIPWIDTH = $418 
#TTM_SETMARGIN = $41A 

Global Dim Tool.TOOLINFO(0) 
Procedure AddTip(Handle,Text.s) 
Tool(0)\cbSize = SizeOf(TOOLINFO) 
Tool(0)\uFlags = #TTF_SUBCLASS|#TTF_IDISHWND 
Tool(0)\hwnd = Handle 
Tool(0)\uId = Handle 
Tool(0)\hInst = GetModuleHandle_(0) 
Tool(0)\lpszText = @Text 
SendMessage_(hTooltip,#TTM_ADDTOOL,0,@Tool(0)); 
EndProcedure 


If OpenWindow(0, 100, 200, 195, 260, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget) 

;Tooltip anlegen 
hTooltip = CreateWindowEx_(#WS_EX_TOPMOST, "tooltips_class32", 0,#TTS_ALWAYSTIP|#TTS_NOPREFIX|#WS_POPUP|#TTS_BUBBLE,#CW_USEDEFAULT,#CW_USEDEFAULT, #CW_USEDEFAULT,#CW_USEDEFAULT,WindowID(0), 0, GetModuleHandle_(0), 0); 

;Zeitverzögerung einstellen 
SendMessage_(hTooltip,#TTM_SETDELAYTIME,#TTDT_INITIAL,0) 

;Farben einstellen 
SendMessage_(hTooltip,#TTM_GETTIPTEXTCOLOR,RGB($F9,$6A,$06),0);TextColor Tooltip 
SendMessage_(hTooltip,#TTM_GETTIPBKCOLOR,RGB($E6,$FB,$19),0);BackColor Tooltip 

;maximal Breite einstellen = automatischer Umbruch 
SendMessage_(hTooltip,#TTM_SETMAXTIPWIDTH,0,160);maximale Breite = 160 Pixel 

;Rand einstellen 
r.RECT 
SetRect_(r,130,30,130,30);extrem einstellen, damit man was sieht 
SendMessage_(hTooltip,#TTM_SETMARGIN,0,r);Rand zwischen Text und Bergenzung 

;deaktivieren 
SendMessage_(hTooltip,#TTM_ACTIVATE,#False,0);deaktiv 

;aktivieren 
SendMessage_(hTooltip,#TTM_ACTIVATE,#True,0);aktiv 

;anderen Font einstellen 
LoadFont(0, "Arial",14,#PB_Font_Italic|#PB_Font_Bold) 
SendMessage_(hTooltip,#WM_SETFONT,FontID(0),0) 

CreateGadgetList(WindowID(0)) 
ButtonGadget(0, 10,10,80,24,"OK") 
AddTip(GadgetID(0),"Ein Tooltip der automatisch umgebrochen wird."+Chr(13)+Chr(13)+"Sieht mitunter ganz nett aus !"+Chr(13)) 


Repeat 
    EventID.l = WaitWindowEvent() 
    If EventID = #PB_Event_CloseWindow 
      FreeFont(0) 
      Quit = 1 
    EndIf 
  Until Quit = 1 
EndIf 
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
