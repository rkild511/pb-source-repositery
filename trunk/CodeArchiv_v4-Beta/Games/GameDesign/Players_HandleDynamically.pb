; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8836&highlight=
; Author: freak
; Date: 23. December 2003
; OS: Windows
; Demo: Yes

Structure PlayerStruct 
  x.l 
  y.l 
  Whatever.l 
EndStructure 

NewList Player.PlayerStruct()  ; this creates the list, only needed once at start 

; now, to add a player: 
AddElement(Player()) 
Player()\X = 20 
Player()\Y = 100 
;... 

; to select the current player, you can use: 
SelectElement(Player(), ListIndex) 

; or loop through them all, simply with 
ForEach Player() 
  Debug Player()\X 
Next Player() 

; to remove the current player: 
DeleteElement(Player()) 

; clear the list: 
ClearList(Player()) 

; count the players: 
NumPlayers = CountList(Player())
Debug NumPlayers 
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
