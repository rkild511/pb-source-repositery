;*****************************************************************************
;* PurePunch Contest 
;* http://www.purebasic.fr/english/viewtopic.php?p=256341#256341
;*
;* Name   : starfield console
;* Author : Dobro
;* Date   : Dim 24/Aoû/2008
;* Link   : http://www.purebasic.fr/french/viewtopic.php?p=86756#86756
;*
;*****************************************************************************

EcranX=80:EcranY=25:#dobro =1:#Police =1:SSum.l = 80000 :Cspeed.f=1:CameraZ.f=0:Gosub InitStarField:OpenConsole (): EnableGraphicalConsole (1):Repeat: ConsoleLocate (0, 0): Print ( "appuis sur return pour quitter , patientez 12 secondes pour voir l'effet" ): Gosub DrawStarField: Gosub MoveCamera
ClearConsole ():Until GetAsyncKeyState_ ( #VK_RETURN ):CloseConsole () :InitStarField: Structure a3DStar: x.f: y.f: z.f :EndStructure:Dim Stars.a3DStar(SSum):For dummy = 0 To SSum: Stars(dummy)\x = Random (10000)-5000: Stars(dummy)\y = Random (10000)-5000: Stars(dummy)\z = 100 + Random (1000):Next dummy:Return
MoveCamera :If CameraZ>1000: Direction=-1:ElseIf CameraZ<-1000: Direction=1:EndIf:If Direction=1 And Cspeed<30: Cspeed=Cspeed+0.1:ElseIf Direction=-1 And Cspeed>-30: Cspeed=Cspeed-0.1:EndIf:CameraZ = CameraZ +Cspeed:Return
DrawStarField:For dummy = 0 To SSum: If Stars(dummy)\z<CameraZ: Stars(dummy)\z= CameraZ +1000: ElseIf Stars(dummy)\z>( CameraZ +1000): Stars(dummy)\z= CameraZ: EndIf: sx = Stars(dummy)\x / (Stars(dummy)\z- CameraZ )*100+EcranX/2: sy = Stars(dummy)\y / (Stars(dummy)\z- CameraZ )*100+EcranY/2: If sx<EcranX And sy<EcranY And sx>0 And sy>0
            b.f = 15-(((Stars(dummy)\z)- CameraZ )*(15/1000.)): c= Int (b): coul = Random (14)+1: ConsoleColor (coul,0): ConsoleLocate (sx, sy): Print ( "*" ):
EndIf:Next dummy:Return 
