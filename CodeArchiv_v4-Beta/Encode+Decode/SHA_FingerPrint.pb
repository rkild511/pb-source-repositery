; German forum: http://www.purebasic.fr/german/viewtopic.php?t=1385&highlight=
; Author: andi256 (updated for PB 4.00 by Andre + Helle)
; Date: 29. December 2004
; OS: Windows
; Demo: Yes

; SHA Algorithmus
; ------------------
; Fingerabdruck (Hashcode) von Daten. Dieser Code hat die Eigenschaft, nicht
; zurückgerechnet werden zu können. Also aus dem Fingerabdruck (zB MD5 oder
; SHA-1) kann der ursprüngliche Datensatz nicht zurückgerechnet werden.

; Das schöne ist, dass auch nur ein verändertes Bit am Ursprungsdatensatz den
; Fingerabdruck stark und fast nicht vorherzusehen verändert. Demnach kann
; man die Integrität von z.B. Dateien etc. testen (Erweiterung dazu ist die
; Digitale Signatur, in der Hashcodes auch eine grosse Rolle spielen).
; Desweiteren kann man Passwörter nur als Fingerabdruck speichern (also nur
; den Hashcode) und später so vorgehen, dass man das eingegebene Passwort
; durch den Hash-Algorithmus jagt und dann das Ergebnis mit dem gespeicherten
; Hash vergleicht. Somit kann man feststellen, ob es das selbe Passwort war.
; Allerdings ist das Passwort selbst nicht wiederherstellbar oder
; herauszufinden und demnach sehr sicher verpackt.

; Weitere Info's zu SHA-1:
; http://de.wikipedia.org/wiki/SHA-1


Global Dim state.l(4)
Global Dim magic.l(4)
Global Dim w.l(80)

Procedure UpeekB(*mem)
  ProcedureReturn Val(StrU(PeekB(*mem),#Byte))
EndProcedure

Procedure.s speicherout_hex(*mem,l,q$)
  For i = 0 To l-1
    q$ = q$ + RSet(Hex(UPeekB(*mem+i)),2,"0") + " "
  Next i
  ProcedureReturn q$
EndProcedure

Procedure toLE(value)
  dummy1 = ((value >> 24) & $FF)
  dummy2 = ((value >> 8) & $FF00)
  dummy3 = ((value & $FF) << 24)
  dummy4 = ((value & $FF00) << 8)
  dummy5 = dummy1 |dummy2 |dummy3 |dummy4
  ProcedureReturn dummy5
EndProcedure

Procedure RotL(num,count) ; rotate left
  If count>0 And count<32
    !MOV dword ECX,[p.v_count]
    !ROL dword [p.v_num],cl
  EndIf
  ProcedureReturn num
EndProcedure

Procedure f(round,x,y,z)
  If round < 20
    dummy = ( x & y ) | ( ~x & z )
  Else
    If round < 40
      dummy = ( x ! y ! z )
    Else
      If round < 60
        dummy = ( x & y ) | ( x & z ) | ( y & z )
      Else
        dummy = ( x ! y ! z )
      EndIf
    EndIf
  EndIf
  ProcedureReturn dummy
EndProcedure

Procedure SHA_1(*digest,*buf,len,pad,ende)

  magic(0) = $5A827999
  magic(1) = $6ED9EBA1
  magic(2) = $8F1BBCDC
  magic(3) = $CA62C1D6

  *databuf = AllocateMemory(64)

  state(0) = $67452301
  state(1) = $EFCDAB89
  state(2) = $98BADCFE
  state(3) = $10325476
  state(4) = $C3D2E1F0

  blocks = (len + 3 + 63) >> 6
  bytes_left = len
  If (pad|ende) = #True
    len=0
    Debug "len : " +Str(len)
  EndIf

  For i=0 To blocks-1
    If bytes_left >= 64
      CopyMemory(*buf,*databuf, 64)
      buf = buf + 64
      bytes_left = bytes_left - 64
    Else
      j=0
      If bytes_left > 0
        CopyMemory(*buf,*databuf,bytes_left)
        j = bytes_left
      EndIf
      If bytes_left >= 0
        PokeB(*databuf+j,Ende)
        j = j + 1
        bytes_left = -1
      EndIf
      For  j = j To 61
        PokeB(*databuf+j,pad)
      Next j

      If j=62
        dummy = ((8*len) >> 8) & $FF
        PokeB(*databuf+62,dummy)
        j = j + 1
      EndIf
      If j=63
        dummy = (8*len) & $FF
        PokeB(*databuf+63,((8*len) & $FF))
      EndIf
    EndIf

    CopyMemory(*databuf,@w(0),64)

    For j=0 To 15
      w(j)= toLE(w(j))
    Next j

    For j=16 To 79
      w(j) = RotL(w(j-3) ! w(j-8) ! w(j-14) ! w(j-16),1)
    Next j

    a = state(0)
    b = state(1)
    c = state(2)
    d = state(3)
    e = state(4)

    For j=0 To 79
      t= RotL(a,5) + f(j,b,c,d) + e + w(j) + magic(j/20)
      e = d
      d = c
      c= RotL(b,30)
      b = a
      a = t
    Next j

    state(0) = state(0) + a
    state(1) = state(1) + b
    state(2) = state(2) + c
    state(3) = state(3) + d
    state(4) = state(4) + e


  Next i

  state(0) = toLE(state(0))
  state(1) = toLE(state(1))
  state(2) = toLE(state(2))
  state(3) = toLE(state(3))
  state(4) = toLE(state(4))

  CopyMemory(@state(0),*digest,20)

EndProcedure

OpenConsole()

Input.s = "abc"
*digest = AllocateMemory(19)

sha_1(*digest,@input,3,0,$80)
PrintN(speicherout_hex(*digest,20,"ist   : "))

PrintN ("soll  : A9 99 3E 36 47 06 81 6A BA 3E 25 71 78 50 C2 6C 9C D0 D8 9D")
Input()
CloseConsole()

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = --
; DisableDebugger