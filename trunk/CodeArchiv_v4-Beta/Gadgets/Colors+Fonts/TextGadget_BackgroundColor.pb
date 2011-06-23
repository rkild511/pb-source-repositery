; German forum:
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 08. November 2002
; OS: Windows
; Demo: No

; +++ updated 03/2005 by Team100 for use with PB 3.93


#Text_Background_Green = $00FF00  ; Gruener Hintergrund 
#Text_Background_Red   = $0000FF  ; Roter Hintergrund 
#Text_Foreground       = $000000  ; Schrift-Farbe 

#MaxTextGadgets        = 20       ; Max. Anzahl TextGadgets 

Global Dim TextGadgetColors.l(#MaxTextGadgets) 

Text_Background_Green = CreateSolidBrush_(#Text_Background_Green) 
Text_Background_Red   = CreateSolidBrush_(#Text_Background_Red) 

OpenWindow(0,200,200,150,310,"TEST",#PB_Window_SystemMenu) 

Procedure TextGadget_Red(GadgetNr) 
   TextGadgetColors(GadgetNr) = 1 
   InvalidateRect_(GadgetID(GadgetNr),0,1) 
EndProcedure 

Procedure TextGadget_Green(GadgetNr) 
   TextGadgetColors(GadgetNr) = 0 
   InvalidateRect_(GadgetID(GadgetNr),0,1) 
EndProcedure 

Procedure WindowCallback(Window,Message,wParam,lParam) 
Shared Text_Background_Green, Text_Background_Red 
  Result = #PB_ProcessPureBasicEvents 
  Select Message 
     Case #WM_CTLCOLORSTATIC 
        For a = 1 To #MaxTextGadgets 
          If IsGadget(a)                      ; +++ need for PB3.93+ with debugger on
           If lParam = GadgetID(a) 
              SetBkMode_(wParam,#TRANSPARENT) 
              SetTextColor_(wParam, #Text_Foreground) 
              If TextGadgetColors(a) = 0 
                 Result = Text_Background_Green 
              Else 
                 Result = Text_Background_Red 
              EndIf 
           EndIf 
          EndIf 
         Next a 
  EndSelect 
  ProcedureReturn Result 
EndProcedure 

SetWindowCallback(@WindowCallback()) 

CreateGadgetList(WindowID(0)) 
For a = 1 To #MaxTextGadgets 
    TextGadget(a,10,a*14,130,14,"Text-Gadget "+Str(a),#PB_Text_Center) 
Next a 


TextGadget_Red(2) 
TextGadget_Red(7) 
TextGadget_Red(15) 

Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow 


program_end: 
DeleteObject_(Text_Background_Green) 
DeleteObject_(Text_Background_Red) 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger