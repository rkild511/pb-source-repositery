; http://freak.purearea.net/help/
; Author: Freak (updated for PB 4.00 by Andre)
; Date: 28. November 2004
; OS: Windows
; Demo: No

; ------------------------------------------------------------------
;
;   Drag & Drop example with 
;   ExplorerListGadget and ExplorerTreeGadget
;
;   By Timo 'fr34k' Harter
;
; ------------------------------------------------------------------
;
; This example shows how to implement drag & drop between
; Explorer type gadgets in PureBasic. It is done very similar
; to the other drag & drop exmaples i wrote, so if you read them,
; you might find that this one uses basically all the same techniques.
;
; However, the explorer gadgets are a little more complicated than a
; basic ListIcon or TreeGadget, so this code is longer, but it
; should not be much more complicated than the others.
;
; As always, feel free to use any of the code/information given
; here in whichever way you want.
;
; ------------------------------------------------------------------

; These are the 3 Constants for the 3 needed objects: the main window and
; the two gadgets. If you modify this code to fit into your project,
; make sure you replace all occourances of these with your own constants.
; It should work with no problem with #PB_Any created onjects, you just
; have to replace all the constants with the variables then.
#Window       = 0
#ExplorerTree = 0
#ExplorerList = 1


; One note first for better understanding:
; The explorergadgets have like some of the other more
; complicated PB Gadgets an own invisible parent Window for their
; event procession. This is no problem, it just means, that you
; can't get their messages from the main WindowCallback, because
; they never end up there. You need to subclass that invisible
; parent window as described later to get these messages.

; Ok, here's the required global stuff. The callback variables
; are needed for the subclassing and explained below. IsDraging
; is #true when drag&drop is in progress and DragImageList stores
; the imagelist that contains the drag image.
; The other variables should be clear.

; You have to know though that 'SourceItem' and 'TargetItem' do contain
; the item index if the Gadget is an ExplorerListGadget and contain 
; an Item handle, when it is an ExplorerTreeGadget. This is because
; a treeview control internally only uses handles, and no index.

Global RealCallback_ExplorerList, RealCallback_ExplorerTree
Global IsDraging, SourceGadget, SourceItem, TargetGadget, TargetItem
Global DragImageList


; Ok, now about the subclassing. Each window and gadget in windows
; has a callback procedure that handles its messages. Subclassing
; just means that you replace that procedure with your own, and at the
; end of your procedure call the original one. This way, there can be
; a chain of subclasses, each procedure calling the next, and everybody
; can process the messages he needs.
; So the global values above are used to store the adress of the real
; callbacks of the invisible parent window of the gadgets.

; So here we have our replacement procedure for the ExplorerListGadget's
; parent window. We only need to catch one message here. The one that
; starts the draging, so this procedure is quite short.

