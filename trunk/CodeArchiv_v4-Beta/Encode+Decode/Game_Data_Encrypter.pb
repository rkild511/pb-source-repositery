; http://www.purebasic-lounge.de
; Author: Kaeru Gaman
; Date: 10. Juny 2006
; OS: Windows, Linux
; Demo: Yes


; *******************************************************************************
; ***
; ***   CODY  0.21    "Base 96/32+RunLength Encrypter"
; ***
; ***   Game-Data-Encrypter
; ***
; ***   by Kaeru Gaman
; ***
; ***   2006-06-10
; ***
; ***   PB 4.0
; ***
; ***   this handy little fellow encrypts every ASCII-Data
; ***   containing ASCII-Codes 32-127
; ***
; *******************************************************************************


; *******************************************************************************
; ***
; ***   following Key is implemented as a Constant
; ***
; ***   only Procedures using the same Key can decrypt each others Data
; ***
; ***   !!! Only Use Values of 0 - 95 !!!
; ***   higher Values will lead to crypting mistakes
; ***
; *******************************************************************************

#CODY_KEY = 42

; *******************************************************************************

Procedure.s CODY_Encrypt_Field( Inp$ )

  Leng.l  =  0    ; Length of Field
  LenCr.l =  0    ; Crypted Length
  Len$    = ""    ; Crypted Length Writechar
  Base.l  =  0    ; Field individual Crypt-Key
  BasCr.l =  0    ; Crypted Crypt-Key
  Bas$    = ""    ; Crypt-Key Writechar
  Crypt$  = ""    ; Encrypted Field
  Char.l  =  0    ; single Char of string

  Outp$   = ""    ; Return-String

  n.l     =  0    ; Loopcounter

  ; *** length
  ; calculate length
  Leng = Len( Inp$ )
  ; cut
  If Leng < 1
    Leng = 1
    Inp$ = " "
  EndIf
  If Leng > 96
    Leng = 96
    Inp$ = Left( Inp$, 96 )
  EndIf
  ; encrypt length
  LenCr = Leng + #CODY_KEY
  If LenCr > 96
    LenCr -96
  EndIf
  ; encode length
  Len$ = Chr( 128 - LenCr )

  ; *** base
  Base = Random( 95 )
  ; encrypt base
  BasCr = Base + #CODY_KEY
  If BasCr > 95
    BasCr - 96
  EndIf
  ; encode base
  Bas$ = Chr( 32+ BasCr )

  ; *** string
  For n=1 To Leng
    Char = Asc( Mid( Inp$, n, 1) ) + Base + n
    ; fit to 96-pattern
    If Char > 127
      Char - 96
    EndIf
    ; if Base + n is very high, we might to do it 2 times
    If Char > 127
      Char - 96
    EndIf
    Crypt$ + Chr( Char )
  Next

  ; return value
  Outp$ = Len$ + Bas$ + Crypt$

  ProcedureReturn Outp$

EndProcedure

; *******************************************************************************

Procedure.s CODY_Decrypt_Field( Inp$ )

  Leng.l  =  0    ; Length of Field
  LenCr.l =  0    ; Crypted Length
  Len$    = ""    ; Crypted Length Writechar
  Base.l  =  0    ; Field individual Crypt-Key
  BasCr.l =  0    ; Crypted Crypt-Key
  Bas$    = ""    ; Crypt-Key Writechar
  Crypt$  = ""    ; Encrypted Field
  Char.l  =  0    ; single Char of string

  Outp$   = ""    ; Return-String

  n.l     =  0    ; Loopcounter

  ; *** length
  Len$ = Mid( Inp$, 1, 1 )
  ; decode length
  LenCr = 128 - Asc( Len$ )
  ; decrypt length
  Leng = LenCr - #CODY_KEY
  If Leng < 1
    Leng + 96
  EndIf

  ; *** base
  Bas$ = Mid( Inp$, 2, 1 )
  ; decode Base
  BasCr = Asc(Bas$) -32
  ; decrypt Base
  Base = BasCr - #CODY_KEY
  If Base < 0
    Base + 96
  EndIf

  ; *** string
  Crypt$ = Mid( Inp$, 3, Leng)
  For n=1 To Leng
    Char = Asc(Mid(Crypt$, n, 1)) - Base - n
    ; fit to 96-pattern
    If Char < 32
      Char + 96
    EndIf
    ; if Base + n is very high, we might to do it 2 times
    If Char < 32
      Char + 96
    EndIf
    Outp$ + Chr( Char )
  Next

  ProcedureReturn Outp$

EndProcedure

; *******************************************************************************

Procedure.s CODY_Write_Field( File_Nr.l, Inp$ )

  Leng.l  =  0    ; Length of already crypted Field
  n.l     =  0    ; Loopcounter

  Leng = Len( Inp$ )

  For n=1 To Leng
    WriteByte( File_Nr, Asc( Mid( Inp$, n, 1 ) ) )
  Next

EndProcedure

; *******************************************************************************

Procedure.s CODY_Read_Field( File_Nr.l )

  Leng.l  =  0    ; Length of Field
  Len$    = ""    ; Crypted Length
  Bas$    = ""    ; Crypt-Key Writechar
  Crypt$  = ""    ; Encrypted Field

  Out$    = ""    ; Return String

  n.l     =  0    ; Loopcounter

  ; *** length
  Len$ = Chr( ReadByte( File_Nr ) )
  ; decode length
  LenCr = 128 - Asc( Len$ )
  ; decrypt length
  Leng = LenCr - #CODY_KEY
  If Leng < 1
    Leng + 96
  EndIf

  ; *** base
  Bas$ = Chr( ReadByte( File_Nr ) )

  ; *** string
  For n=1 To Leng
    Crypt$ + Chr( ReadByte( File_Nr ) )
  Next

  Outp$ = Len$ + Bas$ + Crypt$

  ProcedureReturn Outp$

EndProcedure

; *******************************************************************************
; ***
; ***   Demonstrating / Testing Abilities of CODY
; ***
; ***   Chose ".txt" for easy NotePad access this time
; ***
; ***   any FileNameExtension is suitable
; ***
; *******************************************************************************

FileName$ = "Data.txt"

Dim DatOut$(16)
Dim DatIn$(16)

; *** Read from Data

For n=0 To 16
  Read DatOut$(n)
  Debug DatOut$(n)
Next

FileNumber = 0

Debug "-----------------------"

; *** debug encrypted Data

For n=0 To 16
  DatIn$(n) = CODY_Encrypt_Field( DatOut$(n) )
  Debug DatIn$(n)
Next

Debug "-----------------------"

; *** debug decrypted Data

For n=0 To 16
  DatOut$(n) = CODY_Decrypt_Field( DatIn$(n) )
  Debug DatOut$(n)
Next


; *** write to file

CreateFile( FileNumber, FileName$ )
For n=0 To 16
  Outp$ = CODY_Encrypt_Field( DatOut$(n) )
  CODY_Write_Field( FileNumber, Outp$ )
Next
CloseFile( FileNumber )

Debug "-----------------------"

; *** read and debug crypted File

OpenFile( FileNumber, FileName$ )
Inp$ = ReadString( FileNumber )
Debug Inp$
CloseFile( FileNumber )

Debug "-----------------------"

; *** read and encrypt File

OpenFile( FileNumber, FileName$ )
For n=0 To 16
  Inp$ = CODY_Read_Field( File_Nr.l )
  DatIn$(n) = CODY_Decrypt_Field( Inp$ )
Next
CloseFile( FileNumber )

; *** debug encrypted Data

For n=0 To 16
  Debug DatIn$(n)
Next

; *******************************************************************************

DataSection

  Data.s "Player_Name = Amathusalem"
  Data.s "Strength = 37"
  Data.s "Dexterity = 52"
  Data.s "Vitality = 42"
  Data.s "Luck = 32"
  Data.s "Intelligence = 39"
  Data.s "*"
  Data.s "HighScore-Table"
  Data.s "Tom"
  Data.s "128375"
  Data.s "Dick"
  Data.s "61787"
  Data.s "Harry"
  Data.s "23174"
  Data.s "************"
  Data.s "Da sprach der alte Haeuptling der Indianer"
  Data.s "wild ist der Westen, schwer ist der Beruf"

EndDataSection

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -