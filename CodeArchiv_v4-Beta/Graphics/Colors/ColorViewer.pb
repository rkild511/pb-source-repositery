; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1418&highlight=
; Author: CSprengel (updated for PB4.00 by blbltheworm)
; Date: 20. June 2003
; OS: Windows
; Demo: Yes


; Calculate the hex-code of all 16.8 mio. colors

; Farbenhexer gibt den Hexcode einer Farbe aus. Zusätzlich hab ich noch GPI's HexVal hinzu gefügt,
; so wird auch der Wert der Farbe ausgegeben. 
; Damit kann man Problemlos den Hexcode aller 16,8 Millionen Farben ermitteln. 

;FarbenHexer 
;CSprengel 
;Procedure HexVal() ist von GPI 
;Juni 2003 

Procedure HexVal(a$) 
  a$=Trim(UCase(a$)) 
  If Asc(a$)='$' 
    a$=Trim(Mid(a$,2,Len(a$)-1)) 
  EndIf 
  result=0 
  *adr.BYTE=@a$ 
  For i=1 To Len(a$) 
    result<<4 
    Select *adr\b 
      Case '0' 
      Case '1':result+1 
      Case '2':result+2 
      Case '3':result+3 
      Case '4':result+4 
      Case '5':result+5 
      Case '6':result+6 
      Case '7':result+7 
      Case '8':result+8 
      Case '9':result+9 
      Case 'A':result+10 
      Case 'B':result+11 
      Case 'C':result+12 
      Case 'D':result+13 
      Case 'E':result+14 
      Case 'F':result+15 
      Default:i=Len(a$) 
    EndSelect 
    *adr+1 
  Next 
  ProcedureReturn result 
EndProcedure 

If OpenWindow(0, 0, 0, 340, 140, "FarbenHexer", #PB_Window_MinimizeGadget| #PB_Window_ScreenCentered) 
  If CreateGadgetList(WindowID(0)) 
    TextGadget(0, 5, 5, 25, 20, "rot") 
    TrackBarGadget(1, 35,  5, 265, 20, 0, 255) 
    StringGadget(2, 305, 5, 30, 20, "0", #PB_String_ReadOnly) 
    
    TextGadget(10, 5, 30, 25, 20, "grün") 
    TrackBarGadget(11, 35, 30, 265, 20, 0, 255) 
    StringGadget(12, 305, 30, 30, 20, "0", #PB_String_ReadOnly) 
    
    TextGadget(20, 5, 55, 25, 20, "blau") 
    TrackBarGadget(21, 35, 55, 265, 20, 0, 255) 
    StringGadget(22, 305, 55, 30, 20, "0", #PB_String_ReadOnly) 
    
    StringGadget(30, 5, 90 , 60, 20, "$000000", #PB_String_ReadOnly) 
    StringGadget(40, 5, 115, 60, 20, "0"      , #PB_String_ReadOnly) 
  EndIf 
  
  CreateImage(1, 260, 20) 
  CreateImage(2, 260, 20) 
  rot   = 0 
  gruen = 0 
  blau  = 0 
EndIf 


Repeat 
  rot_hex$   = Hex(rot) 
  gruen_hex$ = Hex(gruen) 
  blau_hex$  = Hex(blau) 
  
  Farbe$ = "$" 
  If Len(blau_hex$) = 2 
    Farbe$ + blau_hex$ 
  Else 
    Farbe$ + "0" + blau_hex$ 
  EndIf 
  If Len(gruen_hex$) = 2 
    Farbe$ + gruen_hex$ 
  Else 
    Farbe$ + "0" + gruen_hex$ 
  EndIf 
  If Len(rot_hex$) = 2 
    Farbe$ + rot_hex$ 
  Else 
    Farbe$ + "0" + rot_hex$ 
  EndIf 
  
  If Farbe$ <> Farbe_merken$ 
    SetGadgetText(30, Farbe$) 
    Farbe_merken$ = Farbe$    
  EndIf    
  
  Wert = HexVal(Farbe$) 
  If Wert <> Wert_merken 
    SetGadgetText(40, Str(Wert)) 
    Wert_merken = Wert    
  EndIf 
  
  StartDrawing(ImageOutput(1)) 
    Box(0, 0, 260, 20, RGB(rot, gruen, blau)) 
  StopDrawing() 
  StartDrawing(ImageOutput(2)) 
    Box(0, 0, 260, 20, Wert) 
  StopDrawing()  
  
  StartDrawing(WindowOutput(0)) 
    DrawImage(ImageID(1), 75, 90) 
  StopDrawing() 
  StartDrawing(WindowOutput(0)) 
    DrawImage(ImageID(2), 75, 115) 
  StopDrawing() 
  
  EventID = WaitWindowEvent() 
  
  If EventID = #PB_Event_Gadget 
    Select EventMenu() 
      Case 1 
        rot = GetGadgetState(1) 
        SetGadgetText(2, Str(rot)) 
      Case 11 
        gruen = GetGadgetState(11) 
        SetGadgetText(12, Str(gruen)) 
      Case 21 
        blau = GetGadgetState(21) 
        SetGadgetText(22, Str(blau)) 
    EndSelect  
  EndIf  
Until EventID = #PB_Event_CloseWindow

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP