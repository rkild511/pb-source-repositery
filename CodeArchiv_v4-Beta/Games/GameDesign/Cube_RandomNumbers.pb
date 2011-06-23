; German forum: http://www.purebasic.fr/german/viewtopic.php?t=3249&start=10
; Author: NicTheQuick (updated for PB 4.00 by Andre)
; Date: 05. May 2005
; OS: Windows, Linux
; Demo: Yes

Global Wuerfel_Size.l, Wuerfel_Points_r.l 

Wuerfel_Size = 100 
Wuerfel_Points_r = Wuerfel_Size / 10 

Global Wuerfel_Img.l 
Procedure DrawWuerfel(Nr.l) 
  Protected a.l, x.l, y.l, drhx.l, drhy.l 
  
  If Nr < 0 And Nr > 6 : ProcedureReturn #False : EndIf 
  
  If IsImage(Wuerfel_Img) : FreeImage(Wuerfel_Img) : EndIf 
  
  Wuerfel_Img = CreateImage(#PB_Any, Wuerfel_Size, Wuerfel_Size) 
  If Wuerfel_Img 
    Restore Wuerfel_Pos 
    a = Nr * (Nr - 1) / 2 
    
    While a : Read x : Read y : a - 1 : Wend 
    
    StartDrawing(ImageOutput(Wuerfel_Img)) 
      
      DrawingMode(0) 
      Box(0, 0, Wuerfel_Size - 1, Wuerfel_Size - 1, $FFFFFF) 
      
      drhx = Random(1) 
      drhy = Random(1) 
      For a = 1 To Nr 
        Read x : If drhx : x = 100 - x : EndIf 
        Read y : If drhy : y = 100 - y : EndIf 
        
        x = x * Wuerfel_Size / 100 
        y = y * Wuerfel_Size / 100 
        
        Circle(x, y, Wuerfel_Points_r, $000000) 
      Next 
      
    StopDrawing() 
    
    ProcedureReturn Wuerfel_Img 
  Else 
    ProcedureReturn #False 
  EndIf 
  
  DataSection 
    Wuerfel_Pos: 
      Data.l 50, 50 
      Data.l 25, 25, 75, 75 
      Data.l 25, 25, 50, 50, 75, 75 
      Data.l 25, 25, 75, 25, 25, 75, 75, 75 
      Data.l 25, 25, 75, 25, 50, 50, 25, 75, 75, 75 
      Data.l 25, 25, 75, 25, 25, 50, 75, 50, 25, 75, 75, 75 
  EndDataSection 
EndProcedure 

DrawWuerfel(0) 
If OpenWindow(0, 0, 0, Wuerfel_Size + 10, Wuerfel_Size + 40, "Würfel", #PB_Window_SystemMenu | #PB_Window_ScreenCentered) 
  If CreateGadgetList(WindowID(0)) 
    Gad_Image.l  = ImageGadget(#PB_Any, 5, 5, Wuerfel_Size, Wuerfel_Size, ImageID(Wuerfel_Img), #PB_Image_Border) 
    Gad_Button.l = ButtonGadget(#PB_Any, 5, Wuerfel_Size + 15, Wuerfel_Size, 20, "Würfeln...") 
    
    Repeat 
      EventID.l = WaitWindowEvent() 
      
      Select EventID 
        Case #PB_Event_CloseWindow 
          Break 
        Case #PB_Event_Gadget 
          Select EventGadget() 
            Case Gad_Button 
              DrawWuerfel(Random(5) + 1) 
              SetGadgetState(Gad_Image, ImageID(Wuerfel_Img)) 
          EndSelect 
      EndSelect 
    ForEver 
  EndIf 
  
  CloseWindow(0) 
EndIf

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -