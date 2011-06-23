; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7503&highlight=
; Author: Tinman (updated for PB4.00 by blbltheworm)
; Date: 11. January 2003
; OS: Windows
; Demo: No

; License:      You are free to use this code in any way you like. Please send the author any changes 
;               you make so that the original source can be kept up-to-date. A "thank you" in your 
;               software documentation would be nice but is not required. 

; Description:  Additional sorting algorithms and things to enhance the PB sort library. 
;               Pretty much just re-implementations of various sorting routines and comparison 
;               functions which operate like the standard C libraries. 
; 
;               The benefits are that (using these procedures) you can now sort arrays AND lists, 
;               sort any type of variable (simple built in types or structured types), you can sort 
;               on any field within a structure, have a choice of sort algorithms and the system 
;               is flexible enough so that if this does not meet your needs you can change it. 
; 
;               The way to use these procedures is to call the procedures for sorting (e.g. 
;               Sort_ArraySelection, Sort_ListQuick - the format is Sort_<Storage type><Sort Algorithm>) 
;               and not any of the others (such as the internal ones or the compare procedures). 
; 
;               All sort procedures follow the same format. You must specify the following items: 
;                   - address at which the array or list starts 
;                   - Index or address of first item to include in the sort (this item gets sorted) 
;                   - Index or address of last item to include in the sort (this item gets sorted) 
;                   - The size of each item in the list or array - use SizeOf to get the size of 
;                     structures and look in the PureBasic manual for sizes of basic types (with 
;                     the exception that strings are 4!) 
;                   - The address of a function which is used to compare items in the array or list. 
;                     Some comparison functions have been provided which allow you to compare any type 
;                     of built in type. 
;                   - The direction to sort in 
;                   - An offset to allow you to sort on any field within structured arrays and lists. 
;                     Currently the easiest way to create this value is to use something like 
;                     "@array(0)\field - @array(0)" so PureBasic will calculate the offset for you. 
; 
;               There are also stripped down sort functions (they have a "B" at the end of their names) 
;               which take less parameters and have simpler inner loops, so they *might* be slightly 
;               faster. However, the user should write their own comparison function which returns 
;               the correct result for the sort direction they want and compares the correct fields 
;               if it is structured types they are dealing with. 
; 
;               Please not that these procedures have been written to be portable across the different 
;               PureBasic compilers (as much as possible). That means these procedures are written in 
;               basic, so do not expect them to be as fast as they would if they were written in assembly 
;               language. 
; 
;               Also note that the list sort procedures are a lot slower than they could be - there is 
;               no way to hack into PureBasic's list structure yet (someone want to write a library with 
;               a ListAddress() command? :) so the data in each element must be copied rather than 
;               simply swapping the pointers. It may not be noticable for smaller elements (such as 
;               a list of one of the built in types) but it will be worse with large user-defined structures. 
; 
;               A demo can be found in the "sort_extras_test.pb" file which should have been included 
;               in the original archive with this file. 

; Authors:      David McMinn (dave@blitz-2000.co.uk) 

; Type:         Misc 

; Contents: 
;  ! PRIVATE !  Procedure int_Sort_ExchangeData(*first.bptr, *second.bptr, data_size.l) 
;               Procedure.l Sort_CompareByte(*first.bptr, *second.bptr) 
;               Procedure.l Sort_CompareWord(*first.wptr, *second.wptr) 
;               Procedure.l Sort_CompareLong(*first.lptr, *second.lptr) 
;               Procedure.l Sort_CompareFloat(*first.fptr, *second.fptr) 
;               Procedure.l Sort_CompareString(*first.sptr, *second.sptr) 
;               Procedure.l Sort_CompareLocale(*first.sptr, *second.sptr) 
;               Procedure.l Sort_CompareLocale(*first.sptr, *second.sptr) 
;               Procedure.l Sort_CompareStringI(*first.sptr, *second.sptr) 
;               Procedure.l Sort_CompareLocaleI(*first.sptr, *second.sptr) 
;               Procedure Sort_ArraySelection(base_address.l, start_index.l, end_index.l, item_size.l, compare_function.l, direction.l, field_offset.l) 
;               Procedure Sort_ArrayDoubleSelection(base_address.l, start_index.l, end_index.l, item_size.l, compare_function.l, direction.l, field_offset.l) 
;               Procedure Sort_ArrayQuick(base_address.l, start_index.l, end_index.l, item_size.l, compare_function.l, direction.l, field_offset.l, field_offset.l) 
;               Procedure Sort_ListSelection(base_address.l, *start_element.Element, *end_element.Element, item_size.l, compare_function.l, direction.l, field_offset.l) 
;               Procedure Sort_ListQuick(base_address.l, *start_element.Element, *end_element.Element, item_size.l, compare_function.l, direction.l, field_offset.l) 

; Requires: 
;               Additional useful structures for pointer access to simple types (structures.pb) 

