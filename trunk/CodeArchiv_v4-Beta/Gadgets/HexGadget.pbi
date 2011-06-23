; PureBasic IRC Chat 
; Author: pcfreak
; Date: 26. November 2006
; OS: Windows
; Demo: No

; Demonstration of a self-made gadget in PureBasic
; Demonstration eines selbst-erstellten Gadgets in PureBasic

Macro InRect(x,y,a,b,c,d)
 (((x) >= (a)) And ((x) <= (c)) And ((y) >= (b)) And ((y) <= (d)))
 ;x = pos x
 ;y = pos y
 ;a = left
 ;b = top
 ;c = right
 ;d = bottom
EndMacro

Enumeration #WM_USER + 12
 #HEM_SetFont
 #HEM_SetResolution
 #HEM_SetMem
 #HEM_SetReadOnlyHighlight
 #HEM_GetMemAddress
 #HEM_GetMemSize
 #HEM_changedBytes
 #HEM_ResetCaret
EndEnumeration

#HE_RD_Nothing   = %00000000
#HE_RD_All       = %00001111
#HE_RD_Offset    = %00000001
#HE_RD_HexDump   = %00000010
#HE_RD_CharDump  = %00000100
#HE_RD_ResetBack = %00001000

#HE_CF_NoCarret = %000
#HE_CF_HexLN    = %001
#HE_CF_HexHN    = %010
#HE_CF_Char     = %100

#HE_DefaultMemSize = -1 ;Columns * Rows

#HE_CLASS = "HexEdit_TC599"

Declare.l HexEditGadget(hWndParent, X, Y, Width, Height, Columns, Rows, Flags)
Declare.l FreeHexEditGadgetClass()
Declare.l HexEditGadget_Callback(hWnd, Msg, wParam, lParam)
Declare.l HE_SetFont(hWnd, FontID)
Declare.l HE_SetMem(hWnd, mem, offset, len)
Declare.l HE_SetReadOnlyHL(hWnd, flag)
Declare.l HE_GetMemAddress(hWnd)
Declare.l HE_GetMemSize(hWnd)
Declare.l HE_changedBytes(hWnd)

Procedure.l HexEditGadget(hWndParent, X, Y, Width, Height, Columns, Rows, Flags) ;Returns the Handle of the HexEditGadget
 Static initialized = #False
 If initialized = #False
  lpwcx.WNDCLASSEX
  ClassName$ = #HE_CLASS
  With lpwcx
   \cbSize = SizeOf(WNDCLASSEX)
   \style = #CS_GLOBALCLASS|#CS_HREDRAW|#CS_VREDRAW|#CS_DBLCLKS|#CS_SAVEBITS
   \lpfnWndProc = @HexEditGadget_Callback()
   \cbClsExtra = 0
   \cbWndExtra = 0
   \hInstance = #Null
   \hIcon = #Null
   \hCursor = LoadCursor_(#Null, #IDC_ARROW)
   \hbrBackground = GetSysColorBrush_(#COLOR_3DHILIGHT)
   \lpszMenuName = #Null
   \lpszClassName = @ClassName$
   \hIconSm = #Null
  EndWith
  If RegisterClassEx_(@lpwcx)
   initialized = #True
  Else
   ProcedureReturn 0
  EndIf
 EndIf
 hWnd = CreateWindowEx_(0, @ClassName$, "", Flags|#WS_CHILDWINDOW|#WS_VISIBLE, X, Y, Width, Height, hWndParent, #Null, #Null, #Null)
 If hWnd
  SendMessage_(hWnd, #HEM_SetResolution, Columns, Rows)
  UpdateWindow_(hWnd)
 EndIf
 ProcedureReturn hWnd
EndProcedure

Procedure.l FreeHexEditGadgetClass()
 ClassName$ = #HE_CLASS
 ProcedureReturn UnregisterClass_(@ClassName$, #Null)
EndProcedure

Procedure.l HE_SetFont(hWnd, FontID)
 ProcedureReturn SendMessage_(hWnd, #HEM_SetFont, FontID, 0)
EndProcedure

Procedure.l HE_SetMem(hWnd, mem, offset, len)
 Dim mem.l(2)
 mem(0) = mem
 mem(1) = offset
 mem(2) = len
 ProcedureReturn SendMessage_(hWnd, #HEM_SetMem, @mem(), 0)
EndProcedure

Procedure.l HE_SetReadOnlyHL(hWnd, flag)
 ProcedureReturn SendMessage_(hWnd, #HEM_SetReadOnlyHighlight, flag, 0)
EndProcedure

Procedure.l HE_GetMemAddress(hWnd)
 ProcedureReturn SendMessage_(hWnd, #HEM_GetMemAddress, 0, 0)
EndProcedure

Procedure.l HE_GetMemSize(hWnd)
 ProcedureReturn SendMessage_(hWnd, #HEM_GetMemSize, 0, 0)
EndProcedure

Procedure.l HE_changedBytes(hWnd)
 ProcedureReturn SendMessage_(hWnd, #HEM_changedBytes, 0, 0)
EndProcedure

Procedure.l HexEditGadget_Callback(hWnd, Msg, wParam, lParam)
 Structure HexEditGadgetID
  hWnd.l            ;window handle
  hMem.l            ;memory handle/address
  MemOffset.l       ;offset for output, won't be calculated to hMem, just for owner defined display
  MemSize.l         ;memory size
  readOnly.l        ;indicates whether input is allowed or not
  readOnlyHL.l      ;indicates if readonly memory blocks shall be highlighted
  changedBytes.l    ;true if bytes were changed, false else
  Font.l            ;window handle to a font used for text output
  Char.SIZE         ;max size of a character of the used font
  CharSizeChanged.l ;font changed -> max character size changed (for redrawing/calculating)
  Columns.l         ;max number of columns (1 column = 1 byte)
  Rows.l            ;max number of rows
  SelColumn.l       ;selected column
  SelRow.l          ;selected row
  hDC.l             ;handle of the buffered device context, used for graphic output
  BackhDC.l         ;handle of the buffered device context, used to create a background to save cpu at graphic output
  Image.l           ;handle of a compatible bitmap to 'hDC'
  BackImage.l       ;handle of a compatible bitmap to 'BackhDC', used to save the background for faster redraw
  ImageWidth.l      ;width of the client area, used to recreate the compatible bitmap if the window is resized
  ImageHeight.l     ;height of the client area, used to recreate the compatible bitmap if the window is resized
  ReDraw.l          ;flag which indicates what areas needs to be redrawn with the next WM_PAINT call
  LMBdown.l         ;indicates whether the left mouse button was pushed down in the client area or not
                    ;(doesn't receives 'WM_KEYUP' when mouse was moved pressed inside the client area, and relesed there)
  BGBrush.l         ;solid brush for the background, colored with the system color for 'COLOR_3DHILIGHT'
  HLBrush.l         ;solid brush for the highlighted background, colored with the system color for 'COLOR_HIGHLIGHT'
  InputCaret.l      ;handle to the caret for user input
  CaretFlag.l       ;indicates where the caret is placed (hex dump area or character area)
 EndStructure
 Static NewList HexEditorGadget.HexEditGadgetID()

 hWndMatch = #False
 ForEach HexEditorGadget()
  If HexEditorGadget()\hWnd = hWnd : hWndMatch = #True : Break : EndIf
 Next

 Result = 0
 If hWndMatch = #True Or Msg = #WM_CREATE
  Select Msg
   Case #WM_CREATE
    *lpcs.CREATESTRUCT = lParam
    If *lpcs And *lpcs\lpszClass
     If LCase(PeekS(*lpcs\lpszClass)) = LCase(#HE_CLASS)
      AddElement(HexEditorGadget())
      HexEditorGadget()\hWnd = hWnd
      HexEditorGadget()\hMem = #Null
      HexEditorGadget()\MemOffset = 0
      HexEditorGadget()\MemSize = 0
      If *lpcs\style & #ES_READONLY
       HexEditorGadget()\readOnly = #True
      Else
       HexEditorGadget()\readOnly = #False
      EndIf
      HexEditorGadget()\readOnlyHL = #False
      HexEditorGadget()\changedBytes = #False
      HexEditorGadget()\Font = #Null
      HexEditorGadget()\Char\cx = 5
      HexEditorGadget()\Char\cy = 8
      HexEditorGadget()\CharSizeChanged = #True
      HexEditorGadget()\Columns = 16
      HexEditorGadget()\Rows = 32
      HexEditorGadget()\SelColumn = -1
      HexEditorGadget()\SelRow = -1
      HexEditorGadget()\hDC = #Null
      HexEditorGadget()\BackhDC = #Null
      HexEditorGadget()\Image = #Null
      HexEditorGadget()\BackImage = #Null
      HexEditorGadget()\ReDraw = #True
      HexEditorGadget()\LMBdown = #False
      HexEditorGadget()\BGBrush = GetSysColorBrush_(#COLOR_3DHILIGHT)
      HexEditorGadget()\HLBrush = GetSysColorBrush_(#COLOR_HIGHLIGHT)
      HexEditorGadget()\InputCaret = #Null
      HexEditorGadget()\CaretFlag = 0
      EnableWindow_(hWnd, #True)
      Result = 0
     Else
      Result = -1
     EndIf
    Else
     Result = -1
    EndIf
   Case #WM_CLOSE
    Result = CallWindowProc_(@HexEditGadget_Callback(),hWnd,#WM_DESTROY,0,0)
   Case #WM_DESTROY
    If HexEditorGadget()\hDC <> #Null
     DeleteDC_(HexEditorGadget()\hDC)
    EndIf
    If HexEditorGadget()\BackhDC <> #Null
     DeleteDC_(HexEditorGadget()\BackhDC)
    EndIf
    If HexEditorGadget()\Image <> #Null
     DeleteObject_(HexEditorGadget()\Image)
    EndIf
    If HexEditorGadget()\BackImage <> #Null
     DeleteObject_(HexEditorGadget()\BackImage)
    EndIf
    If HexEditorGadget()\BGBrush
     DeleteObject_(HexEditorGadget()\BGBrush)
    EndIf
    If HexEditorGadget()\HLBrush
     DeleteObject_(HexEditorGadget()\HLBrush)
    EndIf
    If HexEditorGadget()\InputCaret
     DestroyCaret_()
    EndIf
    DeleteElement(HexEditorGadget())
    Result = 0
   Case #WM_PAINT
    hDC = BeginPaint_(hWnd, @lpPaint.PAINTSTRUCT)
    If hDC
      If HexEditorGadget()\hDC = #Null
       HexEditorGadget()\hDC = CreateCompatibleDC_(hDC)
      Else
       DeleteDC_(HexEditorGadget()\hDC)
       HexEditorGadget()\hDC = CreateCompatibleDC_(hDC)
      EndIf
      If HexEditorGadget()\BackhDC = #Null
       HexEditorGadget()\BackhDC = CreateCompatibleDC_(hDC)
      Else
       DeleteDC_(HexEditorGadget()\BackhDC)
       HexEditorGadget()\BackhDC = CreateCompatibleDC_(hDC)
      EndIf
      ;================================================================================
      If HexEditorGadget()\BackhDC <> #Null And HexEditorGadget()\ReDraw <> #HE_RD_Nothing
       GetClientRect_(hWnd, @childRect.RECT)
       imgWidth  = childRect\right-childRect\left
       imgHeight = childRect\bottom-childRect\top
       If HexEditorGadget()\ImageWidth <> imgWidth Or HexEditorGadget()\ImageHeight <> imgHeight
        If HexEditorGadget()\Image
         DeleteObject_(HexEditorGadget()\Image)
         HexEditorGadget()\Image = #Null
        EndIf
        If HexEditorGadget()\BackImage
         DeleteObject_(HexEditorGadget()\BackImage)
         HexEditorGadget()\BackImage = #Null
        EndIf
        HexEditorGadget()\Image = CreateCompatibleBitmap_(hDC,imgWidth,imgHeight)
        HexEditorGadget()\ImageWidth  = imgWidth
        HexEditorGadget()\ImageHeight = imgHeight
        HexEditorGadget()\ReDraw | #HE_RD_ResetBack
       EndIf
       If HexEditorGadget()\CharSizeChanged = #True
        HexEditorGadget()\ReDraw | #HE_RD_ResetBack
       EndIf
       ;================================================================================
       If HexEditorGadget()\ReDraw & #HE_RD_ResetBack
        If HexEditorGadget()\BackImage = #Null
         HexEditorGadget()\BackImage = CreateCompatibleBitmap_(hDC,HexEditorGadget()\ImageWidth,HexEditorGadget()\ImageHeight)
        EndIf
        SelectObject_(HexEditorGadget()\BackhDC, HexEditorGadget()\BackImage)
        If HexEditorGadget()\Font
         SelectObject_(HexEditorGadget()\BackhDC, HexEditorGadget()\Font)
        EndIf
        HexEditorGadget()\Char\cx = 0
        HexEditorGadget()\Char\cy = 0
        If GetTextMetrics_(HexEditorGadget()\BackhDC, @lptm.TEXTMETRIC)
         HexEditorGadget()\Char\cx = lptm\tmMaxCharWidth
         HexEditorGadget()\Char\cy = lptm\tmHeight
         HexEditorGadget()\CharSizeChanged = #False
        EndIf
        GetClientRect_(hWnd, @childRect.RECT)
        sep1x = childRect\left + (8 * HexEditorGadget()\Char\cx) + 5
        sep2x = childRect\left + (8 * HexEditorGadget()\Char\cx) + (2 * HexEditorGadget()\Columns * HexEditorGadget()\Char\cx) + (3 * (HexEditorGadget()\Columns - 1)) + 11
        ;Draw Background and Frame
        FillRect_(HexEditorGadget()\BackhDC, @childRect, HexEditorGadget()\BGBrush)
        DrawEdge_(HexEditorGadget()\BackhDC, @childRect, #BDR_SUNKEN, #BF_RECT)
        ;Clip Frameborder
        GetClientRect_(hWnd, @childRect.RECT)
        With childRect
         \top + 2
         \bottom - 2
         \left + 2
         \right - 2
        EndWith
        ClippingRgn = CreateRectRgnIndirect_(@childRect)
        SelectObject_(HexEditorGadget()\BackhDC, ClippingRgn)
        ;Draw Offset/HexDump Seperator
        MoveToEx_(HexEditorGadget()\BackhDC, sep1x, childRect\top, #Null)
        LineTo_(HexEditorGadget()\BackhDC, sep1x, childRect\bottom)
        ;Draw HexDump/CharDump Seperator
        MoveToEx_(HexEditorGadget()\BackhDC, sep2x, childRect\top, #Null)
        LineTo_(HexEditorGadget()\BackhDC, sep2x, childRect\bottom)
        ;No Backgroundcolor when drawing text
        ;SetBkMode_(HexEditorGadget()\BackhDC, #TRANSPARENT)
        ;Output HexData
        If HexEditorGadget()\hMem
         If IsBadReadPtr_(HexEditorGadget()\hMem, HexEditorGadget()\MemSize) = #False
          For a = 0 To HexEditorGadget()\MemSize - 1
           *adr.BYTE = HexEditorGadget()\hMem + a
           If a > HexEditorGadget()\Columns * HexEditorGadget()\Rows
            Break
           EndIf
           Column = a % HexEditorGadget()\Columns
           Row = a / HexEditorGadget()\Columns
           ;Draw Offset
           ;-----------------------------------------------------------
           If Column = 0
            ColumnRect.RECT
            With ColumnRect
             \top    = childRect\top + (Row * HexEditorGadget()\Char\cy)
             \bottom = childRect\top + (Row * HexEditorGadget()\Char\cy) + HexEditorGadget()\Char\cy
             \left   = childRect\left
             \right  = childRect\left + (8 * HexEditorGadget()\Char\cx) + 2
            EndWith
            Text$ = RSet(Hex(HexEditorGadget()\MemOffset + a),8,"0")
            yOffset = childRect\top + (Row * HexEditorGadget()\Char\cy)
            CharRect.RECT
            For index = 0 To Len(Text$) - 1
             xOffset = childRect\left + (index * HexEditorGadget()\Char\cx)
             With CharRect
              \top    = yOffset
              \bottom = yOffset + HexEditorGadget()\Char\cy
              \left   = xOffset
              \right  = xOffset + HexEditorGadget()\Char\cx
             EndWith
             Char$ = Mid(Text$,index + 1,1)
             DrawText_(HexEditorGadget()\BackhDC, @Char$, Len(Char$), @CharRect, #DT_SINGLELINE|#DT_RIGHT|#DT_BOTTOM)
            Next
           EndIf
           If HexEditorGadget()\readOnlyHL = #True And IsBadWritePtr_(*adr, 1) = #True
            SetTextColor_(HexEditorGadget()\BackhDC, $0000FF)
           EndIf
           ;Draw Hex Value
           ;-----------------------------------------------------------
           Text$ = RSet(Hex(*adr\b&$FF),2,"0")
           xOffset = sep1x + (2 * Column * HexEditorGadget()\Char\cx) + (3 * Column) + 3
           yOffset = childRect\top + (Row * HexEditorGadget()\Char\cy)
           ;Draw Left Side of the Byte
           ByteRect.RECT
           With ByteRect
            \top    = yOffset
            \bottom = yOffset + HexEditorGadget()\Char\cy
            \left   = xOffset
            \right  = xOffset + HexEditorGadget()\Char\cx
           EndWith
           HiByte$ = Left(Text$,1)
           DrawText_(HexEditorGadget()\BackhDC, @HiByte$, Len(HiByte$), @ByteRect, #DT_SINGLELINE|#DT_RIGHT|#DT_BOTTOM)
           ;Draw Right Side of the Byte
           With ByteRect
            \top    = yOffset
            \bottom = yOffset + HexEditorGadget()\Char\cy
            \left   = xOffset + HexEditorGadget()\Char\cx
            \right  = xOffset + (2 * HexEditorGadget()\Char\cx)
           EndWith
           LowByte$ = Right(Text$,1)
           DrawText_(HexEditorGadget()\BackhDC, @LowByte$, Len(LowByte$), @ByteRect, #DT_SINGLELINE|#DT_RIGHT|#DT_BOTTOM)
           ;Draw Character
           ;-----------------------------------------------------------
           xOffset = sep2x + (Column * HexEditorGadget()\Char\cx) + 3
           yOffset = childRect\top + (Row * HexEditorGadget()\Char\cy)
           With ByteRect
            \top    = yOffset
            \bottom = yOffset + HexEditorGadget()\Char\cy
            \left   = xOffset
            \right  = xOffset + HexEditorGadget()\Char\cx
           EndWith
           value = *adr\b & $FF
           Select value
            Case 0
             value = '.'
            Case 9
             value = '.'
            Case 10
             value = '.'
            Case 11
             value = '.'
            Case 12
             value = '.'
            Case 13
             value = '.'
            Case 127
             value = '.'
           EndSelect
           Text$ = Chr(value)
           DrawText_(HexEditorGadget()\BackhDC, @Text$, Len(Text$), @ByteRect, #DT_SINGLELINE|#DT_RIGHT|#DT_BOTTOM)
           SetTextColor_(HexEditorGadget()\BackhDC, $000000)
          Next
         EndIf
        EndIf
        DeleteObject_(ClippingRgn)
       EndIf
       ;================================================================================
       If HexEditorGadget()\hDC <> #Null And HexEditorGadget()\ReDraw <> #HE_RD_Nothing
        HexEditorGadget()\ReDraw = HexEditorGadget()\ReDraw & (~(#HE_RD_ResetBack))
        SelectObject_(HexEditorGadget()\hDC, HexEditorGadget()\Image)
        If HexEditorGadget()\Font
         SelectObject_(HexEditorGadget()\hDC, HexEditorGadget()\Font)
        EndIf
        SelectObject_(HexEditorGadget()\BackhDC, HexEditorGadget()\BackImage)
        GetClientRect_(hWnd, @childRect.RECT)
        sep1x = childRect\left + (8 * HexEditorGadget()\Char\cx) + 5
        sep2x = childRect\left + (8 * HexEditorGadget()\Char\cx) + (2 * HexEditorGadget()\Columns * HexEditorGadget()\Char\cx) + (3 * (HexEditorGadget()\Columns - 1)) + 11
        If HexEditorGadget()\ReDraw | #HE_RD_ResetBack = #HE_RD_All
         BitBlt_(HexEditorGadget()\hDC,childRect\left,childRect\top,childRect\right,childRect\bottom,HexEditorGadget()\BackhDC,childRect\left,childRect\top,#SRCCOPY)
        ElseIf HexEditorGadget()\ReDraw = #HE_RD_Offset
         childRect\right = sep1x
         BitBlt_(HexEditorGadget()\hDC,childRect\left,childRect\top,childRect\right,childRect\bottom,HexEditorGadget()\BackhDC,childRect\left,childRect\top,#SRCCOPY)
        ElseIf HexEditorGadget()\ReDraw = #HE_RD_HexDump
         childRect\left  = sep1x
         childRect\right = sep2x
         BitBlt_(HexEditorGadget()\hDC,childRect\left,childRect\top,childRect\right,childRect\bottom,HexEditorGadget()\BackhDC,childRect\left,childRect\top,#SRCCOPY)
        ElseIf HexEditorGadget()\ReDraw = #HE_RD_CharDump
         childRect\left  = sep2x
         BitBlt_(HexEditorGadget()\hDC,childRect\left,childRect\top,childRect\right,childRect\bottom,HexEditorGadget()\BackhDC,childRect\left,childRect\top,#SRCCOPY)
        ElseIf HexEditorGadget()\ReDraw = #HE_RD_Offset | #HE_RD_HexDump
         childRect\right = sep2x
         BitBlt_(HexEditorGadget()\hDC,childRect\left,childRect\top,childRect\right,childRect\bottom,HexEditorGadget()\BackhDC,childRect\left,childRect\top,#SRCCOPY)
        ElseIf HexEditorGadget()\ReDraw = #HE_RD_HexDump | #HE_RD_CharDump
         childRect\left = sep1x
         BitBlt_(HexEditorGadget()\hDC,childRect\left,childRect\top,childRect\right,childRect\bottom,HexEditorGadget()\BackhDC,childRect\left,childRect\top,#SRCCOPY)
        ElseIf HexEditorGadget()\ReDraw = #HE_RD_Offset | #HE_RD_CharDump
         left = childRect\left
         childRect\left = sep2x
         BitBlt_(HexEditorGadget()\hDC,childRect\left,childRect\top,childRect\right,childRect\bottom,HexEditorGadget()\BackhDC,childRect\left,childRect\top,#SRCCOPY)
         childRect\left = left
         childRect\right = sep1x
         BitBlt_(HexEditorGadget()\hDC,childRect\left,childRect\top,childRect\right,childRect\bottom,HexEditorGadget()\BackhDC,childRect\left,childRect\top,#SRCCOPY)
        EndIf
        With childRect
         \top + 2
         \bottom - 2
         \left + 2
         \right - 2
        EndWith
        SetBkColor_(HexEditorGadget()\hDC, GetSysColor_(#COLOR_HIGHLIGHT))
        SetTextColor_(HexEditorGadget()\hDC, GetSysColor_(#COLOR_HIGHLIGHTTEXT))
        Offset = (HexEditorGadget()\Columns * HexEditorGadget()\SelRow) + HexEditorGadget()\SelColumn
        If IsBadReadPtr_(HexEditorGadget()\hMem, HexEditorGadget()\MemSize) = #False
         *adr.BYTE = HexEditorGadget()\hMem + Offset
         ;Draw Selected Offset
         ;-----------------------------------------------------------
         If HexEditorGadget()\SelRow <> -1 And HexEditorGadget()\ReDraw & #HE_RD_Offset
          ColumnRect.RECT
          With ColumnRect
           \top    = childRect\top + (HexEditorGadget()\SelRow * HexEditorGadget()\Char\cy)
           \bottom = childRect\top + (HexEditorGadget()\SelRow * HexEditorGadget()\Char\cy) + HexEditorGadget()\Char\cy
           \left   = childRect\left
           \right  = childRect\left + (8 * HexEditorGadget()\Char\cx) + 2
          EndWith
          FillRect_(HexEditorGadget()\hDC, @ColumnRect,HexEditorGadget()\HLBrush)
          Offset = HexEditorGadget()\Columns * HexEditorGadget()\SelRow
          Text$ = RSet(Hex(HexEditorGadget()\MemOffset + Offset),8,"0")
          yOffset = childRect\top + (HexEditorGadget()\SelRow * HexEditorGadget()\Char\cy)
          CharRect.RECT
          For index = 0 To Len(Text$) - 1
           xOffset = childRect\left + (index * HexEditorGadget()\Char\cx)
           With CharRect
            \top    = yOffset
            \bottom = yOffset + HexEditorGadget()\Char\cy
            \left   = xOffset
            \right  = xOffset + HexEditorGadget()\Char\cx
           EndWith
           Char$ = Mid(Text$,index + 1,1)
           DrawText_(HexEditorGadget()\hDC, @Char$, Len(Char$), @CharRect, #DT_SINGLELINE|#DT_RIGHT|#DT_BOTTOM)
          Next
         EndIf
        EndIf
        If IsBadReadPtr_(HexEditorGadget()\hMem, HexEditorGadget()\MemSize) = #False And Offset >= 0
         ;Draw Hex Value
         ;-----------------------------------------------------------
         If HexEditorGadget()\SelRow <> -1 And HexEditorGadget()\SelColumn <> -1 And HexEditorGadget()\ReDraw & #HE_RD_HexDump
          Text$ = RSet(Hex(*adr\b&$FF),2,"0")
          xOffset = sep1x + (2 * HexEditorGadget()\SelColumn * HexEditorGadget()\Char\cx) + (3 * HexEditorGadget()\SelColumn) + 3
          yOffset = childRect\top + (HexEditorGadget()\SelRow * HexEditorGadget()\Char\cy)
          ;Draw Left Side of the Byte
          ByteRect.RECT
          With ByteRect
           \top    = yOffset
           \bottom = yOffset + HexEditorGadget()\Char\cy
           \left   = xOffset
           \right  = xOffset + HexEditorGadget()\Char\cx
          EndWith
          HiByte$ = Left(Text$,1)
          DrawText_(HexEditorGadget()\hDC, @HiByte$, Len(HiByte$), @ByteRect, #DT_SINGLELINE|#DT_RIGHT|#DT_BOTTOM)
          ;Draw Right Side of the Byte
          With ByteRect
           \top    = yOffset
           \bottom = yOffset + HexEditorGadget()\Char\cy
           \left   = xOffset + HexEditorGadget()\Char\cx
           \right  = xOffset + (2 * HexEditorGadget()\Char\cx)
          EndWith
          LowByte$ = Right(Text$,1)
          DrawText_(HexEditorGadget()\hDC, @LowByte$, Len(LowByte$), @ByteRect, #DT_SINGLELINE|#DT_RIGHT|#DT_BOTTOM)
         EndIf
         ;Draw Character
         ;-----------------------------------------------------------
         If HexEditorGadget()\SelRow <> -1 And HexEditorGadget()\SelColumn <> -1 And HexEditorGadget()\ReDraw & #HE_RD_CharDump
          xOffset = sep2x + (HexEditorGadget()\SelColumn * HexEditorGadget()\Char\cx) + 3
          yOffset = childRect\top + (HexEditorGadget()\SelRow * HexEditorGadget()\Char\cy)
          With ByteRect
           \top    = yOffset
           \bottom = yOffset + HexEditorGadget()\Char\cy
           \left   = xOffset
           \right  = xOffset + HexEditorGadget()\Char\cx
          EndWith
          value = *adr\b & $FF
          Select value
           Case 0
            value = '.'
           Case 9
            value = '.'
           Case 10
            value = '.'
           Case 11
            value = '.'
           Case 12
            value = '.'
           Case 13
            value = '.'
           Case 127
            value = '.'
          EndSelect
          Text$ = Chr(value)
          DrawText_(HexEditorGadget()\hDC, @Text$, Len(Text$), @ByteRect, #DT_SINGLELINE|#DT_RIGHT|#DT_BOTTOM)
         EndIf
        EndIf
       EndIf
       ;================================================================================
      EndIf
      BitBlt_(hDC,lpPaint\rcPaint\left,lpPaint\rcPaint\top,lpPaint\rcPaint\right,lpPaint\rcPaint\bottom,HexEditorGadget()\hDC,lpPaint\rcPaint\left,lpPaint\rcPaint\top,#SRCCOPY)
      HexEditorGadget()\ReDraw = #HE_RD_Nothing
     EndPaint_(hWnd,@lpPaint)
    EndIf
    Result = 0
   Case #WM_ERASEBKGND
    HexEditorGadget()\ReDraw = HexEditorGadget()\ReDraw |(#HE_RD_All & (~(#HE_RD_ResetBack)))
    Result = -1
   Case #WM_LBUTTONDOWN
    SetFocus_(hWnd)
    HexEditorGadget()\LMBdown = #True
    Result = 0
   Case #WM_LBUTTONUP
    If HexEditorGadget()\LMBdown = #True
     SetFocus_(hWnd)
    EndIf
    If HexEditorGadget()\LMBdown = #True And IsBadReadPtr_(HexEditorGadget()\hMem, HexEditorGadget()\MemSize) = #False
     xPos = lParam & $FFFF - 2
     !SHR dword [p.v_lParam], 16
     yPos = lParam & $FFFF - 2
     GetClientRect_(hWnd, @childRect)
     sep1x = childRect\left + (8 * HexEditorGadget()\Char\cx) + 5
     sep2x = childRect\left + (8 * HexEditorGadget()\Char\cx) + (2 * HexEditorGadget()\Columns * HexEditorGadget()\Char\cx) + (3 * (HexEditorGadget()\Columns - 1)) + 11
     With childRect
      \bottom = childRect\top + (HexEditorGadget()\Char\cy * HexEditorGadget()\Rows) - 4
      \left   = sep1x + 1
      \right  = sep2x - 4
     EndWith
     HexEditorGadget()\CaretFlag = #HE_CF_NoCarret
     If InRect(xPos, yPos, childRect\left, childRect\top, childRect\right, childRect\bottom) ;HexDump Area
      newValueX = (xPos - (8 * HexEditorGadget()\Char\cx) - 8) / ((2 * HexEditorGadget()\Char\cx) + 3)
      HexEditorGadget()\CaretFlag = #HE_CF_HexHN
     Else
      GetClientRect_(hWnd, @childRect.RECT)
      With childRect
       \bottom = childRect\top + (HexEditorGadget()\Char\cy * HexEditorGadget()\Rows) - 4
       \left   = sep2x + 1
       \right  = \left + (HexEditorGadget()\Char\cx * HexEditorGadget()\Columns) - 1
      EndWith
      If InRect(xPos, yPos, childRect\left, childRect\top, childRect\right, childRect\bottom) ;CharDump Area
       newValueX = (xPos - sep2x) / HexEditorGadget()\Char\cx
       HexEditorGadget()\CaretFlag = #HE_CF_Char
      Else
       newValueX = -1
      EndIf
     EndIf
     GetClientRect_(hWnd, @childRect.RECT)
     With childRect
      \bottom = childRect\top + (HexEditorGadget()\Char\cy * HexEditorGadget()\Rows) - 4
     EndWith
     If InRect(xPos, yPos, childRect\left, childRect\top, childRect\right, childRect\bottom) ;Offset Area
      newValueY = yPos / HexEditorGadget()\Char\cy
     Else
      newValueY = -1
     EndIf
     If newValueX >= HexEditorGadget()\Columns : newValueX = HexEditorGadget()\Columns - 1 : EndIf
     If newValueY >= HexEditorGadget()\Rows : newValueY = HexEditorGadget()\Rows - 1 : EndIf
     If (newValueY * HexEditorGadget()\Columns) + newValueX >= HexEditorGadget()\MemSize : newValueX = -1 : newValueY = -1 : EndIf
     refreshWnd = #False
     If newValueX <> HexEditorGadget()\SelColumn Or newValueY <> HexEditorGadget()\SelRow
      HexEditorGadget()\SelRow = newValueY
      HexEditorGadget()\SelColumn = newValueX
      HexEditorGadget()\ReDraw | #HE_RD_Offset | #HE_RD_HexDump | #HE_RD_CharDump
      refreshWnd = #True
     EndIf
     If refreshWnd = #True
      InvalidateRect_(hWnd, 0, #False)
     EndIf
     SendMessage_(hWnd, #HEM_ResetCaret, 0, 0)
    EndIf
    HexEditorGadget()\LMBdown = #False
    Result = 0
   Case #WM_KEYDOWN
    If IsBadReadPtr_(HexEditorGadget()\hMem, HexEditorGadget()\MemSize) = #False
     Refresh = #False
     If HexEditorGadget()\readOnly = #True
      HexEditorGadget()\CaretFlag = #HE_CF_Char
     EndIf
     Select wParam
      Case #VK_RIGHT
       Select HexEditorGadget()\CaretFlag
        Case #HE_CF_HexLN
         If (HexEditorGadget()\SelRow * HexEditorGadget()\Columns) + HexEditorGadget()\SelColumn + 1 < HexEditorGadget()\MemSize
          If HexEditorGadget()\SelColumn >= HexEditorGadget()\Columns - 1
           HexEditorGadget()\SelColumn = 0
           HexEditorGadget()\SelRow + 1
           HexEditorGadget()\CaretFlag = #HE_CF_HexHN
          Else
           HexEditorGadget()\SelColumn + 1
           HexEditorGadget()\CaretFlag = #HE_CF_HexHN
          EndIf
         EndIf
         Refresh = #True
        Case #HE_CF_HexHN
         HexEditorGadget()\CaretFlag = #HE_CF_HexLN
         Refresh = #True
        Case #HE_CF_Char
         If (HexEditorGadget()\SelRow * HexEditorGadget()\Columns) + HexEditorGadget()\SelColumn + 1 < HexEditorGadget()\MemSize
          If HexEditorGadget()\SelColumn >= HexEditorGadget()\Columns - 1
           HexEditorGadget()\SelColumn = 0
           HexEditorGadget()\SelRow + 1
          Else
           HexEditorGadget()\SelColumn + 1
          EndIf
         EndIf
         Refresh = #True
       EndSelect
      Case #VK_LEFT
       Select HexEditorGadget()\CaretFlag
        Case #HE_CF_HexLN
         HexEditorGadget()\CaretFlag = #HE_CF_HexHN
         Refresh = #True
        Case #HE_CF_HexHN
         If (HexEditorGadget()\SelRow * HexEditorGadget()\Columns) + HexEditorGadget()\SelColumn > 0
          If HexEditorGadget()\SelColumn = 0
           HexEditorGadget()\SelColumn = HexEditorGadget()\Columns - 1
           HexEditorGadget()\SelRow - 1
           HexEditorGadget()\CaretFlag = #HE_CF_HexLN
          Else
           HexEditorGadget()\SelColumn - 1
           HexEditorGadget()\CaretFlag = #HE_CF_HexLN
          EndIf
         EndIf
         Refresh = #True
        Case #HE_CF_Char
         If (HexEditorGadget()\SelRow * HexEditorGadget()\Columns) + HexEditorGadget()\SelColumn > 0
          If HexEditorGadget()\SelColumn = 0
           HexEditorGadget()\SelColumn = HexEditorGadget()\Columns - 1
           HexEditorGadget()\SelRow - 1
          Else
           HexEditorGadget()\SelColumn - 1
          EndIf
         EndIf
         Refresh = #True
       EndSelect
      Case #VK_UP
       Select HexEditorGadget()\CaretFlag
        Case #HE_CF_HexLN, #HE_CF_HexHN, #HE_CF_Char
         If HexEditorGadget()\SelRow > 0
          HexEditorGadget()\SelRow - 1
         EndIf
         Refresh = #True
       EndSelect
      Case #VK_DOWN
       Select HexEditorGadget()\CaretFlag
        Case #HE_CF_HexLN, #HE_CF_HexHN, #HE_CF_Char
         If ((HexEditorGadget()\SelRow + 1) * HexEditorGadget()\Columns) + HexEditorGadget()\SelColumn < HexEditorGadget()\MemSize
          HexEditorGadget()\SelRow + 1
         EndIf
         Refresh = #True
       EndSelect
      Case #VK_HOME
       Select HexEditorGadget()\CaretFlag
        Case #HE_CF_HexLN, #HE_CF_HexHN, #HE_CF_Char
         If HexEditorGadget()\CaretFlag = #HE_CF_HexLN
          HexEditorGadget()\CaretFlag = #HE_CF_HexHN
         EndIf
         HexEditorGadget()\SelColumn = 0
         HexEditorGadget()\SelRow = 0
         Refresh = #True
       EndSelect
      Case #VK_END
       Select HexEditorGadget()\CaretFlag
        Case #HE_CF_HexLN, #HE_CF_HexHN, #HE_CF_Char
         If HexEditorGadget()\CaretFlag = #HE_CF_HexLN
          HexEditorGadget()\CaretFlag = #HE_CF_HexHN
         EndIf
         HexEditorGadget()\SelColumn = (HexEditorGadget()\MemSize - 1) % HexEditorGadget()\Columns
         HexEditorGadget()\SelRow = (HexEditorGadget()\MemSize - 1) / HexEditorGadget()\Columns
         Refresh = #True
       EndSelect
     EndSelect
     If Refresh = #True
      HexEditorGadget()\ReDraw | #HE_RD_Offset | #HE_RD_HexDump | #HE_RD_CharDump
      InvalidateRect_(hWnd, 0, #False)
      SendMessage_(hWnd, #HEM_ResetCaret, 0, 0)
     EndIf
    EndIf
    Result = 0
   Case #WM_KEYUP
    Offset = (HexEditorGadget()\Columns * HexEditorGadget()\SelRow) + HexEditorGadget()\SelColumn
    *adr.BYTE = HexEditorGadget()\hMem + Offset
    If IsBadWritePtr_(*adr, 1) = #False And HexEditorGadget()\readOnly = #False
     Refresh = #False
     Select wParam
      Case #VK_BACK
       Select HexEditorGadget()\CaretFlag
        Case #HE_CF_HexLN
         HexEditorGadget()\CaretFlag = #HE_CF_HexHN
         *adr\b & $0F
         HexEditorGadget()\changedBytes = #True
         Refresh = #True
        Case #HE_CF_HexHN
         *adr - 1
         If Offset > 0 And IsBadWritePtr_(*adr, 1) = #False
          If HexEditorGadget()\SelColumn = 0
           HexEditorGadget()\SelColumn = HexEditorGadget()\Columns - 1
           HexEditorGadget()\SelRow - 1
           HexEditorGadget()\CaretFlag = #HE_CF_HexLN
          Else
           HexEditorGadget()\SelColumn - 1
           HexEditorGadget()\CaretFlag = #HE_CF_HexLN
          EndIf
          *adr\b & $F0
          HexEditorGadget()\changedBytes = #True
         EndIf
         Refresh = #True
        Case #HE_CF_Char
         *adr - 1
         If Offset > 0 And IsBadWritePtr_(*adr, 1) = #False
          If HexEditorGadget()\SelColumn = 0
           HexEditorGadget()\SelColumn = HexEditorGadget()\Columns - 1
           HexEditorGadget()\SelRow - 1
          Else
           HexEditorGadget()\SelColumn - 1
          EndIf
          *adr\b = 0
          HexEditorGadget()\changedBytes = #True
         EndIf
         Refresh = #True
       EndSelect
      Case #VK_DELETE
       Select HexEditorGadget()\CaretFlag
        Case #HE_CF_HexLN
         *adr\b & $F0
         HexEditorGadget()\changedBytes = #True
         If Offset + 1 < HexEditorGadget()\MemSize
          If HexEditorGadget()\SelColumn >= HexEditorGadget()\Columns - 1
           HexEditorGadget()\SelColumn = 0
           HexEditorGadget()\SelRow + 1
           HexEditorGadget()\CaretFlag = #HE_CF_HexHN
          Else
           HexEditorGadget()\SelColumn + 1
           HexEditorGadget()\CaretFlag = #HE_CF_HexHN
          EndIf
         EndIf
         Refresh = #True
        Case #HE_CF_HexHN
         *adr\b & $0F
         HexEditorGadget()\changedBytes = #True
         HexEditorGadget()\CaretFlag = #HE_CF_HexLN
         Refresh = #True
        Case #HE_CF_Char
         *adr\b = 0
         HexEditorGadget()\changedBytes = #True
         If Offset + 1 < HexEditorGadget()\MemSize
          If HexEditorGadget()\SelColumn >= HexEditorGadget()\Columns - 1
           HexEditorGadget()\SelColumn = 0
           HexEditorGadget()\SelRow + 1
          Else
           HexEditorGadget()\SelColumn + 1
          EndIf
         EndIf
         Refresh = #True
       EndSelect
     EndSelect
     If Refresh = #True
      HexEditorGadget()\ReDraw =  #HE_RD_All
      InvalidateRect_(hWnd, 0, #False)
      SendMessage_(hWnd, #HEM_ResetCaret, 0, 0)
     EndIf
    EndIf
    If IsBadReadPtr_(HexEditorGadget()\hMem, HexEditorGadget()\MemSize) = #False And wParam = #VK_TAB
     Select HexEditorGadget()\CaretFlag 
      Case #HE_CF_HexLN, #HE_CF_HexHN
       HexEditorGadget()\CaretFlag = #HE_CF_Char
       Refresh = #True
      Case #HE_CF_Char
       HexEditorGadget()\CaretFlag = #HE_CF_HexHN
       Refresh = #True
     EndSelect
     SendMessage_(hWnd, #HEM_ResetCaret, 0, 0)
    EndIf
    Result = 0
   Case #WM_CHAR
    Offset = (HexEditorGadget()\Columns * HexEditorGadget()\SelRow) + HexEditorGadget()\SelColumn
    *adr.BYTE = HexEditorGadget()\hMem + Offset
    If IsBadWritePtr_(*adr, 1) = #False And HexEditorGadget()\readOnly = #False
     Refresh = #False
     Select wParam
      Case '0' To '9', 'a' To 'f', 'A' To 'F'
       Select HexEditorGadget()\CaretFlag
        Case #HE_CF_HexLN
         If wParam < 'A'
          *adr\b & $F0 | (wParam - '0')
         ElseIf wParam < 'a'
          *adr\b & $F0 | (wParam - 'A' + 10)
         Else
          *adr\b & $F0 | (wParam - 'a' + 10)
         EndIf
         HexEditorGadget()\changedBytes = #True
         If Offset + 1 < HexEditorGadget()\MemSize
          If HexEditorGadget()\SelColumn >= HexEditorGadget()\Columns - 1
           HexEditorGadget()\SelColumn = 0
           HexEditorGadget()\SelRow + 1
           HexEditorGadget()\CaretFlag = #HE_CF_HexHN
          Else
           HexEditorGadget()\SelColumn + 1
           HexEditorGadget()\CaretFlag = #HE_CF_HexHN
          EndIf
         EndIf
         Refresh = #True
        Case #HE_CF_HexHN
         If wParam < 'A'
          *adr\b & $0F | ((wParam - '0') << 4)
         ElseIf wParam < 'a'
          *adr\b & $0F | ((wParam - 'A' + 10) << 4)
         Else
          *adr\b & $0F | ((wParam - 'a' + 10) << 4)
         EndIf
         HexEditorGadget()\changedBytes = #True
         HexEditorGadget()\CaretFlag = #HE_CF_HexLN
         Refresh = #True
        Case #HE_CF_Char
         *adr\b = wParam
         HexEditorGadget()\changedBytes = #True
         If Offset + 1 < HexEditorGadget()\MemSize
          If HexEditorGadget()\SelColumn >= HexEditorGadget()\Columns - 1
           HexEditorGadget()\SelColumn = 0
           HexEditorGadget()\SelRow + 1
          Else
           HexEditorGadget()\SelColumn + 1
          EndIf
         EndIf
         Refresh = #True
       EndSelect
      Default
       If HexEditorGadget()\CaretFlag = #HE_CF_Char And wParam <> 8
        *adr\b = wParam
        HexEditorGadget()\changedBytes = #True
        If Offset + 1 < HexEditorGadget()\MemSize
         If HexEditorGadget()\SelColumn >= HexEditorGadget()\Columns - 1
          HexEditorGadget()\SelColumn = 0
          HexEditorGadget()\SelRow + 1
         Else
          HexEditorGadget()\SelColumn + 1
         EndIf
        EndIf
        Refresh = #True
       EndIf
     EndSelect
     If Refresh = #True
      HexEditorGadget()\ReDraw =  #HE_RD_All
      InvalidateRect_(hWnd, 0, #False)
      SendMessage_(hWnd, #HEM_ResetCaret, 0, 0)
     EndIf
    EndIf
    Result = 0
   Case #WM_SETFOCUS
    ShowCaret_(hWnd)
    Result = 0
   Case #WM_KILLFOCUS
    HideCaret_(hWnd)
    Result = 0
   Case #HEM_SetResolution
    HexEditorGadget()\Columns = wParam
    HexEditorGadget()\Rows = lParam
    DestroyCaret_()
    HexEditorGadget()\InputCaret = #Null
    HexEditorGadget()\ReDraw = #HE_RD_All
    InvalidateRect_(hWnd, 0, #True)
   Case #HEM_SetFont
    HexEditorGadget()\Font = wParam
    HexEditorGadget()\CharSizeChanged = #True
    DestroyCaret_()
    HexEditorGadget()\InputCaret = #Null
    HexEditorGadget()\ReDraw = #HE_RD_All
    InvalidateRect_(hWnd, 0, #True)
   Case #HEM_SetMem
    If wParam
     If PeekL(wParam) = -1
      HexEditorGadget()\hMem = 0
      HexEditorGadget()\MemOffset = 0
      HexEditorGadget()\MemSize = 0
     Else
      HexEditorGadget()\hMem = PeekL(wParam)
      HexEditorGadget()\changedBytes = #True
      HexEditorGadget()\MemOffset = PeekL(wParam+4)
      len = PeekL(wParam+8)
      If len = #HE_DefaultMemSize
       HexEditorGadget()\MemSize = HexEditorGadget()\Columns * HexEditorGadget()\Rows
      ElseIf len < 1
       HexEditorGadget()\hMem = #Null
       HexEditorGadget()\changedBytes = #False
       HexEditorGadget()\MemSize = 0
      Else
       HexEditorGadget()\MemSize = len
      EndIf
      SendMessage_(hWnd, #HEM_ResetCaret, 0, 0)
     EndIf
     HexEditorGadget()\ReDraw = #HE_RD_All
     InvalidateRect_(hWnd, 0, #True)
    EndIf
   Case #HEM_SetReadOnlyHighlight
    Result = HexEditorGadget()\readOnlyHL
    HexEditorGadget()\readOnlyHL = wParam
   Case #HEM_GetMemAddress
    Result = HexEditorGadget()\hMem
   Case #HEM_GetMemSize
    Result = HexEditorGadget()\MemSize
   Case #HEM_changedBytes
    Result = HexEditorGadget()\changedBytes
   Case #HEM_ResetCaret
    If HexEditorGadget()\readOnly = #False And HexEditorGadget()\SelColumn <> -1 And HexEditorGadget()\SelRow <> -1 And HexEditorGadget()\CaretFlag <> #HE_CF_NoCarret And IsBadReadPtr_(HexEditorGadget()\hMem, HexEditorGadget()\MemSize) = #False And GetFocus_() = hWnd
     If HexEditorGadget()\InputCaret = #Null
      HexEditorGadget()\InputCaret = CreateCaret_(hWnd, 0, 1, HexEditorGadget()\Char\cy)
     EndIf
     GetClientRect_(hWnd, @childRect)
     sep1x = childRect\left + (8 * HexEditorGadget()\Char\cx) + 5
     sep2x = childRect\left + (8 * HexEditorGadget()\Char\cx) + (2 * HexEditorGadget()\Columns * HexEditorGadget()\Char\cx) + (3 * (HexEditorGadget()\Columns - 1)) + 11
     Select HexEditorGadget()\CaretFlag
      Case #HE_CF_HexLN
       SetCaretPos_(sep1x + (2 * HexEditorGadget()\SelColumn * HexEditorGadget()\Char\cx) + (3 * HexEditorGadget()\SelColumn) + HexEditorGadget()\Char\cx + 3, HexEditorGadget()\SelRow * HexEditorGadget()\Char\cy + 2)
      Case #HE_CF_HexHN
       SetCaretPos_(sep1x + (2 * HexEditorGadget()\SelColumn * HexEditorGadget()\Char\cx) + (3 * HexEditorGadget()\SelColumn) + 3, HexEditorGadget()\SelRow * HexEditorGadget()\Char\cy + 2)
      Case #HE_CF_Char
       SetCaretPos_(sep2x + (HexEditorGadget()\SelColumn * HexEditorGadget()\Char\cx) + 3, HexEditorGadget()\SelRow * HexEditorGadget()\Char\cy + 2)
     EndSelect
     ShowCaret_(hWnd)
    Else
     HideCaret_(hWnd)
    EndIf
   Default
    Result = DefWindowProc_(hWnd, Msg, wParam, lParam)
  EndSelect
 Else
  Result = DefWindowProc_(hWnd, Msg, wParam, lParam)
 EndIf
ProcedureReturn Result
EndProcedure

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = --
; EnableXP