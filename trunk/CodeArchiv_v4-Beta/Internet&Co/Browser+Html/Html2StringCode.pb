; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2970&highlight=
; Author: opl (updated for PB4.00 by blbltheworm + Andre)
; Date: 29. November 2003
; OS: Windows
; Demo: Yes

; Dieses Programm dient dazu das Erstellen eines Programmcodes zur Ausgabe einer 
; HTML-datei zu erleichtern. 
; Zuerst sollte eine HTML datei mit einem geeignetem Tool erstellt werden, 
; HTML Profis können auch einen Texteditor verwenden ;-). 
; Diese HTML-Datei wird eingelesen und eine Textdatei mit folgendem Inhalt wird ausgegeben: 
; text+"<html>"+Chr(13)+Chr(10) 
; text+""+Chr(13)+Chr(10) 
; text+"<head>"+Chr(13)+Chr(10) 
; ... 
; 
; Anführungszeichen werde durch Chr(34)+"+Chr(34)+"+Chr(34) ersetzt. 
; Jetzt kann man den Zuweisungscode aus der Textdatei kopieren und in das eigentliche 
; Programm einfügen. 
; Danach werde die Stellen an denen das Programm Werte einsetzten soll durch Variablen ersetzt. 
; Es sollte darauf geachtet werden dass bei PureBasic bis v3.94 eine Stringvariable auf 64kB 
; beschränkt ist. 


text$ = "" 
If ReadFile(0,"Datei.htm") 
  Repeat 
    help$=ReadString(0) 
    help$=ReplaceString(help$,Chr(34),Chr(34)+"+Chr(34)+"+Chr(34)) 
    text$ +"text$+"+Chr(34)+help$+Chr(34)+"+Chr(13)+Chr(10)"+Chr(13)+Chr(10) 
  Until Eof(0) 
  CloseFile(0) 
Else 
  MessageRequester("html2string", "Error: Datei kann nicht geöffnet werden", #PB_MessageRequester_Ok) 
  End
EndIf 
  
If CreateFile(0,"Datei.txt") 
  WriteString(0,text$) 
  CloseFile(0) 
Else 
  MessageRequester("html2string", "Error: Datei kann nicht geöffnet werden", #PB_MessageRequester_Ok) 
EndIf 
MessageRequester("html2string","Datei erstellt", #PB_MessageRequester_Ok) 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
