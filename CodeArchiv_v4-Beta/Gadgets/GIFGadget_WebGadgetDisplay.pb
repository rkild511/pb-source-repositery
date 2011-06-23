; English forum: http://www.purebasic.fr/english/viewtopic.php?t=13855&highlight=
; Author: Sparkie (updated for PB 4.00 by Andre)
; Date: 31. January 2005
; OS: Windows
; Demo: Yes

; *****       Sparkies GIF display        ***** 
; Portions of code produced by fellow PB'er "PB" 
; You can also change the color of the WebGadget background to help with tranparent .GIF's.
Enumeration 
  #GIF_0 
  #GIF_1
  #GIF_2 
EndEnumeration 

Procedure myGIFGadget(id, x, y, bg$, gif$) 
  If FileSize(gif$) > 0 
    ; --> Read GIF file to get width and height 
    ; --> This is used to resize the webgadget to fit the GIF 
    ReadFile(0, gif$) 
    FileSeek(0, 6) 
    gifWidth = ReadWord(0) 
    gifHeight = ReadWord(0) 
    CloseFile(0) 
    ; --> Create blank HTML page to load the GIF image 
    url$ = "about:<html>" 
    ; --> Remove margins and scrollbars 
    url$ + "<body bgcolor= '#" + bg$ + "' topmargin=0 leftmargin=0 scroll='no'>" 
    ; --> Our image source is here 
    url$ + "<img src='" + gif$ + "'></body></html>')" 
    ; --> Greate the GIF/WebGadget 
    WebGadget(id, x, y, gifWidth, gifHeight, url$) 
    ; --> No mouse clicks accepted 
    DisableGadget(id, 1) 
  EndIf 
EndProcedure 

If OpenWindow(0, 0, 0, 600, 400, "Gif display", #PB_Window_SystemMenu | #PB_Window_ScreenCentered) And CreateGadgetList(WindowID(0)) 
  ; --> Set background color for webgadget 
  bgColor$ = Hex(RGB(224, 223, 227)) 
  ; --> You can remove the OpenFileRequester 
  ; --> And replace it with the path to your GIF 
  ; --> myGIFGadget(WebGadget#, xPos, yPos, bgColor, imagePath$) 
  image$ = OpenFileRequester("Choose image for myGIFGadget #0", "c:\",  "Gif file | *.Gif", 0)
  myGIFGadget(#GIF_0, 10, 10, bgColor$, image$) 
  myGIFGadget(#GIF_1, 60,110, bgColor$, image$) 
  myGIFGadget(#GIF_2,110,210, bgColor$, image$) 
  Repeat 
    event = WaitWindowEvent() 
  Until event = #PB_Event_CloseWindow 
EndIf 
End 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -