* procedure for adding conditions *
proc _add
set escape on
dimen con(7)
dimen fld(3)
store "None" to con(1) 
store "Greater than" to con(2)
store "Greater than or equal to" to con(3)
store "Equal to" to con(4)
store "Equal to or less than" to con(5)
store "Less than" to con(6)
store "Not equal to" to con(7)
store "None" to fld(1)
store "DATE" to fld(2)
store "QUANTITY" to fld(3)
store 1 to ch_opt1,ch_opt2,ch_fld2,cod_ch
store 2 to ch_fld1
store 0 to tool,price,val1,val2
store date() to dat1,dat2
define window ad_con from 1,5 to 19,75 double shadow title" Add a condition "
move window ad_con center
activate window ad_con
use &data\wrk_code shared
set order to code
@ 1,2 to 15,66 color w/b
@ 1,3 say" IF " color w/b
define popup scrollopts FROM 0,0 prompt field str(work_code,2)+" "+code_name MARGIN SCROLL COLOR SCHEME 11
@ 3,4 say "FOR ITEM :"
@ 2,17 GET cod_ch POPUP scrollopts SIZE 3, 33
@ 6,4 get ch_fld1 from fld size 3, 14 color scheme 8 valid check1()
@ 6,20 get ch_opt1 from con size 3, 30 color scheme 8
@ 7,55 get dat1 pict'99/99/9999'
@ 8,55 get val1 pict'99999.99' disabled
@ 10,4 get ch_fld2 from fld size 3, 14 color scheme 8 valid check2()
@ 10,20 get ch_opt2 from con size 3, 30 color scheme 8
@ 11,55 get dat2 pict'99/99/9999'
@ 12,55 get val2 pict'99999.99' disabled
@ 14,4 say"IF TRUE THEN SET VALUE OF PRICE TO "get price pict'99999.99'
read cycle

proc check1
if ch_fld1=2
 show get dat1 enabled
 show get val1 disabled
endif
if ch_fld1=3
 show get dat1 disabled
 show get val1 enabled
endif
return .t.

proc check2
if ch_fld2=2
 show get dat2 enabled
 show get val2 disabled
endif
if ch_fld2=3
 show get dat2 disabled
 show get val2 enabled
endif
return .t.
