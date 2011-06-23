; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3049&highlight=
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 07. December 2003
; OS: Windows
; Demo: No


; Stellt einen Farbverlauf im Hintergrund dar, hier als Grundlage für ein Setup-Programm.
; 
; by Danilo, 07.12.2003 - german forum 
; 
Procedure GradientImage(image,width,height,color1,color2,type) 
  #vert = 0 
  #horz = 1 
  hImg = CreateImage(image,width,height) 
  If hImg 
    If type=#vert : i = width : Else : i = height : EndIf 
    sRed.f   = Red(color1)   : r.f = (Red  (color1) - Red  (color2))/i 
    sGreen.f = Green(color1) : g.f = (Green(color1) - Green(color2))/i 
    sBlue.f  = Blue(color1)  : b.f = (Blue (color1) - Blue (color2))/i 
    StartDrawing(ImageOutput(image)) 
      For a = 0 To i-1 
        x.f = sRed   - a*r 
        y.f = sGreen - a*g 
        z.f = sBlue  - a*b 
        If type=#horz 
          Line(0,a,width,0,RGB(x,y,z)) 
        Else 
          Line(a,0,0,height,RGB(x,y,z)) 
        EndIf 
      Next a 
    StopDrawing() 
  EndIf 
  ProcedureReturn hImg 
EndProcedure 

Enumeration 0 
  #Img1 
  #Img2 
  #Cancel 
EndEnumeration 

OpenWindow(0,0,200,200,0,"Setup",#PB_Window_TitleBar|#PB_Window_Invisible) 
  MoveWindow_(WindowID(0),0,0,GetSystemMetrics_(#SM_CXSCREEN),GetSystemMetrics_(#SM_CYSCREEN),0) 
  CreateGadgetList(WindowID(0)) 
  width  = WindowWidth(0) 
  height = WindowHeight(0) 
  ImageGadget(#Img1,0,0,width,height,GradientImage(1,width,height,RGB($00,$00,$FF),RGB($00,$00,$00),#vert)) 

  OpenWindow(1,0,0,500,300,"Install",#PB_Window_TitleBar|#PB_Window_Invisible|#PB_Window_ScreenCentered,WindowID(0)) 
    CreateGadgetList(WindowID(1)) 
    width  = WindowWidth(1) 
    height = WindowHeight(1) 
    ImageGadget(#Img2,0,0,width,height,GradientImage(2,width,height,RGB($00,$00,$FF),RGB($00,$00,$00),#horz)) 
    DisableGadget(#Img2,1)
    ButtonGadget(#Cancel,390,270,100,20,"Cancel") 

HideWindow(0,0) 
HideWindow(1,0) 

Repeat 
  Select WaitWindowEvent() 
    Case #PB_Event_Gadget 
      Select EventGadget() 
        Case #Cancel 
          If MessageRequester("Setup", "Realy quit setup?", #MB_YESNO|#MB_ICONQUESTION)=#IDYES 
            Quit = #True 
          EndIf 
      EndSelect 
  EndSelect 
Until Quit

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger
