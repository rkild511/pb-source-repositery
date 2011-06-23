; German forum:
; Author: Unknown (updated for PB4.00 by blbltheworm & Andre)
; Date: 22. March 2003
; OS: Windows
; Demo: No

Procedure PaintMapfile(pWindow.l)
  Filename$ = "..\..\Graphics\Gfx\PureBasic.bmp"
  Filehandle = OpenFile_(Filename$,OfStruct.OFSTRUCT,#OF_READWRITE)
  ;Mit CreateFileMapping ein Map-Handle ermitteln
  MapHandle = CreateFileMapping_(Filehandle,0,#PAGE_READWRITE,0,0,0)
  ;Mit MapViewOfFile ein File-Mapping-Object anlegen
  bdata= MapViewOfFile_(MapHandle,#FILE_MAP_ALL_ACCESS,0,0,0)
  ;Pointer fuer Bitmapdaten
  
  OfBits = PeekL(bdata+10);Hier beginnen die Bilddaten
  
  BmpWidth = PeekL(bdata+18);Bildbreite
  BmpHeight = PeekL(bdata+22);Bildhoehe
  BitsPixel = PeekL(bdata+28);Farbtiefe
  
  DataPointer = bdata + 14;Start - Bilddaten
  PixelStartPointer = bdata + OfBits;Start - Pixeldaten
  
  ;aus dem gemappten File auf den Bildschirm
  Bdc = StartDrawing(WindowOutput(pWindow))
  StretchDIBits_(Bdc,0,0,BmpWidth,BmpHeight,0,0,BmpWidth,BmpHeight,PixelStartPointer,DataPointer,#DIB_RGB_COLORS,#SRCCOPY)
  StopDrawing()
  UnmapViewOfFile_(bdata)
  CloseHandle_(Filehandle)
  CloseHandle_(MapHandle)
EndProcedure

If OpenWindow(0, 0, 0, 768, 520, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  PaintMapfile(0)
  Repeat
    EventID.l = WaitWindowEvent()
    If EventID = #PB_Event_CloseWindow  ; If the user has pressed on the close button
      Quit = 1
    EndIf
  Until Quit = 1
EndIf
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -