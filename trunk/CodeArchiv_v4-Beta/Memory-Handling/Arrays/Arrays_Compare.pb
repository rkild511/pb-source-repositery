; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=970&highlight=
; Author: mutzel.man
; Date: 11. May 2003
; OS: Windows
; Demo: Yes


; Möchte überprüfen ob der Inhalt von Array1 in Array 2 zu finden ist. 
; => Wenn ja nix tun
; => Wenn Nein, denn Wert in neues Array(Array3) schreiben. 

anzahl.l = 4 
dummyanzahl.l = 0 
gefunden.l = 0 

Dim dummy1.s(anzahl) 
Dim dummy2.s(anzahl) 
Dim dummy3.s(anzahl) 

dummy1(0) = "Test0" 
dummy1(1) = "Test1" 
dummy1(2) = "Test2" 
dummy1(3) = "Test3" 
dummy1(4) = "Test4" 

dummy2(0) = "Test0" 
dummy2(1) = "1Test" 
dummy2(2) = "Test2" 
dummy2(3) = "" 
dummy2(4) = "Test2" 

For aussen = 0 To anzahl 

  For innen = 0 To anzahl 
    If dummy1(aussen) = dummy2(innen) 
      gefunden = 1 
    EndIf 
  Next innen 
  
  If gefunden = 0 
    dummy3(dummyanzahl) = dummy1(aussen) 
    dummyanzahl = dummyanzahl + 1 
  Else 
    gefunden = 0 
  EndIf 
  
Next aussen 

For test = 0 To dummyanzahl 
  Debug dummy3(test) 
Next test
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
