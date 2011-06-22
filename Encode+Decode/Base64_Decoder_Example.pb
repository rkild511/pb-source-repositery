; German forum: http://robsite.de/php/pureboard/viewtopic.php?t=2094&highlight=
; Author: qbcafe
; Date: 25. August 2003


; Hinweis zur Anwendung:
; ----------------------
; Wenn die Größe der Originaldatei bekannt ist - wie in diesem Fall - dann folgende Zeilen benutzen:
  ;  WriteData(UseMemory(1), OrigLen) 
 
; Ansonsten die Länge auf Maximum setzen (ergibt evtl. nen Haufen Nullbytes am Ende der Datei)
; und folgende Zeile stattdessen verwenden:
  ;  WriteData(UseMemory(1), outbufferlength) 
 

Procedure Base64Decoder(b64in$, b64len.l ,*b64out, b64max.l) 
  *b64in.l = @b64in$ ; <- put this in to use a string as parameter 
  ;convert tables 
  For b64x = 0 To 255 
    b64asc$ = b64asc$ + Right("0000000" + Bin(b64x),8) + "|"                    ;ASC Binary Code 
  Next b64x 
  
  b64tab$ = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=" ;base64 Code 
  RtlFillMemory_(*b64out,b64max,0) 
  
  ;decode 
  b64tln = b64len / 4 
  
  For b64xln.l = 0 To b64tln -1 
    b64bcd$ = PeekS(*b64in+b64xln*4,4) 
    
    b64bin$ = "" 
    b64pad = 0 
    For b64xb = 1 To 4 
      b64tcd$ = Mid(b64bcd$,b64xb,1) 
      b64num = FindString(b64tab$,b64tcd$,0)        ;base64 to 6 Bit-Code 
      If b64num > 0 
        If b64num = 65 
          b64pad +1 
        EndIf 
        b64bin$ +Right("000000" + Bin(b64num-1),6)   ;24 Bit code 
      Else 
        b64err = 1 
        b64xln = b64tln +1 
      EndIf 
    Next b64xb 
    
    For b64xu = 0 To 2-b64pad 
      b64bit$ = Mid(b64bin$,1+b64xu*8,8) + "|" 
      b64num = FindString(b64asc$,b64bit$,0) /9     ;ASC Code 8 Bit Binary 
      PokeS(*b64out+b64buf,Chr(b64num)) 
      b64buf +1 
      If b64buf >b64max 
        b64err = 1 
        b64xln = b64tln +1 
      EndIf 
    Next b64xu 
    
  Next b64xln 
  
  If b64err = 1 
    RtlFillMemory_(*b64out,b64max,0) 
    b64buf = -1 
  EndIf 
  ProcedureReturn b64buf 
EndProcedure 



file.s = OpenFileRequester("Select file", ".\", "*.*|*.*",0) 
If file = ""  
  End 
  
EndIf 

If ReadFile(0, file) 
  inbufferlength.l = Lof():OrigLen.l = inbufferlength 
  Debug inbufferlength 
  If AllocateMemory(0, inbufferlength) 
    outbufferlength.l = inbufferlength + inbufferlength/3 + 64 
    Debug "outbuff= "+Str(outbufferlength)+", inbuff= "+Str(inbufferlength) 
    If AllocateMemory(1, outbufferlength, 0) 
      ReadData(UseMemory(0), inbufferlength) 
      Base64Encoder(UseMemory(0),inbufferlength, UseMemory(1), outbufferlength) 
      If CreateFile(1, "encodedfile.txt") 
        WriteString(PeekS(UseMemory(1))) 
        CloseFile(1)      
      Else 
        Debug "Failed to create file" 
      EndIf 
      FreeMemory(1)    
    Else      
      Debug "Memory allocation failed (1)"    
    EndIf    
    FreeMemory(0)  
  Else    
    Debug "Memory allocation failed (0)."  
  EndIf  
  CloseFile(0) 
Else  
  Debug "failed to read file" 
EndIf 

ReadFile(0,"encodedfile.txt") 
  inbufferlength =Lof():outbufferlength = inbufferlength 
  AllocateMemory(0,inbufferlength,0) 
  AllocateMemory(1,outbufferlength,0) 
  ReadData(UseMemory(0), inbufferlength) 
  Code$ = Space(inbufferlength) 
  CopyMemory(UseMemory(0), @Code$, inbufferlength) 
  Base64Decoder(Code$, inbufferlength, UseMemory(1),outbufferlength) 
  OpenFile(1,"decodedfile.txt") 
;   WriteData(UseMemory(1), outbufferlength) 
  WriteData(UseMemory(1), OrigLen) 
  CloseFile(1) 
CloseFile(0) 

; ExecutableFormat=Windows
; FirstLine=1
; EOF