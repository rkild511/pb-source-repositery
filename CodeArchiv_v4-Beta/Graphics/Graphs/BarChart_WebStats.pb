; www.PureArea.net
; Author: Andre Beer (updated for PB4.00 by blbltheworm)
; Date: 27. April 2003
; OS: Windows
; Demo: Yes


; Graphs - Diagram using bars
; 27th April 2003 by Andre Beer / PureBasic-Team (www.purebasic.com)

;-Init
ImW.w = 500        ; Width of diagram in pixel   \ in this case also the (inner) window
ImH.w = 200        ; Height of diagram in pixel  / dimensions....
MaxValue.w = 80    ; Maximum individual value stored in the diagramm values
Graphs.w = 30      ; Number of bars (graphs) in the diagram
Bottom.l = 1       ; Contents of the bottom bar:
                   ; 0 = print relating values at bottom of the bars
                   ; 1 = use an alternative text, stored in the diagram structure  -  see "Diagram data"
Color.l = 0        ; Number of color-style, currently included only three:
                   ; 0 = blue style
                   ; 1 = brown style
                   ; 2 = green style

;-Structures
Structure Diagram
  Value.l      ; Wert
  XAxis.s      ; Beschriftung x-Achse
EndStructure 

Structure Style
  Front1.l   ; 1st foreground color  (main)
  Front2.l   ; 2nd foreground color  (lighter)
  Front3.l   ; 3rd foreground color  (darker)
  Back1.l    ; 1st background color  (lighter)
  Back2.l    ; 2nd background color  (darker)
  Bottom.l   ; Color of the bottom bar
  Title.l    ; Title color
  Text.l     ; Text color (axis descriptions)
EndStructure


