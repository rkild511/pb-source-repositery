; German forum: 
; Author: Danilo
; Date: 24. July 2002
; OS: Windows
; Demo: No


; Need the NView.dll

Procedure LoadNViewImage(ImageNumber,FileName$)
  ;
  ; Load JPG, JIF, GIF, BMP, DIB, RLE, TGA and PCX images with PB and NViewLib.DLL
  ; NViewLib 1.1.4 is free: http://www.programmersheaven.com/file.asp?FileID=2045
  ;
  ;
  ; SYNTAX
  ;    ImageHandle = LoadNViewImage(#Image, FileName$)
  ;
  ; DESCRIPTION
  ;    Load the specified image.
  ;    The image format can be a JPG, JIF, GIF, BMP, DIB, RLE, TGA or PCX file.
  ;    If the function fails, 0 is returned, Else all is fine.
  ;    This command requires the NVIEWLIB.DLL in the Path.
  ;
     If OpenLibrary(0,"nviewlib.dll")
        AddrImage = CallFunction(0,"NViewLibLoad",FileName$,0)
        Width     = CallFunction(0,"GetWidth")
        Height    = CallFunction(0,"GetHeight")
        newImage  = CreateImage(ImageNumber,Width,Height)
                    StartDrawing(ImageOutput(ImageNumber))
                       DrawImage(AddrImage,0,0)
                    StopDrawing()
                    DeleteObject_(AddrImage)
        CloseLibrary(0)
     Else
        MessageRequester("ERROR","Cant find NVIEWLIB.DLL in Path",0):End
     EndIf
  ProcedureReturn newImage
EndProcedure



File$ = OpenFileRequester("Load Image", "", "All supported images | *.jpg;*.jpeg;*.jif;*.gif;*.bmp;*.dib;*.rle;*.tga;*.pcx | All files *.* | *.*", 0)
If File$ <> ""
  If LoadNViewImage(1,File$)
  
    #FLAGS = #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget
    OpenWindow(0,200,200,ImageWidth(1),ImageHeight(1),"PB Image Viewer",#FLAGS)
    SetForegroundWindow_(WindowID(0))
  
    Repeat
       event=WaitWindowEvent()
       If event=#WM_PAINT
          StartDrawing(WindowOutput(0))
             DrawImage(ImageID(1),0,0)
          StopDrawing()         
       EndIf
    Until event=#PB_Event_CloseWindow
  
  EndIf
EndIf
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger