; English forum: http://www.purebasic.fr/english/viewtopic.php?t=14226&postdays=0&postorder=asc&start=15
; Author: MrMat
; Date: 03. March 2005
; OS: Windows
; Demo: No


; Changing stack size during program flow...
; Ändern der Stack-Größe während des Programmablaufs

; The example initially sets the stack to 200 kb then calls an iterative procedure 
; which monitors the free stack space. When it goes below 100 kb it calls a procedure 
; to increase the stack by 1 mb and then it continues iterating. I set it to stop 
; when the stack size reached 2 mb. The decreasing numbers at the end show the stack 
; was preserved correctly so i think it's all working. 


Global *NewStack.l, NewStackSize.l, *OldStack.l, *StartStack.l, *OrigStack.l 

MOV *NewStack, esp ; Start of stack 
NewStackSize = 1024 * 1024 ; Default stack size is 1 mb 
*OldStack = 0 
*OrigStack = *NewStack ; Store original stack position to return to at code exit 

Procedure.l ReallocateStack(StackSize.l) ; Set new stack size (in bytes) 
; Get position in current stack 
  MOV *StartStack, esp 
  
; Calculate stack free 
  CurrentFree = NewStackSize - *NewStack + *StartStack 

; Need a few bytes spare 
  If CurrentFree < 256 
    ProcedureReturn 1 ; Not enough (1 = stack free space too small) 
  EndIf 

; Calculate stack used 
  NewStackSize = *NewStack - *StartStack 

; Check new stack size is bigger than current size in use + 1k 
  If StackSize < NewStackSize + 1024 
    ProcedureReturn 2 ; No it isn't (2 = new stack size too small) 
  EndIf 

; Allocate space for new stack 
  *NewStackPos = AllocateMemory(StackSize) 

; Could we allocate memory for new stack? 
  If *NewStackPos = 0 
    ProcedureReturn 3 ; Nope we couldn't (3 = not enough free memory to allocate new stack) 
  EndIf 

; Calcaulate position in new stack 
  *NewStack.l = *NewStackPos + StackSize - NewStackSize 

; Temporarily shift stack so as not to interfere with CopyMemory 
  *TempStack = *StartStack - 128 
  MOV eax, *TempStack 
  MOV esp, eax 

; Copy used stack across to new stack 
  CopyMemory(*StartStack, *NewStack, NewStackSize) 

; Update stack with new position 
  MOV eax, *NewStack 
  MOV esp, eax 

; Previous stack no longer needed, so free it 
  If *OldStack 
    FreeMemory(*OldStack) 
  EndIf 

; Update new stack position and size and old stack position 
  *NewStack = *NewStackPos + StackSize 
  NewStackSize = StackSize 
  *OldStack = *NewStack - NewStackSize 

; Phew, we made it to the end (0 = good) 
ProcedureReturn 0 
EndProcedure 

Procedure.l StackFree() ; Return free stack space 
  *CurrentStack.l 
  MOV *CurrentStack, esp 
ProcedureReturn NewStackSize - *NewStack + *CurrentStack 
EndProcedure 

Procedure.l StackUsed() ; Return used stack space 
  *CurrentStack.l 
  MOV *CurrentStack, esp 
ProcedureReturn *NewStack - *CurrentStack 
EndProcedure 

Procedure.l flop(count.l) ; Iterative example procedure 
; Update every 2000 calls 
  If count % 2000 = 0 
    Debug("Count: " + Str(count) + " Stack free (kb): " + Str(StackFree() / 1024) + " Stack used (kb): " + Str(StackUsed() / 1024)) 
    Delay(200) 
; Check if less than 100 kb stack space 
    If StackFree() < 1024 * 100 
      Debug("Less than 100 kb stack space; increasing stack size by 1 mb:") 
      result = ReallocateStack(StackUsed() + 1024 * 1024) ; Increase stack by 1 mb 
      Debug("Stack free (kb): " + Str(StackFree() / 1024) + " Stack used (kb): " + Str(StackUsed() / 1024)) 
      Select result 
        Case 0 : Debug("Stack space allocated successfully") 
        Case 1 : Debug("Not enough space on stack") : End 
        Case 2 : Debug("New stack size must be greater than previous amount in use") : End 
        Case 3 : Debug("Could not allocate memory for new stack") : End 
      EndSelect 
    EndIf 
  EndIf 
  If StackUsed() < 1024 * 1024 * 2 ; Go up to 2 mb stack size 
    flop(count + 1) 
  EndIf 
  If count % 2000 = 0 ; Check count is decreasing as procedure exits 
    Debug(count) 
  EndIf 
EndProcedure 

; Output initial free and used stack space 
Debug("Initial stack details:") 
Debug("Stack free (kb): " + Str(StackFree() / 1024) + " Stack used (kb): " + Str(StackUsed() / 1024)) 

; Set stack size to 200 kb 
Debug("Setting stack size to 200 kb:") 
result = ReallocateStack(1024 * 200) 
Select result 
  Case 0 : Debug("Stack space allocated successfully") 
  Case 1 : Debug("Not enough space on stack") : End 
  Case 2 : Debug("New stack size must be greater than previous amount in use") : End 
  Case 3 : Debug("Could not allocate memory for new stack") : End 
EndSelect 
Debug("Stack free (kb): " + Str(StackFree() / 1024) + " Stack used (kb): " + Str(StackUsed() / 1024)) 

; Call recursive procedure 
Debug("Calling iterative procedure:") 
flop(0) 

; Return to original stack and free previous stack 
If *OldStack 
  MOV eax, *OrigStack 
  MOV esp, eax 
  FreeMemory(*OldStack) 
EndIf 

Debug("Finished")
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableAsm