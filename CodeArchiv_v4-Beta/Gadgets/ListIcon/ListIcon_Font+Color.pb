; German forum:
; Author: RedZack (updated for PB4.00 by blbltheworm)
; Date: 06. November 2002
; OS: Windows
; Demo: No

; Edit 31.5.2003 by Andre - removed FakeEndSelect

; ------------------------------------------------------------ 
;   Zeilen in einem ListIconGadget einfärben und 
;   verschiedene Zeichensätze benutzen 
; ------------------------------------------------------------ 
; 
; Benötigte Strukturen und Konstanten 
; 

#CDDS_PREPAINT       = $00000001 
#CDRF_NOTIFYITEMDRAW = $00000020 
#CDRF_NEWFONT        = $00000002 
#CDDS_ITEM           = $00010000 

#CDDS_ITEMPREPAINT   = #CDDS_ITEM |  #CDDS_PREPAINT 

#LI_ICON_GADGET      = 1 
#LI_ICON1_GADGET     = 2 

; 
;  Modulus 
; 

Procedure MOD( a,b ) 
  ProcedureReturn a-a/b*b 
EndProcedure 

; 
; Hier werden die Zeile eingefärbt 
; 

Procedure Color_ListIconGadger ( lParam.l , color.l, colorbk.l) 
Result.l = 0 
*nml.NMLVCUSTOMDRAW = lParam 
; CustomDraw Struktur kopieren 

Select *nml\nmcd\dwDrawStage 
                             ; Windows mitteilen das jede Zeile einzeln gezeichnet werden 
                             ; sollen 
   Case #CDDS_PREPAINT     : Result = #CDRF_NOTIFYITEMDRAW 

   Case #CDDS_ITEMPREPAINT :  ;Den 2ten Eintrag von #LI_ICON_GADGET gesondert einfärben 
                              If *nml\nmcd\dwItemSpec = 2 And *nml\nmcd\hdr\idFrom = #LI_ICON_GADGET 
                                *nml\clrTextBk = $00EAEA00 
                                *nml\clrText = $00FF0000 
                                ; 
                                ; Einen neuen Zeichensatz 
                                SelectObject_(*nml\nmcd\hDC, LoadFont (0, "Courier", 3)); 
                                ; Das Ganze zurück 
                                Result = #CDRF_NEWFONT 
                              Else 
                              If MOD( *nml\nmcd\dwItemSpec, 2 ) = 0 
                                *nml\clrTextBk = colorbk 
                                *nml\clrText = color 
                                ; 
                                ; Einen neuen Zeichensatz 
                                SelectObject_(*nml\nmcd\hDC, LoadFont (0, "Courier", 3)); 
                                ; Das Ganze zurück 
                                Result = #CDRF_NEWFONT 
                              Else 
                              ;Bei jedem 4ten Listeneintrag die 
                              ; Farbe und Font ändern 
                               If MOD( *nml\nmcd\dwItemSpec, 4 ) = 1 
                                 *nml\clrTextBk = color 
                                 *nml\clrText = colorbk 
                                 ; Einen neuen Zeichensatz 
                                SelectObject_(*nml\nmcd\hDC, LoadFont (0, "Verdana", 6)); 
                                Result = #CDRF_NEWFONT 
                               EndIf 
                              EndIf 
                            EndIf    
EndSelect 

ProcedureReturn Result 
EndProcedure 

; 
; Windows messages verarbeiten 
; 

Procedure.l WndProc(hWnd,Msg.l,wParam.l,lParam.l) 
  Result.l = 0 

  Select Msg 
    ; MW_NOTIFY message auswerten 
    Case #WM_NOTIFY : *hdr.NMHDR = lParam 
                      ; Das ListIconGadget steht in wParam 
                      ; EventGadgetID() funktioniert hier leider nicht 
                      If wParam = #LI_ICON_GADGET Or wParam = #LI_ICON1_GADGET 
                        Select wParam 
                          Case #LI_ICON_GADGET  : colorbk = $00EAEAEA 
                                                  color   = $00303030 

                          Case #LI_ICON1_GADGET : colorbk = $00303030 
                                                  color   = $0000FFFF 
                          
                        EndSelect 
                        ; Zeichnet das ListIconGadget ? 
                        If *hdr\code = #NM_CUSTOMDRAW 
                          ; Ja, dann einfärben 
                          ; FakeEndSelect ist einfach Sch....., bei anderen 
                          ; Programmiersprachen  geht das auch ohne! 
                          ProcedureReturn Color_ListIconGadger ( lParam, color, colorbk ) 
                        EndIf 
                      EndIf 
    Default
                 ProcedureReturn #PB_ProcessPureBasicEvents 
  EndSelect 


  ProcedureReturn 0 
EndProcedure 

; 
; Programmstart 
; 

hWnd.l = OpenWindow(1, 250, 250, 420, 215, "Color - ListIconGadget Demo", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget) 

If hWnd 

  SetWindowCallback(@WndProc()) 
  CreateGadgetList(WindowID(1)) 

  ListIconGadget(#LI_ICON1_GADGET,10,10, 95,191," Sonst was ",75, #PB_ListIcon_FullRowSelect) 
  For x = 0 To 20 
    AddGadgetItem(#LI_ICON1_GADGET ,-1, "Eintrag " + Str(x)) 
  Next 

  ListIconGadget(#LI_ICON_GADGET ,110,10,300,191,"Spalte 1",100,#PB_ListIcon_GridLines | #PB_ListIcon_FullRowSelect) 
    AddGadgetColumn(#LI_ICON_GADGET ,2, "Spalte 2", 100) 
    AddGadgetColumn(#LI_ICON_GADGET ,3, "Spalte 3", 100)    
  For x = 0 To 20 
    AddGadgetItem(#LI_ICON_GADGET ,-1, "Eintrag " + Str(x) + Chr(10) + "Irgendwas " + Chr(10) + "Irgendwas " ) 
  Next 

  Repeat 
    EventID.l = WaitWindowEvent() 
  Until EventID = #PB_Event_CloseWindow 

EndIf 
End   

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -