; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2015&highlight=
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 18. August 2003
; OS: Windows
; Demo: No


; #page defines the address of the image to load
; #page definiert die Adresse des zu ladenden Bildes
Procedure UpdateImage() 
  #page = "http://www.hzs.be/antwerp/schelde.jpg"   ; there is probably only every xx minutes a new picture on the server !
  DeleteUrlCacheEntry_(#page) 
  URLDownloadToFile_(0,#page, "c:\__temp.jpg", 0, 0) 
  LoadImage(0, "c:\__temp.jpg") 
  DeleteFile("c:\__temp.jpg") 
  If IsGadget(0)
    SetGadgetState(0,ImageID(0)) 
  EndIf 
EndProcedure 

UseJPEGImageDecoder() 

UpdateImage() 

OpenWindow(0, 0, 0, ImageWidth(0), ImageHeight(0), "PB - Webcam!", #PB_Window_SystemMenu) 
  CreateGadgetList(WindowID(0)) 
  ImageGadget(0,0,0,ImageWidth(0),ImageHeight(0),ImageID(0),#PB_Image_Border) 

SetTimer_(WindowID(0),1,10000,0) 

Repeat 
  Select WaitWindowEvent() 
    Case #PB_Event_CloseWindow 
      End 
    Case #WM_TIMER 
      UpdateImage() 
      Beep_(800,50) 
  EndSelect 
ForEver 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
