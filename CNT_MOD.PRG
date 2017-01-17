hide menu main
hide popup all
@ 0,1 say"Modify counter order" color r/w
define window selord from 1,0 to 7,70 double shadow title" Search "
move window selord center
define window mod from 1,0 to 19,70 double shadow title" Modify order "
move window mod center
do while .t.
 close all
 clear gets
 deacti window mod
 activate window selord
 store 0 to word,ord,tool
 @ 1,5 say"Order reference:"get ord pict'99999999'
 @ 1,37 say"Work Order:"get word pict'9999999999'
 @ 3,21 get tool function'*H Find;Cancel' size 1,10,6
 read cycle
 if tool=0 .or. tool=2
  close all
  clear window all
  do ctop in looks
  return .t.
  exit
 endif
 if tool=1
  deacti window selord
  use &data\counter shared 
  if ord>0
   set order to ordref
   seek ord
  else
   set order to worder
   seek word
  endif
  if found()
   if delivered=.t. 
    do error with "This order has already been delivered","you cannot make changes now !","Halted"
    loop
   endif
   store ordref to ord
   store cust_name to _cnm
   store worder to word
   store itemcode to _itcd
   store quantity to _qty
   store work_code1 to wk1
   store work_code2 to wk2
   store work_code3 to wk3
   store advance to adv
   store cat_code to _ccd
   store orddt to _ordt
   store recno() to _rec
   store produced to _prd
   ********* read catagory information
    use &data\catagory shared
    _recs=reccount()
    if _recs=0
     use
     do error with "No pricing catagories defiend","contact administrator","Error"
     return .t.
     exit
    endif
    dimen _cstarr(_recs,2)
    go top
    store 1 to cntr
    do while .not. eof()
     store cat_name to _cstarr(cntr,1)
     store cat_code to _cstarr(cntr,2)
     cntr=cntr+1
     skip
    enddo
    use
    for i=1 to _recs
     if _ccd=_cstarr(i,2)
      store i to catcd
      exit
     endif
    endfor
   *************** end read 
   use &data\counter shared
   goto _rec
   acti window mod
   ************** booking only
   @ 1,3 say "Order reference: "get ord pict'9999999'
   @ 1,30 say"Name:"get _cnm pict'@!'
   @ 4,3 say"Catagory:"
   @ 3,21 get catcd from _cstarr size 3,30 color scheme 11
   @ 7,3 to 11,65 color w/b
   @ 12,3 to 14,65 color w/b
   @ 7,4 say" Booking details " color w/b
   @ 12,4 say" Production details " color w/b
   @ 8,5 say"Item Code:"get _itcd pict'9999'
   @ 8,25 say"Quantity:"get _qty pict'9999'
   @ 8,42 say"Booking :"get _ordt pict'99/99/9999'
   @ 10,5 say"Work 1:"get wk1 pict'99' valid wrkchk(1,_cstarr(catcd,2))
   @ 10,17 say"Work 2:"get wk2 pict'99' valid wrkchk(2,_cstarr(catcd,2))
   @ 10,30 say "Work 3:"get wk3 pict'99' valid wrkchk(3,_cstarr(catcd,2))
   @ 10,42 say"Advance :"get adv pict'9999999.99'
   ************** production also
   if produced=.t.
    store work_qty1 to qt1
    store work_qty2 to qt2
    store work_qty3 to qt3
    store amt_full to _amt
    store unit_prc1 to prc1
    store unit_prc2 to prc2
    store unit_prc3 to prc3
    store produced to _prd
    @ 13,5 say"Qty1:"get qt1 pict'9999'
    @ 13,18 say"Qty2:"get qt2 pict'9999'
    @ 13,30 say"Qty3:"get qt3 pict'9999'
    @ 13,42 say"Total:"+str(_amt,10,2)
   endif
   close all
   @ 15,20 get tool function'*H Change;Cancel' size 1,12,6 when prcheck()
   read cycle
   if tool=0 .or. tool=2
    deacti window mod
    clear gets
    loop
   endif
   if tool=1
    use &data\counter shared
    set order to worder
    seek word
    replace ordref with ord
    replace cust_name with _cnm
    replace itemcode with _itcd
    replace quantity with _qty
    replace work_code1 with wk1
    replace work_code2 with wk2
    replace work_code3 with wk3
    replace advance with adv
    replace cat_code with _cstarr(catcd,2)
    replace orddt with _ordt
    if produced=.t.
     replace work_qty1 with qt1
 
     replace work_qty2 with qt2
     replace work_qty3 with qt3
     replace gamt with _amt
     replace amt_full with _amt
     replace amt_due with amt_full-advance
     replace unit_prc1 with prc1
     replace unit_prc2 with prc2
     replace unit_prc3 with prc3
    endif  
    close all
    deacti window mod
    loop
   endif
   ************** end prod.
  else
   do error with "The requested order was not found","please check and try again","Error"
   loop
  endif
 endif
enddo


********* work code check **************
proc wrkchk
parameter codeno,ccode
use &data\cprice shared
set order to wcode,ccode
if codeno=1
 if wk1=0
  use
  return .t.
 endif
 locate for cat_code=ccode .and. workcode=wk1
endif
if codeno=2
 if wk2=0
  use
  return .t.
 endif
 locate for cat_code=ccode .and. workcode=wk2
endif
if codeno=3
 if wk3=0
  use
  return .t.
 endif
 locate for cat_code=ccode .and. workcode=wk3
endif
if found()
 use
 return .t.
else
 use 
 do error with "Work Code "+str(codeno,1)+" is not valid for","this catagory","Error"
 return .f.
endif
return .t.


************* pricing 
************* proc subtotal
proc subtotal
parameter _wkcd,_qty,_code
if _wkcd=0
 return .t.
endif
use &data\cprice shared
set order to wcode,ccode
locate for cat_code=_cstarr(catcd,2) .and. workcode=_wkcd
if found()
 store price to _tmpprice
else
 do error with "The pricing details were not found","contact Administrator","Error"
 return .f.
endif
use
********* start intelli condition system plugin ***********
use &data\ccond shared order search
locate for cat_code=_cstarr(catcd,2) .and. work_code=_wkcd
if found()
 do while (cat_code=_cstarr(catcd,2) .and. work_code=_wkcd)
  store "" to exec_stat
  exec_stat="_tmpprice=iif("

  if variable="QUANTITY"
   exec_stat=exec_stat+"_qty"
   store .f. to addn
  endif
  if variable="DATE"
   exec_stat=exec_stat+"_ordt"
   store .f. to addn
  endif
  if variable="WCD1"
   exec_stat=exec_stat+"wk1"
   store .t. to addn
  endif
  if variable="WCD2"
   exec_stat=exec_stat+"wk2"
   store .t. to addn
  endif
  if variable="WCD3"
   exec_stat=exec_stat+"wk3"
   store .t. to addn
  endif

  if variable<>"WCD"
   exec_stat=exec_stat+rtrim(condition)
   if variable="DATE"
    exec_stat=exec_stat+"ctod('"+alltrim(dtoc(dat_value))+"')"
   endif
   if variable="QUANTITY"
    exec_stat=exec_stat+ltrim(str(num_value,10,2))
   endif
   if addn=.t.
    if variable="WCD1"
     exec_stat=exec_stat+" .and. qt1>0"
    endif
    if variable="WCD2"
     exec_stat=exec_stat+" .and. qt2>0"
    endif
    if variable="WCD3"
     exec_stat=exec_stat+" .and. qt3>0"
    endif
   endif
  else 
   ********** consider all workcodes
   if _code=1
    exec_stat=exec_stat+"((wk2="+ltrim(str(num_value,10))+" .and. qt2>0) .or. (wk3="+ltrim(str(num_value,10))+" .and. qt3>0))"
   endif
   if _code=2
    exec_stat=exec_stat+"((wk1="+ltrim(str(num_value,10))+" .and. qt1>0) .or. (wk3="+ltrim(str(num_value,10))+" .and. qt3>0))"
   endif
   if _code=3
    exec_stat=exec_stat+"((wk2="+ltrim(str(num_value,10))+" .and. qt2>0) .or. (wk1="+ltrim(str(num_value,10))+" .and. qt1>0))"
   endif
   *************
  endif
  exec_stat=exec_stat+",work_price,_tmpprice)"
  &exec_stat
  skip
 enddo
endif
*************** end intelli pulg ************
*************** parameter _wkcd,_qty,_code,_tmpprice
if _code=1
 store _tmpprice to prc1
endif
if _code=2
 store _tmpprice to prc2
endif
if _code=3
 store _tmpprice to prc3
endif
_amt=(qt1*prc1)+(qt2*prc2)+(qt3*prc3)
@ 13,42 say"Total:"+str(_amt,10,2)
return .t.

*************************
proc prcheck
if _prd=.f.
 return .t.
endif
********** for work code1
store wk1 to _wrkcd
store qt1 to _qtyit
do subtotal with _wrkcd,_qtyit,1
********** for work code2
store wk2 to _wrkcd
store qt2 to _qtyit
do subtotal with _wrkcd,_qtyit,2
********* for work code3
store wk3 to _wrkcd
store qt3 to _qtyit
do subtotal with _wrkcd,_qtyit,3
return .t.
