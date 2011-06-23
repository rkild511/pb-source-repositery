; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=214&start=10
; Author: NicTheQuick
; Date: 11. May 2003
; OS: Windows
; Demo: Yes


; Chiffrieren von Text

Procedure Mod(a.l, b.l) 
  ProcedureReturn a - a / b * b 
EndProcedure 

Text.s = "Feel The Pure Power!" 

#MaxRND = 5 
#Preset = 127 

NewList Ch.l() 

For a.l = 1 To Len(Text) 
  ASCII.l = Asc(Mid(Text, a, 1)) 
  If a = 1 
    PrevASCII.l = #Preset 
  Else 
    PrevASCII.l = Asc(Mid(Text, a - 1, 1)) 
  EndIf 
  
  Chiffre1.l = Random(#MaxRND - 1) + 1 
  Chiffre2.l = (255 + PrevASCII - ASCII) * Chiffre1 
  Chiffre1 = (Random(100) * (#MaxRND + 1)) + Chiffre1 
  
  AddElement(Ch()) 
  Ch() = Chiffre2 + (Chiffre1 << 16) 
Next 

Erg.s = "" 
Bin.s = "" 
ResetList(Ch()) 
While NextElement(Ch()) 
  If ListIndex(Ch()) > 1 : Erg = Erg + " " : EndIf 
  Erg = Erg + Right("00000" + Str(Ch()), 6) 
  Bin = Bin + Bin(Ch()) + Chr(13) 
Wend 

MessageRequester("Chiffretext", Erg, 0) 

Text.s = "" 
StartASCII.l = #Preset 

ResetList(Ch()) 
While NextElement(Ch()) 
  Chiffre2.l = Ch() & $FFFF 
  Chiffre1.l = Ch() >> 16 
  
  Chiffre1 = Mod(Chiffre1, #MaxRND + 1) 
  
  Chiffre2 = (Chiffre2 / Chiffre1) - 255 
  StartASCII - Chiffre2 
  Text = Text + Chr(StartASCII) 
  
Wend 

MessageRequester("Text", Text, 0)
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
