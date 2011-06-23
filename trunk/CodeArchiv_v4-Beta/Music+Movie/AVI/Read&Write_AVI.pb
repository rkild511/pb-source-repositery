; www.purearea.net (Sourcecode collection by cnesm)
; Author: dige (updated for PB4.00 by blbltheworm)
; Date: 22. November 2003
; OS: Windows
; Demo: No

Structure AVI_INFO
  aviWidth.l
  aviHeight.l
  aviFirstFrame.l
  aviNumFrames.l
  aviFPS.b
  hWnd.l
EndStructure

Enumeration
#Lib
EndEnumeration

UseJPEGImageDecoder()

Procedure AVI2BMP ()
  file.s = OpenFileRequester( "Open AVI", "", "AVI Video|*.avi", 0 )
  *INF.AVI_INFO = CallFunction( #Lib, "OpenAVIforRead", file.s )
  If *INF
    MessageRequester( "AVI Stream Info", "Size: " + Str(*INF\aviWidth) + "x" + Str(*INF\aviHeight) + Chr(13) + "Frames: " + Str(*INF\aviNumFrames), 0 )
    hBmp = CreateImage ( 0, *INF\aviWidth, *INF\aviHeight )
    
    For a = *INF\aviFirstFrame To *INF\aviNumFrames - *INF\aviFirstFrame - 1
      If CallFunction( #Lib, "GetFrameFromAVI", hBmp, a )
        SaveImage(0, "Sequence_" + Right("000" + Str(a), 4 ) + ".bmp" )
      Else
        a = *INF\aviNumFrames + 1
      EndIf
    Next
    
    CallFunction( #Lib, "CloseAVIStreams" )
    MessageRequester( "Done", "AVI splitted to bitmaps", 0 )
  Else
    MessageRequester( "Error", "Could not open avi", 0)
  EndIf
EndProcedure
Procedure BMP2AVI ()
  INF.AVI_INFO
  INF\hWnd = OpenWindow(0, 0, 0, 300, 200, "Images 2 AVI" , #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  If INF\hWnd And CreateGadgetList( INF\hWnd )
    ListViewGadget( 0, 0, 0, 300, 200 )
    
    file.s = SaveFileRequester( "Save AVI", "", "AVI Video|*.avi", 0 )
    dir.s = PathRequester( "Select images directory", GetPathPart( file.s ))
    
    If ExamineDirectory( 0, dir.s, "*.*" )
      Repeat
        Res = NextDirectoryEntry( 0)
        If Res = 1
          img.s = DirectoryEntryName( 0)
          ext.s = UCase(GetExtensionPart(img.s))
          
          If ext = "BMP" Or ext = "JPG" Or ext = "JPEG"
            
            hBmp = LoadImage(0, dir + img )
            If hBmp
              If INF\aviWidth <= 0
                INF\aviWidth  = ImageWidth(0)
                INF\aviHeight = ImageHeight(0)
                INF\aviFPS    = 25 ; Play 25 Frame per Second
                SetForegroundWindow_( INF\hWnd )
                If CallFunction( #Lib, "OpenAVIforWrite", file.s, @INF ) = #False : Res = 0 : EndIf
              EndIf
              
              If INF\aviWidth + INF\aviHeight <> ImageWidth(0) + ImageHeight(0)
                hBmp = ResizeImage( 0, INF\aviWidth, INF\aviHeight )
              EndIf
              
              If INF\aviWidth
                StartDrawing( ImageOutput( 0) )
                ; Make some image effects ...
                DrawingMode( 1|2 )
                DrawText(1, 1, "PureBasic RuLeS! :-)" )
                DrawText(INF\aviWidth - TextWidth( img ) - 10, INF\aviHeight - 20 , img )
                StopDrawing()
                If CallFunction( #Lib, "AddFrameToAVI", hBmp, -1 ) = #True ; -1 Autoincrement FrameNr
                  Frames + 1
                EndIf
              EndIf
            Else
              img + " failed"
            EndIf
            AddGadgetItem( 0, -1, img )
          EndIf
        EndIf
      Until Res = 0
      AddGadgetItem(0, -1, "Done. " + Str(Frames) + " Images." )
      CallFunction( #Lib, "CloseAVIStreams" )
      Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
    EndIf
  EndIf
EndProcedure

If OpenLibrary( #Lib, "AVIServ.dll" )
  If CallFunction( #Lib, "AVI_Init" )
    
    AVI2BMP() ; Splitt AVI video into singel frames
    BMP2AVI() ; Create AVI and add *jpg, *bmp images
    
    CallFunction( #Lib, "AVI_Quit" )
  EndIf
  CloseLibrary( #Lib )
Else
  MessageRequester( "Error", "Could not open AVIServ.dll", 0)
EndIf

End


; Die Dll kann unter http://www.sunset-team.de/Download/AVIServ.zip
; heruntergeladen werden [11 kB]
;
; Nachfolgend 2 mögliche Anwendungsbeispiele:
; AVI2BMP : Konvertiert eine AVI Datei in Einzelbilder
; BMP2AVI : Erstellt ein AVI Video aus JPG, BMP Bildern eines Verzeichnises


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -