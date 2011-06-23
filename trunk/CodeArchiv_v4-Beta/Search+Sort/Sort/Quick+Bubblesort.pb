; www.PureArea.net 
; Author: Andre (updated for PB4.00 by blbltheworm) 
; Date: 06. April 2003 
; OS: Windows 
; Demo: Yes 
 
 
; Conversion of a BB sourcecode example
; Done by Andre (andre@purebasic.com)
; 06. April 2003


;- Init section
max=10000
Global Dim feld(max)
Global Dim speed(1,10)


;- Functions
Procedure quicksort(s,e)
  i=s
  j=e
  Repeat
    a = i+j
    While feld(i) < feld(a/2)     ; original code ".... < feld((i+j)/2)" must be splitted because of a "Too complex...." error
      i = i+1
    Wend
    a = i+j
    While feld(j) > feld(a/2)
      j = j-1
    Wend
    If i <= j
      tmp = feld(i)
      feld(i) = feld(j)
      feld(j) = tmp
      i = i+1
      j = j-1
    EndIf
  Until i > j
  If j > s  :  quicksort(s,j)  : EndIf
  If i < e  :  quicksort(i,e)  : EndIf
EndProcedure


Procedure bubblesort(s,e)
  For i = s To e-1
    For j = i+1 To e
      If feld(i) > feld(j)
        tmp = feld(i)
        feld(i) = feld(j)
        feld(j) = tmp
      EndIf
    Next
  Next
EndProcedure

;- Start output
OpenConsole()
EnableGraphicalConsole(1)
PrintN("Now Quicksort begins...")

;- Quicksort use
For t=1 To 10
  For i=0 To max
    feld(i)=Random(max)
  Next
  
  t1=GetTickCount_()         ; Windows API call to millisecs since system start
  quicksort(0,1000*t)
  t2=GetTickCount_()
  speed(0,t)=t2-t1
Next

PrintN("Quicksort finished.")
PrintN("Now Bubblesort begins...")


;- Bubblesort use
For t=1 To 10
  For i=0 To max
    feld(i)=Random(max)
  Next
  t1=GetTickCount_()         
  bubblesort(0,1000*t)
  t2=GetTickCount_()
  speed(1,t)=t2-t1
Next

PrintN("Bubblesort finished.")
PrintN("")
Print("Press Return to show results....")
Input()
ClearConsole()

;- Show results
ConsoleLocate(1,1)
ConsoleColor(7,0)
Print("Lines")
ConsoleLocate(15-4,1)
ConsoleColor(14,0)
Print("Quick [ms]")
ConsoleLocate(30-4,1)
ConsoleColor(11,0)
Print ("Bubble [ms]")
PrintN("")
For i=1 To 10
  ConsoleColor(7,0)
  ConsoleLocate(1,1+i)
  Print(Str(i*1000))
  ConsoleColor(14,0)
  ConsoleLocate(15,1+i)
  Print(Str(speed(0,i)))
  ConsoleColor(11,0)
  ConsoleLocate(30,1+i)
  Print(Str(speed(1,i)))
Next
PrintN("") : PrintN("")
ConsoleColor(7,0)
Print("Press return to exit...")
Input()
CloseConsole()
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger