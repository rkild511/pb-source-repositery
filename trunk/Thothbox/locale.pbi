; http://unicode.org/onlinedat/languages.html
; JCV @ PureBasic Forum
; http://www.JCVsite.com
; Corrected by djes@free.fr Jul 18th 2011


CompilerIf #PB_Compiler_OS = #PB_OS_Windows
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; http://unicode.org/onlinedat/languages.html
  ; JCV @ PureBasic Forum
  ; http://www.JCVsite.com
  ; Corrected by djes@free.fr Jul 18th 2011
  
  #LANG_AFRIKAANS = $36
  #LANG_ALBANIAN = $1C
  #LANG_ARABIC = $01
  #LANG_ARMENIAN = $2B
  #LANG_ASSAMESE = $4D
  #LANG_AZERI = $2C
  #LANG_BASQUE = $2D
  #LANG_BELARUSIAN = $23
  #LANG_BENGALI = $45
  #LANG_BULGARIAN = $02
  #LANG_BELARUSIAN = $23
  #LANG_CATALAN = $03
  #LANG_CHINESE = $04
  #LANG_CROATIAN = $1A
  #LANG_CZECH = $05
  #LANG_DANISH = $06
  #LANG_DIVEHI = $65
  #LANG_DUTCH = $13
  #LANG_ENGLISH = $09
  #LANG_ESTONIAN = $25
  #LANG_FAEROESE = $38
  #LANG_FARSI = $29
  #LANG_FINNISH = $0B
  #LANG_FRENCH = $0C
  #LANG_GALICIAN = $56
  #LANG_GEORGIAN = $37
  #LANG_GERMAN = $07
  #LANG_GREEK = $08
  #LANG_GUJARATI = $47
  #LANG_HEBREW = $0D
  #LANG_HINDI = $39
  #LANG_HUNGARIAN = $0E
  #LANG_ICELANDIC = $0F
  #LANG_INDONESIAN = $21
  #LANG_ITALIAN = $10
  #LANG_JAPANESE = $11
  #LANG_KANNADA = $4B
  #LANG_KASHMIRI = $60
  #LANG_KAZAK = $3F
  #LANG_KONKANI = $57
  #LANG_KYRGYZ = $40
  #LANG_LATVIAN = $26
  #LANG_LITHUANIAN = $27
  #LANG_MACEDONIAN = $2F
  #LANG_MALAY = $3E
  #LANG_MALAYALAM = $4C
  #LANG_MANIPURI = $58
  #LANG_MARATHI = $4E
  #LANG_MONGOLIAN = $50
  #LANG_NEPALI = $61
  #LANG_ORIYA = $48
  #LANG_POLISH = $15
  #LANG_PORTUGUESE = $16
  #LANG_PUNJABI = $46
  #LANG_ROMANIAN = $18
  #LANG_RUSSIAN = $19
  #LANG_SANSKRIT = $4F
  #LANG_SERBIAN = $1A
  #LANG_SINDHI = $59
  #LANG_SLOVAK = $1B
  #LANG_SLOVENIAN = $24
  #LANG_SPANISH = $0A
  #LANG_SWEDISH = $1D
  #LANG_SORBIAN = $2E
  #LANG_SWAHILI = $41
  #LANG_SYRIAC = $5A
  #LANG_TAMIL = $49
  #LANG_TATAR = $44
  #LANG_TELUGU = $4A
  #LANG_THAI = $1E
  #LANG_TURKISH = $1F
  #LANG_UKRAINIAN = $22
  #LANG_URDU = $20
  #LANG_UZBEK = $43
  #LANG_VIETNAMESE = $2A
  #SUBLANG_NEUTRAL = $0
  #SUBLANG_DEFAULT = $1
  #SUBLANG_SYS_DEFAULT = $2
  #SUBLANG_ARABIC_SAUDI_ARABIA = $01
  #SUBLANG_ARABIC = $1
  #SUBLANG_ARABIC_IRAQ = $2
  #SUBLANG_ARABIC_EGYPT = $3
  #SUBLANG_ARABIC_LIBYA = $4
  #SUBLANG_ARABIC_ALGERIA = $5
  #SUBLANG_ARABIC_MOROCCO = $6
  #SUBLANG_ARABIC_TUNISIA = $7
  #SUBLANG_ARABIC_OMAN = $8
  #SUBLANG_ARABIC_YEMEN = $9
  #SUBLANG_ARABIC_SYRIA = $A
  #SUBLANG_ARABIC_JORDAN = $B
  #SUBLANG_ARABIC_LEBANON = $C
  #SUBLANG_ARABIC_KUWAIT = $D
  #SUBLANG_ARABIC_UAE = $E
  #SUBLANG_ARABIC_BAHRAIN = $F
  #SUBLANG_AZERI_LATIN = $01
  #SUBLANG_ARABIC_QATAR = $10
  #SUBLANG_CHINESE_TRADITIONAL = $1
  #SUBLANG_CHINESE_SIMPLIFIED = $2
  #SUBLANG_CHINESE_HONGKONG = $3
  #SUBLANG_CHINESE_SINGAPORE = $4
  #SUBLANG_DUTCH = $1
  #SUBLANG_DUTCH_BELGIAN = $2
  #SUBLANG_ENGLISH_US = $1
  #SUBLANG_ENGLISH_UK = $2
  #SUBLANG_ENGLISH_AUS = $3
  #SUBLANG_ENGLISH_CAN = $4
  #SUBLANG_ENGLISH_NZ = $5
  #SUBLANG_ENGLISH_EIRE = $6
  #SUBLANG_ENGLISH_SAFRICA = $7
  #SUBLANG_ENGLISH_JAMAICA = $8
  #SUBLANG_ENGLISH_CARRIBEAN = $9
  #SUBLANG_FRENCH = $1
  #SUBLANG_FRENCH_BELGIAN = $2
  #SUBLANG_FRENCH_CANADIAN = $3
  #SUBLANG_FRENCH_SWISS = $4
  #SUBLANG_FRENCH_LUXEMBOURG = $5
  #SUBLANG_GERMAN = $1
  #SUBLANG_GERMAN_SWISS = $2
  #SUBLANG_GERMAN_AUSTRIAN = $3
  #SUBLANG_GERMAN_LUXEMBOURG = $4
  #SUBLANG_GERMAN_LIECHTENSTEIN = $5
  #SUBLANG_ITALIAN = $1
  #SUBLANG_ITALIAN_SWISS = $2
  #SUBLANG_KOREAN = $1
  #SUBLANG_KOREAN_JOHAB = $2
  #SUBLANG_NORWEGIAN_BOKMAL = $1
  #SUBLANG_NORWEGIAN_NYNORSK = $2
  #SUBLANG_PORTUGUESE = $2
  #SUBLANG_PORTUGUESE_BRAZILIAN = $1
  #SUBLANG_SPANISH = $1
  #SUBLANG_SPANISH_MEXICAN = $2
  #SUBLANG_SPANISH_MODERN = $3
  #SUBLANG_SPANISH_GUATEMALA = $4
  #SUBLANG_SPANISH_COSTARICA = $5
  #SUBLANG_SPANISH_PANAMA = $6
  #SUBLANG_SPANISH_DOMINICAN = $7
  #SUBLANG_SPANISH_VENEZUELA = $8
  #SUBLANG_SPANISH_COLOMBIA = $9
  #SUBLANG_SPANISH_PERU = $A
  #SUBLANG_SPANISH_ARGENTINA = $B
  #SUBLANG_SPANISH_ECUADOR = $C
  #SUBLANG_SPANISH_CHILE = $D
  #SUBLANG_SPANISH_URUGUAY = $E
  #SUBLANG_SPANISH_PARAGUAY = $F
  #SUBLANG_SPANISH_BOLIVIA = $10
  #SUBLANG_ARABIC_SAUDI_ARABIA = $01
  #SUBLANG_ARABIC_IRAQ = $02
  #SUBLANG_ARABIC_EGYPT = $03
  #SUBLANG_ARABIC_LIBYA = $04
  #SUBLANG_ARABIC_ALGERIA = $05
  #SUBLANG_ARABIC_MOROCCO = $06
  #SUBLANG_ARABIC_TUNISIA = $07
  #SUBLANG_ARABIC_OMAN = $08
  #SUBLANG_ARABIC_YEMEN = $09
  #SUBLANG_ARABIC_SYRIA = $0A
  #SUBLANG_ARABIC_JORDAN = $0B
  #SUBLANG_ARABIC_LEBANON = $0C
  #SUBLANG_ARABIC_KUWAIT = $0D
  #SUBLANG_ARABIC_UAE = $0E
  #SUBLANG_ARABIC_BAHRAIN = $0F
  #SUBLANG_ARABIC_QATAR = $10
  #SUBLANG_AZERI_LATIN = $01
  #SUBLANG_AZERI_CYRILLIC = $02
  #SUBLANG_CHINESE_MACAU = $05
  #SUBLANG_ENGLISH_SOUTH_AFRICA = $07
  #SUBLANG_ENGLISH_JAMAICA = $08
  #SUBLANG_ENGLISH_CARIBBEAN = $09
  #SUBLANG_ENGLISH_BELIZE = $0A
  #SUBLANG_ENGLISH_TRINIDAD = $0B
  #SUBLANG_ENGLISH_ZIMBABWE = $0C
  #SUBLANG_ENGLISH_PHILIPPINES = $0D
  #SUBLANG_FRENCH_LUXEMBOURG = $05
  #SUBLANG_FRENCH_MONACO = $06
  #SUBLANG_GERMAN_LUXEMBOURG = $04
  #SUBLANG_GERMAN_LIECHTENSTEIN = $05
  #SUBLANG_KASHMIRI_INDIA = $02
  #SUBLANG_MALAY_MALAYSIA = $01
  #SUBLANG_MALAY_BRUNEI_DARUSSALAM = $02
  #SUBLANG_NEPALI_INDIA = $02
  #SUBLANG_SERBIAN_LATIN = $02
  #SUBLANG_SERBIAN_CYRILLIC = $03
  #SUBLANG_SPANISH_GUATEMALA = $04
  #SUBLANG_SPANISH_COSTA_RICA = $05
  #SUBLANG_SPANISH_PANAMA = $06
  #SUBLANG_SPANISH_DOMINICAN_REPUBLIC = $07
  #SUBLANG_SPANISH_VENEZUELA = $08
  #SUBLANG_SPANISH_COLOMBIA = $09
  #SUBLANG_SPANISH_PERU = $0A
  #SUBLANG_SPANISH_ARGENTINA = $0B
  #SUBLANG_SPANISH_ECUADOR = $0C
  #SUBLANG_SPANISH_CHILE = $0D
  #SUBLANG_SPANISH_URUGUAY = $0E
  #SUBLANG_SPANISH_PARAGUAY = $0F
  #SUBLANG_SPANISH_BOLIVIA = $10
  #SUBLANG_SPANISH_EL_SALVADOR = $11
  #SUBLANG_SPANISH_HONDURAS = $12
  #SUBLANG_SPANISH_NICARAGUA = $13
  #SUBLANG_SPANISH_PUERTO_RICO = $14
  #SUBLANG_SWEDISH_FINLAND = $02
  #SUBLANG_URDU_PAKISTAN = $01
  #SUBLANG_URDU_INDIA = $02
  #SUBLANG_UZBEK_LATIN = $01
  #SUBLANG_UZBEK_CYRILLIC = $02
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; GUIMAUVE : Added
  
  #LANG_TURKMEN = $42
  #LANG_BURMESE = $55
  #LANG_CAMBODIAN = $53
  #LANG_YORUBA = $6A
  #LANG_ZULU = $35
  #LANG_YIDDISH = $3D
  #LANG_YI = $78
  #LANG_XHOSA = $34
  #LANG_VENDA = $33
  #LANG_TIBETAN = $51
  #LANG_TIGRINYA = $73
  #LANG_TSONGA = $31
  #LANG_TAGALOG = $64
  #LANG_TAJIK = $28 
  #LANG_TAMAZIGHT = $5F
  #LANG_SUTU = $30
  #LANG_SOMALI = $77
  #LANG_SINHALESE = $5B
  #LANG_SAMI = $3B
  #LANG_RHAETO_ROMANCE = $17
  #LANG_PASHTO = $63
  #LANG_OROMO = $72
  #LANG_PAPIAMENTU = $79
  #LANG_MALTESE = $3A
  #LANG_LAO = $54
  #LANG_LATIN = $76
  #LANG_KANURI = $71
  #LANG_INUKTITUT = $5D
  #LANG_IGBO = $70
  #LANG_IBIBIO = $69
  #LANG_HAWAIIAN = $75
  #LANG_HAUSA = $68
  #LANG_GUARANI = $74
  #LANG_IRISH = $02
  #LANG_FRISIAN = $62
  #LANG_FULFULDE = $67
  #LANG_EDO = $66
  #LANG_BURMESE = $55
  #LANG_CAMBODIAN = $53
  #LANG_CHEROKEE = $5C
  #LANG_AMHARIC = $5E
  #LANG_GAELIC = $3C
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; FIXME 
  ; #LANG_KOREAN = ??????
  ; #LANG_NORWEGIAN = ??????
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  
  #SUBLANG_SCOTTISH = $01
  #SUBLANG_IRISH = $02
  
  Macro SUBLANGID(lgid)
    ((lgid)>>10) 
  EndMacro
  
  Macro PRIMARYLANGID(lgid)
    ((lgid)&$3FF) 
  EndMacro
  
  Macro MAKELANGID(primary, sublang)
    (((sublang)<<10)|(primary))
  EndMacro
  
  Macro LANGIDFROMLCID(lgid)
    ((lgid)&255)
  EndMacro
  
CompilerEndIf

#COUNT_OFFSET = 8
#ORIGINAL_OFFSET = 12
#TRANSLATION_OFFSET = 16

#TRANSLATION_MODE_ORI = 0
#TRANSLATION_MODE_TRA = 1

Procedure.s getLanguageName()
  
  CompilerSelect #PB_Compiler_OS
      
    CompilerCase #PB_OS_Linux
      ProcedureReturn StringField(GetEnvironmentVariable("LANGUAGE"), 1, ":")
      
    CompilerCase #PB_OS_MacOS
      ProcedureReturn StringField(GetEnvironmentVariable("LANGUAGE"), 1, ":")
      
    CompilerCase #PB_OS_Windows 
      Protected lcid, langid, primary, sub
      lcid = GetThreadLocale_()
      langid = LANGIDFROMLCID(lcid)
      primary = PRIMARYLANGID(langid)
      sub = SUBLANGID(lcid)
      
      Select primary
          
        Case #LANG_AFRIKAANS
          ProcedureReturn "af_ZA";
          
        Case #LANG_ALBANIAN:
          ProcedureReturn "sq_AL";
          
        Case #LANG_AMHARIC
          ProcedureReturn "am_ET"; /* AMHARIC */ 
          
        Case #LANG_ARMENIAN
          ProcedureReturn "hy_AM";
          
        Case #LANG_ASSAMESE
          ProcedureReturn "as_IN";
          
        Case #LANG_BASQUE
          ProcedureReturn "eu"; /* Ambiguous: could be "eu_ES" or "eu_FR".  */
          
        Case #LANG_BELARUSIAN
          ProcedureReturn "be_BY";
          
        Case #LANG_BENGALI
          ProcedureReturn "bn_IN";
          
        Case #LANG_BULGARIAN
          ProcedureReturn "bg_BG";
          
        Case #LANG_BURMESE
          ProcedureReturn "my_MM"; /* BURMESE */ 
          
        Case #LANG_CAMBODIAN
          ProcedureReturn "km_KH"; /* CAMBODIAN */ 
          
        Case #LANG_CATALAN: 
          ProcedureReturn "ca_ES";
          
        Case #LANG_CHEROKEE
          ProcedureReturn "chr_US"; /* CHEROKEE */ 
          
        Case #LANG_CZECH: 
          ProcedureReturn "cs_CZ";
          
        Case #LANG_DANISH:
          ProcedureReturn "da_DK";
          
        Case #LANG_DIVEHI
          ProcedureReturn "div_MV";
          
        Case #LANG_EDO
          ProcedureReturn "bin_NG"; /* EDO */ 
          
        Case #LANG_ESTONIAN
          ProcedureReturn "et_EE";
          
        Case #LANG_FAEROESE
          ProcedureReturn "fo_FO";
          
        Case #LANG_FARSI
          ProcedureReturn "fa_IR";
          
        Case #LANG_FINNISH
          ProcedureReturn "fi_FI";
          
        Case #LANG_FRISIAN
          ProcedureReturn "fy_NL"; /* FRISIAN */ 
          
        Case #LANG_FULFULDE
          ProcedureReturn "ful_NG"; /* FULFULDE */ 
          
        Case #LANG_GALICIAN
          ProcedureReturn "gl_ES";
          
        Case #LANG_GEORGIAN
          ProcedureReturn "ka_GE";
          
        Case #LANG_GREEK
          ProcedureReturn "el_GR";
          
        Case #LANG_GUARANI
          ProcedureReturn "gn_PY"; /* GUARANI */ 
          
        Case #LANG_GUJARATI
          ProcedureReturn "gu_IN";
          
        Case #LANG_HAUSA
          ProcedureReturn "ha_NG"; /* HAUSA */ 
          
        Case #LANG_HAWAIIAN ; /* HAWAIIAN */
          ; /* FIXME: Do they mean Hawaiian ("haw_US", 1000 speakers)
          ; Or Hawaii Creole English ("cpe_US", 600000 speakers)?  */
          ProcedureReturn "cpe_US";
          
        Case #LANG_HEBREW
          ProcedureReturn "he_IL";
          
        Case #LANG_HINDI
          ProcedureReturn "hi_IN";
          
        Case #LANG_HUNGARIAN
          ProcedureReturn "hu_HU";
          
        Case #LANG_IBIBIO
          ProcedureReturn "nic_NG"; /* IBIBIO */ 
          
        Case #LANG_ICELANDIC
          ProcedureReturn "is_IS";
          
        Case #LANG_IGBO
          ProcedureReturn "ibo_NG"; /* IGBO */ 
          
        Case #LANG_INDONESIAN
          ProcedureReturn "id_ID";
          
        Case #LANG_INUKTITUT
          ProcedureReturn "iu_CA"; /* INUKTITUT */ 
          
        Case #LANG_JAPANESE
          ProcedureReturn "ja_JP";
          
        Case #LANG_KANNADA
          ProcedureReturn "kn_IN";
          
        Case #LANG_KANURI
          ProcedureReturn "kau_NG"; /* KANURI */ 
          
        Case #LANG_KAZAK
          ProcedureReturn "kk_KZ";
          
        Case #LANG_KONKANI ; /* FIXME: Adjust this when such locales appear on Unix.  */
          ProcedureReturn "kok_IN";
          
          ;Case #LANG_KOREAN ; GUIMAUVE : LA VALEUR DE CETTE CONSTANTE EST MANQUANTE. DE PLUS, IL SEMBLE QUE CETTE LANGUE POSSÈDE DES SOUS-LANGUES
          ; ProcedureReturn "ko_KR";
          
        Case #LANG_KYRGYZ
          ProcedureReturn "ky_KG";
          
        Case #LANG_LAO
          ProcedureReturn "lo_LA"; /* LAO */ 
          
        Case #LANG_LATIN
          ProcedureReturn "la_VA"; /* LATIN */ 
          
        Case #LANG_LATVIAN
          ProcedureReturn "lv_LV";
          
        Case #LANG_LITHUANIAN
          ProcedureReturn "lt_LT";
          
        Case #LANG_MACEDONIAN
          ProcedureReturn "mk_MK";
          
        Case #LANG_MALAYALAM
          ProcedureReturn "ml_IN";
          
        Case #LANG_MALTESE
          ProcedureReturn "mt_MT"; /* MALTESE */ 
          
        Case #LANG_MANIPURI:
          ProcedureReturn "mni_IN"; ; /* FIXME: Adjust this when such locales appear on Unix.  */ (GUIMAUVE : THIS FIXME IS NOT NEEDED)
          
        Case #LANG_MARATHI
          ProcedureReturn "mr_IN";
          
        Case #LANG_MONGOLIAN
          ProcedureReturn "mn"; /* Ambiguous: could be "mn_CN" or "mn_MN".  */
          
        Case #LANG_ORIYA
          ProcedureReturn "or_IN";
          
        Case #LANG_OROMO
          ProcedureReturn "om_ET"; /* OROMO */ 
          
        Case #LANG_PAPIAMENTU
          ProcedureReturn "pap_AN"; /* PAPIAMENTU */ 
          
        Case #LANG_PASHTO ; /* PASHTO */
          ProcedureReturn "ps"; /* Ambiguous: could be "ps_PK" or "ps_AF".  */
          
        Case #LANG_POLISH
          ProcedureReturn "pl_PL";
          
        Case #LANG_PUNJABI
          ProcedureReturn "pa_IN";
          
        Case #LANG_RHAETO_ROMANCE
          ProcedureReturn "rm_CH"; /* RHAETO-ROMANCE */ 
          
        Case #LANG_ROMANIAN
          ProcedureReturn "ro_RO";
          
        Case #LANG_RUSSIAN
          ProcedureReturn "ru"; /* Ambiguous: could be "ru_RU" or "ru_UA".  */
          
        Case #LANG_SAMI
          ProcedureReturn "se_NO"; /* SAMI */ 
          
        Case #LANG_SANSKRIT
          ProcedureReturn "sa_IN";
          
        Case #LANG_SINDHI
          ProcedureReturn "sd";
          
        Case #LANG_SINHALESE
          ProcedureReturn "si_LK"; /* SINHALESE */ 
          
        Case #LANG_SLOVAK
          ProcedureReturn "sk_SK";
          
        Case #LANG_SLOVENIAN
          ProcedureReturn "sl_SI";
          
        Case #LANG_SOMALI
          ProcedureReturn "so_SO"; /* SOMALI */ 
          
        Case #LANG_SORBIAN:
          ProcedureReturn "wen_DE"; ; /* FIXME: Adjust this when such locales appear on Unix.  */
          
        Case #LANG_SUTU
          ProcedureReturn "bnt_TZ"; /* SUTU */ 
          
        Case #LANG_SWAHILI
          ProcedureReturn "sw_KE";
          
        Case #LANG_SYRIAC
          ProcedureReturn "syr_TR"; /* An extinct language.  */
          
        Case #LANG_TAGALOG
          ProcedureReturn "tl_PH"; /* TAGALOG */ 
          
        Case #LANG_TAJIK
          ProcedureReturn "tg_TJ"; /* TAJIK */ 
          
        Case #LANG_TAMAZIGHT
          ProcedureReturn "ber_MA"; /* TAMAZIGHT */ 
          
        Case #LANG_TAMIL:
          ProcedureReturn "ta"; /* Ambiguous: could be "ta_IN" or "ta_LK" or "ta_SG".  */
          
        Case #LANG_TATAR
          ProcedureReturn "tt_RU";
          
        Case #LANG_TELUGU
          ProcedureReturn "te_IN";
          
        Case #LANG_THAI
          ProcedureReturn "th_TH";
          
        Case #LANG_TIBETAN
          ProcedureReturn "bo_CN"; /* TIBETAN */ 
          
        Case #LANG_TIGRINYA
          ProcedureReturn "ti_ET"; /* TIGRINYA */ 
          
        Case #LANG_TSONGA
          ProcedureReturn "ts_ZA"; /* TSONGA */ 
          
        Case #LANG_TURKISH
          ProcedureReturn "tr_TR";
          
        Case #LANG_TURKMEN
          ProcedureReturn "tk_TM"; /* #LANG_TURKMEN  = $42 */ 
          
        Case #LANG_UKRAINIAN
          ProcedureReturn "uk_UA";
          
        Case #LANG_VENDA
          ProcedureReturn "ven_ZA"; /* VENDA */ 
          
        Case #LANG_VIETNAMESE
          ProcedureReturn "vi_VN";
          
        Case #LANG_XHOSA
          ProcedureReturn "xh_ZA"; /* XHOSA */ 
          
        Case #LANG_YI
          ProcedureReturn "sit_CN"; /* YI */ 
          
        Case #LANG_YIDDISH
          ProcedureReturn "yi_IL"; /* YIDDISH */ 
          
        Case #LANG_YORUBA
          ProcedureReturn "yo_NG"; /* YORUBA */ 
          
        Case #LANG_ZULU
          ProcedureReturn "zu_ZA"; /* ZULU */ 
          
        Case #LANG_FRENCH
          
          Select sub
              
            Case #SUBLANG_FRENCH
              ProcedureReturn "fr_FR";
              
            Case #SUBLANG_FRENCH_BELGIAN
              ProcedureReturn "fr_BE";  /* WALLOON */
              
            Case #SUBLANG_FRENCH_CANADIAN
              ProcedureReturn "fr_CA";
              
            Case #SUBLANG_FRENCH_SWISS
              ProcedureReturn "fr_CH";
              
            Case #SUBLANG_FRENCH_LUXEMBOURG
              ProcedureReturn "fr_LU";
              
            Case #SUBLANG_FRENCH_MONACO
              ProcedureReturn "fr_MC";
              
            Default
              ProcedureReturn "fr";
              
          EndSelect
          
        Case #LANG_ENGLISH
          Select sub
              
              ; /* #SUBLANG_ENGLISH_US == #SUBLANG_DEFAULT. Heh. I thought
              ;  English was the language spoken in England. Oh well. */
            Case #SUBLANG_ENGLISH_US
              ProcedureReturn "en_US";
              
            Case #SUBLANG_ENGLISH_UK
              ProcedureReturn "en_GB";
              
            Case #SUBLANG_ENGLISH_AUS
              ProcedureReturn "en_AU";
              
            Case #SUBLANG_ENGLISH_CAN
              ProcedureReturn "en_CA";
              
            Case #SUBLANG_ENGLISH_NZ
              ProcedureReturn "en_NZ";
              
            Case #SUBLANG_ENGLISH_EIRE
              ProcedureReturn "en_IE";
              
            Case #SUBLANG_ENGLISH_SOUTH_AFRICA
              ProcedureReturn "en_ZA";
              
            Case #SUBLANG_ENGLISH_JAMAICA
              ProcedureReturn "en_JM";
              
            Case #SUBLANG_ENGLISH_CARIBBEAN
              ProcedureReturn "en_GD"; /* Grenada? */
              
            Case #SUBLANG_ENGLISH_BELIZE
              ProcedureReturn "en_BZ";
              
            Case #SUBLANG_ENGLISH_TRINIDAD
              ProcedureReturn "en_TT";
              
            Case #SUBLANG_ENGLISH_ZIMBABWE
              ProcedureReturn "en_ZW";
              
            Case #SUBLANG_ENGLISH_PHILIPPINES
              ProcedureReturn "en_PH";
              
            Default
              ProcedureReturn "en";
              
          EndSelect
          
        Case #LANG_SWEDISH:
          
          Select sub
            Case #SUBLANG_DEFAULT
              ProcedureReturn "sv_SE";
            Case #SUBLANG_SWEDISH_FINLAND
              ProcedureReturn "sv_FI";
            Default
              ProcedureReturn "sv";
              
          EndSelect    
          
        Case #LANG_URDU
          
          Select sub
              
            Case #SUBLANG_URDU_PAKISTAN
              ProcedureReturn "ur_PK";
              
            Case #SUBLANG_URDU_INDIA
              ProcedureReturn "ur_IN";
              
            Default
              ProcedureReturn "ur";
              
          EndSelect
          
        Case #LANG_UZBEK:
          
          Select sub
              ; /* FIXME: Adjust this when Uzbek locales appear on Unix.  */
            Case #SUBLANG_UZBEK_LATIN
              ProcedureReturn "uz_UZ@latin";
              
            Case #SUBLANG_UZBEK_CYRILLIC
              ProcedureReturn "uz_UZ@cyrillic";
              
            Default
              ProcedureReturn "uz";
              
          EndSelect
          
        Case #LANG_SPANISH
          
          Select sub
              
            Case #SUBLANG_SPANISH
              ProcedureReturn "es_ES";
              
            Case #SUBLANG_SPANISH_MEXICAN
              ProcedureReturn "es_MX";
              
            Case #SUBLANG_SPANISH_MODERN
              ProcedureReturn "es_ES@modern";	/* not seen on Unix */
              
            Case #SUBLANG_SPANISH_GUATEMALA
              ProcedureReturn "es_GT";
              
            Case #SUBLANG_SPANISH_COSTA_RICA
              ProcedureReturn "es_CR";
              
            Case #SUBLANG_SPANISH_PANAMA
              ProcedureReturn "es_PA";
              
            Case #SUBLANG_SPANISH_DOMINICAN_REPUBLIC
              ProcedureReturn "es_DO";
              
            Case #SUBLANG_SPANISH_VENEZUELA
              ProcedureReturn "es_VE";
              
            Case #SUBLANG_SPANISH_COLOMBIA
              ProcedureReturn "es_CO";
              
            Case #SUBLANG_SPANISH_PERU
              ProcedureReturn "es_PE";
              
            Case #SUBLANG_SPANISH_ARGENTINA
              ProcedureReturn "es_AR";
              
            Case #SUBLANG_SPANISH_ECUADOR
              ProcedureReturn "es_EC";
              
            Case #SUBLANG_SPANISH_CHILE
              ProcedureReturn "es_CL";
              
            Case #SUBLANG_SPANISH_URUGUAY
              ProcedureReturn "es_UY";
              
            Case #SUBLANG_SPANISH_PARAGUAY
              ProcedureReturn "es_PY";
              
            Case #SUBLANG_SPANISH_BOLIVIA
              ProcedureReturn "es_BO";
              
            Case #SUBLANG_SPANISH_EL_SALVADOR
              ProcedureReturn "es_SV";
              
            Case #SUBLANG_SPANISH_HONDURAS
              ProcedureReturn "es_HN";
              
            Case #SUBLANG_SPANISH_NICARAGUA
              ProcedureReturn "es_NI";
              
            Case #SUBLANG_SPANISH_PUERTO_RICO
              ProcedureReturn "es_PR";
              
            Default
              ProcedureReturn "es";
              
          EndSelect
          
        Case #LANG_PORTUGUESE
          
          Select sub
              
            Case #SUBLANG_PORTUGUESE
              ProcedureReturn "pt_PT";
              ; /* Hmm. #SUBLANG_PORTUGUESE_BRAZILIAN == #SUBLANG_DEFAULT.
              ; Same phenomenon As #SUBLANG_ENGLISH_US == #SUBLANG_DEFAULT. */
              
            Case #SUBLANG_PORTUGUESE_BRAZILIAN
              ProcedureReturn "pt_BR";
              
            Default
              ProcedureReturn "pt";
              
          EndSelect
          
          ;     Case #LANG_NORWEGIAN ; GUIMAUVE : LA VALEUR DE CETTE CONSTANTE EST MANQUANTE.
          ;       
          ;       Select sub
          ;           
          ;         Case #SUBLANG_NORWEGIAN_BOKMAL
          ;           ProcedureReturn "no_NO";
          ;           
          ;         Case #SUBLANG_NORWEGIAN_NYNORSK
          ;           ProcedureReturn "nn_NO";
          ;           
          ;         Default
          ;           ProcedureReturn "no";
          ;           
          ;       EndSelect
          
        Case #LANG_NEPALI
          
          Select sub
              
            Case #SUBLANG_DEFAULT
              ProcedureReturn "ne_NP";
              
            Case #SUBLANG_NEPALI_INDIA
              ProcedureReturn "ne_IN";
              
            Default
              ProcedureReturn "ne";
              
          EndSelect
          
        Case #LANG_MALAY
          
          Select sub
              
            Case #SUBLANG_MALAY_MALAYSIA
              ProcedureReturn "ms_MY";
              
            Case #SUBLANG_MALAY_BRUNEI_DARUSSALAM
              ProcedureReturn "ms_BN";
              
            Default
              ProcedureReturn "ms";
              
          EndSelect
          
          
        Case #LANG_KASHMIRI
          
          Select sub
              
            Case #SUBLANG_DEFAULT
              ProcedureReturn "ks_PK";
              
            Case #SUBLANG_KASHMIRI_INDIA
              ProcedureReturn "ks_IN";
              
            Default
              ProcedureReturn "ks";
              
          EndSelect
          
          
        Case #LANG_ITALIAN
          
          Select sub
              
            Case #SUBLANG_ITALIAN
              ProcedureReturn "it_IT";
              
            Case #SUBLANG_ITALIAN_SWISS
              ProcedureReturn "it_CH";
              
            Default
              ProcedureReturn "it";
              
          EndSelect
          
          
        Case #LANG_GERMAN
          
          Select sub
              
            Case #SUBLANG_GERMAN
              ProcedureReturn "de_DE";
              
            Case #SUBLANG_GERMAN_SWISS
              ProcedureReturn "de_CH";
              
            Case #SUBLANG_GERMAN_AUSTRIAN
              ProcedureReturn "de_AT";
              
            Case #SUBLANG_GERMAN_LUXEMBOURG
              ProcedureReturn "de_LU";
              
            Case #SUBLANG_GERMAN_LIECHTENSTEIN
              ProcedureReturn "de_LI";
              
            Default
              ProcedureReturn "de";
              
          EndSelect 
          
          
        Case #LANG_GAELIC; /* GAELIC */
          
          Select sub
              
            Case #SUBLANG_SCOTTISH
              ProcedureReturn "gd_GB"; /* SCOTTISH */
              
            Case #SUBLANG_IRISH
              ProcedureReturn "ga_IE"; /* IRISH */ 
              
            Default
              ProcedureReturn "C";
              
          EndSelect
          
          
        Case #LANG_DUTCH:
          
          Select sub
              
            Case #SUBLANG_DUTCH
              ProcedureReturn "nl_NL";
              
            Case #SUBLANG_DUTCH_BELGIAN
              ProcedureReturn "nl_BE"; /* FLEMISH, VLAAMS */ 
              
            Default
              ProcedureReturn "nl";
              
          EndSelect  
          
        Case #LANG_CHINESE:
          
          Select sub
              
            Case #SUBLANG_CHINESE_TRADITIONAL:
              ProcedureReturn "zh_TW";
              
            Case #SUBLANG_CHINESE_SIMPLIFIED:
              ProcedureReturn "zh_CN";
              
            Case #SUBLANG_CHINESE_HONGKONG:
              ProcedureReturn "zh_HK";
              
            Case #SUBLANG_CHINESE_SINGAPORE
              ProcedureReturn "zh_SG";
              
            Case #SUBLANG_CHINESE_MACAU
              ProcedureReturn "zh_MO";
              
            Default
              ProcedureReturn "zh";
              
          EndSelect
          
        Case #LANG_CROATIAN:	; /* #LANG_CROATIAN == #LANG_SERBIAN
          ; * What used To be called Serbo-Croatian
          ; * should really now be two separate
          ; * languages because of political reasons.
          ; * (Says tml, who knows nothing about Serbian
          ; * Or Croatian.)
          ; * (i can feel those flames coming already.)
          ; */
          Select sub
              
            Case #SUBLANG_DEFAULT
              ProcedureReturn "hr_HR";
              
            Case #SUBLANG_SERBIAN_LATIN
              ProcedureReturn "sr_YU";
              
            Case #SUBLANG_SERBIAN_CYRILLIC
              ProcedureReturn "sr_YU@cyrillic";
              
            Default
              ProcedureReturn "hr";
              
          EndSelect   
          
        Case #LANG_AZERI:
          
          Select sub
              ; /* FIXME: Adjust this when Azerbaijani locales appear on Unix.  */
            Case #SUBLANG_AZERI_LATIN
              ProcedureReturn "az_AZ@latin";
              
            Case #SUBLANG_AZERI_CYRILLIC
              ProcedureReturn "az_AZ@cyrillic";
              
            Default
              ProcedureReturn "az";
              
          EndSelect
          
        Case #LANG_ARABIC:
          
          Select sub
              
            Case #SUBLANG_ARABIC_SAUDI_ARABIA: 
              ProcedureReturn "ar_SA";
              
            Case #SUBLANG_ARABIC_IRAQ: 
              ProcedureReturn "ar_IQ";
              
            Case #SUBLANG_ARABIC_EGYPT: 
              ProcedureReturn "ar_EG"
              
            Case #SUBLANG_ARABIC_LIBYA: 
              ProcedureReturn "ar_LY";
              
            Case #SUBLANG_ARABIC_ALGERIA: 
              ProcedureReturn "ar_DZ";
              
            Case #SUBLANG_ARABIC_MOROCCO: 
              ProcedureReturn "ar_MA";
              
            Case #SUBLANG_ARABIC_TUNISIA: 
              ProcedureReturn "ar_TN";
              
            Case #SUBLANG_ARABIC_OMAN: 
              ProcedureReturn "ar_OM";
              
            Case #SUBLANG_ARABIC_YEMEN: 
              ProcedureReturn "ar_YE";
              
            Case #SUBLANG_ARABIC_SYRIA: 
              ProcedureReturn "ar_SY";
              
            Case #SUBLANG_ARABIC_JORDAN:
              ProcedureReturn "ar_JO";
              
            Case #SUBLANG_ARABIC_LEBANON: 
              ProcedureReturn "ar_LB";
              
            Case #SUBLANG_ARABIC_KUWAIT: 
              ProcedureReturn "ar_KW";
              
            Case #SUBLANG_ARABIC_UAE: 
              ProcedureReturn "ar_AE";
              
            Case #SUBLANG_ARABIC_BAHRAIN: 
              ProcedureReturn "ar_BH";
              
            Case #SUBLANG_ARABIC_QATAR: 
              ProcedureReturn "ar_QA";
              
            Default
              ProcedureReturn "ar";
              
          EndSelect
          
        Default
          ProcedureReturn "C";
          
      EndSelect  
      
  CompilerEndSelect
  
EndProcedure

; IDE Options = PureBasic 4.60 RC 1 (Linux - x64)
; CursorPosition = 1037
; FirstLine = 275
; Folding = --
; EnableUnicode