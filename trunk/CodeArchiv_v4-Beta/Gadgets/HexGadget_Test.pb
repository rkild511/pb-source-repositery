; PureBasic IRC Chat 
; Author: pcfreak
; Date: 26. November 2006
; OS: Windows
; Demo: No

; Demonstration of a self-made gadget in PureBasic
; Demonstration eines selbst-erstellten Gadgets in PureBasic

XIncludeFile "HexGadget.pbi"

OpenWindow(0,0,0,320,240,"HexEditGadget",#PB_Window_SystemMenu|#PB_Window_MinimizeGadget|#PB_Window_ScreenCentered|#PB_Window_Invisible)

If CreateGadgetList(WindowID(0))
 hWnd = HexEditGadget(WindowID(0), 10, 30, 300, 200, 8, 14, 0);#ES_READONLY
 If hWnd
  ;Debug hWnd
  HE_SetFont(hWnd, FontID(LoadFont(#PB_Any,"Courier",8)))
  HE_SetMem(hWnd, $400000, $400000, #HE_DefaultMemSize)
  HE_SetMem(hWnd, ?DataField, ?DataField, #HE_DefaultMemSize)
  HE_SetReadOnlyHL(hWnd, #True)
 EndIf
 ButtonGadget(1,250,10,20,20,"<-")
 ButtonGadget(2,270,10,20,20,"->")
 ButtonGadget(3,230,10,20,20,"<<")
 ButtonGadget(4,290,10,20,20,">>")
EndIf

While WindowEvent() : Wend
HideWindow(0,#False)

Repeat

Select WaitWindowEvent()
 Case #PB_Event_Gadget
  Select EventGadget()
   Case 1
    If hWnd
     *mem = HE_GetMemAddress(hWnd) - HE_GetMemSize(hWnd)
     HE_SetMem(hWnd, *mem, *mem, #HE_DefaultMemSize)
    EndIf
   Case 2
    If hWnd
     *mem = HE_GetMemAddress(hWnd) + HE_GetMemSize(hWnd)
     HE_SetMem(hWnd, *mem, *mem, #HE_DefaultMemSize)
    EndIf
   Case 3
    If hWnd
     *mem = HE_GetMemAddress(hWnd) - (HE_GetMemSize(hWnd) * 100)
     HE_SetMem(hWnd, *mem, *mem, #HE_DefaultMemSize)
    EndIf
   Case 4
    If hWnd
     *mem = HE_GetMemAddress(hWnd) + (HE_GetMemSize(hWnd) * 100)
     HE_SetMem(hWnd, *mem, *mem, #HE_DefaultMemSize)
    EndIf
  EndSelect
 Case #PB_Event_CloseWindow
  FreeHexEditGadgetClass()
  End
EndSelect

ForEver

DataSection
 DataField:
  Data.b $2A, $91, $D4, $3B, $4A, $0A, $E5, $9B, $6E, $F3, $37, $D2, $45, $3F
  Data.b $25, $A3, $FF, $89, $07, $FE, $D1, $1D, $7B, $5E, $C2, $AF, $21, $5F
  Data.b $10, $2B, $75, $11, $5F, $13, $0B, $F8, $FD, $BC, $F3, $C7, $A0, $6A
  Data.b $B4, $66, $95, $77, $91, $2E, $9E, $1C, $42, $28, $FD, $D5, $BF, $7D
  Data.b $F9, $20, $09, $92, $15, $D0, $CB, $AD, $1F, $22, $74, $22, $D3, $6A
  Data.b $BC, $13, $29, $C1, $E3, $57, $E0, $16, $14, $20, $80, $B4, $64, $55
  Data.b $E7, $FA, $ED, $F2, $48, $6A, $00, $30, $85, $48, $F7, $E5, $30, $84
  Data.b $0C, $A2, $D0, $D1, $36, $DF, $91, $ED, $A7, $E1, $DE, $17, $08, $B6
EndDataSection
; IDE Options = PureBasic v4.02 (Windows - x86)
; CursorPosition = 9
; Folding = -
; EnableXP