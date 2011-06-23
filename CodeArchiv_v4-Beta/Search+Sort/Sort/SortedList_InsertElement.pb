; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7503&highlight=
; Author: GPI (updated for PB4.00 by blbltheworm)
; Date: 14. September 2003
; OS: Windows
; Demo: Yes

Global NewList var.STRING() 
Procedure find_var(*Name.BYTE) 
  ResetList(var()) 
  half=CountList(var())>>1 
  If half 
    SelectElement(var(),half) 
    pos=half 
    quit=0 
  Else 
    pos=0 
    If NextElement(var())=0 
      quit=2 
    Else 
      quit=0 
    EndIf 
  EndIf 
  oldcompare=0 
  While quit=0 
    compare=CompareMemoryString(*Name,@var()\s,1) 
    If half 
      Select compare 
        Case -1:half>>1:pos-half:SelectElement(var(),pos) 
        Case 0:quit=1 
        Case 1:half>>1:pos+half:SelectElement(var(),pos) 
      EndSelect 
    Else 
      If compare=0 
        quit=1 
      ElseIf compare=oldcompare Or oldcompare=0 
        oldcompare=compare 
        If compare=-1 
          If PreviousElement(var())=0 
            ResetList(var()) 
            quit=2 
          EndIf 
        Else 
          If NextElement(var())=0 
            LastElement(var()) 
            quit=2 
          EndIf 
        EndIf 
      Else 
        If oldcompare=1 
          If PreviousElement(var())=0 
            ResetList(var()) 
          EndIf 
        EndIf 
        quit=2 
      EndIf 
    EndIf    
  Wend 
  If quit=2 
    ProcedureReturn 0 
  Else 
    ProcedureReturn 1 
  EndIf  
EndProcedure 
Procedure ADD_Element(a$) 
  find_var(@a$) 
  AddElement(var()) 
  var()\s=a$ 
EndProcedure 

ADD_Element("hallo") 
ADD_Element("adfa") 
ADD_Element("2345") 
ADD_Element("uioa") 
ADD_Element("23jlk") 
ADD_Element("osad") 
ResetList(var()) 
While NextElement(var()) 
  Debug var()\s 
Wend 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
