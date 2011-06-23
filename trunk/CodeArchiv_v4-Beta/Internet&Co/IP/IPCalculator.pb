; English forum: 
; Author: Unknown (updated for PB4.00 by blbltheworm + Andre)
; Date: 01. April 2003
; OS: Windows
; Demo: Yes

;- Window Constants
;
#Window_0 = 0

;- Gadget Constants
;
#Gadget_IP = 0
#Gadget_Calc = 1
#Gadget_SM = 2
#Gadget_CLASS = 3
#Gadget_SLIDER = 4
#Gadget_PREFIX = 5
#Gadget_NETS = 6
#Gadget_HOSTS = 7
#Gadget_10 = 8
#Gadget_11 = 9
#Gadget_INVERT = 10
#Gadget_LIST = 11
#Gadget_14 = 12
#Gadget_15 = 13
#Gadget_16 = 14

;- StatusBar Constants
;
#StatusBar_0 = 0

Procedure Open_Window_0()
  If OpenWindow(#Window_0, 247, 50, 351, 460 , "IPcalc", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_TitleBar)
    If CreateStatusBar(#StatusBar_0, WindowID(#Window_0))
    EndIf
    
    If CreateGadgetList(WindowID(#Window_0))
      IPAddressGadget(#Gadget_IP, 20, 20, 180, 30)
      ButtonGadget(#Gadget_Calc, 10, 400, 150, 30, "Calc")
      IPAddressGadget(#Gadget_SM, 20, 70, 180, 30)
      StringGadget(#Gadget_CLASS, 240, 20, 60, 30, "")
      TrackBarGadget(#Gadget_SLIDER, 20, 120, 280, 30, 0, 32)
      StringGadget(#Gadget_PREFIX, 240, 70, 60, 30, "")
      StringGadget(#Gadget_NETS, 80, 170, 80, 30, "")
      StringGadget(#Gadget_HOSTS, 220, 170, 80, 30, "")
      TextGadget(#Gadget_10, 20, 170, 40, 30, "Nets")
      TextGadget(#Gadget_11, 170, 170, 50, 30, "Hosts")
      CheckBoxGadget(#Gadget_INVERT, 320, 70, 20, 30, "")
      TreeGadget(#Gadget_LIST, 20, 220, 310, 170)
      Frame3DGadget(#Gadget_14, 10, 150, 320, 60, "")
      Frame3DGadget(#Gadget_15, 10, 10, 330, 50, "")
      Frame3DGadget(#Gadget_16, 10, 60, 330, 50, "")
    EndIf
  EndIf
EndProcedure




;--------------------------------------- CUT HERE --------------------------------------------------
; purebasic removed the assembly language.


Procedure.l prefix( n.l)
  If n.l =0 
    ProcedureReturn 0
  EndIf
  ProcedureReturn(-1 << (32-n.l))
EndProcedure



Procedure.l maskToPrefix( c.l )
  l.l=0
  For i=0 To 31
    If (c.l & 1) : l.l=l.l+1:EndIf 
    c.l = c.l >> 1
  Next
  ProcedureReturn l.l
EndProcedure



Procedure.l reverse( l.l )
  a.b=PeekB(@l.l+0)
  b.b=PeekB(@l.l+1)
  c.b=PeekB(@l.l+2)
  d.b=PeekB(@l.l+3)
  PokeB(@l.l+0,d.b)
  PokeB(@l.l+1,c.b)
  PokeB(@l.l+2,b.b)
  PokeB(@l.l+3,a.b)
  ProcedureReturn l.l
EndProcedure


Procedure.s ipAddressToString( ip.l)
  ipStr.s=""
  For i.l=0 To 3
    ipStr.s=ipStr.s+Str(IPAddressField(ip.l,i))+"."
  Next i
  ipStr.s=Left(ipStr.s,Len(ipStr.s)-1)
  ProcedureReturn ipStr.s
EndProcedure


Procedure updateGadgets( bits.l, reserved.l)
  SetGadgetText(#Gadget_PREFIX,StrU(bits.l,#Long)) 
  sMask.l=reverse(prefix(bits))
  subNet.l = (1<<(bits.l-reserved.l))
  hosts.l = (1<<((32-bits.l)))
  invert.l = GetGadgetState(#Gadget_INVERT)
  If invert.l=1 
    sMask.l = -1 ! sMask.l
  EndIf
  SetGadgetState(#Gadget_SM,sMask.l)
  SetGadgetText(#Gadget_NETS,StrU(subNet.l,#Long))
  SetGadgetText(#Gadget_HOSTS, StrU(hosts.l,#Long)) 
  SetGadgetState(#Gadget_SLIDER, bits.l)
EndProcedure


Procedure updateGadgets2( bits.l, reserved.l)
  SetGadgetText(#Gadget_PREFIX,StrU(bits.l,#Long)) 
  subNet.l = (1<<(bits.l-reserved.l))
  hosts.l = (1<<((32-bits.l)))
  SetGadgetText(#Gadget_NETS,StrU(subNet.l,#Long))
  SetGadgetText(#Gadget_HOSTS, StrU(hosts.l,#Long))
  SetGadgetState(#Gadget_SLIDER,bits.l) 
EndProcedure


Procedure updateGadgets3( bits.l, reserved.l)
  ;SetGadgetText(#Gadget_PREFIX,StrU(bits.l,#long)) 
  sMask.l=reverse(prefix(bits))
  subNet.l = (1<<(bits.l-reserved.l))
  hosts.l = (1<<((32-bits.l)))
  invert.l = GetGadgetState(#Gadget_INVERT)
  If invert.l=1 
    sMask.l = -1 ! sMask.l
  EndIf
  SetGadgetState(#Gadget_SM,sMask.l)
  SetGadgetText(#Gadget_NETS,StrU(subNet.l,#Long))
  SetGadgetText(#Gadget_HOSTS, StrU(hosts.l,#Long)) 
  SetGadgetState(#Gadget_SLIDER, bits.l)
EndProcedure



Procedure showHosts(thisNet.l, hosts.l)
  
  broadcastNet.l=reverse(reverse(thisNet.l) + hosts.l) 
  thisHost.l = thisNet.l 
  
  If hosts.l<8192 
    For i.l=1 To hosts.l -2
      sel.s = "":sel0.s = "" 
      thisHost=reverse(reverse(thisHost.l)+1) 
      If subNet.l = thisHost.l: sel0.s= " [":sel.s = "]":EndIf
      ip.s=ipAddressToString(thisHost.l)
      AddGadgetItem(#Gadget_LIST,0,sel0.s+"HOST :"+ip.s+sel.s,0,1)
    Next 
  Else 
    ; do a summary instead
    sel.s = "":sel0.s = "" 
    thisHost=reverse(reverse(thisHost.l)+1)
    If subNet.l = thisHost.l: sel0.s= " [":sel.s = "]":EndIf
    ip.s=ipAddressToString(thisHost.l)
    AddGadgetItem(#Gadget_LIST,0,sel0.s+"HOST :"+ip.s+sel.s,0,1) 
    AddGadgetItem(#Gadget_LIST,0,".... etc ... ",0,1) 
    ; last host
    thisHost=reverse(reverse(thisHost.l)-1) 
    If subNet.l = thisHost.l: sel0.s= " [":sel.s = "]":EndIf
    ip.s=ipAddressToString(thisHost.l)
    AddGadgetItem(#Gadget_LIST,0,sel0.s+"HOST :"+ip.s+sel.s,0,1)
  EndIf

EndProcedure



Procedure upDateTree( b.l, r.l)
  
  bits.l = b.l
  reserved.l = r.l
  subNet.l=GetGadgetState(#Gadget_IP)
  Mask.l = GetGadgetState(#Gadget_SM)
  firstNet.l=subNet.l & reverse(prefix( reserved.l)) 
  ourNet.l = subNet.l & Mask.l
  thisNet.l=firstNet.l 
  hosts.l = (1<<((32-bits.l)))
  nets.l= (1<<(bits.l-reserved.l))
  
  ClearGadgetItemList(#Gadget_LIST) 
  If Abs(nets.l) < 257
    skip.l = hosts.l -1 
    For j.l=1 To nets.l
      broadcastNet.l=reverse(reverse(thisNet.l) + skip.l)
      ip1.s=ipAddressToString(thisNet.l)
      ip2.s=ipAddressToString(broadcastNet.l)
      sel.s ="":sel0.s=""
      If thisNet.l = ourNet.l ; select the network we want.
        SetGadgetItemState(#Gadget_LIST, item.l, 1)
        sel.s = "]": sel0.s = " ["
      EndIf
      AddGadgetItem(#Gadget_LIST,0,sel0.s+"NET:"+ip1.s+" BR:" + ip2.s + sel.s )
      
      ;OpenTreeGadgetNode(#Gadget_LIST) 
      
      showHosts(thisNet.l,hosts.l)
      
      ;CloseTreeGadgetNode(#Gadget_LIST)
      ; end of hosts
      thisNet.l=reverse(reverse(broadcastNet.l)+1) 
    Next
  Else 
    ; do net summary instead
    
    AddGadgetItem(#Gadget_LIST,0,"To many hosts or nets to display all networks")
    thisNet.l = ourNet.l 
    broadcastNet.l=reverse(reverse(thisNet.l) + hosts.l -1)
    ip1.s=ipAddressToString(thisNet.l)
    ip2.s=ipAddressToString(broadcastNet.l)
    sel.s ="":sel0.s="" 
    AddGadgetItem(#Gadget_LIST,0,sel0.s+"NET:"+ip1.s+" BR:" + ip2.s + sel.s ) 
    
  EndIf 

EndProcedure





Open_Window_0()


; default state
reserved.l=24
bits.l=24
ip0.l = -1
oldIp0.l = 0
Repeat
  Event = WaitWindowEvent()
  If Event= #PB_Event_Gadget
    Select EventGadget()
      Case #Gadget_SLIDER
        bits.l = GetGadgetState(#Gadget_SLIDER)
        prefix.l=prefix(bits.l) 
        If bits.l<16 
          reserved.l=8
          SetGadgetText(#Gadget_CLASS,"A") 
        ElseIf bits.l<24
          reserved.l=16
          SetGadgetText(#Gadget_CLASS,"B")
        ElseIf bits.l<32
          reserved.l=24
          SetGadgetText(#Gadget_CLASS,"C")
        EndIf 
        If reserved.l<4: reserved.l=4: EndIf
        updateGadgets(bits.l, reserved.l)

      ;------------------------------------------------
      Case #Gadget_PREFIX
        s.s = GetGadgetText(#Gadget_PREFIX)
        prefix.l = Val(s.s) 
        If prefix.l>32: prefix.l=32:EndIf
        bits.l = prefix.l
        updateGadgets3(bits.l, reserved.l)
      
      ;------------------------------------------------
      Case #Gadget_IP
        subNet.l=GetGadgetState(#Gadget_IP)
        ip0.l = IPAddressField(subNet.l,0)
        If ip0.l <> oldIP0.l 
          If ip0.l < 127
            reserved.l=8
            bits.l=8
            SetGadgetText(#Gadget_CLASS,"A")
          ElseIf ip0.l < 191
            bits.l=16
            reserved.l=16
            SetGadgetText(#Gadget_CLASS,"B")
          ElseIf ip0.l < 224
            bits.l=24
            reserved.l =24
            SetGadgetText(#Gadget_CLASS,"C")
          ElseIf ip0.l < 239 
            SetGadgetText(#Gadget_CLASS,"D")
          ElseIf ip0.l < 255
            SetGadgetText(#Gadget_CLASS,"E")
          EndIf
          updateGadgets(bits.l, reserved.l)
        EndIf
        If reserved.l<4: reserved.l=4: EndIf
        oldIp0.l = ip0.l
      ; endcase IP ---------------------------------- 
      Case #Gadget_INVERT 
        updateGadgets(bits.l, reserved.l) 
      ;endcase INVERT -------------------------------
      Case #Gadget_SM
        Mask.l = GetGadgetState(#Gadget_SM)
        prefix.l = maskToPrefix( Mask.l)
        reserved.l = prefix.l
        bits.l = prefix.l 
        updateGadgets2(bits.l, reserved.l)
      ; ----------------------------------------------
      Case #Gadget_LIST 
        item.l=GetGadgetState(#Gadget_LIST)
        text.s=GetGadgetItemText(#Gadget_LIST,item.l,0 )
      
      
      ;------------------------------------------------
      Case #Gadget_Calc
        upDateTree(bits.l, reserved.l)
      
    EndSelect
  EndIf 
Until Event = #PB_Event_CloseWindow
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = --
; EnableXP