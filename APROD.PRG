* Agent order production system

hide menu main
hide popup all
@ 0,1 say"Agent order production" color r/w
define window cprod from 1,5 to 17,75 double shadow title" Agent Order Production "
move window cprod center
activate window cprod
store 0 to agncd
do while .t.
 clear gets
 clear
 store 0 to word,ordr
 @ 1,3 say "Agent Code      : "get agncd pict'9999' valid agn_cd(agncd)
 @ 3,3 say "Order Reference : "get ordr pict'99999999' valid ordsek(ordr,1,agncd)
 @ 3,34 say "Work Order number : "get word pict'99999999' valid ordsek(word,2,agncd)
 store 0 to wk1,wk2,wk3
 store 0 to qt1,qt2,qt3
 store 0 to prc1,prc2,prc3
 store 0 to toolbox,adv
 store ctod('  /  /    ') to _odt
 @ 5,1 to 14,45 color w/b
 @ 6,4 say"Work 1:"get wk1 pict'99' disabled valid wrkchk(1)
 @ 6,15 say"X Qty :"get qt1 pict'9999' disabled 
 @ 8,4 say"Work 2:"get wk2 pict'99' disabled valid wrkchk(2)
 @ 8,15 say"X Qty :"get qt2 pict'9999' disabled 
 @ 10,4 say"Work 3:"get wk3 pict'99' disabled valid wrkchk(3)
 @ 10,15 say"X Qty :"get qt3 pict'9999' disabled 
 @ 6,28 say"Rs."
 @ 8,28 say"Rs."
 @ 10,28 say"Rs."
 @ 12,28 say"Rs."
 @ 12,4 say"Total   :"
 @ 6,50 get toolbox function'*V Produced;Clear;Quit' size 1,12,2 when prcheck()
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
  use &data\agnfile shared order worder
  seek word
  if found()
   replace work1 with wk1
   replace work2 with wk2
   replace work3 with wk3
   replace qty1 with qt1
   replace qty2 with qt2
   replace qty3 with qt3
   replace proddate with zoom_date
   replace billed with .f.
   replace total with (qt1*prc1)+(qt2*prc2)+(qt3*prc3)
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
parameter _tmpord,_indon,_agcd
if _tmpord=0
 return .t.
endif
if _indon=1
 use &data\agnfile shared
 set order to ordref
 locate for agent_code=_agcd .and. order_num=_tmpord
else
 use &data\agnfile shared
 set order to worder
 seek _tmpord
endif
if found()
 if produced=.t.
  use
  do error with "This order has already been produced","cannot contiune with this request","Error"
  return .f.
 endif
 agncd=agent_code
 ordr=order_num
 word=workorder
 wk1=work1 
 wk2=work2
 wk3=work3
 qt1=qty1
 qt2=qty2
 qt3=qty3
 _odt=orderdate
 show get agncd disabled
 show get ordr disabled
 show get word disabled
 show get agn_cd disabled
 show get wk1 enabled
 show get wk2 enabled
 show get wk3 enabled
 show get qt1 enabled
 show get qt2 enabled
 show get qt3 enabled
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
use &data\aprice shared
set order to wcode,acode
if codeno=1
 if wk1=0
  use
  return .t.
 endif
 locate for agn_code=agncd .and. workcode=wk1
endif
if codeno=2
 if wk2=0
  use
  return .t.
 endif
 locate for agn_code=agncd .and. workcode=wk2
endif
if codeno=3
 if wk3=0
  use
  return .t.
 endif
 locate for agn_code=agncd .and. workcode=wk3
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
use &data\aprice shared
set order to wcode,acode
locate for agn_code=agncd .and. workcode=_wkcd
if found()
 store price to _tmpprice
else
 do error with "The pricing details were not found","contact Administrator","Error"
 return .f.
endif
use
********* start intelli condition system plugin ***********
use &data\acond shared order search
locate for agn_code=agncd .and. work_code=_wkcd
if found()
 do while (agn_code=agncd .and. work_code=_wkcd)
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
    exec_stat=exec_stat+"((wk2="+ltrim(str(num_value,10,2))+" .and. qt2>0) .or. (wk3="+ltrim(str(num_value,10,2))+" .and. qt3>0))"
   endif
   if _code=2
    exec_stat=exec_stat+"((wk1="+ltrim(str(num_value,10,2))+" .and. qt1>0) .or. (wk3="+ltrim(str(num_value,10,2))+" .and. qt3>0))"
   endif
   if _code=3
    exec_stat=exec_stat+"((wk2="+ltrim(str(num_value,10,2))+" .and. qt2>0) .or. (wk1="+ltrim(str(num_value,10,2))+" .and. qt1>0))"
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
 @ 6,34 say str(_tmpprice*_qty,10,2)
endif
if _code=2
 store _tmpprice to prc2
 @ 8,34 say str(_tmpprice*_qty,10,2)
endif
if _code=3
 store _tmpprice to prc3
 @ 10,34 say str(_tmpprice*_qty,10,2)
endif
subtot=(qt1*prc1)+(qt2*prc2)+(qt3*prc3)
@ 12,34 say subtot pict'9999999.99'
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


proc agn_cd
parameter _agcd
if _agcd=0
 return .t.
endif
use &data\agents shared order code
seek _agcd
if found()
 @ 1,34 say"Agent: "+rtrim(agn_name)
 use
 return .t.
else
 define popup agn from 4,10 to 10,40 shadow title" Available agent codes " prompt field str(agn_code,4)+" "+agn_name
 on selection popup agn deacti popup agn
 activate popup agn
 agn_cd=agn_code
 show get agn_cd 
 @ 1,34 say"Agent: "+rtrim(agn_name)
 use
 return .t.
endif