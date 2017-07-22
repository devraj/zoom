hide menu main
hide popup all
@ 0,1 say"Counter order delivery" color r/w
define window del from 1,5 to 20,75 double shadow title" Counter order delivery "
move window del center
activate window del
do while .t.
 clear gets
 clear
 close all
 rele _payitms

 ** Modified by Devraj Mukherjee on 31st March 2003
 ** Reads TAXP from configuration file
 
 use zoom.cfg
 taxp = cntr_taxp
 icp = ic_p
 
 ** End MOD

 use &data\paytype shared
 dimen _payitms(reccount(),3)
 go top
 store 1 to cntr
 do while .not. eof()
  store pay_name to _payitms(cntr,1)
  store pay_code to _payitms(cntr,2)
  store creditcard to _payitms(cntr,3)
  cntr=cntr+1
  skip
 enddo
 close all
 store 0 to ordr,word
 store 0 to disp, _disamt
 taxamt=0
 store 0 to _oriamt,tot_amt, ic_amt
 store 0 to _oridue,due,adv
 store 0 to _ifkex,memno,amtre,dtool
 store 1 to _pbill,_payt
 store space(30) to rem
 @ 0,1 to 17,35 color w/b 
 @ 0,36 to 17,67 color w/b 
 @ 0,48 say" Delivery details " color w/b
 @ 0,2 say" Order details " color w/b
 @ 2,3 say "Order Reference   : "get ordr pict'9999999' valid getord(ordr,1)
 @ 4,3 say "Work Order number : "get word pict'99999999' valid getord(word,2)
 @ 14,17 get taxp pict'99.99' valid vtaxp()
 @ 7,3 say "Name :"
 @ 8,3 say "Catagory :"
 @ 10,3 say "Work 1 :      Quantity :"
 @ 11,3 say "Work 2 :      Quantity :"
 @ 12,3 say "Work 3 :      Quantity :"
**** change on 14 jul 2001
****
* @ 14,3 say"Total   : Rs."
 @ 13,3 say"Total   : Rs."
 @ 14,3 say"TAX     : @ "


 @ 15,3 say"Advance : Rs."
 @ 16,3 say"Due     : Rs."
 @ 2,38 get _ifkex function'*C KEX Member' size 1,15 disabled valid kex_mem(_ifkex)
 @ 4,38 say"Membership no. "get memno pict'9999' disabled valid memveri(memno)
 @ 7,38 say"Remarks : "get rem pict'@!' size 1,15 disabled
 @ 9,38 say"Amount Recd: Rs."get amtre pict'9999999.99' disabled valid amtcheck(amtre,due)
 @ 11,38 get _payt from _payitms size 3,28 color scheme 11 disabled
 @ 14,38 get _pbill function'*C Print bill' size 1,15 disabled
 @ 16,40 get dtool function'*H Deliver;Cancel' size 1,10,4
 read cycle
 if dtool=0 .or. dtool=2
  clear window all
  do ctop in looks
  close all
  return .t.
  exit
 endif
 if dtool=1

  ** Modified by Devraj Mukherjee on 31st March 2003
  ** Saves TAXP to configuration file
  
  use zoom.cfg
  replace cntr_taxp with taxp
  
  ** End MOD
  
  use &data\counter shared order worder
  seek word
  if found()
   replace delivered with .t.
    replace amt_due with tot_amt-adv+TAXAMT
    replace tax_per with taxp
    replace tax_amt with taxamt
    replace ntotal with tot_amt+taxamt-adv
    replace icamt with ic_amt
   if _ifkex=1
    replace amt_full with tot_amt
****
    replace amt_due with tot_amt-adv+TAXAMT
    replace tax_per with taxp
    replace tax_amt with taxamt
    replace ntotal with tot_amt+taxamt-adv
*****
    replace kex_member with .t.
    replace discount with .t.
    replace disc_per with disp
    replace kex_member with .t.
    replace kex_number with memno
   endif
   if amtre<due
    replace creditcase with .t.
*    replace amt_due with amt_due+taxamt-amtre
    replace amt_due with amt_full+taxamt-amtre
   else
    replace creditcase with .f.
   endif
   replace amt_recd with amtre
   replace delon with zoom_date
   replace remarks with rem
   replace pay_code with _payitms(_payt,2)
   use
   if _payitms(_payt,3)=.t.
    do ccdet with ordr,_payitms(_payt,2),_payitms(_payt,1)
   endif
   if _pbill=1
    do cntbill with word
   endif
   close all
   loop
  else
   use
   do error with "The order pointer has been deleted","contact Administrator","Error"
   loop
  endif
 endif
enddo


***************************************
proc getord
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
 if produced=.f.
  use
  do error with "This order has not been produced yet","cannot contiune with this request","Error"
  return .f.
 endif
 if delivered=.t.
  use
  do error with "This order has already been delivered","cannot continue with this request","Error"
  return .f.
 endif
 @ 7,10 say substr(cust_name,1,25)
 store ordref to ordr
 store worder to word
 show get ordr disabled
 show get word disabled
 store advance to adv
* store amt_full to tot_amt, _oriamt
**** change by sanjay on 10-10-2004
**** change for service tax on service part only
 store gamt to tot_amt, _oriamt
 if icp>0
 	ic_amt = round(tot_amt*icp/100,2)
 else
 	ic_amt = 0
 endif
* taxamt=round(tot_amt*taxp/100,2)
 taxamt=round((tot_amt-ic_amt)*taxp/100,2)
****
****
* store amt_full-advance to amtre
* store amt_full-advance+taxamt to amtre
 store tot_amt-advance+taxamt to amtre
 store amt_due+taxamt to _oridue,due
 show get amtre enabled
 show get _pbill enabled
 show get _ifkex enabled
 show get rem enabled
 show get _payt enabled
**************
* @ 14,17 say amt_full pict'9999999.99'
 @ 13,17 say tot_amt pict'9999999.99'
 @ 14,17 SAY taxp pict'99.99'
 @ 14,26 say taxamt pict'999999.99'
*********

 @ 15,17 say advance pict'9999999.99' color bg+/b
 @ 16,17 say amt_due+taxamt pict'9999999.99' color gr+/b
 @ 10,12 say work_code1 pict'99'
 @ 11,12 say work_code2 pict'99'
 @ 12,12 say work_code3 pict'99'
 @ 10,27 say work_qty1 pict'9999'
 @ 11,27 say work_qty2 pict'9999'
 @ 12,27 say work_qty3 pict'9999'
 store cat_code to _tmpcat
 use &data\catagory shared order cat_code
 seek _tmpcat
 if found()
  @ 8,13 say substr(cat_name,1,20)
 else
  do error with "Catagory information is invalid","contact administrator","Error"
 endif
 use
 return .t.
else
 use
 do error with "The requested order was not found","please check order number","Error"
 return .t.
endif



***************************************
proc vtaxp
*parameter _tmpord,_indon
if !empty(word)
	_tmpord = word
    _indon=2
else
	_tmpord = ordr
    _indon=1
endif
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
 if produced=.f.
  use
  do error with "This order has not been produced yet","cannot contiune with this request","Error"
  return .f.
 endif
 if delivered=.t.
  use
  do error with "This order has already been delivered","cannot continue with this request","Error"
  return .f.
 endif
 @ 7,10 say substr(cust_name,1,25)
 store ordref to ordr
 store worder to word
 show get ordr disabled
 show get word disabled
 store advance to adv
 store gamt to tot_amt, _oriamt
 tot_amt=tot_amt-_disamt
****** 10-10-2004
 if icp>0
 	ic_amt = round(tot_amt*icp/100,2)
 else
 	ic_amt = 0
 endif
 taxamt=round((tot_amt-ic_amt)*taxp/100,2)
****
* taxamt=round((tot_amt-ic_amt)*taxp/100,2)
* store amt_full-advance to amtre
 store tot_amt-advance+taxamt to amtre, due
* store amt_due+taxamt to _oridue,due
 show get amtre enabled
 show get _pbill enabled
 show get _ifkex enabled
 show get rem enabled
 show get _payt enabled
**************
* @ 14,17 say amt_full pict'9999999.99'
 @ 13,17 say tot_amt pict'9999999.99'
 @ 14,17 SAY taxp pict'99.99'
 @ 14,26 say taxamt pict'999999.99'
*********

 @ 15,17 say advance pict'9999999.99' color bg+/b
* @ 16,17 say amt_due+taxamt pict'9999999.99' color gr+/b
 @ 16,17 say due pict'9999999.99' color gr+/b
 @ 10,12 say work_code1 pict'99'
 @ 11,12 say work_code2 pict'99'
 @ 12,12 say work_code3 pict'99'
 @ 10,27 say work_qty1 pict'9999'
 @ 11,27 say work_qty2 pict'9999'
 @ 12,27 say work_qty3 pict'9999'
 store cat_code to _tmpcat
 use &data\catagory shared order cat_code
 seek _tmpcat
 if found()
  @ 8,13 say substr(cat_name,1,20)
 else
  do error with "Catagory information is invalid","contact administrator","Error"
 endif
 use
 return .t.
else
 use
 do error with "The requested order was not found","please check order number","Error"
 return .t.
endif


*************
proc kex_mem
para _tmpkex
if _tmpkex=1
 show get memno enabled
else
 show get memno disabled
 due=_oridue
 tot_amt=_oriamt
****** 10-10-2004
 if icp>0
 	ic_amt = round(tot_amt*icp/100,2)
 else
 	ic_amt = 0
 endif
 taxamt=round((tot_amt-ic_amt)*taxp/100,2)
****
* taxamt=round((tot_amt-ic_amt)*taxp/100,2)
 _disamt = 0
 @ 14,26 say taxamt pict'999999.99'
 @ 13,17 say tot_amt pict'9999999.99' color gr+/b
 @ 16,17 say tot_amt-adv+taxamt pict'9999999.99' color bg+/b
 store _oridue to amtre
 show get amtre
endif
return .t.

proc memveri
parameter _tmpmemno
use &data\kexmem
set order to mem_no
seek _tmpmemno
if found()
 @ 5,38 say "NAME:"+substr(mem_name,1,24) color w+/b+
 if doi>=zoom_date .and. doe<=zoom_date
  use
  do error with "This KEX membership has expired","","Error"
  _ifkex=0
  show get _ifkex enabled
  return .t.
 endif
 use
 do _kexamt
 return .t.
else
 define popup _tmp from 5,30 to 12,66 shadow title" Select member " prompt field str(mem_no,4)+" "+mem_name color scheme 11
 on selection popup _tmp deacti popup _tmp
 activate popup _tmp
 @ 5,38 say "NAME:"+substr(mem_name,1,24) color w+/b+
 memno=mem_no
 use
 show get memno 
 do _kexamt
 return .t.
endif

proc _kexamt
use &data\system shared
_disper=kex_dis
store kex_dis to disp
use
_disamt=(_disper*_oriamt)/100
tot_amt=_oriamt-_disamt
****** 10-10-2004
 if icp>0
 	ic_amt = round(tot_amt*icp/100,2)
 else
 	ic_amt = 0
 endif
 taxamt=round((tot_amt-ic_amt)*taxp/100,2)
****
*taxamt=round((tot_amt-ic_amt)*taxp/100,2)
@ 14,26 say taxamt pict'999999.99'

store tot_amt-adv+taxamt to amtre,due 
show get amtre
@ 13,17 say tot_amt pict'9999999.99' color gr+/b
*@ 16,17 say tot_amt-adv pict'9999999.99' color bg+/b
@ 16,17 say tot_amt-adv+taxamt pict'9999999.99' color bg+/b
return .t.

************** credit card process
proc ccdet
parameter _order,_pt,_cardname
define window ccd from 1,1 to 11,69 double shadow title" Credit Card Details "
move window ccd center
activate window ccd
use &data\counter shared order ordref
seek _order
store cust_name to name
store amt_full to amt
use
store space(20) to cdno
store 0 to tool
store ctod('  /  /    ') to dtexp
@ 1,2 say"Order number: "+str(_order,7)+space(5)+"Card: "+_cardname
@ 3,2 say"Holder name :" get name pict'@!'
@ 5,2 say"Card number :"get cdno
@ 5,38 say "Date of Expiry "get dtexp pict'99/99/9999'
@ 7,1 to 7,66 color w/b
@ 8,25 get tool function'*H Continue'
read cycle
use &data\cardet shared
append blank
replace holder_nm with name
replace card_no with cdno
replace valid_dt with dtexp
replace amt_total with amt
replace order_no with _order
replace pay_code with _pt
replace card_name with _cardname
replace order_date with zoom_date
use
deacti window ccd
return .t.

*************** proc print
proc cntbill
para _order
if sys(13)="OFFLINE"
 do error with "Your printer is not responding","please check","Error"
 close all
 return .t.
