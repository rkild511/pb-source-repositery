; freak.PureArea.net
; Author: Freak (updated for PB4.00 by blbltheworm)
; Date: 08. December 2003
; OS: Windows
; Demo: No
 
; ------------------------------------------------------------------
;
;   Drag & Drop example with ListIconGadget
;   By Timo 'fr34k' Harter
;
; ------------------------------------------------------------------
;
; Hi, this is a rather basic example of how to do drag & drop with 
; a ListIconGadget in PureBasic. It should give you a good start, of
; how to do such a thing in your own projects. This uses 2 Gadgets
; for the demonstration. It should not be hard to modify it to use
; more than that, or even to work with only one Gadget.
;
; Feel free, to copy & paste any of this code into your own, i don't 
; care.
;
; ------------------------------------------------------------------

; Ok, let's start with what we need global, so it is always accessible 
; from the callback procedure. 'IsDraging' is used to see, if a drag&drop
; operation is in progress, 'DragImageList' is used to store the displayed
; drag&drop image. The rest should be pretty clear.

Global IsDraging, DragImageList, SourceGadget, SourceItem, TargetGadget, TargetItem

Declare WindowCallback(Window, Message, wParam, lParam)


; Here, the GUI is created, nothing fancy about this one...

#ListIcon1 = 1
#ListIcon2 = 2

If OpenWindow(0, 0, 0, 600, 300, "ListIcon Drag&Drop", #PB_Window_ScreenCentered|#PB_Window_SystemMenu)
  If CreateGadgetList(WindowID(0))
  
    ; callback is needed for the processing of the drag&drop messages
    SetWindowCallback(@WindowCallback())  
    
    ListIconGadget(#ListIcon1, 5, 5, 290, 290, "Testing...", 250)
    ListIconGadget(#ListIcon2, 305, 5, 290, 290, "Testing...", 250)  
    
    For i = 0 To 10
      AddGadgetItem(#ListIcon1, -1, "Gadget1 - Item"+Str(i))
      AddGadgetItem(#ListIcon2, -1, "Gadget2 - Item"+Str(i))
    Next i
    
    ; all drag&drop handling is done in the callback procedure,
    ; so nothing is needed here.  
    Repeat
    Until WaitWindowEvent() = #PB_Event_CloseWindow
  
  EndIf
EndIf

End


; If you are not familiar with the use of a WindowCallback procedure,
; you should read my basic explanation here:
; http://purebasic.myforums.net/viewtopic.php?p=39654#39654

Procedure WindowCallback(Window, Message, wParam, lParam)
  Result = #PB_ProcessPureBasicEvents
  
  ; The first message we need is #LVN_BEGINDRAG. This is a so called
  ; Notification message. This means, that you don't get a message called
  ; #LVN_BEGINDRAG, but you get a #WM_NOTIFY message, with further information, 
  ; that tells you, that it is #LVN_BEGINDRAG.

  If Message = #WM_NOTIFY
  
    ; The lparam paramenter contains a pointer to a NMHDR structure. There is
    ; the information about the Message    
    *nmhdr.NMHDR = lParam
    
    ; The 'hwndfrom' member tells you, which Gadget actually sent the message
    ; This must be always checked to be sure, it is the right gadget.
    ; We allow only our 2 Gadgets:
    If *nmhdr\hwndfrom = GadgetID(#ListIcon1) Or *nmhdr\hwndfrom = GadgetID(#ListIcon2)
    
      ; The 'code' member contains the real message, in our case #LVN_BEGINDRAG
      If *nmhdr\code = #LVN_BEGINDRAG
    
        ; Let's find out, which of our Gadgets is the source, we will need this later.
        ; If you have more than 2 Gadgets with drag&drop, you have to add more checks
        ; here:
        If *nmhdr\hwndfrom = GadgetID(#ListIcon1)
          SourceGadget = #ListIcon1
          
        Else  ; must be #ListIcon2, as we have allready checked, that it is only one of the 2
          SourceGadget = #ListIcon2
          
        EndIf
        
        ; Ok, for the #LVN_BEGINDRAG notification message, lParam is a pointer to a
        ; NMLISTVIEW Structure. You might think that this can't be, as lParam allready
        ; pointed to a NMHDR structure, but this is correct, as NMLISTVIEW has a
        ; NMHDR structure inside, it only adds more members to it.
    
        *nmv.NMLISTVIEW = lParam
        
        ; The 'iItem' member contains the index of the source item, which we will need
        ; later.        
        SourceItem = *nmv\iItem        
        
        ; By sending a #LVM_CREATEDRAGIMAGE message to the gadget, we create an ImageList
        ; that contains just one image, the drag&drop image. We will need the Imagelist WinAPI
        ; commands to work with that one later. This message also expects a POINT structure
        ; as parameter that contains the hot-spot in the image. As we set this to (0|0), we
        ; don't even need to initialize this variable.             
        DragImageList = SendMessage_(GadgetID(SourceGadget), #LVM_CREATEDRAGIMAGE, SourceItem, @UpperLeft.POINT)
        
        ; It is important to check the result, as it would lock the mouse, if
        ; we continue without this one working.
        If DragImageList 
        
          ; This begins the drag&drop operation by displaying the image
          If ImageList_BeginDrag_(DragImageList , 0, 0, 0)
            
            ; this command shows or hides the drag&drop image. Or course,
            ; we want to see it now :)
            ImageList_DragShowNolock_(#True)
            
            ; this causes windows to send all mouse messages to our window,
            ; even if the mouse is outside of our window. This is neccesary,
            ; because we need to detect the mouseup event to abort the
            ; operation, even if the mouse is outside our window.
            SetCapture_(GetParent_(GadgetID(SourceGadget)))
            
            ; hide the standart cursor
            ShowCursor_(#False)
            
            ; When processing the other events, we need to know whether something
            ; is being draged or not.
            IsDraging = #True
            
            
          EndIf ; check for ImageList_BeginDrag_()       
        
        EndIf ; check for DragImageList
        
      EndIf ; check for #LVN_BEGINDRAG
          
    EndIf ; check for right gadget
    
  
  ; The next message we need is #WM_MOUSEMOVE, to update the mouse.
  ; But only if IsDraging is #TRUE.  
  ElseIf Message = #WM_MOUSEMOVE And IsDraging
    
    ; this moves the drag Image. It requires Screen coordinates.    
    ImageList_DragMove_(WindowMouseX(0)+WindowX(0), WindowMouseY(0)+WindowY(0))  
    
    ; now we hide the image to avoid redraw problems.
    ImageList_DragShowNolock_(#False)
    
    ; the next thing we do is hilighting the target item in the target gadget.
    ; for this, we need mouse coordinates relative to the client area of our
    ; window. WindowMouseX() and WindowMouseY() include the window borders, so
    ; we can't use them. When #EM_MOUSEMOVE is sent, the lParam parameter contains
    ; the x coordinate in the low-word and the y coordinate in the high-word, so we
    ; just use them here:
        
    MouseX = lParam & $FFFF
    MouseY = lParam >> 16
    
    ; first, we unhilight the previous target, if there was one:    
    If TargetGadget <> -1
      
      ; We send a #LNM_SETITEM message for that, but we only need to change the
      ; item state, so #LVIF_STATE is enough for the mask.          
      pitem.LV_ITEM
      pitem\mask = #LVIF_STATE
      pitem\iItem = TargetItem
      
      ; 'stateMask' determines, what will be changed, and 'state' sets the actual value,
      ; so here, we set the #LVIS_DROPHILITED state flag to 0.
      pitem\state = 0
      pitem\stateMask = #LVIS_DROPHILITED
           
      SendMessage_(GadgetID(TargetGadget), #LVM_SETITEM, 0, @pitem)
      
      ; a redraw is neccesary here to avoid problems.
      RedrawWindow_(GadgetID(TargetGadget), 0, 0, #RDW_UPDATENOW)
    
    EndIf
    
    ; now we need to find out, which Gadget is currently the target one.
    ; with ChildWindowFromPoint_() we can get it's handle.
    TargetGadgetID = ChildWindowFromPoint_(Window, MouseX, MouseY)
    
    ; find out the PB numeric ID for the Gadget
    ; again, for more Gadgets, more checks are needed.
    If TargetGadgetID = GadgetID(#ListIcon1)
      TargetGadget = #ListIcon1
      
    ElseIf TargetGadgetID = GadgetID(#ListIcon2)
      TargetGadget = #ListIcon2
      
    Else
      TargetGadget = -1
    EndIf
        
    
    If TargetGadget <> -1
    
      ; What we need next is the Item, that is currently under the mouse cursor.
      ; the #LVM_HITTEST message does that test for us.
    
      ; here, we need coordinates relative to the top/left corner of our target
      ; Gadget, so we substract the Gadget position from our window coordinates.
      hittestinfo.LV_HITTESTINFO
      hittestinfo\pt\x = MouseX - GadgetX(TargetGadget)
      hittestinfo\pt\y = MouseY - GadgetY(TargetGadget)
      
      ; find the item, if none is under the cursor, we get -1, and the next
      ; SendMessage won't work, and nothing is hilighted.
      TargetItem = SendMessage_(GadgetID(TargetGadget), #LVM_HITTEST, 0, @hittestinfo)            
    
      ; same as before, this time we set the #LVIS_DROPHILITED flag to #LVIS_DROPHILITED.
      pitem.LV_ITEM
      pitem\mask = #LVIF_STATE
      pitem\iItem = TargetItem
      pitem\state = #LVIS_DROPHILITED
      pitem\stateMask = #LVIS_DROPHILITED
      
      SendMessage_(GadgetID(TargetGadget), #LVM_SETITEM, 0, @pitem)  
      RedrawWindow_(GadgetID(TargetGadget), 0, 0, #RDW_UPDATENOW) ; again a redraw
    
    EndIf
    
    ; now we can show the drag image again:        
    ImageList_DragShowNolock_(#True)
    
    ; that's all to do while moving the mouse. Of course, there can be more checks added,
    ; and for example, a different cursor displayed, if you don't want the source to
    ; be draged to the current target and so on, but i think this is enough for a basic
    ; example.
  
  
  ; next is the end of the drag&drop operation... when the user releases the mouse.           
  ElseIf Message = #WM_LBUTTONUP And IsDraging
    
    ; first, we release all we did, to unlock the mouse. 
    
    ; mouse messages will be sent to other windows again    
    ReleaseCapture_()
    
    ; and drag&drop (remove the image)
    ImageList_EndDrag_()
    
    ; free the image list
    ImageList_Destroy_(DragImageList)
    
    ; show cursor again
    ShowCursor_(#True)
    
    ; no draging in progress now.
    IsDraging = #False
    
    
    ; next, we unhilight the last target item, just like before:        
    If TargetGadget <> -1
    
      pitem.LV_ITEM
      pitem\mask = #LVIF_STATE
      pitem\iItem = TargetItem
      pitem\state = 0
      pitem\stateMask = #LVIS_DROPHILITED
      
      SendMessage_(GadgetID(TargetGadget), #LVM_SETITEM, 0, @pitem)
      RedrawWindow_(GadgetID(TargetGadget), 0, 0, #RDW_UPDATENOW)
    
    EndIf  
    
    ; there is no need to check, which is the target, because this was allready
    ; done on the last mouse move.
    ; just check, if the mouse is over one of our target gadgets:
    If TargetGadget <> -1
    
      ; at this point, every thing is complete, and we know, that the 
      ; drag&drop was successfull, from one gadget to another.
      ; We can now take the action on this operation.
      
      ; Note: TargetItem might be -1, if the item was draged into the
      ; empty area of the target gadget. The TargetItem doesn't have to
      ; be a valid item.
    
      
      ; for the example, we just remove the source, and add the target.
      ItemText$ = GetGadgetItemText(SourceGadget, SourceItem, 0)      
      RemoveGadgetItem(SourceGadget, SourceItem)            
      AddGadgetItem(TargetGadget, TargetItem, ItemText$)
        
    EndIf ; check TargetGadget 
    
  EndIf ; check Message
    
  ProcedureReturn Result
EndProcedure

; ------------------------------------------------------------------
;
; That's all for this example. If you have more questions, feel free
; to post them at http://purebasic.myforums.net/, or send me a mail
; at freak@betriebsdirektor.de
;
;; ------------------------------------------------------------------


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger