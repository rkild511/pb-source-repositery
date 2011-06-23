; English forum: http://www.purebasic.fr/english/viewtopic.php?t=15714&highlight=
; Author: localmotion34 (updated for PB 4.00 by Andre)
; Date: 26. June 2005
; OS: Windows
; Demo: No


; Here is a little piece of code that could be the beginning of a simple grid
; or whatever else someone had in mind for a lisbox. It's based on an ownerdrawn
; listbox as previously i have posted before. This just takes advantage of the
; #wm_drawitem message and the #wm_notify message. Take it for what it is worth,
; and use it as you need.

Global OriginProc,editcontrol.l ,editprocedure.l ,crtitem.l


Procedure GetPanelDisplayWindowID(hwnd,item)
  tc_item.TC_ITEM
  tc_item\Mask=#TCIF_PARAM
  SendMessage_(hwnd,#TCM_GETITEM,item,tc_item)
  ProcedureReturn tc_item\lParam
EndProcedure
Procedure EditProc(hwnd,msg,wParam,lParam)
  Select msg
    Case #WM_RBUTTONDOWN

      ProcedureReturn 0
  EndSelect
  ProcedureReturn CallWindowProc_(editprocedure,hwnd,msg,wParam,lParam)
EndProcedure

Procedure ListboxProc( hwnd, msg,wParam,lParam)
  Select msg
    Case #WM_DRAWITEM
      hbrushSelectedFocus.l = CreateSolidBrush_(RGB(0, 0, 80))
      *textbuffer.s=Space(255)
      listb=GetWindow_(hwnd,#GW_CHILD)
      *lpdis.DRAWITEMSTRUCT=lParam
      *lptris.DRAWITEMSTRUCT=*lpdis.DRAWITEMSTRUCT
      Select *lpdis\CtlType
        Case #ODT_LISTBOX
          itemHeight=SendMessage_(*lpdis\hwndItem,#LB_GETITEMHEIGHT,0,0)
          Select *lpdis\itemState
            Case #ODS_SELECTED
              dtFlags = #DT_LEFT | #DT_VCENTER
              currentBrush = CreateSolidBrush_(RGB(0, 0, 80))
              currentTextColor = #White
              drawfoc=#False
              drawbox=#False
            Case #ODS_SELECTED | #ODS_FOCUS
              dtFlags = #DT_LEFT | #DT_VCENTER
              currentBrush = hbrushSelectedFocus
              currentTextColor = #White
              drawfoc=#True
            Case 0
              dtFlags = #DT_LEFT | #DT_VCENTER
              currentBrush = #White
              currentTextColor = RGB(0, 0, 0)
              drawfoc=#False
              drawbox=#True
          EndSelect
          SendMessage_(*lpdis\hwndItem,#LB_GETTEXT,*lpdis\itemID,*textbuffer)
          lbText$=*textbuffer
          FillRect_(*lpdis\hdc, *lpdis\rcItem, currentBrush)
          If drawfoc=#True
            DrawFocusRect_(*lpdis\hdc, *lpdis\rcItem)
          EndIf
          If drawbox=#True
            hpen=CreatePen_(#PS_INSIDEFRAME      ,0,#Black)
            Rectangle_(*lpdis\hdc,*lpdis\rcItem\left,*lpdis\rcItem\top,*lpdis\rcItem\right,*lpdis\rcItem\bottom)
          EndIf
          SetBkMode_(*lpdis\hdc, #TRANSPARENT)
          SetTextColor_(*lpdis\hdc, currentTextColor)
          *lpdis\rcItem\left+itemHeight
          DrawText_(*lpdis\hdc, lbText$, Len(lbText$), *lpdis\rcItem, dtFlags)
          ProcedureReturn 0
      EndSelect
    Case #WM_COMMAND
      Select (wParam>>16)&$FFFF
        Case #LBN_DBLCLK
          *textbuffer1.s=Space(256)
          curitem=SendMessage_(lParam,#LB_GETCURSEL,0,0)
          crtitem=curitem
          SendMessage_(lParam,#LB_GETITEMRECT,curitem,itmrect.RECT)
          SendMessage_(lParam,#LB_GETTEXT,curitem,*textbuffer1)
          itmhght=SendMessage_(lParam,#LB_GETITEMHEIGHT,0,0)
          UseGadgetList(lParam)
          editcontrol=StringGadget(#PB_Any,itmrect\left+1,itmrect\top,itmrect\right-itmrect\left-2,itmhght,*textbuffer1,#PB_String_BorderLess)
          SetFocus_(GadgetID(editcontrol))
          editprocedure.l=SetWindowLong_(GadgetID(editcontrol),#GWL_WNDPROC,@EditProc())
          ProcedureReturn 0
        Case #LBN_SELCHANGE
          If editcontrol
            *textbuffer2.s=Space(256)
            SendMessage_(lParam,#LB_GETTEXT,crtitem,*textbuffer2)
            SendMessage_(lParam,#LB_DELETESTRING,crtitem,0)
            SendMessage_(lParam,#LB_INSERTSTRING,crtitem,GetGadgetText(editcontrol))
            FreeGadget(editcontrol)
            editcontrol = 0
          EndIf
          ProcedureReturn 0
      EndSelect
  EndSelect
  ProcedureReturn CallWindowProc_(OriginProc,hwnd,msg,wParam,lParam)
EndProcedure

ProcedureDLL LBGrid(x,y,width,height,itemHeight,type,parent,tabitem)
  *class.s=Space(255)
  cs=GetClassName_(parent,*class,Len(*class))
  If *class = "SysTabControl32"
    finalparent=GetPanelDisplayWindowID(parent,tabitem)
  Else
    finalparent=parent
  EndIf
  window=OpenWindow(#PB_Any,x,y,width,height,"",#PB_Window_BorderLess|#PB_Window_Invisible)
  SetWindowLong_(WindowID(window),#GWL_STYLE, #WS_CHILD|#WS_DLGFRAME|#WS_EX_CLIENTEDGE|#WS_CLIPCHILDREN|#WS_CLIPSIBLINGS )
  SetParent_(WindowID(window),finalparent)
  ShowWindow_(WindowID(window),#SW_SHOW)
  CreateGadgetList(WindowID(window))
  lb=ListViewGadget(#PB_Any,0,0,width,height,#LBS_OWNERDRAWFIXED|#LBS_HASSTRINGS|#LBS_MULTICOLUMN|#LBS_NOTIFY)
  OriginProc= SetWindowLong_(WindowID(window), #GWL_WNDPROC, @ListboxProc())
  SendMessage_(GadgetID(lb), #LB_SETITEMHEIGHT, 0, itemHeight)
  SendMessage_(GadgetID(lb), #LB_SETCOLUMNWIDTH, 80,0)
  UseGadgetList(finalparent)
  ProcedureReturn lb
EndProcedure

#WindowWidth  = 390
#WindowHeight = 350
If OpenWindow(0, 100, 200, #WindowWidth, #WindowHeight, "", #PB_Window_MinimizeGadget)
  If CreateGadgetList(WindowID(0))
    grid=LBGrid(30,20,250,200,0,0,WindowID(0),0)
  EndIf
  For a=0 To 35
    AddGadgetItem(grid,-1,Str(a))
  Next

  ;- create some images

  ;- add some items


  ;- event loop
  Repeat

    EventID = WaitWindowEvent()

    If EventID = #PB_Event_Gadget

      Select EventGadget()



    EndSelect

  EndIf

Until EventID = #PB_Event_CloseWindow

EndIf

End

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -