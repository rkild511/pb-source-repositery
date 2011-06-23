; German forum: http://www.purebasic.fr/german/viewtopic.php?t=2126&highlight=
; Author: sverson (updated for PB 4.00 by Andre)
; Date: 19. February 2005
; OS: Windows
; Demo: No


; Display system colors
; Systemfarben anzeigen


;/ Display system colors 
;/ sverson 02/2005 

Structure SYSCOLORS 
  ColorConst.s 
  ColorNumber.l 
EndStructure 
Global NewList ColorList.SYSCOLORS() 

Procedure InitColorList() 
  AddElement(ColorList()) : ColorList()\ColorConst = "#COLOR_3DDKSHADOW" : ColorList()\ColorNumber = 21 
  AddElement(ColorList()) : ColorList()\ColorConst = "#COLOR_3DFACE = #COLOR_BTNFACE" : ColorList()\ColorNumber = 15 
  AddElement(ColorList()) : ColorList()\ColorConst = "#COLOR_3DHILIGHT = #COLOR_BTNHIGHLIGHT" : ColorList()\ColorNumber = 20 
  AddElement(ColorList()) : ColorList()\ColorConst = "#COLOR_3DHIGHLIGHT = #COLOR_BTNHIGHLIGHT" : ColorList()\ColorNumber = 20 
  AddElement(ColorList()) : ColorList()\ColorConst = "#COLOR_3DLIGHT" : ColorList()\ColorNumber = 22 
  AddElement(ColorList()) : ColorList()\ColorConst = "#COLOR_3DSHADOW = #COLOR_BTNSHADOW" : ColorList()\ColorNumber = 16 
  AddElement(ColorList()) : ColorList()\ColorConst = "#COLOR_ACTIVEBORDER" : ColorList()\ColorNumber = 10 
  AddElement(ColorList()) : ColorList()\ColorConst = "#COLOR_ACTIVECAPTION" : ColorList()\ColorNumber = 2 
  AddElement(ColorList()) : ColorList()\ColorConst = "#COLOR_APPWORKSPACE" : ColorList()\ColorNumber = 12 
  AddElement(ColorList()) : ColorList()\ColorConst = "#COLOR_BACKGROUND" : ColorList()\ColorNumber = 1 
  AddElement(ColorList()) : ColorList()\ColorConst = "#COLOR_BTNFACE" : ColorList()\ColorNumber = 15 
  AddElement(ColorList()) : ColorList()\ColorConst = "#COLOR_BTNHIGHLIGHT" : ColorList()\ColorNumber = 20 
  AddElement(ColorList()) : ColorList()\ColorConst = "#COLOR_BTNHILIGHT = #COLOR_BTNHIGHLIGHT" : ColorList()\ColorNumber = 20 
  AddElement(ColorList()) : ColorList()\ColorConst = "#COLOR_BTNSHADOW" : ColorList()\ColorNumber = 16 
  AddElement(ColorList()) : ColorList()\ColorConst = "#COLOR_BTNTEXT" : ColorList()\ColorNumber = 18 
  AddElement(ColorList()) : ColorList()\ColorConst = "#COLOR_CAPTIONTEXT" : ColorList()\ColorNumber = 9 
  AddElement(ColorList()) : ColorList()\ColorConst = "#COLOR_DESKTOP = #COLOR_BACKGROUND" : ColorList()\ColorNumber = 1 
  AddElement(ColorList()) : ColorList()\ColorConst = "#COLOR_GRADIENTACTIVECAPTION" : ColorList()\ColorNumber = 27 
  AddElement(ColorList()) : ColorList()\ColorConst = "#COLOR_GRADIENTINACTIVECAPTION" : ColorList()\ColorNumber = 28 
  AddElement(ColorList()) : ColorList()\ColorConst = "#COLOR_GRAYTEXT" : ColorList()\ColorNumber = 17 
  AddElement(ColorList()) : ColorList()\ColorConst = "#COLOR_HIGHLIGHT" : ColorList()\ColorNumber = 13 
  AddElement(ColorList()) : ColorList()\ColorConst = "#COLOR_HIGHLIGHTTEXT" : ColorList()\ColorNumber = 14 
  AddElement(ColorList()) : ColorList()\ColorConst = "#COLOR_HOTLIGHT" : ColorList()\ColorNumber = 26 
  AddElement(ColorList()) : ColorList()\ColorConst = "#COLOR_INACTIVEBORDER" : ColorList()\ColorNumber = 11 
  AddElement(ColorList()) : ColorList()\ColorConst = "#COLOR_INACTIVECAPTION" : ColorList()\ColorNumber = 3 
  AddElement(ColorList()) : ColorList()\ColorConst = "#COLOR_INACTIVECAPTIONTEXT" : ColorList()\ColorNumber = 19 
  AddElement(ColorList()) : ColorList()\ColorConst = "#COLOR_INFOBK" : ColorList()\ColorNumber = 24 
  AddElement(ColorList()) : ColorList()\ColorConst = "#COLOR_INFOTEXT" : ColorList()\ColorNumber = 23 
  AddElement(ColorList()) : ColorList()\ColorConst = "#COLOR_MENU" : ColorList()\ColorNumber = 4 
  AddElement(ColorList()) : ColorList()\ColorConst = "#COLOR_MENUTEXT" : ColorList()\ColorNumber = 7 
  AddElement(ColorList()) : ColorList()\ColorConst = "#COLOR_SCROLLBAR" : ColorList()\ColorNumber = 0 
  AddElement(ColorList()) : ColorList()\ColorConst = "#COLOR_WINDOW" : ColorList()\ColorNumber = 5 
  AddElement(ColorList()) : ColorList()\ColorConst = "#COLOR_WINDOWFRAME" : ColorList()\ColorNumber = 6 
  AddElement(ColorList()) : ColorList()\ColorConst = "#COLOR_WINDOWTEXT" : ColorList()\ColorNumber = 8 
  AddElement(ColorList()) : ColorList()\ColorConst = "#COLORMATCHTOTARGET_EMBEDED" : ColorList()\ColorNumber = 1 
  AddElement(ColorList()) : ColorList()\ColorConst = "#COLORONCOLOR" : ColorList()\ColorNumber = 3 
EndProcedure 

InitColorList() 
If OpenWindow(0,10,10,640,CountList(ColorList())*15+1,"Display system colors",#PB_Window_ScreenCentered|#PB_Window_SystemMenu) 
  background = GetSysColor_(#COLOR_WINDOW) 
  If StartDrawing(WindowOutput(0)) 
    DrawingFont(LoadFont(0, "Arial", 8)) 
    FirstElement(ColorList()) 
    For a = 0 To CountList(ColorList())-1 
      SysColor = GetSysColor_(ColorList()\ColorNumber) 
      Box(0,15*a,640,16,RGB(0,0,0)) 
      Box(1,15*a+1,638,14,RGB(255,255,255)) 
      Box(300,15*a+2,200,12,SysColor) 
      FrontColor(RGB(0,0,0))
      BackColor(RGB(255,255,255))
      DrawText(12, 15*a+1, RSet(Str(ColorList()\ColorNumber),3,"0")+"  "+ColorList()\ColorConst) 
      DrawText(510, 15*a+1, RSet(Str(SysColor),8,"0")+"  "+RSet(Str(Red(SysColor)),3,"0")+"/"+RSet(Str(Green(SysColor)),3,"0")+"/"+RSet(Str(Blue(SysColor)),3,"0")) 
      NextElement(ColorList()) 
    Next 
    StopDrawing() 
  EndIf 
  Repeat 
      EventID.l = WaitWindowEvent() 
  Until EventID = #PB_Event_CloseWindow 
  CloseWindow(0) 
EndIf 
End

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; DisableDebugger