; Init array  (item 0 is used for general settings, item 1 until Graphs+1 contains the diagram data
Global Dim Stats.Diagram(Graphs+1) 

;-ColorStyles
Global Dim Colors.Style(3)

; Set blue color-style
Colors(0)\Front1 = RGB(71,71,108)
Colors(0)\Front2 = RGB(140,140,183)
Colors(0)\Front3 = RGB(49,49,75)
Colors(0)\Back1  = RGB(201,211,233)
Colors(0)\Back2  = RGB(184,197,226)
Colors(0)\Bottom = RGB(255,255,255)
Colors(0)\Title  = RGB(0,0,255)
Colors(0)\Text   = RGB(0,0,0)

; Set red-brown color-style
Colors(1)\Front1 = RGB(108,71,71)
Colors(1)\Front2 = RGB(183,120,120)
Colors(1)\Front3 = RGB(75,49,49)
Colors(1)\Back1  = RGB(233,211,201)
Colors(1)\Back2  = RGB(226,197,184)
Colors(1)\Bottom = RGB(243,232,226)
Colors(1)\Title  = RGB(255,0,0)
Colors(1)\Text   = RGB(240,0,0)

; Set green color-style
Colors(2)\Front1 = RGB(71,108,71)
Colors(2)\Front2 = RGB(120,183,120)
Colors(2)\Front3 = RGB(49,75,49)
Colors(2)\Back1  = RGB(201,233,211)
Colors(2)\Back2  = RGB(184,226,197)
Colors(2)\Bottom = RGB(223,242,228)
Colors(2)\Title  = RGB(49,75,49)
Colors(2)\Text   = RGB(24,58,35)

;-Procedure
Procedure Bars(ID.l, Count.l, x.l, y.l, Width.l, Height.l, Color.l, Title.s) 
  ; ID     = Output-ID for drawing operations (e.g. WindowOutput, ImageOutput, etc.)
  ; Count  = Value-/Bars-number
  ; x, y   = top-left corner of the diagram in pixel
  ; Width  = Width of diagram in pixel
  ; Height = Height of diagram in pixel, including title line and text line
  ; Color  = number of color-style
  ; Title  = String with the text, which should be printed as title line
  
  ; Load fonts
  FontID.l = LoadFont(1, "ARIAL", 10, #PB_Font_Bold | #PB_Font_HighQuality)
  FontID2.l = LoadFont(1, "ARIAL", 8, #PB_Font_HighQuality)
  
  StartDrawing(ID) 

  ; Paint background
  #LeftBar = 20
  #Title   = 24
  #Bottom  = 15
  Box(x,y,Width,Height,Colors(Color)\Back1)       ; paint lighter background fullsize
  Box(x,y,#LeftBar,Height,Colors(Color)\Back2)    ; paint darker bar at left 
  For a = y+18 To y+Height Step 40
    Box(x+#LeftBar+1,a,Width-#LeftBar-1,20,Colors(Color)\Back2)       ; paint darker background bars
  Next a
  Box(x,y+(Height-#Bottom),Width,#Bottom,Colors(Color)\Bottom)  ; paint bar at bottom
  
  ; Paint title string
  FrontColor(RGB(Red(Colors(Color)\Title),Green(Colors(Color)\Title),Blue(Colors(Color)\Title)))
  DrawingMode(1)     ; set drawing-mode to 1 for transparent text drawing
  DrawingFont(FontID)
  DrawText(#LeftBar+(Width-TextWidth(Title))/2, y,Title)

  ; Paint maximum value in left bar
  DrawingFont(FontID2)
  FrontColor(RGB(Red(Colors(Color)\Text),Green(Colors(Color)\Text),Blue(Colors(Color)\Text)))
  DrawText(x+(#LeftBar-TextWidth(Str(Stats(0)\Value)))/2, y+20,Str(Stats(0)\Value))
  
  y + 24

  ; Paint X-Axis description at bottom bar
  DrawText(x+2,y+(Height-#Bottom-#Title),Stats(0)\XAxis)

  ; Do some pre-calculations for diagram positions  
  Height = Height-#Bottom-#Title-1
  Height2.f = Height / Stats(0)\Value
  Width = (Width-#LeftBar-20) / Count
  x = x + #LeftBar + 8 - Width

  ; Paint graphs
  For graph.l = 1 To Count 
    x1 = x + (graph * Width)
    y1 = y + (Height - (Stats(graph)\Value * Height2))
    x2 = x1 + Width - 3
    y2 = y + Height

    LineXY(x1, y1, x1, y2, Colors(Color)\Front2)
    LineXY(x1, y1, x2, y1, Colors(Color)\Front2)
    LineXY(x2, y1, x2, y2, Colors(Color)\Front3)

    DrawingMode(0) 
    Box(x1 + 1, y1 + 1, Width - 4, Stats(graph)\Value * Height2, Colors(Color)\Front1) 
    
    DrawingMode(1)
    FrontColor(RGB(Red(Colors(Color)\Text),Green(Colors(Color)\Text),Blue(Colors(Color)\Text)))
    DrawText(x1 + (Width - TextWidth(Stats(graph)\XAxis))/2, y2+1,Stats(graph)\XAxis)
  Next graph
  
  StopDrawing() 
EndProcedure 

;- Diagram data

; Store some general values
Stats(0)\Value = MaxValue  ; value is relating to 100% diagram height, must correspond to (at least) the greatest individual value!!!
If Bottom=0
  Stats(0)\XAxis = "Value"
Else
  Stats(0)\XAxis = "Day"
EndIf
; Fill data array
For a=1 To Graphs
  Value = Random(MaxValue)
  Stats(a)\Value = Value
  If Bottom=0
    Stats(a)\XAxis = Str(Value)
  Else
    Stats(a)\XAxis = Str(a)
  EndIf
Next a


;-Main Programm 
OpenWindow(0,100,200,ImW,ImH,"Diagrams... ;-)    <written April 2003 by Andre Beer>",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) 

;-Create Image
If CreateImage(0,ImW,ImH)
Else
  Debug "Error when creating image..."
  End
EndIf


;-Call Diagram
; Parameters: OutputID, Elements, x, y, Width, Height, Colorstyle, Title-String
Bars(ImageOutput(0), Graphs, 0, 0, ImW, ImH, Color, "Website Access Statistics")         


WinID.l = WindowID(0)
If CreateGadgetList(WinID)
  ImageGadget(0,2,2,300,220,ImageID(0))
EndIf


;- Main loop
Repeat 
   Event = WaitWindowEvent() 
   Select Event 
      Case #PB_Event_CloseWindow 
         Quit = #True 
   EndSelect 
Until Quit 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -