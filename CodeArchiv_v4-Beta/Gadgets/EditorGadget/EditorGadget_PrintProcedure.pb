; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1395&highlight=
; Author: Wichtel (updated for PB4.00 by blbltheworm)
; Date: 24. June 2003
; OS: Windows
; Demo: No


; Procedure for printing contents of a EditorGadget
; EditorPrint(PureBasicID of existing EditorGadget, DocName of displayed doc in spooler)

; Der Code setzt voraus, dass vorher ein EditorGadget() in einem Fenster erzeugt worden ist. 
; An EditorPrint() wird die PB Konstante für das EditorGadget und der Name der im Spooler erscheint übergeben. 

Procedure EditorPrint(Gadget.l,docname.s) 
  Protected DC 

  lppd.PRINTDLG; Struktur für die API Druckerauswahl 
  lppd\lStructsize=SizeOf(PRINTDLG) 
  lppd\Flags=#PD_ALLPAGES| #PD_HIDEPRINTTOFILE | #PD_NOSELECTION | #PD_RETURNDC 
  PrintDlg_(lppd); API Druckerauswahl (printrequester geht nicht) 
;  DC = DefaultPrinter(); oder den Standarddrucker nutzen 
    
  DC=lppd\hDC; hier kommt der Device Context zurück 
  cRect.RECT 
  FormatRange.FORMATRANGE 
  Docinfo.Docinfo;DInfo1 
    
  Docinfo\cbSize = SizeOf(Docinfo) 
  Docinfo\lpszDocName = @docname 
  Docinfo\lpszOutput = #Null 
    
;    PrintWindow() ; hier könnte man ein Info fenster einbauen 
;    SetGadgetText(#infotext, "Druckvorbereitung") 
    StartDoc_(DC,Docinfo) 
    
    LastChar = 0 
    MaxLen = Len(GetGadgetText(Gadget)) - SendMessage_(GadgetID(Gadget),#EM_GETLINECOUNT,0,0) 
    OldMapMode = GetMapMode_(DC) 
    SetMapMode_(DC,#MM_TWIPS) 
    OffsetX = GetDeviceCaps_(DC,#PHYSICALOFFSETX) 
    OffsetY = -GetDeviceCaps_(DC,#PHYSICALOFFSETY) 
    HorzRes = GetDeviceCaps_(DC,#HORZRES) 
    VertRes = -GetDeviceCaps_(DC,#VERTRES) 
    SetRect_(cRect,OffsetX,OffsetY,HorzRes,VertRes) 
    DPtoLP_(DC,cRect,2) 
    SetMapMode_(DC,OldMapMode) 
    FormatRange\hDC = DC 
    FormatRange\hdcTarget = DC 
    FormatRange\rc\left = cRect\left 
    FormatRange\rc\top = cRect\top 
    FormatRange\rc\right = cRect\right 
    FormatRange\rc\bottom = cRect\bottom 
    FormatRange\rcPage\left = cRect\left 
    FormatRange\rcPage\top = cRect\top 
    FormatRange\rcPage\right = cRect\right 
    FormatRange\rcPage\bottom = cRect\bottom 
    a = 1 
    Repeat 
;        SetGadgetText(#infotext, "Drucke Seite : "+ Str(a)) ; fürs Info Fenster 
        StartPage_(DC) 
        FormatRange\chrg\cpMax = -1 
        LastChar = SendMessage_(GadgetID(Gadget),#EM_FORMATRANGE,#True,@FormatRange) 
        FormatRange\chrg\cpMin = LastChar 
        SendMessage_(GadgetID(Gadget),#EM_DISPLAYBAND,0,cRect) 
        a + 1 
        EndPage_(DC) 
    Until LastChar >= MaxLen Or LastChar = -1 
;    SetGadgetText(#infotext, "Fertig") ; ebenso fürs Info Fenster 
;    CloseWindow(#infofenster) ; Info fenster schliessen 
    EndDoc_(DC) 
    SendMessage_(GadgetID(Gadget),#EM_FORMATRANGE,0,0) 
EndProcedure 


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
