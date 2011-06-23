; ------------------------------------------------------------
; Linked List Quick Sort TEST -  by horst.schaeffer@gmx.net 
; ------------------------------------------------------------

XIncludeFile "QLsort.pbi" ; see more comments 

Structure test
 name.s
 other.l 
EndStructure 

Global NewList TestList.test() 

; This is the startup procedure for the given Linked List 

Procedure SortAlist(*cmp_function)
  Shared *cmp, temp.s, sz
  sz = SizeOf(test)
  temp.s = Space(sz)
  *cmp = *cmp_function
  count = CountList(TestList())
  If count > 1
    FirstElement(TestList()) : *a = @TestList()
    LastElement(TestList()) : *b = @TestList()
    SortListR(*a,*b,count) 
  EndIf 
EndProcedure 

; These are two simple comparison functions: 

Procedure ByNameAscending(*a.test,*b.test) 
  If *a\name <= *b\name : result = #True : EndIf 
ProcedureReturn result 
EndProcedure 

Procedure ByNameDescending(*a.test,*b.test) 
  If *a\name >= *b\name : result = #True : EndIf 
ProcedureReturn result 
EndProcedure 

; ------------------------------------------------------------
;- Test 
; ------------------------------------------------------------

#elements = 10000
e.s = Str(#elements)+ " Elements "
s.s = "Sort time: "

For i = 1 To #elements         ; make a test list
  AddElement(TestList())
  TestList()\name = RSet(Str(Random(100000)),5,"0")
Next

t = GetTickCount_()
SortAlist(@ByNameAscending())  
MessageBox_(0,s +Str(GetTickCount_() -t)+ "ms",e+"random > ascending",0)

t = GetTickCount_()
SortAlist(@ByNameDescending())  
MessageBox_(0,s +Str(GetTickCount_() -t)+ "ms",e+"ascending > descending",0)

TempFile.s = "Sort$$.txt"
CreateFile(0,TempFile)         ; write result as text file 
ResetList(TestList())
While NextElement(TestList())
  WriteStringN(0,TestList()\name)
Wend 
CloseFile(0)

ShellExecute_(0,"open",TempFile,"","",0) ; show with text editor
Delay(2000)
DeleteFile(TempFile)

End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; Executable = C:\Programme\PureBasic\Projects\Test\sort\QLtest.exe
; DisableDebugger