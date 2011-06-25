;*****************************************************************************
;* PurePunch Contest 
;* http://www.purebasic.fr/english/viewtopic.php?p=256341#256341
;*
;* Name   : scroll text sinuzoidale en mode console 
;* Author : Dobro
;* Date   : Dim 24/Aoû/2008
;* Link   : http://www.purebasic.fr/french/viewtopic.php?p=86758#86758
;*
;*****************************************************************************

Global PosX:Global PosY:Global x.f = 85 : Global y.f =5:Global vx.f = 1:Global vy.f = -4:Global Pas.f=0.2:Declare  Ondulation_console(x,y,Texte.s,r,v,b) 
#HauteurSin = 2:#LargeurSin = 5 :#VitesseAngle =  1 * #PI / 5:#Vitesse = 100 :Global angle.f, FontID,   long_text_bas
OpenConsole():EnableGraphicalConsole(1):Repeat : Texte.s= " joyeux Pure Punch :D !!!": x=x-0.5 :If x<-30:x=85:EndIf: Ondulation_console(x,y,Texte.s,255,255,0) : Delay(#Vitesse) :Until GetAsyncKeyState_(#VK_RETURN) :CloseConsole()
Procedure Ondulation_console(x,y,Texte.s,r,v,b)  :  ClearConsole(): ConsoleLocate(0, 0): Print("appuis sur Return pour quitter"): angle + #VitesseAngle : If angle >= 2 * #PI: angle = 0: EndIf :  PosX = 1: For n = 1 To Len(Texte) : Lettre.s = Mid(Texte, n, 1) : PosY = 10 + #HauteurSin * Sin(angle + PosX / #LargeurSin)
Resultat = ConsoleColor( 10, 0): ConsoleLocate(x+PosX, y+PosY): Print(Lettre): Resultat = ConsoleColor( 2, 0): ConsoleLocate(x+PosX, y+PosY-1): Print(Lettre): PosX +1: Next n : EndProcedure