endif
use &data\counter shared order worder
seek _order
store recno() to _tmprec
*set printer to san. 
set device to printer
set printer on
set console off
store "-------------------------------------------------------------" to _lbreak
??CHR(15)
?space((len(_lbreak)-len(_head(1)))/2)+_head(1)
?space((len(_lbreak)-len(_head(2)))/2)+_head(2)
?space((len(_lbreak)-len(_head(3)))/2)+_head(3)
?space((len(_lbreak)-len(_head(4)))/2)+_head(4)
?_lbreak
?" Order number :"+str(ordref,7)+"  Date:"+dtoc(zoom_date)
?" To : "+cust_name
?_lbreak
?"Order description             | Unit Prc | Qty|   Total    |"
?_lbreak
******** gather the work names **********
store work_code1 to wk1
store work_code2 to wk2
store work_code3 to wk3
use &data\wrk_code shared order code
seek wk1
store code_name to work1
seek wk2
store code_name to work2
seek wk3
store code_name to work3
use &data\counter shared
goto _tmprec
************ back with the names ********
if work_code1<>0
 ?work1+ "|" + str(unit_prc1,10,2) +"|" + str(work_qty1,4) + "|"+ str(unit_prc1*work_qty1,10,2)
endif
if work_code2<>0
 ?work2+"|"+str(unit_prc2,10,2)+"|"+str(work_qty2,4)+"|"+str(unit_prc2*work_qty2,10,2)
endif
if work_code3<>0
 ?work3+"|"+str(unit_prc3,10,2)+"|"+str(work_qty3,4)+"|"+str(unit_prc3*work_qty3,10,2)
endif
?_lbreak
*?" Sub-Total Amount :                         Rs."+str(amt_full,10,2)
*?" Gross Total Amount :                       Rs."+str(gamt,10,2)
?"                          Gross Total Amt : Rs."+str(gamt,10,2)
_damt=0
if discount=.t.
 _damt=round(((disc_per*gamt)/100),2)
 ?" Kex Member Discount :" +str(disc_per,5,2)+ "%                Rs." +str(_damt,10,2)
 ?"                                            -------------"
 ?" Sub-Total Amount :                         Rs."+str(gamt-_damt,10,2)
endif

*?" Service TAX @ "+str(taxp,5,2)+"%                       Rs."+str(taxamt,10,2)
****** 10-10-2004
if icp>0
	_icline = 'IC      = '+str(ic_amt,11,2)
	_scline = 'Tax Amt.= '+str(tot_amt-ic_amt,11,2)
else
	_icline = space(21)
	_scline = space(21)
endif
*?" Service TAX                                Rs."+str(taxamt,10,2)
*?"                                            -------------"
? _icline+"     Service TAX       Rs."+str(taxamt,10,2)
? _scline+"                       -------------"
******
*?" Total Amount :                             Rs."+str(gamt-_damt+taxamt,10,2)
?"                          Total Amount :    Rs."+str(gamt-_damt+taxamt,10,2)
*if discount=.t.
* ?" Kex Member Discount :" +str(disc_per,5,2)+ "%                Rs." +str(((disc_per*amt_full)/100),10,2)
*endif
*?" Less Advance :                             Rs."+str(advance,10,2)
?"                          Less Advance :    Rs."+str(advance,10,2)
*?" Balance Paid :                             Rs."+str(amt_due,10,2)
?"                                            -------------"
if amtre<0
*?" Amount Refunded :                          Rs."+str(amtre,10,2)
?"                          Amount Refunded : Rs."+str(amtre,10,2)
else
*?" Balance Paid :                             Rs."+str(amtre,10,2)
?"                          Balance Paid :    Rs."+str(amtre,10,2)
endif
?"                                            ============="
?_lbreak
?"E. & O.E."
?""
?"                                                (Signature)"
?""
?space((len(_lbreak)-len(_foot(1)))/2)+_foot(1)
?space((len(_lbreak)-len(_foot(2)))/2)+_foot(2)
if month(zoom_date)>=12 .or. month(zoom_date)=01
 store "MERRY CHRITSMAS & A HAPPY NEW YEAR" TO GREET
 ?space((len(_lbreak)-len(GREET))/2)+GREET
endif
for i=1 to 8
 ??CHR(13)
 ?" "
endfor
??CHR(18)
??CHR(13)
close all
set printer off
*set printer to lpt1
set console on
set device to screen
return .t.

proc amtcheck
para _recd,_act
if _recd<_act
 do error with "The current order shall become a credit case","please check before delivering it"," Warning "
 return .t.
endif