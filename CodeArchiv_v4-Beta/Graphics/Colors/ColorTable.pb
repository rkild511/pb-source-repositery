; German forum: http://www.purebasic.fr/german/viewtopic.php?t=1847&highlight=
; Author: rayman1970 (updated for PB 4.00 by Andre)
; Date: 29. January 2005
; OS: Windows
; Demo: Yes


#Farbtabelle_max = 134

Procedure grafik(rot,gruen,blau )
  CreateImage(0, 32, 16)
  StartDrawing( ImageOutput(0) )
  Box(0,0,32,16, RGB( rot,gruen,blau ) )
  StopDrawing()
EndProcedure

Structure farb_daten
  farbname.s
  farbwert_rot.w
  farbwert_gruen.w
  farbwert_blau.w
EndStructure



If OpenWindow(0,0,0,245,60,"Rayman´s Farbtabelle",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) And CreateGadgetList(WindowID(0))
  ComboBoxGadget(2,10,10,150,300)
  grafik( 0,0,0 )
  ImageGadget(1,200,10,32,16,ImageID(0),#PB_Image_Border)
  ;{ ------------------ Init Farbtabelle ----------------
  Dim Farbtabelle.farb_daten( #Farbtabelle_max )
  Restore Farbtabelle
  For i = 0 To #Farbtabelle_max
    Read Farbtabelle(i)\farbname
    AddGadgetItem(2,-1,Farbtabelle(i)\farbname)
    Read Farbtabelle(i)\farbwert_blau
    Read Farbtabelle(i)\farbwert_gruen
    Read Farbtabelle(i)\farbwert_rot
  Next i
  SetGadgetState(2,0)
  ;} -----------------------------------------------------


  farbe$ = GetGadgetText( 2 )
  Repeat
    Event = WaitWindowEvent()

    If GetGadgetText( 2 ) <> farbe$
      farbe$ = GetGadgetText( 2 )
      grafik( Farbtabelle(GetGadgetState( 2 ) )\farbwert_rot, Farbtabelle(GetGadgetState( 2 ) )\farbwert_gruen,Farbtabelle(GetGadgetState( 2 ) )\farbwert_blau )
      SetGadgetState(1, ImageID( 0 ) ) ; Die Image Grafik Aktuell machen
    EndIf

  Until Event = #PB_Event_CloseWindow
EndIf


;{ --------------------- Die Farbtabelle -----------------------
DataSection
  Farbtabelle:
  Data.s = "Black"                : Data.w =    $00 , $00 , $00
  Data.s = "Maroon"               : Data.w =    $00 , $00 , $80
  Data.s = "Green"                : Data.w =    $00 , $80 , $00
  Data.s = "Olive"                : Data.w =    $00 , $80 , $80
  Data.s = "Navy"                 : Data.w =    $80 , $00 , $00
  Data.s = "Purple"               : Data.w =    $80 , $00 , $80
  Data.s = "Teal"                 : Data.w =    $80 , $80 , $00
  Data.s = "Gray"                 : Data.w =    $80 , $80 , $80
  Data.s = "Silver"               : Data.w =    $C0 , $C0 , $C0
  Data.s = "Red"                  : Data.w =    $00 , $00 , $FF
  Data.s = "Lime"                 : Data.w =    $00 , $FF , $00
  Data.s = "Yellow"               : Data.w =    $00 , $FF , $FF
  Data.s = "Blue"                 : Data.w =    $FF , $00 , $00
  Data.s = "Fuchsia"              : Data.w =    $FF , $00 , $FF
  Data.s = "Aqua"                 : Data.w =    $FF , $FF , $00
  Data.s = "White"                : Data.w =    $FF , $FF , $FF
  Data.s = "Aliceblue"            : Data.w =    $FF , $F8 , $F0
  Data.s = "Antiquewhite"         : Data.w =    $D7 , $EB , $FA
  Data.s = "Aquamarine"           : Data.w =    $D4 , $FF , $7F
  Data.s = "Azure"                : Data.w =    $FF , $FF , $F0
  Data.s = "Beige"                : Data.w =    $DC , $F5 , $F5
  Data.s = "Blueviolet"           : Data.w =    $E2 , $2B , $8A
  Data.s = "Brown"                : Data.w =    $2A , $2A , $A5
  Data.s = "Burlywood"            : Data.w =    $87 , $B8 , $DE
  Data.s = "Cadetblue"            : Data.w =    $A0 , $9E , $5F
  Data.s = "Chartreuse"           : Data.w =    $00 , $FF , $7F
  Data.s = "Chocolate"            : Data.w =    $1E , $69 , $D2
  Data.s = "Coral"                : Data.w =    $50 , $7F , $FF
  Data.s = "Cornflowerblue"       : Data.w =    $ED , $95 , $64
  Data.s = "Cornsilk"             : Data.w =    $DC , $F8 , $FF
  Data.s = "Crimson"              : Data.w =    $3C , $14 , $DC
  Data.s = "Darkblue"             : Data.w =    $8B , $00 , $00
  Data.s = "Darkcyan"             : Data.w =    $8B , $8B , $00
  Data.s = "Darkgoldenrod"        : Data.w =    $0B , $86 , $B8
  Data.s = "Darkgray"             : Data.w =    $A9 , $A9 , $A9
  Data.s = "Darkgreen"            : Data.w =    $00 , $64 , $00
  Data.s = "Darkkhaki"            : Data.w =    $6B , $B7 , $BD
  Data.s = "Darkmagenta"          : Data.w =    $8B , $00 , $8B
  Data.s = "Darkolivegreen"       : Data.w =    $2F , $6B , $55
  Data.s = "Darkorange"           : Data.w =    $00 , $8C , $FF
  Data.s = "Darkorchid"           : Data.w =    $CC , $32 , $99
  Data.s = "Darkred"              : Data.w =    $00 , $00 , $8B
  Data.s = "Darksalmon"           : Data.w =    $7A , $96 , $E9
  Data.s = "Darkseagreen"         : Data.w =    $8F , $BC , $8F
  Data.s = "Darkslateblue"        : Data.w =    $8B , $3D , $48
  Data.s = "Darkslategray"        : Data.w =    $4F , $4F , $2F
  Data.s = "Darkturquoise"        : Data.w =    $D1 , $CE , $00
  Data.s = "Darkviolet"           : Data.w =    $D3 , $00 , $94
  Data.s = "Deeppink"             : Data.w =    $93 , $14 , $FF
  Data.s = "Deepskyblue"          : Data.w =    $FF , $BF , $00
  Data.s = "Dimgray"              : Data.w =    $69 , $69 , $69
  Data.s = "Dodgerblue"           : Data.w =    $FF , $90 , $1E
  Data.s = "Firebrick"            : Data.w =   $22 , $22 , $B2
  Data.s = "Floralwhite"          : Data.w =    $F0 , $FA , $FF
  Data.s = "Forestgreen"          : Data.w =    $22 , $8B , $22
  Data.s = "Gainsboro"            : Data.w =    $DC , $DC , $DC
  Data.s = "Ghostwhite"           : Data.w =    $FF , $F8 , $F8
  Data.s = "Gold"                 : Data.w =    $00 , $D7 , $FF
  Data.s = "Goldenrod"            : Data.w =    $20 , $A5 , $DA
  Data.s = "Greenyellow"          : Data.w =    $2F , $FF , $AD
  Data.s = "Honeydew"             : Data.w =    $F0 , $FF , $F0
  Data.s = "Hotpink"              : Data.w =    $B4 , $69 , $FF
  Data.s = "Indianred"            : Data.w =    $5C , $5C , $CD
  Data.s = "Indigo"               : Data.w =    $82 , $00 , $4B
  Data.s = "Ivory"                : Data.w =    $F0 , $FF , $FF
  Data.s = "Khaki"                : Data.w =    $8C , $E6 , $F0
  Data.s = "Lavender"             : Data.w =    $FA , $E6 , $E6
  Data.s = "Lavenderblush"        : Data.w =    $F5 , $F0 , $FF
  Data.s = "Lawngreen"            : Data.w =    $00 , $FC , $7C
  Data.s = "Lemonchiffon"         : Data.w =    $CD , $FA , $FF
  Data.s = "Lightblue"            : Data.w =    $E6 , $D8 , $AD
  Data.s = "Lightcoral"           : Data.w =    $80 , $80 , $F0
  Data.s = "Lightcyan"            : Data.w =    $FF , $FF , $E0
  Data.s = "Lightgoldenrodyellow" : Data.w =    $D2 , $FA , $FA
  Data.s = "Lightgreen"           : Data.w =    $90 , $EE , $90
  Data.s = "Lightgrey"            : Data.w =    $D3 , $D3 , $D3
  Data.s = "Lightpink"            : Data.w =    $C1 , $B6 , $FF
  Data.s = "Lightsalmon"          : Data.w =    $7A , $A0 , $FF
  Data.s = "Lightseagreen"        : Data.w =    $AA , $B2 , $20
  Data.s = "Lightskyblue"         : Data.w =    $FA , $CE , $87
  Data.s = "Lightslategray"       : Data.w =    $99 , $88 , $77
  Data.s = "Lightsteelblue"       : Data.w =    $DE , $C4 , $B0
  Data.s = "Lightyellow"          : Data.w =    $E0 , $FF , $FF
  Data.s = "Limegreen"            : Data.w =    $32 , $CD , $32
  Data.s = "Linen"                : Data.w =    $E6 , $F0 , $FA
  Data.s = "Mediumaquamarine"     : Data.w =    $AA , $CD , $66
  Data.s = "Mediumblue"           : Data.w =    $CD , $00 , $00
  Data.s = "Mediumorchid"         : Data.w =    $D3 , $55 , $BA
  Data.s = "Mediumseagreen"       : Data.w =    $71 , $B3 , $3C
  Data.s = "Mediumslateblue"      : Data.w =    $EE , $68 , $7B
  Data.s = "Mediumspringgreen"    : Data.w =    $9A , $FA , $00
  Data.s = "Mediumturquoise"      : Data.w =    $CC , $D1 , $48
  Data.s = "Mediumvioletred"      : Data.w =    $85 , $15 , $C7
  Data.s = "Midnightblue"         : Data.w =    $70 , $19 , $19
  Data.s = "Mintcream"            : Data.w =    $FA , $FF , $F5
  Data.s = "Mistyrose"            : Data.w =    $E1 , $E4 , $FF
  Data.s = "Moccasin"             : Data.w =    $B5 , $E4 , $FF
  Data.s = "Navajowhite"          : Data.w =    $AD , $DE , $FF
  Data.s = "Oldlace"              : Data.w =    $E6 , $F5 , $FD
  Data.s = "Olivedrab"            : Data.w =    $23 , $8E , $6B
  Data.s = "Orange"               : Data.w =    $00 , $A5 , $FF
  Data.s = "Orangered"            : Data.w =    $00 , $45 , $FF
  Data.s = "Orchid"               : Data.w =    $D6 , $70 , $DA
  Data.s = "Palegoldenrod"        : Data.w =    $AA , $E8 , $EE
  Data.s = "Palegreen"            : Data.w =    $98 , $FB , $98
  Data.s = "Paleturquoise"        : Data.w =    $EE , $EE , $AF
  Data.s = "Palevioletred"        : Data.w =    $93 , $70 , $DB
  Data.s = "Papayawhip"           : Data.w =    $D5 , $EF , $FF
  Data.s = "Peachpuff"            : Data.w =    $B9 , $DA , $FF
  Data.s = "Peru"                 : Data.w =    $3F , $85 , $CD
  Data.s = "Pink"                 : Data.w =    $CB , $C0 , $FF
  Data.s = "Plum"                 : Data.w =    $DD , $A0 , $DD
  Data.s = "Powderblue"           : Data.w =    $E6 , $E0 , $B0
  Data.s = "Rosybrown"            : Data.w =    $8F , $8F , $BC
  Data.s = "Royalblue"            : Data.w =    $E1 , $69 , $41
  Data.s = "Saddlebrown"          : Data.w =    $13 , $45 , $8B
  Data.s = "Salmon"               : Data.w =    $72 , $80 , $FA
  Data.s = "Sandybrown"           : Data.w =    $60 , $A4 , $F4
  Data.s = "Seagreen"             : Data.w =    $57 , $8B , $2E
  Data.s = "Seashell"             : Data.w =    $EE , $F5 , $FF
  Data.s = "Sienna"               : Data.w =    $2D , $52 , $A0
  Data.s = "Skyblue"              : Data.w =    $EB , $CE , $87
  Data.s = "Slateblue"            : Data.w =    $CD , $5A , $6A
  Data.s = "Slategray"            : Data.w =    $90 , $80 , $70
  Data.s = "Snow"                 : Data.w =    $FA , $FA , $FF
  Data.s = "Springgreen"          : Data.w =    $7F , $FF , $00
  Data.s = "Steelblue"            : Data.w =    $B4 , $82 , $46
  Data.s = "Tan"                  : Data.w =    $8C , $B4 , $D2
  Data.s = "Thistle"              : Data.w =    $D8 , $BF , $D8
  Data.s = "Tomato"               : Data.w =    $47 , $63 , $FF
  Data.s = "Turquoise"            : Data.w =    $D0 , $E0 , $40
  Data.s = "Violet"               : Data.w =    $EE , $82 , $EE
  Data.s = "Wheat"                : Data.w =    $B3 , $DE , $F5
  Data.s = "Whitesmoke"           : Data.w =    $F5 , $F5 , $F5
  Data.s = "Yellowgreen"          : Data.w =    $32 , $CD , $9A
EndDataSection
;} -------------------------------------------------------------

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP