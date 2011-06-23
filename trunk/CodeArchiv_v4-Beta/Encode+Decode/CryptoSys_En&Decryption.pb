; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7139&highlight=
; Author: Leo
; Date: 07. August 2003
; OS: Windows
; Demo: Yes


; Example for using the CryptoSys DLL. Its free to download from
; http://www.di-mgt.com.au/crypto.html (for personal use).
; Supported algorithms are DES, AES, Blowfish etc.
; And soon PKI/RSA. 

Input$="0300000000000000" 
Output$="0000000000000000" 
Key$="0000000000000070" 
If OpenLibrary(10, "dicryptosys.dll") 
  R.l=CallFunction(10, "DES_Hex",@Output$,@Input$,@Key$,0) 
  If R.l=0 
    MessageRequester("Information", "Encrypt : "+Output$, 0) 
  Else 
    MessageRequester("Information", "Error : "+Str(R.l), 0) 
  EndIf 
  R.l=CallFunction(10, "DES_Hex",@Input$,@Output$,@Key$,1) 
  If R.l=0 
    MessageRequester("Information", "Decrypt : "+Input$, 0) 
  Else 
    MessageRequester("Information", "Error : "+Str(R.l), 0) 
  EndIf 
Else 
  MessageRequester("Information", "Could not open dicrypto.dll", 0) 
EndIf    
 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
