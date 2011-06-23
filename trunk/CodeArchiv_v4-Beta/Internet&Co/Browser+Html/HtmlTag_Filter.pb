; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=23276#23276
; Author: benny
; Date: 30. November 2003
; OS: Windows
; Demo: Yes

Procedure HTMLTag_Filter(String2Filter.s) 

  laenge.l = Len (String2Filter.s) 
  capture.l= 1                ; wenn 1, mitschneiden! 
  filtered.s = "" 
  
  For dummy=1 To laenge 
    part.s = Mid(String2Filter.s, dummy, 1) 
    
    If part.s = "<" 
      capture.l = 0           ; nicht mitschneiden ! 
    EndIf 
    
    If capture.l = 1 
      filtered.s = filtered.s + part.s 
    EndIf 
    
    If capture.l = 0 And part.s = ">" 
      capture.l = 1           ; wieder mitschneiden 
    EndIf    
    
  Next dummy 
  
  filtered.s = ReplaceString( filtered.s, "Ü", "Ü" ) 
  
  Debug filtered.s 

EndProcedure 

html.s = "<HTML><HEAD><TITLE> PureBasic </TITLE></HEAD><BODY> Test mit Umlaut UE -> Ü !!! </BODY></HTML>" 

HTMLTag_Filter(html.s) 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
