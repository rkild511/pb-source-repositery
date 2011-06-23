; PB 4.0
;**
;* Coded by Remi_Meier@gmx.ch in 2006
; If you want to be a thief, just remove this comment.

Structure FPREFELEM
  *prev.FPREFELEM
  *next.FPREFELEM
  *name  ; Ptr to String
  *value ; Ptr to Data
EndStructure


Interface iFPref
  addData.l(key.s, *mem, len.l) ; Adds data identified with a key
  addString.l(key.s, string.s) ; Adds a string to the list
  removeData.l(key.s) ; Removes the data identified with the key
  getDataPtr.l(key.s) ; Gets a pointer to the data
  getString.s(key.s) ; Returns the data as a string, be sure, that Data is a String!
  clear.l() ; clears the list
  saveToFile.l(file.s) ; Save data list to file
  loadFromFile.l(file.s) ; Loads data from file (adds it to the list!)
  ; Iteration
  examineData() ; Starts the iteration through the data pointers
  nextData.l() ; Selects next data element, returns 0 if none exists
  currentDataPtr.l() ; Returns a pointer to the data in the currently selected element
  currentString.s() ; Returns the string of currentDataPtr(), be sure, that Data is a String!
  currentKey.s() ; Returns the key of the currently selected element
EndInterface

Structure cFPref
  *VT
  *listHead.FPREFELEM ; Ptr to ListStart
  *currentData.FPREFELEM ; for Iterator
EndStructure

Procedure FPref__freeElement(*this.cFPref, *elem.FPREFELEM)
  If *elem
    If *elem\Name
      FreeMemory(*elem\Name)
    EndIf
    If *elem\Value
      FreeMemory(*elem\Value)
    EndIf
    FreeMemory(*elem)
  EndIf
EndProcedure

Procedure.l FPref__addElement(*this.cFPref, *elem.FPREFELEM)
  Protected *list.FPREFELEM, found.l
 
  If Not *elem Or Not *elem\Name
    FPref__freeElement(*this, *elem)
   
  Else
    If *this\listHead
      *list = *this\listHead
      found = #False
      While *list
        If *list\Name And PeekS(*list\Name) = PeekS(*elem\Name)
          ; Modify Data
          If *list\Value : FreeMemory(*list\Value) : EndIf
          *list\Value = *elem\Value
         
          found = #True
          Break
        EndIf
       
        *list = *list\Next
      Wend
     
      If found
        FreeMemory(*elem\Name)
        FreeMemory(*elem)
        ProcedureReturn #True
      Else
        ; Else add at start
        *elem\Next = *this\listHead
        *elem\Prev = 0
        *this\listHead\Prev = *elem
        *this\listHead = *elem
      EndIf
    Else
      ; Else insert at start
      *elem\Next = 0
      *elem\Prev = 0
      *this\listHead = *elem
    EndIf
   
    ProcedureReturn #True
  EndIf
 
  ProcedureReturn #False
EndProcedure

Procedure.l FPref__removeElement(*this.cFPref, *elem.FPREFELEM)
  Protected *list.FPREFELEM
 
  If Not *elem Or Not *elem\name Or Not *this\listHead
    FPref__freeElement(*this, *elem)
  Else
    *list = *this\listHead
    While *list
      If *list\name And PeekS(*list\name) = PeekS(*elem\name)
        ; Remove it
        If Not *list\Prev
          *this\listHead = *list\Next
        Else
          *list\Prev\Next = *list\Next
        EndIf
       
        If *list\Next
          *list\Next\Prev = *list\Prev
        EndIf
       
        ProcedureReturn #True
      EndIf
     
      *list = *list\Next
    Wend
  EndIf
 
  ProcedureReturn #False
EndProcedure

Procedure.l FPref__createElement(*this.cFPref, key.s, *mem, len.l)
  Protected *elem.FPREFELEM
 
  *elem = AllocateMemory(SizeOf(FPREFELEM))
  If Not *elem
    FPref__freeElement(*this, *elem)
    ProcedureReturn #False
  EndIf
 
  If Len(key) > 0
    *elem\name = AllocateMemory(StringByteLength(key) + SizeOf(CHARACTER))
    If Not *elem\name
      FPref__freeElement(*this, *elem)
      ProcedureReturn #False
    EndIf
  EndIf
 
  If len > 0 And *mem
    *elem\Value = AllocateMemory(len)
    If Not *elem\Value
      FPref__freeElement(*this, *elem)
      ProcedureReturn #False
    EndIf
  EndIf
 
 
  If Len(key) > 0
    CopyMemory(@key, *elem\name, StringByteLength(key) + SizeOf(CHARACTER))
  EndIf
  If len > 0 And *mem
    CopyMemory(*mem, *elem\Value, len)
  EndIf
 
  ProcedureReturn *elem
EndProcedure

;** fpref_addData
;* adds or modifies data of the key.
;** .key: a key to identify the data
;** .*mem: the memory from which to copy
;** .len: len to copy from *mem
Procedure.l FPref_addData(*this.cFPref, key.s, *mem, len.l)
  Protected *elem.FPREFELEM
 
  *elem = FPref__createElement(*this, key, *mem, len)
 
  If FPref__addElement(*this, *elem)
    ProcedureReturn #True
  Else
    ProcedureReturn #False
  EndIf
EndProcedure

;** fpref_addstring
;* a simplyfied version of addData to add a string
Procedure.l FPref_addString(*this.cFPref, key.s, String.s)
  ProcedureReturn FPref_addData(*this, key, @String, StringByteLength(String) + SizeOf(CHARACTER))
EndProcedure

;** fpref_removedata
;* removes the element identified by the key
Procedure.l FPref_removeData(*this.cFPref, key.s)
  Protected *elem.FPREFELEM
 
  *elem = FPref__createElement(*this, key, 0, 0)
 
  If FPref__removeElement(*this, *elem)
    ProcedureReturn #True
  Else
    ProcedureReturn #False
  EndIf
EndProcedure

;** fpref_getdataptr
;* returns a pointer to the data of the key
Procedure.l FPref_getDataPtr(*this.cFPref, key.s)
  Protected *list.FPREFELEM
 
  If key And *this\listHead
    *list = *this\listHead
    While *list
      If *list\Name And PeekS(*list\Name) = key
        ProcedureReturn *list\Value
      EndIf
     
      *list = *list\Next
    Wend
  EndIf
 
  ProcedureReturn #Null
EndProcedure

;** fpref_getstring
;* returns the string identified by the key_
;* simplified version of getdataptr() with PeekS()_
;* <b>Only works if you really saved a string in this key!</b>
Procedure.s FPref_getString(*this.cFPref, key.s)
  Protected *mem
  *mem = FPref_getDataPtr(*this, key)
  If *mem
    ProcedureReturn PeekS(*mem)
  Else
    ProcedureReturn ""
  EndIf
EndProcedure

;** fpref_clear: deletes all keys
Procedure.l FPref_clear(*this.cFPref)
  Protected *list.FPREFELEM, *nextelem.FPREFELEM
 
  If *this\listHead
    *list = *this\listHead
    While *list
      *nextelem = *list\Next
      FPref__freeElement(*this, *list)
     
      *list = *nextelem
    Wend
   
    *this\listHead = 0
  EndIf
 
  ProcedureReturn #True
EndProcedure

;** fpref_savetofile: saves all keys in the list
;* to a file (binary)
Procedure.l FPref_saveToFile(*this.cFPref, file.s)
  Protected fileID.l, *list.FPREFELEM, len.l
 
  fileID = CreateFile(#PB_Any, file)
  If IsFile(fileID)
    If *this\listHead
      *list = *this\listHead
      While *list
        If *list\name
          len = MemorySize(*list\name)
          WriteLong(fileID, len)
          WriteData(fileID, *list\name, len)
         
          If *list\name
            len = MemorySize(*list\Value)
          Else
            len = 0
          EndIf
          WriteLong(fileID, len)
          If len
            WriteData(fileID, *list\Value, len)
          EndIf
        EndIf
       
        *list = *list\Next
      Wend
    EndIf
    CloseFile(fileID)
    ProcedureReturn #True
  EndIf
 
  ProcedureReturn #False
EndProcedure

;** fpref_loadfromfile: loads a previously saved list
;* from a file. If the list already contains some
;* keys, they will be overwritten (if the same Key.s used)
;* and the new keys will be added. No keys will be removed!
Procedure.l FPref_loadFromFile(*this.cFPref, file.s)
  Protected fileID.l, *elem.FPREFELEM, len.l
 
  fileID = ReadFile(#PB_Any, file)
  If IsFile(fileID)
    While Not Eof(fileID)
      *elem = AllocateMemory(SizeOf(FPREFELEM))
      If Not *elem
        ProcedureReturn #False
      EndIf
     
      len = ReadLong(fileID)
      *elem\name = AllocateMemory(len)
      If *elem\name
        ReadData(fileID, *elem\name, len)
      Else
        FreeMemory(*elem)
        ProcedureReturn #False
      EndIf
     
      len = ReadLong(fileID)
      If len
        *elem\Value = AllocateMemory(len)
        If Not *elem\Value
          FreeMemory(*elem\name)
          FreeMemory(*elem)
          ProcedureReturn #False
        EndIf
        ReadData(fileID, *elem\Value, len)
      EndIf
     
      If Not FPref__addElement(*this, *elem)
        ProcedureReturn #False
      EndIf
    Wend
   
    CloseFile(fileID)
    ProcedureReturn #True
  EndIf
 
  ProcedureReturn #False
EndProcedure

;** fpref_examinedata: Starts examination of all keys in the list
Procedure FPref_examineData(*this.cFPref)
  *this\currentData = 0
EndProcedure

;** fpref_nextdata:
;* Goes to the next key (returns 0 if there is none)
Procedure.l FPref_nextData(*this.cFPref)
  If *this\currentData = 0
    *this\currentData = *this\listHead
  Else
    *this\currentData = *this\currentData\Next
  EndIf
  ProcedureReturn *this\currentData
EndProcedure

;** fpref_currentdataptr
;* returns the dataptr of the current element/key
Procedure.l FPref_currentDataPtr(*this.cFPref)
  If *this\currentData
    ProcedureReturn *this\currentData\Value
  Else
    ProcedureReturn #False
  EndIf
EndProcedure

;** fpref_currentString
;* returns a string of the current element/key.
;* simplified version of currentDataPtr()._
;* <b>Only valid if there is really a string
;* stored in this key!</b>_
;* To be aware of this, you could i. c. add a
;* prefix to all of your keys that identifies
;* of which type the data in this key is. Like:_
;* Key.s = "s CancelButton"
Procedure.s FPref_currentString(*this.cFPref)
  Protected *mem
  *mem = FPref_currentDataPtr(*this)
  If *mem
    ProcedureReturn PeekS(*mem)
  Else
    ProcedureReturn ""
  EndIf
EndProcedure

;** fpref_currentkey
;* returns the key/identifier of the current element/key.
Procedure.s FPref_currentKey(*this.cFPref)
  If *this\currentData
    ProcedureReturn PeekS(*this\currentData\name)
  Else
    ProcedureReturn ""
  EndIf
EndProcedure

DataSection ;[
  cFPref_VT:
  Data.l @FPref_addData(), @FPref_addString(), @FPref_removeData()
  Data.l @FPref_getDataPtr(), @FPref_getString(), @FPref_clear()
  Data.l @FPref_saveToFile(), @FPref_loadFromFile(), @FPref_examineData()
  Data.l @FPref_nextData(), @FPref_currentDataPtr(), @FPref_currentString()
  Data.l @FPref_currentKey()
EndDataSection ;]

Procedure.l new_FPref()
  Protected *this.cFPref
 
  *this = AllocateMemory(SizeOf(cFPref))
  If *this = 0 : ProcedureReturn 0 : EndIf
  *this\vt = ?cFPref_VT
 
  ProcedureReturn *this
EndProcedure

Procedure.l delete_FPref(*this.cFPref)
  FPref_clear(*this)
  FreeMemory(*this)
EndProcedure

; IDE Options = PureBasic v4.00 (Windows - x86)
; CursorPosition = 4
; FirstLine = 4
; Folding = ----
; EnableXP
; HideErrorLog