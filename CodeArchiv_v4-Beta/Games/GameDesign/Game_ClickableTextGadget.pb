; English forum: http://www.purebasic.fr/english/viewtopic.php?t=23329
; Author: Guimauve
; Date: 22. August 2006
; OS: Windows
; Demo: No

;  A very simple ClickableTextGadget

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< 
; Project name : Game menu Prototype 
; File : Game menu Prototype.pb 
; File Version : 1.0.1 
; Programmation : OK 
; Programmed by : Guimauve 
; Date : 21-08-2006 
; Last Update : 21-08-2006 
; Coded for PureBasic V4.00 
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< 

ProcedureDLL.b MouseReleasedButton(ButtonNumber.b) 
  
  Static Appel.b, Appuyee.b, Relachee.b, Memoire.b 
  
  If Appel = #False 
    
    Relachee = #False 
    Memoire = #False 
    Appel = #True 
    
  EndIf 
  
  Appuyee = MouseButton(ButtonNumber) 
  
  If Appuyee = #True 
    
    Relachee = #False 
    Memoire = #True 
    
  EndIf 
  
  If Appuyee = #False And Relachee = #False And Memoire = #True 
    
    Relachee = #True 
    Appel = #False 
    
  EndIf 
  
  ProcedureReturn Relachee 
EndProcedure 

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< 
; <<<<< Constants Enumeration >>>>> 

Enumeration 
  
  #State_Normal 
  #State_FlyOver 
  #State_Clicked 
  
EndEnumeration 

Enumeration 
  
  #Menu_New_Game 
  #Menu_Return_Game 
  #Menu_Quit_Game 
  
  #Menu_Max_Size 
  
EndEnumeration 

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< 
; AUTOMATICALLY GENERATED CODE, DO NOT MODIFY 
; UNLESS YOU REALLY, REALLY, REALLY MEAN IT !! 
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< 

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< 
; <<<<< Structure declaration >>>>> 

Structure ClickableText 
  
  PosX.w 
  PosY.w 
  Width.w 
  Height.w 
  Text.s 
  Color.l 
  FlyColor.l 
  EffexColor.l 
  state.b 
  ClickDown.b 
  ClickUp.b 
  Option.b 
  FontID.l 
  
EndStructure 

; <<<<<<<<<<<<<<<<<<<<<<<<< 
; <<<<< Access macros >>>>> 

Macro ClickableTextPosX(GadgetA) 
  
  GadgetA\PosX 
  
EndMacro 

Macro ClickableTextPosY(GadgetA) 
  
  GadgetA\PosY 
  
EndMacro 

Macro ClickableTextWidth(GadgetA) 
  
  GadgetA\Width 
  
EndMacro 

Macro ClickableTextHeight(GadgetA) 
  
  GadgetA\Height 
  
EndMacro 

Macro ClickableTextText(GadgetA) 
  
  GadgetA\Text 
  
EndMacro 

Macro ClickableTextColor(GadgetA) 
  
  GadgetA\Color 
  
EndMacro 

Macro ClickableTextFlyColor(GadgetA) 
  
  GadgetA\FlyColor 
  
EndMacro 

Macro ClickableTextEffexColor(GadgetA) 
  
  GadgetA\EffexColor 
  
EndMacro 

Macro ClickableTextState(GadgetA) 
  
  GadgetA\state 
  
EndMacro 

Macro ClickableTextClickDown(GadgetA) 
  
  GadgetA\ClickDown 
  
EndMacro 

Macro ClickableTextClickUp(GadgetA) 
  
  GadgetA\ClickUp 
  
EndMacro 

Macro ClickableTextOption(GadgetA) 
  
  GadgetA\Option 
  
EndMacro 

Macro ClickableTextFontID(GadgetA) 
  
  GadgetA\FontID 
  
EndMacro 

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< 
; <<<<< Code generated in : 31 ms <<<<< 
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< 

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< 
; <<<<< ClickableTextGadget >>>>> 

Macro ClickableTextGadget(GadgetA, P_PosX, P_PosY, P_Text, P_Color, P_FlyColor, P_EffexColor, P_Option = 0, P_FontID = #PB_Default) 
  
  ClickableTextPosX(GadgetA) = P_PosX 
  ClickableTextPosY(GadgetA) = P_PosY 
  ClickableTextText(GadgetA) = P_Text 
  ClickableTextColor(GadgetA) = P_Color 
  ClickableTextFlyColor(GadgetA) = P_FlyColor 
  ClickableTextEffexColor(GadgetA) = P_EffexColor 
  ClickableTextOption(GadgetA) = P_Option 
  ClickableTextFontID(GadgetA) = P_FontID 
  
EndMacro 

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< 
; <<<<< MouseFlyOverClickableText <<<<< 

Procedure.b MouseFlyOverClickableText(*GadgetA.ClickableText) 
  
  If MouseX() > ClickableTextPosX(*GadgetA) 
    If MouseX() < (ClickableTextPosX(*GadgetA) + ClickableTextWidth(*GadgetA)) 
      If MouseY() > ClickableTextPosY(*GadgetA) 
        If MouseY() < (ClickableTextPosY(*GadgetA) + ClickableTextHeight(*GadgetA)) 
          FlyOver.b = #True 
        EndIf 
      EndIf  
    EndIf  
  EndIf 
  
  ProcedureReturn FlyOver 
EndProcedure 

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< 
; <<<<< DrawClickableTextGadget <<<<< 

Procedure DrawClickableTextGadget(*GadgetA.ClickableText) 
  
  StartDrawing(ScreenOutput());> 
    
    If ClickableTextFontID(*GadgetA) <> #PB_Default 
      DrawingFont(FontID(ClickableTextFontID(*GadgetA))) 
    EndIf 
    
    ClickableTextWidth(*GadgetA) = TextWidth(ClickableTextText(*GadgetA)) 
    ClickableTextHeight(*GadgetA) = TextHeight(ClickableTextText(*GadgetA)) 
    
    If ClickableTextOption(*GadgetA) = 1 
      
      ClickableTextPosX(*GadgetA) = (GetSystemMetrics_(#SM_CXSCREEN) - ClickableTextWidth(*GadgetA)) >> 1 
      
    EndIf 
    
    If ClickableTextState(*GadgetA) = #State_Normal 
      
      Txt_x = ClickableTextPosX(*GadgetA) 
      Txt_y = ClickableTextPosY(*GadgetA) 
      TxtColor = ClickableTextColor(*GadgetA) 
      
    ElseIf ClickableTextState(*GadgetA) = #State_FlyOver 
      
      Txt_x = ClickableTextPosX(*GadgetA) - 1 
      Txt_y = ClickableTextPosY(*GadgetA) - 1 
      TxtColor = ClickableTextFlyColor(*GadgetA) 
      
    ElseIf ClickableTextState(*GadgetA) = #State_Clicked 
      
      Txt_x = ClickableTextPosX(*GadgetA) + 1 
      Txt_y = ClickableTextPosY(*GadgetA) + 1 
      TxtColor = ClickableTextEffexColor(*GadgetA) 
      
    EndIf 
    
    DrawingMode(#PB_2DDrawing_Transparent) 
    
    DrawText(Txt_x, Txt_y, ClickableTextText(*GadgetA), TxtColor) 
    
  StopDrawing();< 
  
EndProcedure 

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< 
; AUTOMATICALLY GENERATED CODE, DO NOT MODIFY 
; UNLESS YOU REALLY, REALLY, REALLY MEAN IT !! 
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< 

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< 
; <<<<< Structure declaration >>>>> 

Structure Menu 
  
  EventID.l 
  GadgetList.ClickableText[#Menu_Max_Size] 
  
EndStructure 

; <<<<<<<<<<<<<<<<<<<< 
; <<<<< Mutators >>>>> 

Macro SetMenuEventID(ObjetA, P_EventID) 
  
  ObjetA\EventID = P_EventID 
  
EndMacro 

; <<<<<<<<<<<<<<<<<<<<<<< 
; <<<<< Observators >>>>> 

Macro GetMenuEventID(ObjetA) 
  
  ObjetA\EventID 
  
EndMacro 

Macro GetMenuGadgetList(ObjetA, Index) 
  
  ObjetA\GadgetList[Index] 
  
EndMacro 

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< 
; <<<<< Code generated in : 16 ms <<<<< 
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< 

; <<<<<<<<<<<<<<<<<<<< 
; <<<<< DrawMenu >>>>> 
  
Procedure DrawMenu(*ObjetA.Menu) 
  
  For Index = 0 To #Menu_Max_Size - 1 
    
    ClickableTextClickDown(GetMenuGadgetList(*ObjetA, Index)) = #False 
    
    If MouseFlyOverClickableText(GetMenuGadgetList(*ObjetA, Index)) And MouseButton(1) = 1 
      
      ClickableTextClickDown(GetMenuGadgetList(*ObjetA, Index)) = #True 
      ClickableTextState(GetMenuGadgetList(*ObjetA, Index)) = #State_Clicked 
      
    ElseIf MouseFlyOverClickableText(GetMenuGadgetList(*ObjetA, Index)) = #True 
      
      ClickableTextState(GetMenuGadgetList(*ObjetA, Index)) = #State_FlyOver 
      
    ElseIf MouseFlyOverClickableText(GetMenuGadgetList(*ObjetA, Index)) = #False 
      
      ClickableTextState(GetMenuGadgetList(*ObjetA, Index)) = #State_Normal 
      
    EndIf 
    
    DrawClickableTextGadget(GetMenuGadgetList(*ObjetA, Index)) 
    
  Next 
  
  If MouseReleasedButton(1) = 1 
    
    For Index = 0 To #Menu_Max_Size - 1 
      
      If MouseFlyOverClickableText(GetMenuGadgetList(*ObjetA, Index)) = #True 
        
        SetMenuEventID(*ObjetA, Index) 
        Break 
        
      Else 
        
        ClickableTextState(GetMenuGadgetList(*ObjetA, Index)) = #State_Normal 
        SetMenuEventID(*ObjetA, -1) 
        
      EndIf 
      
    Next 
    
  EndIf 
  
EndProcedure 

; <<<<<<<<<<<<<<<<<<<<<<<<<< 
; <<<<< DrawScreenMenu >>>>> 

Procedure NewGameScreen(Text.s) 
  
  LoadFont(5, "Comic Sans MS", 14, #PB_Font_Bold) 
  
  Repeat 
    
    ClearScreen(#Black) 
    
    StartDrawing(ScreenOutput());> 
      
      DrawingMode(#PB_2DDrawing_Transparent) 
      DrawingFont(FontID(5)) 
      DrawText(5,5, "Game mode : " + Text, RGB($99, $33, $FF)) 
      DrawText(5,30, "Press ESCAPE to Return to the Main Menu", RGB($99, $33, $FF)) 
      
    StopDrawing();< 
    
    ExamineKeyboard() 
    FlipBuffers() 
    
  Until KeyboardPushed(#PB_Key_Escape) 
  
EndProcedure 

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< 
; <<<<< Game menu Prototype <<<<< 

ScreenW = GetSystemMetrics_(#SM_CXSCREEN) 
ScreenH = GetSystemMetrics_(#SM_CYSCREEN) 
Title.s = "Game menu Prototype" 
#Cursor = 125 

If InitKeyboard() = 0 Or InitSprite() = 0 Or InitSprite3D() = 0 Or InitMouse() = 0 
  
  MessageRequester("ERROR","Can't initialize DirectX !",#MB_ICONERROR) 
  End 
  
EndIf 

If OpenScreen(ScreenW, ScreenH, 32, Title) = 0 
  
  If OpenScreen(ScreenW, ScreenH, 24, Title) = 0 
    
    If OpenScreen(ScreenW, ScreenH, 16, Title) = 0 
      
      MessageRequester("ERROR", "Can't open DirectX screen !", #MB_ICONERROR) 
      End 
      
    EndIf 
    
  EndIf 
  
EndIf 

If CreateSprite(#Cursor, 32,32, #PB_Sprite_Texture) 
  
  StartDrawing(SpriteOutput(#Cursor));> 
    
    For Coord = 0 To 14 
      Circle(Coord,3,3,#Red) 
      Circle(3,Coord,3,#Red) 
    Next 

    For Coord = 0 To 27 Step 1 
      Circle(Coord,Coord,3,#Red) 
    Next 

  StopDrawing();< 
  
  CreateSprite3D(#Cursor, #Cursor) 
  
EndIf 

SetMenuEventID(MainMenu.Menu, -1) 
  
LoadFont(0, "Comic Sans MS", 20, #PB_Font_Bold | #PB_Font_Underline) 
  
ClickableTextGadget(GetMenuGadgetList(MainMenu, #Menu_New_Game), 0, ScreenH >> 1, "New Game", #Green, #Yellow, #Red, 1, 0) 
ClickableTextGadget(GetMenuGadgetList(MainMenu, #Menu_Return_Game), 0, (ScreenH >> 1) + 40, "Return to Current", #Green, #Yellow, #Red, 1, 0) 
ClickableTextGadget(GetMenuGadgetList(MainMenu, #Menu_Quit_Game), 0, (ScreenH >> 1) + 80, "Quit", #Green, #Yellow, #Red, 1, 0) 
  
Repeat 
  
  ClearScreen(#Black) 
  
  DrawMenu(MainMenu) 
  
  Select GetMenuEventID(MainMenu) 
    
    Case #Menu_New_Game 
      NewGameScreen("New Game") 
      SetMenuEventID(MainMenu, -1) 
      
    Case #Menu_Return_Game 
      NewGameScreen("Return Current game") 
      SetMenuEventID(MainMenu, -1) 
      
    Case #Menu_Quit_Game 
      Quit = #True 
      
  EndSelect 
  
  Start3D();> 
    DisplaySprite3D(#Cursor, MouseX(), MouseY()) 
  Stop3D();< 
  
  ExamineMouse() 
  FlipBuffers() 
  
Until Quit = #True 
  
CloseScreen() 
End 

; <<<<<<<<<<<<<<<<<<<<<<< 
; <<<<< END OF FILE <<<<< 
; <<<<<<<<<<<<<<<<<<<<<<<
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = ----
; EnableXP