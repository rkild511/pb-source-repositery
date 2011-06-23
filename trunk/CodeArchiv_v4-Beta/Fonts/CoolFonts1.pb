; English forum: 
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 11. November 2002
; OS: Windows
; Demo: No


; Cool Fonts 1, by Danilo - 11.11.2002
;
#FONT_NORMAL    = %00000000
#FONT_BOLD      = %00000001
#FONT_ITALIC    = %00000010
#FONT_UNDERLINE = %00000100
#FONT_STRIKEOUT = %00001000


Procedure CreateFont(Name$,Size,Style)
   If (Style & #FONT_BOLD)      : bold = 700    : EndIf
   If (Style & #FONT_ITALIC)    : italic = 1    : EndIf
   If (Style & #FONT_UNDERLINE) : underline = 1 : EndIf
   If (Style & #FONT_STRIKEOUT) : strikeout = 1 : EndIf
   ProcedureReturn CreateFont_(Size,0,0,0,bold,italic,underline,strikeout,0,0,0,0,0,Name$)
EndProcedure

Procedure CreateMyImage()
   Normal    = CreateFont("Verdana",48,#FONT_NORMAL)
   bold      = CreateFont("Verdana",48,#FONT_BOLD)
   italic    = CreateFont("Verdana",48,#FONT_ITALIC)
   underline = CreateFont("Verdana",48,#FONT_UNDERLINE)
   strikeout = CreateFont("Verdana",48,#FONT_STRIKEOUT)
   Combined1 = CreateFont("Verdana",48,#FONT_BOLD|#FONT_UNDERLINE)
   Combined2 = CreateFont("Verdana",48,#FONT_ITALIC|#FONT_UNDERLINE|#FONT_STRIKEOUT|#FONT_BOLD)
   
   image = CreateImage(1,600,400)
   StartDrawing(ImageOutput(1))
      DrawingMode(1)
      FrontColor(RGB($FF,$FF,$00))
      
        DrawingFont(Normal)
        DrawText(10,10,"PureBasic - normal")
        DrawingFont(bold)
        DrawText(10,60,"PureBasic - Bold")
        DrawingFont(italic)
        DrawText(10,110,"PureBasic - Italic")
        DrawingFont(Underline)
        DrawText(10,160,"PureBasic - Underline")
        DrawingFont(StrikeOut)
        DrawText(10,210,"PureBasic - StrikeOut")
        DrawingFont(Combined1)
        DrawText(10,260,"PureBasic - Combined 1")
        DrawingFont(Combined2)
        DrawText(10,310,"PureBasic - Combined 2")
   StopDrawing()
   
   DeleteObject_(Normal)   : DeleteObject_(Bold)
   DeleteObject_(Italic)   : DeleteObject_(Underline)
   DeleteObject_(StrikeOut): DeleteObject_(Combined1)
   DeleteObject_(Combined2)

   ProcedureReturn image
EndProcedure

OpenWindow(1,100,200,600,400,"Cool Fonts 1",#PB_Window_SystemMenu)

   myImage = CreateMyImage()

   CreateGadgetList(WindowID(1))
   ImageGadget(1,0,0,600,400,myImage)

Repeat:Until WaitWindowEvent() = #PB_Event_CloseWindow

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger