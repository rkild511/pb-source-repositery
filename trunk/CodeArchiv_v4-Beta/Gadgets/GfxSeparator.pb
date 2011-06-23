; English forum: http://www.purebasic.fr/english/viewtopic.php?t=9630&highlight=
; Author: Num3 (updated for PB 4.00 by Andre)
; Date: 24. February 2004
; OS: Windows
; Demo: No

Procedure separator(id,x,y,width,height,text.s,fontid,color1,color2) 
  
  If CreateImage(id,width,height) 
    
    i = width 
    sRed.f   = Red(color1)   : r.f = (Red  (color1) - Red  (color2))/i 
    sGreen.f = Green(color1) : g.f = (Green(color1) - Green(color2))/i 
    sBlue.f  = Blue(color1)  : b.f = (Blue (color1) - Blue (color2))/i 
    
    StartDrawing(ImageOutput(id)) 
    For a = 0 To i-1 
      xx.f = sRed   - a*r 
      yy.f = sGreen - a*g 
      zz.f = sBlue  - a*b 
      Line(a,0,0,height,RGB(xx,yy,zz)) 
    Next a 
    
    DrawingMode(1) 
    FrontColor(RGB($FF,$FF,$FF))
    If fontid<>0 
      DrawingFont(fontid) 
    EndIf 
    DrawText(5,2,text) 
    StopDrawing() 
    
  EndIf 
  
  ImageGadget(id,x,y,width,Header,ImageID(id)) 
  
EndProcedure 

OpenWindow(0,0,0,600,400,"Nice bars",#PB_Window_TitleBar|#PB_Window_ScreenCentered|#PB_Window_SystemMenu) 

CreateGadgetList(WindowID(0)) 
ButtonGadget(0,390,270,100,20,"Cancel") 

separator(0,100,100,250,20,"Hello world",0,RGB($50,$50,$50),GetSysColor_(#COLOR_3DFACE)) 

;/// Note GetSysColor_(#COLOR_3DFACE) is a win32 API call, don't use it on linux!!! 

fontid=LoadFont(1,"Lucida Console",12) 
separator(1,100,200,250,20,"My configuration",fontid,RGB($40,$40,$40),RGB($CC,$CC,$CC)) 



Repeat 
  Select WaitWindowEvent() 
    Case #PB_Event_Gadget 
      Select EventGadget() 
        Case 0 
          
          Quit = #True 
          
      EndSelect 
  EndSelect 
Until Quit 



; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -