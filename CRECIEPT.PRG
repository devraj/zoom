hide menu main
hide popup all
@ 0,1 say"Counter reciving system" color r/w
define window main from 1,5 to 22,75 double shadow title" New order details "
activate window main
 store 0 to ordno, tool, work1, work2, work3, catcd, itcd, adv, catag
 store space(30) to cust_nm
 store 3536 to itcd
 store zoom_date to deldt
 store 1 to qty
 store 1 to catcd
 store 18 to deltime
 store 10 to work1
 store 20 to work2
do while .t.
 release _cstarr
 store 0 to word
 clear
 store .f. to _marker
 clear gets
 set color to g+/b+,w+/bg+
 use &data\catagory shared
 _recs=reccount()
 if _recs=0
  use
  do error with "No pricing catagories defiend","contact administrator","Error"
  deacti window all
  close all
  do ctop in looks
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
 set color to g+/b+,w+/bg+
 @ 1,2 say"Order reference : "get ordno pict'99999999' valid ordno()
 @ 3,2 say"Customer's Name : "get cust_nm pict'@!' valid name()
 @ 6,2 say"Pricing Catagory"
 @ 5,21 get catcd from _cstarr size 3,30 color scheme 11
 @ 9,2 to 17,65 color w/b
 @ 9,3 say" Order details " color w/b
 @ 11,5 say"Item Code :"get itcd pict'9999' when catagory() valid items(itcd)
 @ 11,23 say"Quantity :"get qty pict'9999' valid qty()
 @ 13,5 say"Work (1)  :"get work1 pict'99' valid workcd(1)
 @ 13,23 say"Work (2) :"get work2 pict'99' valid workcd(2)
 @ 13,41 say"Work (3) :"get work3 pict'99' valid workcd(3)
 @ 15,5 say"Delivery date :"get deldt pict'99/99/9999' valid deldate()
 @ 15,35 say"Advance : "get adv pict'9999999.99' valid advzero()
 @ 18,11 get tool function'*H Recieve;Clear;Quit' size 1,13,4
 read cycle
 if tool=3 .or. tool=0
  deacti window all
  clear window all
  close all
  do ctop in looks
  return .t.
  exit
 endif
 if tool=2
  store 0 to ordno, tool, work1, work2, work3, catcd, itcd, adv, catag
  store space(30) to cust_nm
  store 3536 to itcd
  store zoom_date to deldt
  store 1 to qty
  store 1 to catcd
  store 18 to deltime
  store 10 to work1
  store 20 to work2
  loop
 endif
 if tool=1 
  ***************** entry validation
  if ordno=0
   do error with "Order reference is invalid","","Error"
   loop
  endif
  if empty(cust_nm)
   do error with "Customer name is invalid","","Error"
   loop
  endif
  if qty<=0
   do error with "Quantity has to be atleast one","","Error"
   loop
  endif
  if deldt<zoom_date
   do error with "Delivery date has already passed","","Error"
   loop
  endif
  **************** validation ends
  use &data\system shared
  repl cnt_number with word

  use &data\counter shared
  append blank
  replace ordref with ordno
  replace worder with word
  replace orddt with zoom_date
  replace cust_name with cust_nm
  replace work_code1 with work1
  replace work_code2 with work2
  replace work_code3 with work3
  replace quantity with qty
  replace deldate with deldt
  replace advance with adv
  replace itemcode with itcd
  replace cat_code with catag
  use
  store 0 to ordno, tool, work1, work2, work3, catcd, itcd, adv, catag
  store space(30) to cust_nm
  store 3536 to itcd
  store zoom_date to deldt
  store 1 to qty
  store 1 to catcd
  store 18 to deltime
  store 10 to work1
  store 20 to work2
 endif
enddo

**************************
proc deldate
if deldt<zoom_date
 do error with "The delivery date is invalid","please check it again","Error"
 return .f.
endif
return .t.
**************************
proc advzero
if adv=0
 ??chr(7)
endif
return .t.
*************************
proc catagory
catag=_cstarr(catcd,2)
return .t.
************************
proc workcd
parameter codeno
use &data\cprice shared
set order to wcode,ccode
if codeno=1
 if work1=0
  use
  return .t.
 endif
 locate for cat_code=catag .and. workcode=work1
endif
if codeno=2
 if work2=0
  use
  return .t.
 endif
 locate for cat_code=catag .and. workcode=work2
endif
if codeno=3
 if work3=0
  use
  return .t.
 endif
 locate for cat_code=catag .and. workcode=work3
endif
if found()
 use
 return .t.
else
 use 
 do error with "Work Code "+str(codeno,1)+" is not valid for","this catagory","Error"
 return .f.
endif
***************************
proc ordno
use &data\counter shared
set order to ordref
seek ordno
if found()
 use
 do error with "This order no has already been registered","onto the databases","Error"
 return .f.
else
 use
 if ordno<>0 .and. _marker=.f.
  do _worder
 endif
 return .t.
endif
***************************
proc name
if empty(cust_nm)
 do error with "Customer name is invalid","","Error"
 return .f.
endif
return .t.
***************************
proc qty
if qty<=0 
 do error with "Quantity has to be atleast one","","Error"
 return .f.
endif
return .t.

************* proc for work order no
proc _worder
use &data\system shared
if word>9999999999
 do error with "The upper limit of the Work order number","has exceeded, contact for support"," Halted "
endif
word=cnt_number+1
use
@ 1,35 say"Work order no : "+str(word,10) color w+/b+
store .t. to _marker
return .t.

*********** proc for checking work item
proc items
parameter _tmpval
use &data\wrk_item shared order code
seek _tmpval
if .not. found()
 use
 do error with "The work item is not defined","contact administrator","Error"
 return .f.
endif
close all
return .t.