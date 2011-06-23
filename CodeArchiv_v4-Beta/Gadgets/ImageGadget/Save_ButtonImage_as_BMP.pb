; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2773
; Author: Stefan Moebius (updated for PB4.00 by blbltheworm) 
; Date: 08. November 2003
; OS: Windows
; Demo: No

#DI_NORMAL=3 

Procedure IconWidth(Icon) 
  BmpInf.BITMAP:GetIconInfo_(Icon,Info.ICONINFO) 
  GetObject_(Info\hbmColor,SizeOf(BmpInf),BmpInf) 
  ProcedureReturn BmpInf\bmWidth 
EndProcedure 

Procedure IconHeight(Icon) 
  BmpInf.BITMAP:GetIconInfo_(Icon,Info.ICONINFO) 
  GetObject_(Info\hbmColor,SizeOf(BmpInf),BmpInf) 
  ProcedureReturn BmpInf\bmHeight 
EndProcedure 

Procedure ConvertIcon2Image(ImageNr,Icon) 
  IconWidth=IconWidth(Icon) 
  IconHeight=IconHeight(Icon) 
  CreateImage(ImageNr,IconWidth,IconHeight) 
  
  HDC=StartDrawing(ImageOutput(ImageNr)) 
  Box(0,0,IconWidth,IconHeight,RGB(255,0,255)) 
  DrawIconEx_(HDC,0,0,Icon,IconWidth,IconHeight,0,0,#DI_NORMAL);Icon zeichnen 
  StopDrawing() 
EndProcedure 

OpenWindow(1,0,0,200,200,"Icon als Bmp speichern",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) 


CreateGadgetList(WindowID(1)) 


Icon=ExtractIcon_(0,"Shell32.dll",40) 
ButtonImageGadget(1,0,0,50,50,Icon) 



Repeat 
  Erg=WaitWindowEvent() 
  
  
  If Erg=#PB_Event_Gadget And EventGadget()=1 ;Wenn der Gadget gedrückt wird  
    ConvertIcon2Image(1,Icon) 
    Datei$ = SaveFileRequester("","Icon.bmp","Bitmap|*.bmp",1) ;Bitmap speichern 
    If Datei$<>"":SaveImage(1,Datei$):EndIf 
  EndIf 
  
Until Erg=#PB_Event_CloseWindow 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
