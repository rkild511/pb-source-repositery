; English forum: http://www.purebasic.fr/english/viewtopic.php?t=5289&highlight=greek
; Author: GPI
; Date: 03. March 2003
; OS: Windows
; Demo: No

LangInf= GetUserDefaultLCID_()
langId_main=langInf&$FF
langId_sub=(langinf&$ff>>8)&$ff

lan$="":sub$=""

Select langid_main
  Case $00: lan$="Neutral"
    Select langid_sub
      Case $01: sub$="Default"
      Case $02: sub$="System Default"
    EndSelect
  Case $01: lan$="Arabic"
    Select langid_sub
      Case $01: sub$="Arabia"
      Case $02: sub$="Iraq"
      Case $03: sub$="Egypt" 
      Case $04: sub$="Libya" 
      Case $05: sub$="Algeria" 
      Case $06: sub$="Morocco" 
      Case $07: sub$="Tunisia" 
      Case $08: sub$="Oman" 
      Case $09: sub$="Yemen" 
      Case $10: sub$="Syria" 
      Case $11: sub$="Jordan" 
      Case $12: sub$="Lebanon" 
      Case $13: sub$="Kuwait" 
      Case $14: sub$="U.A.E." 
      Case $15: sub$="Bahrain"
      Case $16: sub$="Qatar"
    EndSelect
  Case $02: lan$="Bulgarian"
  Case $03: lan$="Catalan"  
  Case $04: lan$="Chinese"
    Select langid_sub
      Case $01: sub$="Traditional"
      Case $02: sub$="Simplified"
      Case $03: sub$="Hong Kong SAR, PRC"
      Case $04: sub$="Singapore"
      Case $05: sub$="Macau"
    EndSelect
  Case $05: lan$="Czech"
  Case $06: lan$="Danish" 
  Case $07: lan$="German" 
    Select langid_sub
      Case $01: sub$=""
      Case $02: sub$="Swiss"
      Case $03: sub$="Austrian"
      Case $04: sub$="Luxembourg"
      Case $05: sub$="Liechtenstein"
    EndSelect
  Case $08: lan$="Greek" 
  Case $09: lan$="English"
    Select langid_sub
      Case $01: sub$="US"
      Case $02: sub$="UK"
      Case $03: sub$="Australian"
      Case $04: sub$="Canadian"
      Case $05: sub$="New Zealand"
      Case $06: sub$="Ireland"
      Case $07: sub$="South Africa"
      Case $08: sub$="Jamaica"
      Case $09: sub$="Caribbean"
      Case $0a: sub$="Belize"
      Case $0b: sub$="Trinidad" 
      Case $0c: sub$="Zimbabwe"
      Case $0d: sub$="Philippines"
    EndSelect
  Case $0a: lan$="Spanish"
    Select langid_sub
      Case $01: sub$="Castilian" 
      Case $02: sub$="Mexican" 
      Case $03: sub$="Modern"
      Case $04: sub$="Guatemala"
      Case $05: sub$="Costa Rica"
      Case $06: sub$="Panama"
      Case $07: sub$="Dominican Republic"
      Case $08: sub$="Venezuela"
      Case $09: sub$="Colombia"
      Case $0a: sub$="Peru"
      Case $0b: sub$="Argentina"
      Case $0c: sub$="Ecuador"
      Case $0d: sub$="Chile"
      Case $0e: sub$="Uruguay"
      Case $0f: sub$="Paraguay" 
      Case $10: sub$="Bolivia"
      Case $11: sub$="El Salvador"
      Case $12: sub$="Honduras"
      Case $13: sub$="Nicaragua"
      Case $14: sub$="Puerto Rico"
    EndSelect
  Case $0b: lan$="Finnish" 
  Case $0c: lan$="French" 
    Select langid_sub
      Case $01: sub$="" 
      Case $02: sub$="Belgian"
      Case $03: sub$="Canadian"
      Case $04: sub$="Swiss"
      Case $05: sub$="Luxembourg"
      Case $06: sub$="Monaco"
    EndSelect
  Case $0d: lan$="Hebrew" 
  Case $0e: lan$="Hungarian" 
  Case $0f: lan$="Icelandic" 
  Case $10: lan$="Italian"
    If langid_sub=$02: sub$="Swiss" :EndIf
  Case $11: lan$="Japanese" 
  Case $12: lan$="Korean" 
  Case $13: lan$="Dutch"
    If langid_sub=$02: sub$="Belgian" :EndIf
  Case $14: lan$="Norwegian"
    Select langid_sub
      Case $01: sub$="Norwegian"
      Case $02: sub$="Nynorsk"
    EndSelect
  Case $15: lan$="Polish" 
  Case $16: lan$="Portuguese"
    If langid_sub=$02: sub$="Brazilian" :EndIf
  Case $18: lan$="Romanian" 
  Case $19: lan$="Russian" 
  Case $1a: lan$="Croatian" 
  Case $1a: lan$="Serbian"
    Select langid_sub
      Case $02: sub$="Latin"
      Case $03: sub$="Cyrillic"
    EndSelect
  Case $1b: lan$="Slovak" 
  Case $1c: lan$="Albanian" 
  Case $1d: lan$="Swedish"
    If langid_sub=$02: sub$="Finland" :EndIf  
  Case $1e: lan$="Thai" 
  Case $1f: lan$="Turkish"  
  Case $20: lan$="Urdu"
    Select langid_sub
      Case $01: sub$="Pakistan"
      Case $02: sub$="India"
    EndSelect
  Case $21: lan$="Indonesian" 
  Case $22: lan$="Ukrainian" 
  Case $23: lan$="Belarusian" 
  Case $24: lan$="Slovenian" 
  Case $25: lan$="Estonian" 
  Case $26: lan$="Latvian" 
  Case $27: lan$="Lithuanian"
    If langid_sub: sub$="Classic" :EndIf
  Case $29: lan$="Farsi" 
  Case $2a: lan$="Vietnamese" 
  Case $2b: lan$="Armenian" 
  Case $2c: lan$="Azeri"
    Select langid_sub
      Case $01: sub$="Latin"
      Case $02: sub$="Cyrillic"
    EndSelect
  Case $2d: lan$="Basque" 
  Case $2f: lan$="Macedonian" 
  Case $36: lan$="Afrikaans" 
  Case $37: lan$="Georgian" 
  Case $38: lan$="Faeroese" 
  Case $39: lan$="Hindi" 
  Case $3e: lan$="Malay"
    Select langid_sub
      Case $01: sub$="Malaysia"
      Case $02: sub$="Brunei Darassalam"
    EndSelect
  Case $3f: lan$="Kazak" 
  Case $41: lan$="Swahili" 
  Case $43: lan$="Uzbek"
    Select langid_sub
      Case $01: sub$="Latin"
      Case $02: sub$="Cyrillic"
    EndSelect 
  Case $44: lan$="Tatar" 
  Case $45: lan$="Bengali" 
  Case $46: lan$="Punjabi" 
  Case $47: lan$="Gujarati" 
  Case $48: lan$="Oriya" 
  Case $49: lan$="Tamil" 
  Case $4a: lan$="Telugu" 
  Case $4b: lan$="Kannada" 
  Case $4c: lan$="Malayalam" 
  Case $4d: lan$="Assamese" 
  Case $4e: lan$="Marathi" 
  Case $4f: lan$="Sanskrit" 
  Case $57: lan$="Konkani" 
  Case $58: lan$="Manipuri" 
  Case $59: lan$="Sindhi" 
  Case $60: lan$="Kashmiri"
    If langid_sub=$02 : sub$="India" : EndIf
  Case $61: lan$="Nepali"
    If langid_sub=$02 : sub$="India" : EndIf
EndSelect

Debug lan$+" "+sub$

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
