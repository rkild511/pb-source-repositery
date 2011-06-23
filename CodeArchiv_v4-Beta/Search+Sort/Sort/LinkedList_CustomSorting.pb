; German forum: http://www.purebasic.fr/german/viewtopic.php?t==1749&highlight=
; Author: Deeem2031 (updated for PB 4.00 by Andre)
; Date: 24. January 2005
; OS: Windows
; Demo: Yes


; Sort procedure for longs (it doesn't matter they if are included in a structure or not)
; Sortier-Prozedur für Longs (dabei ist es auch egal, ob diese in einer Structure stehen oder nicht)

Structure PB_LinkedListData_Struc 
  *FirstElement.PB_LinkedListElement_Struc ; FirstElement(LL()): = @LL()-8 
  *LastElement.PB_LinkedListElement_Struc ; LastElement(LL()): = @LL()-8 
  SizeofElement.l ; (Structure + *NextElement.l and *PrevElement.l (8 Byte)) 
  AmountofElements.l ; = CountList() 
  NumberofCurrentElement.l ; = ListIndex() + 1 (with the normal PB 3.92 LL-Library NumberofCurrentElement.l is equal to the result of ListIndex(), with the new one from purebasic.com/beta its bigger by 1) 
  StructureMap.l ; "the StructureMap is the address of the structure associated with the list, so if there is string in it they can be freed easily" by AlphaSND (explained at the end of the file) 
  IsSetNumberofCurrentElement.l ; Is NumberofCurrentElement saving the correct value? (0=yes,other=no) 
EndStructure 

Structure PB_LinkedListElement_Struc 
  *NextElement.l 
  *PrevElement.l 
  ;[...] Content 
EndStructure 

Structure PB_LinkedList_Struc 
  *PB_LinkedListData.PB_LinkedListData_Struc 
  *CurrentElement.PB_LinkedListElement_Struc 
EndStructure 

#SortLL_rising = 1 
#SortLL_descending = 2 

Procedure SortLL(*p.PB_LinkedList_Struc,Offset.l,flags) 
  Protected LL_Elements,LL_CurrentValue,*PValsBufC.LONG,MemOffsetHigh,*LL_CurrentElement.PB_LinkedListElement_Struc,*LL_LastElement.PB_LinkedListElement_Struc 
  Protected i 
  
  Offset + 8 
  LL_Elements = *p\PB_LinkedListData\AmountofElements 
  If LL_Elements 
    PValsBuf = AllocateMemory(LL_Elements*8) 
    If PValsBuf 
      PValsBufEnd = PValsBuf+LL_Elements*8-8 
      
      *LL_CurrentElement = *p\PB_LinkedListData\FirstElement 
      
      MemOffsetHigh = 0 
      Repeat 
        LL_CurrentValue = PeekL(*LL_CurrentElement+Offset) 
        *PValsBufC = PValsBufEnd 
        If flags & #SortLL_rising 
          While *PValsBufC\l >= LL_CurrentValue And MemOffsetHigh > PValsBufEnd-*PValsBufC 
            *PValsBufC-8 
          Wend 
        ElseIf  flags & #SortLL_descending 
          While *PValsBufC\l <= LL_CurrentValue And MemOffsetHigh > PValsBufEnd-*PValsBufC 
            *PValsBufC-8 
          Wend 
        EndIf 
        If MemOffsetHigh <> PValsBufEnd-*PValsBufC 
          ;Debug Str(PValsBufEnd-MemOffsetHigh)+" "+Str(PValsBufEnd-MemOffsetHigh)+" "+Str(MemOffsetHigh-(PValsBufEnd-*PValsBufC)) 
          CopyMemory(PValsBufEnd-MemOffsetHigh+8,PValsBufEnd-MemOffsetHigh,MemOffsetHigh-(PValsBufEnd-*PValsBufC)) 
        EndIf 
        *PValsBufC\l = LL_CurrentValue 
        *PValsBufC+4 
        *PValsBufC\l = *LL_CurrentElement 
        *PValsBufC+4 
        MemOffsetHigh+8 
        
        *LL_CurrentElement = *LL_CurrentElement\NextElement 
      Until *LL_CurrentElement = 0 
      
      *PValsBufC = PValsBuf+4 
      *LL_CurrentElement = *p\PB_LinkedListData\FirstElement 
      *LL_LastElement = 0 
      *p\PB_LinkedListData\FirstElement = *PValsBufC\l 
      For i = 1 To LL_Elements 
        *LL_CurrentElement\PrevElement = *LL_LastElement 
        *LL_LastElement = *LL_CurrentElement 
        *LL_CurrentElement\NextElement = *PValsBufC\l 
        *LL_CurrentElement = *LL_CurrentElement\NextElement 
        
        *PValsBufC+8 
      Next 
      *p\PB_LinkedListData\LastElement = *LL_CurrentElement 
      *LL_CurrentElement\NextElement = 0 
      
      FreeMemory(PValsBuf) 
      
      *p\PB_LinkedListData\IsSetNumberofCurrentElement = 1 ;Set ListIndex to invalid 
      ProcedureReturn #True 
    Else 
      ProcedureReturn #False 
    EndIf 
  Else 
    ProcedureReturn #True 
  EndIf 
EndProcedure 

;-Beispiel 

Structure player_struc 
  x.l 
  y.l 
  quality.l 
  l.l 
EndStructure 

NewList Playerlist.player_struc() 

AddElement(Playerlist()) 
Playerlist()\quality = 11 
AddElement(Playerlist()) 
Playerlist()\quality = 8 
AddElement(Playerlist()) 
Playerlist()\quality = 3 
AddElement(Playerlist()) 
Playerlist()\quality = 4 
AddElement(Playerlist()) 
Playerlist()\quality = 2 
AddElement(Playerlist()) 
Playerlist()\quality = 10 

Global tmp.l 
!MOV dword [v_tmp], t_Playerlist 
SortLL(tmp,OffsetOf(player_struc\quality),#SortLL_descending) 

ForEach Playerlist() 
  Debug Playerlist()\quality 
Next 



Dim TestArray.l(5) 
TestArray(0) = 11:TestArray(1) = 8:TestArray(2) = 3:TestArray(3) = 4:TestArray(4) = 2:TestArray(5) = 10 
NewList TestLL.l() 
AddElement(TestLL()):TestLL() = 11 
AddElement(TestLL()):TestLL() = 8 
AddElement(TestLL()):TestLL() = 3 
AddElement(TestLL()):TestLL() = 4 
AddElement(TestLL()):TestLL() = 2 
AddElement(TestLL()):TestLL() = 10 

Debug ""
Debug "Now a speed test with linked list sorting starts..."

DisableDebugger

#r = 1000000

!MOV dword [v_tmp], t_TestLL 
StartTime = timeGetTime_() 
For i = 1 To #r 
  SortLL(tmp,0,#SortLL_descending) 
Next 
Time1 = timeGetTime_()-StartTime 


StartTime = timeGetTime_() 
For i = 1 To #r 
  SortArray(TestArray(),1) 
Next 
Time2 = timeGetTime_()-StartTime 

MessageRequester("","SortLL: "+StrF(Time1/#r)+"ms/call"+Chr(13)+Chr(10)+"SortArray: "+StrF(Time2/#r)+"ms/call")

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -