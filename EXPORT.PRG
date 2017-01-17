***
* Program to Change Data to CSV file format
* Copyright (c) 2000 OpenZoom.org
* Author: Devraj Mukherjee
***

hide menu main
hide popup all
set color to gr/w
@ 0,1 say"Export Data for the Web" color r/w
define window confirmation from 1,10 to 8,53 double shadow title" Confirm " color scheme 2
move window confirmation center
activate window confirmation
set color to r/w
@ 1,5 say"Ready to export data, abort now"
@ 2,5 say"by choosing 'No'"
@ 4,1 to 4,40 color n/w
store 0 to confirm
@ 5,23 get confirm function'*H Yes;No' size 1,8,2 COLOR ,,,,,w+/n,R/B,,r/w,W/B
read cycle
deacti window confirmation
set color to g+/b+,w+/bg+
if confirm=0 .or. confirm=2
 close all
 clear window all
 do ctop in looks
 return .t.
endif
if confirm=1
 define window web from 4,10 to 6,65 shadow
 move window web center
 activate window web
 set color to bg+/b+,w+/bg+
 @ 0,1 say repl("Û",2)
 do ex_codes
 @ 0,1 say repl("Û",12)
 do ex_items
 @ 0,1 say repl("Û",22)
 do ex_categ
 @ 0,1 say repl("Û",32)
 do ex_cntr
 @ 0,1 say repl("Û",42)
 do ex_order
 @ 0,1 say repl("Û",52)
 activate window confirmation
 set color to r/w
 @ 1,5 say"Data converted, do you wish to"
 @ 2,5 say"start uploading files now?"
 @ 4,1 to 4,40 color n/w
 store 0 to confirm
 @ 5,23 get confirm function'*H Yes;No' size 1,8,2 COLOR ,,,,,w+/n,R/B,,r/w,W/B
 read cycle
 deacti window confirmation  
 deacti window web
 if confirm=1
  save screen to _tempscreen
  set color to w+/n+
  clear
  run java XpressConsole
  set color to g+/b+
  restore screen from _tempscreen
 endif 
 close all
 clear window all
 do ctop in looks
 return .t.
endif


***
* Function to export data to CSV
***

function ex_codes
 select work_code,code_name,web_code,price from &data\wrk_codes, &data\cprice WHERE workcode=work_code AND cprice.cat_code=1 INTO CURSOR WORKCODE
 copy to &data\wrk_codes.csv fields work_code,code_name,web_code,price for code_name!="" delimited 
 close all
 
function ex_items
 use &data\wrk_items
 copy to &data\wrk_items.csv fields work_item,item_name for item_name!="" delimited
 use
  
function ex_categ
 use &data\webcat
 copy to &data\webcat.csv fields cat_code,cat_name delimited 
 use
 
function ex_cntr
 use &data\stk_itm
 copy to &data\counter.csv fields item_name,unit_price,web_code for counter=.t. delimited 
 use
 
function ex_order
 use &data\counter 
 copy to &data\order.csv fields ordref,cust_name,orddt,prod_date,itemcode,quantity,work_code1,work_qty1,unit_prc1,work_code2,work_qty2,unit_prc2,work_code3,work_qty3,unit_prc3,advance for delivered=.f. delimited
 use
 
***
* End of .prg file 
***