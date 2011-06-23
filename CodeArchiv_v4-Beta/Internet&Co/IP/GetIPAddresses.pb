; German forum: http://www.purebasic.fr/german/viewtopic.php?t=1453&highlight=
; Author: DarkDragon
; Date: 01. January 2004
; OS: Windows
; Demo: Yes

InitNetwork() 

ExamineIPAddresses() 
NextIP = NextIPAddress() 
While NextIP 
  Debug IPString(NextIP) 
  NextIP = NextIPAddress() 
Wend
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -