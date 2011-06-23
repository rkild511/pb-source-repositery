; German forum: http://www.purebasic.fr/german/viewtopic.php?t=11768&start=20
; Author: remi_meier
; Date: 01. February 2007
; OS: Windows
; Demo: No


; Example for a plan gadget (e.g. note reservations in a hotel)
; Beispiel für ein PlanGadget (z.B. zum Eintragen von Reservierungen in einem Hotel)

Macro HIWORD(Value)
  ((Value) >> 16)
EndMacro
Macro LOWORD(Value)
  ((Value) & $FFFF)
EndMacro


Structure PLANELEMENT
  Visible.l
  Row.l
  ColumnStart.l
  ColumnEnd.l
  *Data
EndStructure

Structure PLANGADGET
  GadgetID.l
  RenderImg.l
  *OldCB

  HeadHeight.l
  SideWidth.l
  ColumnWidth.l
  RowHeight.l

  *elements   ; first element
  ElementsCount.l
EndStructure

Declare PlanRedraw(*pg.PLANGADGET)

Procedure.l _plangadgetcb(hwnd.l, message.l, wParam.l, lParam.l)
  Protected *pg.PLANGADGET, Result.l, x.l, y.l
  Protected Row.l, Column.l, w.l, h.l, *elem.PLANELEMENT

  *pg = GetWindowLong_(hwnd, #GWL_USERDATA)
  Result = 1
  If *pg

    Select message
      Case #WM_LBUTTONDOWN
        x = LOWORD(lParam)
        y = HIWORD(lParam)

        Column = (x - *pg\SideWidth) / *pg\ColumnWidth
        Row    = (y - *pg\HeadHeight) / *pg\RowHeight

        *pg\ElementsCount + 1
        *pg\elements = ReAllocateMemory(*pg\elements, SizeOf(PLANELEMENT) * *pg\ElementsCount)

        *elem             = *pg\elements + SizeOf(PLANELEMENT) * (*pg\ElementsCount - 1)
        *elem\Row         = Row
        *elem\ColumnStart = Column

      Case #WM_MOUSEMOVE
        If wParam & #MK_LBUTTON
          ; dragging
          x = LOWORD(lParam)
          y = HIWORD(lParam)

          Column = (x - *pg\SideWidth) / *pg\ColumnWidth

          *elem           = *pg\elements + SizeOf(PLANELEMENT) * (*pg\ElementsCount - 1)
          *elem\ColumnEnd = Column
          *elem\Visible   = #True

          PlanRedraw(*pg)
        EndIf

      Case #WM_LBUTTONUP
        x = LOWORD(lParam)
        y = HIWORD(lParam)

        Column = (x - *pg\SideWidth) / *pg\ColumnWidth

        *elem           = *pg\elements + SizeOf(PLANELEMENT) * (*pg\ElementsCount - 1)
        *elem\ColumnEnd = Column
        *elem\Visible   = #True

        PlanRedraw(*pg)
    EndSelect
  EndIf

  If Result And *pg
    ProcedureReturn CallWindowProc_(*pg\OldCB, hwnd, message, wParam, lParam)
  EndIf
  ProcedureReturn Result
EndProcedure

Procedure.l CreatePlanGadget(x.l, y.l, width.l, height.l)
  Protected *pg.PLANGADGET

  *pg = AllocateMemory(SizeOf(PLANGADGET))
  If Not *pg
    ProcedureReturn #False
  EndIf

  *pg\RenderImg = CreateImage(#PB_Any, width, height, 32)
  If IsImage(*pg\RenderImg)
    *pg\GadgetID = ImageGadget(#PB_Any, x, y, width, height, ImageID(*pg\RenderImg))

    If Not IsGadget(*pg\GadgetID)
      FreeImage(*pg\RenderImg)
      FreeMemory(*pg)
      ProcedureReturn #False
    EndIf

    ;setup callback
    *pg\OldCB = SetWindowLong_(GadgetID(*pg\GadgetID), #GWL_WNDPROC, @_plangadgetcb())
    SetWindowLong_(GadgetID(*pg\GadgetID), #GWL_USERDATA, *pg)
    SetWindowPos_(GadgetID(*pg\GadgetID), GadgetID(*pg\GadgetID), 10, 10, 100, 100, #SWP_NOMOVE | #SWP_NOSIZE | #SWP_NOZORDER | #SWP_FRAMECHANGED)

  Else
    FreeMemory(*pg)
    ProcedureReturn #False
  EndIf

  With *pg
    \HeadHeight  = 50
    \SideWidth   = 50
    \ColumnWidth = 30
    \RowHeight   = 20
  EndWith

  ProcedureReturn *pg
EndProcedure


Procedure.l PlanGetGadget(*pg.PLANGADGET)
  If *pg
    ProcedureReturn *pg\GadgetID
  EndIf
EndProcedure

Procedure PlanRedraw(*pg.PLANGADGET)
  Protected w.l, h.l, x.l, y.l, z.l, w2.l
  Protected *elem.PLANELEMENT

  If *pg
    w = ImageWidth(*pg\RenderImg)
    h = ImageHeight(*pg\RenderImg)
    StartDrawing(ImageOutput(*pg\RenderImg)) ;>
    Box(0, 0, w, h, RGB(200, 200, 255))
    Box(0, 0, w, *pg\HeadHeight, RGB(150, 150, 255))
    Box(0, *pg\HeadHeight, *pg\SideWidth, h - *pg\HeadHeight, RGB(150, 150, 255))

    For y = 1 To (h - *pg\HeadHeight) / *pg\RowHeight
      Box(0, *pg\HeadHeight + y * *pg\RowHeight, w, 1, 0)
    Next

    For x = 1 To (w - *pg\SideWidth) / *pg\ColumnWidth
      Box(*pg\SideWidth + x * *pg\ColumnWidth, 0, 1, h, 0)
    Next

    For z = 0 To *pg\ElementsCount - 1
      *elem = *pg\elements + z * SizeOf(PLANELEMENT)

      If *elem\Visible
        x  = *pg\SideWidth + *elem\ColumnStart * *pg\ColumnWidth
        w2 = (*elem\ColumnEnd - *elem\ColumnStart + 1) * *pg\ColumnWidth
        y  = *pg\HeadHeight + *elem\Row * *pg\RowHeight
        Box(x + 1, y + 1, w2 - 1, *pg\RowHeight - 1, RGB(100, 100, 200))
      EndIf
    Next
    StopDrawing() ;<

    SetGadgetState(*pg\GadgetID, ImageID(*pg\RenderImg))
  EndIf
EndProcedure




OpenWindow(0, 20, 20, 500, 500, "test")
CreateGadgetList(WindowID(0))
pg = CreatePlanGadget(0, 0, 500, 500)
PlanRedraw(pg)

Repeat
  event = WaitWindowEvent()

  If event = #PB_Event_Gadget
    If EventGadget() = PlanGetGadget(pg)

      PlanRedraw(pg)
    EndIf
  EndIf

Until event = #PB_Event_CloseWindow

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = --
; EnableXP