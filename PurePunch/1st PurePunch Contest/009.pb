;*****************************************************************************
;* PurePunch Contest 
;* http://www.purebasic.fr/english/viewtopic.php?p=256341#256341
;*
;* Author : Baldrick
;* Date : Sat Sep 06, 2008
;* Link : http://www.purebasic.fr/english/viewtopic.php?p=258096#258096
;*
;*****************************************************************************
   Enumeration
      #Font1
      #Sp1
      #Sp1_3d
   EndEnumeration
      #Width=800
      #Height=600
      #Depth=32
      Upper=50
      Lower=#Height-50
      Left=50
      Right=#Width-50
      CentreX=#Width/2
      CentreY=#Height/2
      PB$="PureBasic"
      FTPP$="Feel the Pure Power"
Macro Die(Title,Message) 
   MessageRequester(Title,Message)
   End
EndMacro
Macro Frame()
   StartDrawing(ScreenOutput())   
   DrawingFont(FontID(#Font1))
   DrawText(CentreX-(TextWidth(PB$)/2),Upper+18,PB$,RGB(Trans/2,(255-Trans)/2,255-Trans),#Black)
    For a=0 To 10
     LineXY(Left,Upper+a,Right,Upper+a,RGB(Trans/2,200/(a+1),255-(a*24)))
     LineXY(Left,Lower-a,Right,Lower-a,RGB(Trans/2,200/(a+1),255-(a*24)))
     LineXY(Upper+a,Left,Upper+a,Lower,RGB(Trans/4,200/(a+1),255-(a*24)))
     LineXY(Right-a,Left,Right-a,Lower,RGB(Trans/4,200/(a+1),255-(a*24)))
    Next
   DrawingFont(#PB_Default)
   DrawText(CentreX-(TextWidth(FTPP$)/2),Lower-75,FTPP$,RGB(Trans/2,(255-Trans)/2,255-Trans),#Black)
   StopDrawing()
EndMacro
Macro Z()
   Start3D()
   ZoomSprite3D(#Sp1_3d,Trans,(Trans/2)+50)
   DisplaySprite3D(#Sp1_3d,CentreX-(Trans/2),CentreY-(Trans/2)+(Trans/4) ,Trans)
   Stop3D()
EndMacro
   If Not InitKeyboard()     
    Die("keyboard", "Initialisation fail")
   EndIf
   If Not InitSprite()
    Die("Sprite", "Initialisation fail")
   EndIf
   If Not InitSprite3D()
    Die("Sprite3D", "Initialisation fail")
   EndIf
   If Not LoadFont(#Font1,"Arial",72)
    Die("Font", "Loading fail")
   EndIf
   If Not OpenScreen(#Width,#Height,#Depth,"Screen")
    Die("Screen","Initialisation fail")
   EndIf   
   If Not CreateSprite(#Sp1,60,90,#PB_Sprite_Texture)
    Die("Sprite1","Creation fail") 
     Else
    StartDrawing(SpriteOutput(#Sp1))
    DrawingFont(FontID(#Font1))
    DrawText(0,0,"Z",#Red,#Black)
     For a=0 To 7
      Line(12,48+a,30,0,#Red)
     Next
    Box(6,16,5,10,#Black)
    Box(51,77,6,10,#Black)
    StopDrawing()
     If Not CreateSprite3D(#Sp1_3d,#Sp1)
      Die("Sprite1_3D","Creation fail")
     EndIf 
   EndIf
   Repeat
    Trans+Trans1
     If Trans>252
      Trans1=-1 
     ElseIf Trans<1
      Trans1=3
     EndIf 
    ExamineKeyboard()
    ClearScreen(#Black)
    Frame() 
    Z() 
    FlipBuffers()
   Until KeyboardPushed(#PB_Key_Escape)    
