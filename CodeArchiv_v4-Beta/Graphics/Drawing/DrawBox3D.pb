; German forum: http://www.purebasic.fr/german/viewtopic.php?t=1245&highlight=
; Author: Leo (updated for PB 4.00 by Andre)
; Date: 17. December 2004
; OS: Windows
; Demo: Yes


;/ 
;/M32 - Main 
;/ 

;################################################################### 
;Hier einstellen, ob sich die Linien überkreuzen sollen oder nicht## 
#UEBERKREUZEN = #True ;############################################# 
;################################################################### 

#ScrWidth = 1024 
#ScrHeight= 768 

InitSprite():InitKeyboard() 
OpenScreen(#ScrWidth,#ScrHeight,32,"M32") 

Procedure M32_DrawBox3D(X,Y,BreiteHinten,HoeheHinten,BreiteVorne,HoeheVorne,Laenge) 
  DrawingMode(4) 
  Box(X,Y,BreiteVorne,HoeheVorne) 
  Box(X-Laenge,Y-Laenge,BreiteHinten,HoeheHinten) 
  LineXY(X,Y,X-Laenge,Y-Laenge) 
  LineXY(X+BreiteVorne,Y,X-Laenge+BreiteHinten,Y-Laenge) 
  LineXY(X,Y+HoeheVorne,X-Laenge,Y-Laenge+HoeheHinten) 
  LineXY(X+BreiteVorne,Y+HoeheVorne,X-Laenge+BreiteHinten,Y-Laenge+HoeheHinten) 
EndProcedure 

Enumeration 
  #BreiteH 
  #BreiteV 
  #HoeheH 
  #HoeheV 
  #Laenge 
EndEnumeration 
Enumeration 
  #Add 
  #Min 
EndEnumeration 

Structure ShowType 
  Speed.l 
  Type.l 
  Limit.l 
  LimitMin.l 
EndStructure 
Structure BoxInfo 
  X.l 
  Y.l 
  BreiteH.l 
  HoeheH.l 
  BreiteV.l 
  HoeheV.l 
  Laenge.l 
  FluchtW.l 
  Mode.ShowType[5] 
EndStructure 
NewList Box3D.BoxInfo() 

AddElement(Box3D()) 
Box3D()\X = 550 
Box3D()\Y = 400 
Box3D()\BreiteH = 50 
Box3D()\HoeheH = 70 
Box3D()\BreiteV = 100 
Box3D()\HoeheV = 140 
Box3D()\Laenge = 300 
For I = 0 To 4 
  Box3D()\Mode[I]\Speed = Random(1)+1 
  Box3D()\Mode[I]\Limit = 150+Random(50) 
  If #UEBERKREUZEN = #True 
    Box3D()\Mode[I]\LimitMin = 150+Random(50) 
  Else 
    Box3D()\Mode[I]\LimitMin = 0 
  EndIf 
Next 

Repeat 
  ExamineKeyboard() 
  ClearScreen(RGB(0,0,0))
  If KeyboardPushed(1) : Quit = #True : EndIf 
  StartDrawing(ScreenOutput()) 
  ForEach Box3D() 
    FrontColor(RGB(0,0,255))
    M32_DrawBox3D(Box3D()\X,Box3D()\Y,Box3D()\BreiteH,Box3D()\HoeheH,Box3D()\BreiteV,Box3D()\HoeheV,Box3D()\Laenge) 
    For I = 0 To 4 
      Select Box3D()\Mode[I]\Type 
        Case #Add 
          Select I 
            Case #BreiteH : Box3D()\BreiteH + Box3D()\Mode[I]\Speed : If Box3D()\BreiteH => Box3D()\Mode[I]\Limit : Box3D()\Mode[I]\Type = #Min : EndIf 
            Case #BreiteV : Box3D()\BreiteV + Box3D()\Mode[I]\Speed : If Box3D()\BreiteV => Box3D()\Mode[I]\Limit : Box3D()\Mode[I]\Type = #Min : EndIf 
            Case #HoeheH  : Box3D()\HoeheH  + Box3D()\Mode[I]\Speed : If Box3D()\HoeheH => Box3D()\Mode[I]\Limit  : Box3D()\Mode[I]\Type = #Min : EndIf 
            Case #HoeheV  : Box3D()\HoeheV  + Box3D()\Mode[I]\Speed : If Box3D()\HoeheV => Box3D()\Mode[I]\Limit  : Box3D()\Mode[I]\Type = #Min : EndIf 
            Case #Laenge  : Box3D()\Laenge  + Box3D()\Mode[I]\Speed : If Box3D()\Laenge => Box3D()\Mode[I]\Limit : Box3D()\Mode[I]\Type = #Min : EndIf 
          EndSelect 
        Case #Min 
          Select I 
            Case #BreiteH : Box3D()\BreiteH - Box3D()\Mode[I]\Speed : If Box3D()\BreiteH <= -Box3D()\Mode[I]\LimitMin : Box3D()\Mode[I]\Type = #Add : EndIf 
            Case #BreiteV : Box3D()\BreiteV - Box3D()\Mode[I]\Speed : If Box3D()\BreiteV <= -Box3D()\Mode[I]\LimitMin : Box3D()\Mode[I]\Type = #Add : EndIf 
            Case #HoeheH  : Box3D()\HoeheH - Box3D()\Mode[I]\Speed  : If Box3D()\HoeheH <= -Box3D()\Mode[I]\LimitMin : Box3D()\Mode[I]\Type = #Add : EndIf 
            Case #HoeheV  : Box3D()\HoeheV - Box3D()\Mode[I]\Speed  : If Box3D()\HoeheV <= -Box3D()\Mode[I]\LimitMin : Box3D()\Mode[I]\Type = #Add : EndIf 
            Case #Laenge  : Box3D()\Laenge - Box3D()\Mode[I]\Speed  : If Box3D()\Laenge <= -Box3D()\Mode[I]\LimitMin : Box3D()\Mode[I]\Type = #Add : EndIf 
          EndSelect 
      EndSelect 
    Next 
  Next 
  StopDrawing() 
  FlipBuffers() 
Until Quit = #True 
End 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; DisableDebugger