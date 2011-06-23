; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6806&highlight=
; Author: Lance Jepsen
; Date: 04. July 2003
; OS: Windows
; Demo: Yes

; How many times have you used a program that popped up a nice holiday message?
; You can very easily add this functionality To your program. Remember, this
; works only for hard coded date holidays (holidays that are on a specific date
; as opposed to "third Thursday" of the month).

date$ = FormatDate("%mm/%dd", Date())

If date$="01/01"
  MessageRequester("Title", "Happy New Year!", 0)
EndIf

If date$="02/14"
  MessageRequester("Title", "Happy Valentines Day!", 0)
EndIf

If date$="03/17"
  MessageRequester("Title", "Happy St. Patricks Day!", 0)
EndIf

If date$="07/04"
  MessageRequester("Title", "Happy 4th of July!", 0)
EndIf

If date$="11/11"
  MessageRequester("Title", "Happy Veterans Day", 0)
EndIf

If date$="12/25"
  MessageRequester("Title", "Merry Christmas", 0)
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
