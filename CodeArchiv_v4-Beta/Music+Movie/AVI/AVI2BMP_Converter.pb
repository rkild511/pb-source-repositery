; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2387&highlight=
; Author: dige (updated for PB4.00 by blbltheworm + Andre)
; Date: 25. September 2003
; OS: Windows
; Demo: Yes

; Converts a AVI videostream into single bmp frames 
; AVI2BMP Video in Einzelbilder konvertieren
; dige 09/2003 
#streamtypeVIDEO = $73646976 
#AVIGETFRAMEF_BESTDISPLAYFMT = 1 
#AVI_ERR_OK = 0 
#Lib = 0 

Procedure AVI2BMP ( avifile.s, bmpfile.s ) 
  *ptr.BITMAPINFOHEADER 
  bfh.BITMAPFILEHEADER 
  
  bmpdir.s = GetPathPart( bmpfile ) 
  bmpfile  = GetFilePart( bmpfile ) 
  
  res = CallFunction( #Lib, "AVIFileOpen", @pAVIFile, @avifile.s, #OF_SHARE_DENY_WRITE, 0 ) 
  
  If res = #AVI_ERR_OK 

    res = CallFunction( #Lib, "AVIFileGetStream", pAVIFile, @pAVIStream, #streamtypeVIDEO, 0 ) 
    If res = #AVI_ERR_OK 

      firstFrame = CallFunction( #Lib, "AVIStreamStart", pAVIStream ) 
      numFrames  = CallFunction( #Lib, "AVIStreamLength", pAVIStream ) 

      pGetFrameObj = CallFunction( #Lib, "AVIStreamGetFrameOpen", pAVIStream, #AVIGETFRAMEF_BESTDISPLAYFMT ) 

      For a = firstFrame To ( numFrames - 1 ) - firstFrame 
        *ptr = CallFunction( #Lib, "AVIStreamGetFrame", pGetFrameObj, a ) 
        If *ptr And OpenFile ( 0, bmpdir + Right("000" + Str(a), 4 ) + "_" + bmpfile ) 
        
          bfh\bfType = $4D42 
          bfh\bfSize = SizeOf(BITMAPFILEHEADER) + *ptr\biSize + *ptr\biSizeImage 
          bfh\bfReserved1 = 0 
          bfh\bfReserved2 = 0 
          bfh\bfOffBits = SizeOf(BITMAPFILEHEADER) + *ptr\biSize 
        
          WriteData( 0, @bfh, SizeOf(BITMAPFILEHEADER) ) 
          WriteData( 0, *ptr, SizeOf(BITMAPINFOHEADER) ) 
          WriteData( 0, *ptr+SizeOf(BITMAPINFOHEADER), *ptr\biSizeImage) 
        
          CloseFile (0) 
        EndIf 
      Next 
      CallFunction( #Lib, "AVIStreamGetFrameClose", pGetFrameObj ) 
    EndIf 
    CallFunction( #Lib, "AVIFileRelease", pAVIFile ) 
  EndIf 
  MessageRequester( "AVI2BMP", Str(numFrames) + " Frames extracted",  0 ) 
EndProcedure 
  
If OpenLibrary  ( #Lib , "AVIFIL32.DLL") 
  CallFunction ( #Lib,  "AVIFileInit" ) ; AVI Initialisieren 

  avifile.s = OpenFileRequester ( "AVI File auswählen", "", "Video|*.avi", 0 ) 

  If avifile
    bmpfile.s = SaveFileRequester ( "BMP Ausgabe Pfad", GetPathPart( avifile.s )+"Avi2bmp.bmp", "Bild|*bmp", 0  ) 
  EndIf

  If avifile And bmpfile : AVI2BMP( avifile, bmpfile ) : EndIf 

  CallFunction( #Lib, "AVIFileExit" ) 
  CloseLibrary( #Lib ) 
EndIf 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
