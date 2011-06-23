; German forum: http://www.purebasic.fr/german/viewtopic.php?t=7664
; Author: stbi (new code formatting by DarkDragon)
; Date: 02. April 2006
; OS: Windows
; Demo: Yes


; Just a little joke program... ;)
; Idea is from magazine 'MC' April 1984 !
; (Painting with stars depending on the given bit pattern)

OpenConsole() 
For x=1 To 11 
  For y=1 To 2 
    Read d 
    Print(RSet(ReplaceString(ReplaceString(Bin(d),"0"," "),"1","*"),16," ")+Space(3)) 
  Next 
  PrintN("") 
Next 
Input() 
CloseConsole() 

DataSection 
  Data.l $eeea,$eeea,$aaaa,$aaaa,$eeea,$eeea,$a8ca,$a8ca,$a8ab,$a8ab,0,0,$6200,$eee8,$6100,$84a8,$0D00,$e4c8,$6100,$24a8,$6200,$e4e8 
EndDataSection
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -