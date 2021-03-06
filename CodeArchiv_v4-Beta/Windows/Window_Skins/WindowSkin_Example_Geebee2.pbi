UsePNGImageDecoder()
Procedure OpenMaskedWindow_Geebee2(winID,x,y,title.s,imID)
  hwnd=OpenWindow(winID,GetSystemMetrics_(#SM_CXSCREEN),y,128,128,title,#WS_POPUP)
  memhandle=GlobalAlloc_(#GMEM_MOVEABLE,1496)
  *mem=GlobalLock_(memhandle)
  UnpackMemory(?Geebee2_mask,*mem)
  region=ExtCreateRegion_(0,1488,*mem)
  SetWindowRgn_(hwnd,region,#True)
  pic=CatchImage(imID,?Geebee2)
  brush=CreatePatternBrush_(pic)
  SetClassLong_(hwnd,#GCL_HBRBACKGROUND,brush)
  ResizeWindow(winID,x,y,#PB_Ignore,#PB_Ignore)
  GlobalUnlock_(memhandle)
  GlobalFree_(memhandle)
  DeleteObject_(region)
  ProcedureReturn hwnd
  DataSection
  Geebee2:
    IncludeBinary "..\..\Graphics\Gfx\Geebee2.bmp"
  Geebee2_mask:
    Data.l $5D0434A ,$62C90000,$8A10000 ,$1ADA20C8,$2A100101,$82005B08,$3A7E2021,$1288DF9 ,$94EAC215,$F5822A54
    Data.l $50646A74,$21532A0A,$8C11A8AC,$83A553A7,$A9A5092 ,$60884361,$94E9D3B ,$A5A510A1,$5C9D9822,$14C4094A
    Data.l $5293384A,$11521021,$A52AA56C,$250C1285,$9D454EA3,$C2104A52,$D2874A1C,$65901151,$846B084 ,$A2292883
    Data.l $221C5BA3,$53464D58,$A262892 ,$822A0881,$54A694CD,$85165A51,$C11549C0,$BB684A60,$10A33128,$58227196
    Data.l $196D094B,$2AA2A725,$7C800E02,$946D51A6,$8AE8ADA ,$1BB3AF38,$E8942947,$CE02808A,$51E57543,$8AF2BBA 
    Data.l $D49C1B38,$BD252947,$69DE022 ,$42C2204A,$5F127B4A,$58431011,$FA949111,$232B008A,$B1849184,$414B0E74
    Data.l $329D232C,$B38C9902,$30682F58,$9D31B305,$329D0E32,$33806A0E,$A2E73258,$22BB8AF0,$D0A64218,$8A4EA8F9
    Data.l $822B08AE,$64A17431,$14A69A53,$7011A9D7,$44E8EA6E,$56C45C16,$45139304,$2E74A729,$2B5AAD4B,$14605182
    Data.l $E026DF99,$22B58AD4,$91664558,$2B722DE9,$822B08AD,$9918645D,$CC953ADD,$CE02608A,$D299114C,$8AC42B2A
    Data.l $47D81D60,$2D49B5A6,$8AB22B0 ,$648D9216,$E2D4CB52,$608A822A,$A64A9927,$AAADB0B4,$C6085822,$3A740992
    Data.l $2A8BAA6B,$4000B982,$8B3D8E98,$B260B060,$12CD684C,$12D08985,$8CB38221,$A36751F3,$4ED225A2,$8CB51968
    Data.l $B08451B3,$3B512769,$32C265B1,$104647CE,$94CC16AB,$A16B53B5,$194EE32C,$E32B407 ,$D81CD86A,$69669DB2
    Data.l $D49D653B,$1C65CE32,$C70CB6DE,$9DBC3B75,$196132D4,$8823A107,$CC210B95,$B9D29DC ,$29DD1964,$C6549823
    Data.l $96A00D01,$7C6734EE,$62CE32F ,$52C152A1,$A42738A7,$87199DD2,$CEB67537,$5C535408,$CEEA3096,$9881AD62
    Data.l $78255043,$10210CA7,$22447CC1,$7F11    
    Data.b $0,$0
  EndDataSection
EndProcedure

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -