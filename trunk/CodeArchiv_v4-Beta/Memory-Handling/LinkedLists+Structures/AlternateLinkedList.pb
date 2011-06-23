; English forum: http://www.purebasic.fr/english/viewtopic.php?t=13234&highlight=
; Author: Xombie (updated for PB 4.00 by Andre)
; Date: 17. December 2004
; OS: Windows
; Demo: Yes


; Author comments:
; The difference is (aside from one or two minor tweaks) you have to create at least 
; 2-3 procedures per linked list. You have to create a procedure to copy one structure 
; to another, another procedure to copy empty/default your structure and (optional) a 
; procedure to sort your list. I don't have a working sort procedure yet but perhaps 
; in the future? I figure people have their own algorithms they like more than others 
; so I put in a template but left it at that. And I show how you could sort by 
; different fields if you wanted to. Once those three procedures are created, the 
; linked list functions don't care what kind of structure you're using. 

; Again, it's light on error checking but I tried to put in a lot of comments to show 
; what's happening so you can modify it to your own taste.

;- Constants 
#xlNull = -1 
#xlEmpty = 0 

;- Structures 
Structure s_xListInfo 
   Count.l 
   ; A count of the nodes in the list. 
   Current.l 
   ; Points to the address for our last selected node. 
   StructureSize.l 
   ; The size of our value structure. 
   AddChangesCurrent.b 
   ; Controls the behavior of the Current pointer when adding a node.  If True, will set 
   ; the Current pointer to our new node.  If False, will not change the Current pointer. 
   AddCausesSort.b 
   ; Controls whether our sorting routine is called when adding a new item.  If True, our 
   ; sort function will be called every time a new element is added.  Probably not the 
   ; best way to do this.  Maybe two separate functions?  One for just sorting and one 
   ; for sorting when adding a new element?  If your list is already sorted and this is 
   ; called would it be faster to resort the whole thing or make a smart sorting procedure? 
   ; 
   ; Not implemented yet. 
   ; 
   AddressCopy.l 
   ; The address of our CopyStructure Procedure.  When using structures with xList there 
   ; needs to be two custom procedures - a procedure to copy the structure and a procedure 
   ; to 'clear' the structure. 
   AddressEmpty.l 
   ; This will hold the address of our clearing routine.  Use this to set defaults or just 
   ; to set an empty structure.  When we look for an item based on it's index and don't find 
   ; it, we return an emptied structure - using this procedure.  So if you want to return 
   ; a certain set of values, set them in this procedure. 
   AddressSort.l 
   ; This will hold the address of our custom sorting routine.  Tailored to the structure. 
EndStructure 

Structure s_xList 
   ; Our linked list structure. 
   Left.l 
   ; Points to our previous node (or the information structure if at the root). 
   Right.l 
   ; Points to the next node (or an #xlEmpty constant if there is no next node). 
   Value.l 
   ; Holds the pointer to our structure 
EndStructure 

Structure s_Test 
   ; 
   Named.s 
   lVar.l 
   bVar.b 
   sVar.s 
   ; 
EndStructure 


;- Procedures 
;/ This block of procedures are the 'private' functions that shouldn't be called by the user. 

Procedure.l xl_Value(*xlNode.s_xList) ; A simple 'Private' function that returns the address of our value structure based on a node's address. 
   If *xlNode <> #xlNull : ProcedureReturn *xlNode\Value : Else : ProcedureReturn 0 : EndIf 
EndProcedure 

Procedure.s xl_SetValue(*xlNode.s_xList, inValueAddress.l) ; A simple 'Private' function that set's a node's value based on the node's address. 
   If *xlNode <> #xlNull : *xlNode\Value = inValueAddress : EndIf 
EndProcedure 

Procedure xl_SetLAddress(*xlNode.s_xList, Address.l) ; A 'Private' function to set the left pointer address of a node. 
   If *xlNode > 0 : *xlNode\Left = Address : EndIf 
   ; Make sure we aren't trying to set an #xlEmpty (non-node) item's address. 
EndProcedure 

Procedure xl_SetRAddress(*xlNode.s_xList, Address.l) ; A 'Private' function to set the right pointer address of a node. 
   If *xlNode > 0 : *xlNode\Right = Address : EndIf 
   ; Make sure we aren't trying to set an #xlEmpty (non-node) item's address. 
EndProcedure 

Procedure.l xl_NodeLeft(*xlNode.s_xList) ; A 'Private' function to return the address of the Node left of *xlNode 
   If *xlNode > 0 : ProcedureReturn *xlNode\Left : EndIf 
EndProcedure 

Procedure.l xl_NodeRight(*xlNode.s_xList) ; A 'Private' function to return the address of the Node right of *xlNode 
   If *xlNode > 0 : ProcedureReturn *xlNode\Right : EndIf 
EndProcedure 

Procedure.l xl_InsertItem(*xlNode.s_xList, inValue.l, bInserting.b) ; A 'Private' function to insert a new node.  Not to be called by the user. 
   ; 
   Protected *xlNewNode.s_xList 
   ; 
   *xlNewNode = AllocateMemory(SizeOf(s_xList)) 
   ; Create space for our new item in memory. 
   *xlNewNode\Left = *xlNode 
   ; Make sure the left points to the item before this one. 
   If bInserting = #False : *xlNewNode\Right = #xlEmpty : Else : *xlNewNode\Right = *xlNode\Right : EndIf 
   ; If we are inserting a value in the middle of our list then we need to make sure our right pointer 
   ; points to the next item in the list.  Otherwise, we're adding at the end so the next item is an 
   ; empty pointer. 
   If bInserting = #True : xl_SetLAddress(*xlNewNode\Right, *xlNewNode) : EndIf 
   ; Since we're inserting a new node, we're replacing the old node with the information from the added node. 
   ; We're then calling xl_InsertItem to add the *old* item back as a right node to the added node.  Since the 
   ; old node (which is being created here) is using a new address we have to update it's next item's left 
   ; address pointer to this 'old' node. 
   *xlNewNode\Value = inValue 
   ; We're passing the address of our value structure so just store it here. 
   ProcedureReturn *xlNewNode 
   ; 
EndProcedure 

;/ This is needed for the sorting routine and other functions so I'm putting it at the top. 
Procedure.l xlAddress(*xList.s_xList, index.l) ; Return the address of a node based on it's Index 
   Protected NodeCount.l 
   If *xList\Right <> #xlNull 
      While *xList\Right <> #xlEmpty And NodeCount <> index 
         *xList = *xList\Right 
         NodeCount + 1 
      Wend 
      If NodeCount = index 
         ProcedureReturn *xList 
         ; Return our address. 
      EndIf 
   Else 
      ProcedureReturn -1 
      ; Empty list, return -1 
   EndIf 
   ; 
   ProcedureReturn -1 
   ; We didn't find our node. 
EndProcedure 

;/ These four procedures are needed for each structure.  So for every different list we create, we have to create 
;/ new functions using these as templates.  For demonstration purposes I list two sort routines but only one is 
;/ 'needed'.  It's okay to change the procedure names and procedure variable names but you must keep the same 
;/ number of variables in the procedure line.  For example, you can call the copy procedures variables 
;/ "*sCopyTo.whatever_your_structure_is" & "*sCopyFrom.whatever_your_structure_is" 
;/ instead of 
;/ "*strctCopyTo.s_Test" & "*strctCopyFrom.s_Test" 
;/ but the first variable *must* be the structure you are copying to and the second must be the structure you are 
;/ copying from and they both must be pointers.  So, basically, changing the names are okay but not the number or 
;/ type. 
Procedure xl_TestCopyStructure(*strctCopyTo.s_Test, *strctCopyFrom.s_Test) 
   *strctCopyTo\Named = *strctCopyFrom\Named 
   *strctCopyTo\lVar = *strctCopyFrom\lVar 
   *strctCopyTo\bVar = *strctCopyFrom\bVar 
   *strctCopyTo\sVar = *strctCopyFrom\sVar 
EndProcedure 

Procedure xl_TestEmptyStructure(*StructureToEmpty.s_Test) 
   *StructureToEmpty\Named = "" 
   *StructureToEmpty\lVar = -1 ; In our test, this will help identify bad return values. 
   *StructureToEmpty\bVar = 0 
   *StructureToEmpty\sVar = "Empty" 
EndProcedure 

Procedure xl_TestSortBylVar(*xList.s_xList) 
   ; Note that we can create as many sort routines as we want, to sort on different values.  Just be sure to call 
   ; xlSetSortProcedure with the sorting procedure you wish to use before sorting.  So if you want to sort by lVar 
   ; 
   ; xlSetSortProcedure(q, @xl_TestSortBylVar()) 
   ; xlSort(q) 
   ; 
   ; Or, if you want to sort by Named... 
   ; 
   ; xlSetSortProcedure(q, @xl_TestSortBylNamed()) 
   ; xlSort(q) 
   ; 
   Protected *xlHold.s_Test 
   Protected *xlHold02.s_Test 
   ; 
   *xlHold = xlAddress(*xList, 0) 
   *xlHold02 = xlAddress(*xList, 1) 
   ; 
   If *xlHold\lVar > *xlHold02\lVar 
   EndIf 
   ; Hopefully you get the idea.  Just put whatever sorting routines you prefer here. 
EndProcedure 

Procedure xl_TestSortByNamed(*xList.s_xList) 
   ; Set xlTestSortBylVar for description. 
   Protected *xlHold.s_Test 
   Protected *xlHold02.s_Test 
   ; 
   *xlHold = xlAddress(*xList, 0) 
   *xlHold02 = xlAddress(*xList, 1) 
   ; 
   If *xlHold\Named > *xlHold02\Named 
   EndIf 
   ; Hopefully you get the idea.  Just put whatever sorting routines you prefer here. 
EndProcedure 
;/ 
Procedure xlSetCopyProcedure(*xList.s_xList, AddressOfCopyProcedure.l) 
   ; Set the pointer to the copy structure procedure.  Shouldn't need to call this since 
   ; we set it from xlCreate. 
   *xlInfo.s_xListInfo 
   *xlInfo = *xList\Left 
   *xlInfo\AddressCopy = AddressOfCopyProcedure 
EndProcedure 

Procedure xlSetEmptyProcedure(*xList.s_xList, AddressOfEmptyProcedure.l) 
   ; Set the pointer to the empty structure procedure. 
   *xlInfo.s_xListInfo 
   *xlInfo = *xList\Left 
   *xlInfo\AddressEmpty = AddressOfEmptyProcedure 
EndProcedure 

Procedure xlSetSortProcedure(*xList.s_xList, AddressOfSortProcedure.l) 
   ; Set the pointer to the sorting procedure. 
   *xlInfo.s_xListInfo 
   *xlInfo = *xList\Left 
   *xlInfo\AddressSort = AddressOfSortProcedure 
EndProcedure 

Procedure xlSetAddBehavior(*xList.s_xList, AddChangesCurrent.b) ; If #True, the current node pointer will point to any newly added value. 
   Protected *xlInfo.s_xListInfo 
   *xlInfo = *xList\Left 
   *xlInfo\AddChangesCurrent = AddChangesCurrent 
EndProcedure 

Procedure xlSetSortBehavior(*xList.s_xList, SortOnAdd.b) ; If #True, the list will be sorted every time an element is added. 
   Protected *xlInfo.s_xListInfo 
   *xlInfo = *xList\Left 
   If *xlInfo\AddressSort : *xlInfo\AddCausesSort = SortOnAdd : EndIf 
   ; Check To make sure our sort procedure address isn't 0.  That should be the case if we 
   ; haven't set our sort procedure yet with xlSetSortProcedure. 
EndProcedure 

Procedure.l xlCreate(*inStructureAddress.l, inStructureSize.l, AddressOfCopyProcedure.l) 
   ; 
   ; Call like xlCreate(@StructureVariable, SizeOf(Whatever_Your_Structure_Is_Named)) 
   ; 
   Protected *xList.s_xList 
   ;Protected *xlHold.s_classLines_Section 
   Protected *xlInfo.s_xListInfo 
   ; 
   *xList = AllocateMemory(SizeOf(s_xList)) 
   ; 
   *xlInfo = AllocateMemory(SizeOf(s_xListInfo)) 
   ; The fake root will not point to a parent node but will instead 
   ; point to our information structure.  We'll use this to access 
   ; optional parameters within the tree. 
   *xList\Left = *xlInfo 
   ; Our root should always point to our information structure on the left. 
   *xlInfo\Count = 1 
   ; Set the defaults for our information structure.  1 based. 
   *xlInfo\Current = *xList 
   ; Set our default Current pointer.  Points to the only node. 
   *xlInfo\AddChangesCurrent = #True 
   ; By default, when a new node is added we change our current pointer to the node. 
   *xlInfo\AddCausesSort = #False 
   ; Be default, we do not sort when a new element is added. 
   *xlInfo\StructureSize = inStructureSize 
   Debug "Structure size is: "+Str(inStructureSize) 
   ; Hold the size of our value structure. 
   *xlInfo\AddressCopy = AddressOfCopyProcedure 
   ; 
   *xList\Right = #xlEmpty 
   ; The root is the only item so this points to nothing. 
   *xlHold = AllocateMemory(inStructureSize) 
   ; Create our initial structure. 
   CallFunctionFast(AddressOfCopyProcedure, *xlHold, *inStructureAddress) 
   ; Copy the structure into our list item. 
   *xList\Value = *xlHold 
   ; 
   ProcedureReturn *xList 
   ; 
EndProcedure 

Procedure.l xlIndex(*xList.s_xList, index.l, *inStructureAddress.l) ; Fills the structure with our value. 
   ; 
   ; Could be used like... 
   ; 
   ; MyTest.s_Test 
   ; xlIndex(q, 0, @MyTest) 
   ; Where 'q' is the pointer return from xlCreate and '0' is the first element in our list (zero based) 
   ; 'MyTest' would hold the values from *PointerToHoldStructure 
   ; 
   Protected NodeCount.l 
   ; 
   Protected *xlInfo.s_xListInfo 
   *xlInfo = *xList\Left 
   ; 
   While *xList\Right <> #xlEmpty And index <> NodeCount 
      ; Check to see if we've hit the last item or the index of the item we're looking for. 
      *xList = *xList\Right 
      ; Move right through our list. 
      NodeCount + 1 
   Wend 
   ; 
   If index = NodeCount 
      CallFunctionFast(*xlInfo\AddressCopy, *inStructureAddress, *xList\Value) 
      ; Copy our value into the passed parameter. 
      ProcedureReturn #True 
   EndIf 
   ; Return the address of our value structure if we found the index. 
   CallFunctionFast(*xlInfo\AddressEmpty, *inStructureAddress) 
   ; Return an empty/bad structure. 
   ProcedureReturn #False 
   ; If we got here, we didn't find our item. 
EndProcedure 

Procedure.l xlSelectIndex(*xList.s_xList, index.l, *inStructureAddress.l) ; Fills the structure with our value and selects it as Current. 
   ; See xlIndex for example usage. 
   Protected NodeCount.l 
   ; 
   Protected *xlInfo.s_xListInfo 
   ; 
   *xlInfo = *xList\Left 
   ; Get our information structure. 
   While *xList\Right <> #xlEmpty And index <> NodeCount 
      ; Check to see if we've hit the last item or the index of the item we're looking for. 
      *xList = *xList\Right 
      ; Move right through our list. 
      NodeCount + 1 
   Wend 
   ; 
   If index = NodeCount 
      ; We found the index we were looking for. 
      *xlInfo\Current = *xList 
      ; Select it... 
      CallFunctionFast(*xlInfo\AddressCopy, *inStructureAddress, *xList\Value) 
      ; Copy the item's value into our passed parameter. 
      ProcedureReturn #True 
      ; ...fill our structure and return True since everything went okay. 
   EndIf 
   ; 
   CallFunctionFast(*xlInfo\AddressEmpty, *inStructureAddress) 
   ; Return an empty structure since we didn't find what we were looking for. 
   ProcedureReturn #False 
   ; If we got here, we didn't find our item. 
EndProcedure 

Procedure xlValue(*xList.s_xList, *inStructureAddress.l) ; Returns the address for the value structure for the Current Node (last selected). 
   ; 
   Protected *xlInfo.s_xListInfo 
   ; 
   *xlInfo = *xList\Left 
   CallFunctionFast(*xlInfo\AddressCopy, *inStructureAddress, *xList\Value) 
   ; 
EndProcedure 

Procedure.l xlAdd(*xList.s_xList, *inStructureAddress.l) ; Inserts an item at the end of our list. 
   ; 
   Protected *xlRoot.s_xList 
   Protected *xlInfo.s_xListInfo 
   ; 
   *xlRoot = *xList 
   *xlInfo = *xList\Left 
   ; 
   *xlHold = AllocateMemory(*xlInfo\StructureSize) 
   ; Create our value structure in memory. 
   CallFunctionFast(*xlInfo\AddressCopy, *xlHold, *inStructureAddress) 
   ; Create a space for our value structure and copy our incoming values into it. 
   If *xList\Right = #xlNull 
      ; Add the item as our new root. 
      *xList\Right = #xlEmpty 
      ; As our list was empty and this was added as our new root, let the list know our 
      ; next item is empty. 
      *xList\Value = *xlHold 
      ; Set our value structure. 
   Else 
      If *xList\Right = #xlEmpty 
         *xList\Right = xl_InsertItem(*xList, *xlHold, #False) 
         *xlInfo\Count + 1 
      Else 
         ; Adding to the end. 
         Repeat 
            *xList = *xList\Right 
         Until *xList\Right = #xlEmpty 
         *xList\Right = xl_InsertItem(*xList, *xlHold, #False) 
         *xlInfo\Count + 1 
      EndIf 
   EndIf 
   ; 
   If *xlInfo\AddChangesCurrent = #True : *xlInfo\Current = *xList\Right : EndIf 
   ; 
   ProcedureReturn *xList\Right 
   ; 
EndProcedure 

Procedure.l xlAddAt(*xList.s_xList, *inStructureAddress.l, InsertAt.l) ; InsertAt=The position to insert.  0 for the root (first element) 
   ; 
   Protected NodeCount.l 
   ; 
   Protected *xlRoot.s_xList 
   Protected *xlPrevious.s_xList 
   Protected *xlInfo.s_xListInfo 
   ; 
   *xlRoot = *xList 
   *xlInfo = *xList\Left 
   ; 
   *xlHold = AllocateMemory(*xlInfo\StructureSize) 
   ; Create our value structure 
   CallFunctionFast(*xlInfo\AddressCopy, *xlHold, *inStructureAddress) 
   ; Create a space for our value structure and copy our incoming values into it. 
   If *xList\Right = #xlNull 
      ; Add the item as our new root. 
      *xList\Right = #xlEmpty 
      ; As our list was empty and this was added as our new root, let the list know our 
      ; next item is empty. 
      *xList\Value = *xlHold 
      ; Set our the 
      *xlInfo\Current = *xList 
      ; 
   Else 
      If InsertAt <> -1 
         If InsertAt = 0 
            ; Insert at the root. 
            *xList\Right = xl_InsertItem(*xList, *xList\Value, #True) 
            *xList\Value = *xlTest 
            ; We're inserting at the root so insert the current 
            ; root values as a new item and set the root to the 
            ; node and the right value to the old node. 
            *xlInfo\Count + 1 
            ; Increment our node counter 
            If *xlInfo\AddChangesCurrent = #True : *xlInfo\Current = *xList : EndIf 
            ; 
         Else 
            Repeat 
               NodeCount + 1 
               *xList = *xList\Right 
               If NodeCount = InsertAt 
                  ; Found our insertion point. 
                  NodeCount = -1 
                  ; This will let the procedure know we found the insertion point. 
                  *xList\Right = xl_InsertItem(*xList, *xList\Value, #True) 
                  ; Since we're inserting, create a new item based on the current node and 
                  ; set it to the current node's right pointer.  So if we're inserting '3' 
                  ; at index two (value 10) then we'll add a new node based on the existing 
                  ; '10' and set it to '10's right pointer.  Once we do that... 
                  *xList\Value = *xlHold 
                  ; ...we'll set the current node (which was 10) to our new value ('3', in our 
                  ; example). 
                  *xlInfo\Count + 1 
                  ; Increment our list counter. 
                  If *xlInfo\AddChangesCurrent = #True : *xlInfo\Current = *xList : EndIf 
                  ; 
                  Break 
                  ; And exit the loop. 
               EndIf 
            Until *xList\Right = #xlEmpty 
            ; If we break at this point then we didn't find our insertion point - passed a value 
            ; greater than the number of nodes. 
            If NodeCount <> -1 
               *xList\Right = xl_InsertItem(*xList, *xlHold, #False) 
               ; We moved past our InsertAt position so add the value 
               ; at the end. 
               *xlInfo\Count + 1 
               ; 
               If *xlInfo\AddChangesCurrent = #True : *xlInfo\Current = *xList\Right : EndIf 
               ; 
            EndIf 
         EndIf 
      Else 
         If *xList\Right = #xlEmpty 
            *xList\Right = xl_InsertItem(*xList, *xlHold, #False) 
            *xlInfo\Count + 1 
            If *xlInfo\AddChangesCurrent = #True : *xlInfo\Current = *xList\Right : EndIf 
         Else 
            ; Adding to the end. 
            Repeat 
               *xList = *xList\Right 
            Until *xList\Right = #xlEmpty 
            *xList\Right = xl_InsertItem(*xList, *xlHold, #False) 
            *xlInfo\Count + 1 
            If *xlInfo\AddChangesCurrent = #True : *xlInfo\Current = *xList\Right : EndIf 
         EndIf 
      EndIf 
   EndIf 
   ; 
   ProcedureReturn *xList\Right 
   ; 
EndProcedure 

Procedure xlDestroy(*xList.s_xList) ; Completely destroys our list. 
   Protected lHold.l 
   Protected *xRoot.s_xList 
   *xRoot = *xList 
   If *xList\Right <> #xlEmpty 
      *xList = *xList\Right 
      While *xList\Right <> #xlEmpty 
         ; 
         lHold = *xList 
         ; Hold our current node. 
         FreeMemory(*xList\Value) 
         ; Clear the memory for our value structure 
         *xList = *xList\Right 
         ; Get the next item. 
         FreeMemory(lHold) 
         ; Now clear our node from memory. 
      Wend 
      FreeMemory(*xList) 
   EndIf 
   FreeMemory(*xRoot\Left) 
   ; Free the xList information structure. 
   FreeMemory(*xRoot\Value) 
   ; Clear the root's value structure. 
   FreeMemory(*xRoot) 
   ; Free the root. 
EndProcedure 

Procedure xlClear(*xList.s_xList) ; Clears all items from our list. 
   ; 
   Protected lHold.l 
   ; 
   Protected *xRoot.s_xList 
   Protected *xlInfo.s_xListInfo 
   ; 
   *xRoot = *xList 
   ; Hold our root. 
   *xlInfo = *xRoot\Left 
   ; Hold our information structure. 
   If *xList\Right <> #xlNull 
      ; Make sure the list isn't already empty. 
      If *xList\Right <> #xlEmpty 
         ; This block will delete only the non-root nodes from memory. 
         *xList = *xList\Right 
         ; Move to the next item after our root, without deleting the root. 
         While *xList\Right <> #xlEmpty 
            lHold = *xList 
            ; Hold the current node. 
            FreeMemory(*xList\Value) 
            ; Clear the memory for our value structure 
            *xList = *xList\Right 
            ; Update our pointer with the next node in our list.  This will not be empty since our While loop already checked. 
            FreeMemory(lHold) 
            ; Now delete our held node. 
         Wend 
         ; We exit here when we find the last non-empty node. 
         FreeMemory(*xList) 
         ; Delete the last non-empty, non-root node. 
      EndIf 
      ; The root is the only item left. 
      FreeMemory(*xRoot\Value) 
      ; Clear the value structure.  We'll recreate it when we add a value. 
      *xRoot\Right = #xlNull 
      ; Let the routines know that the list is unpopulated. 
      *xlInfo\Count = 0 
      ; No items left since we cleared everything. 
      *xlInfo\Current = *xRoot 
      ; Select our root item - just to be safe. 
   EndIf 
EndProcedure 

Procedure xlRemove(*xList.s_xList, index.l) ; Removes a node from our list. 
   ; 
   Protected NodeCount.l 
   ; 
   Protected *xlRoot.s_xList 
   Protected *xlNext.s_xList 
   Protected *xlPrevious.s_xList 
   Protected *xlInfo.s_xListInfo 
   ; 
   *xlRoot = *xList 
   *xlInfo = *xList\Left 
   ; 
   If *xList\Right = #xlNull 
      ; The list is uninitialized.  Don't delete anything. 
   Else 
      If index >= 0 
         ; Make sure we passed a non-negative index. 
         If index = 0 
            ; Delete the root. 
            If *xList\Right <> #xlEmpty 
               ; There are more items than the root item. 
               *xlNext = *xlRoot\Right 
               ; Get the address for the next item in our list. 
               *xlRoot\Right = *xlNext\Right 
               ; We can't just delete the node because then our root address would change.  That would cause 
               ; the xList pointer to be invalidated (the xList pointer is the pointer returned from xlCreate()) 
               ; So, instead, we will copy the next node into our root, leaving the address the same. 
               xl_SetLAddress(*xlNext\Right, *xlRoot) 
               ; Make sure the "Next Node"'s next node is pointing back to our root item. 
               FreeMemory(*xlRoot\Value) 
               ; Since we're copying the 'Next Node' structure into our root structure, clear the old root value 
               ; structure from memory. 
               *xlRoot\Value = *xlNext\Value 
               ; Set our root value pointer to our next item value pointer. 
               If *xlInfo\Current = *xlNext : *xlInfo\Current = *xlRoot :  EndIf 
               ; If our current node was the node after the root, set the current node to the root (which was the node after the root). 
               FreeMemory(*xlNext) 
               ; Now, delete the next node since we've copied it's values to the root.  We effectively spliced it out. 
               *xlInfo\Count - 1 
               ; Decrement our node counter 
            Else 
               ; The root is the only item. 
               FreeMemory(*xList\Value) 
               ; Clear our value structure. 
               *xList\Right = #xlNull 
               ; Let the routines know that the list is unpopulated. 
               *xlInfo\Count = 0 
               ; Set our node count to 0 since there are no more items. 
               *xlInfo\Current = *xList 
               ; Set the current node pointer to our empty root.  Just to be safe. 
            EndIf 
         Else 
            Repeat 
               NodeCount + 1 
               *xList = *xList\Right 
               If NodeCount = index 
                  ; Found the node to delete. 
                  If *xList\Right <> #xlEmpty 
                     ; There's another item after this. 
                     *xlNext = *xList\Right 
                     ; Grab our pointer 
                     *xlPrevious = *xList\Left 
                     ; 
                     *xlNext\Left = *xlPrevious 
                     ; Dereference our current node by setting the next item's left pointer 
                     ; to the current node's left item. 
                     *xlPrevious\Right = *xlNext 
                     ; Make sure our previous item points to the next item (the one after the deleted item). 
                     If *xlInfo\Current = *xList : *xlInfo\Current = *xlPrevious : EndIf 
                     ; If we're deleting the currently selected node then set the previous node as current. 
                     FreeMemory(*xList\Value) 
                     ; Free our value structure from memory. 
                     FreeMemory(*xList) 
                     ; Free the node from memory. 
                     *xlInfo\Count - 1 
                     ; Decrement our item counter. 
                  Else 
                     ; This is the last item. 
                     *xlPrevious = *xList\Left 
                     ; Okay, yes, I'm cheating.  Rather than pointing to the next item in our list, it's 
                     ; pointing to the previous item. 
                     *xlPrevious\Right = #xlEmpty 
                     ; Dereference our current item. 
                     If *xlInfo\Current = *xList : *xlInfo\Current = *xlPrevious : EndIf 
                     ; If we're deleting the currently selected node then set the previous node as current. 
                     FreeMemory(*xList\Value) 
                     ; Free our value structure from memory. 
                     FreeMemory(*xList) 
                     ; And free it from memory. 
                     *xlInfo\Count - 1 
                     ; Decrement our item counter. 
                  EndIf 
                  ; 
                  Break 
                  ; And exit the loop. 
               EndIf 
            Until *xList\Right = #xlEmpty 
            ; If we break at this point then we didn't find our insertion point - passed a value 
            ; greater than the number of nodes. 
         EndIf 
      EndIf 
   EndIf 
   ; 
EndProcedure 

Procedure xlPrint(*xList.s_xList) ; Prints your list.  For debug purposes primarily. 
   Protected lCount.l 
   Protected sHold.s 
   Protected *xlHold.s_Test 
   If *xList\Right = #xlNull 
      Debug "o-*" 
   Else 
      If *xList\Right = #xlEmpty 
         *xlHold = *xList\Value 
         ; Hold our value structure. 
         Debug "o-'"+*xlHold\Named+"'" 
      Else 
         Repeat 
            *xlHold = *xList\Value 
            If lCount = 0 
               sHold = "*-->'"+*xlHold\Named+"'" 
            Else 
               sHold = sHold+"-->'"+*xlHold\Named+"'" 
            EndIf 
            *xList = *xList\Right 
            lCount + 1 
         Until *xList\Right = #xlEmpty 
         *xlHold = *xList\Value 
         Debug sHold+"-->'"+*xlHold\Named+"'-->*" 
      EndIf 
   EndIf 
EndProcedure 

Procedure.l xlCount(*xList.s_xList) 
   ; Returns a 1 based count of our items. 
   Protected *xlInfo.s_xListInfo 
   *xlInfo = *xList\Left 
   ProcedureReturn *xlInfo\Count 
EndProcedure 

Procedure xlReset(*xList.s_xList) ; Reset our Current pointer to -1 so xlNext will move to the root node. 
   ; 
   Protected *xlInfo.s_xListInfo 
   ; 
   *xlInfo = *xList\Left 
   ; 
   *xlInfo\Current = -1 
   ; No selected node. 
EndProcedure 

Procedure.l xlFirst(*xList.s_xList) ; Sets our current pointer to the first node and returns it's address... 
   ; ...which, incidentally, is useless as the value passed to the procedure is the address ^_^ 
   Protected *xlInfo.s_xListInfo 
   ; 
   *xlInfo = *xList\Left 
   ; 
   *xlInfo\Current = *xList 
   ; 
   ProcedureReturn *xList 
   ; 
EndProcedure 

Procedure.l xlLast(*xList.s_xList) ; Sets our current pointer to the last node and returns it's address 
   ; 
   Protected *xlInfo.s_xListInfo 
   ; 
   *xlInfo = *xList\Left 
   ; 
   While *xList\Right <> #xlEmpty And *xList\Right <> #xlNull 
      *xList = *xList\Right 
   Wend 
   ; 
   *xlInfo\Current = *xList 
   ; 
   ProcedureReturn *xList 
   ; 
EndProcedure 

Procedure.l xlNext(*xList.s_xList) ; Sets our current pointer to the next node (after the current pointer). 
   ; 
   Protected *xlNode.s_xList 
   Protected *xlInfo.s_xListInfo 
   ; 
   *xlInfo = *xList\Left 
   If *xlInfo\Current = -1 
      ; We have no selected node. 
      If *xList\Right = #xlNull 
         ; Uninitialized list.  No next node. 
         ProcedureReturn #False 
      Else 
         *xlInfo\Current = *xList 
         ; Since our Current pointer is invalidated, move to the root item and return true. 
         ProcedureReturn #True 
         ; So return 
      EndIf 
   Else 
      *xlNode = *xlInfo\Current 
   EndIf 
   ; 
   If *xlNode\Right <> #xlEmpty And *xlNode\Right <> #xlNull 
      ; Make sure there is a next items. 
      *xlNode = *xlNode\Right 
      ; Select it. 
   Else 
      ProcedureReturn #False 
      ; Return False since there is no next element. 
   EndIf 
   ; 
   *xlInfo\Current = *xlNode 
   ; 
   ProcedureReturn #True 
   ; There is a next node so return True. 
EndProcedure 

Procedure.l xlPrevious(*xList.s_xList) ; Sets our current pointer to the previous node (before the current pointer). 
   ; 
   Protected *xlNode.s_xList 
   Protected *xlInfo.s_xListInfo 
   ; 
   *xlInfo = *xList\Left 
   If *xlInfo\Current = -1 
      ; No current node. 
      ProcedureReturn #False 
      ; We've reset the list - there is no previous item. 
   Else 
      *xlNode = *xlInfo\Current 
   EndIf 
   ; 
   If *xList <> *xlNode 
      ; Make sure the Current item is not the root item.  The root address is passed to xlPrevious. 
      *xlNode = *xlNode\Left 
      ; Select it. 
   Else 
      ProcedureReturn #False 
      ; Return False since there is no previous element. 
   EndIf 
   ; 
   *xlInfo\Current = *xlNode 
   ; 
   ProcedureReturn #True 
   ; There is a next node so return True. 
EndProcedure 

Procedure xlSwap(*xList.s_xList, Index01.l, Index02.l) ; Swap the two nodes. 
   ; 
   Protected lHold.l 
   ; A variable to hold one of our values. 
   If Index01 = Index02 : ProcedureReturn : EndIf 
   ; Can't swap the same indexes. 
   lAddress01 = xlAddress(*xList,Index01) 
   ; Get the first address. 
   If lAddress01 <> -1 
      ; Make sure we found it. 
      lAddress02 = xlAddress(*xList, Index02) 
      ; Get the second address. 
      If lAddress02 <> -1 
         ; Make sure we found it. 
         lHold = xl_Value(lAddress01) 
         xl_SetValue(lAddress01, xl_Value(lAddress02)) 
         xl_SetValue(lAddress02, lHold) 
      EndIf 
   EndIf 
    
EndProcedure 

Procedure xlSort(*xList.s_xList) ; Call our custom sorting procedure. 
   Protected *xlInfo.s_xListInfo 
   *xlInfo = *xList\Left 
   CallFunctionFast(*xlInfo\AddressSort,*xList) 
EndProcedure 

; 
holdTest.s_Test 
holdTest\Named = "Hi" 
holdTest\lVar = 1 
holdTest\bVar = 5 
holdTest\sVar = "One" 
; 
q.l = xlCreate(@holdTest, SizeOf(s_Test), @xl_TestCopyStructure()) 
; Pass the initial structure values, the size of our structure and the address of the procedure that will copy our structure 
xlSetEmptyProcedure(q, @xl_TestEmptyStructure()) 
Debug "*************** " 
Debug holdTest\Named 
Debug holdTest\lVar 
holdTest\Named = "blah!" 
holdTest\lVar = 99193892 
Debug "*************** " 
Debug holdTest\Named 
Debug holdTest\lVar 
Debug "*************** " 
xlIndex(q, 0, @holdTest) 
Debug holdTest\Named 
Debug holdTest\lVar 
Debug " *************** " 
holdTest\Named = "blah!" 
holdTest\lVar = 99193892 
Debug holdTest\Named 
Debug holdTest\lVar 
Debug " *************** " 
xlValue(q, @holdTest) 
Debug holdTest\Named 
Debug holdTest\lVar 
Debug " *************** " 
holdTest\Named = "blah!" 
holdTest\lVar = 99193892 
Debug holdTest\Named 
Debug holdTest\lVar 
Debug " *************** " 
xlSelectIndex(q, 0, @holdTest) 
Debug holdTest\Named 
Debug holdTest\lVar 
Debug " *************** " 
; 
holdTest\Named = "Nihao" 
holdTest\lVar = 2 
xlAdd(q, @holdTest) 
; 
xlIndex(q, 0, @holdTest) 
Debug holdTest\Named 
Debug holdTest\lVar 
Debug " *************** " 
; 
xlIndex(q, 1, @holdTest) 
Debug holdTest\Named 
Debug holdTest\lVar 
Debug " *************** " 
; 
holdTest\Named = "Konbawa" 
holdTest\lVar = 3 
xlAdd(q, @holdTest) 
; 
xlIndex(q, 2, @holdTest) 
Debug holdTest\Named 
Debug holdTest\lVar 
Debug " *************** " 
; 
xlIndex(q, 1, @holdTest) 
Debug holdTest\Named 
Debug holdTest\lVar 
Debug " *************** " 
; 
holdTest\Named = "Zai Jian" 
holdTest\lVar = 4 
xlAddAt(q, @holdTest, 1) 
; 
xlIndex(q, 1, @holdTest) 
Debug holdTest\Named 
Debug holdTest\lVar 
Debug " *************** " 
; 
Debug "Count: "+Str(xlCount(q)) 
xlDestroy(q) 
;

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = ------