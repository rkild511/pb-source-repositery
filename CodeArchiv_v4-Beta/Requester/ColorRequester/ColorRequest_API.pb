; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1337&highlight=
; Author: GPI (updated for PB4.00 by blbltheworm)
; Date: 13. June 2003
; OS: Windows
; Demo: No


; ColorRequest mit Startwert und Costum-List 
; ColorRequest with a Start-Value and a Costum Color-List

#CC_ANYCOLOR = $100 
#CC_FULLOPEN = $2 
#CC_RGBINIT  = $1 

Structure CustomColorList 
  RGB.l[16] 
EndStructure 
Procedure ChooseColor(Owner.l,startRGB,*cl.CustomColorList) 
  chc.choosecolor
  chc\LStructSize=SizeOf(choosecolor) 
  chc\hwndOwner=Owner
  chc\rgbResult=startRGB 
  chc\lpCustColors=*cl 
  chc\flags=#CC_ANYCOLOR|#CC_FULLOPEN|#CC_RGBINIT 
  If ChooseColor_(@chc)  
    ProcedureReturn chc\rgbResult 
  Else 
    ProcedureReturn -1 
  EndIf 
EndProcedure 

startColor.CustomColorList 
startColor\RGB[0]=RGB(255,128,0) 
startColor\RGB[1]=RGB(80,70,60) 

choose=ChooseColor(0,0,@startColor) ;Als Owner die WindowID übergeben, wenn nicht vorhanden einfach 0
Debug Hex(choose)+" "+Str(Red(choose))+" "+Str(Green(choose))+" "+Str(Blue(choose)) 
ChooseColor(0,choose,@startColor) 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
