; English forum: http://www.purebasic.fr/english/viewtopic.php?t=29273#29273
; Author: midebor (updated for PB4.00 by blbltheworm)
; Date: 29. June 2003
; OS: Windows
; Demo: No
; 
; ------------------------------------------------------------ 
; Purebasic Webcam viewer by midebor (mdb@skynet.be) 

; The programm uses URLDownloadToFile Api to download Webcam images 
; to temp.jpg file and displays them using the UseJPEGImageDecoder() 
; function. 
; The program assumes you are already connected to the Internet 
; Has only been tested with ADSL connection 

; The program takes the Webcam's URL as program parameter. 
; Place as many instances you need on your desktop with the webcam's URL 
; you want to monitor. Only jpg format is supported 
; ------------------------------------------------------------ 
; 

UseJPEGImageDecoder() 
Parameter$ = ProgramParameter() 
If URLDownloadToFile_(0, Parameter$, "temp.jpg", 0, 0) 
EndIf 
  If LoadImage(0, "temp.jpg") 
  
    OpenWindow(0, 0, 0, ImageWidth(0), ImageHeight(0), "PureBasic - Webcam Viewer", #PB_Window_SystemMenu) 
    CreateGadgetList(WindowID(0)) 
    ImageGadget(0, 0, 0, ImageWidth(0), ImageHeight(0), ImageID(0), #PB_Image_Border) 
      
    Repeat 
    Until WaitWindowEvent() = #PB_Event_CloseWindow 
  Else 
    MessageRequester("Error", "Can't load the image...", 0) 
  EndIf 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger
