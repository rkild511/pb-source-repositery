; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=24708#24708
; Author: Andreas (updated for PB4.00 by blbltheworm)
; Date: 16. December 2003
; OS: Windows
; Demo: No

; Shows ToolBar buttons inside a ContainerGadget
; first button works as toggle button...

#TB_GETBUTTONINFO = (#WM_USER + 65) 
#TB_SETBUTTONINFO = (#WM_USER + 66) 
#TBIF_STYLE = $8 
#TB_SETINDENT = (#WM_USER + 47)

Structure TBBUTTONINFO 
    cbSize.l 
    dwMask.l 
    idCommand.l 
    iImage.l 
    fsState.b 
    fsStyle.b 
    cx.w 
    lParam.l 
    pszText.l 
    cchText.l 
EndStructure    

If OpenWindow(0,0,0,322,150,"ContainerGadget",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) And CreateGadgetList(WindowID(0)) 
  ContainerGadget (0,8,30,306,100,#PB_Container_Single) 
  TB = CreateToolBar(1, GadgetID(0)) 
  SendMessage_(TB,#TB_SETSTYLE,0,SendMessage_(TB,#TB_GETSTYLE,0,0)|#CCS_NODIVIDER) 
  SendMessage_(TB,#TB_SETINDENT,40,0);um 40 Pixel einrücken 
  ToolBarStandardButton(2,#PB_ToolBarIcon_New) 
  ToolBarStandardButton(3,#PB_ToolBarIcon_Open) 
  
  ;Button-Info holen 
  ButtonIndex = 0 
  b.TBBUTTONINFO 
  b\cbSize = SizeOf(TBBUTTONINFO) 
  b\dwMask = #TBIF_STYLE|#TBIF_BYINDEX 
  SendMessage_(TB,#TB_GETBUTTONINFO,ButtonIndex,b) 
  b\fsStyle = #TBSTYLE_CHECK ;Style setzen 
  SendMessage_(TB,#TB_SETBUTTONINFO,ButtonIndex,b);und neue Infos an den Button weiterleiten 
  
  CloseGadgetList() 
  Repeat : Until WaitWindowEvent()=#PB_Event_CloseWindow 
EndIf 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