; History: 
;   To do               Assembly string compare case insensitive function (since the current compare function is slow) 
;   To do               Double ended selection sort for lists 
;   To do               Find some way to swap pointers in lists rather than exchange data (will also require changes to list sort procedure point handling). A ListAddress() command in PB would be nice :) 
;   11th January 2003   Localsied string comparison function (Windows only ATM) 
;                       Case insensitive string comparisons 
;                       Stripped down and simplified sort procedures (which would require additional compare functions by the user) 
;                       Removed some useless code from the list quick sort procedures 
;   6th January 2003    Simplified and optimised operation of quick sort algorithms a bit 
;   5th January 2003    Added quick sort for arrays and lists 
;                       Added field_offset parameters to sort functions so structured arrays could be sorted on any field using the built in compare functions 
;   4th January 2002    Comparison functions for all built in PB types completed 
;                       Added separate single and double ended selection sort procedures 
;                       Added procedure for exchanging data at two addresses of any size 
;                       Changed names of procedures to make them more identifiable 
;   3th January 2003    Created due to need to sort something which the Sort library could not handle 

Structure bptr  ; Structure for accessing data with pointers to bytes, or pointers to arrays of bytes
    b.b[0]
EndStructure

Structure wptr  ; As above, for words
    w.w[0]
EndStructure


Structure lptr  ; As abive, for longs
    l.l[0]
EndStructure


Structure fptr  ; As above, for floats
    f.f[0]
EndStructure


Structure sptr  ; As above, for strings
    s.s[0]
EndStructure

Structure Element       ; Structure at the start of each element in a PB linked list
    *next.Element       ; Pointer to next element in list or NULL for end of list
    *prev.Element       ; Pointer to previous element in list or NULL for start of list
EndStructure


; Name:         int_Sort_ExchangeData 
; Synopsis:     int_Sort_ExchangeData(*first, *second, data_size) 
; Parameters:   *first.bptr - Address of first data item to be swapped 
;               *second.bptr- Address of second data item to be swapped 
;               data_size.l - Size of data to swap 
; Returns:      Nothing 
; Globals:      None 
; Description:  Internal function for sort routines. Used to swap the data stored at 
;               two non-overlapping addresses. 
Procedure int_Sort_ExchangeData(*first.bptr, *second.bptr, data_size.l) 
    Define.l   copy_long   ; Used when exchanging data 4 bytes at a time 
    Define.b   copy_byte   ; Used when exchanging data 1 byte at a time 

    ; Copy as much as possible using longs (which would hopefully be quicker than using bytes) 
    While data_size>=4 
        copy_long = PeekL(*first) 
        PokeL(*first, PeekL(*second)) 
        *first + 4 
        
        PokeL(*second, copy_long) 
        *second + 4 
        
        data_size - 4 
    Wend 
    
    ; Any left over parts are done using bytes 
    While data_size>0 
        copy_byte = PeekB(*first) 
        PokeB(*first, PeekB(*second)) 
        *first + 1 
        
        PokeB(*second, copy_byte) 
        *second + 1 
        
        data_size - 1 
    Wend 
EndProcedure 


; Name:         Sort_CompareByte 
; Synopsis:     compare = Sort_CompareByte(*first, *second) 
; Parameters:   *first.bptr - Address of the first byte to compare 
;               *second.bptr- Address of the second byte to compare 
; Returns:      compare.l - Long showing the relationship between the two items to compare: 
;                           first < second ... compare is negative 
;                           first = second ... compare is 0 
;                           first > second ... compare is positive 
; Globals:      None 
; Description:  A procedure which can be used as the compare function for the sorting procedures. 
;               It takes pointers to the two items to compare, compares them and then returns 
;               a result in the above format (which is a requirement of all compare procedures). 
;               This procedure simply compares the bytes at the addresses given, but of course it 
;               could do anything as long as the compare function is written specifically for the 
;               data stored in the array or list being sorted. 
Procedure.l Sort_CompareByte(*first.bptr, *second.bptr) 
    If *first\b[0]<*second\b[0] 
        ProcedureReturn -1 
    ElseIf *first\b[0]=*second\b[0] 
        ProcedureReturn 0 
    Else 
        ProcedureReturn 1 
    EndIf 
EndProcedure 


; Name:         Sort_CompareWord 
; Synopsis:     compare = Sort_CompareWord(*first, *second) 
; Parameters:   *first.wptr - Address of the first word to compare 
;               *second.wptr- Address of the second word to compare 
; Returns:      compare.l - Long showing the relationship between the two items to compare: 
;                           first < second ... compare is negative 
;                           first = second ... compare is 0 
;                           first > second ... compare is positive 
; Globals:      None 
; Description:  A procedure which can be used as the compare function for the sorting procedures. 
;               It takes pointers to the two items to compare, compares them and then returns 
;               a result in the above format (which is a requirement of all compare procedures). 
;               This procedure simply compares the words at the addresses given, but of course it 
;               could do anything as long as the compare function is written specifically for the 
;               data stored in the array or list being sorted. 
Procedure.l Sort_CompareWord(*first.wptr, *second.wptr) 
    If *first\w[0]<*second\w[0] 
        ProcedureReturn -1 
    ElseIf *first\w[0]=*second\w[0] 
        ProcedureReturn 0 
    Else 
        ProcedureReturn 1 
    EndIf 
EndProcedure 


; Name:         Sort_CompareLong 
; Synopsis:     compare = Sort_CompareLong(*first, *second) 
; Parameters:   *first.lptr - Address of the first long to compare 
;               *second.lptr- Address of the second long to compare 
; Returns:      compare.l - Long showing the relationship between the two items to compare: 
;                           first < second ... compare is negative 
;                           first = second ... compare is 0 
;                           first > second ... compare is positive 
; Globals:      None 
; Description:  A procedure which can be used as the compare function for the sorting procedures. 
;               It takes pointers to the two items to compare, compares them and then returns 
;               a result in the above format (which is a requirement of all compare procedures). 
;               This procedure simply compares the longs at the addresses given, but of course it 
;               could do anything as long as the compare function is written specifically for the 
;               data stored in the array or list being sorted. 
Procedure.l Sort_CompareLong(*first.lptr, *second.lptr) 
    If *first\l[0]<*second\l[0] 
        ProcedureReturn -1 
    ElseIf *first\l[0]=*second\l[0] 
        ProcedureReturn 0 
    Else 
        ProcedureReturn 1 
    EndIf 
EndProcedure 


; Name:         Sort_CompareFloat 
; Synopsis:     compare = Sort_CompareFloat(*first, *second) 
; Parameters:   *first.fptr - Address of the first float to compare 
;               *second.fptr- Address of the second float to compare 
; Returns:      compare.l - Long showing the relationship between the two items to compare: 
;                           first < second ... compare is negative 
;                           first = second ... compare is 0 
;                           first > second ... compare is positive 
; Globals:      None 
; Description:  A procedure which can be used as the compare function for the sorting procedures. 
;               It takes pointers to the two items to compare, compares them and then returns 
;               a result in the above format (which is a requirement of all compare procedures). 
;               This procedure simply compares the floats at the addresses given, but of course it 
;               could do anything as long as the compare function is written specifically for the 
;               data stored in the array or list being sorted. 
Procedure.l Sort_CompareFloat(*first.fptr, *second.fptr) 
    If *first\f[0]<*second\f[0] 
        ProcedureReturn -1 
    ElseIf *first\f[0]=*second\f[0] 
        ProcedureReturn 0 
    Else 
        ProcedureReturn 1 
    EndIf 
EndProcedure 


; Name:         Sort_CompareString 
; Synopsis:     compare = Sort_CompareString(*first, *second) 
; Parameters:   *first.sptr - Address of the first string to compare 
;               *second.sptr- Address of the second string to compare 
; Returns:      compare.l - Long showing the relationship between the two items to compare: 
;                           first < second ... compare is negative 
;                           first = second ... compare is 0 
;                           first > second ... compare is positive 
; Globals:      None 
; Description:  A procedure which can be used as the compare function for the sorting procedures. 
;               It takes pointers to the two items to compare, compares them and then returns 
;               a result in the above format (which is a requirement of all compare procedures). 
;               This procedure simply compares the strings at the addresses given, but of course it 
;               could do anything as long as the compare function is written specifically for the 
;               data stored in the array or list being sorted. 
Procedure.l Sort_CompareString(*first.sptr, *second.sptr) 
    If *first\s[0]<*second\s[0] 
        ProcedureReturn -1 
    ElseIf *first\s[0]=*second\s[0] 
        ProcedureReturn 0 
    Else 
        ProcedureReturn 1 
    EndIf 
EndProcedure 


; Missing from the PB resident 
#NORM_IGNOREWIDTH = $00020000  ; ignore width 


; Name:         Sort_CompareLocale 
; Synopsis:     compare = Sort_CompareLocale(*first, *second) 
; Parameters:   *first.sptr - Address of the first string to compare 
;               *second.sptr- Address of the second string to compare 
; Returns:      compare.l - Long showing the relationship between the two items to compare: 
;                           first < second ... compare is negative 
;                           first = second ... compare is 0 
;                           first > second ... compare is positive 
; Globals:      None 
; Description:  A procedure which can be used as the compare function for the sorting procedures. 
;               It takes pointers to the two items to compare, compares them and then returns 
;               a result in the above format (which is a requirement of all compare procedures). 
;               This procedure compares two strings but is also capable of working with 
;               non-English characters (for example ä, ê, ó, ù, and so on). 
; 
;               Currently only usable under Windows. 
Procedure.l Sort_CompareLocale(*first.sptr, *second.sptr) 
    CompilerSelect #PB_Compiler_OS 
        CompilerCase 1  ; Windows 
            ProcedureReturn CompareString_(#LOCALE_USER_DEFAULT, #NORM_IGNOREWIDTH|#SORT_STRINGSORT, @*first\s[0], -1, @*second\s[0], -1) - 2 
    CompilerEndSelect 
EndProcedure 


; Name:         Sort_CompareStringI 
; Synopsis:     compare = Sort_CompareStringI(*first, *second) 
; Parameters:   *first.sptr - Address of the first string to compare 
;               *second.sptr- Address of the second string to compare 
; Returns:      compare.l - Long showing the relationship between the two items to compare: 
;                           first < second ... compare is negative 
;                           first = second ... compare is 0 
;                           first > second ... compare is positive 
; Globals:      None 
; Description:  A procedure which can be used as the compare function for the sorting procedures. 
;               It takes pointers to the two items to compare, compares them and then returns 
;               a result in the above format (which is a requirement of all compare procedures). 
;               This procedure simply compares the strings at the addresses given, but of course it 
;               could do anything as long as the compare function is written specifically for the 
;               data stored in the array or list being sorted. 
; 
;               This procedure uses a case insensitive compare. 
Procedure.l Sort_CompareStringI(*first.sptr, *second.sptr) 
    Define.s   first_lower 
    Define.s   second_lower 

    first_lower = LCase(*first\s[0]) 
    second_lower = LCase(*second\s[0]) 
    
    If first_lower<second_lower 
        ProcedureReturn -1 
    ElseIf first_lower=second_lower 
        ProcedureReturn 0 
    Else 
        ProcedureReturn 1 
    EndIf 
EndProcedure 


; Name:         Sort_CompareLocaleI 
; Synopsis:     compare = Sort_CompareLocaleI(*first, *second) 
; Parameters:   *first.sptr - Address of the first string to compare 
;               *second.sptr- Address of the second string to compare 
; Returns:      compare.l - Long showing the relationship between the two items to compare: 
;                           first < second ... compare is negative 
;                           first = second ... compare is 0 
;                           first > second ... compare is positive 
; Globals:      None 
; Description:  A procedure which can be used as the compare function for the sorting procedures. 
;               It takes pointers to the two items to compare, compares them and then returns 
;               a result in the above format (which is a requirement of all compare procedures). 
;               This procedure compares two strings but is also capable of working with 
;               non-English characters (for example ä, ê, ó, ù, and so on). This comparison 
;               is case insensitive. 
; 
;               Currently only usable under Windows. 
Procedure.l Sort_CompareLocaleI(*first.sptr, *second.sptr) 
    CompilerSelect #PB_Compiler_OS 
        CompilerCase 1  ; Windows 
            ProcedureReturn CompareString_(#LOCALE_USER_DEFAULT, #NORM_IGNORECASE|#NORM_IGNOREWIDTH|#SORT_STRINGSORT, @*first\s[0], -1, @*second\s[0], -1) - 2 
    CompilerEndSelect 
EndProcedure 


; Name:         Sort_ArraySelection 
; Synopsis:     Sort_ArraySelection(base_address, start_index, end_index, item_size, compare_function, direction, field_offset) 
; Parameters:   base_address.l      - Address of the start of the array 
;               start_index.l       - Index number of the first item to include in the sort 
;               end_index.l         - Index number of the last item to include in the sort 
;               item_size.l         - Size in bytes of each item in the array 
;               compare_function.l  - Address of a function which is used to compare the items in the array. 
;                                     This function must take two parameters, each one being pointers to items 
;                                     in the array. It must return a value to indicate their relationship 
;                                     in the following way: first < second ... negative value 
;                                                           first = second ... 0 
;                                                           first > second ... positive value 
;                                     See the default comparison functions for examples. 
;               direction.l         - Flag showing what direction to sort in. 0 means ascending, non-zero means descending. 
;               field_offset.l      - This value is added to the address of each item in the array before the comparison 
;                                     is called. This allows the user to sort structured arrays on a field which is not 
;                                     at the start of a structure using the standard comparison procedures. 
; Returns:      Nothing 
; Globals:      None 
; Description:  Sorts the specified array (or the items between the start and end positions (inclusive)) 
;               using the selection sort algorithm. 
Procedure Sort_ArraySelection(base_address.l, start_index.l, end_index.l, item_size.l, compare_function.l, direction.l, field_offset.l) 
    Define.l   current_position 
    Define.l   comparison 
    Define.l   new_index           ; Index of new item to store in the current index 

    ; Make sure we have some valid inputs to the function 
    If base_address And compare_function 
    
        While start_index<end_index 
        
            new_index = start_index 
            
            For current_position=start_index+1 To end_index 
                ; Check if we should use this current item as the new lower index 
                comparison = CallFunctionFast(compare_function, base_address + new_index * item_size + field_offset, base_address + current_position * item_size + field_offset) 
                If (comparison>0 And direction=0) Or (comparison<0 And direction<>0) 
                    new_index = current_position 
                EndIf 
            Next 
        
            ; Perform the actual data swap for the item which should go earlier in the array 
            If new_index<>start_index 
                int_Sort_ExchangeData(base_address + new_index * item_size, base_address + start_index * item_size, item_size) 
            EndIf 

            ; Increase the start index value as we are sure that the smallest item is in there, 
            ; therefore we do not need to include it in the loop any more. 
            start_index + 1 
        Wend 
    
    EndIf 
EndProcedure 


; Name:         Sort_ArrayDoubleSelection 
; Synopsis:     Sort_ArrayDoubleSelection(base_address, start_index, end_index, item_size, compare_function, direction, field_offset) 
; Parameters:   base_address.l      - Address of the start of the array 
;               start_index.l       - Index number of the first item to include in the sort 
;               end_index.l         - Index number of the last item to include in the sort 
;               item_size.l         - Size in bytes of each item in the array 
;               compare_function.l  - Address of a function which is used to compare the items in the array. 
;                                     This function must take two parameters, each one being pointers to items 
;                                     in the array. It must return a value to indicate their relationship 
;                                     in the following way: first < second ... negative value 
;                                                           first = second ... 0 
;                                                           first > second ... positive value 
;                                     See the default comparison functions for examples. 
;               direction.l         - Flag showing what direction to sort in. 0 means ascending, non-zero means descending. 
;               field_offset.l      - This value is added to the address of each item in the array before the comparison 
;                                     is called. This allows the user to sort structured arrays on a field which is not 
;                                     at the start of a structure using the standard comparison procedures. 
; Returns:      Nothing 
; Globals:      None 
; Description:  Sorts the specified array (or the items between the start and end positions (inclusive)) 
;               using the selection sort algorithm. The difference between this procedure and the above one 
;               is that this procedure selects the new items at both ends of the array at the same time, 
;               not just one as with the standard Selection sort. This may be faster in some cases. 
Procedure Sort_ArrayDoubleSelection(base_address.l, start_index.l, end_index.l, item_size.l, compare_function.l, direction.l, field_offset.l) 
    Define.l   current_position 
    Define.l   comparison 
    Define.l   new_lower           ; Index of new item to store in the lower index 
    Define.l   new_higher          ; Index of new item to store in the upper index 


    ; Make sure we have some valid inputs to the function 
    If base_address And compare_function 
    
        While start_index<end_index 
        
            new_lower = start_index 
            new_higher = end_index 
            
            For current_position=start_index To end_index 
                ; Check if we should use this current item as the new lower index 
                comparison = CallFunctionFast(compare_function, base_address + new_lower * item_size + field_offset, base_address + current_position * item_size + field_offset) 
                If (comparison>0 And direction=0) Or (comparison<0 And direction<>0) 
                    new_lower = current_position 
                EndIf 
                
                ; Check if we should use this current item as the new lower index 
                comparison = CallFunctionFast(compare_function, base_address + new_higher * item_size + field_offset, base_address + current_position * item_size + field_offset) 
                If (comparison<0 And direction=0) Or (comparison>0 And direction<>0) 
                    new_higher = current_position 
                EndIf 
            Next 
        
            ; Perform the actual data swap for the item which should go earlier in the array 
            If new_lower<>start_index 
                int_Sort_ExchangeData(base_address + new_lower * item_size, base_address + start_index * item_size, item_size) 
            EndIf 
            
            ; Perform the actual data swap for the item which should go later in the array 
            If new_higher<>end_index And new_higher<>new_lower 
                ; If we swapped the higher item when we swapped in the lowest item, we need 
                ; to adjust the new higher item to show the correct position to get the value from 
                If new_higher=start_index 
                    new_higher = new_lower 
                EndIf 
                
                int_Sort_ExchangeData(base_address + new_higher * item_size, base_address + end_index * item_size, item_size) 
            EndIf 
        
            start_index + 1 
            end_index - 1 
        Wend 
    
    EndIf 
EndProcedure 


; Name:         Sort_ArrayQuick 
; Synopsis:     Sort_ArrayQuick(base_address, start_index, end_index, item_size, compare_function, direction, field_offset) 
; Parameters:   base_address.l      - Address of the start of the array 
;               start_index.l       - Index number of the first item to include in the sort 
;               end_index.l         - Index number of the last item to include in the sort 
;               item_size.l         - Size in bytes of each item in the array 
;               compare_function.l  - Address of a function which is used to compare the items in the array. 
;                                     This function must take two parameters, each one being pointers to items 
;                                     in the array. It must return a value to indicate their relationship 
;                                     in the following way: first < second ... negative value 
;                                                           first = second ... 0 
;                                                           first > second ... positive value 
;                                     See the default comparison functions for examples. 
;               direction.l         - Flag showing what direction to sort in. 0 means ascending, non-zero means descending. 
;               field_offset.l      - This value is added to the address of each item in the array before the comparison 
;                                     is called. This allows the user to sort structured arrays on a field which is not 
;                                     at the start of a structure using the standard comparison procedures. 
; Returns:      Nothing 
; Globals:      None 
; Description:  Sorts the specified array (or the items between the start and end positions (inclusive)) 
;               using the quick sort algorithm. 
Procedure Sort_ArrayQuick(base_address.l, start_index.l, end_index.l, item_size.l, compare_function.l, direction.l, field_offset.l) 
    Define.l   new_lower 
    Define.l   new_higher 
    Define.l   centre_point 
    Define.l   comparison 
    
    If base_address And compare_function 
    
        new_lower = start_index 
        new_higher = end_index 
        centre_point = (start_index + end_index) / 2 
        
        Repeat 
            comparison = CallFunctionFast(compare_function, base_address + new_lower * item_size + field_offset, base_address + centre_point * item_size + field_offset) 
            While (comparison < 0 And direction = 0) Or (comparison > 0 And direction<>0) 
                new_lower + 1 
                comparison = CallFunctionFast(compare_function, base_address + new_lower * item_size + field_offset, base_address + centre_point * item_size + field_offset) 
            Wend 
            
            comparison = CallFunctionFast(compare_function, base_address + new_higher * item_size + field_offset, base_address + centre_point * item_size + field_offset) 
            While (comparison > 0 And direction = 0) Or (comparison < 0 And direction<>0) 
                new_higher - 1 
                comparison = CallFunctionFast(compare_function, base_address + new_higher * item_size + field_offset, base_address + centre_point * item_size + field_offset) 
            Wend 

            If new_lower=new_higher 
                ; Move onto next items in array 
                new_lower + 1 
                new_higher - 1 
            ElseIf new_lower<new_higher 
                int_Sort_ExchangeData(base_address + new_lower * item_size, base_address + new_higher * item_size, item_size) 

                If centre_point=new_lower 
                    centre_point = new_higher 
                ElseIf centre_point=new_higher 
                    centre_point=new_lower 
                EndIf 

                new_lower + 1 
                new_higher - 1 
            EndIf 
        Until new_lower>new_higher 
    
        If start_index<new_higher 
            Sort_ArrayQuick(base_address, start_index, new_higher, item_size, compare_function, direction, field_offset) 
        EndIf 
        
        If new_lower<end_index 
            Sort_ArrayQuick(base_address, new_lower, end_index, item_size, compare_function, direction, field_offset) 
        EndIf 
    
    EndIf 
EndProcedure 


; Name:         Sort_ArrayQuickB 
; Synopsis:     Sort_ArrayQuickB(base_address, start_index, end_index, item_size, compare_function) 
; Parameters:   base_address.l      - Address of the start of the array 
;               start_index.l       - Index number of the first item to include in the sort 
;               end_index.l         - Index number of the last item to include in the sort 
;               item_size.l         - Size in bytes of each item in the array 
;               compare_function.l  - Address of a function which is used to compare the items in the array. 
;                                     This function must take two parameters, each one being pointers to items 
;                                     in the array. It must return a value to indicate their relationship 
;                                     in the following way: first < second ... negative value 
;                                                           first = second ... 0 
;                                                           first > second ... positive value 
;                                     See the default comparison functions for examples. 
; Returns:      Nothing 
; Globals:      None 
; Description:  Sorts the specified array (or the items between the start and end positions (inclusive)) 
;               using the quick sort algorithm. This is the stripped down and simplified version where 
;               the user will probably need to write their own compare function. 
Procedure Sort_ArrayQuickB(base_address.l, start_index.l, end_index.l, item_size.l, compare_function.l) 
    Define.l   new_lower 
    Define.l   new_higher 
    Define.l   centre_point 
    Define.l   comparison 
    
    If base_address And compare_function 
    
        new_lower = start_index 
        new_higher = end_index 
        centre_point = (start_index + end_index) / 2 
        
        Repeat 
            comparison = CallFunctionFast(compare_function, base_address + new_lower * item_size, base_address + centre_point * item_size) 
            While comparison < 0 
                new_lower + 1 
                comparison = CallFunctionFast(compare_function, base_address + new_lower * item_size, base_address + centre_point * item_size) 
            Wend 
            
            comparison = CallFunctionFast(compare_function, base_address + new_higher * item_size, base_address + centre_point * item_size) 
            While comparison > 0 
                new_higher - 1 
                comparison = CallFunctionFast(compare_function, base_address + new_higher * item_size, base_address + centre_point * item_size) 
            Wend 

            If new_lower=new_higher 
                ; Move onto next items in array 
                new_lower + 1 
                new_higher - 1 
            ElseIf new_lower<new_higher 
                int_Sort_ExchangeData(base_address + new_lower * item_size, base_address + new_higher * item_size, item_size) 

                If centre_point=new_lower 
                    centre_point = new_higher 
                ElseIf centre_point=new_higher 
                    centre_point=new_lower 
                EndIf 

                new_lower + 1 
                new_higher - 1 
            EndIf 
        Until new_lower>new_higher 
    
        If start_index<new_higher 
            Sort_ArrayQuickB(base_address, start_index, new_higher, item_size, compare_function) 
        EndIf 
        
        If new_lower<end_index 
            Sort_ArrayQuickB(base_address, new_lower, end_index, item_size, compare_function) 
        EndIf 
    
    EndIf 
EndProcedure 


; Name:         Sort_ListSelection 
; Synopsis:     Sort_ListSelection(base_address, *start_element, *end_element, item_size, compare_function, direction, field_offset) 
; Parameters:   base_address.l          - Not used 
;               *start_element.Element  - Address of earlier element in list to start sorting from. You must get this pointer using the '@list_name()' syntax 
;               *end_element.Element    - Address of last element in list to include in sort. You must get this pointer using the '@list_name()' syntax 
;               item_size.l             - Size of the user's data structure in each list element (i.e. this should not include the list structure for moving between elements) 
;               compare_function.l      - Address of a function which is used to compare the items in the array. 
;                                         This function must take two parameters, each one being pointers to the user's data in 
;                                         list elements. It must return a value to indicate their relationship 
;                                         in the following way: first < second ... negative value 
;                                                               first = second ... 0 
;                                                               first > second ... positive value 
;                                         See the default comparison functions for examples. 
;               direction.l             - Flag showing what direction to sort in. 0 means ascending, non-zero means descending. 
;               field_offset.l          - This value is added to the address of each list element before the comparison 
;                                         is called. This allows the user to sort structured lists on a field which is not 
;                                         at the start of a structure using the standard comparison procedures. 
; Returns:      Nothing 
; Globals:      None 
; Description:  Sorts a PureBasic linked list using the selection sort algorithm. Both the start and end elements are 
;               included in the sort. 
; 
;               Unfortunately, this procedure is slower than it needs to be because there seems to be no way to get access 
;               to the PureBasic list header structure. Therefore it would be impossible to swap pointers in the list items 
;               since there is no way to modify the pointers to the first and last elements in the list. Swapping the pointers 
;               would almost always be quicker than swapping the data in each element. 
Procedure Sort_ListSelection(base_address.l, *start_element.Element, *end_element.Element, item_size.l, compare_function.l, direction.l, field_offset.l) 
    Define.Element *current_position 
    Define.l       comparison 
    Define.Element *new_element        ; Pointer to new element to store as the current element 

    *start_element = *start_element - SizeOf(Element) 
    *start_element = *end_element - SizeOf(Element) 
        
    ; Make sure we have some valid inputs to the function 
    If compare_function And *start_element And *end_element 

        While *start_element<>*end_element 
        
            *new_element = *start_element 
            
            *current_position = *start_element 
            Repeat 
                *current_position = *current_position\Next 
                
                ; Check if we should use this current item as the new lower index 
                comparison = CallFunctionFast(compare_function, *new_element + SizeOf(Element) + field_offset, *current_position + SizeOf(Element) + field_offset) 
                If (comparison>0 And direction=0) Or (comparison<0 And direction<>0) 
                    *new_element = *current_position 
                EndIf 
            Until *current_position = *end_element 
        
            ; Perform the actual data swap for the item which should go earlier in the array 
            If *new_element<>*start_element 
                a.l = *new_element + SizeOf(Element) 
                b.l = *start_element + SizeOf(Element) 
                int_Sort_ExchangeData(a, b, item_size) 
            EndIf 

            ; Increase the start index value as we are sure that the smallest item is in there, 
            ; therefore we do not need to include it in the loop any more. 
            *start_element = *start_element\Next 
        Wend 
    
    EndIf 
EndProcedure 


; Name:         Sort_ListQuick 
; Synopsis:     Sort_ListQuick(base_address.l, *start_element, *end_element, item_size, compare_function, direction, field_offset) 
; Parameters:   base_address.l          - Address of the start of the array 
;               *start_element.Element  - Index number of the first item to include in the sort 
;               *end_element.Element    - Index number of the last item to include in the sort 
;               item_size.l             - Size in bytes of each item in the array 
;               compare_function.l      - Address of a function which is used to compare the items in the array. 
;                                         This function must take two parameters, each one being pointers to items 
;                                         in the array. It must return a value to indicate their relationship 
;                                         in the following way: first < second ... negative value 
;                                                               first = second ... 0 
;                                                               first > second ... positive value 
;                                         See the default comparison functions for examples. 
;               direction.l             - Flag showing what direction to sort in. 0 means ascending, non-zero means descending. 
;               field_offset.l          - This value is added to the address of each item in the array before the comparison 
;                                         is called. This allows the user to sort structured arrays on a field which is not 
;                                         at the start of a structure using the standard comparison procedures. 
; Returns:      Nothing 
; Globals:      None 
; Description:  Sorts the specified list (or the items between the start and end positions (inclusive)) 
;               using the quick sort algorithm. 
Procedure Sort_ListQuick(base_address.l, *start_element.Element, *end_element.Element, item_size.l, compare_function.l, direction.l, field_offset.l) 
    Define.Element *new_lower 
    Define.Element *new_higher 
    Define.Element *centre_point 
    Define.l       comparison 
    Define.l       done            ; Flag to show when pointers have passed each other in the list, representing the end of the sort 
    
    *start_element = *start_element - SizeOf(Element) 
    *end_element = *end_element - SizeOf(Element) 
    
    If compare_function And *start_element And *end_element And *start_element<>*end_element 
    
        *new_lower = *start_element 
        *centre_point = *start_element 
        *new_higher = *end_element 

        done = 0 
        Repeat 
            a.l = *new_lower + SizeOf(Element) + field_offset 
            b.l = *centre_point + SizeOf(Element) + field_offset 
            comparison = CallFunctionFast(compare_function, a, b) 
            While (comparison < 0 And direction = 0) Or (comparison > 0 And direction<>0) 
                If *new_lower=*new_higher 
                    done = 1 
                EndIf 

                *new_lower = *new_lower\Next 

                a.l = *new_lower + SizeOf(Element) + field_offset 
                b.l = *centre_point + SizeOf(Element) + field_offset 
                comparison = CallFunctionFast(compare_function, a, b) 
            Wend 
            
            a.l = *new_higher + SizeOf(Element) + field_offset 
            b.l = *centre_point + SizeOf(Element) + field_offset 
            comparison = CallFunctionFast(compare_function, a, b) 
            While (comparison > 0 And direction = 0) Or (comparison < 0 And direction<>0) 
                If *new_higher=*new_lower 
                    done = 1 
                EndIf 

                *new_higher = *new_higher\prev 

                a.l = *new_higher + SizeOf(Element) + field_offset 
                b.l = *centre_point + SizeOf(Element) + field_offset 
                comparison = CallFunctionFast(compare_function, a, b) 
            Wend 

            If *new_lower=*new_higher 
                *new_lower = *new_lower\Next 
                *new_higher = *new_higher\prev 
                done = 1 
            ElseIf done=0 
                a.l = *new_lower + SizeOf(Element) 
                b.l = *new_higher + SizeOf(Element) 
                int_Sort_ExchangeData(a, b, item_size) 

                ; Keep track of the centre point (we are really tracking the value it has) 
                ; and move onto next items in array 
                If *new_lower = *centre_point 
                    *centre_point = *new_higher 
                ElseIf *new_higher = *centre_point 
                    *centre_point = *new_lower 
                EndIf 

                If *new_lower=*end_element Or *new_higher=*start_element 
                    done = 1 
                Else 
                    *new_lower = *new_lower\Next 
                    *new_higher = *new_higher\prev 

                    ; Final check to see if pointers have passed 
                    If *new_lower\prev=*new_higher 
                        done = 1 
                    EndIf 
                EndIf 
            EndIf 
        Until done 
    
        If *start_element<>*new_higher And *start_element\prev<>*new_higher 
            a.l = *start_element + SizeOf(Element) 
            b.l = *new_higher + SizeOf(Element) 
            Sort_ListQuick(base_address, a, b, item_size, compare_function, direction, field_offset) 
        EndIf 
        
        If *new_lower<>*end_element And *new_lower<>*end_element\Next 
            a.l = *new_lower + SizeOf(Element) 
            b.l = *end_element + SizeOf(Element) 
            Sort_ListQuick(base_address, a, b, item_size, compare_function, direction, field_offset) 
        EndIf 
    
    EndIf 
EndProcedure 


; Name:         Sort_ListQuickB 
; Synopsis:     Sort_ListQuickB(*start_element, *end_element, item_size, compare_function) 
; Parameters:   *start_element.Element  - Index number of the first item to include in the sort 
;               *end_element.Element    - Index number of the last item to include in the sort 
;               item_size.l             - Size in bytes of each item in the array 
;               compare_function.l      - Address of a function which is used to compare the items in the array. 
;                                         This function must take two parameters, each one being pointers to items 
;                                         in the array. It must return a value to indicate their relationship 
;                                         in the following way: first < second ... negative value 
;                                                               first = second ... 0 
;                                                               first > second ... positive value 
;                                         See the default comparison functions for examples. 
; Returns:      Nothing 
; Globals:      None 
; Description:  Sorts the specified list (or the items between the start and end positions (inclusive)) 
;               using the quick sort algorithm. This is the stripped down and simplified version where 
;               the user will probably need to write their own compare function. 
Procedure Sort_ListQuickB(*start_element.Element, *end_element.Element, item_size.l, compare_function.l) 
    Define.Element *new_lower 
    Define.Element *new_higher 
    Define.Element *centre_point 
    Define.l       comparison 
    Define.l       done            ; Flag to show when pointers have passed each other in the list, representing the end of the sort 
    
    *start_element = *start_element - SizeOf(Element) 
    *end_element = *end_element - SizeOf(Element) 
    
    If compare_function And *start_element And *end_element And *start_element<>*end_element 
    
        *new_lower = *start_element 
        *centre_point = *start_element 
        *new_higher = *end_element 
        
        done = 0 
        Repeat 
            a.l = *new_lower + SizeOf(Element) 
            b.l = *centre_point + SizeOf(Element) 
            comparison = CallFunctionFast(compare_function, a, b) 
            While comparison < 0 
                If *new_lower=*new_higher 
                    done = 1 
                EndIf 

                *new_lower = *new_lower\Next 

                a.l = *new_lower + SizeOf(Element) 
                b.l = *centre_point + SizeOf(Element) 
                comparison = CallFunctionFast(compare_function, a, b) 
            Wend 
            
            a.l = *new_higher + SizeOf(Element) 
            b.l = *centre_point + SizeOf(Element) 
            comparison = CallFunctionFast(compare_function, a, b) 
            While comparison > 0 
                If *new_higher=*new_lower 
                    done = 1 
                EndIf 

                *new_higher = *new_higher\prev 

                a.l = *new_higher + SizeOf(Element) 
                b.l = *centre_point + SizeOf(Element) 
                comparison = CallFunctionFast(compare_function, a, b) 
            Wend 

            If *new_lower=*new_higher 
                *new_lower = *new_lower\Next 
                *new_higher = *new_higher\prev 
                done = 1 
            ElseIf done=0 
                a.l = *new_lower + SizeOf(Element) 
                b.l = *new_higher + SizeOf(Element) 
                int_Sort_ExchangeData(a, b, item_size) 

                ; Keep track of the centre point (we are really tracking the value it has) 
                ; and move onto next items in array 
                If *new_lower = *centre_point 
                    *centre_point = *new_higher 
                ElseIf *new_higher = *centre_point 
                    *centre_point = *new_lower 
                EndIf 

                If *new_lower=*end_element Or *new_higher=*start_element 
                    done = 1 
                Else 
                    *new_lower = *new_lower\Next 
                    *new_higher = *new_higher\prev 

                    ; Final check to see if pointers have passed 
                    If *new_lower\prev=*new_higher 
                        done = 1 
                    EndIf 
                EndIf 
            EndIf 
        Until done 
    
        If *start_element<>*new_higher And *start_element\prev<>*new_higher 
            a.l = *start_element + SizeOf(Element) 
            b.l = *new_higher + SizeOf(Element) 
            Sort_ListQuickB(a, b, item_size, compare_function) 
        EndIf 
        
        If *new_lower<>*end_element And *new_lower<>*end_element\Next 
            a.l = *new_lower + SizeOf(Element) 
            b.l = *end_element + SizeOf(Element) 
            Sort_ListQuickB(a, b, item_size, compare_function) 
        EndIf 
    
    EndIf 
EndProcedure 


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = ---
