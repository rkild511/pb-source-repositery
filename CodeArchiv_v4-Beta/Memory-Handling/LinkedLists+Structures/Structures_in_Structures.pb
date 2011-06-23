; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7288&highlight=
; Author: spangly (updated for PB 4.00 by Andre)
; Date: 20. August 2003
; OS: Windows
; Demo: Yes


; Example for using structures in structures

Structure COUNTRY 
  name.s 
  month.s 
  number_of_users.s 
  national_cost.f 
  international_cost.f 
  roaming_cost.f 
  subscription_cost.f 
  other_cost.f 
  total_cost.f 
EndStructure 

Structure DATAFILE_STATS 
  filename.s 
  filesize.l 
  number_of_countries.w 
  COUNTRY_INFO.COUNTRY[20] 
EndStructure 

Global CURRENT_DATAFILE_STATS.DATAFILE_STATS 

CURRENT_DATAFILE_STATS\COUNTRY_INFO[6]\name="Country" 


; Example output:
Debug CURRENT_DATAFILE_STATS\COUNTRY_INFO[6]\name

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
