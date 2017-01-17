hide menu main
hide popup all
@ 0,1 say"Edit an Agent order" color r/w
close all databases
set color to g+/b+,w+/bg+
define window agrem from 1,0 to 9,60 double shadow title" Search "
move window agrem center
define window mod from 1,0 to 16,70 double shadow title" Modify order "
move window mod center
do while .t.
 clear gets
 close all
 deacti window mod
 activate window agrem
 @ 0,2 to 5,30 color w/b
 @ 0,32 to 5,56 color w/b
 @ 0,3 say" Order Reference " color w/b
 @ 0,33 say" Work Order " color w/b
 store 0 to word,agn,ord,tool
 @ 2,4 say"Agent Code     :"get agn pict'9999' valid agn_cd(agn)
 @ 3,4 say"Order Reference:"get ord size 1,8,10
 @ 3,34 say"Work Order:"get word pict'99999999'
 @ 6,17 get tool function'*H Find;Cancel' size 1,10,4
 read cycle
 if tool=0 .or. tool=2
  clear window all
  close all
  do ctop in looks
  return .t.
  exit
 endif
 if tool=1 
  use &data\agnfile shared
  if ord>0
   set order to ordref
   locate for agent_code=agn .and. order_num=ord
  else
   set order to worder
   seek word
  endif
  if found()
   store workorder to word
   store order_num to ord
   store agent_code to agn
   store work_item to _itcd
   store work_qty to _qty
   store orderdate to _ordt
   store work1 to wk1
   store work2 to wk2
   store work3 to wk3
   store qty1 to qt1
   store qty2 to qt2
   store qty3 to qt3
   store billed to _bill
   store produced to _prd
   store total to _amt
   close all
   IF _BILL=.T.
    DO ERROR WITH "THIS ORDER HAS ALREADY BEEN BILLED","YOU CAN'T MAKE CHANGES NOW !","ERROR"
    LOOP
   ENDIF
   ********** EDITING STARTS *********
   store 0 to tool,prc1,prc2,prc3
   deacti window agrem
   activate window mod
   @ 1,3 say "Agent Code :"get agn pict'9999' valid agn_cd(agn)
   @ 1,23 say "Order reference: "get ord pict'9999999'
   @ 4,3 to 8,65 color w/b
   @ 9,3 to 11,65 color w/b
   @ 4,4 say" Booking details " color w/b
   @ 9,4 say" Production details " color w/b
   @ 5,5 say"Item Code:"get _itcd pict'9999'
   @ 5,25 say"Quantity:"get _qty pict'9999'
   @ 5,42 say"Booking :"get _ordt pict'99/99/9999'
   @ 7,5 say"Work 1:"get wk1 pict'99' valid wrkchk(1)
   @ 7,17 say"Work 2:"get wk2 pict'99' valid wrkchk(2)
   @ 7,30 say "Work 3:"get wk3 pict'99' valid wrkchk(3)
   ************** production also
   if _prd=.t.
    @ 10,5 say"Qty1:"get qt1 pict'9999'
    @ 10,18 say"Qty2:"get qt2 pict'9999'
    @ 10,30 say"Qty3:"get qt3 pict'9999'
    @ 10,42 say"Total:"+str(_amt,10,2)
   endif
   close all
   @ 12,20 get tool function'*H Change;Cancel' size 1,12,6 when prcheck()
   read cycle
   if tool=0 .or. tool=2
    loop
   endif
   if tool=1
    use &data\agnfile shared
    set order to worder
    seek word
    if found()
     replace order_num with ord
     replace agent_code with agn
     replace work_item with _itcd
     replace work_qty with _qty
     replace orderdate with _ordt
     replace work1 with wk1
     replace work2 with wk2
     replace work3 with wk3
     replace qty1 with qt1
     replace qty2 with qt2
     replace qty3 with qt3
     replace total with _amt   
     close all
     loop
    else
     close all
     do error with "THE ORDER POINTER HAS BEEN DELETED","CONTACT ADMINISTRATOR","ERROR"
    endif
   endif
   ********** EDITING ENDS   *********
  else
   do error with "The requested order was not found","on the agent databases","Oops"
  endif
 endif
enddo

************ AGENT CODE CHECK
proc wrkchk
parameter codeno
use &data\aprice shared
set order to wcode,acode
if codeno=1
 if wk1=0
  use
  return .t.
 endif
 locate for agn_code=agn .and. workcode=wk1
endif
if codeno=2
 if wk2=0
  use
  return .t.
 endif
 locate for agn_code=agn .and. workcode=wk2
endif
if codeno=3
 if wk3=0
  use
  return .t.
 endif
 locate for agn_code=agn .and. workcode=wk3
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

*********** pricing
************* proc subtotal
proc subtotal
parameter _wkcd,_qty,_code
store agn to agncd
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
endif
if _code=2
 store _tmpprice to prc2
endif
if _code=3
 store _tmpprice to prc3
endif
_amt=(qt1*prc1)+(qt2*prc2)+(qt3*prc3)
@ 10,42 say"Total:"+str(_amt,10,2)
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
 use
 return .t.
else
 define popup agn from 2,10 to 10,40 shadow title" Available agent codes " prompt field str(agn_code,4)+" "+agn_name
 on selection popup agn deacti popup agn
 activate popup agn
 agn=agn_code
 show get agn
 use
 return .t.
endif