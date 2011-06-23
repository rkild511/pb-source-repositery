; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1076&highlight=
; Author: bobobo
; Date: 20. May 2003
; OS: Windows
; Demo: No


;-Mini-Demo MCI-Medienwiedergabe 

mci$="open guitar_sample.mid type sequencer alias mymidi" 
Debug mciSendString_(mci$,Return$,0,0) 

mci$="play mymidi from 10 to 20 wait"        ;das hier spielt nur einen kleinen Teil 10 bis 20 
;mci$="play mymidi wait"   ; abspielen und warten bis fertig 
Debug mciSendString_(mci$,Return$,0,0) 

mci$="close mymidi"                  ;sollte das mci-Zeug wieder zumachen 
Debug mciSendString_(mci$,Return$,0,0) 

Debug "Ach wie schöööön" 
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
