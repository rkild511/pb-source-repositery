;*****************************************************************************
;*
;* Summer 2010 PurePunch Demo contest
;* 200 lines of 80 chars, two months delay
;*
;* Name     : Slider, demo of PB possibilities :)
;* Author   : infratec
;* Date     : 09.07.2010
;* Purebasic Version : 4.50 32bit Windows
;* Notes    : -
;*
;*****************************************************************************
#FreeColour = $0 : #WindowColour = $303030
UseJPEGImageDecoder()
Global FPos = 50, Counter = 0, Pcs = 4, Sound = 0
Procedure LoadIt()
 IniFile$ = Left(ProgramFilename(), Len(ProgramFilename()) - 3) + "ini"
 If Not OpenPreferences(IniFile$)
  CreatePreferences(IniFile$)
  ClosePreferences()
  OpenPreferences(IniFile$)
 EndIf
 PreferenceGroup(Str(Pcs) + " Pcs")
 ActualPcs = Pcs * Pcs + 1
 Counter = ReadPreferenceInteger("Counter", 0)
 Def$ = ""
 For i = 1 To ActualPcs : Def$ + RSet(Str(i), 2, "0") + " " : Next i
 Def$ = RTrim(Def$) : State$ = ReadPreferenceString("State", Def$)
 For i = 1 To ActualPcs
  No = Val(StringField(State$, i, " "))
  SetGadgetState(i, ImageID(No))
  If No = ActualPcs : FPos = i : EndIf
 Next i
 If Counter > 0 : SetGadgetText(91, Str(Counter)) : EndIf
 Sound = ReadPreferenceInteger("Sound", 0)
 If Sound = 0 : SetGadgetState(111, 0) : EndIf
EndProcedure
Procedure SaveIt()
 ActualPcs = Pcs * Pcs + 1 : State$ = ""
 For i = 1 To ActualPcs
  ImageID = GetGadgetState(i)
  For j = 1 To ActualPcs
   If ImageID = ImageID(j) : Break : EndIf
  Next j
  State$ + RSet(Str(j), 2, "0") + " "
 Next i
 WritePreferenceString("State", State$)
 WritePreferenceInteger("Counter", Counter);
 WritePreferenceInteger("Sound", Sound);
 ClosePreferences()
EndProcedure
Procedure MixIt()
 ActualPcs = Pcs * Pcs : Line$ = ""
 RandomSeed(Date())
 Repeat
  No$ = RSet(LTrim(Str(Random(ActualPcs - 2) + 1)), 2, "0") + " "
  If FindString(Line$, No$, 1) = 0 : Line$ + No$ : EndIf
 Until Len(Line$) = (ActualPcs - 1) * 3
 For i = 1 To ActualPcs - 1
  No = Val(StringField(Line$, i, " "))
  SetGadgetState(i, ImageID(No))
 Next i
 SetGadgetState(ActualPcs, ImageID(ActualPcs))
 SetGadgetState(ActualPcs + 1, ImageID(ActualPcs + 1))
 FPos = ActualPcs + 1 : Counter = 0
 SetGadgetText(91, Str(Counter))
EndProcedure
Procedure MoveIt(No)
 Result = #False
 If No <> FPos
  If No - 1 = FPos Or No + 1 = FPos Or No - Pcs = FPos Or No + Pcs = FPos
   Help = GetGadgetState(No)
   SetGadgetState(FPos, Help)
   SetGadgetState(No, ImageID(Pcs * Pcs + 1))
   FPos = No : Counter + 1
   SetGadgetText(91, LTrim(Str(Counter)))
   Result = #True
  EndIf
 EndIf
 ProcedureReturn Result
EndProcedure
Procedure CheckIt()
 Result = #True
 For i = 1 To Pcs * Pcs + 1
  If ImageID(i) <> GetGadgetState(i)
   Result = #False
   Break
  EndIf
 Next i
 ProcedureReturn Result
EndProcedure
Flags = #PB_Window_ScreenCentered|#PB_Window_BorderLess|#PB_Window_Invisible
If OpenWindow(0, 0, 0, 750, 530, "", Flags)
 Sound = #False
 If InitSound()
  Sound = #True
  CatchSound(0, ?Sound)
 EndIf
 SetWindowColor(0, #WindowColour)
 ExtPicture = #False
 If CountProgramParameters()
  For i = 0 To CountProgramParameters() - 1
   If FindString(LCase(ProgramParameter(i)), ".jpg", 1)
    If FileSize(ProgramParameter(i)) > 0
     If LoadImage(0, ProgramParameter(i))
      ExtPicture = #True
     EndIf
    EndIf
   Else
    Pcs = Val(ProgramParameter(i))
    If Pcs < 4 : Pcs = 4 : EndIf
     If Pcs > 7 : Pcs = 7 : EndIf
   EndIf
  Next i
 EndIf
 If Not ExtPicture : CatchImage(0, ?Picture) : EndIf
 Sz = 490 / Pcs
 ResizeImage(0, Pcs * Sz, Pcs * Sz, #PB_Image_Smooth)
 x = 0 : y = 0
 For i = 1 To Pcs * Pcs
  GrabImage(0, i, x, y, Sz, Sz)
  ImageGadget(i, 20 + x, 20 + y, Sz, Sz, ImageID(i))
  x + Sz
  If x > (Pcs - 1) * Sz;420
   x = 0 : y + Sz
  EndIf
 Next i
 CreateImage(Pcs * Pcs + 1, Sz, Sz)
 StartDrawing(ImageOutput(Pcs * Pcs + 1))
 Box(0, 0, Sz, Sz, #FreeColour)
 StopDrawing()
 ImageGadget(Pcs*Pcs+1,Pcs*Sz+20,(Pcs-1)*Sz+20,Sz,Sz,ImageID(Pcs*Pcs+1))
 CopyImage(0, Pcs * Pcs + 2)
 ResizeImage(Pcs * Pcs + 2, 196, 196, #PB_Image_Smooth)
 ImageGadget(Pcs * Pcs + 2, 530, 20, 196, 196, ImageID(Pcs * Pcs + 2)) 
 If Sound
  CreateImage(111, 196, 30)
  StartDrawing(ImageOutput(111))
  Box(0, 0, 196, 30, #WindowColour)
  DrawText(65, 6 , "Sound off", $FFFFFF, #WindowColour)
  StopDrawing()
  CreateImage(112, 196, 30)
  StartDrawing(ImageOutput(112))
  Box(0, 0, 196, 30, #WindowColour)
  DrawText(65, 6 , "Sound on", $FFFFFF, #WindowColour)
  StopDrawing()
  ButtonImageGadget(111, 530, 230, 196, 30, ImageID(112), #PB_Button_Toggle)
  SetGadgetState(111, 1)
  SetGadgetAttribute(111, #PB_Button_PressedImage, ImageID(111))
 EndIf
 ButtonX = 20 + (Pcs + 1) * Sz + 20
 Button2Y = 20 + Pcs * Sz - 30 - 1
 Button1Y = Button2Y - 30 - 8
 ButtonWidth = WindowWidth(0) - ButtonX - 20
 CreateImage(100, 130, 30)
 StartDrawing(ImageOutput(100))
 Box(0, 0, 130, 30, #WindowColour)
 DrawText(40, 6 , "Mix it !", $FFFFFF, #WindowColour)
 StopDrawing()
 ButtonImageGadget(100, ButtonX, Button1Y, ButtonWidth, 30, ImageID(100))
 CreateImage(110, 130, 30)
 StartDrawing(ImageOutput(110))
 Box(0, 0, 130, 30, #WindowColour)
 DrawText(50, 6 , "Exit", $FFFFFF, #WindowColour)
 StopDrawing()
 ButtonImageGadget(110, ButtonX, Button2Y, ButtonWidth, 30, ImageID(110))
 If LoadFont(0, "Arial", 16, #PB_Font_Bold)
  SetGadgetFont(#PB_Default, FontID(0))
 EndIf
 TextGadget(91, 530, 310, 196, 30, "", #PB_Text_Center)
 SetGadgetColor(91, #PB_Gadget_BackColor, #WindowColour)
 SetGadgetColor(91, #PB_Gadget_FrontColor, $FFFFFF)
 TextGadget(92, 530, 350, 196, 30, "", #PB_Text_Center)
 SetGadgetColor(92, #PB_Gadget_BackColor, #WindowColour)
 SetGadgetColor(92, #PB_Gadget_FrontColor, $FFFFFF)
 LoadIt()
 HideWindow(0, 0)
 Exit = #False
 If Counter = 0 : Move = #False : Else : Move = #True : EndIf
 Repeat
  Event = WaitWindowEvent()
  If Event = #PB_Event_Gadget
   EventGadget = EventGadget()
   Select EventGadget
    Case 1 To Pcs * Pcs + 1
     If Move
      If MoveIt(EventGadget)
       If Sound : PlaySound(0) : EndIf
        If CheckIt()
         SetGadgetText(92, "Super !")
         Counter = 0 : Move = #False
        EndIf
       EndIf
      EndIf
    Case 100 : MixIt() : Move = #True
    Case 110 : Exit = #True
    Case 111
     If GetGadgetState(111) : Sound = #True : Else : Sound = #False : EndIf
   EndSelect
  EndIf
 Until Exit
 SaveIt()
EndIf
End
DataSection
 Picture: IncludeBinary "purebasic.jpg"
 Sound: IncludeBinary "Sound.wav"
EndDataSection

; IDE Options = PureBasic 4.50 (Windows - x86)
; CursorPosition = 133
; FirstLine = 131
; Folding = -
; EnableXP
; UseIcon = PBSlider.ico
; Executable = PBSlider.exe
; CommandLine =
; CompileSourceDirectory