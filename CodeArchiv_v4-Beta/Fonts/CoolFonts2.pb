; English forum: 
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 11. November 2002
; OS: Windows
; Demo: No

;
; Cool Fonts 2, by Danilo - 11.11.2002
;
#FONT_NORMAL    = %00000000
#FONT_BOLD      = %00000001
#FONT_ITALIC    = %00000010
#FONT_UNDERLINE = %00000100
#FONT_STRIKEOUT = %00001000

Procedure SetNewGadgetFont(Gadget,FontID)
   SendMessage_(GadgetID(Gadget),#WM_SETFONT,FontID,#True)
EndProcedure

Procedure CreateFont(Name$,Size,Style)
   If (Style & #FONT_BOLD)      : bold = 700    : EndIf
   If (Style & #FONT_ITALIC)    : italic = 1    : EndIf
   If (Style & #FONT_UNDERLINE) : underline = 1 : EndIf
   If (Style & #FONT_STRIKEOUT) : strikeout = 1 : EndIf
   ProcedureReturn CreateFont_(Size,0,0,0,bold,italic,underline,strikeout,0,0,0,0,0,Name$)
EndProcedure

Normal    = CreateFont("Courier",14,#FONT_NORMAL)
bold      = CreateFont("Courier",14,#FONT_BOLD)
italic    = CreateFont("Courier",14,#FONT_ITALIC)
underline = CreateFont("Courier",14,#FONT_UNDERLINE)
strikeout = CreateFont("Courier",14,#FONT_STRIKEOUT)
Combined1 = CreateFont("Courier",14,#FONT_BOLD|#FONT_UNDERLINE)
Combined2 = CreateFont("Courier",14,#FONT_ITALIC|#FONT_UNDERLINE|#FONT_STRIKEOUT|#FONT_BOLD)
Combined3 = CreateFont("Arial"  ,20,#FONT_BOLD|#FONT_UNDERLINE)   

OpenWindow(1,200,200,200,200,"Cool Fonts",#PB_Window_SystemMenu)
   CreateGadgetList(WindowID(1))
   StringGadget(1,10, 10,180,20,"Normal")     : SetNewGadgetFont(1,Normal)
   StringGadget(2,10, 30,180,20,"Bold")       : SetNewGadgetFont(2,bold)
   StringGadget(3,10, 50,180,20,"Italic")     : SetNewGadgetFont(3,italic)
   StringGadget(4,10, 70,180,20,"Underline")  : SetNewGadgetFont(4,underline)
   StringGadget(5,10, 90,180,20,"StrikeOut")  : SetNewGadgetFont(5,strikeout)
   StringGadget(6,10,110,180,20,"Combined 1") : SetNewGadgetFont(6,Combined1)
   StringGadget(7,10,130,180,20,"Combined 2") : SetNewGadgetFont(7,Combined2)

   ButtonGadget(8,70,160, 60,30,"Quit")       : SetNewGadgetFont(8,Combined3)

Repeat:Until WaitWindowEvent() = #PB_Event_CloseWindow Or EventGadget() = 8

CleanUp:
 DeleteObject_(Normal)   : DeleteObject_(Bold)
 DeleteObject_(Italic)   : DeleteObject_(Underline)
 DeleteObject_(StrikeOut): DeleteObject_(Combined1)
 DeleteObject_(Combined2)

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger