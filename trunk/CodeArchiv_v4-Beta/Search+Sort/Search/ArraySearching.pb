; www.PureArea.net
; Author: Andre
; Date: 05. April 2003
; OS: Windows
; Demo: Yes


;- Information
; This little routine is a BB conversion ;-)
; for fast searching in large sorted arrays (containing numeric values)
; done by Andre (andre@purebasic.com)
; 5. April 2003

;- Declare variables
high=0       ; high element of search
low=0        ; low element of search
middle=0     ; middle value of search
oldmiddle=0  ; used to check if the value couldn't be found
value=0      ; the value to search for
asize=0      ; the size of the array
done=0       ; flag to see if we have finished the search

;- Settings
show.b = 0   ; if value = 1, then all array values are printed to the console window, else not

;- OpenConsole
OpenConsole()

;- Get informations
Print("How many elements would you like in the array?: ")
asize=Val(Input())
low=0
high=asize-1

PrintN("")
Print("What value would you like to search for in the array?: ")
value=Val(Input())
PrintN("")

;- Security check
If asize=0 Or value=0
  PrintN("Value(s) are missing, program will exit...")
  Input()
  End
EndIf

;- Build array values
Dim array(asize)     ; dim the array to be searched
; the following routine does fill the array with precalculated values, change this to your own loading routine etc.
For i=0 To asize-1   ; fill the array from first to last element, for filling backwards use this code: For i=asize-1 To 0 Step -1
  array(i)=i*(2+i)   ; fill each element with a strange number, change it to whatever you want 
  If show = 1
    PrintN("Value of array("+Str(i)+") is: "+Str(array(i)))  ; list all the values
  EndIf  
Next


;- Search routine
PrintN("Searching for "+Str(value))

Repeat
  middle=(high + low) / 2   ; find the middle value
  PrintN("Middle is "+Str(array(middle))) ; print the value of middle for 'debug' purposes 

  If oldmiddle=middle ; If oldmiddle has equaled middle for more than one loop, then we know that the element couldn't be found
    PrintN("The value is not stored in any element in this array")
    done=1            ; tell the loop that we are done and to leave
  EndIf

  oldmiddle=middle    ; store a value for oldmiddle, used to see if we couldn't find the value

  If array(middle)=value
    PrintN("Found it in element "+Str(middle))   ; found the value 
  EndIf
  If value<array(middle)
    high=middle       ; if the middle is too high, then reset high to middle 
  ElseIf value>array(middle)
    low=middle        ; or if the middle is too low, then reset low to middle 
  EndIf
Until array(middle)=value Or done=1  ; loop until the middle value is equal to the value we specified or done is true 


;- Finish program
PrintN("Press return...")
Input()
CloseConsole()

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -