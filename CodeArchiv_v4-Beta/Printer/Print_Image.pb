; English forum: 
; Author: Paul (updated for PB4.00 by blbltheworm)
; Date: 06. November 2002
; OS: Windows
; Demo: Yes


;PrintImage - by Paul Leischow
;=============================
;This code snippet will resize a BMP so that it prints
;the same size on all printers regardless of printer
;quality or resolution.
;
;It can also resize the image to fill the entire width
;of the printer page.


#pic=1

If LoadImage(#pic,"..\Graphics\Gfx\purebasic.bmp")        ;<---load your BMP image here
  If PrintRequester() 
    fiximage.f=(ImageWidth(#pic)*8.39)/PrinterPageWidth()

    imgx.f=ImageWidth(#pic)/fiximage
    imgy.f=ImageHeight(#pic)/fiximage
    ResizeImage(#pic,imgx,imgy)      ;<---this sizes image To print exact size  
    
    fillx.f=imgx*(PrinterPageWidth()/imgx)
    filly.f=imgy*(PrinterPageWidth()/imgx)
    ;ResizeImage(#pic,fillx,filly)   ;<---this sizes image to fit full page
       
    If StartPrinting("Print Job")     
      If StartDrawing(PrinterOutput())
        DrawImage(ImageID(#pic),100,500)
        StopDrawing()        
      EndIf      
      StopPrinting()          
    EndIf    
    MessageRequester("Print","Data has been sent to Printer",#MB_ICONINFORMATION)  
  EndIf
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableAsm
; UseIcon = D:\RM Apps\Angler Pro\work\fish red.ICO
; Executable = D:\RM Apps\Angler Pro\Plugins\ar_teamtags.exe