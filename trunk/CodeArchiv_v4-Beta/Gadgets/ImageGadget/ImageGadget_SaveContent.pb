; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=21346#21346
; Author: Andreas  (updated for PB3.92+ by Andre)
; Date: 02. November 2003
; OS: Windows
; Demo: No

#DI_NORMAL = $3
; Saves the content of the displayed ImageGadget in an .bmp file...
  If OpenWindow(0,0,0,245,105,"ImageGadget",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) And CreateGadgetList(WindowID(0)) 
      ;Icon ins ImageGagdet 
      ImageGadget(0, 10,10,100,83,LoadImage(10,"..\..\Graphics\Gfx\people.ico") )
      
      ;oder Bitmap 
      ;ImageGadget(0, 10,10,100,83,LoadImage(10,"..\..\Graphics\Gfx\Map2.bmp")) 
      
      ;erstmal herausfinden ob Bitmap oder Icon 
      If SendMessage_(GadgetID(0),#STM_GETIMAGE,#IMAGE_BITMAP,0) 
        MessageRequester("Image","Bitmap",0) 
        ;BITMAP Speichern als Bitmap 
        Handle = SendMessage_(GadgetID(0),#STM_GETIMAGE,#IMAGE_BITMAP,0) 
        GetClientRect_(GadgetID(0),r.RECT) 
        SDC = CreateCompatibleDC_(0) 
        SelectObject_(SDC,Handle) 
        CreateImage(1,r\right,r\bottom) 
        hdc=StartDrawing(ImageOutput(1)) 
        BitBlt_(hdc,0,0,r\right,r\bottom,SDC,0,0,#SRCCOPY) 
        StopDrawing() 
        Name$ = SaveFileRequester("Speichern","unbenannt.bmp","*.bmp",0) 
        If Name$ 
          SaveImage(1,Name$,#PB_ImagePlugin_BMP);Pfad anpassen 
        EndIf 
        FreeImage(1) 
        DeleteDC_(SDC) 
        
      ElseIf SendMessage_(GadgetID(0),#STM_GETIMAGE,#IMAGE_ICON,0) 
        MessageRequester("Image","Icon",0) 
        ;ICON Speichern als Bitmap 
        Handle = SendMessage_(GadgetID(0),#STM_GETIMAGE,#IMAGE_ICON,0) 
        GetClientRect_(GadgetID(0),r.RECT) 
        CreateImage(1,r\right,r\bottom) 
        hdc=StartDrawing(ImageOutput(1)) 
        DrawIconEx_(hdc,0,0,Handle,r\right,r\bottom,0,0,#DI_NORMAL) 
        StopDrawing() 
        Name$ = SaveFileRequester("Speichern","unbenannt.bmp","*.bmp",0) 
        If Name$ 
          SaveImage(1,Name$,#PB_ImagePlugin_BMP);Pfad anpassen 
        EndIf 
        FreeImage(1) 
      
      
    EndIf 
    Repeat : Until WaitWindowEvent()=#PB_Event_CloseWindow 
  EndIf 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
