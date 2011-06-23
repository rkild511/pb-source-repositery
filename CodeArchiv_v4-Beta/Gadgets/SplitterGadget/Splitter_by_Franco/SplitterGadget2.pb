; English forum:
; Author: Franco (code fixed & updated for PB4.00 by blbltheworm)
; Date: 22. July 2003
; OS: Windows
; Demo: No


; (c) 2003 - Franco's template - absolutely freeware
; This is a Gadget Splitter for three Gadgets!
; The Gadgets are populated West, East and South.
; Should work fine on all Windows Operating Systems
;
; You create three gadgets which you want to incorporate in your 
; splitter function. Example:
; ListViewGadget(1,  10, 10, 88, 200)
; or
; ListViewGadget(2,  0, 0, 0, 0) ; I talk about the zeros later...
;
; After that, you have to create the SplitterGadget with:
; TripleSplitterGadget(HorizontalGadgetNumber.l, VerticalGadgetNumber.l,PositionX.l, PositionY.l, Width.l, Height.l, WestGadget.l, EastGadget.l, SouthGadget.l)
;
; The PositionX, PositionY, Width and Height are the maximum area 
; of all incorporated Gadgets. That's why it's possible to do:
; ListViewGadget(2,  0, 0, 0, 0). 
; This values are changed when you call the SplitterGadget.
; For this you have to tell the SplitterGadget which Gadgets to work with.
; This can be done with the parameters WestGadget, EastGadget and SouthGadget.
; That's it!
;
; As you can see, you have to click the toggle button on the SplitterGadget
; and than you can move it. A second click will freeze it at the actual position.
; I know, the use is different than normal hotspots, but I think this approach
; is more elegant - and personally I don't care if I have to click twice.
;
; The Procedures SetTripleSplitterGadgetH(), SetTripleSplitterGadgetV() and 
; WatchTripleSplitterGadget() must be incorporated in the event handler as seen in this example. 
;
; The SplitterGadget has no return value yet 
 ;(because didn't know what - there are 2 new Buttons in there).
;
; BTW:
; The cursor changes with the action... nice isn't it?
; And only if it is over the SplitterGadget, nowhere else !
;
; Also this is the newest version with compensation of the Windows Border/Theme.
; Thanks to Berikco for the hint :)
;
; And here it goes:

#winMain=1

Procedure TripleSplitterGadget(GadgetNumberH.l, GadgetNumberV.l,PositionX.l, PositionY.l, Width.l, Height.l, WestGadget.l, EastGadget.l, SouthGadget.l)
  Shared Splitter_ToggleH.l,  Splitter_ToggleV.l,Splitter_HandCursor.l, Splitter_ArrowCursorH.l, Splitter_ArrowCursorV.l
  Shared Splitter_GadgetX1.l, Splitter_GadgetX2.l, Splitter_GadgetY1.l, Splitter_GadgetY2.l

  RoomBetweenGadgets.l = 4

  SplitterGadgetWidthH.l = 4
  SplitterGadgetHeightH.l = Height/2 - (RoomBetweenGadgets * 2) - 6
  SplitterGadgetHX.l = PositionX + Width/2 - SplitterGadgetWidthH/2
  SplitterGadgetHY.l = PositionY + 4

  SplitterGadgetHeightV.l = 4
  SplitterGadgetWidthV.l = Width - 8
  SplitterGadgetVX.l = PositionX + 4
  SplitterGadgetVY.l = PositionY + Height/2-2

  
  ; WestGadget
  WestGadgetWidth.l = SplitterGadgetHX - 4 - PositionX
  WestGadgetHeight.l = Height / 2 - 6
  ResizeGadget(WestGadget, PositionX, PositionY, WestGadgetWidth, WestGadgetHeight) 
  
  ; EastGadget
  EastGadgetX.l = SplitterGadgetHX + SplitterGadgetWidthH + RoomBetweenGadgets
  EastGadgetWidth.l = PositionX + Width - EastGadgetX
  EastGadgetHeight.l = Height / 2 - 6
  ResizeGadget(EastGadget, EastGadgetX, PositionY, EastGadgetWidth, EastGadgetHeight) 
  
  ; SouthGadget
  SouthGadgetY.l = SplitterGadgetVY + SplitterGadgetHeightV + RoomBetweenGadgets
  SouthGadgetHeight.l = PositionY + Height - SouthGadgetY
  ResizeGadget(SouthGadget, PositionX, SouthGadgetY, Width, SouthGadgetHeight) 
  
  ;HorizontalSplitter
  SplitterIDH = ButtonGadget(GadgetNumberH, SplitterGadgetHX, SplitterGadgetHY, SplitterGadgetWidthH, SplitterGadgetHeightH, "",#PB_Button_Toggle)
  
  ;VerticalSplitter
  SplitterIDV = ButtonGadget(GadgetNumberV, SplitterGadgetVX , SplitterGadgetVY, SplitterGadgetWidthV, SplitterGadgetHeightV, "",#PB_Button_Toggle)

  SetClassLong_(SplitterIDH,#GCL_HCURSOR,0)
  SetClassLong_(SplitterIDV,#GCL_HCURSOR,0)

  Splitter_ArrowCursorH = LoadCursor_(0, #IDC_SIZEWE)
  Splitter_ArrowCursorV = LoadCursor_(0, #IDC_SIZENS)
  Splitter_HandCursor = LoadCursor_(0, 32649); #IDC_HAND not recognized by PureBasic

  Splitter_Toggle = 0

  Splitter_GadgetX1.l = PositionX
  Splitter_GadgetX2.l = PositionX + Width
  Splitter_GadgetY1.l = PositionY
  Splitter_GadgetY2.l = PositionY + Height

  ;ProcedureReturn SplitterID

EndProcedure

Procedure SetTripleSplitterGadgetH()
  Shared Splitter_ToggleH

  If Splitter_ToggleH = 0
    Splitter_ToggleH = 1
  ElseIf Splitter_ToggleH = 1
    Splitter_ToggleH = 0
  EndIf 

EndProcedure

Procedure SetTripleSplitterGadgetV()
  Shared Splitter_ToggleV

  If Splitter_ToggleV = 0
    Splitter_ToggleV = 1
  ElseIf Splitter_ToggleV = 1
    Splitter_ToggleV = 0
  EndIf 

EndProcedure

Procedure InnerWindowMouseX()
  ProcedureReturn WindowMouseX(#winMain) - GetSystemMetrics_(#SM_CYSIZEFRAME)
EndProcedure

Procedure InnerWindowMouseY()
  ProcedureReturn WindowMouseY(#winMain) - GetSystemMetrics_(#SM_CYCAPTION) - GetSystemMetrics_(#SM_CYSIZEFRAME)
EndProcedure

Procedure WatchTripleSplitterGadget()
  Shared Splitter_HandCursor, Splitter_ToggleH, Splitter_ToggleV, Splitter_ArrowCursorH, Splitter_ArrowCursorV
  Shared Splitter_GadgetX1.l, Splitter_GadgetX2.l, Splitter_GadgetY1.l, Splitter_GadgetY2.l

  If Splitter_ToggleH = 0 And ChildWindowFromPoint_(WindowID(#winMain),InnerWindowMouseX(),InnerWindowMouseY()) = GadgetID(3)
    SetCursor_(Splitter_HandCursor) 
  ElseIf Splitter_ToggleH = 1 And InnerWindowMouseX() > Splitter_GadgetX1 And InnerWindowMouseX() < Splitter_GadgetX2 
    ResizeGadget(0,#PB_Ignore,#PB_Ignore, InnerWindowMouseX() - 4 - Splitter_GadgetX1,#PB_Ignore) 
    ResizeGadget(1, InnerWindowMouseX() + 8,#PB_Ignore, Splitter_GadgetX2 - InnerWindowMouseX() - 8,#PB_Ignore) 
    ResizeGadget(3, InnerWindowMouseX(),#PB_Ignore,#PB_Ignore,#PB_Ignore) 
    SetCursor_(Splitter_ArrowCursorH) 
  ElseIf Splitter_ToggleV = 0 And ChildWindowFromPoint_(WindowID(#winMain),InnerWindowMouseX(),InnerWindowMouseY()) = GadgetID(4)
    SetCursor_(Splitter_HandCursor) 
  ElseIf Splitter_ToggleV = 1 And InnerWindowMouseY() > Splitter_GadgetY1 And InnerWindowMouseY() < Splitter_GadgetY2
    ResizeGadget(0,#PB_Ignore,#PB_Ignore,#PB_Ignore, InnerWindowMouseY() - 4 - Splitter_GadgetY1) 
    ResizeGadget(1,#PB_Ignore,#PB_Ignore,#PB_Ignore, InnerWindowMouseY() - 4 - Splitter_GadgetY1) 
    ResizeGadget(2,#PB_Ignore, InnerWindowMouseY() + 8,#PB_Ignore, Splitter_GadgetY2 - InnerWindowMouseY() - 8)
    ResizeGadget(3,#PB_Ignore,#PB_Ignore,#PB_Ignore, InnerWindowMouseY() - 12 - Splitter_GadgetY1) 
    ResizeGadget(4,#PB_Ignore, InnerWindowMouseY(),#PB_Ignore,#PB_Ignore) 
    SetCursor_(Splitter_ArrowCursorV) 
  EndIf 

EndProcedure

;- Example

OpenWindow(#winMain,200,200,320,320,"SplitterGadget Example",#PB_Window_SystemMenu) 
CreateGadgetList(WindowID(#winMain)) 
    
ListViewGadget(0,  10, 10, 88, 200)
    
ListViewGadget(1, 0, 0, 0, 0)
    
ListViewGadget(2, 10, 200, 200, 100)

TripleSplitterGadget(3, 4, 10, 10, 300, 300, 0, 1,2)


For k=0 To 10
  AddGadgetItem(0, -1, "Hello ListView Item Number " + Str(k))
Next

For k=0 To 10
  AddGadgetItem(1, -1, "Hello ListView Item Number " + Str(k))
Next

For k=0 To 10
  AddGadgetItem(2, -1, "Hello ListView Item Number " + Str(k))
Next

Repeat
  Event = WaitWindowEvent() 

  X = InnerWindowMouseX() ; for debugging purposes
  Y = InnerWindowMouseY() ; for debugging purposes

  If Event = #PB_Event_Gadget
    Select EventGadget()
      Case 3
        MoveSplitter.l=1 ;<- added by blbltheworm
        SetTripleSplitterGadgetH()
      Case 4
        MoveSplitter.l=1 ;<- added
        SetTripleSplitterGadgetV()
    EndSelect
       
  ElseIf Event = #WM_MOUSEMOVE 
    If MoveSplitter=1 ;<- added
      WatchTripleSplitterGadget()
    EndIf
  ElseIf Event =#WM_LBUTTONDOWN ;<- added
    If MoveSplitter=1 ;<- added
      MoveSplitter=0 ;<- added
      SetGadgetState(3,0) ;<- added
      SetGadgetState(4,0) ;<- added
      Splitter_ToggleH=0 ;<- added
      Splitter_ToggleV=0 ;<- added
    EndIf
  EndIf 
Until Event = #PB_Event_CloseWindow 

End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = --
; EnableXP