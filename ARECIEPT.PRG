hide menu main
hide popup all
@ 0,1 say"Agent order reciept" color r/w
define window rcpt from 1,0 to 15,70 double shadow title" Agent order reciept "
move window rcpt center
activate window rcpt
store 0 to agn_cd
do while .t.
 clear gets
 clear
 store 0 to ordr,word,wrk3,tool
 store 1 to qty
 store 3536 to itcd
 store 10 to wrk1
 store 20 to wrk2
 @ 1,3 say"Agent Code      :"get agn_cd pict'9999' valid fndagn(agn_cd)
 @ 3,3 say"Order Reference :"get ordr pict'9999999' valid fndord(agn_cd,ordr)
 ***********
 @ 6,13 say"Item Code :"get itcd pict'9999' valid items(itcd)
 @ 6,39 say"Quantity :"get qty pict'9999' valid qty()
 @ 8,13 say"Work 1 :"get wrk1 pict'99' valid chkitms(wrk1)
 @ 8,28 say"Work 2 :"get wrk2 pict'99' valid chkitms(wrk2)
 @ 8,43 say"Work 3 :"get wrk3 pict'99' valid chkitms(wrk3)
 @ 5,11 to 9,56 color w/b
 @ 11,20 get tool function'*H Recieve;Cancel' size 1,10,8
 read cycle
 if tool=2 .or. tool=0
  close all
  clear window all
  do ctop in looks
  return .t.
  exit
 endif
 if tool=1
  if ordr=0
   do error with "Information on this order is not complete","Check the Order reference number","Error"
   loop
  endif
  use &data\agnfile shared
  append blank
  replace agent_code with agn_cd
  replace order_num with ordr
  replace workorder with word
  replace work_item with itcd
  replace work_qty with qty
  replace work1 with wrk1
  replace work2 with wrk2
  replace work3 with wrk3
  replace billed with .f.
  replace produced with .f.
  replace orderdate with zoom_date
  use &data\system shared
  replace agn_number with agn_number+1
  close all
 endif
enddo

proc fndagn
parameter _tmpagcd
if _tmpagcd=0
 return .t.
endif
use &data\agents shared order code
seek _tmpagcd
if .not. found()
 use
 do error with "This agent code is not valid","please correct it to continue","Error"
 return .f.
else
 @ 1,35 say"Agent : "+agn_name
 use
 return .t.
endif

proc fndord
parameter _tmpag,_tmpord
if _tmpag=0 .or. _tmpord=0
 return .t.
endif
use &data\agnfile shared 
set order to ordref
locate for agent_code=_tmpag .and. order_num=_tmpord
if found()
 use
 do error with "An order entry with the same order reference","was found for this agent, cannot re-register it","Error"
 return .f.
else
 use &data\system shared
 word=agn_number+1
 @ 3,35 say"Work Order number : "+str(word,8)
 return .t.
endif

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

proc qty
if qty<=0
 do error with "The quantity has to be atleast one","","Error"
 return .f.
endif
return .t.

proc chkitms
parameter _tmpcd
if _tmpcd=0
 return .t.
endif
use &data\wrk_code shared order code
seek _tmpcd
if .not. found()
 use
 do error with "This Item Code was not found","please check again","Error"
 return .f.
endif
close all
return .t.