Procedure Callback_ExplorerList(Window, Message, wParam, lParam)

  ; LVN_BEGINDRAG is the message inicating a d&d start. It is a #WM_NOTIFY
  ; message. So we get #WM_NOTIFY, and then there is a structure pointer
  ; in lParam, that contains the actual message data:
  
  If Message = #WM_NOTIFY
    *nmv.NMLISTVIEW = lParam
    
    If *nmv\hdr\code = #LVN_BEGINDRAG
      
      ; no target hilighted yet:
      TargetGadget = -1
      TargetItem   = -1    

      ; since this procedure subclasses only the one gadget, there is no
      ; need to ckeck for gadget type, as they can only come from this one.
      SourceGadget = #ExplorerList
      SourceItem   = GetGadgetState(#ExplorerList)
      
      ; This is a little check to make the ".." item undragable.
      ; you can ckeck for other types of items here, that you don't want to
      ; be draged. Just don't execute the following code then.
      If GetGadgetItemText(#ExplorerList, SourceItem, 0) <> ".."
        
        ; this message creates the drag image:        
        DragImageList = SendMessage_(GadgetID(#ExplorerList), #LVM_CREATEDRAGIMAGE, SourceItem, @UpperLeft.POINT)
        
        ; check for success:
        If DragImageList 
        
          ; ok, this starts the d&d operation
          If ImageList_BeginDrag_(DragImageList , 0, 0, 0)
            
            ; show the image
            ImageList_DragShowNolock_(#True)
            
            ; send all mouse messages to our main window (and thus main window callback)
            SetCapture_(WindowID(#Window))
            
            ; hide the normal cursor
            ShowCursor_(#False)

            ; indicate that d&d is in progress
            IsDraging = #True
            
          EndIf ; ImageList_BeginDrag_()
        
        EndIf ; check DragImageList
        
      EndIf ; check ".." item
    EndIf ; check #LVN_BEGINDRAG
  EndIf ; check #WM_NOTIFY

  ; Now we need to call the original procedure. This is really important,
  ; as otherwise the gadget won't work at all.
  ProcedureReturn CallWindowProc_(RealCallback_ExplorerList, Window, Message, wParam, lParam)
EndProcedure



; This is exactly the same for the ExplorerTreeGadget. The way of doing things is
; the same, just the structures and messages are a little different.

Procedure Callback_ExplorerTree(Window, Message, wParam, lParam)

  If Message = #WM_NOTIFY
    *nmtv.NMTREEVIEW = lParam 
    
    If *nmtv\hdr\code = #TVN_BEGINDRAG    

      TargetGadget = -1
      TargetItem   = -1    

      SourceGadget = #ExplorerTree
      
      ; The source item handle is stored in that structure:
      SourceItem   = *nmtv\itemNew\hItem
      
      ; note that this message functions a little different from the listicon one.
      ; have a look at MS documentation on LVM_CREATEDRAGIMAGE and TVM_CREATEDRAGIMAGES
      ; for the exact description.
      DragImageList = SendMessage_(GadgetID(#ExplorerTree), #TVM_CREATEDRAGIMAGE, 0, SourceItem)
      
      ; this part is exactly the same:
      If DragImageList 
        If ImageList_BeginDrag_(DragImageList , 0, 0, 0)

          ImageList_DragShowNolock_(#True)
          SetCapture_(WindowID(#Window))
          ShowCursor_(#False)

          IsDraging = #True
        EndIf    
      
      EndIf
           
    EndIf
  EndIf
  
  ; also call the real procedure:  
  ProcedureReturn CallWindowProc_(RealCallback_ExplorerTree, Window, Message, wParam, lParam)
EndProcedure

; Ok, the code to start the d&d operation is done. Now we need to implement
; the mouse moves, the target hilightning and the end of the operation.
; This is done in the main callback, because with "SetCapture_(WindowID(#Window))",
; we directed all mouse messages there.

; The next 2 procedures are just seperated, because this code needs to be called
; several times from the main callback.

; This procedure checks, which Gadget the mouse is currently over, and hilights
; the target. it also updates the TargetGadget and TargetItem variables.
; Note that MouseX and MouseY are client coordinates of the main window, not like
; WindowMouseY() and WindowMouseY() which include the window border.
; Note that while this procedure is called, the drag image must be hidden to aboid
; some ugly graphics.

Procedure HilightTarget(MouseX, MouseY)

  ; get the handle of the 'window' under the mouse:
  ; note that for explorer type gadgets, you get the handle of the invisible
  ; parent window here, so we have to compare this value to "GetParent_(GadgetID(#Gadget))"
  TargetID = ChildWindowFromPoint_(WindowID(#Window), MouseX, MouseY)
  
  ; because both gadgets can be both target or source (you can even drag within one gadget)
  ; so the code must always work for both gadgets:
  
  If TargetID = GetParent_(GadgetID(#ExplorerList))
    TargetGadget = #ExplorerList
    
    ; this checks, which item in the gadget the mouse is over:  
    lv_hittestinfo.LV_HITTESTINFO
    lv_hittestinfo\pt\x = MouseX - GadgetX(#ExplorerList)
    lv_hittestinfo\pt\y = MouseY - GadgetY(#ExplorerList)    
    
    ; note that the result here is an item index, that works with the PB gadget functions:
    TargetItem = SendMessage_(GadgetID(#ExplorerList), #LVM_HITTEST, 0, @lv_hittestinfo) 
    
    ; now we hilight the item:    
    lv_item.LV_ITEM
    lv_item\mask = #LVIF_STATE
    lv_item\iItem = TargetItem
    lv_item\state = #LVIS_DROPHILITED
    lv_item\stateMask = #LVIS_DROPHILITED    
    SendMessage_(GadgetID(#ExplorerList), #LVM_SETITEM, 0, @lv_item)  
    
    ; redraw the window
    RedrawWindow_(GadgetID(#ExplorerList), 0, 0, #RDW_UPDATENOW)      
    
    
  ; it is again the same for ExplorerTree, only with slightly different
  ; structures and messages:
  ElseIf TargetID = GetParent_(GadgetID(#ExplorerTree))
    TargetGadget = #ExplorerTree
    
    tv_hittestinfo.TV_HITTESTINFO
    tv_hittestinfo\pt\x = MouseX - GadgetX(#ExplorerTree)
    tv_hittestinfo\pt\y = MouseY - GadgetY(#ExplorerTree)    
    
    TargetItem = SendMessage_(GadgetID(#ExplorerTree), #TVM_HITTEST, 0, @tv_hittestinfo) 
    If TargetItem = 0
      TargetItem = -1
    EndIf
    
    tv_item.TV_ITEM
    tv_item\mask = #TVIF_STATE
    tv_item\hItem = TargetItem
    tv_item\state = #TVIS_DROPHILITED
    tv_item\stateMask = #TVIS_DROPHILITED    
    SendMessage_(GadgetID(#ExplorerTree), #TVM_SETITEM, 0, @tv_item)  
    
    RedrawWindow_(GadgetID(#ExplorerTree), 0, 0, #RDW_UPDATENOW)    
  
  ; if the mouse is not over any gadget, indicate that through the -1     
  Else
    TargetGadget = -1
    TargetItem = -1
  
  EndIf

EndProcedure


; This procedure unhilights the last hilighted gadgets, so a new one can
; be hilighted.

Procedure UnHilightTarget()

  If TargetGadget = #ExplorerList
           
    lv_item.LV_ITEM
    lv_item\mask = #LVIF_STATE
    lv_item\iItem = TargetItem
    lv_item\state = 0
    lv_item\stateMask = #LVIS_DROPHILITED
         
    SendMessage_(GadgetID(#ExplorerList), #LVM_SETITEM, 0, @lv_item)
    RedrawWindow_(GadgetID(#ExplorerList), 0, 0, #RDW_UPDATENOW)  
  
  ElseIf TargetGadget = #ExplorerTree

    tv_item.TV_ITEM
    tv_item\mask = #TVIF_STATE
    tv_item\hItem = TargetItem
    tv_item\state = 0
    tv_item\stateMask = #TVIS_DROPHILITED
    
    SendMessage_(GadgetID(#ExplorerTree), #TVM_SETITEM, 0, @tv_item)  
    RedrawWindow_(GadgetID(#ExplorerTree), 0, 0, #RDW_UPDATENOW)    
  
  EndIf

EndProcedure



; Finally there is the main window callback. This is a normal
; PB windowcallback, as you can see by the #PB_ProcessPureBasicEvents way

Procedure Callback_MainWindow(Window, Message, wParam, lParam)
  result = #PB_ProcessPureBasicEvents
    
  ; the following messages are only processed when draging is in progress
  If IsDraging
  
    ; the mouse is moved, so the image needs to be moved, and maybe a new
    ; target hilighted
    If Message = #WM_MOUSEMOVE
      
      ; this moves the drag image. Screen coordinates are needed here.
      ; for this we need screen coordinates
      GetCursorPos_(@MousePos.POINT)
      ImageList_DragMove_(MousePos\x, MousePos\y)
      
      ; now hide the image for the hilightning of the target
      ImageList_DragShowNolock_(#False)         
      
      ; unhilight any previously hilighted target, and hilight the new one
      UnHilightTarget()
      HilightTarget(WindowMouseX(#Window), WindowMouseY(#Window))
      
      ; show the drag image again.
      ImageList_DragShowNolock_(#True)
    
    
    ; mouse button up, so the d&d is finished.
    ElseIf Message = #WM_LBUTTONUP
      
      ; release the mouse message capturing
      ReleaseCapture_()
      
      ; end the d&d operation
      ImageList_EndDrag_()
      
      ; free the image list
      ImageList_Destroy_(DragImageList)      
      
      ; show the cursor again
      ShowCursor_(#True)
      
      ; indicate, that d&d is no longer in progress
      IsDraging = #False
      
      ; unhilight the target
      UnHilightTarget()
      
      ; That's it, the drag&drop is finished. Now we can work with what we know.
      ; The last call of the HilightTarget() procedure has allready set the
      ; TargetGadget and TargetItem values, so no more such checks are needed.
      
      ; I have inserted a message requester here to show the available information,
      ; and also to explain how to get it.
      
      Message$ = "Drag & Drop complete" + #CRLF$ + #CRLF$
      
      ; for d&d to start, there must be a valid source gadget and item, so there
      ; is no need to check for -1 here.
      
      If SourceGadget = #ExplorerList
        Message$ + "Source: ExplorerListGadget" + #CRLF$
        
        ; for ExplorerListGadget, to get the full item path, both these functions are needed.
        Message$ + "Item: " + GetGadgetText(#ExplorerList) + GetGadgetItemText(#ExplorerList, SourceItem, 0) + #CRLF$
        
        If GetGadgetItemState(#ExplorerList, SourceItem) & #PB_Explorer_Directory
          Message$ + "Type: Directory" + #CRLF$
        Else
          Message$ + "Type: File" + #CRLF$          
        EndIf        
      
      ElseIf SourceGadget = #ExplorerTree
        ; Here is a little issue. As said before, a treeview works with handles, also
        ; the ExplorerTreeGadget doesn't have 'individual' items like the list one, it
        ; only has one current one. Also, the d&d operation removes this current
        ; selection from the gadget.
        
        ; so what we do to get this info is to manually select the Source and the
        ; target item with SendMessage and it's handle, then get the information
        ; with GetGadgetText/State, and deselect the item again later:      
        SendMessage_(GadgetID(#ExplorerTree), #TVM_SELECTITEM, #TVGN_CARET, SourceItem)
        
        ; get the info:
        Message$ + "Source: ExplorerTreeGadget" + #CRLF$
        Message$ + "Item: " + GetGadgetText(#ExplorerTree) + #CRLF$
        If GetGadgetState(#ExplorerList) & #PB_Explorer_Directory
          Message$ + "Type: Directory" + #CRLF$
        Else
          Message$ + "Type: File" + #CRLF$          
        EndIf        
        
        ; delselect the item again:
        SendMessage_(GadgetID(#ExplorerTree), #TVM_SELECTITEM, #TVGN_CARET, 0)
              
      EndIf
            
      Message$ + #CRLF$
      
      If TargetGadget = -1
        Message$ + "Target: Item dropped not in the Explorer Gadgets." + #CRLF$
      
      ElseIf TargetGadget = #ExplorerList
        Message$ + "Source: ExplorerListGadget" + #CRLF$
        If TargetItem = -1
          Message$ + "Item: Item dropped in the empty Gadget area." + #CRLF$
        Else
          Message$ + "Item: " + GetGadgetText(#ExplorerList) + GetGadgetItemText(#ExplorerList, TargetItem, 0) + #CRLF$
          If GetGadgetItemState(#ExplorerList, TargetItem) & #PB_Explorer_Directory
            Message$ + "Type: Directory" + #CRLF$
          Else
            Message$ + "Type: File" + #CRLF$          
          EndIf                       
        EndIf
        
      ElseIf TargetGadget = #ExplorerTree
        Message$ + "Target: ExplorerTreeGadget" + #CRLF$
        If TargetItem = -1
          Message$ + "Item: Item dropped in the empty Gadget area." + #CRLF$
        Else                 
          ; same here: first select the target, get the info and unselect it.
          
          SendMessage_(GadgetID(#ExplorerTree), #TVM_SELECTITEM, #TVGN_CARET, TargetItem)
          Message$ + "Item: " + GetGadgetText(#ExplorerTree) + #CRLF$
          If GetGadgetState(#ExplorerList) & #PB_Explorer_Directory
            Message$ + "Type: Directory" + #CRLF$
          Else
            Message$ + "Type: File" + #CRLF$          
          EndIf  
          SendMessage_(GadgetID(#ExplorerTree), #TVM_SELECTITEM, #TVGN_CARET, 0)                                         
        EndIf
         
      EndIf
      
      ; That's it, now you have all the info you need. work with it ;)
      ; Let's just display our requester.
      
      ; One note though: If you do file operations in the displayed directorys,
      ; the ExplorerListGadget() will automatically refresh. However, the
      ; ExplorerTreeGadget() doesn't have that feature yet (PB v3.91).
      ; Just be aware of this.
      
      MessageRequester("Drag & Drop", Message$)
    
    EndIf  ; check Message
  
  EndIf  ; check IsDraging
  
  ProcedureReturn result  ; return result
EndProcedure



; That was all the hard part, now simply follows the GUI part:

If OpenWindow(#Window, 0, 0, 800, 600, "Drag & Drop with ExplorerGadgets", #PB_Window_SystemMenu|#PB_Window_ScreenCentered)
  If CreateGadgetList(WindowID(#Window))
    
    ExplorerTreeGadget(#ExplorerTree, 5, 5, 240, 590, "*.*", #PB_Explorer_AutoSort)
    ExplorerListGadget(#ExplorerList, 255, 5, 540, 590, "*.*", #PB_Explorer_AutoSort)
    
    ; these lines subclass the parent of the gadgets, and stores the old
    ; callback procedure address in our global variable.
    
    RealCallback_ExplorerList = SetWindowLong_(GetParent_(GadgetID(#ExplorerList)), #GWL_WNDPROC, @Callback_ExplorerList())
    RealCallback_ExplorerTree = SetWindowLong_(GetParent_(GadgetID(#ExplorerTree)), #GWL_WNDPROC, @Callback_ExplorerTree())
    
    ; for a treeview, drag&drop needs to be enabled first in order to work.
    ; this is very important.
    SetWindowLong_(GadgetID(#ExplorerTree), #GWL_STYLE, GetWindowLong_(GadgetID(#ExplorerTree), #GWL_STYLE) & ~#TVS_DISABLEDRAGDROP)
    
    ; finally set our main window callback:
    SetWindowCallback(@Callback_MainWindow())
    
    ; nothing to do in the event loop:
    Repeat
      Event = WaitWindowEvent()
    Until Event = #PB_Event_CloseWindow
    
  EndIf
EndIf

End


; ------------------------------------------------------------------
;
; Phhhhew! That was lots of text again, and probably lots of
; typing errors again :)
; I hope it was easy to understand, and is helpfull to you.
; For more questions, mail me at 'freak@betriebsdirektor.de', or
; ask on the forums at 'http://forums.purebasic.com'
; For more of these tutorials, browse my site at 
; 'http://freak.purearea.net/'
;
; Thanks for reading..
;
; Timo
;
; ------------------------------------------------------------------

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -