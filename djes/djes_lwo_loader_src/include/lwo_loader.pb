;**********************
;* by djes
;* http://djes.free.fr
;* 4 nov 2005
;**********************

;IncludePath "..\include\"
XIncludeFile "headers.pb"

;*********************************************************************************************************************************************************************

Procedure LWO_Load(filename.s)
;*
;* >= Filename.s : name of lwo file to load
;*

	f.f=0																								;a float var
	w.w=0																								;a word var
	l.l=0																								;a long var
	
	points_index_start.l=0

	;*** Does the file exists?

	If ReadFile(0,filename)

		v.l=ReadLong(0)																					;read a long
		tag.s="AAAA"
		PokeL(@tag,v)																					;write rode tag in tag string
		Debug "FORM? -> "+tag,2

		filesize.l=ReadLong(0)																			;read a long
		MOV eax,filesize																				;convert endians and put the int to float
		BSWAP eax 
		MOV filesize,eax		
		Debug "File size = "+Str(filesize),2

		v.l=ReadLong(0)																					;read a long
		tag2.s="AAAA"
		PokeL(@tag2,v)																					;write rode tag in tag string
		Debug "File type : "+tag2,2

		;*** Regular IFF file ?
	
		If tag="FORM" And Lof(0)=filesize+8 And tag2="LWO2" And Eof(0) = #Null	

			AddElement(objects())
			object_id.l=ListIndex(objects())
	
			total_points_nb.l=0
			total_layers_nb.l=0
			total_polygons_nb.l=0
	
			;*** Looking for tags
	
			While Eof(0) = #Null																		;loop as long the 'end of file' isn't reached
	
				v.l=ReadLong(0)																			;read a long
				tag.s="AAAA"
				PokeL(@tag,v)		
				Debug v,2
	
				;*** Proceed tags
	
				Select tag
	
				Case "LAYR"
	
					;*** Layer found
	
					Debug "LAYR found",2
					AddElement(layers())
					total_layers_nb+1
					layers()\object_id=object_id
					layer_id.l=ListIndex(layers())
	
					;*** Pass over the tag
	
					v.l=ReadLong(0)																		;read a long
					MOV eax,v																			;convert endians and put the int to float
					BSWAP eax 
					MOV v,eax
;					!MOV eax,dword [v_v]																;convert endians and put the int to float
;					!bswap eax 
;					!MOV dword [v_v],eax
					Debug Str(v),3
					FileSeek(0,Loc(0)+v)																	;jump over the tag
		
					;*** Process rest of the LAYR tag
	
					While Eof(0) = #Null																;loop as long the 'end of file' isn't reached
	
						v.l=ReadLong(0)																	;read a long
						tag.s="AAAA"
						PokeL(@tag,v)
						
						;*** Looking for geometry tags
	
						Select tag
	
						Case "PNTS"
	
							;*** Points found
	
							Debug "PNTS found",2
							
							;*** Nb of points
	
							nb.l=ReadLong(0)																;read a long
							MOV eax,nb																	;convert endians 
							BSWAP eax 
							MOV nb,eax	
;							!MOV eax,dword [v_nb]														;convert endians 
;							!bswap eax 
;							!MOV dword [v_nb],eax	
							Debug "Nb of points : "+Str(nb/12),2
							points_index_start=ListIndex(points())+1

							;*** One point = 12 bytes mini (4 bytes per axis)
	
							If nb>=$C						
	
								;*** Loop over points
	
								While Eof(0) = #Null And nb>0											;read sequentially x, y, z
	
									;*** New point
	
									AddElement(points())
									AddElement(transformed_points())
									total_points_nb+1
	
									l.l=ReadLong(0)														;read a long
									MOV eax,l															;convert endians and put the int to float
									BSWAP eax 
									MOV f,eax	
;									!MOV eax,dword [v_l]												;convert endians and put the int to float
;									!bswap eax 
;									!MOV dword [v_f],eax	
									points()\x=f													
									Debug "x  "+StrF(f),3
	
									l.l=ReadLong(0)
									MOV eax,l															;convert endians and put the int to float
									BSWAP eax 
									MOV f,eax	
;									!MOV eax,dword [v_l]
;									!bswap eax 
;									!MOV dword [v_f],eax	
									points()\y=f
									Debug "y  "+StrF(f),3
	
									l.l=ReadLong(0)
									MOV eax,l															;convert endians and put the int to float
									BSWAP eax 
									MOV f,eax	
;									!MOV eax,dword [v_l]
;									!bswap eax 
;									!MOV dword [v_f],eax	
									points()\z=f
									Debug "z  "+StrF(f),3
	
									nb-12
	
								Wend
							EndIf
						
						Case "POLS"
						
							;*** Polygons found
	
							Debug "POLS found",2
						
							;*** Get size of this tag to process only this one
	
							pols_tagsize.l=ReadLong(0)													;read a long
							MOV eax,pols_tagsize														;convert endians 
							BSWAP eax 
							MOV pols_tagsize,eax	
;							!MOV eax,dword [v_pols_tagsize]												;convert endians 
;							!bswap eax 
;							!MOV dword [v_pols_tagsize],eax
	
							If Eof(0) = #Null
	
								;*** Get polygon type
	
								v.l=ReadLong(0)
								pols_tagsize-4
								tag.s="AAAA"
								PokeL(@tag,v)
								Debug tag,3
		
								Select tag
								Case "FACE"
								
									;*** Regular polygon found (first, nb of points, then index of points)
	
									Debug "FACE found",2
		
									;*** Process tag
	
									While Eof(0) = #Null And pols_tagsize>0							
		
										;*** How many points in this pol
	
										points_nb.w=ReadWord(0)
										pols_tagsize-2
										MOV ax,points_nb												;convert endians
										XCHG ah,al 
										MOV points_nb,ax
;										!MOV ax,word [v_points_nb]										;convert endians
;										!xchg ah,al 
;										!MOV word [v_points_nb],ax
										Debug "Nb of points in this polygon : "+Str(points_nb),2
					
										If points_nb>0							
	
											;*** There's at least one point : new polygon
	
											AddElement(polygons())
											total_polygons_nb+1
											polygons()\points_nb=points_nb
											polygons()\points_list=ListIndex(polygon_points_index())+1	;This polygon first point index position
											polygons()\layer_id=layer_id
	
											;*** Process all points of this poly : store indexes in polygon_points_index(), and first one pos in the polygon structure, with the nb of points
	
											While Eof(0) = #Null And points_nb>0

												AddElement(polygon_points_index())	

												;*** Is this a long index, or a short? (more than 65279 points in this poly:long)
	
												If ReadByte(0)<>$FF										;read first byte, if $FF, index is a long, else it's a word
	
													;*** New short (word, 2 bytes) size index
	
													FileSeek(0,Loc(0)-1)									;read a word
													w.w=ReadWord(0)	
													pols_tagsize-2
													MOV ax,w											;convert endians
													XCHG ah,al
													MOV w,ax
;													!MOV ax,word [v_w]									;convert endians
;													!xchg ah,al
;													!MOV word [v_w],ax
													polygon_points_index()=w+points_index_start			;value+start of this object's points list
													Debug "num:"+Str(points_nb),3
													Debug w,3
													points_nb-1

												Else
	
													;*** New long (3 bytes in fact) size index
	
													FileSeek(0,Loc(0)-1)									;read a long
													l.l=ReadLong(0)	
													pols_tagsize-4
													MOV eax,l											;convert endians
													BSWAP eax 
													And eax,$00FFFFFF
													MOV l,eax
;													!MOV eax,dword [v_l]								;convert endians
;													!bswap eax 
;													!AND eax,$00FFFFFF
;													!MOV dword [v_l],eax
													polygon_points_index()=l+points_index_start			;value+start of this object's points list
													Debug "num:"+Str(points_nb),3
													Debug l,3
													points_nb-1					
	
												EndIf										
											Wend
										EndIf
									Wend
									
								Case "PTCH"
								
									;*** Patch polygon found (first, nb of points, then index of points). Read only the cage polygons
	
									Debug "PTCH found",2
		
									;*** Process tag
	
									While Eof(0) = #Null And pols_tagsize>0							
		
										;*** How many points in this pol
	
										points_nb.w=ReadWord(0)
										pols_tagsize-2
										MOV ax,points_nb												;convert endians
										XCHG ah,al 
										MOV points_nb,ax
