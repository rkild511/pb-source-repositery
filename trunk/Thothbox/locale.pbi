; http://unicode.org/onlinedat/languages.html
; JCV @ PureBasic Forum
; http://www.JCVsite.com

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

Procedure.s getLanguageName()
  Protected lcid, langid, primary, sub

  lcid = GetThreadLocale_()
  langid = LANGIDFROMLCID(lcid)
  primary = PRIMARYLANGID(langid)
	sub = SUBLANGID (langid)
 
  Select primary
    Case #LANG_AFRIKAANS: ProcedureReturn "af_ZA";
    Case #LANG_ALBANIAN: ProcedureReturn "sq_AL";
    Case $5E: ProcedureReturn "am_ET"; /* AMHARIC */ 
    Case #LANG_ARABIC:
      Select sub
        Case #SUBLANG_ARABIC_SAUDI_ARABIA: ProcedureReturn "ar_SA";
        Case #SUBLANG_ARABIC_IRAQ: ProcedureReturn "ar_IQ";
        Case #SUBLANG_ARABIC_EGYPT: ProcedureReturn "ar_EG";
        Case #SUBLANG_ARABIC_LIBYA: ProcedureReturn "ar_LY";
        Case #SUBLANG_ARABIC_ALGERIA: ProcedureReturn "ar_DZ";
        Case #SUBLANG_ARABIC_MOROCCO: ProcedureReturn "ar_MA";
        Case #SUBLANG_ARABIC_TUNISIA: ProcedureReturn "ar_TN";
        Case #SUBLANG_ARABIC_OMAN: ProcedureReturn "ar_OM";
        Case #SUBLANG_ARABIC_YEMEN: ProcedureReturn "ar_YE";
        Case #SUBLANG_ARABIC_SYRIA: ProcedureReturn "ar_SY";
        Case #SUBLANG_ARABIC_JORDAN: ProcedureReturn "ar_JO";
        Case #SUBLANG_ARABIC_LEBANON: ProcedureReturn "ar_LB";
        Case #SUBLANG_ARABIC_KUWAIT: ProcedureReturn "ar_KW";
        Case #SUBLANG_ARABIC_UAE: ProcedureReturn "ar_AE";
        Case #SUBLANG_ARABIC_BAHRAIN: ProcedureReturn "ar_BH";
        Case #SUBLANG_ARABIC_QATAR: ProcedureReturn "ar_QA";
        Default: ProcedureReturn "ar";
      EndSelect
    Case #LANG_ARMENIAN: ProcedureReturn "hy_AM";
    Case #LANG_ASSAMESE: ProcedureReturn "as_IN";
    Case #LANG_AZERI:
      Select sub
        ; /* FIXME: Adjust this when Azerbaijani locales appear on Unix.  */
        Case #SUBLANG_AZERI_LATIN: ProcedureReturn "az_AZ@latin";
        Case #SUBLANG_AZERI_CYRILLIC: ProcedureReturn "az_AZ@cyrillic";
        Default: ProcedureReturn "az";
      EndSelect
    Case #LANG_BASQUE: ProcedureReturn "eu"; /* Ambiguous: could be "eu_ES" or "eu_FR".  */
    Case #LANG_BELARUSIAN: ProcedureReturn "be_BY";
    Case #LANG_BENGALI: ProcedureReturn "bn_IN";
    Case #LANG_BULGARIAN: ProcedureReturn "bg_BG";
    Case $55: ProcedureReturn "my_MM"; /* BURMESE */ 
    Case $53: ProcedureReturn "km_KH"; /* CAMBODIAN */ 
    Case #LANG_CATALAN: ProcedureReturn "ca_ES";
    Case $5C: ProcedureReturn "chr_US"; /* CHEROKEE */ 
    Case #LANG_CHINESE:
      Select sub
        Case #SUBLANG_CHINESE_TRADITIONAL: ProcedureReturn "zh_TW";
        Case #SUBLANG_CHINESE_SIMPLIFIED: ProcedureReturn "zh_CN";
        Case #SUBLANG_CHINESE_HONGKONG: ProcedureReturn "zh_HK";
        Case #SUBLANG_CHINESE_SINGAPORE: ProcedureReturn "zh_SG";
        Case #SUBLANG_CHINESE_MACAU: ProcedureReturn "zh_MO";
        Default: ProcedureReturn "zh";
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
        Case #SUBLANG_DEFAULT: ProcedureReturn "hr_HR";
        Case #SUBLANG_SERBIAN_LATIN: ProcedureReturn "sr_YU";
        Case #SUBLANG_SERBIAN_CYRILLIC: ProcedureReturn "sr_YU@cyrillic";
        Default: ProcedureReturn "hr";
      EndSelect
    Case #LANG_CZECH: ProcedureReturn "cs_CZ";
    Case #LANG_DANISH: ProcedureReturn "da_DK";
    Case #LANG_DIVEHI: ProcedureReturn "div_MV";
    Case #LANG_DUTCH:
      Select sub
        Case #SUBLANG_DUTCH: ProcedureReturn "nl_NL";
        Case #SUBLANG_DUTCH_BELGIAN: ProcedureReturn "nl_BE"; /* FLEMISH, VLAAMS */ 
        Default: ProcedureReturn "nl";
      EndSelect
    Case $66: ProcedureReturn "bin_NG"; /* EDO */ 
    Case #LANG_ENGLISH:
      Select sub
        ; /* #SUBLANG_ENGLISH_US == #SUBLANG_DEFAULT. Heh. I thought
        ; * English was the language spoken in England.
        ; * Oh well.
        ; */
        Case #SUBLANG_ENGLISH_US: ProcedureReturn "en_US";
        Case #SUBLANG_ENGLISH_UK: ProcedureReturn "en_GB";
        Case #SUBLANG_ENGLISH_AUS: ProcedureReturn "en_AU";
        Case #SUBLANG_ENGLISH_CAN: ProcedureReturn "en_CA";
        Case #SUBLANG_ENGLISH_NZ: ProcedureReturn "en_NZ";
        Case #SUBLANG_ENGLISH_EIRE: ProcedureReturn "en_IE";
        Case #SUBLANG_ENGLISH_SOUTH_AFRICA: ProcedureReturn "en_ZA";
        Case #SUBLANG_ENGLISH_JAMAICA: ProcedureReturn "en_JM";
        Case #SUBLANG_ENGLISH_CARIBBEAN: ProcedureReturn "en_GD"; /* Grenada? */
        Case #SUBLANG_ENGLISH_BELIZE: ProcedureReturn "en_BZ";
        Case #SUBLANG_ENGLISH_TRINIDAD: ProcedureReturn "en_TT";
        Case #SUBLANG_ENGLISH_ZIMBABWE: ProcedureReturn "en_ZW";
        Case #SUBLANG_ENGLISH_PHILIPPINES: ProcedureReturn "en_PH";
        Default: ProcedureReturn "en";
      EndSelect
    Case #LANG_ESTONIAN: ProcedureReturn "et_EE";
    Case #LANG_FAEROESE: ProcedureReturn "fo_FO";
    Case #LANG_FARSI: ProcedureReturn "fa_IR";
    Case #LANG_FINNISH: ProcedureReturn "fi_FI";
    Case #LANG_FRENCH:
      Select sub
        Case #SUBLANG_FRENCH: ProcedureReturn "fr_FR";
        Case #SUBLANG_FRENCH_BELGIAN: ProcedureReturn "fr_BE";  /* WALLOON */
        Case #SUBLANG_FRENCH_CANADIAN: ProcedureReturn "fr_CA";
        Case #SUBLANG_FRENCH_SWISS: ProcedureReturn "fr_CH";
        Case #SUBLANG_FRENCH_LUXEMBOURG: ProcedureReturn "fr_LU";
        Case #SUBLANG_FRENCH_MONACO: ProcedureReturn "fr_MC";
        Default: ProcedureReturn "fr";
      EndSelect
    Case $62: ProcedureReturn "fy_NL"; /* FRISIAN */ 
    Case $67: ProcedureReturn "ful_NG"; /* FULFULDE */ 
    Case $3C: ; /* GAELIC */
      Select sub
        Case $01: ProcedureReturn "gd_GB"; /* SCOTTISH */ 
        Case $02: ProcedureReturn "ga_IE"; /* IRISH */ 
        Default: ProcedureReturn "C";
      EndSelect
    Case #LANG_GALICIAN: ProcedureReturn "gl_ES";
    Case #LANG_GEORGIAN: ProcedureReturn "ka_GE";
    Case #LANG_GERMAN:
      Select sub
        Case #SUBLANG_GERMAN: ProcedureReturn "de_DE";
        Case #SUBLANG_GERMAN_SWISS: ProcedureReturn "de_CH";
        Case #SUBLANG_GERMAN_AUSTRIAN: ProcedureReturn "de_AT";
        Case #SUBLANG_GERMAN_LUXEMBOURG: ProcedureReturn "de_LU";
        Case #SUBLANG_GERMAN_LIECHTENSTEIN: ProcedureReturn "de_LI";
        Default: ProcedureReturn "de";
      EndSelect
    Case #LANG_GREEK: ProcedureReturn "el_GR";
    Case $74: ProcedureReturn "gn_PY"; /* GUARANI */ 
    Case #LANG_GUJARATI: ProcedureReturn "gu_IN";
    Case $68: ProcedureReturn "ha_NG"; /* HAUSA */ 
    Case $75: ; /* HAWAIIAN */
      ; /* FIXME: Do they mean Hawaiian ("haw_US", 1000 speakers)
      ; Or Hawaii Creole English ("cpe_US", 600000 speakers)?  */
      ProcedureReturn "cpe_US";
    Case #LANG_HEBREW: ProcedureReturn "he_IL";
    Case #LANG_HINDI: ProcedureReturn "hi_IN";
    Case #LANG_HUNGARIAN: ProcedureReturn "hu_HU";
    Case $69: ProcedureReturn "nic_NG"; /* IBIBIO */ 
    Case #LANG_ICELANDIC: ProcedureReturn "is_IS";
    Case $70: ProcedureReturn "ibo_NG"; /* IGBO */ 
    Case #LANG_INDONESIAN: ProcedureReturn "id_ID";
    Case $5D: ProcedureReturn "iu_CA"; /* INUKTITUT */ 
    Case #LANG_ITALIAN:
      Select sub
        Case #SUBLANG_ITALIAN: ProcedureReturn "it_IT";
        Case #SUBLANG_ITALIAN_SWISS: ProcedureReturn "it_CH";
        Default: ProcedureReturn "it";
      EndSelect
    Case #LANG_JAPANESE: ProcedureReturn "ja_JP";
    Case #LANG_KANNADA: ProcedureReturn "kn_IN";
    Case $71: ProcedureReturn "kau_NG"; /* KANURI */ 
    Case #LANG_KASHMIRI:
      Select sub
        Case #SUBLANG_DEFAULT: ProcedureReturn "ks_PK";
        Case #SUBLANG_KASHMIRI_INDIA: ProcedureReturn "ks_IN";
        Default: ProcedureReturn "ks";
      EndSelect
    Case #LANG_KAZAK: ProcedureReturn "kk_KZ";
    Case #LANG_KONKANI:
      ; /* FIXME: Adjust this when such locales appear on Unix.  */
      ProcedureReturn "kok_IN";
    Case #LANG_KOREAN: ProcedureReturn "ko_KR";
    Case #LANG_KYRGYZ: ProcedureReturn "ky_KG";
    Case $54: ProcedureReturn "lo_LA"; /* LAO */ 
    Case $76: ProcedureReturn "la_VA"; /* LATIN */ 
    Case #LANG_LATVIAN: ProcedureReturn "lv_LV";
    Case #LANG_LITHUANIAN: ProcedureReturn "lt_LT";
    Case #LANG_MACEDONIAN: ProcedureReturn "mk_MK";
    Case #LANG_MALAY:
      Select sub
        Case #SUBLANG_MALAY_MALAYSIA: ProcedureReturn "ms_MY";
        Case #SUBLANG_MALAY_BRUNEI_DARUSSALAM: ProcedureReturn "ms_BN";
        Default: ProcedureReturn "ms";
      EndSelect
    Case #LANG_MALAYALAM: ProcedureReturn "ml_IN";
    Case $3A: ProcedureReturn "mt_MT"; /* MALTESE */ 
    Case #LANG_MANIPURI:
      ; /* FIXME: Adjust this when such locales appear on Unix.  */
      ProcedureReturn "mni_IN";
    Case #LANG_MARATHI: ProcedureReturn "mr_IN";
    Case #LANG_MONGOLIAN:
      ProcedureReturn "mn"; /* Ambiguous: could be "mn_CN" or "mn_MN".  */
    Case #LANG_NEPALI:
      Select sub
        Case #SUBLANG_DEFAULT: ProcedureReturn "ne_NP";
        Case #SUBLANG_NEPALI_INDIA: ProcedureReturn "ne_IN";
        Default: ProcedureReturn "ne";
      EndSelect
    Case #LANG_NORWEGIAN:
      Select sub
        Case #SUBLANG_NORWEGIAN_BOKMAL: ProcedureReturn "no_NO";
        Case #SUBLANG_NORWEGIAN_NYNORSK: ProcedureReturn "nn_NO";
        Default: ProcedureReturn "no";
      EndSelect
    Case #LANG_ORIYA: ProcedureReturn "or_IN";
    Case $72: ProcedureReturn "om_ET"; /* OROMO */ 
    Case $79: ProcedureReturn "pap_AN"; /* PAPIAMENTU */ 
    Case $63: ; /* PASHTO */
      ProcedureReturn "ps"; /* Ambiguous: could be "ps_PK" or "ps_AF".  */
    Case #LANG_POLISH: ProcedureReturn "pl_PL";
    Case #LANG_PORTUGUESE:
      Select sub
        Case #SUBLANG_PORTUGUESE: ProcedureReturn "pt_PT";
          ; /* Hmm. #SUBLANG_PORTUGUESE_BRAZILIAN == #SUBLANG_DEFAULT.
          ; Same phenomenon As #SUBLANG_ENGLISH_US == #SUBLANG_DEFAULT. */
        Case #SUBLANG_PORTUGUESE_BRAZILIAN: ProcedureReturn "pt_BR";
        Default: ProcedureReturn "pt";
      EndSelect
    Case #LANG_PUNJABI: ProcedureReturn "pa_IN";
    Case $17: ProcedureReturn "rm_CH"; /* RHAETO-ROMANCE */ 
    Case #LANG_ROMANIAN: ProcedureReturn "ro_RO";
    Case #LANG_RUSSIAN:
      ProcedureReturn "ru"; /* Ambiguous: could be "ru_RU" or "ru_UA".  */
    Case $3B: ProcedureReturn "se_NO"; /* SAMI */ 
    Case #LANG_SANSKRIT: ProcedureReturn "sa_IN";
    Case #LANG_SINDHI: ProcedureReturn "sd";
    Case $5B: ProcedureReturn "si_LK"; /* SINHALESE */ 
    Case #LANG_SLOVAK: ProcedureReturn "sk_SK";
    Case #LANG_SLOVENIAN: ProcedureReturn "sl_SI";
    Case $77: ProcedureReturn "so_SO"; /* SOMALI */ 
    Case #LANG_SORBIAN:
      ; /* FIXME: Adjust this when such locales appear on Unix.  */
      ProcedureReturn "wen_DE";
    Case #LANG_SPANISH:
      Select sub
        Case #SUBLANG_SPANISH: ProcedureReturn "es_ES";
        Case #SUBLANG_SPANISH_MEXICAN: ProcedureReturn "es_MX";
        Case #SUBLANG_SPANISH_MODERN:
          ProcedureReturn "es_ES@modern";	/* not seen on Unix */
        Case #SUBLANG_SPANISH_GUATEMALA: ProcedureReturn "es_GT";
        Case #SUBLANG_SPANISH_COSTA_RICA: ProcedureReturn "es_CR";
        Case #SUBLANG_SPANISH_PANAMA: ProcedureReturn "es_PA";
        Case #SUBLANG_SPANISH_DOMINICAN_REPUBLIC: ProcedureReturn "es_DO";
        Case #SUBLANG_SPANISH_VENEZUELA: ProcedureReturn "es_VE";
        Case #SUBLANG_SPANISH_COLOMBIA: ProcedureReturn "es_CO";
        Case #SUBLANG_SPANISH_PERU: ProcedureReturn "es_PE";
        Case #SUBLANG_SPANISH_ARGENTINA: ProcedureReturn "es_AR";
        Case #SUBLANG_SPANISH_ECUADOR: ProcedureReturn "es_EC";
        Case #SUBLANG_SPANISH_CHILE: ProcedureReturn "es_CL";
        Case #SUBLANG_SPANISH_URUGUAY: ProcedureReturn "es_UY";
        Case #SUBLANG_SPANISH_PARAGUAY: ProcedureReturn "es_PY";
        Case #SUBLANG_SPANISH_BOLIVIA: ProcedureReturn "es_BO";
        Case #SUBLANG_SPANISH_EL_SALVADOR: ProcedureReturn "es_SV";
        Case #SUBLANG_SPANISH_HONDURAS: ProcedureReturn "es_HN";
        Case #SUBLANG_SPANISH_NICARAGUA: ProcedureReturn "es_NI";
        Case #SUBLANG_SPANISH_PUERTO_RICO: ProcedureReturn "es_PR";
        Default: ProcedureReturn "es";
      EndSelect
    Case $30: ProcedureReturn "bnt_TZ"; /* SUTU */ 
    Case #LANG_SWAHILI: ProcedureReturn "sw_KE";
    Case #LANG_SWEDISH:
      Select sub
        Case #SUBLANG_DEFAULT: ProcedureReturn "sv_SE";
        Case #SUBLANG_SWEDISH_FINLAND: ProcedureReturn "sv_FI";
        Default: ProcedureReturn "sv";
      EndSelect
    Case #LANG_SYRIAC: ProcedureReturn "syr_TR"; /* An extinct language.  */
    Case $64: ProcedureReturn "tl_PH"; /* TAGALOG */ 
    Case $28: ProcedureReturn "tg_TJ"; /* TAJIK */ 
    Case $5F: ProcedureReturn "ber_MA"; /* TAMAZIGHT */ 
    Case #LANG_TAMIL:
      ProcedureReturn "ta"; /* Ambiguous: could be "ta_IN" or "ta_LK" or "ta_SG".  */
    Case #LANG_TATAR: ProcedureReturn "tt_RU";
    Case #LANG_TELUGU: ProcedureReturn "te_IN";
    Case #LANG_THAI: ProcedureReturn "th_TH";
    Case $51: ProcedureReturn "bo_CN"; /* TIBETAN */ 
    Case $73: ProcedureReturn "ti_ET"; /* TIGRINYA */ 
    Case $31: ProcedureReturn "ts_ZA"; /* TSONGA */ 
    Case #LANG_TURKISH: ProcedureReturn "tr_TR";
    Case $42: ProcedureReturn "tk_TM"; /* TURKMEN */ 
    Case #LANG_UKRAINIAN: ProcedureReturn "uk_UA";
    Case #LANG_URDU:
      Select sub
        Case #SUBLANG_URDU_PAKISTAN: ProcedureReturn "ur_PK";
        Case #SUBLANG_URDU_INDIA: ProcedureReturn "ur_IN";
        Default: ProcedureReturn "ur";
      EndSelect
    Case #LANG_UZBEK:
      Select sub
        ; /* FIXME: Adjust this when Uzbek locales appear on Unix.  */
        Case #SUBLANG_UZBEK_LATIN: ProcedureReturn "uz_UZ@latin";
        Case #SUBLANG_UZBEK_CYRILLIC: ProcedureReturn "uz_UZ@cyrillic";
        Default: ProcedureReturn "uz";
      EndSelect
    Case $33: ProcedureReturn "ven_ZA"; /* VENDA */ 
    Case #LANG_VIETNAMESE: ProcedureReturn "vi_VN";
    Case $52: ProcedureReturn "cy_GB"; /* WELSH */ 
    Case $34: ProcedureReturn "xh_ZA"; /* XHOSA */ 
    Case $78: ProcedureReturn "sit_CN"; /* YI */ 
    Case $3D: ProcedureReturn "yi_IL"; /* YIDDISH */ 
    Case $6A: ProcedureReturn "yo_NG"; /* YORUBA */ 
    Case $35: ProcedureReturn "zu_ZA"; /* ZULU */ 
    Default: ProcedureReturn "C";
    EndSelect  
EndProcedure


; IDE Options = PureBasic 4.60 Beta 3 (Windows - x86)
; CursorPosition = 157
; FirstLine = 402
; Folding = -
; EnableUnicode