; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2205&postdays=0&postorder=asc&start=40
; Author: Dennis (improved by Thorsten, Deeem2031, etc., updated for PB4.00 by blbltheworm)
; Date: 11. September 2003
; OS: Windows
; Demo: No


;/ Mission-IsoScroll 

Declare CreateSprites() 
Declare DrawGrid() 
Declare DrawRect();X1, Y1, X2, Y2, Color.l) 

Structure DrawRect 
  X1.l 
  Y1.l 
  X2.l 
  Y2.l 
  Color.l 
EndStructure 

Global SinCounter.l,TimeStamp.l 

#ColorSet = 2 
#TexMode = 1 ;( 0:Colored 1:ThinBordered 2:FatBordered: 3: BorderEffect  ) 

#GridStartX = 50 
#GridStartY = 250 
#GridWidth = 70 
#GridHeight = 10 
#XWobble = 10 
#YWobble = 10 

Structure Point2d 
  x.w 
  y.w 
EndStructure 

If InitMouse() = 0 Or InitKeyboard() = 0 Or InitSprite() = 0 Or InitSprite3D() = 0 
  End 
EndIf 

Global Dim HeightData(#GridWidth, #GridHeight) 
Global Dim FastSinus.f(3599) 
Procedure InitFastSinus() 
  Protected a.l 
  For a = 0 To 3599 
    FastSinus(a) = Sin(a * #PI / 1800) 
  Next 
EndProcedure 
InitFastSinus() 

  Text.s = "MORPHOSS" 
  Length = Len(Text) - 1 
  
  For Pos = 0 To Length 
    *T.Byte = @Text + Pos 
    
    For M = 0 To 7 
      For n = 0 To 7 
        *Block.Byte = ?FontData + ((*T\B - 65) * 64) + n + M * 8 
        HeightData(n + Pos * 8, M + 1) = *Block\B 
      Next 
    Next 
  Next 
  
  If OpenScreen(800, 600, 32, "")  
    
    CreateSprites() 
    
    Repeat 
      
      ClearScreen(RGB(0,0,0)) 
      
      FPSCounter + 1 
      
      GetTickCount_() 
      !CMP Eax,dword[v_TimeStamp] 
      !JL l_asm_endif 
        !ADD Eax,1000 
        !MOV dword[v_TimeStamp],Eax 
        LastFPSCounter.s = Str(FPSCounter) + " FPS" 
        FPSCounter = 0 
      asm_endif: 
      
      StartDrawing(ScreenOutput()) 
      FrontColor(RGB(255,255,255)) 
      BackColor(RGB(0,0,0)) 
      DrawText(5, 5,LastFPSCounter) 
      StopDrawing()  
      
      DrawGrid()  
      
      FlipBuffers() 
      ExamineKeyboard() 
      
    Until KeyboardPushed(#PB_Key_All) 
  EndIf 
  
  
  Procedure DrawGrid() 
    
    Protected y.l, Sinus.f, winkel.l, M.l, n.l 
    Protected *Word.Word, Last.l, XCubes.l, YCubes.l 
    y = #GridStartY  
    Last = 999 
    
    
    Start3D() 
    For XCubes = 0 To #GridWidth 
      For YCubes = 0 To #GridHeight 
        
        For M = 0 To 2 
          For n = 0 To 3 
            
            If HeightData(XCubes, YCubes) = 1 
              *Word = ?IsoCubeHigh + (n + M * 4) * 4  
            Else 
              *Word = ?IsoCube + (n + M * 4) * 4  
            EndIf 
            
            Erg1 = *Word\w 
            
            *Word + 2 
            Erg2 = *Word\w 
            
            If Last <> Erg1 
              winkel = (Erg1 + #GridStartX + (10 * XCubes) + SinCounter + (YCubes * #YWobble))*10 
              winkel = winkel - winkel / 3600 * 3600 
              Sinus = FastSinus(winkel) * #XWobble 
              Last = Erg1 
            EndIf 
            
            If n = 0 
              X1 = Erg1 + #GridStartX + (10 * XCubes) - (YCubes * 5) 
              Y1 = Erg2 + y + Sinus + (YCubes * 5) 
            ElseIf n = 1 
              X2 = Erg1 + #GridStartX + (10 * XCubes) - (YCubes * 5) 
              Y2 = Erg2 + y + Sinus + (YCubes * 5) 
            ElseIf n = 2 
              X3 = Erg1 + #GridStartX + (10 * XCubes) - (YCubes * 5) 
              Y3 = Erg2 + y + Sinus + (YCubes * 5) 
            ElseIf n = 3 
              X4 = Erg1 + #GridStartX + (10 * XCubes) - (YCubes * 5) 
              Y4 = Erg2 + y + Sinus + (YCubes * 5) 
            EndIf  
            
          Next 
          
          
          TransformSprite3D(M,X1,Y1,X2,Y2,X3,Y3,X4,Y4) 
          DisplaySprite3D(M,0,0)  
          
          
        Next 
      Next 
    Next 
    
    Stop3D() 
    
    SinCounter + 10 
    
  EndProcedure 
  
  Procedure CreateSprites() 
    Global rect.DrawRect 
    
    For n = 0 To 2 
      CreateSprite(n,32,32,#PB_Sprite_Texture) 
      
      CompilerSelect #ColorSet 
        CompilerCase 0 
          G=0 : B=0 
        CompilerCase 1 
          G=0 : B=200 
        CompilerCase 2 
          G=100 : B=0 
        CompilerCase 3 
          G=100 : B=150 
      CompilerEndSelect 
      
      StartDrawing(SpriteOutput(n)) 
      
      Box(0, 0, 32, 32, (255 - n<<6)+G<<8+B<<16) 
      ;DrawingMode(4) 
      CompilerSelect #TexMode 
        CompilerCase 3 
          For M = 0 To 8 
            rect\X1 = M 
            rect\Y1 = M 
            rect\X2 = 32-M 
            rect\Y2 = 32-M 
            rect\Color = (150+M*10-n<<6+G)<<8+B<<16 
            DrawRect() 
          Next 
        CompilerCase 2 
          For M = 0 To 2 
            rect\X1 = M 
            rect\Y1 = M 
            rect\X2 = 32-M 
            rect\Y2 = 32-M 
            rect\Color = (150+M*10-n<<5)+G<<8+B<<16 
            DrawRect();M,M, 32 - M, 32 - M, (150+M*10-n<<5)+G<<8+B<<16) 
          Next 
        CompilerCase 1 
          rect\X1 = 0 
          rect\Y1 = 0 
          rect\X2 = 32 
          rect\Y2 = 32 
          rect\Color = (150+M*10-n<<5)+G<<8+B<<16 
          DrawRect();0,0,32,32,(150+M*10-n<<5)+G<<8+B<<16) 
      CompilerEndSelect 
      StopDrawing() 
    Next 
    
    For n = 0 To 2 
      CreateSprite3D(n, n) 
    Next 
    
  EndProcedure 
  
  Procedure DrawRect();X1, Y1, X2, Y2, Color.l) 
    LineXY(rect\X1, rect\Y1, rect\X2, rect\Y1, rect\Color) 
    LineXY(rect\X2, rect\Y1, rect\X2, rect\Y2, rect\Color) 
    LineXY(rect\X2, rect\Y2, rect\X1, rect\Y2, rect\Color) 
    LineXY(rect\X1, rect\Y2, rect\X1, rect\Y1, rect\Color) 
  EndProcedure

  DataSection 
  IsoCube: 
  Data.w  0, 0 
  Data.w 10, 0 
  Data.w 10,10 
  Data.w  0,10 
  
  Data.w 0,0 
  Data.w 5,-5 
  Data.w 15,-5 
  Data.w 10,0 
  
  Data.w 10,0 
  Data.w 15,-5 
  Data.w 15,5 
  Data.w 10,10 
  
  IsoCubeHigh: 
  Data.w  0, -5 
  Data.w 10, -5 
  Data.w 10,10 
  Data.w  0,10 
  
  Data.w 0,-5 
  Data.w 5,-10 
  Data.w 15,-10 
  Data.w 10,-5 
  
  Data.w 10,-5 
  Data.w 15,-10 
  Data.w 15,5 
  Data.w 10,10 
  
  
  FontData: 
  
  Data.b 0,0,1,1,1,1,0,0 ;A 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,1,1,1,1,0 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,0,0,1,1,0 
  
  Data.b 0,1,1,1,1,1,0,0 ;B 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,1,1,1,0,0 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,1,1,1,0,0 
  
  Data.b 0,0,1,1,1,1,0,0 ;C 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,0,0,0,0,0 
  Data.b 0,1,1,0,0,0,0,0 
  Data.b 0,1,1,0,0,0,0,0 
  Data.b 0,1,1,0,0,0,0,0 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,0,1,1,1,1,0,0 
  
  Data.b 0,1,1,1,1,1,0,0 ;D 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,1,1,1,0,0 
  
  Data.b 0,1,1,1,1,1,1,0 ;E 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,0,0,0,0,0 
  Data.b 0,1,1,1,0,0,0,0 
  Data.b 0,1,1,1,0,0,0,0 
  Data.b 0,1,1,0,0,0,0,0 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,1,1,1,1,0 
  
  Data.b 0,1,1,1,1,1,1,0 ;F 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,0,0,0,0,0 
  Data.b 0,1,1,1,0,0,0,0 
  Data.b 0,1,1,1,0,0,0,0 
  Data.b 0,1,1,0,0,0,0,0 
  Data.b 0,1,1,0,0,0,0,0 
  Data.b 0,1,1,0,0,0,0,0 
  
  Data.b 0,0,1,1,1,1,0,0 ;G 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,0,0,0,0,0 
  Data.b 0,1,1,0,0,0,0,0 
  Data.b 0,1,1,0,1,1,1,0 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,0,1,1,1,1,0,0 
  
  Data.b 0,1,1,0,0,1,1,0 ;H 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,1,1,1,1,0 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,0,0,1,1,0 
  
  Data.b 0,0,0,1,1,0,0,0 ;I 
  Data.b 0,0,0,1,1,0,0,0 
  Data.b 0,0,0,1,1,0,0,0 
  Data.b 0,0,0,1,1,0,0,0 
  Data.b 0,0,0,1,1,0,0,0 
  Data.b 0,0,0,1,1,0,0,0 
  Data.b 0,0,0,1,1,0,0,0 
  Data.b 0,0,0,1,1,0,0,0 
  
  
  Data.b 0,0,0,0,0,1,1,0 ;J 
  Data.b 0,0,0,0,0,1,1,0 
  Data.b 0,0,0,0,0,1,1,0 
  Data.b 0,0,0,0,0,1,1,0 
  Data.b 0,0,0,0,0,1,1,0 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,0,1,1,1,1,0,0 
  
  
  Data.b 0,1,1,0,0,1,1,0 ;K 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,0,1,1,0,0 
  Data.b 0,1,1,1,1,1,0,0 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,0,0,1,1,0 
  
  Data.b 0,1,1,0,0,0,0,0 ;L 
  Data.b 0,1,1,0,0,0,0,0 
  Data.b 0,1,1,0,0,0,0,0 
  Data.b 0,1,1,0,0,0,0,0 
  Data.b 0,1,1,0,0,0,0,0 
  Data.b 0,1,1,0,0,0,0,0 
  Data.b 0,1,1,1,1,1,1,0 
  Data.b 0,1,1,1,1,1,1,0 
  
  
  Data.b 0,1,0,0,0,0,0,1 ;M 
  Data.b 0,1,1,0,0,0,1,1 
  Data.b 0,1,1,1,1,1,1,1 
  Data.b 0,1,1,0,1,0,1,1 
  Data.b 0,1,1,0,0,0,1,1 
  Data.b 0,1,1,0,0,0,1,1 
  Data.b 0,1,1,0,0,0,1,1 
  Data.b 0,1,1,0,0,0,1,1 
  
  Data.b 0,1,0,0,0,0,0,1 ;N 
  Data.b 0,1,1,0,0,0,1,1 
  Data.b 0,1,1,1,0,0,1,1 
  Data.b 0,1,1,1,1,0,1,1 
  Data.b 0,1,1,0,1,1,1,1 
  Data.b 0,1,1,0,0,1,1,1 
  Data.b 0,1,1,0,0,0,1,1 
  Data.b 0,1,1,0,0,0,1,1 
  
  Data.b 0,0,1,1,1,1,0,0 ;O 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,0,1,1,1,1,0,0 
  
  
  Data.b 0,1,1,1,1,1,0,0 ;P 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,1,1,1,0,0 
  Data.b 0,1,1,0,0,0,0,0 
  Data.b 0,1,1,0,0,0,0,0 
  Data.b 0,1,1,0,0,0,0,0 
  Data.b 0,1,1,0,0,0,0,0 
  
  
  Data.b 0,0,1,1,1,1,0,0 ;Q 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,0,1,1,1,0 
  Data.b 0,1,1,0,0,1,1,1 
  Data.b 0,0,1,1,1,1,0,0 
  
  
  Data.b 0,1,1,1,1,1,0,0 ;R 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,1,1,1,0,0 
  Data.b 0,1,1,0,0,1,0,0 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,0,0,1,1,0 
  
  Data.b 0,0,1,1,1,1,0,0 ;S 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,0,1,1,0,0,0,0 
  Data.b 0,0,0,0,1,1,0,0 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,0,1,1,1,1,0,0 
  
  Data.b 0,1,1,1,1,1,1,0 ;T 
  Data.b 0,1,1,1,1,1,1,0 
  Data.b 0,0,0,1,1,0,0,0 
  Data.b 0,0,0,1,1,0,0,0 
  Data.b 0,0,0,1,1,0,0,0 
  Data.b 0,0,0,1,1,0,0,0 
  Data.b 0,0,0,1,1,0,0,0 
  Data.b 0,0,0,1,1,0,0,0 
  
  Data.b 0,1,1,0,0,1,1,0 ;U 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,0,1,1,1,1,0,0 
  
  Data.b 0,1,1,0,0,1,1,0 ;V 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,0,1,1,1,1,0,0 
  Data.b 0,0,0,1,1,0,0,0 
  
  Data.b 0,1,1,0,0,0,1,1 ;W 
  Data.b 0,1,1,0,0,0,1,1 
  Data.b 0,1,1,0,0,0,1,1 
  Data.b 0,1,1,0,0,0,1,1 
  Data.b 0,1,1,0,1,0,1,1 
  Data.b 0,1,1,1,1,1,1,1 
  Data.b 0,1,1,1,0,1,1,1 
  Data.b 0,0,1,0,0,0,1,0 
  
  
  Data.b 0,1,1,0,0,1,1,0 ;X 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,0,1,1,1,1,0,0 
  Data.b 0,0,0,1,1,0,0,0  
  Data.b 0,0,1,1,1,1,0,0 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,0,0,1,1,0 
  
  Data.b 0,1,1,0,0,1,1,0 ;Y 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,0,1,1,1,1,0,0 
  Data.b 0,0,0,1,1,0,0,0  
  Data.b 0,0,0,1,1,0,0,0 
  Data.b 0,0,0,1,1,0,0,0 
  Data.b 0,0,0,1,1,0,0,0 
  Data.b 0,0,0,1,1,0,0,0 
  
  Data.b 0,1,1,1,1,1,1,1 ;Z 
  Data.b 0,1,1,1,1,1,1,0 
  Data.b 0,0,0,0,1,1,0,0 
  Data.b 0,0,0,1,1,0,0,0 
  Data.b 0,0,0,1,1,0,0,0 
  Data.b 0,0,1,1,0,0,0,0 
  Data.b 0,1,1,1,1,1,1,1 ;Z 
  Data.b 0,1,1,1,1,1,1,1 
  
  Data.b 0,0,1,1,1,1,0,0 ;0 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,0,1,1,1,1,0,0 
  
  
  Data.b 0,0,0,0,1,1,0,0 ;1 
  Data.b 0,0,0,1,1,1,0,0 
  Data.b 0,0,1,1,1,1,0,0 
  Data.b 0,0,0,0,1,1,0,0 
  Data.b 0,0,0,0,1,1,0,0 
  Data.b 0,0,0,0,1,1,0,0 
  Data.b 0,0,0,0,1,1,0,0 
  Data.b 0,0,0,0,1,1,0,0 
  
  Data.b 0,0,1,1,1,1,0,0 ;2 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,0,0,0,1,1,0,0 
  Data.b 0,0,0,1,1,0,0,0 
  Data.b 0,0,1,1,0,0,0,0 
  Data.b 0,1,1,1,1,1,1,0 
  Data.b 0,1,1,1,1,1,1,0 
  
  
  Data.b 0,0,1,1,1,1,0,0 ;3 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,0,0,0,1,1,0,0 
  Data.b 0,0,0,0,1,1,0,0 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,0,1,1,1,1,0,0 
  
  Data.b 0,1,1,0,0,0,0,0 ; 4 
  Data.b 0,1,1,0,0,0,0,0 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,1,1,1,1,0 
  Data.b 0,1,1,1,1,1,1,0 
  Data.b 0,0,0,0,0,1,1,0 
  Data.b 0,0,0,0,0,1,1,0 
  Data.b 0,0,0,0,0,1,1,0 
  
  Data.b 0,1,1,1,1,1,1,0 ; 5 
  Data.b 0,1,1,0,0,0,0,0 
  Data.b 0,1,1,0,0,0,0,0 
  Data.b 0,1,1,1,1,1,0,0 
  Data.b 0,1,1,1,1,1,1,0 
  Data.b 0,0,0,0,0,1,1,0 
  Data.b 0,0,0,0,0,1,1,0 
  Data.b 0,1,1,1,1,1,0,0 
  
  
  Data.b 0,0,0,1,1,1,1,0 ; 6 
  Data.b 0,1,1,0,0,0,0,0 
  Data.b 0,1,1,0,0,0,0,0 
  Data.b 0,1,1,1,1,1,0,0 
  Data.b 0,1,1,1,1,1,1,0 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,0,1,1,1,1,0,0 
  
  Data.b 0,1,1,1,1,1,1,0 ; 7 
  Data.b 0,1,1,1,1,1,1,0 
  Data.b 0,0,0,0,0,1,1,0 
  Data.b 0,0,0,0,1,1,0,0 
  Data.b 0,0,0,0,1,1,0,0 
  Data.b 0,0,0,1,1,0,0,0 
  Data.b 0,0,0,1,1,0,0,0 
  Data.b 0,0,0,1,1,0,0,0 
  
  
  Data.b 0,0,1,1,1,1,0,0 ;8 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,0,1,1,1,1,0,0 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,0,1,1,1,1,0,0 
  
  
  Data.b 0,0,1,1,1,1,0,0 ;9 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,0,0,1,1,0 
  Data.b 0,1,1,1,1,1,1,0 
  Data.b 0,0,1,1,1,1,1,0 
  Data.b 0,0,0,0,0,1,1,0 
  Data.b 0,0,0,0,0,1,1,0 
  Data.b 0,0,1,1,1,1,0,0 
  
  EndDataSection  

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger
