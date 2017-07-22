* counter order production system

hide menu main
hide popup all
@ 0,1 say"Counter order production" color r/w
define window cprod from 1,5 to 21,75 double shadow title" Counter Order Production "
move window cprod center
activate window cprod
do while .t.
 clear gets
 clear
 store 0 to word,ordr,catcd
 @ 1,3 say "Order Reference : "get ordr pict'99999999' valid ordsek(ordr,1)
 @ 1,34 say "Work Order number : "get word pict'99999999' valid ordsek(word,2)
 store 0 to wk1,wk2,wk3
 store 0 to qt1,qt2,qt3
 store 0 to prc1,prc2,prc3
 store 0 to toolbox,adv
 store ctod('  /  /    ') to _odt
 @ 3,1 to 7,67 color w/b
 @ 8,1 to 18,45 color w/b
 @ 4,3 say"Name     : "
 @ 5,3 say"Catagory : "
 @ 6,3 say"Booking date : "+space(12)+"Delivery Date :"+space(12)+"Qty:"
 @ 9,4 say"Work 1:"get wk1 pict'99' disabled valid wrkchk(1)
 @ 9,15 say"X Qty :"get qt1 pict'9999' disabled 
 @ 11,4 say"Work 2:"get wk2 pict'99' disabled valid wrkchk(2)
 @ 11,15 say"X Qty :"get qt2 pict'9999' disabled 
 @ 13,4 say"Work 3:"get wk3 pict'99' disabled valid wrkchk(3)
 @ 13,15 say"X Qty :"get qt3 pict'9999' disabled 
 @ 9,28 say"Rs."
 @ 11,28 say"Rs."
 @ 13,28 say"Rs."
 @ 15,28 say"Rs."
 @ 16,28 say"Rs."
 @ 17,28 say"Rs."
 @ 16,4 say"Advance :"
 @ 15,4 say"Total   :"
 @ 17,4 say"Due     :"
 @ 10,50 get toolbox function'*V Produced;Clear;Quit' size 1,12,2 when prcheck()
 read cycle
 if toolbox=0 .or. toolbox=3
  deacti window all
  clear window all
  clear gets 
  do ctop in looks
  return .t.
  exit
 endif
 if toolbox=2
  loop
 endif
 if toolbox=1
  use &data\counter shared order worder
  seek word
  if found()
   replace work_code1 with wk1
   replace work_code2 with wk2
   replace work_code3 with wk3
   replace work_qty1 with qt1
   replace work_qty2 with qt2
   replace work_qty3 with qt3
   replace unit_prc1 with prc1
   replace unit_prc2 with prc2
   replace unit_prc3 with prc3
   replace prod_date with zoom_date
   replace gamt with (qt1*prc1)+(qt2*prc2)+(qt3*prc3)
   replace amt_full with (qt1*prc1)+(qt2*prc2)+(qt3*prc3)
   replace amt_due with ((qt1*prc1)+(qt2*prc2)+(qt3*prc3))-adv
   replace produced with .t.
   use
   loop
  else
   do error with "The order could not be located on the databases","please contact the System Administrator","Error"
   loop
  endif
 endif
enddo

******* procedure to get the requested order *******
proc ordsek
parameter _tmpord,_indon
if _tmpord=0
 return .t.
endif
if _indon=1
 use &data\counter shared order ordref
else
 use &data\counter shared order worder
endif
seek _tmpord
if found()
 if produced=.t.
  use
  do error with "This order has already been produced","cannot contiune with this request","Error"
  return .f.
 endif
 ordr=ordref
 word=worder
 wk1=work_code1 
 wk2=work_code2
 wk3=work_code3
 qt1=work_qty1
 qt2=work_qty2
 qt3=work_qty3
 @ 6,18 say orddt color w+/b
 @ 6,46 say deldate color w+/b
 @ 6,61 say str(quantity,4) color w+/b
 @ 4,14 say cust_name color gr+/b
 @ 16,34 say str(advance,10,2) color gr+/b
 store advance to adv
 store cat_code to catcd
 show get ordr disabled
 show get word disabled
 show get wk1 enabled
 show get wk2 enabled
 show get wk3 enabled
 show get qt1 enabled
 show get qt2 enabled
 show get qt3 enabled
 store orddt to _odt
 use &data\catagory shared order cat_code
 seek catcd
 @ 5,14 say cat_name color w+/b
 use
 return .t.
else
 use
 do error with "The requested order was not found","please check order number","Error"
 return .t.
endif

********* work code check **************
proc wrkchk
parameter codeno
use &data\cprice shared
set order to wcode,ccode
if codeno=1
 if wk1=0
  use
  return .t.
 endif
 locate for cat_code=catcd .and. workcode=wk1
endif
if codeno=2
 if wk2=0
  use
  return .t.
 endif
 locate for cat_code=catcd .and. workcode=wk2
endif
if codeno=3
 if wk3=0
  use
  return .t.
 endif
 locate for cat_code=catcd .and. workcode=wk3
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

************* proc subtotal
proc subtotal
parameter _wkcd,_qty,_code
if _wkcd=0
 return .t.
endif
use &data\cprice shared
set order to wcode,ccode
locate for cat_code=catcd .and. workcode=_wkcd
if found()
 store price to _tmpprice
else
 do error with "The pricing details were not found","contact Administrator","Error"
 return .f.
endif
use
********* start intelli condition system plugin ***********
use &data\ccond shared order search
locate for cat_code=catcd .and. work_code=_wkcd
if found()
 do while (cat_code=catcd .and. work_code=_wkcd)
  store "" to exec_stat
  exec_stat="_tmpprice=iif("
  if variable="QUANTITY"
   exec_stat=exec_stat+"_qty"
   store .f. to addn
  endif
  if variable="DATE"
   exec_stat=exec_stat+"_odt"
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
** parameter _wkcd,_qty,_code,_tmpprice
if _code=1
 store _tmpprice to prc1
 @ 9,34 say str(_tmpprice*_qty,10,2)
endif
if _code=2
 store _tmpprice to prc2
 @ 11,34 say str(_tmpprice*_qty,10,2)
endif
if _code=3
 store _tmpprice to prc3
 @ 13,34 say str(_tmpprice*_qty,10,2)
endif
subtot=(qt1*prc1)+(qt2*prc2)+(qt3*prc3)
gtot=subtot-adv
@ 15,34 say subtot pict'9999999.99'
@ 17,34 say gtot pict'9999999.99'
return .t.

*************************
proc prcheck
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

