; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7204&highlight=
; Author: gnozal
; Date: 12. August 2003
; OS: Windows
; Demo: No

TZInfo.TIME_ZONE_INFORMATION 
; Bias 
; (LONG) Current Bias relative To UCT 
; ! Bias is the number of minutes added To the local time To get GMT. 
; ! Therefore, If Bias is 360, this indicates that we are 6 hours 
; ! (360 minutes) _behind_ GMT (- 0600 GMT).  
; StandardName 
; (WCHAR 32]) Name of standard time zone in Unicode 
; StandardDate 
; (SYSTEMTIME) Date And time when standard time begins in UTC 
; StandardBias 
; (LONG) Offset from UCT of standard time 
; DaylightName 
; (WCHAR 32])Name of daylight saving time zone 
; DaylightDate 
; (SYSTEMTIME) Date And time when daylight saving time begins in UTC 
; DaylightBias 
; (LONG) Offset from UCT of daylight time 

GetTimeZoneInformation_(TZInfo) 
Debug TZInfo\Bias ; Time zone 
Debug TZInfo\DaylightBias ; Summer / Winter ? 

TotalBias.l = TZInfo\Bias + TZInfo\DaylightBias 

GMTInfo.s = Right("00" + Str(Abs(TotalBias) / 60), 2) + "00 GMT" 
If TotalBias > 0 : GMTInfo = " -" + GMTInfo : Else : GMTInfo = " +" + GMTInfo : EndIf 

Debug GMTInfo ; <----- GMT correction 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