;										!MOV ax,word [v_points_nb]										;convert endians
;										!xchg ah,al 
;										!MOV word [v_points_nb],ax
										Debug "Nb of points in this patch polygon : "+Str(points_nb),2
					
										If points_nb>0							
	
											;*** There's at least one point : new polygon
	
											AddElement(polygons())
											total_polygons_nb+1
											polygons()\points_nb=points_nb
											polygons()\points_list=ListIndex(polygon_points_index())+1	;This polygon first point index position
											polygons()\layer_id=layer_id
	
											;*** Process all points of this poly : store indexes in polygon_points_index(), and first one pos in the polygon structure, with the nb of points
	
											While Eof(0) = #Null And points_nb>0
	
												AddElement(polygon_points_index())
											
												;*** Is this a long index, or a short? (more than 65279 points in this poly:long)
	
												If ReadByte(0)<>$FF										;read first byte, if $FF, index is a long, else it's a word
	
													;*** New short (word, 2 bytes) size index
	
													FileSeek(0,Loc(0)-1)									;read a word
													w.w=ReadWord(0)	
													pols_tagsize-2
													MOV ax,w											;convert endians
													XCHG ah,al
													MOV w,ax
;													!MOV ax,word [v_w]									;convert endians
;													!xchg ah,al
;													!MOV word [v_w],ax
													polygon_points_index()=w+points_index_start			;value+start of this object's points list
													Debug "num:"+Str(points_nb),3
													Debug w,3
													points_nb-1

												Else
	
													;*** New long (3 bytes in fact) size index
	
													FileSeek(0,Loc(0)-1)									;read a long
													l.l=ReadLong(0)	
													pols_tagsize-4
													MOV eax,l											;convert endians
													BSWAP eax 
													And eax,$00FFFFFF
													MOV l,eax
;													!MOV eax,dword [v_l]								;convert endians
;													!bswap eax 
;													!AND eax,$00FFFFFF
;													!MOV dword [v_l],eax
													polygon_points_index()=l+points_index_start			;value+start of this object's points list
													Debug "num:"+Str(points_nb),3
													Debug l,3
													points_nb-1
	
												EndIf										
											Wend
										EndIf
									Wend									
								Default

									;*** Pass over the unknown tag
					
									Debug tag+" found",2
									FileSeek(0,Loc(0)+pols_tagsize)
					
								EndSelect
							EndIf

						Default

							;*** Pass over the unknown tag
			
							Debug tag+" found",2
							v.l=ReadLong(0)																;read a long
							MOV eax,v																	;convert endians and put the int to float
							BSWAP eax 
							MOV v,eax
		;					!MOV eax,dword [v_v]														;convert endians and put the int to float
		;					!bswap eax 
		;					!MOV dword [v_v],eax
							Debug Str(v),3
							FileSeek(0,Loc(0)+v)
			
						EndSelect
						;**************************
					Wend
					
					current_layer+1																		;next layer (if exists)
				
				;*** Process others tag
	
				Default
	
					Debug tag+" found",2
					l.l=ReadLong(0)
					MOV eax,l																			;convert endians
					BSWAP eax 
					MOV l,eax
;					!MOV eax,dword [v_l]																;convert endians
;					!bswap eax 
;					!MOV dword [v_l],eax
					Debug l,3
					FileSeek(0,Loc(0)+l)																	;jump over the tag
	
				EndSelect
				;**************************
				
			Wend
			
		EndIf
		
		CloseFile(0)              																		; close the previously opened file
	
	Else
	
		MessageRequester("Information","Couldn't open the file!")
	
	EndIf
	
	Debug Str(total_layers_nb)+" layer(s)",1
	Debug Str(total_polygons_nb)+" polygon(s)",1
	Debug Str(total_points_nb)+" point(s)",1

EndProcedure	

;*********************************************************************************************************************************************************************



; IDE Options = PureBasic v4.00 (Windows - x86)
; CursorPosition = 6
; Folding = -
; EnableAsm