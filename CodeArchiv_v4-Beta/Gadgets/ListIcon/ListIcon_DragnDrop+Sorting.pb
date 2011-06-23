; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7022&highlight=
; Author: LJ (updated for PB4.00 by blbltheworm)
; Date: 26. July 2003
; OS: Windows
; Demo: No


; German forum: 
; Author: Freak (Timo Harter) 
; Date: 17. December 2002 
; Modified for use with ListGadget by Lance Jepsen (Sorted) 
; Date: 15. July 2003 

; -------------------------------------------------------------------------- 
; Drag'n' Drop mit TreeGadgets 
; by Timo Harter 
; 
; Syntax: 
; EnableDragDrop( #Gadget, DragMode, @DropProcedure() ) 
; 
; 
; DragMode : #Drag_LeftMouse  
;            #Drag_RightMouse 
; 
; @DropProcedure() 

;            Procedure DropProcedure(X.l, Y.l, Button.l, Item.l) 
; 


#TVN_BEGINDRAG       = -407 
#TVN_BEGINRDRAG      = -408 
#TVS_DISABLEDRAGDROP = $10 
#Drag_LeftMouse  = 1 
#Drag_RightMouse = 2 
#ListIcon = 3 

Global hWndTV.l, DropProc.l, DragDropMode.l, hDragIml.l, DragItem.l 

Procedure.l DragDropCallback(Window.l, Message.l, wParam.l, lParam.l) 
  Protected DoDrag.l, DropX.l, DropY.l, hItem.l, hItem2.l, dItem.l 
  result = #PB_ProcessPureBasicEvents 
  Select Message 
    Case #WM_NOTIFY 
      *lp.NMHDR = lParam 
      If *lp\code = #TVN_BEGINDRAG And (DragDropMode & #Drag_LeftMouse): DoDrag = #True: EndIf 
      If *lp\code = #TVN_BEGINRDRAG And (DragDropMode & #Drag_RightMouse): DoDrag = #True: EndIf 
      If DoDrag 
        *pnmtv.NMTREEVIEW = lParam 
        DragItem = *pnmtv\itemNew\hItem 
        hDragIml = SendMessage_(hWndTV, #TVM_CREATEDRAGIMAGE, 0, DragItem) 
        SendMessage_(hWndTV, #TVM_SELECTITEM, #TVGN_CARET, #Null) 
        ImageList_BeginDrag_(hDragIml, 0, 0, 0) 
        ImageList_DragEnter_(GetParent_(hWndTV), 0, 0) 
        ImageList_DragShowNolock_(#True) 
        ImageList_DragLeave_(hWndTV) 
        ShowCursor_(#False) 
        SetCapture_(GetParent_(hWndTV)) 
        SendMessage_(hWndTV, #TVM_SELECTITEM, #TVGN_CARET, DragItem) 
      EndIf 
    Case #WM_MOUSEMOVE 
        If hDragIml 
          DropX = PeekW(@lParam) 
          DropY = PeekW(@lParam+2) 
          ImageList_DragMove_(DropX, DropY+20) 
          ImageList_DragShowNolock_(#False) 
          ImageList_DragShowNolock_(#True) 
        EndIf 
    Case #WM_LBUTTONUP 
        If hDragIml And (DragDropMode & #Drag_LeftMouse) 
          ImageList_EndDrag_() 
          ReleaseCapture_() 
          ShowCursor_(#True) 
          ImageList_Destroy_(hDragIml) 
          hDragIml = #False 
          dItem = 0 
          hItem = SendMessage_(hWndTV, #TVM_GETNEXTITEM, #TVGN_ROOT, 0) 
          While hItem <> DragItem 
            hItem2 = SendMessage_(hWndTV, #TVM_GETNEXTITEM, #TVGN_CHILD, hItem) 
            Repeat 
              If hItem2 = #Null: hItem2 = SendMessage_(hWndTV, #TVM_GETNEXTITEM, #TVGN_NEXT, hItem): EndIf 
              If hItem2 = #Null: hItem = SendMessage_(hWndTV, #TVM_GETNEXTITEM, #TVGN_PARENT, hItem): EndIf 
            Until hItem2 <> #Null 
            hItem = hItem2 
            dItem + 1 
          Wend 
          CallFunctionFast(DropProc, WindowMouseX(0), WindowMouseY(0), #Drag_LeftMouse, dItem) 
        EndIf 
    Case #WM_RBUTTONUP 
        If hDragIml And (DragDropMode & #Drag_RightMouse) 
          ImageList_EndDrag_() 
          ReleaseCapture_() 
          ShowCursor_(#True) 
          ImageList_Destroy_(hDragIml) 
          hDragIml = #False 
          dItem = 0 
          hItem = SendMessage_(hWndTV, #TVM_GETNEXTITEM, #TVGN_ROOT, 0) 
          While hItem <> DragItem 
            hItem2 = SendMessage_(hWndTV, #TVM_GETNEXTITEM, #TVGN_CHILD, hItem) 
            Repeat 
              If hItem2 = #Null: hItem2 = SendMessage_(hWndTV, #TVM_GETNEXTITEM, #TVGN_NEXT, hItem): EndIf 
              If hItem2 = #Null: hItem = SendMessage_(hWndTV, #TVM_GETNEXTITEM, #TVGN_PARENT, hItem): EndIf 
            Until hItem2 <> #Null 
            hItem = hItem2 
            dItem + 1 
          Wend 
          CallFunctionFast(DropProc, WindowMouseX(0), WindowMouseY(0), #Drag_RightMouse, DragItem)          
        EndIf 
  EndSelect 
  ProcedureReturn result 
EndProcedure 

Procedure.l EnableDragDrop(TVGadget.l, DragMode.l, DropProcedure.l) 
  Protected Style.l, hIml.l 
  hWndTV = GadgetID(TVGadget) 
  DropProc = DropProcedure 
  DragDropMode = DragMode 
  Style = GetWindowLong_(hWndTV, #GWL_STYLE) 
  Style = Style & (~#TVS_DISABLEDRAGDROP) 
  SetWindowLong_(hWndTV, #GWL_STYLE, Style) 
  If SendMessage_(hWndTV, #TVM_GETIMAGELIST, #TVSIL_NORMAL, 0) = #Null 
    hIml = ImageList_Create_(16,16,#ILC_COLOR8,0,999) 
    SendMessage_(hWndTV, #TVM_SETIMAGELIST, #TVSIL_NORMAL, hIml) 
  EndIf 
  SetWindowCallback(@DragDropCallback()) 
  ProcedureReturn #True 
EndProcedure 

Procedure DropProcedure(X.l, Y.l, Button.l, Item.l) 
If Button = #Drag_LeftMouse 
  If X > 212 And X < 310 
     If Y > 45 And Y < 273 
      
        AddGadgetItem(#ListIcon,-1,"Item"+Str(Item)) 
         NbElements = CountGadgetItems(#ListIcon) 
         Global Dim Array.s(NbElements) 
         For k=0 To NbElements 
         Array(k) = GetGadgetItemText(#ListIcon, k,0) 
         Next 
         SortArray(Array(), 2, 0, NbElements) 
         ClearGadgetItemList(#ListIcon) 
         For k= 1 To NbElements 
         AddGadgetItem(#ListIcon, k, Array(k)) 
         Next 
          
     EndIf 
  EndIf 
EndIf 

; Un-REM (take off ";" in lines below when you need to determine X and Y coordinates of drop 
;  If Button = #Drag_LeftMouse 
;    MessageRequester("Drag'n Drop","Item Number "+Str(Item)+" has been dropped at X:"+Str(X)+" Y:"+Str(Y)+" using left Button.",#MB_ICONINFORMATION) 
;  Else 
;    MessageRequester("Drag'n Drop","Item Number "+Str(Item)+" has been dropped at X:"+Str(X)+" Y:"+Str(Y)+" using right Button.",#MB_ICONINFORMATION) 
;  EndIf 
EndProcedure 

#Tree = 1 

OpenWindow(0, 0, 0, 640, 480, "Drag'n Drop", #PB_Window_SystemMenu | #PB_Window_ScreenCentered) 
CreateGadgetList(WindowID(0)) 

TreeGadget(#Tree, 5, 5, 150, 250) 
hImg = LoadIcon_(0,#IDI_APPLICATION) 
AddGadgetItem(#Tree, -1, "Item0", hImg) 
AddGadgetItem(#Tree, -1, "Item1") 
  AddGadgetItem(#Tree, -1, "Item2",0,1) 
  AddGadgetItem(#Tree, -1, "Item3",0,1) 

ListIconGadget(#ListIcon,250,5, 80, 250, "Item Dropped", 76) 

EnableDragDrop(#Tree, #Drag_LeftMouse|#Drag_RightMouse, @DropProcedure()) 

While WaitWindowEvent() <> #PB_Event_CloseWindow: Wend 
End 


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
