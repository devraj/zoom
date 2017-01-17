hide menu main
hide popup all
@ 0,1 say"Credit Clearance" color r/w
define window cclr from 1,0 to 15,70 double shadow title" Credit Clearance "
move window cclr center
activate window cclr
do while .t.
 clear gets
 clear
 store 0 to word,ordr,npd,tool
 @ 1,3 say "Order Reference : "get ordr pict'99999999' valid ordsek(ordr,1)
 @ 1,34 say "Work Order number : "get word pict'99999999' valid ordsek(word,2)
 @ 3,3 say"Customers name : "
 @ 4,3 say"Catagory       : "
 @ 6,3 say"Total Amount : Rs."
 @ 7,3 say"Paid         : Rs."
 @ 8,3 say"Dues         : Rs."
 @ 8,36 say"Now paid : Rs."get npd pict'9999999.99' disabled
 @ 11,20 get tool function'*H Save;Cancel' size 1,10,8
 read cycle
 if tool=2 .or. tool=0
  close all
  clear window all
  do ctop in looks
  return .t.
  exit
 endif
 if tool=1
  use &data\counter shared order worder
  seek word
  if found()
   store worder to _word
   store ordref to _ordr
   store cust_name to _cnm
   store orddt to _ordate
   replace amt_due with amt_due-npd
   if amt_due=0
    replace creditcase with .f.
   else
    replace creditcase with .t.
   endif
   use &data\credit
   replace worder with _word
   replace ordref with _ordr
   replace cust_name with _cnm
   replace date with zoom_date
   replace amt_paid with npd
   replace order_date with _ordate
   use
  else
   do error with "The order pointer was not found","Contact the system administrator","Error"
  endif
 endif
enddo

proc ordsek
para _tmpord,_indon
if _tmpord=0
 return .t.
endif
use &data\counter shared
if _indon=1
 set order to ordref
else
 set order to worder
endif
seek _tmpord
if found()
 if creditcase=.f.
  use
  do error with "The requested order was found but it is not a credit case","this option is invalid for this order"," Error "
  return .f.
 endif
 @ 3,19 say cust_name
 store amt_due to npd
 store ordref to ordr
 store worder to word
 show get ordr disabled
 show get word disabled
 show get npd enabled
 @ 6,20 say amt_full-advance pict'9999999.99'
 @ 7,20 say amt_recd pict'9999999.99'
 @ 8,20 say amt_due pict'9999999.99'
 store cat_code to _tmpcat
 use &data\catagory shared order cat_code
 seek _tmpcat
 if found()
  @ 4,19 say cat_name
 else
  do error with "Catagory code is invalid","contact administrator","Error"
 endif
 close all
 return .t.
else
 use
 do error with "This order number is not available","on the databases","Error"
 return .t.
endif

