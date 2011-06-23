; English forum:
; Author: Franco (code fixed & updated for PB4.00 by blbltheworm)
; Date: 22. July 2003
; OS: Windows
; Demo: No


; (c) 2003 - Franco's template - absolutely freeware
; This is a Gadget Splitter
; Should work fine on all Windows Operating Systems
;
; Normally if you have 2 ListViews (or TreeViews etc.) and you want
; change the width of both (one decreases the other increases) you
; use mouse hot spots between the Gadgets. 
; Negative about this is the manually setting of this hotspot. 
; Every time you change the position of your ListViews, you have to
; adapt the hotspot.
; Also sometimes it doesn't work properly...
; (see PureBasic Editor while the Procedure Browser is on the left,
; the Arrow Cursor appears also inside the RichEdit Gadget.
; Also the Gadgets Splitter example in PureBasic v3.00 - nowadays disappeared...)
;
; Now here this "hotspot" works different.
; It is realized as a Gadget = SplitterGadget(...)
; No adaptation is required!
; How is this done?
; 
; You create two gadgets which you want to incorporate in your 
; splitter function. Example:
; ListViewGadget(1,  10, 10, 88, 200)
; or
; ListViewGadget(2,  0, 0, 0, 0) ; I talk about the zeros later...
;
; After that, you have to create the SplitterGadget with:
; SplitterGadget(GadgetNumber.l, PositionX.l, PositionY.l, Width.l, Height.l, LeftGadget.l, RightGadget.l)
;
; The PositionX, PositionY, Width and Height are the maximum area 
; of all incorporated Gadgets. That's why it's possible to do:
; ListViewGadget(2,  0, 0, 0, 0). 
; This values are changed when you call the SplitterGadget.
; For this you have to tell the SplitterGadget which Gadgets to work with.
; This can be done with the parameters LeftGadget and RightGadget.
; That's it!
;
; As you can see, you have to click the toggle button on the SplitterGadget
; and than you can move it. A second click will freeze it at the actual position.
; I know, the use is different than normal hotspots, but I think this approach
; is more elegant - and personally I don't care if I have to click twice.
;
; The Procedures SetSplitterGadget() and WatchSplitterGadget() must be
; incorporated in the event handler as seen in this example. 
;
; The return value of SplitterGadget is the Windows-OS handle of this Gadget.
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

Procedure DualSplitterGadget(GadgetNumber.l, PositionX.l, PositionY.l, Width.l, Height.l, LeftGadget.l, RightGadget.l)
  Shared Splitter_Toggle, Splitter_HandCursor.l, Splitter_ArrowCursor.l
  Shared Splitter_GadgetX1, Splitter_GadgetX2
  
  RoomBetweenGadgets.l = 4
  
  SplitterGadgetWidth.l = 4
  SplitterGadgetHeight.l = Height - (RoomBetweenGadgets * 2)
  SplitterGadgetX.l = PositionX + Width/2 - SplitterGadgetWidth/2
  SplitterGadgetY.l = PositionY + 4

  LeftGadgetWidth.l = SplitterGadgetX - 4 - PositionX
  ResizeGadget(LeftGadget, PositionX, PositionY, LeftGadgetWidth, Height) 

  RightGadgetX.l = SplitterGadgetX + SplitterGadgetWidth + RoomBetweenGadgets
  RightGadgetWidth.l = PositionX + Width - RightGadgetX
  ResizeGadget(RightGadget, RightGadgetX, PositionY, RightGadgetWidth, Height) 
  
  SplitterID.l = ButtonGadget(GadgetNumber, SplitterGadgetX, SplitterGadgetY, SplitterGadgetWidth, SplitterGadgetHeight,"",#PB_Button_Toggle)
  SetClassLong_(SplitterID,#GCL_HCURSOR,0)

  Splitter_ArrowCursor = LoadCursor_(0, #IDC_SIZEWE)
  Splitter_HandCursor = LoadCursor_(0, 32649); #IDC_HAND not recognized by PureBasic

  Splitter_Toggle = 0

  Splitter_GadgetX1.l = PositionX
  Splitter_GadgetX2.l = PositionX + Width

  ProcedureReturn SplitterID

EndProcedure

Procedure SetDualSplitterGadget()
  Shared Splitter_Toggle

  If Splitter_Toggle = 0
    Splitter_Toggle = 1
  ElseIf Splitter_Toggle = 1
    Splitter_Toggle = 0
  EndIf 

EndProcedure

Procedure InnerWindowMouseX()
  ProcedureReturn WindowMouseX(#winMain) - GetSystemMetrics_(#SM_CYSIZEFRAME)
EndProcedure

Procedure InnerWindowMouseY()
  ProcedureReturn WindowMouseY(#winMain) - GetSystemMetrics_(#SM_CYCAPTION) - GetSystemMetrics_(#SM_CYSIZEFRAME)
EndProcedure

Procedure WatchDualSplitterGadget()
  Shared Splitter_HandCursor, Splitter_ArrowCursor, Splitter_Toggle
  Shared Splitter_GadgetX1, Splitter_GadgetX2

  If Splitter_Toggle = 0 And ChildWindowFromPoint_(WindowID(#winMain),InnerWindowMouseX(),InnerWindowMouseY()) = GadgetID(2)
    SetCursor_(Splitter_HandCursor) 
  ElseIf Splitter_Toggle = 1 And InnerWindowMouseX() > Splitter_GadgetX1 And InnerWindowMouseX() < Splitter_GadgetX2
    ResizeGadget(0,#PB_Ignore,#PB_Ignore, InnerWindowMouseX() - 4 - Splitter_GadgetX1,#PB_Ignore) 
    ResizeGadget(1, InnerWindowMouseX() + 8,#PB_Ignore, Splitter_GadgetX2 - InnerWindowMouseX() - 8,#PB_Ignore) 
    ResizeGadget(2, InnerWindowMouseX() ,#PB_Ignore,#PB_Ignore,#PB_Ignore) 
    SetCursor_(Splitter_ArrowCursor) 
  EndIf 

EndProcedure

;- Example

OpenWindow(#winMain,200,200,320,240,"SplitterGadget Example",#PB_Window_SystemMenu) 
CreateGadgetList(WindowID(#winMain)) 
    
ListViewGadget(0,  10, 10, 88, 200)
    
ListViewGadget(1, 0, 0, 0, 0)
    
DualSplitterGadget(2, 10, 10, 300, 200, 0, 1)

For k=0 To 10
  AddGadgetItem(0, -1, "Hello ListView Item Number " + Str(k))
Next

For k=0 To 10
  AddGadgetItem(1, -1, "Hello ListView Item Number " + Str(k))
Next

SetDualSplitterGadget()

Repeat
  Event = WaitWindowEvent() 
  
  X = InnerWindowMouseX() ; for debugging purposes
  Y = InnerWindowMouseY() ; for debugging purposes

  If Event = #PB_Event_Gadget ; Start moving
    Select EventGadget()
      Case 2
        MoveSplitter.l=1 ;<- added by blbltheworm
    EndSelect
       
  ElseIf Event = #WM_MOUSEMOVE 
    If MoveSplitter=1
      WatchDualSplitterGadget()
    EndIf
  ElseIf Event=#WM_LBUTTONDOWN ;Stop moving ;<- added
    If MoveSplitter=1  ;<- added
      MoveSplitter=0 ;stop moving <- added
      SetGadgetState(2,0) ;retoggle Button ;<- added
    EndIf
  EndIf 
Until Event = #PB_Event_CloseWindow 

End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP