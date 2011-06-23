; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2934&highlight=
; Author: javabean (updated for PB4.00 by blbltheworm)
; Date: 26. November 2003
; OS: Windows
; Demo: No


; Ich hab' da vor einiger Zeit eine Prozedur geschrieben, das verschiedene Parameter
; der NICs in einem System ermittelt und in lesbarer Form anzeigt. 
; Kernstück hierfür ist die API-Funktion "GetIFTable", sowie die Struktur "MIB_IFROW"
; (http://msdn.microsoft.com/library/default.asp?url=/library/en-us/iphlp/iphlp/getiftable.asp) 
;
; (Außerdem gibt es unter diesenn "IP Helper Functions" noch eine ganze Reihe anderer
; interessanter Funktionen.) 
;
; Die Idee zur Verwendung der GetIFTable und der MIB_IFROW-Struktur hab' ich mir aus
; einem Code-Listing eines C-Programms im Internet geholt. Sucht mal im Internet, da
; gibt's sicher eine Menge anderer Code-Beispiele dazu. 
;
; Meine Prozedur ist eher aus einer "Schnellschußaktion" heraus entstanden, weshalb
; der Code etwas rumpelig und leider auch etwas ineffizient geschrieben sowie praktisch
; nicht kommentiert ist. -Vielleicht es ja trotzdem eine kleine Hilfe. 



Procedure.l GetIFInfo() 
#MAX_INTERFACE_NAME_LEN = 256 
#MAXLEN_PHYSADDR        = 8 
#MAXLEN_IFDESCR         = 256 

#ERROR_SUCCESS = 0 

#MIB_IF_TYPE_OTHER     = 1 
#MIB_IF_TYPE_ETHERNET  = 6 
#MIB_IF_TYPE_TOKENRING = 9 
#MIB_IF_TYPE_FDDI      = 15 
#MIB_IF_TYPE_PPP       = 23 
#MIB_IF_TYPE_LOOPBACK  = 24 
#MIB_IF_TYPE_SLIP      = 28 

Structure MIB_IFROW 
  wszName.b[#MAX_INTERFACE_NAME_LEN*2] 
  dwIndex.l                        ; index of the interface 
  dwType.l                         ; type of interface 
  dwMtu.l                          ; max transmission unit 
  dwSpeed.l                        ; speed of the interface 
  dwPhysAddrLen.l                  ; length of physical address 
  bPhysAddr.b[#MAXLEN_PHYSADDR]    ; physical address of adapter 
  dwAdminStatus.l                  ; administrative status 
  dwOperStatus.l                   ; operational status 
  dwLastChange.l                   ; last time operational status changed 
  dwInOctets.l                     ; octets received 
  dwInUcastPkts.l                  ; unicast packets received 
  dwInNUcastPkts.l                 ; non-unicast packets received 

  dwInDiscards.l                   ; received packets discarded 
  dwInErrors.l                     ; erroneous packets received 
  dwInUnknownProtos.l              ; unknown protocol packets received 
  dwOutOctets.l                    ; octets sent 
  dwOutUcastPkts.l                 ; unicast packets sent 
  dwOutNUcastPkts.l                ; non-unicast packets sent 
  dwOutDiscards.l                  ; outgoing packets discarded 
  dwOutErrors.l                    ; erroneous packets sent 
  dwOutQLen.l                      ; output queue length 
  dwDescrLen.l                     ; length of bDescr member 
  bDescr.b[#MAXLEN_IFDESCR]        ; interface description 
EndStructure 



IPInterfaceRow.MIB_IFROW 
Buffer.l 
BufferSize.l 
nStructSize.l 
nRows.l 
cnt.l 



BufferSize=0 
RetCode.l = GetIfTable_(#Null,@BufferSize,#True) 
If RetCode = 122 

  
  Buffer = AllocateMemory(BufferSize) 
  
  GetIfTable_(Buffer,@BufferSize,#True); = #ERROR_SUCCESS 
    nStructSize = SizeOf(IPInterfaceRow) 
    CopyMemory(Buffer,@nRows,4) 
    
    Global Dim ListArray.s (nRows, 20) 
    ListArray(0,0)  = "Interface Description" 
    ListArray(0,1)  = "Index of the Interface" 
    ListArray(0,2)  = "Type of interface" 
    ListArray(0,3)  = "Max transmission unit" 
    ListArray(0,4)  = "Speed of the interface" 
    ListArray(0,5)  = "Physical address of adapter"    
    ListArray(0,6)  = "Administrative status" 
    ListArray(0,7)  = "Operational status" 
    ListArray(0,8)  = "Last time operational status changed" 
    ListArray(0,9)  = "Octets received" 
    ListArray(0,10) = "Octets sent " 
    ListArray(0,11) = "Unicast packets received " 
    ListArray(0,12) = "Unicast packets sent" 
    ListArray(0,13) = "Non-unicast packets received"    
    ListArray(0,14) = "Non-unicast packets sent" 
    ListArray(0,15) = "Received packets discarded" 
    ListArray(0,16) = "Outgoing packets discarded" 
    ListArray(0,17) = "Erroneous packets received" 
    ListArray(0,18) = "Erroneous packets sent" 
    ListArray(0,19) = "Unknown protocol packets received" 
    ListArray(0,20) = "Output queue length" 

    
    For cnt = 1 To nRows 
    
      CopyMemory((Buffer +4 + (cnt - 1) * nStructSize),@IPInterfaceRow, nStructSize) 
        
        For i = 0 To (IPInterfaceRow\dwDescrLen - 1) 

          IF_Description.s 
          IF_Description = IF_Description + Chr(IPInterfaceRow\bDescr[i]) 
        
        Next 
        
        For j = 0 To (IPInterfaceRow\dwPhysAddrLen - 1) 

          IF_PhysAddress.s 
          
          If j<>(IPInterfaceRow\dwPhysAddrLen - 1)          
            IF_PhysAddress = IF_PhysAddress + Hex(IPInterfaceRow\bPhysAddr[j]) + "-" 
          Else 
            IF_PhysAddress = IF_PhysAddress + Hex(IPInterfaceRow\bPhysAddr[j]) 
          EndIf 
          
          If FindString(IF_PhysAddress,"FFFFFF",1) 
            IF_PhysAddress = RemoveString(IF_PhysAddress, "FFFFFF",1) 
          EndIf 
        
        Next 

        If Len(IF_PhysAddress) = 0 
          IF_PhysAddress = "No physical address" 
        EndIf 


        ListArray(cnt,0)  = IF_Description 
        ListArray(cnt,1)  = Str(IPInterfaceRow\dwIndex) 
        ListArray(cnt,2)  = Str(IPInterfaceRow\dwType)        
        ListArray(cnt,3)  = Str(IPInterfaceRow\dwMtu) 
        ListArray(cnt,4)  = Str(IPInterfaceRow\dwSpeed) 
        ListArray(cnt,5)  = IF_PhysAddress    
        ListArray(cnt,6)  = Str(IPInterfaceRow\dwAdminStatus) 
        ListArray(cnt,7)  = Str(IPInterfaceRow\dwOperStatus) 
        ListArray(cnt,8)  = Str(IPInterfaceRow\dwLastChange)        
        ListArray(cnt,9)  = Str(IPInterfaceRow\dwInOctets) 
        ListArray(cnt,10) = Str(IPInterfaceRow\dwOutOctets) 
        ListArray(cnt,11) = Str(IPInterfaceRow\dwInUcastPkts) 
        ListArray(cnt,12) = Str(IPInterfaceRow\dwOutUcastPkts) 
        ListArray(cnt,13) = Str(IPInterfaceRow\dwInNUcastPkts)    
        ListArray(cnt,14) = Str(IPInterfaceRow\dwOutNUcastPkts) 
        ListArray(cnt,15) = Str(IPInterfaceRow\dwInDiscards) 
        ListArray(cnt,16) = Str(IPInterfaceRow\dwOutDiscards) 
        ListArray(cnt,17) = Str(IPInterfaceRow\dwInErrors) 
        ListArray(cnt,18) = Str(IPInterfaceRow\dwOutErrors) 
        ListArray(cnt,19) = Str(IPInterfaceRow\dwInUnknownProtos) 
        ListArray(cnt,20) = Str(IPInterfaceRow\dwOutQLen) 
                
        IF_PhysAddress = "" 
        IF_Description = "" 
      
     Next 

EndIf 

ProcedureReturn nRows 
EndProcedure 




If OpenWindow(0,500,500,580,320,"Interface List",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) 

  If CreateGadgetList(WindowID(0)) 
    ListIconGadget(0, 0, 0, 580, 318, "Value",192,#PB_ListIcon_GridLines) 

      nRows.l = GetIFInfo() 
      For a=1 To nRows          ; fügt weitere Spalten zum ListIcon hinzu 
        AddGadgetColumn(0,a,"Interface "+Str(a),(384/nRows)) 
      Next 

        
      For b=0 To 20          ; fügt 4 Einträge auf jeder Zeile des ListIcons hinzu 
          y=b    
          AddGadgetItem(0,b,ListArray(0,b)); + Chr(10)+LineArray(b)) 
      Next 
  EndIf 


  Repeat 

    If nRows <> GetIFInfo() 
      FreeGadget(0) 
      If CreateGadgetList(WindowID(0)) 
      ListIconGadget(0, 0, 0, 580, 318, "Value",192,#PB_ListIcon_GridLines) 

        nRows.l = GetIFInfo() 
        For a=1 To nRows          ; fügt weitere Spalten zum ListIcon hinzu 
          AddGadgetColumn(0,a,"Interface "+Str(a),(384/nRows)) 
        Next 

        
        For b=0 To 20          ; fügt 4 Einträge auf jeder Zeile des ListIcons hinzu 
          y=b    
          AddGadgetItem(0,b,ListArray(0,b)); + Chr(10)+LineArray(b)) 
        Next 
      EndIf 

    EndIf 

    nRows = GetIFInfo() 
    For b=0 To 20 
      For a=1 To nRows 
        SetGadgetItemText(0, b, ListArray(a,b) , a) 
      Next 
    Next 

    Delay(80) 
  Until WindowEvent()=#PB_Event_CloseWindow 
EndIf 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger
