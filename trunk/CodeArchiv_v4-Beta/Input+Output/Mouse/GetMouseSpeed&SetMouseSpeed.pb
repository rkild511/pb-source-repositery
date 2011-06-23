; German forum: http://www.purebasic.fr/german/viewtopic.php?t=2880&postdays=0&postorder=asc&start=10
; Author: Leo (two examples combined by Andre)
; Date: 09. April 2005
; OS: Windows
; Demo: No


; Get and set speed of the mouse cursor
; Geschwindigkeit des Mauszeigers ermitteln und setzen

Procedure GetMouseSpeed() 
  #SPI_GETMOUSESPEED = 112 
  SystemParametersInfo_(#SPI_GETMOUSESPEED, #Null, @MSBuffer, #Null) 
  ProcedureReturn MSBuffer 
EndProcedure 

Procedure SetMouseSpeed(Speed)   ; Speed: 10 Default, 1 Minimum, 20 Maximum 
  #SPI_SETMOUSESPEED = 113 
  #SPIF_SENDCHANGE = 2 
  ProcedureReturn SystemParametersInfo_(#SPI_SETMOUSESPEED, #Null, Speed, #SPIF_SENDCHANGE) 
EndProcedure 


speed = GetMouseSpeed() 
Debug "Actual mouse speed is:"
Debug speed


Debug "Setting mouse speed to highest speed"
SetMouseSpeed(20) 


Debug "OK, waiting some secs..."
Delay(10000)


Debug "Setting mouse speed back to old speed now"
SetMouseSpeed(speed)

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -