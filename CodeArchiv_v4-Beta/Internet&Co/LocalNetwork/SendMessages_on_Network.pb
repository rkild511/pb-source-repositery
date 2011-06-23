; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6898&highlight=
; Author: Rings (updated for PB3.93 by ts-soft, updated for PB 4.00 by Andre)
; Date: 14. July 2003
; OS: Windows
; Demo: No


; Rings:
; english: I do not know if this works under Win89, but its a cool way to send
;          messages over the network.
;          => on older machines, you need to run "winpopup" to see the messages
;             (NT/Win2000/XP have it built in)
; german:  Einfach Nachrichten über das Netzwerk verschicken. Hab leider keine Ahnung
;          ob das hier unter Win89 funktioniert, NT und W2K funktionieren tadellos. 

Sender.s="srings";Source (ME) 

Reciepent.s="Ringsnb2" ;Destination, here my Notebook 
Reciepent.s="*" ;BroadCast to all in network :) 

Message.s="This is a Testmessage ! " ;The Message 

Needed=Len(Sender.s)+Len(Reciepent.s)+Len(Message.s)+4 ;Calculate the needed Memory 
buff = AllocateMemory(Needed);and allocate them 
If buff 
;Set the Data to our buffer 
PokeS(buff,Sender) 
PokeS(buff+Len(Sender.s)+1,Reciepent.s) 
PokeS(buff+Len(Sender.s)+Len(Reciepent)+2,Message.s) 

SlotName.s = "\\" + Reciepent.s + "\mailslot\messngr" 
hFile = CreateFile_(@SlotName.s, #GENERIC_WRITE, #FILE_SHARE_READ, 0, #OPEN_EXISTING, #FILE_ATTRIBUTE_NORMAL, 0) 
byteswritten.l=0 
If hFile 
  Result=WriteFile_(hFile, buff, Needed, @byteswritten, 0) 
  If Result 
   MessageRequester("Info","Message written  to "+SlotName.s+" : "+ Str(byteswritten),0) 
  EndIf      
  CloseHandle_(hFile) 
Else 
  MessageRequester("Info","problem with Slotname:"+SlotName.s,0);Error 
EndIf 
FreeMemory(buff);Free Memory 
EndIf  

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -