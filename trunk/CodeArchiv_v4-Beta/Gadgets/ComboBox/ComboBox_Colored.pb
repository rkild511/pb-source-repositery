; French forum: (http://www.serveurperso.com/~cederavic/forum/)
; Author: Flype (updated for PB4.00 by blbltheworm)
; Date: 07. July 2003
; OS: Windows
; Demo: No

Procedure ComboCallBack( hWnd.l, Message.l, wParam.l, lParam.l ) 

  skin.l = GetWindowLong_( hWnd, #GWL_USERDATA ) 
  Result.l = CallWindowProc_( PeekL(skin+16), hWnd, Message, wParam, lParam ) 
  
  If (Message = #WM_DESTROY) 
    
    DeleteObject_( PeekL(skin+12) ) 
    GlobalFree_( skin ) 
    PostQuitMessage_(0) 
    
  ElseIf (Message = #WM_CTLCOLOREDIT) Or (Message = #WM_CTLCOLORLISTBOX) 
    
    SetTextColor_( wParam, PeekL(skin+0) ) 
    SetBkColor_  ( wParam, PeekL(skin+4) ) 
    SetBkMode_   ( wParam, PeekL(skin+8) ) 
    Result = PeekL(skin+12) 
    
  EndIf 
  
  ProcedureReturn Result 
  
EndProcedure 

;---------------------------------------------------------- 

Procedure.l CustomCombo( id.l, fgColor.l, bgColor.l, brColor.l, mode.l ) 

  skin.l = GlobalAlloc_(#Null,5*4) 
  SetWindowLong_( GadgetID(id), #GWL_USERDATA, skin ) 
  
  PokeL( skin+ 0, fgColor ) 
  PokeL( skin+ 4, bgColor ) 
  PokeL( skin+ 8, mode ) 
  PokeL( skin+12, CreateSolidBrush_( brColor ) ) 
  PokeL( skin+16, SetWindowLong_( GadgetID(id), #GWL_WNDPROC, @ComboCallBack() )) 
  
EndProcedure 

;---------------------------------------------------------- 

OpenWindow( 0, 200,400,200,100, "Colorisation et Callback" , #PB_Window_SystemMenu) 

CreateGadgetList( WindowID( 0) ) 
ComboBoxGadget( 1, 10, 10, 180, 120, #PB_ComboBox_Editable ) 
ComboBoxGadget( 2, 10, 40, 180, 120, #PB_ComboBox_Editable ) 
ComboBoxGadget( 3, 10, 70, 180, 120, #PB_ComboBox_Editable ) 
CustomCombo( 1, $00FFFF, $888888, $000000, #OPAQUE ) 
CustomCombo( 2, $BBFFFF, $AAFFAA, $FFCCCC, #OPAQUE ) 
CustomCombo( 3, $AA0000, $888888, $DDFFFF, #TRANSPARENT ) 

For i=1 To 3 
  AddGadgetItem( i, -1, "une ligne d'exemple" ) 
  AddGadgetItem( i, -1, "et encore une autre" ) 
  AddGadgetItem( i, -1, "une p'tite dernière" ) 
  AddGadgetItem( i, -1, "pour finir..." ) 
Next 

Repeat 
Until WaitWindowEvent() = #PB_Event_CloseWindow 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP