; German forum: http://www.purebasic.fr/german/viewtopic.php?t=9886&postdays=0&postorder=asc&start=10
; Author: Kaeru Gaman
; Date: 11. September 2006
; OS: Windows
; Demo: Yes


;***
;*** COLORS.PBI
;***
;*** imported from "colors.inc" by POV
;***
;*** www.povray.org
;***

Macro FRGB(Rot, Grn, Blu)
  #Red * Rot + #Green * Grn + #Blue * Blu
EndMacro

;// These grays are useful For fine-tuning lighting color values
;// And For other areas where subtle variations of grays are needed.
;// PERCENTAGE GRAYS:
#Gray05 = FRGB(0.05,0.05,0.05)
#Gray10 = FRGB(0.10,0.10,0.10)
#Gray15 = FRGB(0.15,0.15,0.15)
#Gray20 = FRGB(0.20,0.20,0.20)
#Gray25 = FRGB(0.25,0.25,0.25)
#Gray30 = FRGB(0.30,0.30,0.30)
#Gray35 = FRGB(0.35,0.35,0.35)
#Gray40 = FRGB(0.40,0.40,0.40)
#Gray45 = FRGB(0.45,0.45,0.45)
#Gray50 = FRGB(0.50,0.50,0.50)
#Gray55 = FRGB(0.55,0.55,0.55)
#Gray60 = FRGB(0.60,0.60,0.60)
#Gray65 = FRGB(0.65,0.65,0.65)
#Gray70 = FRGB(0.70,0.70,0.70)
#Gray75 = FRGB(0.75,0.75,0.75)
#Gray80 = FRGB(0.80,0.80,0.80)
#Gray85 = FRGB(0.85,0.85,0.85)
#Gray90 = FRGB(0.90,0.90,0.90)
#Gray95 = FRGB(0.95,0.95,0.95)

;// OTHER GRAYS
#DimGray    = FRGB(0.329412, 0.329412, 0.329412)
#MedGray    = FRGB(0.752941, 0.752941, 0.752941)
#LightGray  = FRGB(0.658824, 0.658824, 0.658824)
#VLightGray = FRGB(0.80    , 0.80    , 0.80    )

;// OTHER COLORS
#Aquamarine         = FRGB(0.439216, 0.858824, 0.576471)
#BlueViolet         = FRGB(0.62352 , 0.372549, 0.623529)
#Brown              = FRGB(0.647059, 0.164706, 0.164706)
#CadetBlue          = FRGB(0.372549, 0.623529, 0.623529)
#Coral              = FRGB(1.0     , 0.498039, 0.0     )
#CornflowerBlue     = FRGB(0.258824, 0.258824, 0.435294)
#DarkGreen          = FRGB(0.184314, 0.309804, 0.184314)
#DarkOliveGreen     = FRGB(0.309804, 0.309804, 0.184314)
#DarkOrchid         = FRGB(0.6     , 0.196078, 0.8     )
#DarkSlateBlue      = FRGB(0.119608, 0.137255, 0.556863)
#DarkSlateGray      = FRGB(0.184314, 0.309804, 0.309804)
#DarkSlateGrey      = FRGB(0.184314, 0.309804, 0.309804)
#DarkTurquoise      = FRGB(0.439216, 0.576471, 0.858824)
#Firebrick          = FRGB(0.556863, 0.137255, 0.137255)
#ForestGreen        = FRGB(0.137255, 0.556863, 0.137255)
#Gold               = FRGB(0.8     , 0.498039, 0.196078)
#Goldenrod          = FRGB(0.858824, 0.858824, 0.439216)
#GreenYellow        = FRGB(0.576471, 0.858824, 0.439216)
#IndianRed          = FRGB(0.309804, 0.184314, 0.184314)
#Khaki              = FRGB(0.623529, 0.623529, 0.372549)
#LightBlue          = FRGB(0.74902 , 0.847059, 0.847059)
#LightSteelBlue     = FRGB(0.560784, 0.560784, 0.737255)
#LimeGreen          = FRGB(0.196078, 0.8     , 0.196078)
#Maroon             = FRGB(0.556863, 0.137255, 0.419608)
#MediumAquamarine   = FRGB(0.196078, 0.8     , 0.6     )
#MediumBlue         = FRGB(0.196078, 0.196078, 0.8     )
#MediumForestGreen  = FRGB(0.419608, 0.556863, 0.137255)
#MediumGoldenrod    = FRGB(0.917647, 0.917647, 0.678431)
#MediumOrchid       = FRGB(0.576471, 0.439216, 0.858824)
#MediumSeaGreen     = FRGB(0.258824, 0.435294, 0.258824)
#MediumSlateBlue    = FRGB(0.498039, 0.0     , 1.0     )
#MediumSpringGreen  = FRGB(0.498039, 1.0     , 0.0     )
#MediumTurquoise    = FRGB(0.439216, 0.858824, 0.858824)
#MediumVioletRed    = FRGB(0.858824, 0.439216, 0.576471)
#MidnightBlue       = FRGB(0.184314, 0.184314, 0.309804)
#Navy               = FRGB(0.137255, 0.137255, 0.556863)
#NavyBlue           = FRGB(0.137255, 0.137255, 0.556863)
#Orange             = FRGB(1.0     , 0.5     , 0.0     )
#OrangeRed          = FRGB(1.0     , 0.25    , 0.0     )
#Orchid             = FRGB(0.858824, 0.439216, 0.858824)
#PaleGreen          = FRGB(0.560784, 0.737255, 0.560784)
#Pink               = FRGB(0.737255, 0.560784, 0.560784)
#Plum               = FRGB(0.917647, 0.678431, 0.917647)
#Salmon             = FRGB(0.435294, 0.258824, 0.258824)
#SeaGreen           = FRGB(0.137255, 0.556863, 0.419608)
#Sienna             = FRGB(0.556863, 0.419608, 0.137255)
#SkyBlue            = FRGB(0.196078, 0.6     , 0.8     )
#SlateBlue          = FRGB(0.0     , 0.498039, 1.0     )
#SpringGreen        = FRGB(0.0     , 1.0     , 0.498039)
#SteelBlue          = FRGB(0.137255, 0.419608, 0.556863)
#Tan                = FRGB(0.858824, 0.576471, 0.439216)
#Thistle            = FRGB(0.847059, 0.74902 , 0.847059)
#Turquoise          = FRGB(0.678431, 0.917647, 0.917647)
#Violet             = FRGB(0.309804, 0.184314, 0.309804)
#VioletRed          = FRGB(0.8     , 0.196078, 0.6     )
#Wheat              = FRGB(0.847059, 0.847059, 0.74902 )
#YellowGreen        = FRGB(0.6     , 0.8     , 0.196078)

#SummerSky          = FRGB(0.22, 0.69, 0.87)
#RichBlue           = FRGB(0.35, 0.35, 0.67)
#Brass              = FRGB(0.71, 0.65, 0.26)
#Copper             = FRGB(0.72, 0.45, 0.20)
#Bronze             = FRGB(0.55, 0.47, 0.14)
#Bronze2            = FRGB(0.65, 0.49, 0.24)
#Silver             = FRGB(0.90, 0.91, 0.98)
#BrightGold         = FRGB(0.85, 0.85, 0.10)
#OldGold            = FRGB(0.81, 0.71, 0.23)
#Feldspar           = FRGB(0.82, 0.57, 0.46)
#Quartz             = FRGB(0.85, 0.85, 0.95)
#NeonPink           = FRGB(1.00, 0.43, 0.78)
#DarkPurple         = FRGB(0.53, 0.12, 0.47)
#NeonBlue           = FRGB(0.30, 0.30, 1.00)
#CoolCopper         = FRGB(0.85, 0.53, 0.10)
#MandarinOrange     = FRGB(0.89, 0.47, 0.20)
#LightWood          = FRGB(0.91, 0.76, 0.65)
#MediumWood         = FRGB(0.65, 0.50, 0.39)
#DarkWood           = FRGB(0.52, 0.37, 0.26)
#SpicyPink          = FRGB(1.00, 0.11, 0.68)
#SemiSweetChoc      = FRGB(0.42, 0.26, 0.15)
#BakersChoc         = FRGB(0.36, 0.20, 0.09)
#Flesh              = FRGB(0.96, 0.80, 0.69)
#NewTan             = FRGB(0.92, 0.78, 0.62)
#NewMidnightBlue    = FRGB(0.00, 0.00, 0.61)
#VeryDarkBrown      = FRGB(0.35, 0.16, 0.14)
#DarkBrown          = FRGB(0.36, 0.25, 0.20)
#DarkTan            = FRGB(0.59, 0.41, 0.31)
#GreenCopper        = FRGB(0.32, 0.49, 0.46)
#DkGreenCopper      = FRGB(0.29, 0.46, 0.43)
#DustyRose          = FRGB(0.52, 0.39, 0.39)
#HuntersGreen       = FRGB(0.13, 0.37, 0.31)
#Scarlet            = FRGB(0.55, 0.09, 0.09)
#Med_Purple         = FRGB(0.73, 0.16, 0.96)
#Light_Purple       = FRGB(0.87, 0.58, 0.98)
#Very_Light_Purple  = FRGB(0.94, 0.81, 0.99)

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP